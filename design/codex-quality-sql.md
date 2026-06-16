# Quality/CAPA Module SQL建表脚本 (对象线12号: Quality/CAPA)

> 数据库: quality.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js

---

## 一、设计理念

### 1.1 核心表设计思路

**质量/CAPA模块围绕"发现问题→制定措施→执行验证→闭环归档"的生命周期展开：**

1. **发现是入口**：质量发现（quality_finding）是一切的起点
2. **CAPA是核心**：纠正与预防措施（capa）针对发现制定，一个发现可对应多个CAPA
3. **任务是执行粒度**：CAPA任务（capa_task）将CAPA分解为可执行的具体任务
4. **稽查是来源**：质量稽查（quality_audit）是发现的重要来源
5. **指标是统计**：质量指标（quality_indicator）是定期快照，用于仪表盘展示

### 1.2 与其他模块的关系

```
project.db ──project_id──→ quality_finding ──finding_id──→ capa
                    │                               │
                    │──project_site_id──→ capa ─────┘
                    │                                     │
                    │                                     ↓
              team_assignment ←──responsible_id── capa_task
                    │                        │
                    │                        ↓
              member.db ←────────────────────────
```

**跨库引用说明：**
| 字段 | 引用表 | 说明 |
|------|--------|------|
| project_id | project.db | 项目ID |
| project_site_id | project.db | 中心ID |
| responsible_id | member.db | 负责人ID |
| related_inspection_id | quality_audit | 关联稽查记录 |

---

## 二、全量建表脚本

```sql
-- ============================================
-- quality.db 全量建表脚本
-- 对象线12号: Quality/CAPA
-- ============================================

-- 1. 质量发现 (Quality Finding)
CREATE TABLE IF NOT EXISTS quality_finding (
    finding_id            TEXT PRIMARY KEY,
    finding_no           TEXT NOT NULL UNIQUE,   -- QF-YYYY-NNNN格式
    project_id           TEXT NOT NULL,                       -- FK→project.db (逻辑外键)
    project_site_id      TEXT,                                -- FK→project.db (逻辑外键，可空)
    
    -- 发现基本信息
    finding_type         TEXT NOT NULL,    -- INTERNAL_AUDIT/SPONSOR_AUDIT/REGULATORY_INSPECTION/DEVIATION/OTHER
    severity            TEXT NOT NULL,    -- CRITICAL/MAJOR/MINOR/OBSERVATION
    found_date          TEXT NOT NULL,    -- 发现日期
    target_close_date   TEXT NOT NULL,    -- 目标闭环日期
    
    -- 描述与原因
    description         TEXT NOT NULL,    -- 发现描述
    root_cause          TEXT,             -- 根本原因分析
    
    -- 关联
    related_audit_id    TEXT,             -- 关联稽查记录 FK→quality_audit
    related_files       TEXT,             -- JSON: [{file_id, file_name, file_path, file_type}]
    
    -- 状态与时间
    finding_status      TEXT DEFAULT 'OPEN',  -- OPEN/IN_PROGRESS/PENDING_APPROVAL/VERIFIED/CLOSED
    actual_close_date   TEXT,             -- 实际关闭日期
    
    -- GCP要求字段
    impact_assessment   TEXT,             -- 影响评估
    regulatory_reference TEXT,            -- 法规参考（如GCP第5.2条）
    
    -- 统计字段（冗余，定期刷新）
    capa_count          INTEGER DEFAULT 0,       -- 关联CAPA数量
    capa_closed_count   INTEGER DEFAULT 0,       -- 已闭环CAPA数量
    
    -- 审计字段
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 2. CAPA措施 (Corrective and Preventive Action)
CREATE TABLE IF NOT EXISTS capa (
    capa_id              TEXT PRIMARY KEY,
    capa_no             TEXT NOT NULL UNIQUE,   -- CA/PA-{finding_no}-NNN
    finding_id           TEXT NOT NULL,                       -- FK→quality_finding
    
    -- CAPA基本信息
    capa_type           TEXT NOT NULL,    -- CA(纠正措施)/PA(预防措施)
    description         TEXT NOT NULL,    -- 措施描述
    priority            TEXT DEFAULT 'MEDIUM',  -- HIGH/MEDIUM/LOW
    
    -- 执行信息
    responsible_id      TEXT NOT NULL,               -- FK→member.db (逻辑外键)
    due_date            TEXT NOT NULL,    -- 截止日期
    status              TEXT DEFAULT 'PENDING',  -- PENDING/IN_PROGRESS/PENDING_VERIFICATION/VERIFIED/CLOSED/REJECTED
    
    -- 验证信息
    verification_method TEXT,             -- FILE_REVIEW/ON_SITE/SYSTEM/NO_VERIFICATION
    verified_by         TEXT,             -- 验证人
    verified_date       TEXT,             -- 验证日期
    verification_comment TEXT,            -- 验证意见
    
    -- 完成信息
    completion_date     TEXT,             -- 实际完成日期
    completion_desc     TEXT,             -- 完成说明
    
    -- 反驳信息
    rejected_by         TEXT,            -- 反驳人
    rejected_date        TEXT,            -- 反驳日期
    rejection_reason     TEXT,            -- 反驳原因
    
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 3. CAPA执行任务 (CAPA Task)
CREATE TABLE IF NOT EXISTS capa_task (
    task_id             TEXT PRIMARY KEY,
    task_no             TEXT NOT NULL,    -- 任务编号（内部使用）
    capa_id             TEXT NOT NULL,   -- FK→capa
    
    -- 任务信息
    task_description    TEXT NOT NULL,    -- 任务描述
    assignee_id         TEXT,                        -- FK→member.db (逻辑外键)
    due_date            TEXT,             -- 任务截止日期
    
    -- 状态
    task_status         TEXT DEFAULT 'PENDING',  -- PENDING/IN_PROGRESS/COMPLETED/CANCELLED
    
    -- 完成信息
    completed_date      TEXT,             -- 完成日期
    completion_comment  TEXT,             -- 完成说明
    completion_evidence TEXT,            -- 完成证明（文件路径JSON）
    
    -- 审计字段
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 4. 质量稽查/检查记录 (Quality Audit)
CREATE TABLE IF NOT EXISTS quality_audit (
    audit_id            TEXT PRIMARY KEY,
    audit_no            TEXT NOT NULL UNIQUE,   -- AUDIT-YYYY-NNNN
    
    -- 基本信息
    project_id          TEXT NOT NULL,           -- FK→project.db
    project_site_id     TEXT,                   -- FK→project.db
    audit_type          TEXT NOT NULL,    -- INTERNAL/SPONSOR/REGULATORY
    
    -- 稽查信息
    audit_org           TEXT NOT NULL,    -- 稽查机构/检查部门
    auditor             TEXT NOT NULL,    -- 稽查员/检查员姓名
    audit_date          TEXT NOT NULL,    -- 稽查日期
    
    -- 统计
    findings_count      INTEGER DEFAULT 0,   -- 本次发现数量
    
    -- 报告文件
    report_file_path    TEXT,             -- 稽查报告文件路径
    report_file_name    TEXT,             -- 原始文件名
    
    -- 状态
    audit_status        TEXT DEFAULT 'COMPLETED',  -- PLANNED/IN_PROGRESS/COMPLETED/CANCELLED
    
    -- 关联预约
    scheduled_date      TEXT,             -- 预约日期（计划稽查时）
    actual_end_date      TEXT,             -- 实际结束日期
    
    -- 审计字段
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 5. 质量指标快照 (Quality Indicator Snapshot)
CREATE TABLE IF NOT EXISTS quality_indicator (
    indicator_id       TEXT PRIMARY KEY,
    project_id          TEXT,                          -- FK→project.db (可空=全局)
    project_site_id     TEXT,                          -- FK→project.db (可空)
    indicator_type      TEXT NOT NULL,    -- FINDING_COUNT/DEVIATION_RATE/CAPA_CLOSE_RATE/TIMELY_RESOLUTION_RATE
    period_type         TEXT NOT NULL,    -- MONTH/QUARTER/YEAR
    period_value        TEXT NOT NULL,    -- 2024-06 / 2024-Q1 / 2024
    
    -- 指标值
    numerator           REAL DEFAULT 0,   -- 分子
    denominator         REAL DEFAULT 0,   -- 分母
    indicator_value     REAL DEFAULT 0,   -- 指标值(%)
    
    -- 明细（JSON格式存储）
    details             TEXT,             -- JSON: {breakdown: {...}}
    
    -- 时间戳
    snapshot_date       TEXT NOT NULL,    -- 快照日期
    created_at          TEXT DEFAULT (datetime('now'))
);

-- 6. 操作日志 (Operation Log) - 轻量级审计跟踪
CREATE TABLE IF NOT EXISTS quality_log (
    log_id              TEXT PRIMARY KEY,
    entity_type          TEXT NOT NULL,    -- FINDING/CAPA/CAPA_TASK/AUDIT
    entity_id            TEXT NOT NULL,    -- 关联实体ID
    
    -- 操作信息
    action              TEXT NOT NULL,    -- CREATE/UPDATE/STATUS_CHANGE/DELETE/ATTACH_FILE
    actor_id             TEXT,                        -- FK→member.db
    actor_name           TEXT,             -- 操作人姓名（冗余便于查询）
    
    -- 变更详情
    old_value           TEXT,             -- 变更前值(JSON)
    new_value           TEXT,             -- 变更后值(JSON)
    change_summary      TEXT,             -- 变更摘要
    
    -- 上下文
    ip_address          TEXT,             -- 操作IP
    user_agent          TEXT,             -- 浏览器信息
    
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now'))
);

-- 7. 质量文档 (Quality Document) - 附件管理
CREATE TABLE IF NOT EXISTS quality_document (
    doc_id              TEXT PRIMARY KEY,
    doc_no              TEXT UNIQUE,      -- DOC-YYYY-NNNN
    
    -- 关联
    entity_type         TEXT NOT NULL,    -- FINDING/CAPA/AUDIT/OTHER
    entity_id           TEXT NOT NULL,    -- 关联实体ID
    
    -- 文档信息
    doc_type            TEXT NOT NULL,    -- AUDIT_REPORT/FINDING_DOC/CAPA_PLAN/VERIFICATION_DOC/EVIDENCE/OTHER
    doc_name            TEXT NOT NULL,    -- 原始文件名
    file_path           TEXT NOT NULL,    -- 存储路径
    file_size           INTEGER,          -- 文件大小(字节)
    file_hash           TEXT,             -- 文件哈希(MD5/SHA256)
    
    -- 元数据
    uploaded_by         TEXT,                        -- FK→member.db
    uploaded_date       TEXT DEFAULT (datetime('now')),
    
    -- 版本控制
    version             INTEGER DEFAULT 1,  -- 版本号
    parent_doc_id       TEXT,             -- 上一版本ID
    
    -- 审计字段
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now'))
);
```

---

## 三、索引设计

```sql
-- ============================================
-- 索引
-- ============================================

-- quality_finding 索引
CREATE INDEX IF NOT EXISTS idx_finding_no ON quality_finding(finding_no);
CREATE INDEX IF NOT EXISTS idx_finding_project ON quality_finding(project_id);
CREATE INDEX IF NOT EXISTS idx_finding_site ON quality_finding(project_site_id);
CREATE INDEX IF NOT EXISTS idx_finding_type ON quality_finding(finding_type);
CREATE INDEX IF NOT EXISTS idx_finding_severity ON quality_finding(severity);
CREATE INDEX IF NOT EXISTS idx_finding_status ON quality_finding(finding_status);
CREATE INDEX IF NOT EXISTS idx_finding_date ON quality_finding(found_date);
CREATE INDEX IF NOT EXISTS idx_finding_target_close ON quality_finding(target_close_date);
CREATE INDEX IF NOT EXISTS idx_finding_audit ON quality_finding(related_audit_id);
CREATE INDEX IF NOT EXISTS idx_finding_created ON quality_finding(created_at);

-- capa 索引
CREATE INDEX IF NOT EXISTS idx_capa_no ON capa(capa_no);
CREATE INDEX IF NOT EXISTS idx_capa_finding ON capa(finding_id);
CREATE INDEX IF NOT EXISTS idx_capa_type ON capa(capa_type);
CREATE INDEX IF NOT EXISTS idx_capa_responsible ON capa(responsible_id);
CREATE INDEX IF NOT EXISTS idx_capa_due_date ON capa(due_date);
CREATE INDEX IF NOT EXISTS idx_capa_status ON capa(status);
CREATE INDEX IF NOT EXISTS idx_capa_created ON capa(created_at);
CREATE INDEX IF NOT EXISTS idx_capa_verified_by ON capa(verified_by);

-- capa_task 索引
CREATE INDEX IF NOT EXISTS idx_task_capa ON capa_task(capa_id);
CREATE INDEX IF NOT EXISTS idx_task_assignee ON capa_task(assignee_id);
CREATE INDEX IF NOT EXISTS idx_task_status ON capa_task(task_status);
CREATE INDEX IF NOT EXISTS idx_task_due_date ON capa_task(due_date);
CREATE INDEX IF NOT EXISTS idx_task_created ON capa_task(created_at);

-- quality_audit 索引
CREATE INDEX IF NOT EXISTS idx_audit_no ON quality_audit(audit_no);
CREATE INDEX IF NOT EXISTS idx_audit_project ON quality_audit(project_id);
CREATE INDEX IF NOT EXISTS idx_audit_site ON quality_audit(project_site_id);
CREATE INDEX IF NOT EXISTS idx_audit_type ON quality_audit(audit_type);
CREATE INDEX IF NOT EXISTS idx_audit_date ON quality_audit(audit_date);
CREATE INDEX IF NOT EXISTS idx_audit_status ON quality_audit(audit_status);
CREATE INDEX IF NOT EXISTS idx_audit_created ON quality_audit(created_at);

-- quality_indicator 索引
CREATE INDEX IF NOT EXISTS idx_indicator_project ON quality_indicator(project_id);
CREATE INDEX IF NOT EXISTS idx_indicator_site ON quality_indicator(project_site_id);
CREATE INDEX IF NOT EXISTS idx_indicator_type ON quality_indicator(indicator_type);
CREATE INDEX IF NOT EXISTS idx_indicator_period ON quality_indicator(period_type, period_value);
CREATE INDEX IF NOT EXISTS idx_indicator_snapshot ON quality_indicator(snapshot_date);

-- quality_log 索引
CREATE INDEX IF NOT EXISTS idx_log_entity ON quality_log(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_log_actor ON quality_log(actor_id);
CREATE INDEX IF NOT EXISTS idx_log_action ON quality_log(action);
CREATE INDEX IF NOT EXISTS idx_log_created ON quality_log(created_at);

-- quality_document 索引
CREATE INDEX IF NOT EXISTS idx_doc_entity ON quality_document(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_doc_type ON quality_document(doc_type);
CREATE INDEX IF NOT EXISTS idx_doc_uploaded_by ON quality_document(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_doc_created ON quality_document(created_at);
```

---

## 四、枚举值速查表

```
-- quality_finding.finding_type (发现类型)
INTERNAL_AUDIT         -- 内部稽查
SPONSOR_AUDIT          -- 申办方稽查
REGULATORY_INSPECTION  -- 监管检查
DEVIATION              -- 方案偏离
OTHER                  -- 其他

-- quality_finding.severity (严重程度)
CRITICAL   -- 关键偏差（可能导致数据不可靠或违反法规）
MAJOR      -- 主要不符（GCP/方案的重要偏离）
MINOR      -- 轻微偏差（不影响数据完整性的次要问题）
OBSERVATION -- 观察项（建议改进但不构成偏离）

-- quality_finding.finding_status (发现状态)
OPEN               -- 待处理（新建发现）
IN_PROGRESS        -- CAPA进行中（有CAPA正在执行）
PENDING_APPROVAL   -- 待审批（所有CAPA已完成，待验证）
VERIFIED           -- 已验证闭环（验证通过）
CLOSED             -- 已关闭（正式归档）

-- capa.capa_type (CAPA类型)
CA  -- 纠正措施（针对已发生问题的整改）
PA  -- 预防措施（针对潜在问题的预防）

-- capa.priority (优先级)
HIGH    -- 高优先级
MEDIUM  -- 中优先级
LOW     -- 低优先级

-- capa.status (CAPA状态)
PENDING              -- 待处理（新建CAPA）
IN_PROGRESS          -- 进行中（开始执行）
PENDING_VERIFICATION -- 待验证（提交完成）
VERIFIED             -- 已验证（验证通过）
CLOSED               -- 已闭环（措施归档）
REJECTED             -- 已打回（验证人拒绝）

-- capa_task.task_status (任务状态)
PENDING     -- 待处理
IN_PROGRESS -- 进行中
COMPLETED   -- 已完成
CANCELLED   -- 已取消

-- capa.verification_method (验证方式)
FILE_REVIEW     -- 文件审查
ON_SITE         -- 现场核查
SYSTEM          -- 系统验证
NO_VERIFICATION -- 无需验证

-- quality_audit.audit_type (稽查类型)
INTERNAL    -- 内部稽查
SPONSOR     -- 申办方稽查
REGULATORY  -- 监管检查（NMPA/FDA等）

-- quality_audit.audit_status (稽查状态)
PLANNED     -- 已计划
IN_PROGRESS -- 进行中
COMPLETED   -- 已完成
CANCELLED   -- 已取消

-- quality_indicator.indicator_type (指标类型)
FINDING_COUNT           -- 发现数量
DEVIATION_RATE          -- 偏差率
CAPA_CLOSE_RATE         -- CAPA闭环率
TIMELY_RESOLUTION_RATE  -- 及时整改率
REPEAT_FINDING_RATE     -- 重复发现率

-- quality_indicator.period_type (统计周期)
MONTH    -- 月度
QUARTER  -- 季度
YEAR     -- 年度

-- quality_document.entity_type (关联实体类型)
FINDING  -- 质量发现
CAPA     -- CAPA措施
AUDIT    -- 稽查记录
OTHER    -- 其他

-- quality_document.doc_type (文档类型)
AUDIT_REPORT      -- 稽查报告
FINDING_DOC       -- 发现文件
CAPA_PLAN         -- CAPA计划
VERIFICATION_DOC  -- 验证文件
EVIDENCE          -- 证明材料
OTHER             -- 其他

-- quality_log.action (操作类型)
CREATE          -- 创建
UPDATE          -- 更新
STATUS_CHANGE   -- 状态变更
DELETE          -- 删除
ATTACH_FILE     -- 附加文件
DOWNLOAD        -- 下载
VIEW            -- 查看
```

---

## 五、表关系说明

```
┌─────────────────┐       ┌─────────────────┐
│quality_audit    │──1:N──│quality_finding  │
│ (稽查/检查)      │       │  (质量发现)      │
└────────┬────────┘       └────────┬────────┘
         │                          │
         │ finding_id               │ 1:N
         └──────────────────────────┘
                        │
                        ↓
               ┌─────────────────┐
               │      capa       │
               │   (CAPA措施)     │
               └────────┬────────┘
                        │
                        │ 1:N
                        ↓
               ┌─────────────────┐
               │    capa_task    │
               │   (CAPA任务)     │
               └─────────────────┘

跨库引用:
┌─────────────────┐
│ quality_finding │──project_id──→ project.db
│ quality_finding │─project_site_id→ project.db
│      capa       │──responsible_id─→ member.db
│   capa_task     │──assignee_id──→ member.db
│ quality_audit   │──project_id──→ project.db
```

---

## 六、编号规则

### 6.1 发现编号 (finding_no)
```
格式: QF-YYYY-NNNN
示例: QF-2024-0001

规则:
- QF: 前缀(Quality Finding)
- YYYY: 年份
- NNNN: 当年流水号(0001-9999)
- 每年1月1日重置流水号
```

### 6.2 CAPA编号 (capa_no)
```
格式: CA/PA-{finding_no}-NNN
示例: CA-QF-2024-0001-001

规则:
- CA: 纠正措施(Corrective Action)
- PA: 预防措施(Preventive Action)
- finding_no: 关联发现编号
- NNN: 该发现下CAPA流水号
```

### 6.3 稽查编号 (audit_no)
```
格式: AUDIT-YYYY-NNNN
示例: AUDIT-2024-0001

规则:
- AUDIT: 前缀
- YYYY: 年份
- NNNN: 当年流水号
```

### 6.4 文档编号 (doc_no)
```
格式: DOC-YYYY-NNNN
示例: DOC-2024-0001

规则:
- DOC: 前缀
- YYYY: 年份
- NNNN: 当年流水号
```

---

## 七、视图定义（可选）

```sql
-- 1. 活跃发现视图（用于仪表盘）
CREATE VIEW IF NOT EXISTS v_active_findings AS
SELECT 
    qf.*,
    p.project_name,
    ps.site_name,
    (SELECT COUNT(*) FROM capa c WHERE c.finding_id = qf.finding_id) AS capa_total,
    (SELECT COUNT(*) FROM capa c WHERE c.finding_id = qf.finding_id AND c.status = 'VERIFIED') AS capa_verified,
    CASE 
        WHEN qf.target_close_date < date('now') AND qf.finding_status NOT IN ('VERIFIED', 'CLOSED') 
        THEN 1 ELSE 0 
    END AS is_overdue
FROM quality_finding qf
LEFT JOIN project p ON p.project_id = qf.project_id
LEFT JOIN project_site ps ON ps.project_site_id = qf.project_site_id;

-- 2. CAPA汇总视图
CREATE VIEW IF NOT EXISTS v_capa_summary AS
SELECT 
    c.*,
    qf.finding_no,
    qf.project_id,
    qf.project_site_id,
    m.name AS responsible_name,
    (SELECT COUNT(*) FROM capa_task ct WHERE ct.capa_id = c.capa_id) AS task_count,
    (SELECT COUNT(*) FROM capa_task ct WHERE ct.capa_id = c.capa_id AND ct.task_status = 'COMPLETED') AS task_completed,
    CASE 
        WHEN c.due_date < date('now') AND c.status NOT IN ('VERIFIED', 'CLOSED') 
        THEN 1 ELSE 0 
    END AS is_overdue
FROM capa c
JOIN quality_finding qf ON qf.finding_id = c.finding_id
LEFT JOIN member m ON m.member_id = c.responsible_id;

-- 3. 质量统计视图（按项目）
CREATE VIEW IF NOT EXISTS v_project_quality_stats AS
SELECT 
    project_id,
    COUNT(*) AS total_findings,
    SUM(CASE WHEN severity = 'CRITICAL' THEN 1 ELSE 0 END) AS critical_count,
    SUM(CASE WHEN severity = 'MAJOR' THEN 1 ELSE 0 END) AS major_count,
    SUM(CASE WHEN severity = 'MINOR' THEN 1 ELSE 0 END) AS minor_count,
    SUM(CASE WHEN severity = 'OBSERVATION' THEN 1 ELSE 0 END) AS observation_count,
    SUM(CASE WHEN finding_status IN ('VERIFIED', 'CLOSED') THEN 1 ELSE 0 END) AS closed_count
FROM quality_finding
GROUP BY project_id;
```

---

## 八、触发器定义（可选）

```sql
-- 1. 发现状态自动更新触发器
CREATE TRIGGER IF NOT EXISTS trg_finding_status_auto_update
AFTER UPDATE OF finding_status ON quality_finding
BEGIN
    -- 当发现状态变为CLOSED时，更新实际关闭日期
    IF NEW.finding_status = 'CLOSED' THEN
        UPDATE quality_finding 
        SET actual_close_date = date('now')
        WHERE finding_id = NEW.finding_id;
    END IF;
END;

-- 2. CAPA数量统计触发器
CREATE TRIGGER IF NOT EXISTS trg_capa_count_update
AFTER INSERT ON capa
BEGIN
    UPDATE quality_finding 
    SET capa_count = capa_count + 1
    WHERE finding_id = NEW.finding_id;
END;

CREATE TRIGGER IF NOT EXISTS trg_capa_count_update_del
AFTER DELETE ON capa
BEGIN
    UPDATE quality_finding 
    SET capa_count = capa_count - 1
    WHERE finding_id = OLD.finding_id;
END;

-- 3. 操作日志自动记录触发器
CREATE TRIGGER IF NOT EXISTS trg_finding_log
AFTER INSERT ON quality_finding
BEGIN
    INSERT INTO quality_log (log_id, entity_type, entity_id, action, actor_id, actor_name, new_value, created_at)
    VALUES (
        lower(hex(randomblob(16))),
        'FINDING',
        NEW.finding_id,
        'CREATE',
        NEW.created_by,
        (SELECT name FROM member WHERE member_id = NEW.created_by),
        json_object('finding_no', NEW.finding_no, 'finding_type', NEW.finding_type, 'severity', NEW.severity),
        datetime('now')
    );
END;
```

---

## 九、第一版不做

- ❌ 触发器实现（第一版用应用层代码处理）
- ❌ 视图定义（按需创建）
- ❌ 文件哈希校验
- ❌ 版本控制（文档上传直接覆盖）
- ❌ 完整SOP管理（标准操作规程）

---

*文档版本 V1.0 | 2026-06-20*
