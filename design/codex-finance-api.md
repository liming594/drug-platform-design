# 财务模块 API路由规范

> 数据库：budget.db + finance.db | 关联：timesheet.db × member.db
> 入口三线：综合管理(全局) | 项目中心(项目维度) | 中心驾驶舱(中心维度)

---

## 一、第9号线 预算及执行 API

### 1. 预算主表 budget.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/budgets | 预算列表（?type=PROJECT/DEPARTMENT&year=&status=&keyword=） |
| GET | /api/budgets/:budgetId | 预算详情（含预算项+执行快照） |
| POST | /api/budgets | 新建预算（草稿） |
| PUT | /api/budgets/:budgetId | 编辑预算（仅DRAFT/REJECTED） |
| DELETE | /api/budgets/:budgetId | 删除（仅DRAFT） |

### 2. 预算项明细 budget-item.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/budgets/:budgetId/items | 预算项列表 |
| POST | /api/budgets/:budgetId/items | 添加预算项 |
| PUT | /api/budgets/:budgetId/items/:itemId | 编辑预算项 |
| DELETE | /api/budgets/:budgetId/items/:itemId | 删除预算项 |

### 3. 审批流程 budget-approval.js

| 方法 | 路径 | 说明 |
|---|---|---|
| POST | /api/budgets/:budgetId/submit | 提交审批 |
| POST | /api/budgets/:budgetId/approve | 审批通过 |
| POST | /api/budgets/:budgetId/reject | 打回（必填comment） |
| POST | /api/budgets/:budgetId/withdraw | 撤回 |
| GET | /api/budgets/:budgetId/approval-log | 审批历史 |

**审批链：**
- 项目预算：PM提交 → 部门经理 → 财务
- 部门预算：部门负责人提交 → 财务总监 → 总经理

### 4. 预算变更 budget-change.js

| 方法 | 路径 | 说明 |
|---|---|---|
| POST | /api/budgets/:budgetId/change | 申请变更 |
| GET | /api/budgets/:budgetId/changes | 变更记录列表 |
| GET | /api/budgets/:budgetId/changes/:changeId | 变更详情 |
| POST | /api/budgets/:budgetId/changes/:changeId/approve | 变更通过 |
| POST | /api/budgets/:budgetId/changes/:changeId/reject | 变更打回 |

### 5. 执行监控 budget-execution.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/budgets/:budgetId/execution | 执行汇总（按类别） |
| GET | /api/budgets/:budgetId/execution/trend | 月度执行趋势 |
| POST | /api/budgets/:budgetId/execution/refresh | 手动刷新快照 |

**执行数据来源：**
- AUTO_LABOR：timesheet.db × member.db 自动算人工成本
- AUTO_COST：第10号线审批通过自动同步
- MANUAL：直接在费用录入Tab录入

### 6. 费用记录 budget-cost.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/projects/:projectId/costs | 费用记录列表（?categoryId=&sourceType=&siteId=&start=&end=） |
| POST | /api/projects/:projectId/costs | 手动录入费用 |
| PUT | /api/projects/:projectId/costs/:recordId | 编辑费用（仅MANUAL类型） |
| DELETE | /api/projects/:projectId/costs/:recordId | 删除费用（仅MANUAL类型） |

### 7. 人工成本 budget-labor.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/projects/:projectId/budget/labor | 人工成本明细（按人员汇总） |
| GET | /api/projects/:projectId/budget/labor/by-role | 按岗位人工成本 |
| GET | /api/projects/:projectId/budget/labor/trend | 月度人工成本趋势 |

**计算公式：** hourly_rate = (base_salary + social_insurance_company + housing_fund_company) / 21.75 / 8
**跨库：** 读timesheet.db(weekly_timesheet) × member.db(member_salary)

### 8. 中心维度 budget-site.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/sites/:siteId/budget/execution | 中心费用汇总 |
| GET | /api/sites/:siteId/budget/labor | 中心人工成本 |

### 9. 全局概览 budget-overview.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/budgets/overview | 全局概览（总额/执行/偏差/待办） |
| GET | /api/budgets/pending-approvals | 待我审批列表 |

### 10. 费用类别+导出 budget-category.js / budget-export.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/budget/categories | 费用类别列表 |
| POST | /api/budget/categories | 新增类别 |
| PUT | /api/budget/categories/:categoryId | 编辑类别 |
| GET | /api/projects/:projectId/budget/export | 导出项目预算成本Excel |

---

## 二、第10号线 费用管理 API

### 1. 费用报销 expense-report.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/reports | 报销单列表（?status=&type=&projectId=&applicantId=&siteId=） |
| GET | /api/expenses/reports/:reportId | 报销单详情 |
| POST | /api/expenses/reports | 新建报销单 |
| PUT | /api/expenses/reports/:reportId | 编辑报销单（仅DRAFT/REJECTED） |
| DELETE | /api/expenses/reports/:reportId | 删除（仅DRAFT） |
| POST | /api/expenses/reports/:reportId/submit | 提交审批 |
| POST | /api/expenses/reports/:reportId/approve | 审批通过 |
| POST | /api/expenses/reports/:reportId/reject | 打回 |

**三入口筛选：**
- 综合管理：不传projectId/siteId，查全部
- 项目中心：传projectId，WHERE project_id = :projectId
- 中心驾驶舱：传siteId，通过expense_item.project_site_id关联查

### 2. 报销明细 expense-item.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/reports/:reportId/items | 报销明细列表 |
| POST | /api/expenses/reports/:reportId/items | 添加明细 |
| PUT | /api/expenses/reports/:reportId/items/:itemId | 编辑明细 |
| DELETE | /api/expenses/reports/:reportId/items/:itemId | 删除明细 |

### 3. 付款管理 expense-payment.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/payments | 付款单列表（?status=&payeeType=&projectId=&payeeId=） |
| GET | /api/expenses/payments/:paymentId | 付款单详情 |
| POST | /api/expenses/payments | 新建付款单 |
| PUT | /api/expenses/payments/:paymentId | 编辑付款单（仅DRAFT/REJECTED） |
| DELETE | /api/expenses/payments/:paymentId | 删除（仅DRAFT） |
| POST | /api/expenses/payments/:paymentId/submit | 提交审批 |
| POST | /api/expenses/payments/:paymentId/approve | 审批通过 |
| POST | /api/expenses/payments/:paymentId/reject | 打回 |
| POST | /api/expenses/payments/:paymentId/confirm-payment | 确认已付款 |

**三入口筛选：**
- 综合管理：不传projectId/payeeId，查全部
- 项目中心：传projectId，WHERE project_id = :projectId
- 中心驾驶舱：传payeeType=SITE&payeeId=中心ID

### 4. 借款管理 expense-loan.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/loans | 借款列表（?status=&applicantId=&projectId=） |
| GET | /api/expenses/loans/:loanId | 借款详情 |
| POST | /api/expenses/loans | 新建借款 |
| PUT | /api/expenses/loans/:loanId | 编辑借款（仅DRAFT/REJECTED） |
| POST | /api/expenses/loans/:loanId/submit | 提交审批 |
| POST | /api/expenses/loans/:loanId/approve | 审批通过 |
| POST | /api/expenses/loans/:loanId/reject | 打回 |
| POST | /api/expenses/loans/:loanId/repay | 冲抵（关联报销单） |
| GET | /api/expenses/loans/overdue | 逾期借款列表 |

### 5. 发票管理 expense-invoice.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/invoices | 发票列表（?status=&projectId=&type=） |
| GET | /api/expenses/invoices/:invoiceId | 发票详情 |
| POST | /api/expenses/invoices | 录入发票 |
| PUT | /api/expenses/invoices/:invoiceId | 编辑发票 |
| POST | /api/expenses/invoices/:invoiceId/verify | 验真 |
| POST | /api/expenses/invoices/batch-verify | 批量验真 |
| POST | /api/expenses/invoices/:invoiceId/link | 关联单据 |

### 6. 审批日志+待办 expense-approval.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/approval-log | 审批日志（?docType=&docId=） |
| GET | /api/expenses/my-pending | 我的待审批 |

### 7. 项目/中心维度汇总 expense-summary.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/project/:projectId/summary | 项目费用汇总（报销+付款+借款+预算执行率） |
| GET | /api/expenses/site/:siteId/summary | 中心费用汇总（收款+相关报销） |

### 8. 导出 expense-export.js

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/expenses/reports/:reportId/export | 导出报销单 |
| GET | /api/expenses/payments/:paymentId/export | 导出付款单 |

---

## 三、路由文件结构

```
server/routes/
├── budget.js              ← 预算主表CRUD + 列表
├── budget-item.js         ← 预算项明细
├── budget-approval.js     ← 审批流程
├── budget-change.js       ← 预算变更
├── budget-execution.js    ← 执行监控（汇总/趋势/刷新）
├── budget-cost.js         ← 费用记录CRUD（手动录入+查询）
├── budget-labor.js        ← 人工成本（跨timesheet.db+member.db计算）
├── budget-category.js     ← 费用类别字典
├── budget-site.js         ← 中心维度汇总
├── budget-overview.js     ← 全局概览 + 待办
├── budget-export.js       ← 导出
├── expense-report.js      ← 报销单CRUD + 审批
├── expense-item.js        ← 报销明细
├── expense-payment.js     ← 付款单CRUD + 审批 + 确认付款
├── expense-loan.js        ← 借款CRUD + 审批 + 冲抵
├── expense-invoice.js     ← 发票CRUD + 验真 + 关联
├── expense-approval.js    ← 通用审批日志 + 待办
├── expense-summary.js     ← 项目/中心维度汇总
└── expense-export.js      ← 导出
```

---

## 四、三入口筛选规则汇总

| 入口 | 第9号线筛选 | 第10号线筛选 | 权限 |
|------|------------|------------|------|
| 项目中心 | budget_type='PROJECT' AND ref_id=:projectId | project_id = :projectId | 提请+查看+新建 |
| 中心驾驶舱 | cost_record.project_site_id=:siteId | 报销:expense_item.project_site_id=:siteId / 付款:payee_type='SITE' AND payee_id=:siteId | 只读+发起 |
| 综合管理 | 无筛选，全局 | 无筛选，全局 | 审批+监控+全部操作 |

## 五、审批分级规则

**预算审批（第9号线）：**

| 预算类型 | 审批链 |
|---------|--------|
| 项目预算 | PM提交 → 部门经理 → 财务 |
| 部门预算 | 部门负责人提交 → 财务总监 → 总经理 |

**费用审批（第10号线）：**

| 金额范围 | 审批链 |
|---------|--------|
| ≤¥5,000 | 部门经理 → 财务 |
| ¥5,001~¥50,000 | 部门经理 → 财务 → 财务总监 |
| >¥50,000 | 部门经理 → 财务 → CFO → 总经理 |

## 六、跨线联动

1. 第10号线提交报销/付款时自动校验budget_execution，超80%预警，超100%阻断需CFO特批
2. 第10号线审批通过后→写budget.db的cost_record(source_type=AUTO_COST)→刷新budget_execution
3. 借款冲抵闭环：借款→报销→冲抵
4. 发票关联：报销/付款关联发票，发票状态同步为LINKED
