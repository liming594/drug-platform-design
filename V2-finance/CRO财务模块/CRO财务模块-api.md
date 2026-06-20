# CRO财务模块 API路由规范

> 数据库：finance.db（独立库）
> 路由前缀：/api/finance/
> 版本：v2.0 | 日期：2026-06-22
> 配套文件：CRO财务模块-design.md / CRO财务模块-sql.md
> 架构原则引用：《平台交互设计架构原则》—审批中心不拥有数据，只展示切片；三层入口架构

---

## 一、通用约定

### 1.1 请求格式
- Content-Type: application/json
- Authorization: Bearer {token}
- 分页参数：page（默认1）、size（默认20）、keyword（模糊搜索）
- 日期格式：YYYY-MM-DD（日期）/ YYYY-MM-DD HH:mm:ss（时间）

### 1.2 统一响应格式

```json
{
  "code": 0,
  "message": "success",
  "data": { ... } | [ ... ] | null,
  "total": 100
}
```

### 1.3 错误码

| 错误码 | 说明 |
|--------|------|
| 0 | 成功 |
| 40001 | 参数校验失败 |
| 40003 | 权限不足 |
| 40401 | 记录不存在 |
| 40901 | 状态冲突（如已确认不可修改） |
| 40902 | 超额预警（收款/开票超过合同额） |
| 50000 | 服务器内部错误 |

### 1.4 权限角色说明

| 角色标识 | 说明 |
|----------|------|
| employee | 普通员工（提交层） |
| pm | 项目经理（监管层A） |
| center_manager | 中心负责人（监管层A） |
| finance | 综合管理/财务（监管层B） |
| admin | 系统管理员 |

---

## 二、收入线API

### 2.1 收款记录

#### GET /api/finance/collections
获取收款记录列表

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| contract_id | string | 按合同筛选 |
| project_code | string | 按项目筛选 |
| status | string | PENDING/CONFIRMED/REJECTED |
| date_from | date | 收款日期起 |
| date_to | date | 收款日期止 |
| page | int | 页码 |
| size | int | 每页条数 |
| keyword | string | 模糊搜索编号/付款方/回单号 |

**响应data**
```json
{
  "list": [
    {
      "id": 1,
      "collection_no": "CL-20260622-001",
      "contract_id": "contract-xxx",
      "project_code": "SINO202505001",
      "collection_date": "2026-07-01",
      "amount": 300000.00,
      "payer_name": "XX药业有限公司",
      "payer_account": "6228XXXX",
      "payment_method": "BANK",
      "bank_receipt_no": "BK20260701001",
      "bank_receipt_url": "",
      "status": "PENDING",
      "confirmed_by": null,
      "confirmed_at": null,
      "reject_reason": null,
      "remark": "",
      "created_by": "admin",
      "created_at": "2026-06-22 10:00:00",
      "updated_at": "2026-06-22 10:00:00"
    }
  ],
  "total": 8,
  "page": 1,
  "size": 20
}
```

#### POST /api/finance/collections
新建收款记录（默认状态 PENDING）

**权限**：finance/admin

**请求体**
```json
{
  "contract_id": "contract-xxx",
  "project_code": "SINO202505001",
  "collection_date": "2026-07-01",
  "amount": 300000.00,
  "payer_name": "XX药业有限公司",
  "payer_account": "6228XXXX",
  "payment_method": "BANK",
  "bank_receipt_no": "BK20260701001",
  "bank_receipt_url": "",
  "remark": ""
}
```

#### PUT /api/finance/collections/:id
更新收款记录（仅 PENDING/REJECTED 状态可改）

**权限**：finance/admin

#### POST /api/finance/collections/:id/confirm
确认收款（PENDING → CONFIRMED），触发审批中心流程

**权限**：finance/admin

**请求体**
```json
{
  "remark": "银行流水已核实"
}
```

**响应**（含超额预警）
```json
{
  "code": 40902,
  "message": "收款确认成功，但预警：累计收款1,200,000元已超过合同额1,000,000元",
  "data": {
    "id": 1,
    "status": "CONFIRMED",
    "contract_total_collected": 1200000,
    "contract_amount": 1000000,
    "over_amount": 200000,
    "audit_alert_id": 15
  }
}
```

#### POST /api/finance/collections/:id/reject
驳回收款（PENDING → REJECTED）

**权限**：finance/admin

**请求体**
```json
{
  "reject_reason": "银行回单不清晰，请重新上传"
}
```

#### GET /api/finance/collections/summary
收款汇总（按合同或项目维度）

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| contract_id | string | 按合同汇总 |
| project_code | string | 按项目汇总 |

**响应data**
```json
{
  "contract_id": "contract-xxx",
  "contract_amount": 1000000,
  "total_collected": 800000,
  "total_pending": 200000,
  "collection_rate": 80.0,
  "overdue_count": 1
}
```

---

### 2.2 销项发票

#### GET /api/finance/invoices
获取销项发票列表

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| contract_id | string | 按合同筛选 |
| project_code | string | 按项目筛选 |
| collection_id | int | 按收款记录筛选 |
| invoice_status | string | DRAFT/PENDING/ISSUED/VOIDED/REVERSED |
| invoice_type | string | GENERAL/SPECIAL/ELECTRONIC |
| date_from | date | 开票日期起 |
| date_to | date | 开票日期止 |
| page | int | 页码 |
| size | int | 每页条数 |
| keyword | string | 模糊搜索编号/购买方/税号 |

**响应data**
```json
{
  "list": [
    {
      "id": 1,
      "invoice_no": "INV-20260622-001",
      "tax_invoice_no": "24400000000001234",
      "contract_id": "contract-xxx",
      "project_code": "SINO202505001",
      "collection_id": 1,
      "collection_no": "CL-20260622-001",
      "invoice_type": "GENERAL",
      "invoice_status": "ISSUED",
      "amount": 283018.87,
      "tax_rate": 0.06,
      "tax_amount": 16981.13,
      "total_amount": 300000.00,
      "buyer_name": "XX药业有限公司",
      "buyer_tax_no": "91XXXXXXXXXXXXX",
      "buyer_address": "北京市XX区XX路XX号 010-XXXXXXXX",
      "buyer_bank": "中国XX银行XX支行 6228XXXX",
      "invoice_date": "2026-07-01",
      "issued_by": "财务专员",
      "issued_at": "2026-07-01 14:30:00",
      "invoice_url": "/uploads/invoices/INV-20260622-001.pdf",
      "remark": "",
      "created_at": "2026-06-22 10:00:00",
      "updated_at": "2026-07-01 14:30:00"
    }
  ],
  "total": 6,
  "page": 1,
  "size": 20
}
```

#### POST /api/finance/invoices
新建销项发票（默认状态 DRAFT）

**权限**：finance/admin

**请求体**
```json
{
  "contract_id": "contract-xxx",
  "project_code": "SINO202505001",
  "collection_id": 1,
  "invoice_type": "GENERAL",
  "amount": 283018.87,
  "tax_rate": 0.06,
  "buyer_name": "XX药业有限公司",
  "buyer_tax_no": "91XXXXXXXXXXXXX",
  "buyer_address": "北京市XX区XX路XX号 010-XXXXXXXX",
  "buyer_bank": "中国XX银行XX支行 6228XXXX",
  "invoice_date": "2026-07-01",
  "remark": ""
}
```

> 后端自动计算：`tax_amount = amount * tax_rate`，`total_amount = amount + tax_amount`

#### PUT /api/finance/invoices/:id
更新发票（仅 DRAFT 状态可改）

**权限**：finance/admin

#### POST /api/finance/invoices/:id/apply
提交开票申请（DRAFT → PENDING），触发审批中心

**权限**：finance/admin

**请求体**
```json
{
  "approval_flow_code": "finance_invoice_issue",
  "remark": "申请开具增值税普通发票"
}
```

#### POST /api/finance/invoices/:id/issue
开具发票（PENDING → ISSUED）

**权限**：finance/admin

**请求体**
```json
{
  "tax_invoice_no": "24400000000001234",
  "invoice_url": "/uploads/invoices/INV-20260622-001.pdf",
  "issued_by": "财务专员"
}
```

**响应**（含超额预警）
```json
{
  "code": 40902,
  "message": "发票开具成功，但预警：累计开票1,200,000元已超过合同额1,000,000元",
  "data": { "audit_alert_id": 16 }
}
```

#### POST /api/finance/invoices/:id/void
作废发票（DRAFT/PENDING → VOIDED）

**权限**：finance/admin

**请求体**
```json
{
  "void_reason": "信息有误，重新开具"
}
```

#### POST /api/finance/invoices/:id/reverse
红冲发票（ISSUED → REVERSED）

**权限**：finance/admin

**请求体**
```json
{
  "reversed_reason": "金额错误，需红冲重开"
}
```

#### GET /api/finance/invoices/summary
发票汇总（按合同或项目维度）

**权限**：finance/admin（全部）| pm/center_manager（本项目）

---

## 三、支出线API

### 3.1 支出流水管理

#### GET /api/finance/payments
获取支出流水列表

**权限**：finance/admin（全部）| pm/center_manager（本项目）| employee（本人切片）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| payment_type | string | EXPENSE/LOAN/VENDOR_PAYMENT |
| cost_type | string | 费用类型筛选 |
| project_code | string | 按项目筛选 |
| budget_source | string | PROJECT/DEPARTMENT |
| status | string | DRAFT/PENDING_APPROVAL/APPROVED/PAID/CLOSED/REJECTED |
| invoice_status | string | ATTACHED/PENDING_INVOICE/RECONCILED |
| source_module | string | SMO/PARTNER/CENTER |
| source_contract_id | string | 按来源合同筛选 |
| created_by | string | 按提交人筛选（切片查询用） |
| date_from | date | 创建日期起 |
| date_to | date | 创建日期止 |
| page | int | 页码 |
| size | int | 每页条数 |
| keyword | string | 模糊搜索编号/描述 |

**响应data**
```json
{
  "list": [
    {
      "id": 1,
      "payment_code": "PAY-20260622-001",
      "payment_type": "EXPENSE",
      "cost_type": "TRAVEL",
      "amount": 5000.00,
      "description": "XX项目出差差旅费",
      "status": "PAID",
      "project_code": "SINO202505001",
      "budget_source": "PROJECT",
      "department_id": null,
      "source_module": null,
      "source_contract_id": null,
      "source_payment_node_id": null,
      "loan_id": null,
      "repayment_date": null,
      "repaid_amount": 0,
      "repayment_status": null,
      "has_invoice": 1,
      "invoice_status": "ATTACHED",
      "invoice_no": "INV202606001",
      "invoice_amount_excl_tax": 4716.98,
      "invoice_tax_rate": 0.06,
      "invoice_amount_tax": 283.02,
      "invoice_date": "2026-06-20",
      "invoice_attachment": "/uploads/invoices/PAY-20260622-001.pdf",
      "approval_status": "APPROVED",
      "approved_by": "部门经理",
      "approved_at": "2026-06-22 15:00:00",
      "approval_remark": "同意",
      "created_by": "zhangsan",
      "created_at": "2026-06-22 10:00:00",
      "updated_at": "2026-06-22 16:00:00",
      "transferred_to": null,
      "transferred_at": null
    }
  ],
  "total": 25,
  "page": 1,
  "size": 20
}
```

#### POST /api/finance/payments
新建支出流水（默认状态 DRAFT）

**权限**：employee（提交层）| finance/admin

**请求体（EXPENSE 日常报销）**
```json
{
  "payment_type": "EXPENSE",
  "cost_type": "TRAVEL",
  "amount": 5000.00,
  "description": "XX项目出差差旅费",
  "project_code": "SINO202505001",
  "budget_source": "PROJECT",
  "department_id": null,
  "has_invoice": 1,
  "invoice_status": "ATTACHED",
  "invoice_no": "INV202606001",
  "invoice_amount_excl_tax": 4716.98,
  "invoice_tax_rate": 0.06,
  "invoice_date": "2026-06-20",
  "invoice_attachment": "/uploads/invoices/PAY-20260622-001.pdf"
}
```

**请求体（LOAN 员工借款）**
```json
{
  "payment_type": "LOAN",
  "cost_type": "PROJECT_ADVANCE",
  "amount": 20000.00,
  "description": "XX项目预支款",
  "project_code": "SINO202505001",
  "budget_source": "DEPARTMENT",
  "department_id": "dept-001",
  "repayment_date": "2026-08-01",
  "has_invoice": 0,
  "invoice_status": "PENDING_INVOICE"
}
```

**请求体（VENDOR_PAYMENT 供应商付款）**
```json
{
  "payment_type": "VENDOR_PAYMENT",
  "cost_type": "SMO_FEE",
  "amount": 100000.00,
  "description": "XX项目SMO服务费第二期",
  "project_code": "SINO202505001",
  "budget_source": "PROJECT",
  "source_module": "SMO",
  "source_contract_id": "smo-contract-001",
  "source_payment_node_id": "node-002",
  "has_invoice": 0,
  "invoice_status": "PENDING_INVOICE"
}
```

#### PUT /api/finance/payments/:id
更新支出流水（仅 DRAFT/REJECTED 状态可改）

**权限**：employee（本人）| finance/admin

#### POST /api/finance/payments/:id/submit
提交审批（DRAFT → PENDING_APPROVAL），按金额分级路由审批模板

**权限**：employee（本人）| finance/admin

**请求体**
```json
{
  "remark": "提交审批"
}
```

> 后端根据amount自动选择审批模板：
> - EXPENSE ≤5万 → finance_expense_le5k
> - EXPENSE 5-50万 → finance_expense_5k_50k
> - EXPENSE >50万 → finance_expense_gt50k
> - LOAN → finance_loan
> - VENDOR_PAYMENT ≤5万 → finance_vendor_le5k
> - VENDOR_PAYMENT 5-50万 → finance_vendor_5k_50k
> - VENDOR_PAYMENT >50万 → finance_vendor_gt50k

#### POST /api/finance/payments/:id/approve
审批通过（PENDING_APPROVAL → APPROVED），审批中心回调触发

**权限**：finance/admin（审批回调）

**请求体**
```json
{
  "approved_by": "财务总监",
  "approval_remark": "同意"
}
```

#### POST /api/finance/payments/:id/reject
审批驳回（PENDING_APPROVAL → REJECTED），审批中心回调触发

**权限**：finance/admin（审批回调）

**请求体**
```json
{
  "approval_remark": "金额不符，请核实"
}
```

#### POST /api/finance/payments/:id/pay
标记已付款（APPROVED → PAID）

**权限**：finance/admin

**请求体**
```json
{
  "remark": "已通过银行转账付款"
}
```

#### POST /api/finance/payments/:id/close
关闭单据（PAID → CLOSED）

**权限**：finance/admin

> 对于有发票的EXPENSE/VENDOR_PAYMENT，invoice_status=ATTACHED时可直接关闭。
> 对于PENDING_INVOICE的VENDOR_PAYMENT，需补票后（RECONCILED）才能关闭。

#### POST /api/finance/payments/:id/supply-invoice
补票操作（PENDING_INVOICE → RECONCILED），填写发票信息

**权限**：finance/admin

**请求体**
```json
{
  "invoice_no": "INV202607001",
  "invoice_amount_excl_tax": 94339.62,
  "invoice_tax_rate": 0.06,
  "invoice_date": "2026-07-15",
  "invoice_attachment": "/uploads/invoices/PAY-20260622-003.pdf"
}
```

> 后端自动计算 invoice_amount_tax = invoice_amount_excl_tax * invoice_tax_rate
> 更新 invoice_status → RECONCILED，has_invoice → 1

#### GET /api/finance/payments/summary
支出汇总（按项目或类型维度）

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| project_code | string | 按项目汇总 |
| payment_type | string | 按类型汇总 |
| date_from | date | 日期起 |
| date_to | date | 日期止 |

**响应data**
```json
{
  "project_code": "SINO202505001",
  "total_expense": 150000,
  "total_loan": 20000,
  "total_vendor": 300000,
  "by_cost_type": {
    "TRAVEL": 5000,
    "SMO_FEE": 200000,
    "CENTER_FEE": 100000
  },
  "pending_approval_count": 3,
  "paid_count": 12,
  "pending_invoice_count": 2
}
```

---

### 3.2 借款还款

#### GET /api/finance/loan-repayments
获取借款还款记录列表

**权限**：finance/admin（全部）| pm/center_manager（本项目）| employee（本人切片）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| loan_payment_id | int | 按借款记录筛选 |
| loan_code | string | 按借款编号筛选 |
| date_from | date | 还款日期起 |
| date_to | date | 还款日期止 |
| page | int | 页码 |
| size | int | 每页条数 |

**响应data**
```json
{
  "list": [
    {
      "id": 1,
      "repayment_no": "REP-20260701-001",
      "loan_payment_id": 5,
      "loan_code": "PAY-20260622-005",
      "repay_amount": 10000.00,
      "repay_date": "2026-07-01",
      "repay_method": "BANK_TRANSFER",
      "remark": "第一次还款",
      "created_by": "zhangsan",
      "created_at": "2026-07-01 10:00:00"
    }
  ],
  "total": 2,
  "page": 1,
  "size": 20
}
```

#### POST /api/finance/loan-repayments
新增还款记录（自动更新借款记录的repaid_amount和repayment_status）

**权限**：finance/admin | employee（本人，还款操作）

**请求体**
```json
{
  "loan_payment_id": 5,
  "repay_amount": 10000.00,
  "repay_date": "2026-07-01",
  "repay_method": "BANK_TRANSFER",
  "remark": "第一次还款"
}
```

> 后端自动：
> 1. 计算累计还款额 = SUM(repay_amount WHERE loan_payment_id=X)
> 2. 更新fin_payment_records.repaid_amount和repayment_status
> 3. 若累计还款≥借款金额 → repayment_status=SETTLED → 触发器自动将status改为CLOSED

#### GET /api/finance/loan-repayments/loan/:loanPaymentId
获取指定借款的全部还款记录

**权限**：finance/admin（全部）| pm/center_manager（本项目）| employee（本人）

---

### 3.3 切片查询接口（供审批中心调用）

#### GET /api/finance/payments/slice
按created_by查询用户支出切片（审批中心代理调用）

**权限**：内部接口（审批中心调用，需验证调用方token）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| created_by | string | 用户ID（必填） |
| payment_type | string | 可选，按类型筛选 |
| status | string | 可选，按状态筛选 |
| page | int | 页码 |
| size | int | 每页条数 |

**响应data**
```json
{
  "list": [
    {
      "payment_code": "PAY-20260622-001",
      "payment_type": "EXPENSE",
      "cost_type": "TRAVEL",
      "amount": 5000.00,
      "description": "XX项目出差差旅费",
      "status": "PAID",
      "project_code": "SINO202505001",
      "approval_status": "APPROVED",
      "created_at": "2026-06-22 10:00:00"
    }
  ],
  "total": 5,
  "page": 1,
  "size": 20
}
```

---

## 四、票据视图API

### 4.1 销项发票视图

#### GET /api/finance/invoice-view/output
销项发票提取视图（从fin_invoices提取）

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| contract_id | string | 按合同筛选 |
| project_code | string | 按项目筛选 |
| invoice_status | string | ISSUED/VOIDED/REVERSED |
| date_from | date | 开票日期起 |
| date_to | date | 开票日期止 |
| page | int | 页码 |
| size | int | 每页条数 |

**响应data**
```json
{
  "list": [
    {
      "invoice_no": "INV-20260622-001",
      "tax_invoice_no": "24400000000001234",
      "contract_id": "contract-xxx",
      "project_code": "SINO202505001",
      "collection_id": 1,
      "collection_no": "CL-20260622-001",
      "invoice_type": "GENERAL",
      "invoice_status": "ISSUED",
      "amount_excl_tax": 283018.87,
      "tax_rate": 0.06,
      "tax_amount": 16981.13,
      "total_amount": 300000.00,
      "buyer_name": "XX药业有限公司",
      "buyer_tax_no": "91XXXXXXXXXXXXX",
      "invoice_date": "2026-07-01",
      "invoice_url": "/uploads/invoices/INV-20260622-001.pdf"
    }
  ],
  "total": 6,
  "page": 1,
  "size": 20
}
```

### 4.2 进项发票视图

#### GET /api/finance/invoice-view/input
进项发票提取视图（从fin_payment_records发票字段提取）

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| project_code | string | 按项目筛选 |
| payment_type | string | EXPENSE/VENDOR_PAYMENT |
| cost_type | string | 费用类型 |
| invoice_status | string | ATTACHED/RECONCILED |
| date_from | date | 开票日期起 |
| date_to | date | 开票日期止 |
| page | int | 页码 |
| size | int | 每页条数 |

**响应data**
```json
{
  "list": [
    {
      "payment_code": "PAY-20260622-001",
      "payment_type": "EXPENSE",
      "cost_type": "TRAVEL",
      "project_code": "SINO202505001",
      "amount": 5000.00,
      "invoice_no": "INV202606001",
      "invoice_amount_excl_tax": 4716.98,
      "invoice_tax_rate": 0.06,
      "invoice_amount_tax": 283.02,
      "invoice_total": 5000.00,
      "invoice_date": "2026-06-20",
      "invoice_status": "ATTACHED",
      "invoice_attachment": "/uploads/invoices/PAY-20260622-001.pdf"
    }
  ],
  "total": 18,
  "page": 1,
  "size": 20
}
```

### 4.3 待补票列表

#### GET /api/finance/invoice-view/pending
待补票列表（从fin_payment_records WHERE invoice_status=PENDING_INVOICE提取）

**权限**：finance/admin

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| project_code | string | 按项目筛选 |
| overdue_only | boolean | 仅显示逾期（>30天） |
| page | int | 页码 |
| size | int | 每页条数 |

**响应data**
```json
{
  "list": [
    {
      "payment_code": "PAY-20260622-003",
      "payment_type": "VENDOR_PAYMENT",
      "cost_type": "SMO_FEE",
      "project_code": "SINO202505001",
      "amount": 100000.00,
      "invoice_status": "PENDING_INVOICE",
      "paid_date": "2026-06-22",
      "days_pending": 15,
      "is_overdue": false,
      "source_module": "SMO",
      "source_contract_id": "smo-contract-001"
    }
  ],
  "total": 3,
  "page": 1,
  "size": 20,
  "overdue_count": 1
}
```

> days_pending = 当前日期 - PAID状态变更日期
> is_overdue = days_pending > 30

---

## 五、汇总线API

### 5.1 合同结算

#### GET /api/finance/settlements
获取结算单列表

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| contract_id | string | 按合同筛选 |
| project_code | string | 按项目筛选 |
| settlement_status | string | DRAFT/PENDING/CONFIRMED |
| settlement_type | string | PARTIAL/FINAL/ADJUSTMENT |
| page | int | 页码 |
| size | int | 每页条数 |

#### POST /api/finance/settlements
新建结算单（自动汇总数据）

**权限**：finance/admin

**请求体**
```json
{
  "contract_id": "contract-xxx",
  "project_code": "SINO202505001",
  "settlement_type": "FINAL",
  "settlement_date": "2026-12-31",
  "remark": "项目终结算"
}
```

> 后端自动执行汇总：
> 1. 调用 Contract API 获取 contract_amount
> 2. 汇总 fin_collections（CONFIRMED）→ collected_amount
> 3. 汇总 fin_invoices（ISSUED）→ invoiced_amount
> 4. 汇总 fin_payment_records（PAID/CLOSED, payment_type IN EXPENSE/VENDOR_PAYMENT）→ paid_amount
> 5. 计算 balance_collection / balance_invoice / balance_profit

#### POST /api/finance/settlements/:id/refresh
重新汇总结算数据（DRAFT/PENDING状态可刷新）

**权限**：finance/admin

#### POST /api/finance/settlements/:id/submit
提交结算（DRAFT → PENDING），触发审批

**权限**：finance/admin

#### POST /api/finance/settlements/:id/confirm
确认结算（PENDING → CONFIRMED）
- FINAL类型确认后锁定该合同的收款/发票/支出记录
- 自动检测结算差异，写入审计告警

**权限**：finance/admin

#### GET /api/finance/settlements/contract/:contractId
获取指定合同的结算历史

**权限**：finance/admin（全部）| pm/center_manager（本项目）

---

### 5.2 项目盈亏

#### GET /api/finance/pl
获取项目盈亏列表

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| project_code | string | 按项目筛选 |
| period | string | 按期间筛选 YYYY-MM |
| pl_type | string | MONTHLY/FINAL |
| pl_status | string | DRAFT/CONFIRMED |
| page | int | 页码 |
| size | int | 每页条数 |

#### GET /api/finance/pl/project/:projectCode
获取指定项目的盈亏详情（含成本分项）

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**响应data**
```json
{
  "project_code": "SINO202505001",
  "project_name": "XX药物III期临床试验",
  "total_contract": 1000000,
  "total_collected": 800000,
  "total_invoiced": 800000,
  "total_cost": 350000,
  "total_budget": 400000,
  "budget_execution": 87.5,
  "gross_profit": 450000,
  "gross_margin": 56.25,
  "net_receivable": 200000,
  "cost_breakdown": {
    "SMO_FEE": { "budget": 150000, "actual": 120000, "variance": -30000 },
    "CENTER_FEE": { "budget": 100000, "actual": 100000, "variance": 0 },
    "TRAVEL": { "budget": 20000, "actual": 18000, "variance": -2000 },
    "TRIAL": { "budget": 60000, "actual": 55000, "variance": -5000 }
  },
  "latest_period": "2026-06",
  "latest_pl_status": "DRAFT"
}
```

> total_cost = SUM(fin_payment_records WHERE project_code=X AND status IN (PAID,CLOSED) AND payment_type IN (EXPENSE,VENDOR_PAYMENT) AND budget_source=PROJECT)
> LOAN不计入，部门预算EXPENSE不计入项目P&L

#### POST /api/finance/pl/generate
生成盈亏报表（月度快照）

**权限**：finance/admin

**请求体**
```json
{
  "project_code": "SINO202505001",
  "period": "2026-06",
  "pl_type": "MONTHLY"
}
```

> 后端自动聚合：
> 1. 汇总 fin_collections → total_collected
> 2. 汇总 fin_payment_records（项目预算EXPENSE + VENDOR_PAYMENT）→ total_cost + cost_breakdown
> 3. 调用 Contract API → total_contract
> 4. 调用 Budget API → total_budget + 预算分项
> 5. 计算 gross_profit / gross_margin / budget_execution

#### POST /api/finance/pl/:id/confirm
确认盈亏报表（DRAFT → CONFIRMED）

**权限**：finance/admin

#### GET /api/finance/pl/dashboard
财务仪表盘（全平台汇总）

**权限**：finance/admin

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| period | string | 期间 YYYY-MM（默认当月） |

**响应data**
```json
{
  "period": "2026-06",
  "total_contracts": 649,
  "total_contract_amount": 150000000,
  "total_collected": 98000000,
  "total_pending_collection": 52000000,
  "total_invoiced": 95000000,
  "total_expense": 35000000,
  "total_vendor_payment": 27000000,
  "total_loan_outstanding": 5000000,
  "avg_collection_rate": 65.3,
  "avg_gross_margin": 36.7,
  "pending_approval_count": 8,
  "pending_invoice_count": 3,
  "active_alerts_count": 12,
  "top_projects_by_profit": [],
  "alert_projects_over_budget": []
}
```

---

## 六、审计线API

### 6.1 审计告警

#### GET /api/finance/audit/alerts
获取审计告警列表

**权限**：finance/admin（全部）| pm/center_manager（本项目）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| alert_type | string | 7种类型筛选 |
| alert_level | string | WARNING/CRITICAL |
| status | string | ACTIVE/RESOLVED |
| target_type | string | CONTRACT/PROJECT/PAYMENT/COLLECTION/INVOICE |
| target_id | string | 按目标ID筛选 |
| project_code | string | 按项目筛选（关联查询） |
| date_from | date | 检测日期起 |
| date_to | date | 检测日期止 |
| page | int | 页码 |
| size | int | 每页条数 |

**响应data**
```json
{
  "list": [
    {
      "id": 1,
      "alert_code": "ALT-20260622-001",
      "alert_type": "COLLECTION_OVER_AMOUNT",
      "alert_level": "WARNING",
      "target_type": "COLLECTION",
      "target_id": "1",
      "target_desc": "CL-20260622-001",
      "alert_detail": {
        "collection_id": 1,
        "collection_no": "CL-20260622-001",
        "amount": 300000,
        "contract_id": "contract-xxx",
        "contract_amount": 1000000,
        "total_collected": 1200000,
        "over_amount": 200000
      },
      "detected_at": "2026-06-22 16:00:00",
      "status": "ACTIVE",
      "resolved_at": null,
      "resolved_by": null,
      "resolution_remark": null
    }
  ],
  "total": 12,
  "page": 1,
  "size": 20,
  "by_type": {
    "COLLECTION_OVER_AMOUNT": 2,
    "INVOICE_OVER_AMOUNT": 1,
    "BUDGET_OVER": 3,
    "COLLECTION_OVERDUE": 1,
    "LOAN_OVERDUE": 2,
    "PENDING_INVOICE_OVERDUE": 1,
    "SETTLEMENT_DIFF": 2
  }
}
```

#### POST /api/finance/audit/alerts/:id/resolve
处理告警（ACTIVE → RESOLVED）

**权限**：finance/admin

**请求体**
```json
{
  "resolution_remark": "已与申办方沟通确认，超额部分为追加合同款"
}
```

### 6.2 检测触发

#### POST /api/finance/audit/detect
手动触发检测（定时任务也可调用）

**权限**：finance/admin（手动触发）| 系统定时任务（自动触发）

**请求体**
```json
{
  "detect_types": ["LOAN_OVERDUE", "PENDING_INVOICE_OVERDUE", "COLLECTION_OVERDUE"],
  "project_code": null
}
```

> 不传detect_types则执行全部7种检测。project_code为空则全平台扫描。

**响应data**
```json
{
  "detected_count": 5,
  "new_alerts": 3,
  "resolved_alerts": 1,
  "details": [
    {
      "alert_type": "LOAN_OVERDUE",
      "new_count": 2,
      "message": "检测到2笔借款逾期"
    },
    {
      "alert_type": "PENDING_INVOICE_OVERDUE",
      "new_count": 1,
      "message": "检测到1笔待补票逾期"
    }
  ]
}
```

#### GET /api/finance/audit/alerts/stats
告警统计（按类型汇总）

**权限**：finance/admin

**响应data**
```json
{
  "total_active": 12,
  "total_resolved": 35,
  "by_type": {
    "COLLECTION_OVER_AMOUNT": { "active": 2, "resolved": 5 },
    "INVOICE_OVER_AMOUNT": { "active": 1, "resolved": 3 },
    "BUDGET_OVER": { "active": 3, "resolved": 8 },
    "COLLECTION_OVERDUE": { "active": 1, "resolved": 4 },
    "LOAN_OVERDUE": { "active": 2, "resolved": 6 },
    "PENDING_INVOICE_OVERDUE": { "active": 1, "resolved": 5 },
    "SETTLEMENT_DIFF": { "active": 2, "resolved": 4 }
  },
  "by_level": {
    "WARNING": 8,
    "CRITICAL": 4
  }
}
```

---

## 七、提交层接口（审批中心代理）

### 7.1 提交支出申请

#### POST /api/finance/submit
提交层统一入口（审批中心代理调用），按payment_type路由创建不同类型的支出记录

**权限**：employee（通过审批中心提交）

**请求体**
```json
{
  "payment_type": "EXPENSE",
  "cost_type": "TRAVEL",
  "amount": 5000.00,
  "description": "XX项目出差差旅费",
  "project_code": "SINO202505001",
  "budget_source": "PROJECT",
  "department_id": null,
  "has_invoice": 1,
  "invoice_no": "INV202606001",
  "invoice_amount_excl_tax": 4716.98,
  "invoice_tax_rate": 0.06,
  "invoice_date": "2026-06-20",
  "invoice_attachment": "/uploads/invoices/001.pdf",
  "remark": "出差差旅费报销"
}
```

> 后端处理：
> 1. 创建fin_payment_records记录（status=DRAFT）
> 2. 自动计算 invoice_amount_tax
> 3. 根据payment_type和amount选择审批模板编码
> 4. 调用审批中心 POST /api/approval/instances/submit-from-module 发起审批
> 5. 更新status → PENDING_APPROVAL
> 6. 返回业务记录ID和审批实例ID

**响应data**
```json
{
  "payment_id": 1,
  "payment_code": "PAY-20260622-001",
  "approval_instance_id": "app-instance-xxx",
  "approval_flow_code": "finance_expense_le5k",
  "status": "PENDING_APPROVAL"
}
```

### 7.2 获取业务来源合同列表

#### GET /api/finance/submit/contracts
获取供应商付款可选的合同列表（代理调用SMO/合作商/中心管理API）

**权限**：employee（通过审批中心提交）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| source_module | string | SMO/PARTNER/CENTER（必填） |
| project_code | string | 项目编号（必填） |

**响应data**
```json
{
  "list": [
    {
      "contract_id": "smo-contract-001",
      "contract_name": "XX项目SMO服务合同",
      "contract_amount": 500000,
      "vendor_name": "北京XXSMO公司",
      "contract_status": "ACTIVE"
    }
  ]
}
```

> 后端代理调用：
> - SMO → GET /api/smo/contracts?project_code=X
> - PARTNER → GET /api/partner/contracts?project_code=X
> - CENTER → GET /api/center/contracts?project_code=X

### 7.3 获取付款节点列表

#### GET /api/finance/submit/payment-nodes
获取指定合同的付款节点列表（代理调用业务模块API）

**权限**：employee（通过审批中心提交）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| source_module | string | SMO/PARTNER/CENTER（必填） |
| source_contract_id | string | 合同ID（必填） |

**响应data**
```json
{
  "list": [
    {
      "node_id": "node-001",
      "node_name": "首付款30%",
      "plan_amount": 150000,
      "plan_date": "2026-07-01",
      "node_status": "PENDING"
    },
    {
      "node_id": "node-002",
      "node_name": "入组50%",
      "plan_amount": 200000,
      "plan_date": "2026-09-01",
      "node_status": "PENDING"
    }
  ]
}
```

---

## 八、单据转移接口

### 8.1 单据转移

#### POST /api/finance/transfers
执行单据转移

**权限**：pm（项目层面，本项目单据）| center_manager（中心层面）| finance/admin（全局）

**请求体**
```json
{
  "transfer_type": "PROJECT_HANDOVER",
  "target_type": "PAYMENT",
  "target_ids": [1, 2, 3],
  "from_user": "zhangsan",
  "to_user": "lisi",
  "reason": "项目交接，张三离职，费用单据转给李四"
}
```

> 后端处理：
> 1. 校验操作人权限（pm只能转本项目/center_manager只能转本中心/admin全部）
> 2. 批量更新fin_payment_records：transferred_to=to_user, transferred_at=now
> 3. created_by保留原值（追溯），新增transferred_to字段
> 4. 写入fin_transfer_logs记录
> 5. 同步通知审批中心转移待审批任务

**响应data**
```json
{
  "transfer_code": "TR-20260622-001",
  "transferred_count": 3,
  "target_ids": [1, 2, 3],
  "from_user": "zhangsan",
  "to_user": "lisi"
}
```

#### GET /api/finance/transfers
获取转移日志列表

**权限**：finance/admin（全部）| pm/center_manager（本项目/本中心）

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| transfer_type | string | PROJECT_HANDOVER/RESIGNATION/APPROVAL_TRANSFER |
| from_user | string | 按原归属人筛选 |
| to_user | string | 按新归属人筛选 |
| target_type | string | PAYMENT/COLLECTION/INVOICE |
| date_from | date | 日期起 |
| date_to | date | 日期止 |
| page | int | 页码 |
| size | int | 每页条数 |

#### GET /api/finance/transfers/:transferCode
获取转移详情（含转移的单据列表）

**权限**：finance/admin（全部）| pm/center_manager（本项目/本中心）

---

## 九、监管层A接口（按project_code查询本项目全部）

### 9.1 项目财务总览

#### GET /api/finance/project/:projectCode/overview
获取指定项目的财务总览（监管层A入口）

**权限**：pm/center_manager（本项目）| finance/admin

**响应data**
```json
{
  "project_code": "SINO202505001",
  "project_name": "XX药物III期临床试验",
  "summary": {
    "total_collected": 800000,
    "total_expense": 150000,
    "total_loan_outstanding": 20000,
    "total_vendor_payment": 300000,
    "pending_approval_count": 3,
    "pending_invoice_count": 2,
    "active_alerts_count": 1
  },
  "recent_collections": [],
  "recent_payments": [],
  "recent_alerts": []
}
```

> 以project_code为锚点查询全部记录，不受"是谁提的"限制（含前任和离职人员的）。

### 9.2 项目收支明细

#### GET /api/finance/project/:projectCode/payments
获取指定项目的全部支出流水（监管层A，只读）

**权限**：pm/center_manager（本项目）| finance/admin

**Query参数**
| 参数 | 类型 | 说明 |
|------|------|------|
| payment_type | string | EXPENSE/LOAN/VENDOR_PAYMENT |
| status | string | 状态筛选 |
| cost_type | string | 费用类型 |
| date_from | date | 日期起 |
| date_to | date | 日期止 |
| page | int | 页码 |
| size | int | 每页条数 |

> 返回该项目下所有人的支出记录，包括前任PM和离职员工提交的。

### 9.3 项目收款明细

#### GET /api/finance/project/:projectCode/collections
获取指定项目的全部收款记录（监管层A，只读）

**权限**：pm/center_manager（本项目）| finance/admin

### 9.4 项目盈亏详情

#### GET /api/finance/project/:projectCode/pl
获取指定项目的盈亏详情（监管层A，只读）

**权限**：pm/center_manager（本项目）| finance/admin

> 同 GET /api/finance/pl/project/:projectCode，为监管层A提供便捷入口。

### 9.5 项目审计告警

#### GET /api/finance/project/:projectCode/alerts
获取指定项目的审计告警（监管层A，只读）

**权限**：pm/center_manager（本项目）| finance/admin

### 9.6 项目单据转移

#### POST /api/finance/project/:projectCode/transfer
项目层面单据转移（监管层A操作）

**权限**：pm/center_manager（本项目）

**请求体**
```json
{
  "target_type": "PAYMENT",
  "target_ids": [1, 2, 3],
  "from_user": "zhangsan",
  "to_user": "lisi",
  "reason": "项目交接"
}
```

> 调用统一的转移逻辑，写入fin_transfer_logs，transfer_type=PROJECT_HANDOVER。

---

## 十、审批集成

### 10.1 审批回调

#### POST /api/finance/approval/callback
审批结果回调（审批中心调用）

**权限**：内部接口（审批中心调用）

**请求体**
```json
{
  "instance_id": "app-instance-xxx",
  "business_type": "expense",
  "business_id": "PAY-20260622-001",
  "result": "approved",
  "approver": "财务总监",
  "remark": "同意"
}
```

> 后端根据result执行：
> - approved → 更新fin_payment_records.status=APPROVED, approval_status=APPROVED
> - rejected → 更新fin_payment_records.status=REJECTED, approval_status=REJECTED

**响应**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "payment_code": "PAY-20260622-001",
    "new_status": "APPROVED"
  }
}
```

---

## 十一、API清单汇总表

| 序号 | 方法 | 路径 | 功能 | 模块/线 | 权限 |
|------|------|------|------|---------|------|
| **收入线** | | | | | |
| 1 | GET | /api/finance/collections | 收款记录列表 | 收入线 | finance/admin/pm |
| 2 | POST | /api/finance/collections | 新建收款记录 | 收入线 | finance/admin |
| 3 | PUT | /api/finance/collections/:id | 更新收款记录 | 收入线 | finance/admin |
| 4 | POST | /api/finance/collections/:id/confirm | 确认收款 | 收入线 | finance/admin |
| 5 | POST | /api/finance/collections/:id/reject | 驳回收款 | 收入线 | finance/admin |
| 6 | GET | /api/finance/collections/summary | 收款汇总 | 收入线 | finance/admin/pm |
| 7 | GET | /api/finance/invoices | 销项发票列表 | 收入线 | finance/admin/pm |
| 8 | POST | /api/finance/invoices | 新建销项发票 | 收入线 | finance/admin |
| 9 | PUT | /api/finance/invoices/:id | 更新发票 | 收入线 | finance/admin |
| 10 | POST | /api/finance/invoices/:id/apply | 提交开票申请 | 收入线 | finance/admin |
| 11 | POST | /api/finance/invoices/:id/issue | 开具发票 | 收入线 | finance/admin |
| 12 | POST | /api/finance/invoices/:id/void | 作废发票 | 收入线 | finance/admin |
| 13 | POST | /api/finance/invoices/:id/reverse | 红冲发票 | 收入线 | finance/admin |
| 14 | GET | /api/finance/invoices/summary | 发票汇总 | 收入线 | finance/admin/pm |
| **支出线** | | | | | |
| 15 | GET | /api/finance/payments | 支出流水列表 | 支出线 | finance/admin/pm/employee |
| 16 | POST | /api/finance/payments | 新建支出流水 | 支出线 | employee/finance/admin |
| 17 | PUT | /api/finance/payments/:id | 更新支出流水 | 支出线 | employee/finance/admin |
| 18 | POST | /api/finance/payments/:id/submit | 提交审批 | 支出线 | employee/finance/admin |
| 19 | POST | /api/finance/payments/:id/approve | 审批通过 | 支出线 | finance/admin |
| 20 | POST | /api/finance/payments/:id/reject | 审批驳回 | 支出线 | finance/admin |
| 21 | POST | /api/finance/payments/:id/pay | 标记已付款 | 支出线 | finance/admin |
| 22 | POST | /api/finance/payments/:id/close | 关闭单据 | 支出线 | finance/admin |
| 23 | POST | /api/finance/payments/:id/supply-invoice | 补票操作 | 支出线 | finance/admin |
| 24 | GET | /api/finance/payments/summary | 支出汇总 | 支出线 | finance/admin/pm |
| 25 | GET | /api/finance/loan-repayments | 借款还款列表 | 支出线 | finance/admin/pm/employee |
| 26 | POST | /api/finance/loan-repayments | 新增还款记录 | 支出线 | finance/admin/employee |
| 27 | GET | /api/finance/loan-repayments/loan/:loanPaymentId | 借款还款明细 | 支出线 | finance/admin/pm/employee |
| 28 | GET | /api/finance/payments/slice | 切片查询（审批中心调用） | 支出线 | 内部接口 |
| **票据视图** | | | | | |
| 29 | GET | /api/finance/invoice-view/output | 销项发票提取视图 | 票据视图 | finance/admin/pm |
| 30 | GET | /api/finance/invoice-view/input | 进项发票提取视图 | 票据视图 | finance/admin/pm |
| 31 | GET | /api/finance/invoice-view/pending | 待补票列表 | 票据视图 | finance/admin |
| **汇总线** | | | | | |
| 32 | GET | /api/finance/settlements | 结算单列表 | 汇总线 | finance/admin/pm |
| 33 | POST | /api/finance/settlements | 新建结算单 | 汇总线 | finance/admin |
| 34 | POST | /api/finance/settlements/:id/refresh | 刷新结算数据 | 汇总线 | finance/admin |
| 35 | POST | /api/finance/settlements/:id/submit | 提交结算 | 汇总线 | finance/admin |
| 36 | POST | /api/finance/settlements/:id/confirm | 确认结算 | 汇总线 | finance/admin |
| 37 | GET | /api/finance/settlements/contract/:contractId | 合同结算历史 | 汇总线 | finance/admin/pm |
| 38 | GET | /api/finance/pl | 盈亏列表 | 汇总线 | finance/admin/pm |
| 39 | GET | /api/finance/pl/project/:projectCode | 项目盈亏详情 | 汇总线 | finance/admin/pm |
| 40 | POST | /api/finance/pl/generate | 生成盈亏报表 | 汇总线 | finance/admin |
| 41 | POST | /api/finance/pl/:id/confirm | 确认盈亏报表 | 汇总线 | finance/admin |
| 42 | GET | /api/finance/pl/dashboard | 财务仪表盘 | 汇总线 | finance/admin |
| **审计线** | | | | | |
| 43 | GET | /api/finance/audit/alerts | 告警列表 | 审计线 | finance/admin/pm |
| 44 | POST | /api/finance/audit/alerts/:id/resolve | 处理告警 | 审计线 | finance/admin |
| 45 | POST | /api/finance/audit/detect | 触发检测 | 审计线 | finance/admin/系统 |
| 46 | GET | /api/finance/audit/alerts/stats | 告警统计 | 审计线 | finance/admin |
| **提交层** | | | | | |
| 47 | POST | /api/finance/submit | 提交支出申请 | 提交层 | employee |
| 48 | GET | /api/finance/submit/contracts | 获取合同列表 | 提交层 | employee |
| 49 | GET | /api/finance/submit/payment-nodes | 获取付款节点 | 提交层 | employee |
| **单据转移** | | | | | |
| 50 | POST | /api/finance/transfers | 执行单据转移 | 管理 | pm/center_manager/finance/admin |
| 51 | GET | /api/finance/transfers | 转移日志列表 | 管理 | finance/admin/pm |
| 52 | GET | /api/finance/transfers/:transferCode | 转移详情 | 管理 | finance/admin/pm |
| **监管层A** | | | | | |
| 53 | GET | /api/finance/project/:projectCode/overview | 项目财务总览 | 监管层A | pm/center_manager/finance/admin |
| 54 | GET | /api/finance/project/:projectCode/payments | 项目支出明细 | 监管层A | pm/center_manager/finance/admin |
| 55 | GET | /api/finance/project/:projectCode/collections | 项目收款明细 | 监管层A | pm/center_manager/finance/admin |
| 56 | GET | /api/finance/project/:projectCode/pl | 项目盈亏详情 | 监管层A | pm/center_manager/finance/admin |
| 57 | GET | /api/finance/project/:projectCode/alerts | 项目审计告警 | 监管层A | pm/center_manager/finance/admin |
| 58 | POST | /api/finance/project/:projectCode/transfer | 项目单据转移 | 监管层A | pm/center_manager |
| **审批集成** | | | | | |
| 59 | POST | /api/finance/approval/callback | 审批结果回调 | 审批集成 | 内部接口 |
| **合计** | | **59个API** | | | |

### v1.0→v2.0 API变更对照

| 操作 | 说明 |
|------|------|
| 删除 | /api/finance/bank-accounts/* （银行账户CRUD，v2.0精简） |
| 删除 | /api/finance/collection-plans/* （收款计划CRUD，v2.0精简） |
| 删除 | /api/finance/tax-rates/* （税率配置CRUD，v2.0嵌入业务字段） |
| 删除 | /api/finance/costs/* （独立成本CRUD，v2.0由fin_payment_records替代） |
| 新增 | /api/finance/payments/* （统一支出流水CRUD+审批+补票） |
| 新增 | /api/finance/loan-repayments/* （借款还款） |
| 新增 | /api/finance/invoice-view/* （票据视图：销项/进项/待补票提取） |
| 新增 | /api/finance/audit/* （审计告警+检测触发） |
| 新增 | /api/finance/submit/* （提交层统一入口+合同/付款节点获取） |
| 新增 | /api/finance/transfers/* （单据转移） |
| 新增 | /api/finance/project/:projectCode/* （监管层A接口） |
| 新增 | /api/finance/approval/callback （审批回调） |
| 新增 | /api/finance/payments/slice （切片查询，供审批中心调用） |
| 修改 | /api/finance/collections/* 去掉plan_id关联 |
| 修改 | /api/finance/invoices/* 定位为销项发票专用 |
| 修改 | /api/finance/settlements/* paid_amount来源改为fin_payment_records |
| 修改 | /api/finance/pl/* total_cost来源改为fin_payment_records，P&L规则更新 |
