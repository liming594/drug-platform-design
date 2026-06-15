# HR Module SQL建表脚本 (对象线7号: Member / TeamAssignment)

> 数据库: member.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)

```sql
-- ============================================
-- member.db 全量建表脚本
-- 对象线7号: Member / TeamAssignment
-- ============================================

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

-- ============================================
-- 索引
-- ============================================

-- member 索引
CREATE INDEX IF NOT EXISTS idx_member_employee_no ON member(employee_no);
CREATE INDEX IF NOT EXISTS idx_member_name ON member(name);
CREATE INDEX IF NOT EXISTS idx_member_department ON member(department_id);
CREATE INDEX IF NOT EXISTS idx_member_position_type ON member(position_type);
CREATE INDEX IF NOT EXISTS idx_member_status ON member(member_status);
CREATE INDEX IF NOT EXISTS idx_member_report_to ON member(report_to_id);

-- team_assignment 索引
CREATE INDEX IF NOT EXISTS idx_ta_member ON team_assignment(member_id);
CREATE INDEX IF NOT EXISTS idx_ta_project ON team_assignment(project_id);
CREATE INDEX IF NOT EXISTS idx_ta_project_site ON team_assignment(project_site_id);
CREATE INDEX IF NOT EXISTS idx_ta_type_status ON team_assignment(assignment_type, assignment_status);
CREATE INDEX IF NOT EXISTS idx_ta_role ON team_assignment(project_role);
CREATE INDEX IF NOT EXISTS idx_ta_member_active ON team_assignment(member_id, assignment_status);

-- member_salary 索引
CREATE INDEX IF NOT EXISTS idx_ms_member ON member_salary(member_id);
CREATE INDEX IF NOT EXISTS idx_ms_current ON member_salary(member_id, is_current);

-- department 索引
CREATE INDEX IF NOT EXISTS idx_dept_company ON department(company_id);
CREATE INDEX IF NOT EXISTS idx_dept_parent ON department(parent_id);

-- onboarding 索引
CREATE INDEX IF NOT EXISTS idx_onboard_member ON onboarding(member_id);
CREATE INDEX IF NOT EXISTS idx_onboard_status ON onboarding(onboard_status);

-- offboarding 索引
CREATE INDEX IF NOT EXISTS idx_offboard_member ON offboarding(member_id);
CREATE INDEX IF NOT EXISTS idx_offboard_status ON offboarding(offboard_status);
```

---

## 枚举值速查

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
