# HR 薪资管理模块 SQL建表脚本 (salary-sql.md)
> 数据库: salary.db (SQLite, better-sqlite3, WAL模式)
> 直接执行, idempotent (IF NOT EXISTS)
> 零耦合原则: salary.db 独立于 member.db, 跨域数据走HTTP API

```sql
-- ============================================
-- salary.db 全量建表脚本
-- HR 薪资管理模块
-- ============================================

-- 1. salary_structure 薪资结构模板
-- 每个员工可有多条历史记录, is_current=1为当前生效
CREATE TABLE IF NOT EXISTS salary_structure (
    structure_id        TEXT PRIMARY KEY,
    member_id           TEXT NOT NULL,              -- FK→member(member_id), 逻辑外键
    base_salary         REAL NOT NULL DEFAULT 0,    -- 基本工资
    position_allowance  REAL DEFAULT 0,             -- 岗位工资/补贴
    rank_salary         REAL DEFAULT 0,             -- 职级工资
    duty_salary         REAL DEFAULT 0,             -- 职务工资
    position_grade      TEXT,                       -- 职务等级(如B-2, C)
    rank_grade          TEXT,                       -- 职级等级(如CRA-III-1, PM-1)
    transport_subsidy   REAL DEFAULT 0,             -- 交通补贴(固定)
    computer_subsidy    REAL DEFAULT 0,             -- 电脑补贴(固定)
    meal_subsidy        REAL DEFAULT 0,             -- 午餐补贴(固定)
    other_subsidy       REAL DEFAULT 0,             -- 其他补贴
    total_monthly       REAL GENERATED ALWAYS AS (
        base_salary + position_allowance + rank_salary + duty_salary
        + transport_subsidy + computer_subsidy + meal_subsidy + other_subsidy
    ) STORED,                                       -- 应发合计(计算列)
    effective_date      TEXT NOT NULL,              -- 生效日期
    is_current          INTEGER DEFAULT 1,          -- 1=当前生效, 0=历史
    change_reason       TEXT,                       -- 调薪原因: 入职定薪/年度调薪/晋升调薪/转正调薪/其他
    previous_structure_id TEXT,                     -- 上一次结构ID, 用于追溯
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT,
    UNIQUE(member_id, effective_date)
);

-- 2. salary_social_insurance 社保公积金配置
-- 按区域×年度配置缴纳比例和基数上下限
CREATE TABLE IF NOT EXISTS salary_social_insurance (
    insurance_id            TEXT PRIMARY KEY,
    region_code             TEXT NOT NULL,              -- 区域代码(如BJ, QC)
    region_name             TEXT NOT NULL,              -- 区域名称(如北京, 齐齐哈尔)
    config_year             INTEGER NOT NULL,           -- 适用年度(如2026)
    base_min                REAL NOT NULL,              -- 缴纳基数下限
    base_max                REAL NOT NULL,              -- 缴纳基数上限
    -- 养老保险
    pension_company         REAL NOT NULL DEFAULT 0,    -- 养老公积司比例%
    pension_personal        REAL NOT NULL DEFAULT 0,    -- 养老个人比例%
    -- 医疗保险
    medical_company         REAL NOT NULL DEFAULT 0,    -- 医疗公司比例%
    medical_personal        REAL NOT NULL DEFAULT 0,    -- 医疗个人比例%
    -- 失业保险
    unemployment_company    REAL NOT NULL DEFAULT 0,    -- 失业公司比例%
    unemployment_personal   REAL NOT NULL DEFAULT 0,    -- 失业个人比例%
    -- 工伤保险
    injury_company          REAL NOT NULL DEFAULT 0,    -- 工伤公司比例%
    injury_personal         REAL DEFAULT 0,             -- 工伤个人比例%(通常0)
    -- 生育保险
    maternity_company       REAL NOT NULL DEFAULT 0,    -- 生育公司比例%
    maternity_personal      REAL DEFAULT 0,             -- 生育个人比例%(通常0)
    -- 住房公积金
    housing_company         REAL NOT NULL DEFAULT 0,    -- 公积金公司比例%
    housing_personal        REAL NOT NULL DEFAULT 0,    -- 公积金个人比例%
    -- 残保金
    disability_company      REAL DEFAULT 0,             -- 残保金公司比例%
    disability_personal     REAL DEFAULT 0,             -- 残保金个人比例%
    --
    config_status           TEXT DEFAULT 'ACTIVE',      -- ACTIVE/DISABLED
    remark                  TEXT,
    created_at              TEXT DEFAULT (datetime('now')),
    updated_at              TEXT DEFAULT (datetime('now')),
    created_by              TEXT,
    updated_by              TEXT,
    UNIQUE(region_code, config_year)
);

-- 3. salary_tax_config 个税配置
-- 累计预扣法税率表, 按年度配置
CREATE TABLE IF NOT EXISTS salary_tax_config (
    tax_id                  TEXT PRIMARY KEY,
    config_year             INTEGER NOT NULL,           -- 适用年度
    tax_threshold           REAL NOT NULL DEFAULT 5000, -- 起征点(月)
    bracket_min             REAL NOT NULL,              -- 累计预扣预缴应纳税所得额下限
    bracket_max             REAL,                       -- 上限(NULL=无上限)
    tax_rate                REAL NOT NULL,              -- 税率%
    quick_deduction         REAL NOT NULL DEFAULT 0,    -- 速算扣除数
    sort_order              INTEGER DEFAULT 0,          -- 排序
    created_at              TEXT DEFAULT (datetime('now')),
    UNIQUE(config_year, bracket_min)
);

-- 4. salary_batch 发薪批次
CREATE TABLE IF NOT EXISTS salary_batch (
    batch_id                TEXT PRIMARY KEY,
    batch_no                TEXT UNIQUE NOT NULL,       -- 批次编号(如SB-202606)
    batch_month             TEXT NOT NULL,              -- 年月(如2026-06)
    batch_name              TEXT,                       -- 批次名称(如2026年6月薪资)
    employee_count          INTEGER DEFAULT 0,          -- 发薪人数
    gross_pay_total         REAL DEFAULT 0,             -- 应发合计
    net_pay_total           REAL DEFAULT 0,             -- 实发合计
    company_cost_total      REAL DEFAULT 0,             -- 公司成本合计
    tax_total               REAL DEFAULT 0,             -- 个税合计
    social_insurance_company_total REAL DEFAULT 0,      -- 社保(公司)合计
    social_insurance_personal_total REAL DEFAULT 0,     -- 社保(个人)合计
    housing_fund_company_total REAL DEFAULT 0,          -- 公积金(公司)合计
    housing_fund_personal_total REAL DEFAULT 0,         -- 公积金(个人)合计
    batch_status            TEXT DEFAULT 'DRAFT',       -- DRAFT/GENERATED/PENDING_APPROVAL/APPROVED/PAID/CANCELLED
    approval_id             TEXT,                       -- 审批单ID(逻辑FK→admin)
    generated_at            TEXT,                       -- 生成明细时间
    submitted_at            TEXT,                       -- 提交审批时间
    approved_at             TEXT,                       -- 审批通过时间
    paid_at                 TEXT,                       -- 发放时间
    remark                  TEXT,
    created_at              TEXT DEFAULT (datetime('now')),
    updated_at              TEXT DEFAULT (datetime('now')),
    created_by              TEXT,
    updated_by              TEXT
);

-- 5. salary_record 月度薪资明细
-- 每人每月一条记录, 由批次生成
CREATE TABLE IF NOT EXISTS salary_record (
    record_id               TEXT PRIMARY KEY,
    batch_id                TEXT NOT NULL,              -- FK→salary_batch
    member_id               TEXT NOT NULL,              -- FK→member(逻辑外键)
    member_name             TEXT NOT NULL,              -- 冗余: 人员姓名
    department_name         TEXT,                       -- 冗余: 部门名称
    position_type           TEXT,                       -- 冗余: 岗位类型
    position_grade          TEXT,                       -- 职务等级
    rank_grade              TEXT,                       -- 职级等级
    region_code             TEXT,                       -- 社保区域
    is_probation            INTEGER DEFAULT 0,          -- 是否试用期
    structure_id            TEXT,                       -- FK→salary_structure
    -- 应发部分
    base_salary             REAL DEFAULT 0,             -- 基本工资
    position_allowance      REAL DEFAULT 0,             -- 岗位工资
    rank_salary             REAL DEFAULT 0,             -- 职级工资
    duty_salary             REAL DEFAULT 0,             -- 职务工资
    transport_subsidy       REAL DEFAULT 0,             -- 交通补贴
    computer_subsidy        REAL DEFAULT 0,             -- 电脑补贴
    meal_subsidy            REAL DEFAULT 0,             -- 午餐补贴
    other_subsidy           REAL DEFAULT 0,             -- 其他补贴
    gross_pay               REAL DEFAULT 0,             -- 应发合计
    -- 考勤相关
    attendance_days         INTEGER DEFAULT 0,          -- 出勤天数
    clock_days              INTEGER DEFAULT 0,          -- 打卡天数
    leave_days              REAL DEFAULT 0,             -- 请假天数
    annual_leave_days       REAL DEFAULT 0,             -- 年假调休天数
    attendance_pay          REAL DEFAULT 0,             -- 考勤工资(出勤折算后)
    salary_pay              REAL DEFAULT 0,             -- 工资(实际)
    -- 扣款
    attendance_deduction    REAL DEFAULT 0,             -- 考勤扣款
    other_deduction         REAL DEFAULT 0,             -- 其他扣款
    -- 调整
    adjustment              REAL DEFAULT 0,             -- 调整金额
    bonus                   REAL DEFAULT 0,             -- 奖金
    -- 社保公积金(公司)
    company_pension         REAL DEFAULT 0,             -- 公司养老
    company_medical         REAL DEFAULT 0,             -- 公司医疗
    company_unemployment    REAL DEFAULT 0,             -- 公司失业
    company_injury          REAL DEFAULT 0,             -- 公司工伤
    company_maternity       REAL DEFAULT 0,             -- 公司生育
    company_housing         REAL DEFAULT 0,             -- 公司公积金
    company_disability      REAL DEFAULT 0,             -- 公司残保金
    company_social_total    REAL DEFAULT 0,             -- 公司五险合计
    company_housing_total   REAL DEFAULT 0,             -- 公司公积金合计
    company_total           REAL DEFAULT 0,             -- 公司总计
    -- 社保公积金(个人)
    personal_pension        REAL DEFAULT 0,             -- 个人养老
    personal_medical        REAL DEFAULT 0,             -- 个人医疗
    personal_unemployment   REAL DEFAULT 0,             -- 个人失业
    personal_injury         REAL DEFAULT 0,             -- 个人工伤(通常0)
    personal_maternity      REAL DEFAULT 0,             -- 个人生育(通常0)
    personal_housing        REAL DEFAULT 0,             -- 个人公积金
    personal_disability     REAL DEFAULT 0,             -- 个人残保金(通常0)
    personal_social_total   REAL DEFAULT 0,             -- 个人五险合计
    personal_housing_total  REAL DEFAULT 0,             -- 个人公积金合计
    personal_total          REAL DEFAULT 0,             -- 个人总计
    -- 个税
    pre_tax_amount          REAL DEFAULT 0,             -- 税前金额
    cumulative_income       REAL DEFAULT 0,             -- 累计收入
    cumulative_deduction    REAL DEFAULT 0,             -- 累计减免税额
    cumulative_taxable      REAL DEFAULT 0,             -- 累计应纳税所得额
    tax_rate                REAL DEFAULT 0,             -- 适用税率%
    quick_deduction         REAL DEFAULT 0,             -- 速算扣除数
    cumulative_tax          REAL DEFAULT 0,             -- 累计应纳税额
    cumulative_paid_tax     REAL DEFAULT 0,             -- 已累计缴税
    tax_amount              REAL DEFAULT 0,             -- 本月个税
    -- 实发
    net_pay                 REAL DEFAULT 0,             -- 实发工资
    -- 公司成本
    company_cost            REAL DEFAULT 0,             -- 公司成本 = gross_pay + company_total
    --
    is_manual               INTEGER DEFAULT 0,          -- 是否手动调整过
    remark                  TEXT,
    created_at              TEXT DEFAULT (datetime('now')),
    updated_at              TEXT DEFAULT (datetime('now')),
    created_by              TEXT,
    updated_by              TEXT,
    UNIQUE(batch_id, member_id)
);

-- 6. salary_change_log 薪资变更记录
-- 记录所有薪资结构的变更历史
CREATE TABLE IF NOT EXISTS salary_change_log (
    log_id                  TEXT PRIMARY KEY,
    member_id               TEXT NOT NULL,
    change_type             TEXT NOT NULL,              -- NEW/ADJUST/PROMOTION/PROBATION_END/OTHER
    old_structure_id        TEXT,                       -- 变更前结构ID
    new_structure_id        TEXT,                       -- 变更后结构ID
    old_total               REAL,                       -- 变更前应发合计
    new_total               REAL,                       -- 变更后应发合计
    change_amount           REAL,                       -- 变动金额(正=涨, 负=降)
    change_reason           TEXT,
    effective_date          TEXT NOT NULL,              -- 生效日期
    created_at              TEXT DEFAULT (datetime('now')),
    created_by              TEXT
);

-- ============================================
-- 索引
-- ============================================
-- salary_structure 索引
CREATE INDEX IF NOT EXISTS idx_ss_member ON salary_structure(member_id);
CREATE INDEX IF NOT EXISTS idx_ss_current ON salary_structure(member_id, is_current);
CREATE INDEX IF NOT EXISTS idx_ss_effective ON salary_structure(effective_date);

-- salary_social_insurance 索引
CREATE INDEX IF NOT EXISTS idx_si_region ON salary_social_insurance(region_code);
CREATE INDEX IF NOT EXISTS idx_si_year ON salary_social_insurance(config_year);
CREATE INDEX IF NOT EXISTS idx_si_region_year ON salary_social_insurance(region_code, config_year);

-- salary_tax_config 索引
CREATE INDEX IF NOT EXISTS idx_tc_year ON salary_tax_config(config_year);

-- salary_batch 索引
CREATE INDEX IF NOT EXISTS idx_sb_month ON salary_batch(batch_month);
CREATE INDEX IF NOT EXISTS idx_sb_status ON salary_batch(batch_status);
CREATE INDEX IF NOT EXISTS idx_sb_no ON salary_batch(batch_no);

-- salary_record 索引
CREATE INDEX IF NOT EXISTS idx_sr_batch ON salary_record(batch_id);
CREATE INDEX IF NOT EXISTS idx_sr_member ON salary_record(member_id);
CREATE INDEX IF NOT EXISTS idx_sr_batch_member ON salary_record(batch_id, member_id);
CREATE INDEX IF NOT EXISTS idx_sr_department ON salary_record(department_name);
CREATE INDEX IF NOT EXISTS idx_sr_position ON salary_record(position_type);

-- salary_change_log 索引
CREATE INDEX IF NOT EXISTS idx_scl_member ON salary_change_log(member_id);
CREATE INDEX IF NOT EXISTS idx_scl_type ON salary_change_log(change_type);
CREATE INDEX IF NOT EXISTS idx_scl_date ON salary_change_log(effective_date);
```

---

## 初始化数据

### 个税税率表 (2026年度)

```sql
INSERT OR IGNORE INTO salary_tax_config (tax_id, config_year, tax_threshold, bracket_min, bracket_max, tax_rate, quick_deduction, sort_order) VALUES
('tax-2026-1', 2026, 5000, 0, 36000, 3, 0, 1),
('tax-2026-2', 2026, 5000, 36000, 144000, 10, 2520, 2),
('tax-2026-3', 2026, 5000, 144000, 300000, 20, 16920, 3),
('tax-2026-4', 2026, 5000, 300000, 420000, 25, 31920, 4),
('tax-2026-5', 2026, 5000, 420000, 660000, 30, 52920, 5),
('tax-2026-6', 2026, 5000, 660000, 960000, 35, 85920, 6),
('tax-2026-7', 2026, 5000, 960000, NULL, 45, 181920, 7);
```

### 社保公积金默认配置 (北京2026)

```sql
INSERT OR IGNORE INTO salary_social_insurance (
    insurance_id, region_code, region_name, config_year,
    base_min, base_max,
    pension_company, pension_personal,
    medical_company, medical_personal,
    unemployment_company, unemployment_personal,
    injury_company, injury_personal,
    maternity_company, maternity_personal,
    housing_company, housing_personal,
    disability_company, disability_personal
) VALUES (
    'si-BJ-2026', 'BJ', '北京', 2026,
    6326, 35283,
    16, 8,
    9.8, 2,
    0.5, 0.5,
    0.2, 0,
    0.8, 0,
    12, 12,
    1.5, 0
);
```

---

## 枚举值速查

```
-- salary_structure.is_current
1 / 0

-- salary_structure.change_reason
入职定薪 / 年度调薪 / 晋升调薪 / 转正调薪 / 其他

-- salary_batch.batch_status
DRAFT / GENERATED / PENDING_APPROVAL / APPROVED / PAID / CANCELLED

-- salary_social_insurance.config_status
ACTIVE / DISABLED

-- salary_change_log.change_type
NEW / ADJUST / PROMOTION / PROBATION_END / OTHER
```
