# HR Module Implementation Spec (对象线7号: Member / TeamAssignment)

> Codex执行规范：按此文件实现，不需要额外设计决策
> 数据库: member.db (SQLite, better-sqlite3, WAL模式)
> 后端: Node.js + Express

---

## 1. 数据库建表SQL（直接执行）

```sql
-- member.db 全量建表脚本

-- 1. Company 公司
CREATE TABLE IF NOT EXISTS company (
    company_id      TEXT PRIMARY KEY,
    company_name    TEXT NOT NULL,
    short_name      TEXT,
    credit_code     TEXT,
    legal_person    TEXT,
    address         TEXT,
    contact_phone   TEXT,
    contact_email   TEXT,
    company_status  TEXT DEFAULT 'ACTIVE',  -- ACTIVE/DISABLED
    sort_order      INTEGER DEFAULT 0,
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 2. Department 部门
CREATE TABLE IF NOT EXISTS department (
    department_id   TEXT PRIMARY KEY,
    department_name TEXT NOT NULL,
    company_id      TEXT NOT NULL,
    parent_id       TEXT,           -- FK→department, 支持多级
    dept_type       TEXT DEFAULT 'NORMAL',  -- NORMAL/VIRTUAL
    manager_id      TEXT,           -- FK→member
    dept_status     TEXT DEFAULT 'ACTIVE',  -- ACTIVE/DISABLED
    sort_order      INTEGER DEFAULT 0,
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 3. Position 岗位体系
CREATE TABLE IF NOT EXISTS position (
    position_id     TEXT PRIMARY KEY,
    position_type   TEXT NOT NULL,   -- CRA/CRC/PM/医学写作/CTA/DM/SA/QA/BD/其他
    position_level  TEXT NOT NULL,   -- 初级/中级/高级/资深/专家
    position_label  TEXT NOT NULL,   -- 显示名, 如"高级CRA"
    dept_id         TEXT,            -- FK→department (可选)
    sort_order      INTEGER DEFAULT 0,
    created_at      TEXT DEFAULT (datetime('now'))
);

-- 4. Member 人员主档
CREATE TABLE IF NOT EXISTS member (
    member_id       TEXT PRIMARY KEY,
    name            TEXT NOT NULL,
    employee_no     TEXT UNIQUE NOT NULL,
    english_name    TEXT,
    mobile          TEXT NOT NULL,
    email           TEXT,
    gender          TEXT DEFAULT 'UNSPECIFIED',  -- MALE/FEMALE/UNSPECIFIED
    birth_date      TEXT,             -- YYYY-MM-DD
    id_type         TEXT,             -- ID_CARD/PASSPORT/OTHER
    id_number       TEXT,             -- 加密存储
    company_id      TEXT,             -- FK→company
    department_id   TEXT,             -- FK→department
    position_type   TEXT NOT NULL,    -- CRA/CRC/PM/医学写作/CTA/DM/SA/QA/BD/其他
    position_level  TEXT NOT NULL,    -- 初级/中级/高级/资深/专家
    duty            TEXT,             -- 总监/经理/主管/专员
    hire_date       TEXT,
    leave_date      TEXT,             -- 空值=在职
    member_status   TEXT DEFAULT 'ACTIVE',  -- ACTIVE/PROBATION/RESIGNED/DISABLED
    report_to_id    TEXT,             -- FK→member
    work_city       TEXT,
    gcp_certified   INTEGER DEFAULT 0,
    gcp_expiry_date TEXT,
    qualifications  TEXT,             -- JSON: [{type, name, expiryDate}]
    therapeutic_exp TEXT,             -- JSON: ["肿瘤","心血管"]
    availability    TEXT DEFAULT 'FULL',  -- FULL/PARTIAL/UNAVAILABLE
    availability_pct INTEGER DEFAULT 100, -- 0-100
    avatar          TEXT,
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 5. TeamAssignment 项目/中心职责分配
CREATE TABLE IF NOT EXISTS team_assignment (
    assignment_id       TEXT PRIMARY KEY,
    member_id           TEXT NOT NULL,
    assignment_type     TEXT NOT NULL,   -- PROJECT/CENTER/SMO/VENDOR
    project_id          TEXT,            -- PROJECT类型必填
    project_site_id     TEXT,
    project_smo_id      TEXT,
    project_vendor_id   TEXT,
    project_role        TEXT NOT NULL,   -- PM/PM-C/CRA/CRA-I/CRA-II/CRC/PI/Sub-I/CTA/DM/SA/QA/BD/其他
    is_primary          INTEGER DEFAULT 0,
    allocation_pct      INTEGER DEFAULT 100, -- 0-100
    start_date          TEXT,
    end_date            TEXT,            -- 空值=仍在参与
    assignment_status   TEXT DEFAULT 'PENDING',  -- PENDING/ASSIGNED/ACTIVE/RELEASED/REPLACED
    replaced_by_member_id TEXT,
    replaced_date       TEXT,
    report_to_member_id TEXT,
    therapeutic_area    TEXT,
    site_count          INTEGER DEFAULT 0,  -- CRA专用
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT,
    UNIQUE(member_id, assignment_type, project_id, project_site_id, project_smo_id, project_vendor_id, project_role, assignment_status)
);

-- 6. MemberSalary 人员薪资
CREATE TABLE IF NOT EXISTS member_salary (
    salary_id                TEXT PRIMARY KEY,
    member_id                TEXT NOT NULL,
    base_salary              REAL NOT NULL,
    social_insurance_company REAL DEFAULT 0,
    housing_fund_company     REAL DEFAULT 0,
    effective_date           TEXT NOT NULL,
    is_current               INTEGER DEFAULT 1,
    remark                   TEXT,
    created_at               TEXT DEFAULT (datetime('now')),
    updated_at               TEXT DEFAULT (datetime('now')),
    created_by               TEXT,
    updated_by               TEXT,
    UNIQUE(member_id, effective_date)
);

-- 7. Onboarding 入职记录
CREATE TABLE IF NOT EXISTS onboarding (
    onboarding_id   TEXT PRIMARY KEY,
    member_id       TEXT NOT NULL,
    hire_date       TEXT NOT NULL,
    company_id      TEXT NOT NULL,
    department_id   TEXT NOT NULL,
    position_type   TEXT NOT NULL,
    position_level  TEXT NOT NULL,
    probation_end   TEXT,
    onboard_status  TEXT DEFAULT 'PENDING',  -- PENDING/IN_PROGRESS/COMPLETED/CANCELLED
    checklist       TEXT,    -- JSON: [{item, done, doneDate}]
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 8. Offboarding 离职记录
CREATE TABLE IF NOT EXISTS offboarding (
    offboarding_id  TEXT PRIMARY KEY,
    member_id       TEXT NOT NULL,
    leave_date      TEXT NOT NULL,
    leave_type      TEXT NOT NULL,  -- RESIGN/DISMISS/CONTRACT_END/RETIRE/OTHER
    leave_reason    TEXT,
    checklist       TEXT,    -- JSON: [{item, done, doneDate}]
    assignments_total       INTEGER DEFAULT 0,
    assignments_transferred INTEGER DEFAULT 0,
    assignments_released    INTEGER DEFAULT 0,
    handover_to_id          TEXT,  -- FK→member, 交接人
    offboard_status TEXT DEFAULT 'PENDING',  -- PENDING/IN_PROGRESS/COMPLETED/CANCELLED
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_member_employee_no ON member(employee_no);
CREATE INDEX IF NOT EXISTS idx_member_name ON member(name);
CREATE INDEX IF NOT EXISTS idx_member_department ON member(department_id);
CREATE INDEX IF NOT EXISTS idx_member_position_type ON member(position_type);
CREATE INDEX IF NOT EXISTS idx_member_status ON member(member_status);
CREATE INDEX IF NOT EXISTS idx_member_report_to ON member(report_to_id);
CREATE INDEX IF NOT EXISTS idx_ta_member ON team_assignment(member_id);
CREATE INDEX IF NOT EXISTS idx_ta_project ON team_assignment(project_id);
CREATE INDEX IF NOT EXISTS idx_ta_project_site ON team_assignment(project_site_id);
CREATE INDEX IF NOT EXISTS idx_ta_type_status ON team_assignment(assignment_type, assignment_status);
CREATE INDEX IF NOT EXISTS idx_ta_role ON team_assignment(project_role);
CREATE INDEX IF NOT EXISTS idx_ta_member_active ON team_assignment(member_id, assignment_status);
CREATE INDEX IF NOT EXISTS idx_ms_member ON member_salary(member_id);
CREATE INDEX IF NOT EXISTS idx_ms_current ON member_salary(member_id, is_current);
CREATE INDEX IF NOT EXISTS idx_dept_company ON department(company_id);
CREATE INDEX IF NOT EXISTS idx_dept_parent ON department(parent_id);
CREATE INDEX IF NOT EXISTS idx_onboard_member ON onboarding(member_id);
CREATE INDEX IF NOT EXISTS idx_onboard_status ON onboarding(onboard_status);
CREATE INDEX IF NOT EXISTS idx_offboard_member ON offboarding(member_id);
CREATE INDEX IF NOT EXISTS idx_offboard_status ON offboarding(offboard_status);
```

---

## 2. 文件结构

```
server/routes/
├── hr/
│   ├── db.js              ← member.db 连接 + 建表
│   ├── company.js          ← 公司 CRUD
│   ├── department.js       ← 部门 CRUD (树形)
│   ├── position.js         ← 岗位 CRUD
│   ├── member.js           ← 人员 CRUD
│   ├── onboarding.js       ← 入职管理
│   ├── offboarding.js      ← 离职管理
│   └── salary.js           ← 薪资 CRUD (权限控制)
├── project-team.js         ← 项目人员管理
└── project-site-team.js    ← 中心人员 (驾驶舱嵌入)
```

---

## 3. db.js 模板

```javascript
/**
 * HR Module DB - member.db
 * SQLite better-sqlite3 + WAL
 */
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'member.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）
const SCHEMA = `
-- 将上面第1节的全部SQL粘贴于此
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 4. API 路由规范

### 4.1 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该部门下有5名人员，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`

### 4.2 路由注册

在 server/app.js 或 index.js 中：

```javascript
// HR模块
app.use('/api/hr/companies', require('./routes/hr/company'));
app.use('/api/hr/departments', require('./routes/hr/department'));
app.use('/api/hr/positions', require('./routes/hr/position'));
app.use('/api/hr/members', require('./routes/hr/member'));
app.use('/api/hr/onboarding', require('./routes/hr/onboarding'));
app.use('/api/hr/offboarding', require('./routes/hr/offboarding'));
app.use('/api/hr/salary', require('./routes/hr/salary'));
// 项目人员
app.use('/api/projects/:projectId/team', require('./routes/project-team'));
app.use('/api/projects/:projectId/sites/:projectSiteId/team', require('./routes/project-site-team'));
```

### 4.3 公司 CRUD (company.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，返回全部（公司通常不多，不分页） |
| POST | / | 新增，body: `{ company_name, short_name?, credit_code?, legal_person?, address?, contact_phone?, contact_email?, sort_order? }` |
| PUT | /:companyId | 编辑，body同POST全部可选 |
| DELETE | /:companyId | 删除，校验: department表无引用、member表无引用 |

### 4.4 部门 CRUD (department.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 部门树，`?company_id=xxx`，返回递归结构含 `children[]`，每节点附 `member_count` 和 `manager_name`(JOIN member) |
| POST | / | 新增，body: `{ department_name, company_id, parent_id?, dept_type?, manager_id?, sort_order? }` |
| PUT | /:departmentId | 编辑，body同POST全部可选 |
| DELETE | /:departmentId | 删除，校验: 无子部门(parent_id引用)、无人员(department_id引用) |

**树形查询示例：**
```javascript
function buildTree(rows) {
  const map = {};
  const roots = [];
  rows.forEach(r => { map[r.department_id] = { ...r, children: [] }; });
  rows.forEach(r => {
    if (r.parent_id && map[r.parent_id]) map[r.parent_id].children.push(map[r.department_id]);
    else roots.push(map[r.department_id]);
  });
  return roots;
}
```

### 4.5 岗位 CRUD (position.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，返回全部 |
| POST | / | 新增，body: `{ position_type, position_level, position_label, dept_id?, sort_order? }` |
| PUT | /:positionId | 编辑 |
| DELETE | /:positionId | 删除，校验: member表无position_type+position_level组合引用 |

### 4.6 人员 CRUD (member.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?department_id=&company_id=&status=&position_type=&keyword=&page=&size=`，JOIN company/department补名称 |
| GET | /:memberId | 详情，含 `active_assignments[]` (JOIN team_assignment) |
| POST | / | 新增，body见下方 |
| PUT | /:memberId | 编辑，body同POST全部可选 |
| PUT | /:memberId/status | 变更状态，body: `{ member_status: "ACTIVE"/"PROBATION"/"RESIGNED"/"DISABLED" }` |

**POST body 完整字段：**
```json
{
  "name": "张三",
  "employee_no": "EMP001",
  "english_name": "Tom",
  "mobile": "13800138000",
  "email": "zhangsan@sinocro.cn",
  "gender": "MALE",
  "birth_date": "1990-01-15",
  "id_type": "ID_CARD",
  "id_number": "110xxx",
  "company_id": "uuid",
  "department_id": "uuid",
  "position_type": "CRA",
  "position_level": "高级",
  "duty": "主管",
  "hire_date": "2024-03-01",
  "report_to_id": "uuid",
  "work_city": "北京",
  "gcp_certified": 1,
  "gcp_expiry_date": "2026-12-31",
  "qualifications": [{"type":"GCP","name":"GCP证书","expiryDate":"2026-12-31"}],
  "therapeutic_exp": ["肿瘤","心血管"],
  "avatar": "/uploads/xxx.jpg",
  "remark": ""
}
```

**GET /:memberId 响应：**
```json
{
  "member_id": "uuid",
  "name": "张三",
  "...": "全部member字段",
  "report_to_name": "李四",
  "company_name": "北京兴德通",
  "department_name": "临床部",
  "active_assignments": [
    {
      "assignment_id": "uuid",
      "project_id": "uuid",
      "project_name": "PD-001",
      "project_role": "CRA",
      "allocation_pct": 60,
      "assignment_status": "ACTIVE"
    }
  ]
}
```

### 4.7 入职管理 (onboarding.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?status=&department_id=&keyword=&page=&size=`，附 `checklist_progress: "2/5"` |
| POST | / | 新建入职，**同时创建Member+Onboarding** |
| GET | /:onboardingId | 详情，含 checklist 数组 |
| PUT | /:onboardingId | 更新信息/勾选待办，body: `{ checklist?, onboard_status?, remark? }` |
| PUT | /:onboardingId/complete | 完成入职 → `onboard_status=COMPLETED`, `Member.member_status=ACTIVE` |

**POST / 逻辑（事务）：**
1. INSERT member (member_status='PROBATION')
2. INSERT onboarding (member_id=上一步ID)
3. 返回 onboarding 完整对象

**POST body：**
```json
{
  "name": "王六",
  "employee_no": "EMP010",
  "mobile": "13900139000",
  "company_id": "uuid",
  "department_id": "uuid",
  "position_type": "CRA",
  "position_level": "初级",
  "hire_date": "2026-06-15",
  "probation_end": "2026-09-15",
  "checklist": [
    {"item": "签订劳动合同"},
    {"item": "开通系统账号"},
    {"item": "领取工牌"},
    {"item": "GCP培训安排"},
    {"item": "分配办公设备"}
  ]
}
```

### 4.8 离职管理 (offboarding.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?status=&department_id=&keyword=` |
| POST | / | 新建离职 |
| GET | /:offboardingId | 详情，含 `active_assignments[]` + 每条 `transfer_status` |
| PUT | /:offboardingId | 更新信息/勾选待办 |
| PUT | /:offboardingId/transfer/:assignmentId | 交接单条分配 |
| POST | /:offboardingId/transfer-batch | 批量交接多条分配给同一人 |
| PUT | /:offboardingId/complete | 完成离职 |

**POST / 逻辑：**
1. 校验 member 存在且 member_status ≠ RESIGNED
2. 查询该 member 所有 ACTIVE 的 team_assignment
3. INSERT offboarding，assignments_total = 活跃分配数
4. 返回 offboarding + active_assignments 列表

**PUT /:offboardingId/transfer/:assignmentId 逻辑（事务）：**
1. 原 team_assignment → `assignment_status='REPLACED'`，填 `replaced_by_member_id` + `replaced_date`
2. INSERT 新 team_assignment (new_member_id, 同 project/site/role, status='ACTIVE')
3. offboarding: `assignments_transferred += 1`

**POST /:offboardingId/transfer-batch body：**
```json
{
  "assignment_ids": ["id1", "id2", "id3"],
  "new_member_id": "uuid",
  "transfer_date": "2026-06-20"
}
```
遍历执行，任一失败全部回滚。

**PUT /:offboardingId/complete 逻辑（事务）：**
1. `offboard_status → COMPLETED`
2. `Member.member_status → RESIGNED`
3. 所有剩余 ACTIVE team_assignment → `RELEASED`, `end_date = 当天`
4. `offboarding.assignments_released = 剩余未交接数`

### 4.9 薪资 CRUD (salary.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?member_id=xxx`，**需权限校验** |
| POST | / | 新增/调薪，body: `{ member_id, base_salary, social_insurance_company?, housing_fund_company?, effective_date }` |
| PUT | /:salaryId | 编辑 |
| GET | /current/:memberId | 获取当前生效薪资 |

**计算公式：**
```
时薪 = (base_salary + social_insurance_company + housing_fund_company) / 21.75 / 8
项目人工成本 = SUM(时薪 × actual_hours)  -- 按项目×人员聚合
```

**新增薪资时自动处理：**
- 同一 member 的其他 is_current=1 记录 → is_current=0
- 新记录 is_current=1

### 4.10 项目人员管理 (project-team.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 项目团队，`?role=&status=&keyword=`，含角色分布summary + 每人member_total_allocation |
| POST | / | 添加项目人员 |
| PUT | /:assignmentId | 编辑分配 |
| PUT | /:assignmentId/replace | 替换人员 |
| PUT | /:assignmentId/release | 释放人员 |
| GET | /:memberId/sites | 某人负责的中心列表 |
| GET | /load | 团队负载概览 |

**GET / 响应：**
```json
{
  "total": 8,
  "summary": { "PM": 2, "CRA": 3, "CRC": 1, "CTA": 1, "OTHER": 1 },
  "list": [{
    "assignment_id": "uuid",
    "member_id": "uuid",
    "member_name": "王五",
    "employee_no": "EMP003",
    "position_type": "CRA",
    "position_level": "高级",
    "project_role": "CRA",
    "is_primary": 0,
    "allocation_pct": 60,
    "start_date": "2026-03-15",
    "end_date": null,
    "assignment_status": "ACTIVE",
    "site_count": 5,
    "therapeutic_area": "肿瘤",
    "member_total_allocation": 140
  }]
}
```

**POST / body：**
```json
{
  "member_id": "uuid",
  "project_role": "CRA",
  "is_primary": false,
  "allocation_pct": 60,
  "start_date": "2026-06-15",
  "site_ids": ["siteId1", "siteId2"]
}
```

**PUT /:assignmentId/replace 逻辑（事务）：**
1. 原 team_assignment → REPLACED
2. INSERT 新 team_assignment (new_member_id)
3. body: `{ new_member_id, replace_date, site_ids? }`

**PUT /:assignmentId/release 逻辑：**
1. `assignment_status → RELEASED`, `end_date = 当天`
2. body: `{ end_date?, remark? }`

**GET /load 响应：**
```json
[{
  "member_id": "uuid",
  "member_name": "张三",
  "allocations": [
    { "assignment_id": "uuid", "project_name": "PD-001", "project_role": "PM", "allocation_pct": 40 },
    { "assignment_id": "uuid", "project_name": "PD-002", "project_role": "PM", "allocation_pct": 20 }
  ],
  "total_allocation": 60
}]
```

### 4.11 中心人员 (project-site-team.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心人员（轻量），返回 `{ CRA: {...}, CRC: {...}, PI: {...} }` |
| PUT | /:assignmentId/replace | 替换中心人员，body: `{ new_member_id, replace_date? }` |

**GET / 响应：**
```json
{
  "CRA": { "member_id": "uuid", "member_name": "王五", "assignment_id": "uuid" },
  "CRC": { "member_id": "uuid", "member_name": "赵六", "assignment_id": "uuid" },
  "PI": { "member_id": "uuid", "member_name": "李教授", "assignment_id": "uuid" }
}
```

---

## 5. 枚举值速查

```
-- member.member_status
ACTIVE / PROBATION / RESIGNED / DISABLED

-- member.availability
FULL / PARTIAL / UNAVAILABLE

-- member.position_type
CRA / CRC / PM / 医学写作 / CTA / DM / SA / QA / BD / 其他

-- member.position_level
初级 / 中级 / 高级 / 资深 / 专家

-- team_assignment.assignment_type
PROJECT / CENTER / SMO / VENDOR

-- team_assignment.project_role
PM / PM-C / CRA / CRA-I / CRA-II / CRC / PI / Sub-I / CTA / DM / SA / QA / BD / 其他

-- team_assignment.assignment_status
PENDING / ASSIGNED / ACTIVE / RELEASED / REPLACED

-- onboarding.onboard_status
PENDING / IN_PROGRESS / COMPLETED / CANCELLED

-- offboarding.offboard_status
PENDING / IN_PROGRESS / COMPLETED / CANCELLED

-- offboarding.leave_type
RESIGN / DISMISS / CONTRACT_END / RETIRE / OTHER

-- company.company_status
ACTIVE / DISABLED

-- department.dept_status
ACTIVE / DISABLED

-- department.dept_type
NORMAL / VIRTUAL
```

---

## 6. 第一版不做

- ❌ 薪资管理完整权限体系（salary.js只做基础CRUD，权限由中间件控制）
- ❌ 排班/日历视图
- ❌ 工时审批流（走Timesheet线）
- ❌ 跨项目冲突自动检测
- ❌ 完整HR系统（社保、银行卡、考勤）
- ❌ 权限系统（走用户权限域）
