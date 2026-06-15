# Timesheet SQL建表脚本 (对象线8号: Timesheet)

> 数据库: timesheet.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)

```sql
-- ============================================================
-- timesheet.db 全量建表脚本
-- 对象线8号: Timesheet
-- ============================================================

-- 1. WorkCategory 工作类别字典
CREATE TABLE IF NOT EXISTS work_category (
    category_id      TEXT PRIMARY KEY,
    category_code    TEXT UNIQUE NOT NULL,
    category_name    TEXT NOT NULL,
    category_group   TEXT NOT NULL,       -- CENTER_LAUNCH/CENTER_OPS/CENTER_CLOSE/MONITOR/RECRUIT/PM_WORK/CTA_WORK/ETHICS/CONTRACT/OTHER
    is_site_required INTEGER DEFAULT 0,   -- 是否需要关联中心 0/1
    is_active        INTEGER DEFAULT 1,
    sort_order       INTEGER DEFAULT 0,
    created_at       TEXT DEFAULT (datetime('now'))
);

-- 2. WeeklyTimesheet 周工时（核心唯一表）
CREATE TABLE IF NOT EXISTS weekly_timesheet (
    entry_id           TEXT PRIMARY KEY,
    member_id          TEXT NOT NULL,       -- FK→member.db.member
    week_start         TEXT NOT NULL,       -- 周起始日（周一），系统自动计算
    -- 计划周期
    plan_date_start    TEXT,                -- 默认=本周五
    plan_date_end      TEXT,                -- 默认=下周四
    -- 实际周期
    actual_date_start  TEXT,                -- 默认=上周五
    actual_date_end    TEXT,                -- 默认=本周四
    -- 项目关联
    project_id         TEXT,                -- FK→project.db.project，非项目=空
    project_site_id    TEXT,                -- FK→site.db.project_site，可空
    publisher_id       TEXT,                -- FK→member.db.member，安排任务的PM/领导
    position_role      TEXT,                -- 本项目角色：PM/APM/CRA/CRC/CTA/DM/SA/QA/其他
    -- 非项目标记
    is_non_project     INTEGER DEFAULT 0,   -- 0=项目工作，1=非项目工作
    non_project_type   TEXT,                -- TRAINING/MEETING/LEAVE/ADMIN/OTHER
    -- 计划
    plan_category_id   TEXT,                -- FK→work_category
    plan_content       TEXT,
    plan_hours         REAL,
    -- 实际
    actual_category_id TEXT,                -- FK→work_category
    actual_content     TEXT,
    actual_hours       REAL,
    -- 其他
    adhoc_task         TEXT,                -- 临时任务@提醒
    remark             TEXT,
    entry_status       TEXT DEFAULT 'PLANNING',  -- PLANNING/REPORTED/CONFIRMED
    created_at         TEXT DEFAULT (datetime('now')),
    updated_at         TEXT DEFAULT (datetime('now')),

    UNIQUE(member_id, week_start, project_id, project_site_id, is_non_project, non_project_type)
);

-- 3. ProjectBudget 项目工时预算
CREATE TABLE IF NOT EXISTS project_budget (
    budget_id        TEXT PRIMARY KEY,
    project_id       TEXT NOT NULL,          -- FK→project.db.project
    position_role    TEXT NOT NULL,          -- PM/APM/CRA/CRC/CTA/...
    budget_hours     REAL NOT NULL,
    start_from       TEXT,                   -- 预算起始阶段描述
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),

    UNIQUE(project_id, position_role)
);

-- ============================================================
-- 索引
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_wt_member ON weekly_timesheet(member_id);
CREATE INDEX IF NOT EXISTS idx_wt_member_week ON weekly_timesheet(member_id, week_start);
CREATE INDEX IF NOT EXISTS idx_wt_project ON weekly_timesheet(project_id);
CREATE INDEX IF NOT EXISTS idx_wt_project_site ON weekly_timesheet(project_site_id);
CREATE INDEX IF NOT EXISTS idx_wt_week ON weekly_timesheet(week_start);
CREATE INDEX IF NOT EXISTS idx_wt_actual_start ON weekly_timesheet(actual_date_start);
CREATE INDEX IF NOT EXISTS idx_wt_plan_start ON weekly_timesheet(plan_date_start);
CREATE INDEX IF NOT EXISTS idx_wt_status ON weekly_timesheet(entry_status);
CREATE INDEX IF NOT EXISTS idx_wt_member_project ON weekly_timesheet(member_id, project_id);
CREATE INDEX IF NOT EXISTS idx_wt_non_project ON weekly_timesheet(is_non_project);
CREATE INDEX IF NOT EXISTS idx_wt_role ON weekly_timesheet(position_role);
CREATE INDEX IF NOT EXISTS idx_wt_plan_category ON weekly_timesheet(plan_category_id);
CREATE INDEX IF NOT EXISTS idx_wt_actual_category ON weekly_timesheet(actual_category_id);

CREATE INDEX IF NOT EXISTS idx_pb_project ON project_budget(project_id);
```

---

## 预置工作类别数据

```sql
-- 中心运营类（需关联中心）
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'SITE_DAILY', '中心日常维护与管理', 'CENTER_OPS', 1, 10),
(lower(hex(randomblob(4))), 'ROUTINE_MONITOR', '常规监查', 'MONITOR', 1, 20),
(lower(hex(randomblob(4))), 'SDV', '原始数据核查(SDV)', 'MONITOR', 1, 21),
(lower(hex(randomblob(4))), 'REMOTE_MONITOR', '远程监查', 'MONITOR', 1, 22),
(lower(hex(randomblob(4))), 'DATA_QUERY', '数据质疑处理', 'CENTER_OPS', 1, 11);

-- 中心启动类（需关联中心）
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'SITE_LAUNCH', '中心启动会', 'CENTER_LAUNCH', 1, 30),
(lower(hex(randomblob(4))), 'SITE_PREP', '中心启动准备', 'CENTER_LAUNCH', 1, 31),
(lower(hex(randomblob(4))), 'SITE_CONFIRM', '中心名单确认', 'CENTER_LAUNCH', 1, 32),
(lower(hex(randomblob(4))), 'FILE_SETUP', '文件夹建立和寄送', 'CENTER_LAUNCH', 1, 33);

-- 中心关闭类（需关联中心）
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'SITE_CLOSE', '中心关闭访视、药品回收', 'CENTER_CLOSE', 1, 40);

-- 招募类（需关联中心）
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'RECRUIT', '受试者招募', 'RECRUIT', 1, 50);

-- 伦理/协议类（不需关联中心）
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'ETHICS_SUBMIT', '伦理资料递交', 'ETHICS', 0, 60),
(lower(hex(randomblob(4))), 'ETHICS_FOLLOW', '伦理批准跟踪', 'ETHICS', 0, 61),
(lower(hex(randomblob(4))), 'CONTRACT_SIGN', '协议签署推进', 'CONTRACT', 0, 70);

-- PM/管理类（不需关联中心）
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'PM_PLAN', '工作规划及任务下达', 'PM_WORK', 0, 80),
(lower(hex(randomblob(4))), 'PM_DAILY', '项目日常维护与管理', 'PM_WORK', 0, 81),
(lower(hex(randomblob(4))), 'PM_SETUP', '项目管理机制构建', 'PM_WORK', 0, 82);

-- CTA类（不需关联中心）
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'CTA_PRINT', '文件打印签字盖章', 'CTA_WORK', 0, 90),
(lower(hex(randomblob(4))), 'CTA_REVIEW', '文件审核质控', 'CTA_WORK', 0, 91);

-- 其他类
INSERT OR IGNORE INTO work_category (category_id, category_code, category_name, category_group, is_site_required, sort_order) VALUES
(lower(hex(randomblob(4))), 'TRAINING', '培训', 'OTHER', 0, 100),
(lower(hex(randomblob(4))), 'MEETING', '会议', 'OTHER', 0, 101),
(lower(hex(randomblob(4))), 'LEAVE', '请假', 'OTHER', 0, 102),
(lower(hex(randomblob(4))), 'OTHER', '其他', 'OTHER', 0, 199);
```

---

## 枚举值速查

```
-- weekly_timesheet.entry_status
PLANNING / REPORTED / CONFIRMED

-- weekly_timesheet.is_non_project
0 = 项目工作 / 1 = 非项目工作

-- weekly_timesheet.non_project_type
TRAINING / MEETING / LEAVE / ADMIN / OTHER

-- weekly_timesheet.position_role
PM / APM / CRA / CRC / CTA / DM / SA / QA / 其他

-- work_category.category_group
CENTER_LAUNCH / CENTER_OPS / CENTER_CLOSE / MONITOR / RECRUIT / PM_WORK / CTA_WORK / ETHICS / CONTRACT / OTHER
```

---

## 业务规则（应用层实现）

1. 填报日：每周四，填上周五~本周四的实际 + 本周五~下周四的计划
2. 周四法定节假日 → 顺延到周日
3. week_start取当周周一，仅作为周期标识和唯一约束用
4. 月度统计用 actual_date_start 判断归属月份
5. 每人每周 plan_hours 合计应接近 40h，不满40h需在remark说明
6. 一行 = 一人一项目一周（计划+实际同行）
7. 非项目工作 is_non_project=1 + non_project_type 分类，project_id=空
8. 工作类别必须从 work_category 字典选取
9. 人员姓名/职位实时从 member.db 读，不冗余
10. 工时预算 vs 实际：SUM(actual_hours) vs project_budget.budget_hours
