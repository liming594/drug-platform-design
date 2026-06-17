# 审批平台 v2 — 设计文档

> 基于 WO-039 审批引擎重构，升级为唯一审批基础设施。
> 核心目标：**所有业务模块接入同一引擎，消灭各自造轮子。**

---

## 一、WO-039 审计结论 & v2 改进方向

| # | 问题 | v2 方案 |
|---|------|---------|
| P0 | 两套审批并行，业务模块自建审批 | 引擎为唯一入口，废弃 budget-approval/expense-approval 等自建 API |
| P0 | 无业务回调 | 新增 callback_url，审批完成后自动通知业务模块 |
| P1 | 只支持线性链 | 新增条件路由（金额阈值/业务类型分叉） |
| P1 | 无会签 | 新增 countersign 模式（同节点多人全部通过才推进） |
| P2 | 角色全映射 admin | 保持角色映射表，增加委托覆盖 |
| P2 | 无审批委托 | 新增 delegation 表，外出时自动转发 |
| P2 | 无超时升级 | 新增 escalation 规则，超时自动上提 |
| P2 | 无撤回后重提 | v2 撤回不终结实例，允许重新提交 |

---

## 二、架构定位

```
审批中心（综合管理→审批中心）
  6个Tab：待我审批 / 我已审批 / 我发起的 / 新建申请 / 流程配置 / 审批统计

业务模块（合同/用印/文档/预算/费用...）
  "提交审批"按钮 → 调用审批中心API → 弹出审批详情面板
  审批详情面板与审批中心共享同一组件
```

核心架构：**审批中心是唯一流程引擎，各业务模块只是调用方，不再自建审批。**

- **审批中心**：统一入口，覆盖所有审批场景的提交、审批、配置、统计
- **业务模块**：只有"提交审批"按钮，通过 API 调用审批中心，弹出共享审批详情面板
- **审批详情面板**：业务端和审批中心共享同一组件，侧滑/弹窗形式展示流程进度与操作

---

## 三、数据库设计（approval.db v2）

### 3.1 保留并升级的表

**approval_flows（流程模板）**
| 字段 | 类型 | 说明 | v2 新增 |
|------|------|------|---------|
| id | INTEGER PK | | |
| flow_code | TEXT UNIQUE | 流程编码 | |
| flow_name | TEXT | 流程名称 | |
| description | TEXT | | |
| module | TEXT | 所属模块 | |
| flow_category | TEXT | 一级分类：PROJECT(项目类) / DEPT(部门类) | ✅ |
| flow_subcategory | TEXT | 二级分类（如：进度/工时/中心/合同/用印/预算/采购/质量/行政/通用等） | ✅ |
| applicable_companies | TEXT | 适用公司，JSON数组，如["兴德通","兴德通医药"]，空数组=全部 | ✅ |
| source_modules | TEXT | 调用模块，JSON数组，如["contract","seal","budget"] | ✅ |
| route_type | TEXT | linear / conditional | ✅ |
| timeout_hours | INTEGER | 全流程超时小时数，0=不限 | ✅ |
| is_active | INTEGER | | |
| created_at / updated_at | TEXT | | |

**approval_steps（步骤定义）**
| 字段 | 类型 | 说明 | v2 新增 |
|------|------|------|---------|
| id | INTEGER PK | | |
| flow_id | INTEGER FK | | |
| step_order | INTEGER | 步骤序号 | |
| step_name | TEXT | | |
| approver_role | TEXT | 审批角色编码 | |
| approver_type | TEXT | 审批人确定方式 | ✅ |
| approval_type | TEXT | single / countersign | ✅ |
| action_type | TEXT | approve / notify | |
| branch_group | TEXT | 分支组标识（同组互斥，必须且只能匹配一条） | ✅ |
| condition_field | TEXT | 条件字段（amount/business_type） | ✅ |
| condition_op | TEXT | eq/gt/gte/lt/lte/in | ✅ |
| condition_value | TEXT | 条件值 | ✅ |
| is_required | INTEGER | | |
| timeout_hours | INTEGER | 单步超时，0=不限 | ✅ |
| created_at / updated_at | TEXT | | |

**approval_instances（审批实例）**
| 字段 | 类型 | 说明 | v2 新增 |
|------|------|------|---------|
| id | INTEGER PK | | |
| flow_id | INTEGER FK | | |
| flow_version_id | INTEGER FK | 流程版本ID | ✅ |
| flow_no | TEXT | 流程编号（如AP-PRJ-001），从flow的flow_code复制 | ✅ |
| instance_no | TEXT UNIQUE | | |
| company_id | TEXT | 提交所属公司 | ✅ |
| title | TEXT | | |
| module | TEXT | | |
| business_id | TEXT | 业务单据 ID | |
| business_type | TEXT | | |
| applicant_id / applicant_name | TEXT | | |
| amount | REAL | 金额（条件路由关键字段） | |
| summary | TEXT | | |
| form_data | TEXT | JSON，原始表单数据 | ✅ |
| status | TEXT | pending/approved/rejected/cancelled | |
| resubmit_count | INTEGER | 重新提交次数，0=首次 | ✅ |
| callback_url | TEXT | 审批完成回调地址 | ✅ |
| cc_users | TEXT | 抄送人列表，JSON数组 | ✅ |
| created_at / updated_at | TEXT | | |

> **v2 去掉 current_step 字段**：当前步骤从 instance_steps 中 status='pending' 且 step_order 最小的记录动态推导，避免双源冗余不一致。

**approval_logs（审批记录）** — v2 新增 resubmit_seq/attachments 字段
**approval_role_users（角色映射）** — 不变

### 3.2 v2 新增表

**approval_instance_steps（实例步骤快照）**
> 创建实例时根据条件路由解析出实际步骤序列，冻结存储。resubmit 时旧步骤保留（status=skipped），新建一套步骤。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PK | |
| instance_id | INTEGER FK | |
| resubmit_seq | INTEGER | 第几次提交，0=首次，resubmit 时递增 |
| step_order | INTEGER | 1,2,3... |
| step_name | TEXT | |
| approver_role | TEXT | |
| approver_type | TEXT | 审批人确定方式（从步骤快照复制） |
| approval_type | TEXT | single / countersign |
| status | TEXT | pending/approved/rejected/skipped |
| actual_approver_id | TEXT | 实际审批人 |
| actual_approver_name | TEXT | |
| comment | TEXT | 审批意见 |
| created_at / updated_at | TEXT | |

**approval_countersign_votes（会签投票）**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PK | |
| instance_step_id | INTEGER FK | |
| approver_id / approver_name | TEXT | |
| vote | TEXT | approved / rejected |
| comment | TEXT | |
| created_at | TEXT | |

**approval_delegations（审批委托）**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PK | |
| delegator_id / delegator_name | TEXT | 委托人 |
| delegate_id / delegate_name | TEXT | 受托人 |
| role_code | TEXT | 委托角色（空=全部角色） |
| start_date | TEXT | 开始日期 |
| end_date | TEXT | 结束日期 |
| is_active | INTEGER | |
| created_at | TEXT | |

**approval_escalations（超时升级规则）**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PK | |
| flow_id | INTEGER FK | |
| step_order | INTEGER | |
| timeout_hours | INTEGER | 超时触发小时数 |
| escalate_to_role | TEXT | 升级到哪个角色 |
| auto_action | TEXT | escalate / auto_approve / auto_reject |
| is_active | INTEGER | |

**approval_callback_logs（回调日志）** — v2 新增
> 审批终态回调业务模块的执行记录，支持重试。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PK | |
| instance_id | INTEGER FK | |
| callback_url | TEXT | |
| request_body | TEXT | 请求体 JSON |
| response_status | INTEGER | HTTP 状态码 |
| response_body | TEXT | 响应体 |
| attempt | INTEGER | 第几次尝试（1-3） |
| status | TEXT | pending / success / failed |
| next_retry_at | TEXT | 下次重试时间 |
| created_at | TEXT | |

**approval_flow_versions（流程版本）** — v2 新增
> 每次发布模板生成新版本，实例关联版本而非模板本身，支持审计追溯。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PK | |
| flow_id | INTEGER FK | 关联流程模板 |
| version_no | INTEGER | 版本号，从1递增 |
| steps_snapshot | TEXT | 步骤定义快照（JSON） |
| published_by | TEXT | 发布人 |
| published_at | TEXT | 发布时间 |

**approval_notifications（审批通知）** — v2 新增
> 步骤到达/审批完成时生成通知记录，对接企微/站内信。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PK | |
| instance_id | INTEGER FK | |
| instance_step_id | INTEGER FK | 关联步骤（可空，终态通知无步骤） |
| type | TEXT | step_arrived / approved / rejected / cc |
| target_user_id | TEXT | 通知对象 |
| channel | TEXT | site / wework / email |
| title | TEXT | 通知标题 |
| content | TEXT | 通知内容 |
| is_read | INTEGER | 0/1 |
| created_at | TEXT | |

---

## 四、条件路由设计

### 4.1 原理
流程模板定义"完整步骤集"，每步可带 condition_* 条件。创建实例时，引擎根据实例数据评估条件，过滤出实际步骤序列。

### 4.2 示例：费用审批（金额分级）
```
flow_code: payment_approval, route_type: conditional

步骤定义：
│ order │ name          │ role            │ condition        │
├───────┼───────────────┼─────────────────┼──────────────────┤
│ 1     │ 项目经理审核   │ project_manager │ 无（总是执行）    │
│ 2     │ 财务审核       │ finance_manager │ 无               │
│ 3     │ 财务总监审核   │ cfo             │ amount > 50000   │
│ 4     │ 总经理审核     │ gm              │ amount > 500000  │
```

实例 amount=30000 → 步骤序列：1→2
实例 amount=80000 → 步骤序列：1→2→3
实例 amount=600000 → 步骤序列：1→2→3→4

### 4.3 示例：用印审批（分类路由，branch_group 互斥分支）
```
步骤定义（branch_group 标识互斥分支）：
│ order │ branch_group │ name          │ role            │ condition                   │
├───────┼──────────────┼───────────────┼─────────────────┼─────────────────────────────┤
│ 1     │ branch_A     │ 项目经理审核   │ project_manager │ business_type = 'PROJECT'   │
│ 1     │ branch_A     │ 部门经理审核   │ department_head │ business_type = 'NON_PROJECT'│
│ 2     │              │ 法务审核       │ legal           │ 无                          │
│ 3     │              │ 总经理审核     │ gm              │ amount > 500000             │
```

**分支规则：**
- 同一 step_order + 同一 branch_group 的步骤互斥，必须且只能匹配一条
- 无匹配 → 提交时拒绝，返回错误"步骤1分支无匹配条件，请检查business_type"
- 多条匹配 → 提交时拒绝，返回错误"步骤1分支匹配多条条件，存在配置冲突"
- 非 branch_group 步骤（branch_group 为空）正常评估 condition，不匹配则跳过（status=skipped）
- 实例步骤快照 step_order 重新连续编号（过滤后 1,2,3→1,2,3）

---

## 五、会签机制

当 `approval_type = countersign` 时：
1. 该步骤需指定角色的**所有映射用户**投票
2. 全部通过 → 步骤通过 → 推进到下一步
3. 任一人驳回 → 步骤驳回 → 实例驳回
4. 投票记录写入 `approval_countersign_votes`
5. **委托穿透在会签中同样生效**：被委托人代原审批人投票，总投票人数不变
6. **条件路由跳过的步骤不创建投票记录**：如果某步骤因条件不匹配被 skipped，不触发会签流程

### 使用场景
- 合同审批中法务+财务同时审
- 重大支出需 CFO+CEO 双签

---

## 六、审批委托

1. 用户在委托管理页设置：委托给谁、哪个角色、起止日期
2. 引擎查找审批人时：先查 `approval_delegations`，有生效委托则替换为受托人
3. 审批日志中记录"代{委托人}审批"
4. **委托穿透在会签中同样生效**：受托人代原审批人投票，投票人数不变，日志标注"代XX投票"

---

## 七、超时升级

- 每步可设 `timeout_hours`
- `approval_escalations` 定义超时动作：上提/自动通过/自动驳回
- 由定时任务（每15分钟）扫描逾期步骤并执行升级
- 升级记录写入日志，action='escalated'
- **定时任务宿主**：`server/scheduler.js` 独立模块，随 app.js 启动时注册，使用 node-cron 实现，进程重启后自动恢复

---

## 八、业务回调机制

业务模块提交审批时传 `callback_url`：
```
POST /api/approval/instances
{
  "flow_code": "payment_approval",
  "title": "XX项目差旅报销",
  "callback_url": "https://test.sinocro.cn/api/expenses/callback/approval",
  ...
}
```

审批终态时，引擎回调：
```
POST {callback_url}
{
  "instance_no": "APV-20260617-001",
  "status": "approved",
  "business_id": "EXP-042",
  "logs": [...]
}
```

业务模块收到回调后执行：预算锁定/费用归集/状态更新。

---

## 九、前端设计

### 9.1 审批中心（综合管理→审批中心）

审批中心为单层架构，包含6个Tab：

---

**Tab1 待我审批**
- 筛选：申请类型 / 项目 / 时间范围
- 列表字段：申请编号(AP-PRJ-001-20260617-001) / 申请类型 / 标题 / 发起人 / 发起部门 / 项目 / 提交时间 / 操作[审批]
- 点击[审批]弹出审批详情面板（见9.4）

---

**Tab2 我已审批**
- 列表字段：申请编号 / 申请类型 / 标题 / 发起人 / 我的审批结果 / 审批时间 / 操作[查看]

---

**Tab3 我发起的**
- 列表字段：申请编号 / 申请类型 / 标题 / 当前节点 / 当前处理人 / 状态 / 操作
- 状态：审批中 / 已通过 / 已拒绝 / 已退回
- 操作：
  - 审批中 → [催办]
  - 已拒绝 → [重新提交]

---

**Tab4 新建申请**（新增）
- 集中申请入口，按大类分类卡片：

| 卡片 | 类别 | 包含申请 | 对应流程编号 |
|------|------|---------|-------------|
| 📋 印章/证照申请 | 用印 | 用印申请、证照借用 | AP-PRJ-004 / AP-DEPT-004 |
| 💻 办公资产申请 | 行政 | 设备申领、办公用品 | AP-DEPT-005 |
| 💰 借款/用款/报销 | 预算 | 借款、付款、费用报销 | AP-PRJ-003 / AP-DEPT-003 |
| 📝 通用审批 | 通用 | 不属于以上类别 | AP-DEPT-009 |
| 🔒 预留扩展(灰色) | 预留 | 考勤/请假/加班调休，企微对接后开放 | — |

- 点击卡片 → 选项目（项目类必选，部门类可选）→ 选具体表单 → 调用对应模块表单
- 底部提示：💡各申请表单与对应模块共享，审批流程统一归口审批中心

---

**Tab5 流程配置**（管理员，大幅增强）
- 左侧：分类树（项目类 / 部门类 → 二级分类展开）
- 右侧：流程列表（按选中分类过滤）
- 顶部：适用公司筛选 + [新建流程]按钮
- 表格字段：流程编号 / 流程名称 / 分类 / 适用公司 / 条件路由 / 步骤数 / 状态 / 操作
- 新建/编辑弹窗：
  - 基本信息：流程编号(自动AP-{类别}-{序号}) / 名称 / 一级分类 / 二级分类 / 适用公司(多选)
  - 条件路由设置
  - 步骤编辑器（每步可设条件）
- 详细流程分类见第十八章

---

**Tab6 审批统计**
- 顶部统计卡片：本月审批总数 / 平均审批时长 / 审批通过率 / 待处理数
- 图表：按类型分布 / 按部门统计 / 近30天趋势
- 权限：管理人员+管理员看全部，普通员工只看自己相关

---

### 9.2 业务端集成

- 各业务模块有"提交审批"按钮
- 点击弹出审批详情面板（侧滑/弹窗），不是跳转
- 提交后业务对象状态变"审批中"，可随时查看流程进度

---

### 9.3 审批详情面板（共享组件）

- **顶部**：审批单号(AP-PRJ-001-20260617-001) + 状态徽章 + 业务来源(如"合同管理")
- **中部**：流程步骤进度条（✓已完成 / ●当前 / ○待处理）
- **底部**：审批历史时间线
- **操作区**（仅当前审批人可见）：通过 / 驳回 / 退回 + 意见输入
- 此面板从业务端和审批中心都能打开

---

## 十、模块接入迁移计划

| 阶段 | 模块 | 当前方式 | 迁移动作 | 对应流程 |
|------|------|----------|----------|----------|
| 1 | 用印管理 | seal-design 内置审批链 | 改为调用引擎，审批链用条件路由 | AP-PRJ-004 / AP-DEPT-004 |
| 2 | 合同管理 | 状态手动切换 | 对接引擎 contract_approval 流程 | AP-PRJ-005 |
| 3 | 预算管理 | budget-approval.js 自建 | 废弃，改为调用引擎 | AP-DEPT-006 |
| 4 | 费用管理 | expense-approval.js 自建 | 废弃，改为调用引擎 | AP-PRJ-003 / AP-DEPT-003 |
| 5 | 借款/付款 | 内置审批 | 废弃，改为调用引擎 | AP-DEPT-007 / AP-DEPT-008 |
| 6 | 项目进度(里程碑) | 内置状态变更 | 对接引擎里程碑/状态变更流程 | AP-PRJ-001 / AP-PRJ-002 |
| 7 | 工时管理 | 无审批 | 新增工时提交审批 | AP-PRJ-010 |
| 8 | 中心管理 | 无审批 | 新增中心筛选/SIV/关闭审批 | AP-PRJ-007 ~ AP-PRJ-009 |
| 9 | 质量管理 | 无审批 | 新增偏差报告/CAPA审批 | AP-PRJ-011 / AP-PRJ-012 |
| 10 | 采购管理 | 内置审批 | 改为调用引擎 | AP-PRJ-006 / AP-DEPT-002 |
| 11 | 行政办公 | 无审批 | 新增资产申领/证照借用审批 | AP-DEPT-001 / AP-DEPT-005 |
| 12 | HR | 无审批 | 预留，企微对接后启用 | AP-DEPT-010 |

---

## 十一、与平台管理的关系

| 域 | DB | 职责 |
|----|-----|------|
| 审批平台 | approval.db | 审批流引擎、实例、日志、角色映射 |
| 平台管理 | admin.db（原 permission.db 扩展） | 用户、部门、RBAC权限、数据字典、系统配置、操作审计 |

审批的角色映射（approval_role_users）引用平台管理的用户和部门体系。两者通过 user_id / role_code 关联，但 DB 物理独立。

审批引擎动态审批人解析时，需要调用平台管理的部门树（查上级）和项目成员表（查PM），通过 HTTP API 跨域查询，不直接访问 admin.db。

---

## 十二、审批人动态解析

### 12.1 问题
静态角色映射只能表达"某个角色永远是这几个人"，无法处理：
- 申请人直属上级（因人而异）
- 该项目的PM（因项目而异）
- 申请人部门负责人（因部门而异）

### 12.2 approver_type 枚举

| approver_type | 含义 | approver_role 用法 | 审批人确定逻辑 |
|---------------|------|-------------------|---------------|
| single_role | 静态角色映射 | role_code，查 approval_role_users | 当前方式，不变 |
| dynamic_report | 申请人直属上级 | 忽略 | 查 admin 部门树，取申请人所在部门的 parent_dept 负责人 |
| dynamic_dept | 申请人部门负责人 | 忽略 | 查 admin 部门树，取申请人所在部门负责人 |
| dynamic_pm | 项目的PM | 忽略 | 查项目成员表，取 project_manager 角色 |
| applicant | 申请人本人 | 忽略 | 直接取 instance.applicant_id（用于知会/确认场景） |

### 12.3 解析流程
```
创建实例/推进步骤时：
1. 查 instance_step.approver_type
2. single_role → 查 approval_role_users → 委托穿透 → 返回审批人列表
3. dynamic_report → 调 admin API GET /api/admin/users/:id/manager → 返回上级
4. dynamic_dept → 调 admin API GET /api/admin/departments/:id/head → 返回负责人
5. dynamic_pm → 调项目 API GET /api/projects/:id/members?role=pm → 返回PM
6. applicant → 直接取 applicant_id
7. 结果写入 instance_step.actual_approver_id（缓存，避免后续再查）
```

### 12.4 回退策略
动态解析失败时（如无上级、项目无PM）：
1. 回退到 approval_role_users 中 role_code='fallback_approver' 的用户
2. 无 fallback → 标记步骤 status=error，通知管理员手动处理

---

## 十三、流程模板版本管理

### 13.1 问题
改了模板后，运行中实例有快照保护，但**无版本记录**，无法回答"当时这个流程长什么样"。

### 13.2 机制
- 模板有"草稿"和"已发布"两种状态
- 编辑模板 → 改草稿，不影响运行中流程
- 点击"发布" → 生成新版本号 → 写入 approval_flow_versions（含步骤快照JSON）→ 已发布版本不可修改
- 创建实例时关联 flow_version_id，快照从版本生成
- 模板列表显示当前版本号和发布历史

### 13.3 版本快照格式
```json
{
  "version_no": 3,
  "flow_code": "seal_approval",
  "route_type": "conditional",
  "steps": [
    { "step_order": 1, "step_name": "项目经理审核", "approver_role": "project_manager", "approver_type": "single_role", "branch_group": "branch_A", "condition_field": "business_type", "condition_op": "eq", "condition_value": "PROJECT" },
    ...
  ]
}
```

---

## 十四、通知机制

### 14.1 触发时机
| 事件 | 通知对象 | 通知类型 |
|------|---------|---------|
| 步骤到达 | 当前步骤审批人 | step_arrived |
| 审批通过 | 申请人 | approved |
| 审批驳回 | 申请人 | rejected |
| 审批终态 | 抄送人 | cc |
| 超时升级 | 被升级到的审批人 | step_arrived |

### 14.2 通知渠道
- **site**：站内信（写入 approval_notifications，前端轮询/推送）
- **wework**：企微应用消息（对接企微API）
- **email**：邮件通知

### 14.3 用户通知偏好
用户可配置每种事件的通知渠道（默认 site + wework）。通知偏好存 admin.db 的用户配置中。

---

## 十五、加签/减签

### 15.1 加签
审批人在审批时可"加签"——追加一个人来审：

```
POST /api/approval/instances/:id/add-signer
{
  "added_user_id": "wangwu",
  "added_user_name": "王五",
  "reason": "需要法务再看一眼"
}
```

处理逻辑：
1. 在当前 instance_step 之后插入一个新 instance_step（step_order 插入，后续步骤 step_order+1）
2. 原步骤先通过
3. 新步骤审批完后继续原流程
4. 写日志 action='add_signer'

### 15.2 减签
仅 countersign 步骤支持，减少会签投票人：

```
POST /api/approval/instances/:id/remove-signer
{
  "removed_user_id": "zhaoliu",
  "reason": "赵六不相关"
}
```

处理逻辑：
1. 标记该投票人不需要投票
2. 重新计算投票进度（总人数-1）
3. 写日志 action='remove_signer'

---

## 十六、抄送/知会

### 16.1 提交时指定抄送人
```json
{
  "flow_code": "payment_approval",
  "title": "XX项目差旅报销",
  "cc_users": [
    { "user_id": "wangwu", "user_name": "王五" }
  ],
  ...
}
```

### 16.2 通知时机
- 审批终态（approved/rejected）时，抄送人收到 cc 类型通知
- 抄送人可在"抄送给我"Tab 中查看，只读不可操作

---

## 十七、审批附件

### 17.1 审批意见附件
审批日志增加 `attachments` 字段：
```json
{
  "action": "rejected",
  "comment": "合同条款有误，见附件",
  "attachments": [
    { "name": "修改意见.pdf", "url": "/uploads/approval/xxx.pdf" }
  ]
}
```

### 17.2 实例附件
实例表增加 `attachments` 字段（申请时上传的附件）：
```json
{
  "attachments": [
    { "name": "合同扫描件.pdf", "url": "/uploads/seal/contract.pdf" }
  ]
}
```

---

## 十八、预置流程模板（v2）

按新的分类体系，从6个扩充到22个预置流程模板：

### 项目类流程（AP-PRJ-xxx）

| 编号 | 名称 | 二级分类 | 条件路由 | 步骤概要 |
|------|------|---------|---------|---------|
| AP-PRJ-001 | 里程碑调整审批 | 进度 | 无 | PM→部门负责人→副总 |
| AP-PRJ-002 | 项目状态变更审批 | 进度 | 无 | PM→部门负责人→副总→GM |
| AP-PRJ-003 | 项目费用审批 | 预算 | 金额分级 | 直属上级→财务→CFO(>50K)→GM(>500K) |
| AP-PRJ-004 | 项目用印审批 | 用印 | 有费/无费 | PM→财务(有费用)→法务→GM(>500K) |
| AP-PRJ-005 | 项目合同审批 | 合同 | 有费/无费 | PM→财务(有费用)→法务(会签)→CFO(>50K) |
| AP-PRJ-006 | 项目采购审批 | 采购 | 金额分级 | PM→财务→CFO(>50K)→GM(>500K) |
| AP-PRJ-007 | 中心筛选结果审批 | 中心 | 无 | CRA→PM→部门负责人 |
| AP-PRJ-008 | 中心启动(SIV)审批 | 中心 | 无 | PM→QA→部门负责人 |
| AP-PRJ-009 | 中心关闭审批 | 中心 | 无 | PM→部门负责人→副总 |
| AP-PRJ-010 | 周工时提交审批 | 工时 | 无 | PM→部门负责人 |
| AP-PRJ-011 | 偏差报告审批 | 质量 | 无 | PM→QA→部门负责人→副总 |
| AP-PRJ-012 | CAPA审批 | 质量 | 无 | PM→QA→部门负责人 |

### 部门类流程（AP-DEPT-xxx）

| 编号 | 名称 | 二级分类 | 条件路由 | 步骤概要 |
|------|------|---------|---------|---------|
| AP-DEPT-001 | 办公资产申领 | 行政 | 无 | 部门负责人→行政管理 |
| AP-DEPT-002 | 办公用品采购 | 行政 | 金额分级 | 部门负责人→行政→CFO(>50K) |
| AP-DEPT-003 | 部门费用审批 | 预算 | 金额分级 | 直属上级→财务→CFO(>50K)→GM(>500K) |
| AP-DEPT-004 | 公司印章使用(非项目) | 用印 | 无 | 部门负责人→法务→GM(>500K) |
| AP-DEPT-005 | 证照借用 | 行政 | 无 | 部门负责人→行政管理 |
| AP-DEPT-006 | 预算调整审批 | 预算 | 金额分级 | 部门负责人→财务→CFO(>50K)→GM(>500K) |
| AP-DEPT-007 | 借款审批 | 预算 | 金额分级 | 直属上级→财务→CFO(>50K) |
| AP-DEPT-008 | 付款审批 | 预算 | 金额分级 | 直属上级→财务→CFO(>50K)→GM(>500K) |
| AP-DEPT-009 | 通用审批 | 通用 | 无 | 直属上级→部门负责人 |
| AP-DEPT-010 | HR类审批 | HR | 无 | 部门负责人→HR→GM(预留) |
