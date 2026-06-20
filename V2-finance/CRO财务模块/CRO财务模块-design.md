# CRO财务模块设计文档

> 版本：v2.0 | 日期：2026-06-22
> 独立库：finance.db | 零耦合原则：跨域数据走HTTP API
> 架构原则引用：《平台交互设计架构原则》—审批中心不拥有数据，只展示切片；三层入口架构；多层面管理权限梯度
> 配套文件：CRO财务模块-sql.md / CRO财务模块-api.md

---

## 一、概述

v2.0是对v1.0的全面架构升级。v1.0以"四模块"（收款/发票/结算/盈亏）组织，v2.0重新以"五线架构"（收入线/支出线/票据视图/汇总线/审计线）重构，核心变更：

| 变更项 | v1.0 | v2.0 |
|--------|------|------|
| 架构组织 | 4模块 | 5线 |
| 支出管理 | fin_cost_records独立成本表 | fin_payment_records统一支出流水（三类型不合并） |
| 发票管理 | 独立录入模块 | 票据视图（从收支流水提取，非独立录入） |
| 入口架构 | 综合管理+合同工作台嵌入 | 三层入口（提交层/监管层A/监管层B） |
| 审批集成 | 复用审批中心 | 提交层嵌入审批中心，按类型路由 |
| 借款管理 | 无 | LOAN类型：借款→还款→核销，不计P&L |
| 供应商付款 | 无 | VENDOR_PAYMENT类型：关联SMO/合作商/中心合同付款节点 |
| 单据转移 | 无 | 项目交接/人员离职时可转移，全部留痕 |
| 审计 | 7种问题类型（散落在代码中） | 审计线7种检测（fin_audit_alerts独立告警表） |

### 设计原则

1. **独立库零耦合**：finance.db独立，不共享其他库的表；跨域数据通过HTTP API获取
2. **5线架构**：收入线、支出线、票据视图、汇总线、审计线，各线职责清晰
3. **三层入口**：提交层（审批中心）→监管层A（项目运营）→监管层B（综合管理）
4. **审批中心不拥有数据**：业务数据归finance.db，审批中心只展示切片（引用《平台交互设计架构原则》§1）
5. **支出不合并**：报销/借款/供应商付款三种类型各自独立流程，统一存储于fin_payment_records
6. **发票不独立录入**：销项从fin_invoices提取，进项从fin_payment_records发票字段提取

---

## 二、5线架构总览

```
┌─────────────────────────────────────────────────────────────────────┐
│                        finance.db（独立库）                          │
│                                                                     │
│  ┌─── 收入线 ──────────────────────────────────────────────────┐    │
│  │  fin_collections（收款记录）──关联──→ fin_invoices（销项发票） │    │
│  │  申办方合同打款 → 收款确认 → 开具销项发票                       │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─── 支出线 ──────────────────────────────────────────────────┐    │
│  │  fin_payment_records（统一支出流水）                          │    │
│  │  ├── EXPENSE 日常报销（双轨预算：项目/部门，有票才报）         │    │
│  │  ├── LOAN 员工借款（借款→还款→核销，不计P&L）                │    │
│  │  └── VENDOR_PAYMENT 供应商付款（关联合同付款节点，可先付后票） │    │
│  │  fin_loan_repayments（借款还款记录）                          │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─── 票据视图（提取非录入）──────────────────────────────────┐    │
│  │  销项 ← fin_invoices（跟收款走）                              │    │
│  │  进项 ← fin_payment_records.invoice字段（跟支出走）           │    │
│  │  待补票 ← fin_payment_records WHERE invoice_status=PENDING_INVOICE │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─── 汇总线 ─────────────────────────────────────────────────┐    │
│  │  fin_settlements（合同级收支对账）                            │    │
│  │  fin_project_pl（项目级盈亏分析）                             │    │
│  │  P&L规则：LOAN不计入 / 部门预算EXPENSE不计入项目P&L           │    │
│  │  P&L计入：项目预算EXPENSE + VENDOR_PAYMENT                    │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─── 审计线 ─────────────────────────────────────────────────┐    │
│  │  fin_audit_alerts（审计告警）— 7种检测                        │    │
│  │  收款超额 / 开票超额 / 超预算 / 逾期收款 /                    │    │
│  │  借款逾期 / 待补票逾期 / 结算差异                              │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─── 管理辅助 ───────────────────────────────────────────────┐    │
│  │  fin_transfer_logs（单据转移日志）                            │    │
│  └─────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
        │                                          │
        ▼                                          ▼
  审批中心（切片展示）                      Contract/Budget/SMO/中心管理（API只读）
  提交层入口                                跨域数据获取
```

### 5线职责对照

| 线 | 核心表 | 职责 | 数据来源 |
|----|--------|------|----------|
| 收入线 | fin_collections, fin_invoices | 收款记录与销项发票管理 | 申办方合同打款 |
| 支出线 | fin_payment_records, fin_loan_repayments | 统一支出流水（三类型） | 员工提交/供应商合同 |
| 票据视图 | （从收支表提取） | 销项+进项+待补票视图 | 被动提取，非独立录入 |
| 汇总线 | fin_settlements, fin_project_pl | 合同级对账+项目级盈亏 | 从收入线+支出线汇总 |
| 审计线 | fin_audit_alerts | 7种异常检测与告警 | 从各表扫描检测 |

---

## 三、三层入口架构详解

> 引用《平台交互设计架构原则》§2 — 所有涉及审批的业务模块，统一采用三层入口

### 3.1 架构总览

| 层 | 入口位置 | 面向角色 | 能做什么 | 不能做什么 |
|---|---|---|---|---|
| **提交层** | 审批中心→财务/借款/报销 | 所有员工 | 选类型→填表单→附材料→提交 | 不能在项目运营/综合管理中新建 |
| **监管层A** | 项目运营→财务Tab | PM/中心负责人 | 查看本项目全部记录（含前任和离职人员的），只读+管理，可做单据转移 | 不能创建新记录 |
| **监管层B** | 综合管理→财务管理 | 财务/综合管理人员 | 全部记录的增删改查、审批、确认、补票、结算、转移 | — |

### 3.2 提交层（审批中心内）

**定位**：员工最快捷的操作入口。信息完整全面 + 界面简洁干净 + 操作快捷舒服。

**通用头部**：支出类型切换（日常报销/员工借款/供应商付款），切换后下方字段动态变化，不展示无关项。

#### 3.2.1 日常报销（EXPENSE）表单字段

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| 项目选择 | 下拉选择 | 否 | 选了→budget_source=PROJECT走项目预算；不选→budget_source=DEPARTMENT走部门预算 |
| 部门选择 | 下拉选择 | 是（不选项目时） | 不选项目时必填，用于部门预算归属 |
| 费用类型 | 下拉选择 | 是 | TRAVEL/OFFICE/TRIAL/MEAL/COMMUNICATION/TRANSPORT/OTHER |
| 金额 | 数字 | 是 | 报销金额 |
| 事由说明 | 文本域 | 是 | 费用事由描述 |
| 是否有发票 | 开关 | 是 | 有票才报，必须为"是" |
| 发票号 | 文本 | 是（有发票时） | 发票号码 |
| 不含税金额 | 数字 | 是（有发票时） | 发票不含税金额 |
| 税率 | 下拉选择 | 是（有发票时） | 0.06/0.13/0.00 |
| 税额 | 自动计算 | — | =不含税金额×税率 |
| 价税合计 | 自动计算 | — | =不含税金额+税额 |
| 开票日期 | 日期 | 是（有发票时） | 发票开票日期 |
| 发票附件 | 文件上传 | 是（有发票时） | 发票图片/PDF |

**关键规则**：有票才报。has_invoice=1, invoice_status=ATTACHED。双轨预算——选项目走项目预算（计入项目P&L），不选项目走部门预算（不计入项目P&L）。

#### 3.2.2 员工借款（LOAN）表单字段

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| 部门选择 | 下拉选择 | 是 | 借款人所属部门 |
| 借款类型 | 下拉选择 | 是 | CASH_ADVANCE/PROJECT_ADVANCE/TRAVEL_ADVANCE |
| 借款金额 | 数字 | 是 | 借款金额 |
| 事由 | 文本域 | 是 | 借款事由 |
| 预计还款日期 | 日期 | 是 | 预计还款时间，用于逾期检测 |
| 项目选择 | 下拉选择 | 否 | 关联项目（可选，用于项目维度查询） |

**关键规则**：借款不计入P&L成本。借款→还款→核销全流程管理。

#### 3.2.3 供应商付款（VENDOR_PAYMENT）表单字段

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| 项目选择 | 下拉选择 | 是 | 必选，供应商付款必须关联项目 |
| 业务来源 | 下拉选择 | 是 | SMO合同/PARTNER合作商合同/CENTER中心合同 |
| 合同选择 | 下拉选择 | 是 | 选择对应业务来源的合同，自动带出合同信息 |
| 付款节点 | 下拉选择 | 是 | 选择合同付款节点，自动带出计划金额 |
| 计划金额 | 只读 | — | 从付款节点带出 |
| 实际付款金额 | 数字 | 是 | 实际付款金额 |
| 费用类型 | 下拉选择 | 是 | SMO_FEE/PARTNER_FEE/CENTER_FEE/REAGENT/EQUIPMENT/OTHER_PROCUREMENT |
| 事由 | 文本域 | 是 | 付款事由 |
| 是否有发票 | 开关 | 是 | 有→填发票信息 / 无→标记待补票 |
| 发票号 | 文本 | 否（有发票时必填） | — |
| 不含税金额 | 数字 | 否（有发票时必填） | — |
| 税率 | 下拉选择 | 否（有发票时必填） | — |
| 税额 | 自动计算 | — | — |
| 价税合计 | 自动计算 | — | — |
| 开票日期 | 日期 | 否（有发票时必填） | — |
| 发票附件 | 文件上传 | 否（有发票时必填） | — |

**关键规则**：可先付后票。无发票时invoice_status=PENDING_INVOICE，触发还票提醒。source_module+source_contract_id+source_payment_node_id关联业务合同及付款节点。

### 3.3 监管层A（项目运营→财务Tab）

**定位**：PM/中心负责人的监管视角。

**核心特征**：
- 以project_code为锚点查询本项目全部财务记录，不受"是谁提的"限制
- 包含前任PM经手的、离职员工提交的、其他部门关联本项目的费用
- 只读+管理：可查看、筛选、统计、管理已有单据，可做单据转移
- **不提供"新建"入口**——创建统一走审批中心

**PM可见性对照**（引用架构原则§2.4）：

| 场景 | 审批中心能看到 | 项目运营能看到 |
|------|---------------|---------------|
| 在任PM自己提的 | ✅ 自己的切片 | ✅ 本项目全部 |
| 前任PM提的（已交接） | ❌ | ✅ 本项目全部 |
| 离职员工提的 | ❌ | ✅ 本项目全部 |
| 其他部门提的关联费用 | ❌ | ✅ 本项目全部 |

### 3.4 监管层B（综合管理→财务管理）

**定位**：财务/综合管理人员的全局视角，全权限操作。

**能力**：全平台所有收支记录的增删改查、审批、确认、补票、结算、单据转移。按5线分Tab展示：收款管理/支出管理/票据视图/结算盈亏/审计告警。

---

## 四、fin_payment_records完整字段定义

fin_payment_records是支出线的核心表，统一存储三种支出类型，按字段组分类：

### 4.1 基础组

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTOINCREMENT | 自增主键 |
| payment_code | VARCHAR(32) | NOT NULL UNIQUE | 支出编号，格式 PAY-YYYYMMDD-NNN |
| payment_type | VARCHAR(20) | NOT NULL | 支出类型：EXPENSE/LOAN/VENDOR_PAYMENT |
| cost_type | VARCHAR(30) | NOT NULL | 费用类型（见§5枚举表） |
| amount | DECIMAL(14,2) | NOT NULL | 金额 |
| description | TEXT | | 描述/事由 |
| status | VARCHAR(20) | NOT NULL DEFAULT 'DRAFT' | DRAFT/PENDING_APPROVAL/APPROVED/PAID/CLOSED/REJECTED |

### 4.2 预算归属组

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| project_code | VARCHAR(32) | NULLABLE | 项目编号（EXPENSE可选/LOAN可选/VENDOR_PAYMENT必填） |
| budget_source | VARCHAR(20) | NOT NULL | 预算来源：PROJECT/DEPARTMENT |
| department_id | VARCHAR(64) | NULLABLE | 部门ID（budget_source=DEPARTMENT时必填） |

### 4.3 业务关联组

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| source_module | VARCHAR(20) | NULLABLE | 业务来源：SMO/PARTNER/CENTER（仅VENDOR_PAYMENT） |
| source_contract_id | VARCHAR(64) | NULLABLE | 来源合同ID（引用SMO/合作商/中心管理合同） |
| source_payment_node_id | VARCHAR(64) | NULLABLE | 来源付款节点ID |

### 4.4 借款专用组

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| loan_id | VARCHAR(32) | NULLABLE | 借款编号（LOAN类型专用，自引用payment_code） |
| repayment_date | DATE | NULLABLE | 预计还款日期（LOAN专用） |
| repaid_amount | DECIMAL(14,2) | DEFAULT 0 | 已还金额 |
| repayment_status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING/PARTIAL/SETTLED |

### 4.5 发票嵌入组

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| has_invoice | INTEGER | NOT NULL DEFAULT 0 | 是否有发票：0无/1有 |
| invoice_status | VARCHAR(20) | NOT NULL DEFAULT 'PENDING_INVOICE' | ATTACHED/PENDING_INVOICE/RECONCILED |
| invoice_no | VARCHAR(64) | NULLABLE | 发票号 |
| invoice_amount_excl_tax | DECIMAL(14,2) | NULLABLE | 不含税金额 |
| invoice_tax_rate | DECIMAL(5,4) | NULLABLE | 税率 |
| invoice_amount_tax | DECIMAL(14,2) | NULLABLE | 税额 |
| invoice_date | DATE | NULLABLE | 开票日期 |
| invoice_attachment | VARCHAR(256) | NULLABLE | 发票附件URL |

### 4.6 审批组

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| approval_status | VARCHAR(20) | | 审批状态：PENDING/APPROVED/REJECTED |
| approved_by | VARCHAR(64) | | 审批人 |
| approved_at | DATETIME | | 审批时间 |
| approval_remark | TEXT | | 审批备注 |

### 4.7 通用组

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| created_by | VARCHAR(64) | | 创建人（提交人） |
| created_at | DATETIME | NOT NULL DEFAULT now | 创建时间 |
| updated_at | DATETIME | NOT NULL DEFAULT now | 更新时间 |
| transferred_to | VARCHAR(64) | NULLABLE | 转移目标人（单据转移后） |
| transferred_at | DATETIME | NULLABLE | 转移时间 |

---

## 五、cost_type枚举表

| payment_type | cost_type | 中文名 | 说明 |
|--------------|-----------|--------|------|
| EXPENSE | TRAVEL | 差旅费 | 出差交通、住宿等 |
| EXPENSE | OFFICE | 办公费 | 办公用品、耗材等 |
| EXPENSE | TRIAL | 试验费 | 临床试验相关费用 |
| EXPENSE | MEAL | 餐饮费 | 业务招待、工作餐等 |
| EXPENSE | COMMUNICATION | 通讯费 | 话费、网络费等 |
| EXPENSE | TRANSPORT | 交通费 | 市内交通等 |
| EXPENSE | OTHER | 其他 | 其他日常报销 |
| LOAN | CASH_ADVANCE | 备用金借款 | 日常备用金 |
| LOAN | PROJECT_ADVANCE | 项目借款 | 项目预支款项 |
| LOAN | TRAVEL_ADVANCE | 差旅借款 | 出差预借款 |
| VENDOR_PAYMENT | SMO_FEE | SMO服务费 | SMO合同付款 |
| VENDOR_PAYMENT | PARTNER_FEE | 合作商服务费 | 合作商合同付款 |
| VENDOR_PAYMENT | CENTER_FEE | 中心费用 | 研究中心付款 |
| VENDOR_PAYMENT | REAGENT | 试剂采购 | 试验试剂采购付款 |
| VENDOR_PAYMENT | EQUIPMENT | 设备采购 | 设备采购付款 |
| VENDOR_PAYMENT | OTHER_PROCUREMENT | 其他采购 | 其他采购付款 |

---

## 六、三种支出类型业务流程

### 6.1 EXPENSE 日常报销

```
DRAFT（草稿）
  │ 员工提交（有票才报）
  ▼
PENDING_APPROVAL（待审批）
  │ 审批金额分级路由：
  │   ≤5万 → 部门经理→财务确认（直接APPROVED）
  │   5-50万 → 部门经理→财务总监
  │   >50万 → 部门经理→财务总监→CFO
  ├── 审批通过 → APPROVED
  │     │ 财务付款
  │     ▼
  │   PAID（已付款）
  │     │ 单据关闭
  │     ▼
  │   CLOSED（已关闭）
  │
  └── 审批驳回 → REJECTED
        │ 员工可修改后重新提交
        ▼
      DRAFT（回到草稿）
```

**双轨预算规则**：
- 选了项目（project_code非空）→ budget_source=PROJECT → 走项目预算 → **计入项目P&L**
- 不选项目（project_code为空）→ budget_source=DEPARTMENT → 走部门预算 → **不计入项目P&L**

### 6.2 LOAN 员工借款

```
DRAFT（草稿）
  │ 员工提交借款申请
  ▼
PENDING_APPROVAL（待审批）
  │ 部门经理→财务总监
  ├── 审批通过 → APPROVED
  │     │ 财务打款
  │     ▼
  │   PAID（已打款）  repayment_status=PENDING
  │     │ 员工还款（可分多次，记入fin_loan_repayments）
  │     │   部分还款 → repayment_status=PARTIAL
  │     │   全部还清 → repayment_status=SETTLED
  │     ▼
  │   CLOSED（已核销）  ← repayment_status=SETTLED时自动关闭
  │
  └── 审批驳回 → REJECTED
```

**关键规则**：
- LOAN不计入P&L成本（total_cost不含LOAN类型）
- 借款逾期检测：repayment_date过当前日期且repayment_status≠SETTLED → 触发审计告警
- 还款记录存储在fin_loan_repayments表

### 6.3 VENDOR_PAYMENT 供应商付款

```
DRAFT（草稿）
  │ 员工提交（选项目→选业务来源→选合同→选付款节点）
  │ 有发票 → invoice_status=ATTACHED
  │ 无发票 → invoice_status=PENDING_INVOICE
  ▼
PENDING_APPROVAL（待审批）
  │ 部门经理→财务总监（>50万加CFO）
  ├── 审批通过 → APPROVED
  │     │ 财务付款
  │     ▼
  │   PAID（已付款）
  │     │
  │     ├── 有发票（ATTACHED）→ 直接CLOSED
  │     │
  │     └── 无发票（PENDING_INVOICE）→ 待补票提醒
  │           │ 超30天未补票 → 逾期告警
  │           │ 补票后 → invoice_status=RECONCILED
  │           ▼
  │         CLOSED（已关闭）
  │
  └── 审批驳回 → REJECTED
```

**关键规则**：
- VENDOR_PAYMENT必须选项目（project_code必填）
- 通过source_module+source_contract_id+source_payment_node_id关联SMO/合作商/中心管理合同及付款节点
- 可先付后票：付款时无发票→PENDING_INVOICE→还票提醒→补票→RECONCILED→CLOSED
- **计入项目P&L**

---

## 七、还票提醒机制

供应商付款支持"先付后票"模式，发票状态流转：

```
付款时无发票
  │
  ▼
PENDING_INVOICE（待补票）
  │ 付款日期 + 30天
  ├── 未补票 → 逾期 → 触发审计告警（待补票逾期检测）
  │
  └── 补票（填写发票信息）
        │
        ▼
      RECONCILED（已核销）
        │ 单据关闭
        ▼
      CLOSED
```

**提醒逻辑**：
1. 付款时has_invoice=0 → invoice_status=PENDING_INVOICE
2. 系统每日扫描PENDING_INVOICE记录，计算 `当前日期 - PAID日期`
3. 0-30天：正常待补票，列表中标黄提醒
4. >30天：逾期，写入fin_audit_alerts（alert_type=PENDING_INVOICE_OVERDUE）
5. 补票后invoice_status→RECONCILED，告警自动消除
6. 单据状态→CLOSED

**补票操作入口**：监管层B（综合管理→财务管理→支出管理），财务人员填写发票信息并上传附件。

---

## 八、审批金额分级表

| 金额范围 | 审批流 | 审批模板编码 | 适用类型 |
|----------|--------|-------------|----------|
| ≤5万 | 部门经理 → 财务确认 | finance_expense_le5k | EXPENSE |
| 5万-50万 | 部门经理 → 财务总监 | finance_expense_5k_50k | EXPENSE |
| >50万 | 部门经理 → 财务总监 → CFO | finance_expense_gt50k | EXPENSE |
| 任意金额 | 部门经理 → 财务总监 | finance_loan | LOAN |
| ≤5万 | 部门经理 → 财务确认 | finance_vendor_le5k | VENDOR_PAYMENT |
| 5万-50万 | 部门经理 → 财务总监 | finance_vendor_5k_50k | VENDOR_PAYMENT |
| >50万 | 部门经理 → 财务总监 → CFO | finance_vendor_gt50k | VENDOR_PAYMENT |
| 任意金额 | 财务专员 → 财务总监 | finance_collection_confirm | 收款确认 |
| 任意金额 | 财务专员 → 财务总监 | finance_invoice_issue | 开票申请 |
| 任意金额 | 财务总监 | finance_settlement_confirm | 结算确认 |

> 审批模板在审批中心统一配置，业务模块通过flow_code引用。

---

## 九、票据视图提取逻辑

票据视图不做独立录入，从收支流水被动提取：

### 9.1 销项发票（收入线）

**来源**：fin_invoices表（跟收款走）

**提取逻辑**：
```sql
SELECT invoice_no, tax_invoice_no, contract_id, project_code,
       collection_id, invoice_type, invoice_status,
       amount, tax_rate, tax_amount, total_amount,
       buyer_name, buyer_tax_no, invoice_date
FROM fin_invoices
WHERE invoice_status IN ('ISSUED', 'REVERSED')
```

**定位**：销项发票专用表，记录CRO向申办方开具的发票。一张发票关联一次收款（collection_id），也可预开票（collection_id为空）。

### 9.2 进项发票（支出线）

**来源**：fin_payment_records发票嵌入字段

**提取逻辑**：
```sql
SELECT payment_code, payment_type, cost_type, project_code,
       invoice_no, invoice_amount_excl_tax, invoice_tax_rate,
       invoice_amount_tax, (invoice_amount_excl_tax + invoice_amount_tax) AS total,
       invoice_date, invoice_attachment, invoice_status
FROM fin_payment_records
WHERE has_invoice = 1
  AND invoice_status IN ('ATTACHED', 'RECONCILED')
  AND payment_type IN ('EXPENSE', 'VENDOR_PAYMENT')
```

**说明**：进项发票跟着支出走，嵌入在fin_payment_records中。LOAN类型不涉及发票。

### 9.3 待补票列表

**来源**：fin_payment_records

**提取逻辑**：
```sql
SELECT payment_code, payment_type, cost_type, project_code,
       amount, invoice_status, created_at,
       CAST((julianday('now') - julianday(created_at)) AS INTEGER) AS days_pending
FROM fin_payment_records
WHERE invoice_status = 'PENDING_INVOICE'
  AND status IN ('PAID', 'CLOSED')
ORDER BY created_at ASC
```

**说明**：days_pending>30时标红，触发待补票逾期审计告警。

---

## 十、结算/盈亏汇总逻辑

### 10.1 合同级结算（fin_settlements）

| 汇总项 | 计算逻辑 | 数据来源 |
|--------|----------|----------|
| contract_amount | 合同总额（快照） | Contract API GET /api/contract/contracts/{id} |
| collected_amount | SUM(amount WHERE contract_id=X AND status=CONFIRMED) | fin_collections |
| invoiced_amount | SUM(total_amount WHERE contract_id=X AND invoice_status IN ('ISSUED')) | fin_invoices |
| paid_amount | SUM(amount WHERE contract_id=X AND status IN ('PAID','CLOSED') AND payment_type IN ('EXPENSE','VENDOR_PAYMENT')) | fin_payment_records |
| balance_collection | = contract_amount - collected_amount | 计算 |
| balance_invoice | = contract_amount - invoiced_amount | 计算 |
| balance_profit | = collected_amount - paid_amount | 计算 |

**关键**：paid_amount不含LOAN类型（借款不计入成本）。

### 10.2 项目级盈亏（fin_project_pl）

| 汇总项 | 计算逻辑 | 说明 |
|--------|----------|------|
| total_contract | SUM(contract_amount) via Contract API | 项目所有关联合同总额 |
| total_collected | SUM(amount WHERE project_code=X AND status=CONFIRMED) | fin_collections |
| total_invoiced | SUM(total_amount WHERE project_code=X AND invoice_status='ISSUED') | fin_invoices |
| total_cost | SUM(amount WHERE project_code=X AND status IN ('PAID','CLOSED') AND payment_type IN ('EXPENSE','VENDOR_PAYMENT') AND budget_source='PROJECT') | fin_payment_records |
| total_budget | SUM(budget) via Budget API | 项目预算总额 |
| budget_execution | = total_cost / total_budget × 100 | 预算执行率 |
| gross_profit | = total_collected - total_cost | 毛利 |
| gross_margin | = gross_profit / total_collected × 100 | 毛利率 |
| net_receivable | = total_contract - total_collected | 净应收 |

### 10.3 P&L计入规则（关键）

| 支出类型 | 预算来源 | 计入项目P&L | 计入合同结算 | 说明 |
|----------|----------|-------------|-------------|------|
| EXPENSE | PROJECT | ✅ 是 | ✅ 是 | 项目预算报销，计入成本 |
| EXPENSE | DEPARTMENT | ❌ 否 | ✅ 是 | 部门预算报销，计入合同结算但不计入项目P&L |
| LOAN | — | ❌ 否 | ❌ 否 | 借款不计入P&L成本，不计入合同结算 |
| VENDOR_PAYMENT | — | ✅ 是 | ✅ 是 | 供应商付款，计入成本 |

**一句话总结**：只有项目预算EXPENSE和VENDOR_PAYMENT计入项目P&L；LOAN完全不计入成本；部门预算EXPENSE计入合同结算但不计入项目P&L。

### 10.4 成本分项（cost_breakdown）

```json
{
  "SMO_FEE": { "budget": 150000, "actual": 120000 },
  "PARTNER_FEE": { "budget": 80000, "actual": 80000 },
  "CENTER_FEE": { "budget": 200000, "actual": 180000 },
  "REAGENT": { "budget": 60000, "actual": 55000 },
  "EQUIPMENT": { "budget": 30000, "actual": 30000 },
  "TRAVEL": { "budget": 20000, "actual": 18000 },
  "TRIAL": { "budget": 40000, "actual": 35000 },
  "OTHER": { "budget": 10000, "actual": 8000 }
}
```

---

## 十一、审计线7种检测

审计线通过fin_audit_alerts表存储告警记录，7种检测类型：

| 序号 | alert_type | 检测名称 | 检测逻辑 | 触发时机 |
|------|-----------|----------|----------|----------|
| 1 | COLLECTION_OVER_AMOUNT | 收款超额 | SUM(confirmed collections) > contract_amount | 收款确认时 |
| 2 | INVOICE_OVER_AMOUNT | 开票超额 | SUM(issued invoices) > contract_amount | 发票开具时 |
| 3 | BUDGET_OVER | 超预算 | SUM(project EXPENSE + VENDOR_PAYMENT) > project_budget | 支出审批通过时 |
| 4 | COLLECTION_OVERDUE | 逾期收款 | 收款计划日期过当前日期且未收款 | 每日定时扫描 |
| 5 | LOAN_OVERDUE | 借款逾期 | repayment_date < 当前日期 AND repayment_status ≠ SETTLED | 每日定时扫描 |
| 6 | PENDING_INVOICE_OVERDUE | 待补票逾期 | invoice_status=PENDING_INVOICE AND 付款日期+30天 < 当前日期 | 每日定时扫描 |
| 7 | SETTLEMENT_DIFF | 结算差异 | |collected_amount - paid_amount| 与balance_profit偏差>阈值 | 结算确认时 |

**告警字段**：alert_type, alert_level(WARNING/CRITICAL), target_type(CONTRACT/PROJECT/PAYMENT), target_id, target_desc, alert_detail, detected_at, resolved_at, resolved_by, resolution_remark, status(ACTIVE/RESOLVED)

**处理机制**：
- ACTIVE状态告警在审计线Tab展示
- 相关业务操作完成后自动检测是否可消除告警
- 财务人员可手动标记RESOLVED并记录处理说明

---

## 十二、跨模块数据流图

```
┌──────────────────────────────────────────────────────────────────────────┐
│                          外部模块（API只读引用）                           │
│                                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Contract    │  │ SMO合同管理  │  │ 合作商管理   │  │ 中心管理     │     │
│  │ 对象线      │  │             │  │             │  │             │     │
│  │             │  │ 付款节点API  │  │ 付款节点API  │  │ 付款节点API  │     │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘     │
│         │                │                │                │             │
│         │  GET /api/     │  GET /api/     │  GET /api/     │  GET /api/  │
│         │  contract/     │  smo/contracts │  partner/      │  center/    │
│         │  contracts/{id}│  /{id}/nodes   │  contracts/    │  contracts/ │
│         │                │                │  {id}/nodes    │  {id}/nodes │
└─────────┼────────────────┼────────────────┼────────────────┼────────────┘
          │                │                │                │
          ▼                ▼                ▼                ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         finance.db（独立库）                               │
│                                                                          │
│  收入线                                                                   │
│  ┌──────────────────┐     ┌──────────────────┐                          │
│  │ fin_collections  │────→│ fin_invoices     │                          │
│  │ contract_id引用  │     │ collection_id关联 │                          │
│  └──────────────────┘     └──────────────────┘                          │
│                                                                          │
│  支出线                                                                   │
│  ┌──────────────────────────────────────────────────────────┐           │
│  │ fin_payment_records                                       │           │
│  │  ├── source_module=SMO → source_contract_id引用SMO合同    │           │
│  │  ├── source_module=PARTNER → source_contract_id引用合作商  │           │
│  │  ├── source_module=CENTER → source_contract_id引用中心合同 │           │
│  │  └── source_payment_node_id引用对应付款节点               │           │
│  └──────────────────────────────────────────────────────────┘           │
│  ┌──────────────────┐                                                   │
│  │ fin_loan_repayments │ ← fin_payment_records(LOAN)的还款记录          │
│  └──────────────────┘                                                   │
│                                                                          │
│  汇总线                                                                   │
│  ┌──────────────────┐     ┌──────────────────┐                          │
│  │ fin_settlements  │     │ fin_project_pl   │                          │
│  │ 从收入线+支出线汇总│     │ 从收入线+支出线汇总│                          │
│  └──────────────────┘     └──────────────────┘                          │
│                                                                          │
│  审计线 + 管理                                                            │
│  ┌──────────────────┐     ┌──────────────────┐                          │
│  │ fin_audit_alerts │     │ fin_transfer_logs│                          │
│  └──────────────────┘     └──────────────────┘                          │
└──────────────────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  审批中心（切片展示，不拥有数据）                                           │
│  提交层：POST /api/approval/instances/submit-from-module                  │
│  切片查询：GET /api/finance/payments?created_by={user_id}                 │
│  回调通知：approved/rejected → finance模块更新状态                         │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 十三、数据获取规则

### 13.1 供应商付款获取付款节点

VENDOR_PAYMENT类型需要关联外部模块的合同及付款节点，数据获取流程：

```
员工在提交层选择供应商付款
  │
  ├── 1. 选择业务来源（source_module）
  │     ├── SMO → 调用 SMO合同管理 API
  │     ├── PARTNER → 调用 合作商管理 API
  │     └── CENTER → 调用 中心管理 API
  │
  ├── 2. 选择合同（source_contract_id）
  │     GET /api/{module}/contracts?project_code={project_code}
  │     → 返回该项目下该模块的合同列表
  │     → 员工选择具体合同
  │
  ├── 3. 选择付款节点（source_payment_node_id）
  │     GET /api/{module}/contracts/{contract_id}/payment-nodes
  │     → 返回该合同的付款节点列表（节点名称、计划金额、计划日期、状态）
  │     → 员工选择具体付款节点
  │     → 自动带出计划金额
  │
  └── 4. 填写实际付款金额和事由
        → 创建fin_payment_records记录
        → source_module/source_contract_id/source_payment_node_id存储引用
```

**API对照**：

| source_module | 合同列表API | 付款节点API |
|---------------|------------|-------------|
| SMO | GET /api/smo/contracts?project_code=X | GET /api/smo/contracts/{id}/payment-nodes |
| PARTNER | GET /api/partner/contracts?project_code=X | GET /api/partner/contracts/{id}/payment-nodes |
| CENTER | GET /api/center/contracts?project_code=X | GET /api/center/contracts/{id}/payment-nodes |

### 13.2 其他跨域数据获取

| 数据需求 | 来源 | 方式 |
|----------|------|------|
| 申办方合同金额/信息 | Contract对象线 | GET /api/contract/contracts/{id} |
| 项目预算 | Budget对象线 | GET /api/budgets?project_code=X |
| 项目信息 | Project对象线 | GET /api/projects/{code} |
| 部门信息 | 组织架构 | GET /api/departments/{id} |
| 审批提交 | 审批中心 | POST /api/approval/instances/submit-from-module |
| 审批结果 | 审批中心回调 | Webhook通知 |

---

## 十四、单据转移机制

> 引用《平台交互设计架构原则》§2.5 — 项目交接或人员离职时，各层面管理者可操作单据转移

### 14.1 转移场景

| 转移场景 | 操作入口 | 操作人 | 转移范围 |
|----------|----------|--------|----------|
| 项目交接 | 项目运营→财务Tab | PM/中心负责人 | 离职人员本项目费用单据转给接手人 |
| 人员离职 | 综合管理→财务管理 | 财务/admin | 离职人员所有待处理单据批量转移 |
| 审批权转移 | 综合管理→对应模块 | admin | A的审批权转给B |

### 14.2 转移内容

- 单据归属人（created_by → transferred_to）
- 待审批任务的审批人（通过审批中心接口转移）
- 借款余额的还款责任人
- 供应商付款的经办人

### 14.3 转移日志

每次转移操作记录到fin_transfer_logs：

| 字段 | 说明 |
|------|------|
| transfer_code | 转移编号 TR-YYYYMMDD-NNN |
| transfer_type | PROJECT_HANDOVER/RESIGNATION/APPROVAL_TRANSFER |
| target_type | PAYMENT/COLLECTION/INVOICE |
| target_ids | 转移的单据ID列表（JSON） |
| from_user | 原归属人 |
| to_user | 新归属人 |
| operator | 操作人 |
| reason | 转移原因 |
| transferred_at | 转移时间 |

### 14.4 设计原则

转移操作全部留痕：谁转的、转给谁、转了哪些单据、什么时间，全部记录在fin_transfer_logs。转移后原单据的transferred_to和transferred_at字段更新，created_by保留原值以追溯。

---

## 十五、权限矩阵（5角色×5线）

> 引用《平台交互设计架构原则》§2.6 — 权限范围由小到大梯度递增

| 角色 | 收入线 | 支出线 | 票据视图 | 汇总线 | 审计线 |
|------|--------|--------|----------|--------|--------|
| **员工** | 查看（本人提交相关） | 提交+查看本人切片 | 查看本人 | 无 | 无 |
| **PM** | 查看本项目 | 查看本项目（只读+管理，无新建） | 查看本项目 | 查看本项目 | 查看本项目告警 |
| **中心负责人** | 查看本中心项目 | 查看本中心项目（只读+管理+转移） | 查看本中心 | 查看本中心项目 | 查看本中心告警 |
| **综合管理（财务）** | 全部增删改查+确认 | 全部增删改查+审批+补票+转移 | 全部查看+导出 | 全部增删改查+确认 | 全部查看+处理 |
| **admin** | 全部 | 全部 | 全部 | 全部 | 全部 |

**权限梯度说明**：

```
员工个人（审批中心切片）
  → 只看/管自己提交的
  
项目经理 PM（项目运营 → 财务Tab）
  → 看/管本项目所有记录（含前任和离职人员的）
  → 可做单据转移（项目层面）
  
中心负责人（中心管理 → 财务Tab）
  → 看/管本中心所有项目的记录
  → 可做单据转移（中心层面）
  
综合管理/财务（综合管理 → 财务管理）
  → 看/管全平台所有记录
  → 全权限：增删改查、审批、确认、补票、结算、转移
  
admin
  → 全部权限
```

---

## 十六、前端模块规划（7个JS文件）

| 序号 | 文件 | 所属层 | 功能 | 对应线 |
|------|------|--------|------|--------|
| 1 | finance-submit.js | 提交层 | 审批中心内提交入口，三类型动态表单，按payment_type路由字段 | 支出线 |
| 2 | finance-collection.js | 监管层B | 收款管理：收款录入+确认+销项发票管理 | 收入线 |
| 3 | finance-payment.js | 监管层B | 支出管理：三类型列表+审批+补票+借款还款+转移 | 支出线 |
| 4 | finance-invoice.js | 监管层B | 票据视图：销项提取+进项提取+待补票列表 | 票据视图 |
| 5 | finance-settlement.js | 监管层B | 汇总管理：合同结算+项目盈亏 | 汇总线 |
| 6 | finance-audit.js | 监管层B | 审计告警：7种检测列表+处理 | 审计线 |
| 7 | finance-project-view.js | 监管层A | 项目运营财务Tab：按project_code查本项目全部，只读+管理+转移 | 全线切片 |

### 各JS文件职责

**finance-submit.js（提交层）**
- 渲染三种支出类型切换Tab（报销/借款/供应商付款）
- 按类型动态渲染表单字段
- 选择业务来源后调API获取合同列表和付款节点
- 提交到finance模块创建记录，同时调审批中心发起流程
- 查看本人历史提交切片

**finance-collection.js（收入线）**
- 收款记录列表+新建+编辑+确认+驳回
- 销项发票管理（开票申请+开具+作废+红冲）
- 收款汇总统计

**finance-payment.js（支出线）**
- 支出流水列表（按payment_type筛选：全部/报销/借款/供应商付款）
- 审批操作（通过/驳回）
- 补票操作（填写发票信息，PENDING_INVOICE→RECONCILED）
- 借款还款操作（录入还款，更新repaid_amount和repayment_status）
- 单据转移操作

**finance-invoice.js（票据视图）**
- 销项发票视图（从fin_invoices提取）
- 进项发票视图（从fin_payment_records提取）
- 待补票列表（标黄/标红提醒）

**finance-settlement.js（汇总线）**
- 合同结算单：新建+刷新汇总+提交+确认
- 项目盈亏报表：生成+确认+成本分项展示
- 财务仪表盘

**finance-audit.js（审计线）**
- 7种检测告警列表
- 告警处理（标记已解决+记录处理说明）
- 手动触发检测

**finance-project-view.js（监管层A）**
- 以project_code为锚点查询本项目全部财务记录
- Tab切换：收款/支出/票据/结算盈亏/审计告警
- 只读展示+管理操作（改备注、标记关注）
- 单据转移入口（项目层面）

### 页面入口映射

| 入口 | 位置 | 加载JS |
|------|------|--------|
| 审批中心→财务/借款/报销 | 提交层 | finance-submit.js |
| 综合管理→财务管理→收款管理 | 监管层B | finance-collection.js |
| 综合管理→财务管理→支出管理 | 监管层B | finance-payment.js |
| 综合管理→财务管理→票据视图 | 监管层B | finance-invoice.js |
| 综合管理→财务管理→结算盈亏 | 监管层B | finance-settlement.js |
| 综合管理→财务管理→审计告警 | 监管层B | finance-audit.js |
| 项目运营→财务Tab | 监管层A | finance-project-view.js |

---

## 十七、实施优先级

| 优先级 | 模块/线 | 内容 | 理由 |
|--------|---------|------|------|
| **P0** | 支出线 | fin_payment_records + fin_loan_repayments 建表 + API + finance-submit.js + finance-payment.js | 核心业务，替代散乱的支出管理，三类型统一入口 |
| **P0** | 收入线 | fin_collections + fin_invoices 建表 + API + finance-collection.js | CRO核心，合同收款率是业务最急需 |
| **P1** | 票据视图 | 从收支表提取 + finance-invoice.js | 依赖支出线和收入线数据就绪 |
| **P1** | 汇总线 | fin_settlements + fin_project_pl 建表 + API + finance-settlement.js | 依赖收入线+支出线数据 |
| **P1** | 监管层A | finance-project-view.js | 依赖各线API就绪 |
| **P2** | 审计线 | fin_audit_alerts 建表 + API + finance-audit.js + 7种检测 | 增强能力，依赖各线数据完善 |
| **P2** | 单据转移 | fin_transfer_logs 建表 + API + 转移功能 | 管理增强，可后置 |

### 开发顺序

1. 建finance.db + 全部8张表结构（sql.md）
2. 实现支出线API + 提交层前端（finance-submit.js + finance-payment.js）
3. 实现收入线API + 前端（finance-collection.js）
4. 实现票据视图API + 前端（finance-invoice.js）
5. 实现汇总线API + 前端（finance-settlement.js）
6. 实现监管层A前端（finance-project-view.js）
7. 实现审计线API + 前端（finance-audit.js）
8. 实现单据转移功能
9. 改造现有模块对接新API

---

## 十八、表清单汇总（8表5线）

| 序号 | 表名 | 所属线 | 用途 | 核心字段 |
|------|------|--------|------|----------|
| 1 | fin_collections | 收入线 | 收款记录 | contract_id, project_code, amount, status |
| 2 | fin_invoices | 收入线 | 销项发票（跟收款走） | collection_id, invoice_no, total_amount |
| 3 | fin_payment_records | 支出线 | 统一支出流水（三类型） | payment_type, cost_type, amount, status |
| 4 | fin_loan_repayments | 支出线 | 借款还款记录 | loan_payment_id, repay_amount, repay_date |
| 5 | fin_settlements | 汇总线 | 合同级收支对账 | contract_id, collected_amount, paid_amount |
| 6 | fin_project_pl | 汇总线 | 项目级盈亏分析 | project_code, total_cost, gross_profit |
| 7 | fin_transfer_logs | 管理 | 单据转移日志 | from_user, to_user, target_ids |
| 8 | fin_audit_alerts | 审计线 | 审计告警 | alert_type, target_id, status |

**v1.0→v2.0表变更对照**：

| 操作 | 表名 | 说明 |
|------|------|------|
| **删除** | fin_collection_plans | v1.0收款计划，v2.0精简，收款直接记录 |
| **删除** | fin_bank_accounts | v1.0银行账户，v2.0精简 |
| **删除** | fin_tax_rates | v1.0税率配置，v2.0税率嵌入业务字段 |
| **删除** | fin_cost_records | v1.0独立成本表，v2.0成本从fin_payment_records汇总 |
| **保留** | fin_collections | v2.0精简字段，去掉plan_id |
| **保留** | fin_invoices | v2.0定位为销项发票专用 |
| **保留** | fin_settlements | v2.0 paid_amount来源改为fin_payment_records |
| **保留** | fin_project_pl | v2.0 total_cost来源改为fin_payment_records |
| **新增** | fin_payment_records | 统一支出流水核心表 |
| **新增** | fin_loan_repayments | 借款还款记录 |
| **新增** | fin_transfer_logs | 单据转移日志 |
| **新增** | fin_audit_alerts | 审计告警 |
