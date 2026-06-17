# 平台管理模块 — SQL建表脚本

> 数据库：admin.db（独立库，零耦合）
> 共17表 + 31索引 + 预置数据

---

## 一、建表语句

### 1. admin_users

```sql
CREATE TABLE IF NOT EXISTS admin_users (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  username      TEXT    NOT NULL UNIQUE,
  password_hash TEXT    NOT NULL,
  real_name     TEXT    NOT NULL,
  email         TEXT,
  phone         TEXT,
  avatar        TEXT,
  member_id     INTEGER,  -- 关联HR member表ID，入职时同步写入
  status        TEXT    NOT NULL DEFAULT 'active' CHECK(status IN ('active','disabled','locked')),
  last_login_at TEXT,
  created_at    TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  updated_at    TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE INDEX idx_admin_users_status ON admin_users(status);
CREATE INDEX idx_admin_users_username ON admin_users(username);
CREATE INDEX idx_admin_users_member ON admin_users(member_id);
```

### 2. admin_roles

```sql
CREATE TABLE IF NOT EXISTS admin_roles (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  role_code   TEXT    NOT NULL UNIQUE,
  role_name   TEXT    NOT NULL,
  description TEXT,
  is_system   INTEGER NOT NULL DEFAULT 0,
  status      TEXT    NOT NULL DEFAULT 'active' CHECK(status IN ('active','disabled')),
  created_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  updated_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE INDEX idx_admin_roles_code ON admin_roles(role_code);
CREATE INDEX idx_admin_roles_status ON admin_roles(status);
```

### 3. admin_permissions

```sql
CREATE TABLE IF NOT EXISTS admin_permissions (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  perm_code  TEXT    NOT NULL UNIQUE,
  perm_name  TEXT    NOT NULL,
  perm_type  TEXT    NOT NULL CHECK(perm_type IN ('menu','api','data')),
  parent_id  INTEGER NOT NULL DEFAULT 0,
  path       TEXT,
  method     TEXT,
  icon       TEXT,
  route      TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  status     TEXT    NOT NULL DEFAULT 'active' CHECK(status IN ('active','disabled')),
  created_at TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  FOREIGN KEY(parent_id) REFERENCES admin_permissions(id)
);

CREATE INDEX idx_admin_permissions_type ON admin_permissions(perm_type);
CREATE INDEX idx_admin_permissions_parent ON admin_permissions(parent_id);
CREATE INDEX idx_admin_permissions_code ON admin_permissions(perm_code);
```

### 4. admin_role_permissions

```sql
CREATE TABLE IF NOT EXISTS admin_role_permissions (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  role_id       INTEGER NOT NULL,
  permission_id INTEGER NOT NULL,
  UNIQUE(role_id, permission_id),
  FOREIGN KEY(role_id)       REFERENCES admin_roles(id) ON DELETE CASCADE,
  FOREIGN KEY(permission_id) REFERENCES admin_permissions(id) ON DELETE CASCADE
);

CREATE INDEX idx_admin_rp_role ON admin_role_permissions(role_id);
CREATE INDEX idx_admin_rp_perm ON admin_role_permissions(permission_id);
```

### 5. admin_user_roles

```sql
CREATE TABLE IF NOT EXISTS admin_user_roles (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER NOT NULL,
  role_id     INTEGER NOT NULL,
  role_source TEXT    NOT NULL DEFAULT 'hr' CHECK(role_source IN ('hr','project','admin')),
  project_id  TEXT,
  UNIQUE(user_id, role_id, role_source, COALESCE(project_id, '')),
  FOREIGN KEY(user_id) REFERENCES admin_users(id) ON DELETE CASCADE,
  FOREIGN KEY(role_id) REFERENCES admin_roles(id) ON DELETE CASCADE
);

CREATE INDEX idx_admin_ur_user ON admin_user_roles(user_id);
CREATE INDEX idx_admin_ur_role ON admin_user_roles(role_id);
CREATE INDEX idx_admin_ur_source ON admin_user_roles(role_source);
CREATE INDEX idx_admin_ur_project ON admin_user_roles(project_id);
```

### 6. admin_departments

```sql
CREATE TABLE IF NOT EXISTS admin_departments (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  dept_code      TEXT    NOT NULL UNIQUE,
  dept_name      TEXT    NOT NULL,
  parent_id      INTEGER NOT NULL DEFAULT 0,
  hr_dept_id     INTEGER,  -- 关联HR department表ID
  leader_user_id INTEGER,
  sort_order     INTEGER NOT NULL DEFAULT 0,
  status         TEXT    NOT NULL DEFAULT 'active' CHECK(status IN ('active','disabled')),
  created_at     TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  updated_at     TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  FOREIGN KEY(leader_user_id) REFERENCES admin_users(id)
);

CREATE INDEX idx_admin_dept_parent ON admin_departments(parent_id);
CREATE INDEX idx_admin_dept_code ON admin_departments(dept_code);
CREATE INDEX idx_admin_dept_hr ON admin_departments(hr_dept_id);
```

### 7. admin_dept_users

```sql
CREATE TABLE IF NOT EXISTS admin_dept_users (
  id        INTEGER PRIMARY KEY AUTOINCREMENT,
  dept_id   INTEGER NOT NULL,
  user_id   INTEGER NOT NULL,
  is_primary INTEGER NOT NULL DEFAULT 1,
  UNIQUE(dept_id, user_id),
  FOREIGN KEY(dept_id) REFERENCES admin_departments(id) ON DELETE CASCADE,
  FOREIGN KEY(user_id) REFERENCES admin_users(id) ON DELETE CASCADE
);

CREATE INDEX idx_admin_du_dept ON admin_dept_users(dept_id);
CREATE INDEX idx_admin_du_user ON admin_dept_users(user_id);
CREATE INDEX idx_admin_du_primary ON admin_dept_users(user_id, is_primary);
```

### 8. admin_data_scopes

```sql
CREATE TABLE IF NOT EXISTS admin_data_scopes (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  role_id     INTEGER NOT NULL,
  scope_type  TEXT    NOT NULL CHECK(scope_type IN ('all','dept','dept_sub','self','custom')),
  scope_value TEXT,
  FOREIGN KEY(role_id) REFERENCES admin_roles(id) ON DELETE CASCADE
);

CREATE INDEX idx_admin_scope_role ON admin_data_scopes(role_id);
```

### 9. admin_position_role_mapping（岗位权限配置）

```sql
CREATE TABLE IF NOT EXISTS admin_position_role_mapping (
  id                 INTEGER PRIMARY KEY AUTOINCREMENT,
  position_type      TEXT    NOT NULL,
  is_leader          INTEGER NOT NULL DEFAULT 0,
  role_code          TEXT    NOT NULL,
  accessible_modules TEXT    NOT NULL DEFAULT '[]',  -- JSON数组，该岗位可访问的模块编码列表，如 ["project","center","approval"]
  data_scope         TEXT    NOT NULL DEFAULT 'dept_sub',  -- 数据范围: all/dept/dept_sub/self
  description        TEXT,
  UNIQUE(position_type, is_leader),
  FOREIGN KEY(role_code) REFERENCES admin_roles(role_code)
);

CREATE INDEX idx_admin_prm_position ON admin_position_role_mapping(position_type);
CREATE INDEX idx_admin_prm_role ON admin_position_role_mapping(role_code);
```

**accessible_modules示例：**
```json
// PM岗位
["project", "center", "approval"]
// CRA岗位
["project", "center"]
// 财务岗位
["budget", "expense", "contract"]
```

### 10. admin_data_dict

```sql
CREATE TABLE IF NOT EXISTS admin_data_dict (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  category   TEXT    NOT NULL,
  dict_code  TEXT    NOT NULL,
  value      TEXT    NOT NULL,
  label      TEXT    NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  status     TEXT    NOT NULL DEFAULT 'active' CHECK(status IN ('active','disabled')),
  created_at TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  UNIQUE(category, dict_code)
);

CREATE INDEX idx_admin_dict_category ON admin_data_dict(category);
```

### 11. admin_sys_config

```sql
CREATE TABLE IF NOT EXISTS admin_sys_config (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  config_key  TEXT    NOT NULL UNIQUE,
  config_value TEXT,
  config_type TEXT    NOT NULL DEFAULT 'string' CHECK(config_type IN ('string','number','json','boolean')),
  description TEXT,
  created_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  updated_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE INDEX idx_admin_config_key ON admin_sys_config(config_key);
```

### 12. admin_operation_logs

```sql
CREATE TABLE IF NOT EXISTS admin_operation_logs (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER,
  module      TEXT    NOT NULL,
  action      TEXT    NOT NULL,
  target_type TEXT,
  target_id   TEXT,
  detail      TEXT,
  ip          TEXT,
  user_agent  TEXT,
  created_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE INDEX idx_admin_logs_user ON admin_operation_logs(user_id);
CREATE INDEX idx_admin_logs_module ON admin_operation_logs(module);
CREATE INDEX idx_admin_logs_time ON admin_operation_logs(created_at);
```

### 13. admin_modules

```sql
CREATE TABLE IF NOT EXISTS admin_modules (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  module_code   TEXT    NOT NULL UNIQUE,
  module_name   TEXT    NOT NULL,
  module_type   TEXT    NOT NULL DEFAULT 'business' CHECK(module_type IN ('core','business')),
  base_url      TEXT,
  icon          TEXT,
  sort_order    INTEGER NOT NULL DEFAULT 0,
  status        TEXT    NOT NULL DEFAULT 'active' CHECK(status IN ('active','disabled','maintenance')),
  registered_at TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE INDEX idx_admin_modules_code ON admin_modules(module_code);
CREATE INDEX idx_admin_modules_type ON admin_modules(module_type);
```

### 14. admin_user_preferences

```sql
CREATE TABLE IF NOT EXISTS admin_user_preferences (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id    INTEGER NOT NULL,
  pref_key   TEXT    NOT NULL,
  pref_value TEXT,
  updated_at TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  UNIQUE(user_id, pref_key),
  FOREIGN KEY(user_id) REFERENCES admin_users(id) ON DELETE CASCADE
);

CREATE INDEX idx_admin_pref_user ON admin_user_preferences(user_id);
```

### 15. admin_project_role_mapping（项目岗位权限配置）

```sql
CREATE TABLE IF NOT EXISTS admin_project_role_mapping (
  id                 INTEGER PRIMARY KEY AUTOINCREMENT,
  project_role       TEXT    NOT NULL,          -- 项目内角色: PM/APM/PI/CRA/CRC/DM/...
  allowed_positions  TEXT    NOT NULL DEFAULT '[]',  -- JSON数组，允许担任此项目角色的组织岗位，如 ["CRA","CRC"]
  role_code          TEXT    NOT NULL,          -- 项目内生效的角色编码
  accessible_modules TEXT    NOT NULL DEFAULT '[]',  -- JSON数组，项目内可访问的模块
  data_scope         TEXT    NOT NULL DEFAULT 'project_sub',  -- 项目数据范围: project_all/project_sub/project_self/center
  description        TEXT,
  UNIQUE(project_role),
  FOREIGN KEY(role_code) REFERENCES admin_roles(role_code)
);

CREATE INDEX idx_admin_projrm_role ON admin_project_role_mapping(project_role);
```

### 16. admin_permission_packs（权限包）

```sql
CREATE TABLE IF NOT EXISTS admin_permission_packs (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT    NOT NULL UNIQUE,     -- 权限包名称：财务管理包/副总裁包/...
  pack_type   TEXT    NOT NULL DEFAULT 'custom' CHECK(pack_type IN ('domain','composite','custom')),
  -- domain=单领域包, composite=复合包(如副总裁), custom=自定义包
  modules     TEXT    NOT NULL DEFAULT '{}',  -- JSON对象，模块→权限级别，如 {"project":"full","budget":"read","hr":"read"}
  data_scope  TEXT    NOT NULL DEFAULT 'all',  -- 数据范围
  description TEXT,
  created_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  updated_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE INDEX idx_admin_pack_type ON admin_permission_packs(pack_type);
```

### 17. admin_permission_pack_users（权限包分配记录）

```sql
CREATE TABLE IF NOT EXISTS admin_permission_pack_users (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  pack_id         INTEGER NOT NULL,
  user_id         INTEGER NOT NULL,
  assigned_by     INTEGER NOT NULL,  -- 分配人
  assigned_at     TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
  UNIQUE(pack_id, user_id),
  FOREIGN KEY(pack_id) REFERENCES admin_permission_packs(id) ON DELETE CASCADE,
  FOREIGN KEY(user_id) REFERENCES admin_users(id) ON DELETE CASCADE,
  FOREIGN KEY(assigned_by) REFERENCES admin_users(id)
);

CREATE INDEX idx_admin_packuser_pack ON admin_permission_pack_users(pack_id);
CREATE INDEX idx_admin_packuser_user ON admin_permission_pack_users(user_id);
```

---

## 二、预置数据

### 2.1 超级管理员（密码: admin123）

```sql
INSERT INTO admin_users (username, password_hash, real_name, status) VALUES
  ('admin', '$2b$12$LJ3t8vGqN1qBKoZ6YxK8HeQvF8K3mNxRpV9cYjLZAW5dGHTuMCbeK', '超级管理员', 'active');
-- 注意：实际部署时用 bcrypt('admin123', 12) 生成真实hash
```

### 2.2 系统角色

```sql
INSERT INTO admin_roles (role_code, role_name, description, is_system) VALUES
  ('super_admin', '超级管理员', '全平台权限', 1),
  ('admin', '管理员', '用户/角色/部门管理', 1),
  ('pm', '项目经理', '项目全模块读写', 0),
  ('cra', 'CRA', '临床监查', 0),
  ('crc', 'CRC', '临床协调', 0),
  ('dm', '数据管理员', '数据管理相关', 0),
  ('qa', '质量管理员', 'QA相关', 0),
  ('bd', '商务发展', 'BD相关', 0),
  ('finance', '财务', '预算/费用/合同', 0),
  ('hr', '人事', 'HR管理', 0),
  ('dept_head', '部门负责人', '部门审批权+部门数据范围', 0),
  ('viewer', '只读用户', '全平台只读', 0);
```

### 2.3 超级管理员绑定角色

```sql
INSERT INTO admin_user_roles (user_id, role_id, role_source) VALUES (1, 1, 'admin');
```

### 2.4 超级管理员数据范围

```sql
INSERT INTO admin_data_scopes (role_id, scope_type) VALUES (1, 'all');
```

### 2.5 部门树

```sql
INSERT INTO admin_departments (dept_code, dept_name, parent_id, sort_order) VALUES
  ('HQ', '总部', 0, 1),
  ('clinical', '临床研究部', 1, 1),
  ('quality', '质量管理部', 1, 2),
  ('finance_dept', '财务部', 1, 3),
  ('hr_dept', '人力资源部', 1, 4),
  ('bd_dept', '商务发展部', 1, 5),
  ('data_mgmt', '数据管理部', 2, 1),
  ('pm_group', 'PM组', 2, 2),
  ('cra_group', 'CRA组', 2, 3),
  ('crc_group', 'CRC组', 2, 4);
```

### 2.6 权限树

```sql
-- 一级菜单
INSERT INTO admin_permissions (perm_code, perm_name, perm_type, parent_id, icon, route, sort_order) VALUES
  ('project', '项目管理', 'menu', 0, 'folder', '/project', 1),
  ('approval', '审批管理', 'menu', 0, 'check', '/approval', 2),
  ('budget', '预算管理', 'menu', 0, 'wallet', '/budget', 3),
  ('expense', '费用管理', 'menu', 0, 'receipt', '/expense', 4),
  ('contract', '合同管理', 'menu', 0, 'file-text', '/contract', 5),
  ('system', '系统管理', 'menu', 0, 'setting', '/admin', 6);

-- 项目管理子权限
INSERT INTO admin_permissions (perm_code, perm_name, perm_type, parent_id, route, sort_order) VALUES
  ('project:list', '项目列表', 'menu', 1, '/project/list', 1),
  ('project:create', '创建项目', 'api', 1, NULL, 2),
  ('project:update', '编辑项目', 'api', 1, NULL, 3),
  ('project:delete', '删除项目', 'api', 1, NULL, 4),
  ('project:data_all', '查看全部项目', 'data', 1, NULL, 5),
  ('project:data_dept', '查看本部门项目', 'data', 1, NULL, 6),
  ('project:data_self', '查看自己的项目', 'data', 1, NULL, 7);

-- 审批管理子权限
INSERT INTO admin_permissions (perm_code, perm_name, perm_type, parent_id, route, sort_order) VALUES
  ('approval:center', '审批中心', 'menu', 2, '/approval/center', 1),
  ('approval:config', '流程配置', 'menu', 2, '/approval/config', 2),
  ('approval:submit', '提交审批', 'api', 2, NULL, 3),
  ('approval:action', '审批操作', 'api', 2, NULL, 4),
  ('approval:data_all', '查看全部审批', 'data', 2, NULL, 5);

-- 预算管理子权限
INSERT INTO admin_permissions (perm_code, perm_name, perm_type, parent_id, route, sort_order) VALUES
  ('budget:list', '预算列表', 'menu', 3, '/budget/list', 1),
  ('budget:create', '创建预算', 'api', 3, NULL, 2),
  ('budget:approve', '审批预算', 'api', 3, NULL, 3);

-- 费用管理子权限
INSERT INTO admin_permissions (perm_code, perm_name, perm_type, parent_id, route, sort_order) VALUES
  ('expense:list', '费用列表', 'menu', 4, '/expense/list', 1),
  ('expense:create', '创建报销', 'api', 4, NULL, 2),
  ('expense:approve', '审批费用', 'api', 4, NULL, 3);

-- 合同管理子权限
INSERT INTO admin_permissions (perm_code, perm_name, perm_type, parent_id, route, sort_order) VALUES
  ('contract:list', '合同列表', 'menu', 5, '/contract/list', 1),
  ('contract:create', '创建合同', 'api', 5, NULL, 2),
  ('contract:data_all', '查看全部合同', 'data', 5, NULL, 3);

-- 系统管理子权限
INSERT INTO admin_permissions (perm_code, perm_name, perm_type, parent_id, route, sort_order) VALUES
  ('system:users', '用户管理', 'menu', 6, '/admin/users', 1),
  ('system:roles', '角色管理', 'menu', 6, '/admin/roles', 2),
  ('system:departments', '部门管理', 'menu', 6, '/admin/departments', 3),
  ('system:dict', '数据字典', 'menu', 6, '/admin/dict', 4),
  ('system:config', '系统配置', 'menu', 6, '/admin/config', 5),
  ('system:logs', '操作日志', 'menu', 6, '/admin/logs', 6),
  ('system:modules', '模块管理', 'menu', 6, '/admin/modules', 7),
  ('system:manage_users', '管理用户', 'api', 6, NULL, 8),
  ('system:manage_roles', '管理角色', 'api', 6, NULL, 9),
  ('system:manage_departments', '管理部门', 'api', 6, NULL, 10),
  ('system:manage_config', '管理配置', 'api', 6, NULL, 11);
```

### 2.7 超级管理员全权限

```sql
-- super_admin 角色绑定全部权限
INSERT INTO admin_role_permissions (role_id, permission_id)
  SELECT 1, id FROM admin_permissions;
```

### 2.8 数据字典

```sql
INSERT INTO admin_data_dict (category, dict_code, value, label, sort_order) VALUES
  ('project_type', 'ct', 'ct', 'CT', 1),
  ('project_type', 'be', 'be', 'BE', 2),
  ('project_type', 'pk', 'pk', 'PK', 3),
  ('project_status', 'planning', 'planning', '规划中', 1),
  ('project_status', 'ongoing', 'ongoing', '进行中', 2),
  ('project_status', 'completed', 'completed', '已完成', 3),
  ('project_status', 'suspended', 'suspended', '已暂停', 4),
  ('contract_type', 'service', 'service', '服务合同', 1),
  ('contract_type', 'purchase', 'purchase', '采购合同', 2),
  ('contract_type', 'nda', 'nda', '保密协议', 3),
  ('expense_type', 'travel', 'travel', '差旅', 1),
  ('expense_type', 'office', 'office', '办公', 2),
  ('expense_type', 'professional', 'professional', '专业服务', 3),
  ('currency', 'CNY', 'CNY', '人民币', 1),
  ('currency', 'USD', 'USD', '美元', 2);
```

### 2.9 模块注册

```sql
INSERT INTO admin_modules (module_code, module_name, module_type, base_url, icon, sort_order) VALUES
  ('project', '项目管理', 'core', '/api/project', 'folder', 1),
  ('approval', '审批平台', 'core', '/api/approval', 'check', 2),
  ('budget', '预算管理', 'business', '/api/budget', 'wallet', 3),
  ('expense', '费用管理', 'business', '/api/expense', 'receipt', 4),
  ('contract', '合同管理', 'business', '/api/contract', 'file-text', 5),
  ('hr', '人力资源', 'business', '/api/hr', 'team', 6),
  ('smo', 'SMO管理', 'business', '/api/smo', 'network', 7),
  ('seal', '用印管理', 'business', '/api/seal', 'stamp', 8),
  ('meeting', '会议管理', 'business', '/api/meeting', 'calendar', 9),
  ('training', '培训管理', 'business', '/api/training', 'book', 10),
  ('quality', '质量管理', 'business', '/api/quality', 'shield', 11),
  ('supply', '供应商管理', 'business', '/api/supply', 'truck', 12),
  ('sponsor', '申办方', 'business', '/api/sponsor', 'building', 13),
  ('bd', '商务发展', 'business', '/api/bd', 'handshake', 14);
```

### 2.10 系统配置

```sql
INSERT INTO admin_sys_config (config_key, config_value, config_type, description) VALUES
  ('platform_name', '药物研发智能协作平台', 'string', '平台名称'),
  ('login_max_attempts', '5', 'number', '登录失败最大次数'),
  ('login_lock_minutes', '30', 'number', '锁定时长(分钟)'),
  ('token_access_expire', '7200', 'number', 'Access Token有效期(秒)'),
  ('token_refresh_expire', '604800', 'number', 'Refresh Token有效期(秒)'),
  ('password_min_length', '8', 'number', '密码最小长度'),
  ('default_approval_timeout', '72', 'number', '默认审批超时(小时)'),
  ('notification_channels', '["site","wework"]', 'json', '默认通知渠道');
```

### 2.11 岗位权限配置

```sql
INSERT INTO admin_position_role_mapping (position_type, is_leader, role_code, accessible_modules, data_scope, description) VALUES
  ('PM', 0, 'pm', '["project","center","approval"]', 'dept_sub', '项目经理'),
  ('PM', 1, 'dept_head', '["project","center","approval"]', 'dept_sub', 'PM组负责人'),
  ('CRA', 0, 'cra', '["project","center"]', 'dept_sub', '临床监查员'),
  ('CRA', 1, 'dept_head', '["project","center"]', 'dept_sub', 'CRA组负责人'),
  ('CRC', 0, 'crc', '["project","center"]', 'self', '临床协调员'),
  ('CRC', 1, 'dept_head', '["project","center"]', 'dept_sub', 'CRC组负责人'),
  ('DM', 0, 'dm', '["project","center"]', 'dept_sub', '数据管理员'),
  ('DM', 1, 'dept_head', '["project","center"]', 'dept_sub', '数据管理部负责人'),
  ('QA', 0, 'qa', '["quality","project"]', 'dept_sub', '质量管理员'),
  ('QA', 1, 'dept_head', '["quality","project"]', 'dept_sub', '质量管理部负责人'),
  ('BD', 0, 'bd', '["bd","sponsor"]', 'dept_sub', '商务发展'),
  ('BD', 1, 'dept_head', '["bd","sponsor"]', 'dept_sub', 'BD组负责人'),
  ('财务', 0, 'finance', '["budget","expense","contract"]', 'dept_sub', '财务人员'),
  ('财务', 1, 'dept_head', '["budget","expense","contract"]', 'dept_sub', '财务部负责人'),
  ('人事', 0, 'hr', '["hr","training"]', 'dept_sub', 'HR人员'),
  ('人事', 1, 'dept_head', '["hr","training"]', 'dept_sub', 'HR部负责人');
```

### 2.11B 项目岗位权限配置

```sql
INSERT INTO admin_project_role_mapping (project_role, allowed_positions, role_code, accessible_modules, data_scope, description) VALUES
  ('PM', '["PM"]', 'pm', '["project","center","approval"]', 'project_all', '项目经理-项目内全权限'),
  ('APM', '["CRA","CRC"]', 'pm', '["project","center","approval"]', 'project_sub', '助理PM-CRA/CRC可担任'),
  ('PI', '[]', 'viewer', '["project","center"]', 'project_self', '主要研究者-只读'),
  ('CRA', '["CRA"]', 'cra', '["project","center"]', 'center', 'CRA-本中心数据'),
  ('CRC', '["CRC"]', 'crc', '["project","center"]', 'center', 'CRC-本中心有限数据'),
  ('DM', '["DM"]', 'dm', '["project","center"]', 'project_all', '数据管理员-项目内只读');
```

### 2.11C 权限包预置

```sql
INSERT INTO admin_permission_packs (name, pack_type, modules, data_scope, description) VALUES
  ('财务管理包', 'domain', '{"budget":"full","expense":"full","contract":"full"}', 'all', '财务领域全读写'),
  ('项目管理包', 'domain', '{"project":"full","center":"full","approval":"full"}', 'all', '项目领域全读写'),
  ('行政管理包', 'domain', '{"smo":"full","seal":"full","supply":"full","meeting":"full"}', 'all', '行政领域全读写'),
  ('HR管理包', 'domain', '{"hr":"full","training":"full"}', 'all', 'HR领域全读写'),
  ('副总裁包', 'composite', '{"budget":"full","expense":"full","contract":"full","project":"read","center":"read","hr":"read","approval":"full"}', 'all', '财务全读写+项目HR只读+审批'),
  ('COO包', 'composite', '{"project":"read","budget":"read","expense":"read","contract":"read","hr":"read","approval":"full"}', 'all', '全模块只读+审批终审'),
  ('CEO包', 'composite', '{"project":"full","budget":"full","expense":"full","contract":"full","hr":"full","approval":"full","center":"full"}', 'all', '全模块读写+全审批'),
  ('审计监察包', 'custom', '{"project":"read","budget":"read","expense":"read","contract":"read","hr":"read"}', 'all', '全平台只读+操作日志');
```

### 2.12 HR入职联动角色写入

```sql
-- HR入职回调时，根据岗位自动写入角色
-- 示例：张三入职，position_type=CRA, is_leader=0

-- 1. 查映射
-- SELECT role_code FROM admin_position_role_mapping 
--   WHERE position_type='CRA' AND is_leader=0;
-- → cra

-- 2. 写入用户角色
-- INSERT INTO admin_user_roles (user_id, role_id, role_source, project_id)
--   SELECT :new_user_id, r.id, 'hr', NULL
--   FROM admin_roles r WHERE r.role_code = 'cra';

-- 如果是部门负责人(is_leader=1)，同时写入dept_head角色
-- INSERT INTO admin_user_roles (user_id, role_id, role_source, project_id)
--   SELECT :new_user_id, r.id, 'hr', NULL
--   FROM admin_roles r WHERE r.role_code IN ('cra', 'dept_head');
```

---

## 三、索引汇总（34个）

| # | 索引名 | 表 | 字段 |
|---|--------|-----|------|
| 1 | idx_admin_users_status | admin_users | status |
| 2 | idx_admin_users_username | admin_users | username |
| 3 | idx_admin_users_member | admin_users | member_id |
| 4 | idx_admin_roles_code | admin_roles | role_code |
| 5 | idx_admin_roles_status | admin_roles | status |
| 6 | idx_admin_permissions_type | admin_permissions | perm_type |
| 7 | idx_admin_permissions_parent | admin_permissions | parent_id |
| 8 | idx_admin_permissions_code | admin_permissions | perm_code |
| 9 | idx_admin_rp_role | admin_role_permissions | role_id |
| 10 | idx_admin_rp_perm | admin_role_permissions | permission_id |
| 11 | idx_admin_ur_user | admin_user_roles | user_id |
| 12 | idx_admin_ur_role | admin_user_roles | role_id |
| 13 | idx_admin_ur_source | admin_user_roles | role_source |
| 14 | idx_admin_ur_project | admin_user_roles | project_id |
| 15 | idx_admin_dept_parent | admin_departments | parent_id |
| 16 | idx_admin_dept_code | admin_departments | dept_code |
| 17 | idx_admin_dept_hr | admin_departments | hr_dept_id |
| 18 | idx_admin_du_dept | admin_dept_users | dept_id |
| 19 | idx_admin_du_user | admin_dept_users | user_id |
| 20 | idx_admin_du_primary | admin_dept_users | user_id, is_primary |
| 21 | idx_admin_scope_role | admin_data_scopes | role_id |
| 22 | idx_admin_prm_position | admin_position_role_mapping | position_type |
| 23 | idx_admin_prm_role | admin_position_role_mapping | role_code |
| 24 | idx_admin_dict_category | admin_data_dict | category |
| 25 | idx_admin_config_key | admin_sys_config | config_key |
| 26 | idx_admin_logs_user | admin_operation_logs | user_id |
| 27 | idx_admin_logs_module | admin_operation_logs | module |
| 28 | idx_admin_logs_time | admin_operation_logs | created_at |
| 29 | idx_admin_modules_code | admin_modules | module_code |
| 30 | idx_admin_modules_type | admin_modules | module_type |
| 31 | idx_admin_pref_user | admin_user_preferences | user_id |
| 32 | idx_admin_projrm_role | admin_project_role_mapping | project_role |
| 33 | idx_admin_pack_type | admin_permission_packs | pack_type |
| 34 | idx_admin_packuser_pack | admin_permission_pack_users | pack_id |
| 35 | idx_admin_packuser_user | admin_permission_pack_users | user_id |

---

## 四、迁移SQL（从旧permission.db迁移）

```sql
-- 若存在旧 permission.db，迁移用户数据
-- ATTACH 'permission.db' AS old_db;

-- INSERT INTO admin_users (username, password_hash, real_name, email, phone, status)
--   SELECT username, password_hash, real_name, email, phone, status FROM old_db.users;

-- 迁移完成后分离
-- DETACH DATABASE old_db;
```

---

## 五、DB初始化脚本

```javascript
// server/routes/admin/db.js
const path = require('path')
const Database = require('better-sqlite3')

const DB_PATH = path.join(__dirname, '../../data/admin.db')
const db = new Database(DB_PATH)

// 启用WAL模式
db.pragma('journal_mode = WAL')
db.pragma('foreign_keys = ON')

module.exports = db
```
