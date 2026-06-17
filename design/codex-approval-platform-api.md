# 审批平台 v2 — API 路由规范

> 基于 WO-039 15个API扩展，新增18个API + v2.1新增5个，共38个。
> 路由前缀: `/api/approval/` | 错误码段: 40101-40199
> DB: approval.db（12表：5表保留 + 7表新增 instance_steps/countersign_votes/delegations/escalations/callback_logs/flow_versions/notifications）

---

## 一、API 总览

### 流程模板管理（8个，WO-039 保留5个 + v2.1新增3个）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 1 | GET | /api/approval/flows | 流程列表（支持 module/is_active/category/subcategory/company_id 筛选） |
| 2 | GET | /api/approval/flows/:id | 流程详情 + 步骤 |
| 3 | POST | /api/approval/flows | 新建流程 + 步骤 |
| 4 | PUT | /api/approval/flows/:id | 更新流程 |
| 5 | DELETE | /api/approval/flows/:id | 删除流程（有实例则软删除） |
| 6 | GET | /api/approval/flows/categories | **v2.1新增** 查询流程分类树 |
| 7 | GET | /api/approval/flows/by-company | **v2.1新增** 按公司筛选流程 |
| 8 | GET | /api/approval/flows/apply-entry | **v2.1新增** 新建申请入口 |

### 角色映射（4个，WO-039 保留3个 + 新增1个）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 9 | GET | /api/approval/roles | 角色列表（按角色分组） |
| 10 | POST | /api/approval/roles | 设置角色用户 |
| 11 | DELETE | /api/approval/roles/:id | 移除角色用户映射 |
| 12 | GET | /api/approval/roles/users/:role_code | **v2新增** 获取某角色的所有用户 |

### 审批实例操作（8个，WO-039 保留6个 + 新增2个）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 13 | POST | /api/approval/instances | 提交审批（v2增强条件路由，v2.1增加flow_no/project_id/company_id） |
| 14 | GET | /api/approval/instances/pending | 待我审批（含委托穿透） |
| 15 | GET | /api/approval/instances/my | 我发起的 |
| 16 | GET | /api/approval/instances/:id | 实例详情 + 步骤快照 + 日志 |
| 17 | POST | /api/approval/instances/:id/action | 通过/驳回/转交 |
| 18 | POST | /api/approval/instances/:id/withdraw | 撤回（v2不终结，允许重提） |
| 19 | POST | /api/approval/instances/:id/resubmit | **v2新增** 撤回后重新提交 |
| 20 | POST | /api/approval/instances/submit-from-module | **v2.1新增** 业务模块统一提交接口 |

### 会签投票（2个，v2新增）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 21 | POST | /api/approval/instances/:id/vote | 会签节点投票 |
| 22 | GET | /api/approval/instances/:id/votes/:stepOrder | 查看会签投票详情 |

### 审批委托（3个，v2新增）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 23 | GET | /api/approval/delegations | 委托列表 |
| 24 | POST | /api/approval/delegations | 创建委托 |
| 25 | DELETE | /api/approval/delegations/:id | 取消委托 |

### 超时升级（2个，v2新增）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 26 | GET | /api/approval/escalations | 升级规则列表 |
| 27 | POST | /api/approval/escalations | 创建升级规则 |

### 统计与查询（4个，WO-039 保留1个 + 新增3个）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 28 | GET | /api/approval/stats | 审批统计 |
| 29 | GET | /api/approval/stats/efficiency | **v2新增** 审批效率统计（平均耗时/超时率） |
| 30 | GET | /api/approval/instances/query | **v2新增，v2.1增强** 高级组合查询（新增flow_no/category筛选） |
| 31 | GET | /api/approval/stats/by-category | **v2.1新增** 按分类统计 |

### 流程版本（2个，v2新增）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 32 | GET | /api/approval/flows/:id/versions | 流程版本列表 |
| 33 | POST | /api/approval/flows/:id/publish | 发布流程（生成新版本） |

### 加签/减签（2个，v2新增）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 34 | POST | /api/approval/instances/:id/add-signer | 加签（追加审批人） |
| 35 | POST | /api/approval/instances/:id/remove-signer | 减签（仅会签步骤） |

### 通知（2个，v2新增）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 36 | GET | /api/approval/notifications | 我的通知列表 |
| 37 | PUT | /api/approval/notifications/:id/read | 标记已读 |

### 抄送（1个，v2新增）
| # | 方法 | 路径 | 说明 |
|---|------|------|------|
| 38 | GET | /api/approval/instances/cc | 抄送给我 |

---

## 二、v2 / v2.1 新增/变更 API 详细规范

### API-1: GET /api/approval/flows（v2.1 增强）
流程列表。v2.1 新增 category/subcategory/company_id 筛选参数，响应增加分类与适用公司字段。

**请求：**
```
GET /api/approval/flows
  ?module=expense
  &is_active=1
  &category=PROJECT          ← v2.1新增：项目类/部门类筛选
  &subcategory=progress      ← v2.1新增：二级分类筛选
  &company_id=兴德通          ← v2.1新增：按适用公司筛选
```

**响应（v2.1 增强字段）：**
```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "id": 1,
        "flow_code": "AP-PRJ-001",
        "flow_name": "项目进度审批",
        "flow_category": "PROJECT",
        "flow_subcategory": "progress",
        "applicable_companies": ["兴德通", "泰德"],
        "source_modules": ["project", "timesheet"],
        "route_type": "conditional",
        "is_active": 1,
        "step_count": 3
      }
    ]
  }
}
```

> **v2.1 增强说明：** 响应中新增 `flow_category`（项目类/部门类）、`flow_subcategory`（二级分类code）、`applicable_companies`（适用公司列表，为空表示全公司适用）、`source_modules`（来源业务模块列表）。

---

### API-3: POST /api/approval/flows（v2.1 增强）
新建流程 + 步骤。v2.1 新增 flow_category/flow_subcategory/applicable_companies/source_modules 字段，flow_code 自动生成。

**请求（v2.1 增强字段）：**
```json
{
  "flow_name": "项目工时审批",
  "flow_category": "PROJECT",
  "flow_subcategory": "timesheet",
  "applicable_companies": ["兴德通"],
  "source_modules": ["timesheet"],
  "route_type": "linear",
  "steps": [
    { "step_name": "项目经理审核", "approver_type": "dynamic_pm", "approval_type": "single", "step_order": 1 },
    { "step_name": "部门负责人审核", "approver_type": "dynamic_dept", "approval_type": "single", "step_order": 2 }
  ]
}
```

> **v2.1 增强说明：**
> - 请求体新增 `flow_category`（PROJECT/DEPT）、`flow_subcategory`（二级分类code）、`applicable_companies`（适用公司列表，为空表示全公司适用）、`source_modules`（来源业务模块列表）。
> - `flow_code` 自动生成规则：`AP-{PRJ|DEPT}-{3位序号}`，其中 PRJ 对应 flow_category=PROJECT，DEPT 对应 flow_category=DEPT，序号按同类流程自增。例如：AP-PRJ-001、AP-DEPT-001。

---

### API-6: GET /api/approval/flows/categories（v2.1 新增）
查询流程分类树，返回项目类/部门类→二级分类的树形结构，每个分类下含流程数量。

**请求：** `GET /api/approval/flows/categories`

**响应：**
```json
{
  "code": 0,
  "data": {
    "categories": [
      {
        "category": "PROJECT",
        "label": "项目类流程",
        "subcategories": [
          { "code": "progress", "label": "进度", "flow_count": 2 },
          { "code": "timesheet", "label": "工时", "flow_count": 1 },
          { "code": "center", "label": "中心", "flow_count": 3 }
        ]
      },
      {
        "category": "DEPT",
        "label": "部门类流程",
        "subcategories": [
          { "code": "seal", "label": "印章/证照", "flow_count": 2 },
          { "code": "expense", "label": "费用/报销", "flow_count": 3 },
          { "code": "personnel", "label": "人事", "flow_count": 1 }
        ]
      }
    ]
  }
}
```

---

### API-7: GET /api/approval/flows/by-company（v2.1 新增）
按公司筛选流程。返回该公司适用的流程列表，applicable_companies 为空的流程也会返回（表示全公司适用）。

**请求：**
```
GET /api/approval/flows/by-company
  ?company_id=兴德通
  &category=PROJECT
```

**Query 参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| company_id | 是 | 公司标识 |
| category | 否 | 分类筛选（PROJECT/DEPT） |

**响应：**
```json
{
  "code": 0,
  "data": {
    "company_id": "兴德通",
    "list": [
      {
        "id": 1,
        "flow_code": "AP-PRJ-001",
        "flow_name": "项目进度审批",
        "flow_category": "PROJECT",
        "flow_subcategory": "progress",
        "applicable_companies": ["兴德通", "泰德"],
        "step_count": 3,
        "is_active": 1
      },
      {
        "id": 5,
        "flow_code": "AP-PRJ-005",
        "flow_name": "通用合同审批",
        "flow_category": "PROJECT",
        "flow_subcategory": "contract",
        "applicable_companies": [],
        "step_count": 4,
        "is_active": 1
      }
    ]
  }
}
```

---

### API-8: GET /api/approval/flows/apply-entry（v2.1 新增）
新建申请入口。返回按大类分组的可申请流程，用于"新建申请"Tab 展示。

**请求：** `GET /api/approval/flows/apply-entry`

**响应：**
```json
{
  "code": 0,
  "data": {
    "groups": [
      {
        "icon": "📋",
        "title": "印章/证照申请",
        "flow_nos": ["AP-PRJ-004", "AP-DEPT-004", "AP-DEPT-005"],
        "flows": [
          { "flow_no": "AP-PRJ-004", "flow_name": "项目印章审批", "flow_category": "PROJECT" },
          { "flow_no": "AP-DEPT-004", "flow_name": "证照借用审批", "flow_category": "DEPT" },
          { "flow_no": "AP-DEPT-005", "flow_name": "证照复印审批", "flow_category": "DEPT" }
        ]
      },
      {
        "icon": "💰",
        "title": "借款/用款/报销",
        "flow_nos": ["AP-PRJ-003", "AP-DEPT-003", "AP-DEPT-007", "AP-DEPT-008"],
        "flows": [
          { "flow_no": "AP-PRJ-003", "flow_name": "项目用款审批", "flow_category": "PROJECT" },
          { "flow_no": "AP-DEPT-003", "flow_name": "部门报销审批", "flow_category": "DEPT" },
          { "flow_no": "AP-DEPT-007", "flow_name": "借款审批", "flow_category": "DEPT" },
          { "flow_no": "AP-DEPT-008", "flow_name": "还款审批", "flow_category": "DEPT" }
        ]
      }
    ]
  }
}
```

---

### API-12: GET /api/approval/roles/users/:role_code
获取某角色的所有映射用户，用于审批人选择和权限判断。

**请求：** `GET /api/approval/roles/users/project_manager`

**响应：**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "role_code": "project_manager",
    "role_name": "项目经理",
    "users": [
      { "user_id": "admin", "user_name": "管理员" },
      { "user_id": "zhangsan", "user_name": "张三" }
    ]
  }
}
```

---

### API-13: POST /api/approval/instances（v2 增强版，v2.1 增强字段）
提交审批。v2 核心变更：根据 flow 的 route_type 和 steps 的 condition_* 字段，自动解析实际步骤序列，写入 approval_instance_steps 快照。v2.1 新增 flow_no/project_id/company_id 字段，instance_no 生成规则改为含流程编号前缀。

**请求：**
```json
{
  "flow_code": "seal_approval",
  "flow_no": "AP-PRJ-004",
  "title": "XX项目合同盖章申请",
  "business_id": "SEAL-042",
  "business_type": "PROJECT",
  "project_id": "PRJ-001",
  "company_id": "兴德通",
  "applicant_id": "zhangsan",
  "applicant_name": "张三",
  "amount": 30000,
  "summary": "申办方合同需加盖公章",
  "form_data": { "project_id": "PJ-001", "seal_type": "公章", "copies": 2 },
  "callback_url": "https://test.sinocro.cn/api/seal/callback/approval",
  "cc_users": [{ "user_id": "wangwu", "user_name": "王五" }],
  "attachments": [{ "name": "合同扫描件.pdf", "url": "/uploads/seal/contract.pdf" }]
}
```

> **v2.1 增强字段：** `flow_no`（流程编号，如 AP-PRJ-004）、`project_id`（关联项目ID）、`company_id`（所属公司）。

**响应：**
```json
{
  "code": 0,
  "message": "Approval submitted",
  "data": {
    "id": 42,
    "instance_no": "AP-PRJ-004-20260617-001",
    "title": "XX项目合同盖章申请",
    "status": "pending",
    "total_steps": 3,
    "steps": [
      { "step_order": 1, "step_name": "项目经理审核", "approver_role": "project_manager", "approval_type": "single", "status": "pending" },
      { "step_order": 2, "step_name": "法务审核", "approver_role": "legal", "approval_type": "single", "status": "pending" },
      { "step_order": 3, "step_name": "总经理审核", "approver_role": "gm", "approval_type": "single", "status": "pending" }
    ]
  }
}
```

> **v2.1 变更：** instance_no 生成规则改为 `{flow_no}-{日期}-{序号}`，如 `AP-PRJ-003-20260617-001`（原规则为 `APV-20260617-001`）。

> **current_step 从 instance_steps 动态推导**，不存储在 instances 表中。

**条件路由逻辑：**
```
1. 查 flow.route_type
   - linear → 取全部 steps
   - conditional → 遍历 steps，评估每步的 condition_field/condition_op/condition_value
2. 分支组（branch_group）处理：
   - 同一 step_order + 同一 branch_group 的步骤为互斥分支
   - 互斥分支必须且只能匹配一条，0匹配或>1匹配均拒绝提交
   - branch_group 为空的步骤独立评估，不匹配则跳过（status=skipped）
3. 评估规则：
   - condition_field 为 NULL → 总是包含
   - 用 instance 的对应字段与 condition_value 比较
   - op=eq: field == value
   - op=gt: field > value (数值)
   - op=gte: field >= value
   - op=lt: field < value
   - op=lte: field <= value
   - op=in: value 包含 field（逗号分隔）
4. 按 step_order 排序 → 过滤后的步骤重新连续编号 → 生成 instance_steps 快照
5. 当前步骤从 instance_steps 中 status='pending' 且 step_order 最小的记录动态推导
```

---

### API-17: POST /api/approval/instances/:id/action（v2 增强版）

**请求：**
```json
{
  "action": "approved",
  "approver_id": "admin",
  "approver_name": "管理员",
  "comment": "同意盖章",
  "attachments": []
}
```

**处理逻辑（v2 增强）：**
1. 验证审批人权限（含委托穿透 + approver_type 动态解析）
2. 当前步骤 `approval_type=single` → 直接记录日志，推进
3. 当前步骤 `approval_type=countersign` → 返回错误，引导使用 `/vote` 接口
4. 推进到下一步时：
   - 解析 approver_type 确定审批人（详见第六节"审批人动态解析"）
   - 检查 `approval_type=countersign` → 自动创建投票记录
5. 最后一步通过 → status=approved → 触发 callback + 通知申请人 + 通知抄送人
6. 驳回 → status=rejected → 触发 callback + 通知申请人

---

### API-19: POST /api/approval/instances/:id/resubmit（v2 新增）
撤回后重新提交审批。**不清除旧日志和旧步骤快照**，旧 instance_steps 标记 status=skipped，新建一套步骤快照（resubmit_seq 递增）。

**请求：**
```json
{
  "applicant_id": "zhangsan",
  "form_data": { "amount": 60000 },
  "summary": "修改金额后重新提交"
}
```

**处理逻辑：**
1. 验证实例状态为 cancelled（已撤回）
2. 旧 instance_steps 全部标记 status=skipped（保留审计记录）
3. 旧 approval_logs 保留，通过 resubmit_seq 区分提交轮次
4. 重新解析条件路由，生成新 instance_steps（resubmit_seq +1）
5. instance.status → pending，resubmit_count +1

**响应：**
```json
{
  "code": 0,
  "message": "Instance resubmitted",
  "data": { "id": 42, "status": "pending", "current_step": 1, "resubmit_count": 1 }
}
```

---

### API-20: POST /api/approval/instances/submit-from-module（v2.1 新增）
业务模块统一提交审批接口。各业务模块（合同、报销等）的"提交审批"按钮调用此接口，内部复用 API-13 的条件路由解析逻辑。

**请求：**
```json
{
  "flow_no": "AP-PRJ-005",
  "title": "XX项目合同审批",
  "business_id": "CT-2026-042",
  "business_type": "contract",
  "project_id": "PRJ-001",
  "company_id": "兴德通",
  "amount": 120000,
  "summary": "合同金额12万",
  "form_data": { "contract_type": "申办方合同", "amount": 120000 },
  "callback_url": "https://test.sinocro.cn/api/contract/callback/approval",
  "cc_users": [{ "user_id": "wangwu", "user_name": "王五" }]
}
```

**请求字段说明：**
| 字段 | 必填 | 说明 |
|------|------|------|
| flow_no | 是 | 流程编号，如 AP-PRJ-005 |
| title | 是 | 审批标题 |
| business_id | 是 | 业务单据ID |
| business_type | 是 | 业务类型（contract/expense/seal 等） |
| project_id | 否 | 关联项目ID |
| company_id | 否 | 所属公司 |
| amount | 否 | 金额（用于条件路由） |
| summary | 否 | 摘要 |
| form_data | 否 | 表单数据 |
| callback_url | 否 | 审批完成回调地址 |
| cc_users | 否 | 抄送人列表 |

**响应：**
```json
{
  "code": 0,
  "message": "Approval submitted from module",
  "data": {
    "id": 55,
    "instance_no": "AP-PRJ-005-20260617-001",
    "title": "XX项目合同审批",
    "status": "pending",
    "total_steps": 3,
    "current_step": {
      "step_order": 1,
      "step_name": "项目经理审核",
      "approver_type": "dynamic_pm",
      "actual_approver_id": "zhangsan",
      "actual_approver_name": "张三",
      "approval_type": "single",
      "status": "pending"
    },
    "steps": [
      { "step_order": 1, "step_name": "项目经理审核", "approver_type": "dynamic_pm", "approval_type": "single", "status": "pending" },
      { "step_order": 2, "step_name": "法务审核", "approver_type": "single_role", "approver_role": "legal", "approval_type": "single", "status": "pending" },
      { "step_order": 3, "step_name": "总经理审核", "approver_type": "single_role", "approver_role": "gm", "approval_type": "single", "status": "pending" }
    ]
  }
}
```

> **处理逻辑：** 根据 flow_no 查找流程模板，复用 API-13 的条件路由解析逻辑生成 instance_steps，applicant_id 自动取当前登录用户。响应中返回 instance_no 和审批详情面板数据。

---

### API-21: POST /api/approval/instances/:id/vote（v2 新增）
会签节点投票。

**请求：**
```json
{
  "approver_id": "lisi",
  "approver_name": "李四",
  "vote": "approved",
  "comment": "合同条款无异议"
}
```

**处理逻辑：**
1. 验证当前步骤 approval_type=countersign
2. 验证投票人在 approver_role 映射中
3. 写入 approval_countersign_votes
4. 检查是否全员已投票：
   - 全部 approved → 步骤通过 → 推进
   - 任一 rejected → 步骤驳回 → 实例驳回
   - 否则 → 等待剩余投票

**响应：**
```json
{
  "code": 0,
  "message": "Vote recorded",
  "data": {
    "voted": 2,
    "total": 3,
    "status": "pending",
    "step_completed": false
  }
}
```

---

### API-22: GET /api/approval/instances/:id/votes/:stepOrder（v2 新增）
查看会签投票详情。

**响应：**
```json
{
  "code": 0,
  "data": {
    "step_order": 3,
    "step_name": "法务审核",
    "approval_type": "countersign",
    "status": "pending",
    "required_voters": [
      { "user_id": "lawyer1", "user_name": "王法务", "voted": true, "vote": "approved", "comment": "OK" },
      { "user_id": "lawyer2", "user_name": "李法务", "voted": false, "vote": null, "comment": null }
    ],
    "progress": "1/2"
  }
}
```

---

### API-23/24/25: 审批委托 CRUD

**GET /api/approval/delegations?delegator_id=zhangsan**
```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "id": 1,
        "delegator_name": "张三",
        "delegate_name": "李四",
        "role_code": "project_manager",
        "start_date": "2026-06-17",
        "end_date": "2026-06-24",
        "is_active": 1
      }
    ]
  }
}
```

**POST /api/approval/delegations**
```json
{
  "delegator_id": "zhangsan",
  "delegator_name": "张三",
  "delegate_id": "lisi",
  "delegate_name": "李四",
  "role_code": "project_manager",
  "start_date": "2026-06-17",
  "end_date": "2026-06-24"
}
```

---

### API-28: GET /api/approval/stats（v2 增强）
增加 `pending_for_me` 和超时统计。

```json
{
  "code": 0,
  "data": {
    "pending": 12,
    "approved": 45,
    "rejected": 3,
    "cancelled": 1,
    "total": 61,
    "pending_for_me": 5,
    "overdue_count": 2,
    "avg_hours": 18.5
  }
}
```

---

### API-29: GET /api/approval/stats/efficiency（v2 新增）
审批效率分析，支持按时间范围和模块筛选。

**请求：** `GET /api/approval/stats/efficiency?start=2026-06-01&end=2026-06-30&module=expense`

**响应：**
```json
{
  "code": 0,
  "data": {
    "total_instances": 120,
    "avg_completion_hours": 22.3,
    "median_hours": 16.0,
    "overdue_rate": 0.08,
    "by_module": [
      { "module": "expense", "count": 45, "avg_hours": 15.2 },
      { "module": "contract", "count": 30, "avg_hours": 38.7 }
    ],
    "by_step": [
      { "step_name": "财务审核", "avg_hours": 8.5, "bottleneck": true },
      { "step_name": "总经理审核", "avg_hours": 24.1, "bottleneck": true }
    ]
  }
}
```

---

### API-30: GET /api/approval/instances/query（v2 新增，v2.1 增强）
高级组合查询，替代简单的 pending/my 列表。v2.1 新增 flow_no/category 筛选。

**请求：**
```
GET /api/approval/instances/query
  ?status=pending,approved
  &module=expense,contract
  &business_type=PROJECT
  &applicant_id=zhangsan
  &date_from=2026-06-01
  &date_to=2026-06-30
  &keyword=差旅
  &flow_no=AP-PRJ-003     ← v2.1新增：按流程编号筛选
  &category=PROJECT        ← v2.1新增：按分类筛选（PROJECT/DEPT）
  &page=1
  &size=20
```

**响应：**
```json
{
  "code": 0,
  "data": {
    "list": [...],
    "total": 45,
    "page": 1,
    "size": 20,
    "totalPages": 3
  }
}
```

---

### API-31: GET /api/approval/stats/by-category（v2.1 新增）
按分类统计审批数量分布。返回项目类/部门类→二级分类的审批数量分布。

**请求：**
```
GET /api/approval/stats/by-category
  ?date_from=2026-06-01
  &date_to=2026-06-30
```

**响应：**
```json
{
  "code": 0,
  "data": {
    "categories": [
      {
        "category": "PROJECT",
        "label": "项目类流程",
        "total": 35,
        "subcategories": [
          { "code": "progress", "label": "进度", "count": 15, "pending": 5, "approved": 8, "rejected": 2 },
          { "code": "timesheet", "label": "工时", "count": 8, "pending": 2, "approved": 6, "rejected": 0 },
          { "code": "center", "label": "中心", "count": 12, "pending": 3, "approved": 7, "rejected": 2 }
        ]
      },
      {
        "category": "DEPT",
        "label": "部门类流程",
        "total": 26,
        "subcategories": [
          { "code": "seal", "label": "印章/证照", "count": 10, "pending": 3, "approved": 5, "rejected": 2 },
          { "code": "expense", "label": "费用/报销", "count": 12, "pending": 4, "approved": 6, "rejected": 2 },
          { "code": "personnel", "label": "人事", "count": 4, "pending": 1, "approved": 3, "rejected": 0 }
        ]
      }
    ]
  }
}
```

---

## 三、回调机制

### 触发时机
- 审批通过（最后一步 approved）
- 审批驳回（任一步 rejected）
- 申请人撤回（cancelled）

### 回调格式
```
POST {instance.callback_url}
Content-Type: application/json

{
  "instance_no": "AP-PRJ-004-20260617-001",
  "status": "approved",
  "business_id": "SEAL-042",
  "business_type": "PROJECT",
  "applicant_id": "zhangsan",
  "logs": [
    { "step_order": 1, "step_name": "项目经理审核", "action": "approved", "approver_name": "李四", "comment": "同意" },
    ...
  ],
  "completed_at": "2026-06-17 15:30:00"
}
```

### 重试机制
- 回调失败（非2xx）：记录到 `approval_callback_logs`，3次重试（间隔1min/5min/15min）
- 每次重试更新 attempt 和 next_retry_at
- 3次均失败：status 标记 failed，写入异常日志，通知管理员
- 回调成功：status 标记 success

---

## 四、委托穿透逻辑

获取审批人时执行：
```
function getApprovers(role_code, exclude_delegator = null) {
  1. 查 approval_role_users WHERE role_code=? AND is_active=1 → 基础审批人列表
  2. 对每个审批人，查 approval_delegations WHERE delegator_id=? AND is_active=1
     AND start_date <= today AND end_date >= today
     AND (role_code='' OR role_code=?)
  3. 有生效委托 → 替换为受托人
  4. 返回最终审批人列表
}
```

委托审批时，日志中记录：
- approver_id = 受托人ID
- comment 自动追加 "(代{委托人姓名}审批)"

---

## 五、定时任务：超时扫描

宿主模块：`server/scheduler.js`（node-cron，随 app.js 启动），每15分钟执行：
```
1. 查 approval_instance_steps WHERE status='pending' AND resubmit_seq = (SELECT MAX(resubmit_seq) FROM approval_instance_steps WHERE instance_id=?)
2. 对每步查 approval_escalations WHERE flow_id=? AND step_order=?
3. 计算当前时间 - step.created_at，超过 timeout_hours → 触发
4. auto_action:
   - escalate → 步骤转给 escalate_to_role，写日志 action='escalated'
   - auto_approve → 步骤自动通过，写日志 action='auto_approved'
   - auto_reject → 实例驳回，写日志 action='auto_rejected'
5. 回调重试扫描：查 approval_callback_logs WHERE status='pending' AND next_retry_at <= now → 重试回调
```

---

## 六、审批人动态解析

### 解析时机
创建实例（API-13）和步骤推进（API-17）时，需要确定当前步骤的实际审批人。

### 解析逻辑
```
1. 查 instance_step.approver_type
2. switch (approver_type):
   - single_role → 查 approval_role_users WHERE role_code=step.approver_role AND is_active=1 → 委托穿透 → 返回
   - dynamic_report → 调 admin API GET /api/admin/users/:applicant_id/manager → 返回直属上级
   - dynamic_dept → 调 admin API GET /api/admin/departments/head?userId=:applicant_id → 返回部门负责人
   - dynamic_pm → 调项目 API GET /api/projects/:business_id/members?role=pm → 返回项目PM
   - dynamic_qa → 调项目 API GET /api/projects/:project_id/members?role=qa → 返回项目QA（v2.1新增）
   - applicant → 直接取 instance.applicant_id
3. 解析结果缓存到 instance_step.actual_approver_id
4. 解析失败 → 查 approval_role_users WHERE role_code='fallback_approver' → 无 fallback 则步骤 status=error
```

### approver_type 枚举
| 值 | 说明 | 解析方式 |
|----|------|---------|
| single_role | 固定角色 | 查 role_users 表 |
| dynamic_report | 直属上级 | 调 admin API |
| dynamic_dept | 部门负责人 | 调 admin API |
| dynamic_pm | 项目PM | 调项目 API |
| dynamic_qa | 项目QA | 调项目 API（v2.1新增） |
| applicant | 申请人 | 直接取 applicant_id |

### admin 依赖 API
审批引擎调用平台管理的接口（HTTP跨域，不直接访问admin.db）：
- `GET /api/admin/users/:id/manager` → 返回直属上级
- `GET /api/admin/departments/head?userId=:id` → 返回所在部门负责人

---

## 七、新增 API 详细规范

### API-32: GET /api/approval/flows/:id/versions
流程版本列表。

**响应：**
```json
{
  "code": 0,
  "data": {
    "list": [
      { "id": 3, "version_no": 3, "published_by": "admin", "published_at": "2026-06-17 15:00:00", "step_count": 4 },
      { "id": 2, "version_no": 2, "published_by": "admin", "published_at": "2026-06-15 10:00:00", "step_count": 3 }
    ]
  }
}
```

### API-33: POST /api/approval/flows/:id/publish
发布流程模板，生成新版本。当前草稿步骤快照写入 approval_flow_versions。

**请求：** 无需 body，读取当前 flow + steps 生成快照。

**响应：**
```json
{
  "code": 0,
  "message": "Flow published",
  "data": { "version_id": 3, "version_no": 3 }
}
```

**处理逻辑：**
1. 查 flow 当前 steps → 生成 steps_snapshot JSON
2. version_no = MAX(version_no) + 1
3. 写入 approval_flow_versions
4. 后续创建实例时自动使用最新已发布版本

### API-34: POST /api/approval/instances/:id/add-signer
加签——当前审批人追加一个人来审。

**请求：**
```json
{
  "added_user_id": "wangwu",
  "added_user_name": "王五",
  "reason": "需要法务再看一眼"
}
```

**处理逻辑：**
1. 验证调用人是当前步骤审批人
2. 当前步骤先通过（写日志 action='approved'）
3. 在当前步骤后插入新 instance_step（step_order 插入，后续步骤 +1）
4. 新步骤 approver_type=single_role, actual_approver_id=added_user_id
5. 写日志 action='add_signer'

**响应：**
```json
{
  "code": 0,
  "message": "Signer added",
  "data": { "new_step_order": 2, "added_user_name": "王五" }
}
```

### API-35: POST /api/approval/instances/:id/remove-signer
减签——仅 countersign 步骤支持，移除一个投票人。

**请求：**
```json
{
  "removed_user_id": "zhaoliu",
  "reason": "赵六不相关"
}
```

**处理逻辑：**
1. 验证当前步骤 approval_type=countersign
2. 验证调用人是当前步骤审批人
3. 标记该投票人在 countersign_votes 中 status='excluded'
4. 重新计算投票进度（total - 1）
5. 如果已投票人数已达新的 total → 步骤通过
6. 写日志 action='remove_signer'

**响应：**
```json
{
  "code": 0,
  "message": "Signer removed",
  "data": { "voted": 1, "total": 2, "step_completed": false }
}
```

### API-36: GET /api/approval/notifications
我的审批通知列表。

**请求：** `GET /api/approval/notifications?is_read=0&type=step_arrived&page=1&size=20`

**响应：**
```json
{
  "code": 0,
  "data": {
    "list": [
      { "id": 1, "type": "step_arrived", "title": "您有新的审批待处理", "content": "张三提交了盖章审批", "is_read": 0, "created_at": "2026-06-17 15:00:00" }
    ],
    "unread_count": 5
  }
}
```

### API-37: PUT /api/approval/notifications/:id/read
标记通知已读。

**响应：**
```json
{ "code": 0, "message": "Marked as read" }
```

### API-38: GET /api/approval/instances/cc
抄送给我——终态审批的只读列表。

**请求：** `GET /api/approval/instances/cc?page=1&size=20`

**响应：**
```json
{
  "code": 0,
  "data": {
    "list": [
      { "instance_no": "AP-PRJ-004-20260617-001", "title": "XX项目合同盖章申请", "status": "approved", "applicant_name": "张三", "created_at": "2026-06-17 15:00:00" }
    ]
  }
}
```

---

## 八、通知触发规则

| 触发点 | 通知类型 | 对象 | 写入表 |
|--------|---------|------|--------|
| 创建实例 | step_arrived | 第1步审批人 | approval_notifications |
| 步骤通过/推进 | step_arrived | 下一步审批人 | approval_notifications |
| 实例终态 approved | approved | 申请人 | approval_notifications |
| 实例终态 rejected | rejected | 申请人 | approval_notifications |
| 实例终态 | cc | 抄送人（cc_users） | approval_notifications |
| 超时升级 | step_arrived | 被升级到的审批人 | approval_notifications |

通知渠道按用户偏好配置（默认 site + wework），scheduler.js 中每分钟扫描未读通知并推送企微。