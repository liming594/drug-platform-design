# 审批平台 v2 — SQL 建表脚本

> 在 WO-039 基础上扩展，保留原有5表，新增4表。
> DB: approval.db (better-sqlite3 + WAL)

---

## 一、保留表（结构不变）

### approval_flows — 流程模板
```sql
CREATE TABLE IF NOT EXISTS approval_flows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flow_code TEXT UNIQUE NOT NULL,
  flow_name TEXT NOT NULL,
  description TEXT DEFAULT '',
  module TEXT DEFAULT '',
  route_type TEXT DEFAULT 'linear',        -- v2: linear | conditional
  timeout_hours INTEGER DEFAULT 0,         -- v2: 全流程超时，0=不限
  is_active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  updated_at TEXT DEFAULT (datetime('now', 'localtime'))
);
```

### approval_steps — 步骤定义
```sql
CREATE TABLE IF NOT EXISTS approval_steps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flow_id INTEGER NOT NULL,
  step_order INTEGER NOT NULL,
  step_name TEXT NOT NULL,
  approver_role TEXT NOT NULL,
  approver_type TEXT DEFAULT 'single_role', -- v2: single_role | dynamic_report | dynamic_dept | dynamic_pm | applicant
  approval_type TEXT DEFAULT 'single',     -- v2: single | countersign
  action_type TEXT DEFAULT 'approve',      -- approve | notify
  branch_group TEXT DEFAULT NULL,          -- v2: 分支组标识（同组互斥）
  condition_field TEXT DEFAULT NULL,       -- v2: amount | business_type
  condition_op TEXT DEFAULT NULL,          -- v2: eq | gt | gte | lt | lte | in
  condition_value TEXT DEFAULT NULL,       -- v2: 条件值
  is_required INTEGER DEFAULT 1,
  timeout_hours INTEGER DEFAULT 0,         -- v2: 单步超时，0=不限
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  updated_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (flow_id) REFERENCES approval_flows(id)
);
```

### approval_instances — 审批实例
```sql
CREATE TABLE IF NOT EXISTS approval_instances (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flow_id INTEGER NOT NULL,
  flow_version_id INTEGER DEFAULT NULL,    -- v2: 流程版本ID
  instance_no TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  module TEXT DEFAULT '',
  business_id TEXT DEFAULT '',
  business_type TEXT DEFAULT '',
  applicant_id TEXT NOT NULL,
  applicant_name TEXT DEFAULT '',
  amount REAL DEFAULT 0,
  summary TEXT DEFAULT '',
  form_data TEXT DEFAULT '{}',             -- v2: JSON 原始表单数据
  status TEXT DEFAULT 'pending',           -- pending | approved | rejected | cancelled
  resubmit_count INTEGER DEFAULT 0,        -- v2: 重新提交次数
  callback_url TEXT DEFAULT '',            -- v2: 审批完成回调地址
  cc_users TEXT DEFAULT '[]',             -- v2: 抄送人列表 JSON
  attachments TEXT DEFAULT '[]',          -- v2: 实例附件 JSON
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  updated_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (flow_id) REFERENCES approval_flows(id)
);
```

> **v2 去掉 current_step 字段**：当前步骤从 instance_steps 动态推导（status='pending' 且 step_order 最小）。

### approval_logs — 审批记录
```sql
CREATE TABLE IF NOT EXISTS approval_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  instance_id INTEGER NOT NULL,
  step_order INTEGER NOT NULL,
  step_name TEXT NOT NULL,
  approver_role TEXT NOT NULL,
  approver_id TEXT DEFAULT '',
  approver_name TEXT DEFAULT '',
  action TEXT NOT NULL,                    -- approved | rejected | withdrawn | transferred | escalated | auto_approved | auto_rejected | countersign_voted
  comment TEXT DEFAULT '',
  resubmit_seq INTEGER DEFAULT 0,         -- v2: 对应第几次提交，0=首次
  attachments TEXT DEFAULT '[]',          -- v2: 审批附件 JSON
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (instance_id) REFERENCES approval_instances(id)
);
```

### approval_logs — 索引说明
> resubmit_seq 支持按提交轮次分组查看审批记录；attachments 支持审批时上传修改意见等文件。

### approval_role_users — 角色映射
```sql
CREATE TABLE IF NOT EXISTS approval_role_users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role_code TEXT NOT NULL,
  role_name TEXT NOT NULL,
  user_id TEXT NOT NULL,
  user_name TEXT DEFAULT '',
  is_active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  updated_at TEXT DEFAULT (datetime('now', 'localtime')),
  UNIQUE(role_code, user_id)
);
```

---

## 二、v2 新增表

### approval_instance_steps — 实例步骤快照
> 创建实例时根据条件路由解析出实际步骤，冻结存储。resubmit 时旧步骤保留（status=skipped），新建一套步骤。
```sql
CREATE TABLE IF NOT EXISTS approval_instance_steps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  instance_id INTEGER NOT NULL,
  resubmit_seq INTEGER DEFAULT 0,          -- v2: 第几次提交，0=首次
  step_order INTEGER NOT NULL,
  step_name TEXT NOT NULL,
  approver_role TEXT NOT NULL,
  approver_type TEXT DEFAULT 'single_role', -- v2: single_role | dynamic_report | dynamic_dept | dynamic_pm | applicant
  approval_type TEXT DEFAULT 'single',     -- single | countersign
  status TEXT DEFAULT 'pending',           -- pending | approved | rejected | skipped
  actual_approver_id TEXT DEFAULT '',
  actual_approver_name TEXT DEFAULT '',
  comment TEXT DEFAULT '',
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  updated_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (instance_id) REFERENCES approval_instances(id)
);
```

### approval_countersign_votes — 会签投票
```sql
CREATE TABLE IF NOT EXISTS approval_countersign_votes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  instance_step_id INTEGER NOT NULL,
  approver_id TEXT NOT NULL,
  approver_name TEXT DEFAULT '',
  vote TEXT NOT NULL,                      -- approved | rejected
  comment TEXT DEFAULT '',
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (instance_step_id) REFERENCES approval_instance_steps(id)
);
```

### approval_delegations — 审批委托
```sql
CREATE TABLE IF NOT EXISTS approval_delegations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  delegator_id TEXT NOT NULL,
  delegator_name TEXT DEFAULT '',
  delegate_id TEXT NOT NULL,
  delegate_name TEXT DEFAULT '',
  role_code TEXT DEFAULT '',               -- 空=全部角色
  start_date TEXT NOT NULL,                -- YYYY-MM-DD
  end_date TEXT NOT NULL,                  -- YYYY-MM-DD
  is_active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime'))
);
```

### approval_escalations — 超时升级规则
```sql
CREATE TABLE IF NOT EXISTS approval_escalations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flow_id INTEGER NOT NULL,
  step_order INTEGER NOT NULL,
  timeout_hours INTEGER NOT NULL,
  escalate_to_role TEXT NOT NULL,
  auto_action TEXT DEFAULT 'escalate',     -- escalate | auto_approve | auto_reject
  is_active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (flow_id) REFERENCES approval_flows(id)
);
```

### approval_callback_logs — 回调日志（v2 新增）
> 审批终态回调业务模块的执行记录，支持3次重试。
```sql
CREATE TABLE IF NOT EXISTS approval_callback_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  instance_id INTEGER NOT NULL,
  callback_url TEXT NOT NULL,
  request_body TEXT DEFAULT '',
  response_status INTEGER DEFAULT 0,
  response_body TEXT DEFAULT '',
  attempt INTEGER DEFAULT 1,               -- 第几次尝试（1-3）
  status TEXT DEFAULT 'pending',           -- pending | success | failed
  next_retry_at TEXT DEFAULT NULL,         -- 下次重试时间
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (instance_id) REFERENCES approval_instances(id)
);
```

### approval_flow_versions — 流程版本（v2 新增）
> 每次发布模板生成新版本，实例关联版本而非模板本身。
```sql
CREATE TABLE IF NOT EXISTS approval_flow_versions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  flow_id INTEGER NOT NULL,
  version_no INTEGER NOT NULL,
  steps_snapshot TEXT NOT NULL,            -- 步骤定义快照 JSON
  published_by TEXT DEFAULT '',
  published_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (flow_id) REFERENCES approval_flows(id),
  UNIQUE(flow_id, version_no)
);
```

### approval_notifications — 审批通知（v2 新增）
> 步骤到达/审批完成时生成通知，对接企微/站内信。
```sql
CREATE TABLE IF NOT EXISTS approval_notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  instance_id INTEGER NOT NULL,
  instance_step_id INTEGER DEFAULT NULL,
  type TEXT NOT NULL,                     -- step_arrived | approved | rejected | cc
  target_user_id TEXT NOT NULL,
  channel TEXT DEFAULT 'site',            -- site | wework | email
  title TEXT DEFAULT '',
  content TEXT DEFAULT '',
  is_read INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (instance_id) REFERENCES approval_instances(id)
);
```

---

## 三、索引

```sql
CREATE INDEX IF NOT EXISTS idx_flows_code ON approval_flows(flow_code);
CREATE INDEX IF NOT EXISTS idx_flows_module ON approval_flows(module);
CREATE INDEX IF NOT EXISTS idx_steps_flow ON approval_steps(flow_id);
CREATE INDEX IF NOT EXISTS idx_instances_flow ON approval_instances(flow_id);
CREATE INDEX IF NOT EXISTS idx_instances_status ON approval_instances(status);
CREATE INDEX IF NOT EXISTS idx_instances_applicant ON approval_instances(applicant_id);
CREATE INDEX IF NOT EXISTS idx_instances_business ON approval_instances(business_id, business_type);
CREATE INDEX IF NOT EXISTS idx_logs_instance ON approval_logs(instance_id);
CREATE INDEX IF NOT EXISTS idx_role_users_role ON approval_role_users(role_code);
CREATE INDEX IF NOT EXISTS idx_instance_steps_instance ON approval_instance_steps(instance_id);
CREATE INDEX IF NOT EXISTS idx_instance_steps_status ON approval_instance_steps(status);
CREATE INDEX IF NOT EXISTS idx_instance_steps_seq ON approval_instance_steps(instance_id, resubmit_seq);
CREATE INDEX IF NOT EXISTS idx_countersign_step ON approval_countersign_votes(instance_step_id);
CREATE INDEX IF NOT EXISTS idx_delegations_delegator ON approval_delegations(delegator_id);
CREATE INDEX IF NOT EXISTS idx_delegations_active ON approval_delegations(is_active);
CREATE INDEX IF NOT EXISTS idx_escalations_flow ON approval_escalations(flow_id);
CREATE INDEX IF NOT EXISTS idx_callback_logs_instance ON approval_callback_logs(instance_id);
CREATE INDEX IF NOT EXISTS idx_callback_logs_status ON approval_callback_logs(status);
CREATE INDEX IF NOT EXISTS idx_callback_logs_retry ON approval_callback_logs(status, next_retry_at);
CREATE INDEX IF NOT EXISTS idx_logs_resubmit ON approval_logs(instance_id, resubmit_seq);
CREATE INDEX IF NOT EXISTS idx_flow_versions_flow ON approval_flow_versions(flow_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON approval_notifications(target_user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_instance ON approval_notifications(instance_id);
CREATE INDEX IF NOT EXISTS idx_instances_version ON approval_instances(flow_version_id);
```

---

## 四、v2 预置数据

### 4.1 预置角色映射（覆盖 WO-039 6个 + 新增2个）
```sql
INSERT OR IGNORE INTO approval_role_users (role_code, role_name, user_id, user_name) VALUES
  ('project_manager', '项目经理', 'admin', '管理员'),
  ('finance_manager', '财务经理', 'admin', '管理员'),
  ('department_head', '部门负责人', 'admin', '管理员'),
  ('admin_manager', '行政管理', 'admin', '管理员'),
  ('vp', '副总', 'admin', '管理员'),
  ('gm', '总经理', 'admin', '管理员'),
  ('cfo', '财务总监', 'admin', '管理员'),
  ('legal', '法务', 'admin', '管理员');
```

### 4.2 预置流程模板（6个）

**1. 预算审批（条件路由，金额分级）**
```sql
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours)
VALUES ('budget_approval', '预算审批', '项目/部门预算审批', 'budget', 'conditional', 72);

-- flow_id 设为1
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  (1, 1, '项目经理审核', 'project_manager', 'single_role', 'single', NULL, NULL, NULL),
  (1, 2, '财务审核', 'finance_manager', 'single_role', 'single', NULL, NULL, NULL),
  (1, 3, '财务总监审核', 'cfo', 'single_role', 'single', 'amount', 'gt', '50000'),
  (1, 4, '总经理审核', 'gm', 'single_role', 'single', 'amount', 'gt', '500000');
```

**2. 费用审批（条件路由，金额分级 + 动态审批人）**
```sql
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours)
VALUES ('payment_approval', '费用审批', '报销/付款审批', 'expense', 'conditional', 72);

INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  (2, 1, '直属上级审核', 'report_to', 'dynamic_report', 'single', NULL, NULL, NULL),
  (2, 2, '财务审核', 'finance_manager', 'single_role', 'single', NULL, NULL, NULL),
  (2, 3, '财务总监审核', 'cfo', 'single_role', 'single', 'amount', 'gt', '50000'),
  (2, 4, '总经理审核', 'gm', 'single_role', 'single', 'amount', 'gt', '500000');
```

**3. 合同审批（条件路由，金额分级 + 法务会签）**
```sql
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours)
VALUES ('contract_approval', '合同审批', '合同签订审批', 'contract', 'conditional', 120);

INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  (3, 1, '项目经理审核', 'project_manager', 'single_role', 'single', NULL, NULL, NULL),
  (3, 2, '财务审核', 'finance_manager', 'single_role', 'single', NULL, NULL, NULL),
  (3, 3, '法务审核', 'legal', 'single_role', 'countersign', NULL, NULL, NULL),
  (3, 4, '财务总监审核', 'cfo', 'single_role', 'single', 'amount', 'gt', '50000'),
  (3, 5, '总经理审核', 'gm', 'single_role', 'single', NULL, NULL, NULL);
```

**4. 出差审批（线性 + 动态审批人）**
```sql
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours)
VALUES ('travel_approval', '出差审批', '员工出差申请', 'travel', 'linear', 48);

INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  (4, 1, '直属上级审核', 'report_to', 'dynamic_report', 'single'),
  (4, 2, '副总审批', 'vp', 'single_role', 'single');
```

**5. 盖章审批（条件路由，分类分叉 + branch_group 互斥）**
```sql
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours)
VALUES ('seal_approval', '盖章审批', '用印申请审批', 'seal', 'conditional', 48);

INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, branch_group, condition_field, condition_op, condition_value) VALUES
  (5, 1, '项目经理审核', 'project_manager', 'single_role', 'single', 'branch_A', 'business_type', 'eq', 'PROJECT'),
  (5, 1, '部门经理审核', 'department_head', 'single_role', 'single', 'branch_A', 'business_type', 'eq', 'NON_PROJECT'),
  (5, 2, '法务审核', 'legal', 'single_role', 'single', NULL, NULL, NULL, NULL),
  (5, 3, '总经理审核', 'gm', 'single_role', 'single', NULL, 'amount', 'gt', '500000');
```

**6. 人事审批（线性 + 动态审批人）**
```sql
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours)
VALUES ('hr_approval', '人事审批', '调岗/调薪/入职/离职', 'hr', 'linear', 72);

INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  (6, 1, '部门负责人审核', 'dept_head', 'dynamic_dept', 'single'),
  (6, 2, 'HR审核', 'admin_manager', 'single_role', 'single'),
  (6, 3, '总经理审批', 'gm', 'single_role', 'single');
```

---

## 五、v2 迁移 SQL（从 WO-039 升级）

```sql
-- 1. 添加新字段
ALTER TABLE approval_flows ADD COLUMN route_type TEXT DEFAULT 'linear';
ALTER TABLE approval_flows ADD COLUMN timeout_hours INTEGER DEFAULT 0;
ALTER TABLE approval_steps ADD COLUMN approval_type TEXT DEFAULT 'single';
ALTER TABLE approval_steps ADD COLUMN approver_type TEXT DEFAULT 'single_role';
ALTER TABLE approval_steps ADD COLUMN branch_group TEXT DEFAULT NULL;
ALTER TABLE approval_steps ADD COLUMN condition_field TEXT DEFAULT NULL;
ALTER TABLE approval_steps ADD COLUMN condition_op TEXT DEFAULT NULL;
ALTER TABLE approval_steps ADD COLUMN condition_value TEXT DEFAULT NULL;
ALTER TABLE approval_steps ADD COLUMN timeout_hours INTEGER DEFAULT 0;
ALTER TABLE approval_instances ADD COLUMN form_data TEXT DEFAULT '{}';
ALTER TABLE approval_instances ADD COLUMN resubmit_count INTEGER DEFAULT 0;
ALTER TABLE approval_instances ADD COLUMN callback_url TEXT DEFAULT '';
ALTER TABLE approval_instances ADD COLUMN flow_version_id INTEGER DEFAULT NULL;
ALTER TABLE approval_instances ADD COLUMN cc_users TEXT DEFAULT '[]';
ALTER TABLE approval_instances ADD COLUMN attachments TEXT DEFAULT '[]';
ALTER TABLE approval_logs ADD COLUMN resubmit_seq INTEGER DEFAULT 0;
ALTER TABLE approval_logs ADD COLUMN attachments TEXT DEFAULT '[]';

-- 2. 创建新表
-- (执行上方 CREATE TABLE IF NOT EXISTS 即可，含 instance_steps/countersign_votes/delegations/escalations/callback_logs/flow_versions/notifications)

-- 3. 为已有流程设置默认值
UPDATE approval_flows SET route_type = 'linear' WHERE route_type IS NULL;
UPDATE approval_steps SET approval_type = 'single' WHERE approval_type IS NULL;

-- 4. 补充预置角色
INSERT OR IGNORE INTO approval_role_users (role_code, role_name, user_id, user_name) VALUES
  ('cfo', '财务总监', 'admin', '管理员'),
  ('legal', '法务', 'admin', '管理员');
```
