# 培训管理SQL建表脚本 (对象线13号线: Training)

> 数据库: training.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js

---

## 一、数据库概览

### 1.1 表清单

| 序号 | 表名 | 说明 |
|------|------|------|
| 1 | training_plan | 培训计划 |
| 2 | training_record | 培训记录 |
| 3 | training_certificate | 培训证书/资质 |
| 4 | training_material | 培训材料/课件 |
| 5 | training_attendance | 培训签到 |
| 6 | project_training_plan | 项目培训计划 |
| 7 | project_training_record | 项目培训记录 |
| 8 | cert_template | 证书模板 |

---

## 二、建表脚本

```sql
-- ============================================
-- training.db 全量建表脚本
-- 对象线13号线: CRO临床试验培训管理
-- ============================================

-- 1. 培训计划 (Training Plan)
CREATE TABLE IF NOT EXISTS training_plan (
    plan_id              TEXT PRIMARY KEY,
    plan_no              TEXT NOT NULL UNIQUE,      -- TP-YYYY-NNNNN
    plan_name            TEXT NOT NULL,
    training_type        TEXT NOT NULL,            -- GCP/方案/EDC/SOP/其他
    training_mode        TEXT NOT NULL,            -- 线下/线上/直播
    training_date        TEXT NOT NULL,             -- 计划培训日期
    training_duration    REAL DEFAULT 0,            -- 培训时长(小时)
    training_outline     TEXT,                      -- 培训大纲
    location             TEXT,                      -- 线下地点或线上链接
    department           TEXT,                      -- 负责部门
    trainer              TEXT,                      -- 培训讲师
    -- 参与人员范围
    target_type          TEXT NOT NULL,             -- 全体人员/CRA/CRC/PM/指定人员
    target_member_ids    TEXT,                      -- 指定人员ID数组(JSON)
    planned_count        INTEGER DEFAULT 0,         -- 计划参与人数(冗余)
    -- 课件关联
    material_id          TEXT,                      -- FK→training_material.material_id
    -- 状态
    plan_status          TEXT DEFAULT 'DRAFT',      -- DRAFT/PUBLISHED/IN_PROGRESS/COMPLETED/CANCELLED
    published_at         TEXT,                      -- 发布时间
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 2. 培训记录 (Training Record)
CREATE TABLE IF NOT EXISTS training_record (
    record_id            TEXT PRIMARY KEY,
    record_no            TEXT NOT NULL UNIQUE,      -- TR-YYYY-NNNNN
    plan_id              TEXT NOT NULL,             -- FK→training_plan.plan_id
    training_date        TEXT NOT NULL,             -- 实际培训日期
    training_duration    REAL DEFAULT 0,           -- 实际培训时长
    attended_count       INTEGER DEFAULT 0,        -- 实际参加人数
    absent_count         INTEGER DEFAULT 0,       -- 缺席人数
    completion_rate      REAL DEFAULT 0,          -- 完成率(%)
    -- 考核
    has_exam             INTEGER DEFAULT 0,        -- 是否需要考核
    pass_score           REAL DEFAULT 0,           -- 及格分数
    exam_pass_rate       REAL DEFAULT 0,          -- 考核通过率
    -- 培训材料
    training_materials   TEXT,                      -- 培训使用材料(JSON数组)
    record_file_path     TEXT,                      -- 培训记录文件路径
    photos_path          TEXT,                      -- 现场照片路径(JSON数组)
    -- 状态
    record_status        TEXT DEFAULT 'PENDING',   -- PENDING/COMPLETED/CANCELLED
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 3. 培训证书 (Training Certificate)
CREATE TABLE IF NOT EXISTS training_certificate (
    cert_id              TEXT PRIMARY KEY,
    cert_no              TEXT NOT NULL,             -- 证书编号(GCP-YYYY-NNNNN)
    member_id            TEXT NOT NULL,             -- FK→member.member_id(跨库)
    member_name          TEXT,                      -- 冗余：持证人姓名
    cert_type            TEXT NOT NULL,            -- GCP/方案/EDC/SOP/其他
    cert_name            TEXT,                      -- 证书名称
    issue_date           TEXT NOT NULL,             -- 发证日期
    expiry_date          TEXT,                      -- 有效期(可为NULL表示长期)
    cert_status          TEXT DEFAULT 'VALID',     -- VALID/EXPIRING/EXPIRED
    -- 关联培训
    training_plan_id     TEXT,                      -- 关联培训计划
    training_record_id   TEXT,                      -- 关联培训记录
    -- 证书文件
    cert_file_path       TEXT,                      -- 证书扫描件路径
    -- 来源
    cert_source          TEXT DEFAULT 'TRAINING',  -- TRAINING(培训获取)/MANUAL(手动录入)/IMPORT(导入)
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT,
    UNIQUE(member_id, cert_type, cert_no)
);

-- 4. 培训材料 (Training Material)
CREATE TABLE IF NOT EXISTS training_material (
    material_id          TEXT PRIMARY KEY,
    material_name        TEXT NOT NULL,
    material_type        TEXT NOT NULL,            -- 课件/视频/文档/模板
    file_type            TEXT,                      -- pptx/pdf/mp4/docx等
    file_size            INTEGER,                   -- 文件大小(字节)
    file_path            TEXT,                      -- 文件存储路径
    -- 分类
    category             TEXT,                      -- 分类(GCP/方案/EDC/SOP)
    folder_id            TEXT,                      -- 上级文件夹ID
    -- 元数据
    duration             REAL,                      -- 视频时长(分钟)
    page_count           INTEGER,                   -- 文档页数
    -- 统计
    download_count       INTEGER DEFAULT 0,        -- 下载次数
    view_count           INTEGER DEFAULT 0,        -- 浏览次数
    -- 状态
    material_status      TEXT DEFAULT 'ACTIVE',    -- ACTIVE/ARCHIVED/DELETED
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 5. 培训签到 (Training Attendance)
CREATE TABLE IF NOT EXISTS training_attendance (
    attendance_id        TEXT PRIMARY KEY,
    record_id            TEXT NOT NULL,             -- FK→training_record.record_id
    member_id            TEXT NOT NULL,             -- FK→member.member_id(跨库)
    member_name          TEXT,                      -- 冗余：人员姓名
    department           TEXT,                      -- 部门
    position             TEXT,                      -- 职位
    -- 签到状态
    attendance_status    TEXT DEFAULT 'PENDING',   -- PENDING/SIGNED/ABSENT/LATE/EXCUSED
    sign_in_time         TEXT,                      -- 签到时间
    sign_out_time        TEXT,                      -- 签退时间
    -- 考核成绩
    has_exam             INTEGER DEFAULT 0,        -- 是否参加考核
    exam_score           REAL,                      -- 考核分数
    exam_status          TEXT,                      -- PASS/FAIL/EXEMPT
    -- 证书
    cert_issued          INTEGER DEFAULT 0,        -- 是否发放证书
    cert_id              TEXT,                      -- FK→training_certificate.cert_id
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT,
    UNIQUE(record_id, member_id)
);

-- 6. 证书模板 (Certificate Template)
CREATE TABLE IF NOT EXISTS training_cert_template (
    template_id          TEXT PRIMARY KEY,
    template_name        TEXT NOT NULL,
    cert_type            TEXT NOT NULL,            -- GCP/方案/EDC/SOP/其他
    template_file_path   TEXT,                      -- 模板文件路径(pptx/pdf)
    template_content     TEXT,                      -- 模板内容(JSON配置)
    is_default           INTEGER DEFAULT 0,        -- 是否默认模板
    -- 状态
    template_status      TEXT DEFAULT 'ACTIVE',    -- ACTIVE/ARCHIVED
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 7. 项目培训计划 (Project Training Plan)
CREATE TABLE IF NOT EXISTS project_training_plan (
    project_plan_id      TEXT PRIMARY KEY,
    project_plan_no      TEXT NOT NULL UNIQUE,     -- PTP-YYYY-NNNNN
    project_id           TEXT NOT NULL,             -- FK→project.project_id(跨库)
    plan_name            TEXT NOT NULL,
    training_type        TEXT NOT NULL,            -- GCP/方案/EDC/SOP/项目专属
    training_mode        TEXT NOT NULL,            -- 线下/线上/直播
    training_date        TEXT NOT NULL,             -- 培训日期
    -- 参与范围
    target_scope         TEXT NOT NULL,            -- 全体项目人员/指定中心/指定人员
    site_ids             TEXT,                      -- 指定中心ID数组(JSON)
    member_ids           TEXT,                      -- 指定人员ID数组(JSON)
    target_count         INTEGER DEFAULT 0,        -- 目标人数(冗余)
    -- 培训要求
    is_required          INTEGER DEFAULT 1,        -- 是否必修
    need_exam            INTEGER DEFAULT 0,      -- 是否需要考核
    pass_score           REAL DEFAULT 0,           -- 及格分数
    issue_certificate     INTEGER DEFAULT 1,        -- 是否发放证书
    cert_template_id     TEXT,                      -- 证书模板ID
    -- 课件
    material_id          TEXT,                      -- FK→training_material.material_id
    -- 状态
    plan_status          TEXT DEFAULT 'DRAFT',    -- DRAFT/PUBLISHED/IN_PROGRESS/COMPLETED/CANCELLED
    completed_count      INTEGER DEFAULT 0,        -- 已完成人数(冗余)
    completion_rate       REAL DEFAULT 0,          -- 完成率(%)
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 8. 项目培训记录 (Project Training Record)
CREATE TABLE IF NOT EXISTS project_training_record (
    project_record_id    TEXT PRIMARY KEY,
    project_record_no    TEXT NOT NULL UNIQUE,     -- PTR-YYYY-NNNNN
    project_plan_id      TEXT NOT NULL,             -- FK→project_training_plan.project_plan_id
    project_id           TEXT NOT NULL,             -- FK→project.project_id(跨库)
    training_date        TEXT NOT NULL,             -- 实际培训日期
    attended_count       INTEGER DEFAULT 0,        -- 参加人数
    completed_count      INTEGER DEFAULT 0,       -- 完成人数(含考核通过)
    completion_rate      REAL DEFAULT 0,           -- 完成率
    -- 考核
    exam_count           INTEGER DEFAULT 0,        -- 参加考核人数
    exam_pass_count      INTEGER DEFAULT 0,       -- 考核通过人数
    exam_pass_rate       REAL DEFAULT 0,           -- 考核通过率
    -- 证书
    cert_issued_count    INTEGER DEFAULT 0,        -- 已发放证书数
    -- 状态
    record_status        TEXT DEFAULT 'PENDING',   -- PENDING/COMPLETED
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 9. 项目培训参与人员 (Project Training Attendance)
CREATE TABLE IF NOT EXISTS project_training_attendance (
    id                   TEXT PRIMARY KEY,
    project_record_id    TEXT NOT NULL,             -- FK→project_training_record.project_record_id
    member_id            TEXT NOT NULL,             -- FK→member.member_id(跨库)
    member_name           TEXT,                      -- 冗余
    project_site_id      TEXT,                      -- FK→project_site.project_site_id(跨库)
    site_name             TEXT,                      -- 冗余：中心名称
    -- 参与状态
    attendance_status    TEXT DEFAULT 'PENDING',   -- PENDING/SIGNED/ABSENT/EXCUSED
    sign_in_time         TEXT,                      -- 签到时间
    -- 考核
    has_exam             INTEGER DEFAULT 0,
    exam_score           REAL,
    exam_status          TEXT,                      -- PASS/FAIL/EXEMPT
    -- 证书
    cert_issued          INTEGER DEFAULT 0,
    cert_id              TEXT,                      -- FK→training_certificate.cert_id
    -- 合规
    gcp_valid            INTEGER DEFAULT 1,        -- GCP证书是否有效
    -- 时间戳
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT,
    UNIQUE(project_record_id, member_id)
);

-- ============================================
-- 索引
-- ============================================

-- training_plan 索引
CREATE INDEX IF NOT EXISTS idx_tp_plan_no ON training_plan(plan_no);
CREATE INDEX IF NOT EXISTS idx_tp_type ON training_plan(training_type);
CREATE INDEX IF NOT EXISTS idx_tp_mode ON training_plan(training_mode);
CREATE INDEX IF NOT EXISTS idx_tp_date ON training_plan(training_date);
CREATE INDEX IF NOT EXISTS idx_tp_status ON training_plan(plan_status);
CREATE INDEX IF NOT EXISTS idx_tp_target ON training_plan(target_type);

-- training_record 索引
CREATE INDEX IF NOT EXISTS idx_tr_record_no ON training_record(record_no);
CREATE INDEX IF NOT EXISTS idx_tr_plan ON training_record(plan_id);
CREATE INDEX IF NOT EXISTS idx_tr_date ON training_record(training_date);
CREATE INDEX IF NOT EXISTS idx_tr_status ON training_record(record_status);

-- training_certificate 索引
CREATE INDEX IF NOT EXISTS idx_tc_member ON training_certificate(member_id);
CREATE INDEX IF NOT EXISTS idx_tc_type ON training_certificate(cert_type);
CREATE INDEX IF NOT EXISTS idx_tc_status ON training_certificate(cert_status);
CREATE INDEX IF NOT EXISTS idx_tc_expiry ON training_certificate(expiry_date);
CREATE INDEX IF NOT EXISTS idx_tc_no ON training_certificate(cert_no);

-- training_material 索引
CREATE INDEX IF NOT EXISTS idx_tm_name ON training_material(material_name);
CREATE INDEX IF NOT EXISTS idx_tm_type ON training_material(material_type);
CREATE INDEX IF NOT EXISTS idx_tm_category ON training_material(category);
CREATE INDEX IF NOT EXISTS idx_tm_folder ON training_material(folder_id);

-- training_attendance 索引
CREATE INDEX IF NOT EXISTS idx_ta_record ON training_attendance(record_id);
CREATE INDEX IF NOT EXISTS idx_ta_member ON training_attendance(member_id);
CREATE INDEX IF NOT EXISTS idx_ta_status ON training_attendance(attendance_status);

-- training_cert_template 索引
CREATE INDEX IF NOT EXISTS idx_tct_type ON training_cert_template(cert_type);
CREATE INDEX IF NOT EXISTS idx_tct_default ON training_cert_template(is_default);

-- project_training_plan 索引
CREATE INDEX IF NOT EXISTS idx_ptp_project ON project_training_plan(project_id);
CREATE INDEX IF NOT EXISTS idx_ptp_plan_no ON project_training_plan(project_plan_no);
CREATE INDEX IF NOT EXISTS idx_ptp_type ON project_training_plan(training_type);
CREATE INDEX IF NOT EXISTS idx_ptp_date ON project_training_plan(training_date);
CREATE INDEX IF NOT EXISTS idx_ptp_status ON project_training_plan(plan_status);

-- project_training_record 索引
CREATE INDEX IF NOT EXISTS idx_ptr_project ON project_training_record(project_id);
CREATE INDEX IF NOT EXISTS idx_ptr_plan ON project_training_record(project_plan_id);
CREATE INDEX IF NOT EXISTS idx_ptr_record_no ON project_training_record(project_record_no);

-- project_training_attendance 索引
CREATE INDEX IF NOT EXISTS idx_pta_record ON project_training_attendance(project_record_id);
CREATE INDEX IF NOT EXISTS idx_pta_member ON project_training_attendance(member_id);
CREATE INDEX IF NOT EXISTS idx_pta_site ON project_training_attendance(project_site_id);
CREATE INDEX IF NOT EXISTS idx_pta_status ON project_training_attendance(attendance_status);
```

---

## 三、枚举值速查

```
-- training_plan.training_type
GCP / 方案 / EDC / SOP / 其他

-- training_plan.training_mode
线下 / 线上 / 直播

-- training_plan.target_type
全体人员 / CRA / CRC / PM / 指定人员

-- training_plan.plan_status
DRAFT / PUBLISHED / IN_PROGRESS / COMPLETED / CANCELLED

-- training_record.record_status
PENDING / COMPLETED / CANCELLED

-- training_certificate.cert_type
GCP / 方案 / EDC / SOP / 其他

-- training_certificate.cert_status
VALID / EXPIRING / EXPIRED

-- training_certificate.cert_source
TRAINING / MANUAL / IMPORT

-- training_attendance.attendance_status
PENDING / SIGNED / ABSENT / LATE / EXCUSED

-- training_attendance.exam_status
PASS / FAIL / EXEMPT

-- training_material.material_type
课件 / 视频 / 文档 / 模板

-- project_training_plan.target_scope
全体项目人员 / 指定中心 / 指定人员

-- project_training_plan.plan_status
DRAFT / PUBLISHED / IN_PROGRESS / COMPLETED / CANCELLED

-- project_training_attendance.attendance_status
PENDING / SIGNED / ABSENT / EXCUSED

-- project_training_attendance.exam_status
PASS / FAIL / EXEMPT
```

---

## 四、表关系说明

```
┌─────────────────┐       ┌─────────────────┐
│ training_plan   │──1:N──│ training_record │
│ (培训计划)       │       │ (培训记录)       │
└────────┬────────┘       └────────┬────────┘
         │                        │
         │ 1:N                    │ 1:N
         ▼                        ▼
┌─────────────────┐       ┌─────────────────┐
│ training_       │       │ training_      │
│ attendance      │       │ attendance      │
│ (培训签到)       │       │ (培训签到)       │
└────────┬────────┘       └────────┬────────┘
         │                        │
         │ N:1                    │
         └──────┬─────────────────┘
                │
                ▼
┌─────────────────┐       ┌─────────────────┐
│ training_      │       │ training_      │
│ certificate    │       │ material        │
│ (培训证书)       │       │ (培训材料)       │
└─────────────────┘       └─────────────────┘
                                │
                                │ 1:N
                                ▼
                        ┌─────────────────┐
                        │ cert_template   │
                        │ (证书模板)       │
                        └─────────────────┘

┌─────────────────┐       ┌─────────────────┐
│ project_       │──1:N──│ project_       │
│ training_plan  │       │ training_record │
│ (项目培训计划)   │       │ (项目培训记录)   │
└────────┬────────┘       └────────┬────────┘
         │                        │
         │ 1:N                    │ 1:N
         ▼                        ▼
┌─────────────────┐       ┌─────────────────┐
│ project_       │       │ project_       │
│ training_      │       │ training_      │
│ attendance     │       │ attendance     │
│ (项目培训签到)   │       │ (项目培训签到)   │
└─────────────────┘       └─────────────────┘
```

---

## 五、跨库引用说明

| 本表字段 | 引用表 | 说明 |
|---------|--------|------|
| training_certificate.member_id | member.db | 持证人员ID |
| training_attendance.member_id | member.db | 参训人员ID |
| project_training_plan.project_id | project.db | 项目ID |
| project_training_plan.site_ids | project.db | 中心ID数组 |
| project_training_plan.member_ids | member.db | 人员ID数组 |
| project_training_record.project_id | project.db | 项目ID |
| project_training_attendance.member_id | member.db | 人员ID |
| project_training_attendance.project_site_id | project.db | 中心ID |

**跨域数据调用规则：**
- 跨库关联数据不走物理外键
- 前端通过API调用获取关联数据
- 后端查询时用 LEFT JOIN 或应用层聚合

---

## 六、自动编号规则

| 类型 | 格式 | 示例 |
|------|------|------|
| 培训计划 | TP-YYYY-NNNNN | TP-2024-00001 |
| 培训记录 | TR-YYYY-NNNNN | TR-2024-00001 |
| GCP证书 | GCP-YYYY-NNNNN | GCP-2024-00001 |
| 方案证书 | PLAN-YYYY-NNNNN | PLAN-2024-00001 |
| 项目培训计划 | PTP-YYYY-NNNNN | PTP-2024-00001 |
| 项目培训记录 | PTR-YYYY-NNNNN | PTR-2024-00001 |

---

## 七、证书状态自动更新

```sql
-- 定时任务或查询时触发
UPDATE training_certificate SET cert_status =
    CASE
        WHEN expiry_date IS NULL THEN 'VALID'
        WHEN date(expiry_date) <= date('now', '+30 days') AND date(expiry_date) >= date('now') THEN 'EXPIRING'
        WHEN date(expiry_date) < date('now') THEN 'EXPIRED'
        ELSE 'VALID'
    END
WHERE cert_status != 'EXPIRED' OR expiry_date IS NOT NULL;
```

---

## 八、第一版不做

- ❌ 项目培训子中心明细表（先按项目维度管理）
- ❌ 外部培训记录表（对接外部培训系统）
- ❌ 培训效果评估表（问卷调查结果）
- ❌ 培训讲师库（仅记录在plan中）

---

*文档版本 V1.0 | 2026-06-20*
