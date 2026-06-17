# 审批平台 v3 — SQL 建表脚本

> 在 v2 基础上扩展，保留原有12表结构，新增分类与公司维度字段，预置流程从6个扩充到22个，预置角色从8个扩充到10个。
> DB: approval.db (better-sqlite3 + WAL)

**统计概览**：12 表 | 132 字段 | 27 索引 | 22 预置流程 | 10 预置角色

---

## 一、保留表（结构增量更新）

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
  flow_category TEXT DEFAULT 'PROJECT',     -- v3: 一级分类 PROJECT(项目类)/DEPT(部门类)
  flow_subcategory TEXT DEFAULT '',         -- v3: 二级分类：进度/工时/中心/合同/用印/预算/采购/质量/行政/通用/HR
  applicable_companies TEXT DEFAULT '[]',   -- v3: 适用公司JSON数组，空数组=全部
  source_modules TEXT DEFAULT '[]',         -- v3: 调用模块JSON数组，如["contract","seal"]
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
  flow_no TEXT DEFAULT '',                  -- v3: 流程编号（从flow的flow_code复制，如AP-PRJ-001）
  instance_no TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  module TEXT DEFAULT '',
  business_id TEXT DEFAULT '',
  business_type TEXT DEFAULT '',
  applicant_id TEXT NOT NULL,
  applicant_name TEXT DEFAULT '',
  company_id TEXT DEFAULT '',               -- v3: 提交所属公司
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
> **v3 新增 flow_no / company_id**：flow_no 冗余存储流程编号便于查询与展示；company_id 支持多公司场景下按公司筛选实例。

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

## 二、v2 新增表（结构不变）

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
CREATE INDEX IF NOT EXISTS idx_flows_category ON approval_flows(flow_category, flow_subcategory);
CREATE INDEX IF NOT EXISTS idx_flows_companies ON approval_flows(applicable_companies);
CREATE INDEX IF NOT EXISTS idx_steps_flow ON approval_steps(flow_id);
CREATE INDEX IF NOT EXISTS idx_instances_flow ON approval_instances(flow_id);
CREATE INDEX IF NOT EXISTS idx_instances_status ON approval_instances(status);
CREATE INDEX IF NOT EXISTS idx_instances_applicant ON approval_instances(applicant_id);
CREATE INDEX IF NOT EXISTS idx_instances_business ON approval_instances(business_id, business_type);
CREATE INDEX IF NOT EXISTS idx_instances_flow_no ON approval_instances(flow_no);
CREATE INDEX IF NOT EXISTS idx_instances_company ON approval_instances(company_id);
CREATE INDEX IF NOT EXISTS idx_instances_version ON approval_instances(flow_version_id);
CREATE INDEX IF NOT EXISTS idx_logs_instance ON approval_logs(instance_id);
CREATE INDEX IF NOT EXISTS idx_logs_resubmit ON approval_logs(instance_id, resubmit_seq);
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
CREATE INDEX IF NOT EXISTS idx_flow_versions_flow ON approval_flow_versions(flow_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON approval_notifications(target_user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_instance ON approval_notifications(instance_id);
```

> **v3 新增索引**：`idx_flows_category`（分类+子分类联合索引）、`idx_flows_companies`（适用公司索引）、`idx_instances_flow_no`（流程编号索引）、`idx_instances_company`（公司索引）。

---

## 四、v3 预置数据

### 4.1 预置角色映射（v2 共8个 + v3 新增2个 = 10个）
```sql
INSERT OR IGNORE INTO approval_role_users (role_code, role_name, user_id, user_name) VALUES
  ('project_manager', '项目经理', 'admin', '管理员'),
  ('finance_manager', '财务经理', 'admin', '管理员'),
  ('department_head', '部门负责人', 'admin', '管理员'),
  ('admin_manager', '行政管理', 'admin', '管理员'),
  ('vp', '副总', 'admin', '管理员'),
  ('gm', '总经理', 'admin', '管理员'),
  ('cfo', '财务总监', 'admin', '管理员'),
  ('legal', '法务', 'admin', '管理员'),
  ('qa_manager', '质量经理', 'admin', '管理员'),
  ('admin_staff', '行政专员', 'admin', '管理员');
```

### 4.2 预置流程模板（v3 共22个）

> **编号体系**：项目类 `AP-PRJ-xxx`，部门类 `AP-DEPT-xxx`
> flow_id 使用子查询引用，不依赖硬编码 ID。

#### 4.2.1 项目类流程（AP-PRJ-001 ~ AP-PRJ-012）

```sql
-- ============================================================
-- 项目类流程 INSERT（12条）
-- ============================================================
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours, flow_category, flow_subcategory, applicable_companies, source_modules) VALUES
  ('AP-PRJ-001', '里程碑调整审批',   '项目里程碑时间调整审批',         'project',     'linear',      48,  'PROJECT', '进度', '[]', '["project"]'),
  ('AP-PRJ-002', '项目状态变更审批', '项目状态暂停/终止/恢复等变更审批', 'project',     'linear',      72,  'PROJECT', '进度', '[]', '["project"]'),
  ('AP-PRJ-003', '项目费用审批',     '项目相关费用报销/支出审批',       'expense',     'conditional', 72,  'PROJECT', '预算', '[]', '["project","expense"]'),
  ('AP-PRJ-004', '项目用印审批',     '项目相关印章使用审批',           'seal',        'conditional', 48,  'PROJECT', '用印', '[]', '["project","seal"]'),
  ('AP-PRJ-005', '项目合同审批',     '项目相关合同签订审批',           'contract',    'conditional', 120, 'PROJECT', '合同', '[]', '["project","contract"]'),
  ('AP-PRJ-006', '项目采购审批',     '项目相关采购申请审批',           'procurement', 'conditional', 72,  'PROJECT', '采购', '[]', '["project","procurement"]'),
  ('AP-PRJ-007', '中心筛选结果审批', '临床试验中心筛选结果确认审批',    'center',      'linear',      48,  'PROJECT', '中心', '[]', '["project","center"]'),
  ('AP-PRJ-008', '中心启动(SIV)审批','临床试验中心启动审批',           'center',      'linear',      48,  'PROJECT', '中心', '[]', '["project","center"]'),
  ('AP-PRJ-009', '中心关闭审批',     '临床试验中心关闭审批',           'center',      'linear',      48,  'PROJECT', '中心', '[]', '["project","center"]'),
  ('AP-PRJ-010', '周工时提交审批',   '项目成员周工时提交审批',         'timesheet',   'linear',      24,  'PROJECT', '工时', '[]', '["project","timesheet"]'),
  ('AP-PRJ-011', '偏差报告审批',     '项目偏差报告审批',              'quality',     'linear',      72,  'PROJECT', '质量', '[]', '["project","quality"]'),
  ('AP-PRJ-012', 'CAPA审批',         '纠正与预防措施审批',            'quality',     'linear',      72,  'PROJECT', '质量', '[]', '["project","quality"]');

-- ============================================================
-- AP-PRJ-001 里程碑调整审批
-- 条件:无 | 步骤:PM→部门负责人→副总
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-001'), 1, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-001'), 2, '部门负责人审核', 'department_head',  'dynamic_dept',  'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-001'), 3, '副总审批',       'vp',               'single_role',   'single');

-- ============================================================
-- AP-PRJ-002 项目状态变更审批
-- 条件:无 | 步骤:PM→部门负责人→副总→GM
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-002'), 1, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-002'), 2, '部门负责人审核', 'department_head',  'dynamic_dept',  'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-002'), 3, '副总审批',       'vp',               'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-002'), 4, '总经理审批',     'gm',               'single_role',   'single');

-- ============================================================
-- AP-PRJ-003 项目费用审批
-- 条件:金额分级 | 步骤:直属上级→财务→CFO(>50K)→GM(>500K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-003'), 1, '直属上级审核',   'report_to',        'dynamic_report', 'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-003'), 2, '财务审核',       'finance_manager',  'single_role',    'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-003'), 3, '财务总监审核',   'cfo',              'single_role',    'single', 'amount', 'gt', '50000'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-003'), 4, '总经理审批',     'gm',               'single_role',    'single', 'amount', 'gt', '500000');

-- ============================================================
-- AP-PRJ-004 项目用印审批
-- 条件:有费/无费分支 | 步骤:PM→财务(有费用)→法务→GM(>500K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-004'), 1, '项目经理审核',   'project_manager',  'single_role',   'single', NULL,            NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-004'), 2, '财务审核',       'finance_manager',  'single_role',   'single', 'business_type', 'eq', 'HAS_COST'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-004'), 3, '法务审核',       'legal',            'single_role',   'single', NULL,            NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-004'), 4, '总经理审批',     'gm',               'single_role',   'single', 'amount',        'gt', '500000');

-- ============================================================
-- AP-PRJ-005 项目合同审批
-- 条件:有费/无费分支 | 步骤:PM→财务(有费用)→法务(会签)→CFO(>50K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-005'), 1, '项目经理审核',   'project_manager',  'single_role',   'single',      NULL,            NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-005'), 2, '财务审核',       'finance_manager',  'single_role',   'single',      'business_type', 'eq', 'HAS_COST'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-005'), 3, '法务审核',       'legal',            'single_role',   'countersign', NULL,            NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-005'), 4, '财务总监审核',   'cfo',              'single_role',   'single',      'amount',        'gt', '50000');

-- ============================================================
-- AP-PRJ-006 项目采购审批
-- 条件:金额分级 | 步骤:PM→财务→CFO(>50K)→GM(>500K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-006'), 1, '项目经理审核',   'project_manager',  'single_role',   'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-006'), 2, '财务审核',       'finance_manager',  'single_role',   'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-006'), 3, '财务总监审核',   'cfo',              'single_role',   'single', 'amount', 'gt', '50000'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-006'), 4, '总经理审批',     'gm',               'single_role',   'single', 'amount', 'gt', '500000');

-- ============================================================
-- AP-PRJ-007 中心筛选结果审批
-- 条件:无 | 步骤:CRA→PM→部门负责人
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-007'), 1, 'CRA审核',        'cra',              'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-007'), 2, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-007'), 3, '部门负责人审核', 'department_head',  'dynamic_dept',  'single');

-- ============================================================
-- AP-PRJ-008 中心启动(SIV)审批
-- 条件:无 | 步骤:PM→QA→部门负责人
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-008'), 1, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-008'), 2, 'QA审核',         'qa_manager',       'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-008'), 3, '部门负责人审核', 'department_head',  'dynamic_dept',  'single');

-- ============================================================
-- AP-PRJ-009 中心关闭审批
-- 条件:无 | 步骤:PM→部门负责人→副总
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-009'), 1, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-009'), 2, '部门负责人审核', 'department_head',  'dynamic_dept',  'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-009'), 3, '副总审批',       'vp',               'single_role',   'single');

-- ============================================================
-- AP-PRJ-010 周工时提交审批
-- 条件:无 | 步骤:PM→部门负责人
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-010'), 1, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-010'), 2, '部门负责人审核', 'department_head',  'dynamic_dept',  'single');

-- ============================================================
-- AP-PRJ-011 偏差报告审批
-- 条件:无 | 步骤:PM→QA→部门负责人→副总
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-011'), 1, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-011'), 2, 'QA审核',         'qa_manager',       'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-011'), 3, '部门负责人审核', 'department_head',  'dynamic_dept',  'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-011'), 4, '副总审批',       'vp',               'single_role',   'single');

-- ============================================================
-- AP-PRJ-012 CAPA审批
-- 条件:无 | 步骤:PM→QA→部门负责人
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-012'), 1, '项目经理审核',   'project_manager',  'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-012'), 2, 'QA审核',         'qa_manager',       'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-PRJ-012'), 3, '部门负责人审核', 'department_head',  'dynamic_dept',  'single');
```

#### 4.2.2 部门类流程（AP-DEPT-001 ~ AP-DEPT-010）

```sql
-- ============================================================
-- 部门类流程 INSERT（10条）
-- ============================================================
INSERT INTO approval_flows (flow_code, flow_name, description, module, route_type, timeout_hours, flow_category, flow_subcategory, applicable_companies, source_modules) VALUES
  ('AP-DEPT-001', '办公资产申领',       '办公设备/资产申领审批',       'asset',       'linear',      48,  'DEPT', '行政', '[]', '["asset"]'),
  ('AP-DEPT-002', '办公用品采购',       '办公用品采购审批',           'procurement', 'conditional', 48,  'DEPT', '采购', '[]', '["procurement"]'),
  ('AP-DEPT-003', '部门费用审批',       '部门相关费用报销/支出审批',    'expense',     'conditional', 72,  'DEPT', '预算', '[]', '["expense"]'),
  ('AP-DEPT-004', '公司印章使用(非项目)','非项目类印章使用审批',        'seal',        'conditional', 48,  'DEPT', '用印', '[]', '["seal"]'),
  ('AP-DEPT-005', '证照借用',           '公司证照/资质借用审批',       'admin',       'linear',      48,  'DEPT', '行政', '[]', '["admin"]'),
  ('AP-DEPT-006', '预算调整审批',       '部门预算调整审批',           'budget',      'conditional', 72,  'DEPT', '预算', '[]', '["budget"]'),
  ('AP-DEPT-007', '借款审批',           '员工借款审批',              'loan',        'conditional', 48,  'DEPT', '预算', '[]', '["expense"]'),
  ('AP-DEPT-008', '付款审批',           '对外付款审批',              'payment',     'conditional', 72,  'DEPT', '预算', '[]', '["payment"]'),
  ('AP-DEPT-009', '通用审批',           '无特定分类的通用审批流程',     'common',      'linear',      48,  'DEPT', '通用', '[]', '["common"]'),
  ('AP-DEPT-010', 'HR类审批',           '调岗/调薪/入职/离职等人事审批', 'hr',         'linear',      72,  'DEPT', 'HR',   '[]', '["hr"]');

-- ============================================================
-- AP-DEPT-001 办公资产申领
-- 条件:无 | 步骤:部门负责人→行政管理
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-001'), 1, '部门负责人审核', 'department_head',  'dynamic_dept',  'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-001'), 2, '行政专员审核',   'admin_staff',      'single_role',   'single');

-- ============================================================
-- AP-DEPT-002 办公用品采购
-- 条件:金额分级 | 步骤:部门负责人→行政→CFO(>50K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-002'), 1, '部门负责人审核', 'department_head',  'dynamic_dept',  'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-002'), 2, '行政专员审核',   'admin_staff',      'single_role',   'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-002'), 3, '财务总监审核',   'cfo',              'single_role',   'single', 'amount', 'gt', '50000');

-- ============================================================
-- AP-DEPT-003 部门费用审批
-- 条件:金额分级 | 步骤:直属上级→财务→CFO(>50K)→GM(>500K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-003'), 1, '直属上级审核',   'report_to',        'dynamic_report', 'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-003'), 2, '财务审核',       'finance_manager',  'single_role',    'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-003'), 3, '财务总监审核',   'cfo',              'single_role',    'single', 'amount', 'gt', '50000'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-003'), 4, '总经理审批',     'gm',               'single_role',    'single', 'amount', 'gt', '500000');

-- ============================================================
-- AP-DEPT-004 公司印章使用(非项目)
-- 条件:金额条件 | 步骤:部门负责人→法务→GM(>500K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-004'), 1, '部门负责人审核', 'department_head',  'dynamic_dept',  'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-004'), 2, '法务审核',       'legal',            'single_role',   'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-004'), 3, '总经理审批',     'gm',               'single_role',   'single', 'amount', 'gt', '500000');

-- ============================================================
-- AP-DEPT-005 证照借用
-- 条件:无 | 步骤:部门负责人→行政管理
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-005'), 1, '部门负责人审核', 'department_head',  'dynamic_dept',  'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-005'), 2, '行政专员审核',   'admin_staff',      'single_role',   'single');

-- ============================================================
-- AP-DEPT-006 预算调整审批
-- 条件:金额分级 | 步骤:部门负责人→财务→CFO(>50K)→GM(>500K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-006'), 1, '部门负责人审核', 'department_head',  'dynamic_dept',  'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-006'), 2, '财务审核',       'finance_manager',  'single_role',   'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-006'), 3, '财务总监审核',   'cfo',              'single_role',   'single', 'amount', 'gt', '50000'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-006'), 4, '总经理审批',     'gm',               'single_role',   'single', 'amount', 'gt', '500000');

-- ============================================================
-- AP-DEPT-007 借款审批
-- 条件:金额分级 | 步骤:直属上级→财务→CFO(>50K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-007'), 1, '直属上级审核',   'report_to',        'dynamic_report', 'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-007'), 2, '财务审核',       'finance_manager',  'single_role',    'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-007'), 3, '财务总监审核',   'cfo',              'single_role',    'single', 'amount', 'gt', '50000');

-- ============================================================
-- AP-DEPT-008 付款审批
-- 条件:金额分级 | 步骤:直属上级→财务→CFO(>50K)→GM(>500K)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type, condition_field, condition_op, condition_value) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-008'), 1, '直属上级审核',   'report_to',        'dynamic_report', 'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-008'), 2, '财务审核',       'finance_manager',  'single_role',    'single', NULL,    NULL, NULL),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-008'), 3, '财务总监审核',   'cfo',              'single_role',    'single', 'amount', 'gt', '50000'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-008'), 4, '总经理审批',     'gm',               'single_role',    'single', 'amount', 'gt', '500000');

-- ============================================================
-- AP-DEPT-009 通用审批
-- 条件:无 | 步骤:直属上级→部门负责人
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-009'), 1, '直属上级审核',   'report_to',        'dynamic_report', 'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-009'), 2, '部门负责人审核', 'department_head',  'dynamic_dept',   'single');

-- ============================================================
-- AP-DEPT-010 HR类审批
-- 条件:无 | 步骤:部门负责人→HR→GM(预留)
-- ============================================================
INSERT INTO approval_steps (flow_id, step_order, step_name, approver_role, approver_type, approval_type) VALUES
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-010'), 1, '部门负责人审核', 'department_head',  'dynamic_dept',  'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-010'), 2, 'HR审核',         'hr',               'single_role',   'single'),
  ((SELECT id FROM approval_flows WHERE flow_code='AP-DEPT-010'), 3, '总经理审批',     'gm',               'single_role',   'single');
```

---

## 五、v3 迁移 SQL（从 v2 升级）

```sql
-- ============================================================
-- 1. approval_flows 新增字段
-- ============================================================
ALTER TABLE approval_flows ADD COLUMN flow_category TEXT DEFAULT 'PROJECT';
ALTER TABLE approval_flows ADD COLUMN flow_subcategory TEXT DEFAULT '';
ALTER TABLE approval_flows ADD COLUMN applicable_companies TEXT DEFAULT '[]';
ALTER TABLE approval_flows ADD COLUMN source_modules TEXT DEFAULT '[]';

-- ============================================================
-- 2. approval_instances 新增字段
-- ============================================================
ALTER TABLE approval_instances ADD COLUMN flow_no TEXT DEFAULT '';
ALTER TABLE approval_instances ADD COLUMN company_id TEXT DEFAULT '';

-- ============================================================
-- 3. 新增索引
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_flows_category ON approval_flows(flow_category, flow_subcategory);
CREATE INDEX IF NOT EXISTS idx_flows_companies ON approval_flows(applicable_companies);
CREATE INDEX IF NOT EXISTS idx_instances_flow_no ON approval_instances(flow_no);
CREATE INDEX IF NOT EXISTS idx_instances_company ON approval_instances(company_id);

-- ============================================================
-- 4. 旧流程 flow_code 迁移映射（旧编码 → 新编码）
-- ============================================================
UPDATE approval_flows SET
  flow_code = 'AP-DEPT-006',
  flow_category = 'DEPT',
  flow_subcategory = '预算',
  source_modules = '["budget"]'
WHERE flow_code = 'budget_approval';

UPDATE approval_flows SET
  flow_code = 'AP-PRJ-003',
  flow_category = 'PROJECT',
  flow_subcategory = '预算',
  source_modules = '["project","expense"]'
WHERE flow_code = 'payment_approval';

UPDATE approval_flows SET
  flow_code = 'AP-PRJ-005',
  flow_category = 'PROJECT',
  flow_subcategory = '合同',
  source_modules = '["project","contract"]'
WHERE flow_code = 'contract_approval';

UPDATE approval_flows SET
  flow_code = 'AP-PRJ-004',
  flow_category = 'PROJECT',
  flow_subcategory = '用印',
  source_modules = '["project","seal"]'
WHERE flow_code = 'seal_approval';

UPDATE approval_flows SET
  flow_code = 'AP-DEPT-010',
  flow_category = 'DEPT',
  flow_subcategory = 'HR',
  source_modules = '["hr"]'
WHERE flow_code = 'hr_approval';

-- travel_approval 无直接映射，建议停用或手动迁移
UPDATE approval_flows SET
  is_active = 0,
  flow_category = 'DEPT',
  flow_subcategory = '通用',
  source_modules = '["travel"]'
WHERE flow_code = 'travel_approval';

-- ============================================================
-- 5. 为已有实例补充 flow_no
-- ============================================================
UPDATE approval_instances SET
  flow_no = (SELECT flow_code FROM approval_flows WHERE approval_flows.id = approval_instances.flow_id)
WHERE flow_no = '' OR flow_no IS NULL;

-- ============================================================
-- 6. 补充已有流程的分类字段
-- ============================================================
UPDATE approval_flows SET flow_category = 'PROJECT' WHERE flow_category IS NULL OR flow_category = '';
UPDATE approval_flows SET flow_subcategory = '通用' WHERE flow_subcategory IS NULL OR flow_subcategory = '' AND flow_category = 'DEPT';
UPDATE approval_flows SET flow_subcategory = '进度' WHERE flow_subcategory IS NULL OR flow_subcategory = '' AND flow_category = 'PROJECT';

-- ============================================================
-- 7. 补充预置角色（v3 新增2个）
-- ============================================================
INSERT OR IGNORE INTO approval_role_users (role_code, role_name, user_id, user_name) VALUES
  ('qa_manager', '质量经理', 'admin', '管理员'),
  ('admin_staff', '行政专员', 'admin', '管理员');

-- ============================================================
-- 8. 插入新增流程（16个，不含上述5个已迁移的旧流程）
--    执行上方 4.2 节完整 INSERT 即可，已有 flow_code UNIQUE 约束保证幂等
-- ============================================================
```

---

## 附录：流程编号速查表

| 编号 | 流程名称 | 分类 | 子分类 | 路由类型 | 步骤数 |
|------|---------|------|--------|---------|-------|
| AP-PRJ-001 | 里程碑调整审批 | 项目 | 进度 | linear | 3 |
| AP-PRJ-002 | 项目状态变更审批 | 项目 | 进度 | linear | 4 |
| AP-PRJ-003 | 项目费用审批 | 项目 | 预算 | conditional | 4 |
| AP-PRJ-004 | 项目用印审批 | 项目 | 用印 | conditional | 4 |
| AP-PRJ-005 | 项目合同审批 | 项目 | 合同 | conditional | 4 |
| AP-PRJ-006 | 项目采购审批 | 项目 | 采购 | conditional | 4 |
| AP-PRJ-007 | 中心筛选结果审批 | 项目 | 中心 | linear | 3 |
| AP-PRJ-008 | 中心启动(SIV)审批 | 项目 | 中心 | linear | 3 |
| AP-PRJ-009 | 中心关闭审批 | 项目 | 中心 | linear | 3 |
| AP-PRJ-010 | 周工时提交审批 | 项目 | 工时 | linear | 2 |
| AP-PRJ-011 | 偏差报告审批 | 项目 | 质量 | linear | 4 |
| AP-PRJ-012 | CAPA审批 | 项目 | 质量 | linear | 3 |
| AP-DEPT-001 | 办公资产申领 | 部门 | 行政 | linear | 2 |
| AP-DEPT-002 | 办公用品采购 | 部门 | 采购 | conditional | 3 |
| AP-DEPT-003 | 部门费用审批 | 部门 | 预算 | conditional | 4 |
| AP-DEPT-004 | 公司印章使用(非项目) | 部门 | 用印 | conditional | 3 |
| AP-DEPT-005 | 证照借用 | 部门 | 行政 | linear | 2 |
| AP-DEPT-006 | 预算调整审批 | 部门 | 预算 | conditional | 4 |
| AP-DEPT-007 | 借款审批 | 部门 | 预算 | conditional | 3 |
| AP-DEPT-008 | 付款审批 | 部门 | 预算 | conditional | 4 |
| AP-DEPT-009 | 通用审批 | 部门 | 通用 | linear | 2 |
| AP-DEPT-010 | HR类审批 | 部门 | HR | linear | 3 |
