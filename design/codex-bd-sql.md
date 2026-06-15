# BD Module SQL建表脚本 (对象线: BD / 商务拓展)

> 数据库: bd.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js

---

## 一、数据库架构

```
┌─────────────────────────────────────────────────────────────────┐
│                         bd.db                                   │
├─────────────────────────────────────────────────────────────────┤
│  表:                                                             │
│  ├── bd_project          BD项目主表                              │
│  ├── bd_project_action  BD项目跟进记录（历史）                   │
│  └── visit_record        拜访记录表                              │
└─────────────────────────────────────────────────────────────────┘
```

**跨域关联：**
- bd_project.sponsor_id → sponsor_master.sponsor_id (申办方主档)
- bd_project.project_id → project.project_id (正式项目，可空)
- visit_record.sponsor_id → sponsor_master.sponsor_id (申办方主档)
- visit_record.bd_project_id → bd_project.bd_project_id (BD项目，可空)

---

## 二、全量建表脚本

```sql
-- ============================================
-- bd.db 全量建表脚本
-- 对象线: BD / 商务拓展
-- 包含: BD项目 + 拜访记录
-- ============================================

-- 1. BD项目主表 (BD Project)
CREATE TABLE IF NOT EXISTS bd_project (
    bd_project_id           TEXT PRIMARY KEY,
    bd_project_name        TEXT NOT NULL,
    -- 关联申办方
    sponsor_id             TEXT,                    -- 关联申办方(可空，表示潜在客户)
    sponsor_name           TEXT,                    -- 冗余：申办方名称(快照)
    -- 项目类型
    bd_type                TEXT NOT NULL,           -- NEW_CLIENT/EXISTING_EXPANSION
    -- 业务信息
    estimated_value        REAL DEFAULT 0,          -- 预估合同价值(元)
    probability            REAL DEFAULT 0,          -- 成单概率(0-100%)
    expected_close_date    TEXT,                    -- 预计签约日期
    -- 负责人
    assigned_bd_id         TEXT,                    -- 负责BD用户ID
    assigned_bd_name       TEXT,                    -- 冗余：负责BD姓名
    -- 来源
    source                 TEXT,                    -- EXHIBITION/REFERRAL/PROACTIVE/OTHER
    source_detail          TEXT,                    -- 来源详情
    -- 竞争对手
    competitor_info        TEXT,                    -- 竞争对手信息(JSON)
    -- 阶段
    bd_stage               TEXT DEFAULT 'INITIAL',  -- INITIAL/PROSPECTING/QUALIFICATION/QUOTATION/NEGOTIATION/SIGNED/WON/LOST
    stage_changed_at       TEXT,                    -- 阶段变更时间
    -- 关联正式项目
    project_id             TEXT,                    -- 转化后的正式项目ID(可空)
    -- 失败关闭原因
    loss_reason            TEXT,                    -- 输单原因
    -- 状态
    status                 TEXT DEFAULT 'ACTIVE',   -- ACTIVE/ARCHIVED
    -- 描述
    description            TEXT,                    -- 项目描述
    contact_person         TEXT,                    -- 对接人
    contact_phone          TEXT,                    -- 联系电话
    -- 冗余统计
    visit_count            INTEGER DEFAULT 0,       -- 拜访次数
    last_visit_date        TEXT,                    -- 最后拜访日期
    -- 时间戳
    created_at             TEXT DEFAULT (datetime('now')),
    updated_at             TEXT DEFAULT (datetime('now')),
    created_by             TEXT,
    updated_by             TEXT
);

-- 2. BD项目跟进记录 (BD Project Action Log)
-- 记录阶段变更、备注等历史
CREATE TABLE IF NOT EXISTS bd_project_action (
    action_id              TEXT PRIMARY KEY,
    bd_project_id         TEXT NOT NULL,
    action_type           TEXT NOT NULL,           -- STAGE_CHANGE/NOTE/UPDATE/ATTACHMENT
    action_content        TEXT,                    -- 操作内容描述
    -- 阶段变更
    from_stage            TEXT,                    -- 变更前阶段
    to_stage              TEXT,                    -- 变更后阶段
    -- 附件
    attachments           TEXT,                    -- 附件JSON [{"name":"xxx","url":"xxx"}]
    -- 时间戳
    created_at            TEXT DEFAULT (datetime('now')),
    created_by            TEXT,
    created_by_name       TEXT
);

-- 3. 拜访记录表 (Visit Record)
CREATE TABLE IF NOT EXISTS visit_record (
    visit_id              TEXT PRIMARY KEY,
    sponsor_id            TEXT NOT NULL,           -- 关联申办方
    sponsor_name          TEXT,                     -- 冗余：申办方名称(快照)
    bd_project_id         TEXT,                     -- 关联BD项目(可空)
    -- 拜访基本信息
    visit_date            TEXT NOT NULL,           -- 拜访日期
    visit_type            TEXT NOT NULL,           -- FIRST_VISIT/REGULAR_VISIT/NEGOTIATION/AFTER_SALES
    visit_purpose         TEXT,                    -- 拜访目的
    -- 拜访人员
    visitor_ids           TEXT,                    -- 拜访人员ID列表(JSON)
    visitor_names         TEXT,                    -- 冗余：拜访人员姓名(快照)
    -- 联系人
    contact_id            TEXT,                    -- 对接联系人ID(sponsor_contact.contact_id)
    contact_person        TEXT,                    -- 对接联系人姓名
    contact_phone         TEXT,                    -- 联系电话
    contact_position      TEXT,                    -- 职位
    -- 地点
    location              TEXT,                    -- 拜访地点
    -- 内容摘要
    content_summary       TEXT,                    -- 内容摘要
    key_points            TEXT,                    -- 要点(JSON数组)
    -- 后续计划
    follow_up_plan        TEXT,                    -- 后续跟进计划
    next_visit_date       TEXT,                    -- 计划下次拜访日期
    -- 附件
    attachments           TEXT,                    -- 附件JSON [{"name":"xxx","url":"xxx"}]
    -- 状态
    status                TEXT DEFAULT 'COMPLETED', -- DRAFT/COMPLETED/CANCELLED
    -- 评估
    visit_effectiveness   REAL,                    -- 拜访效果评分(1-5)
    client_satisfaction   REAL,                    -- 客户满意度(1-5)
    -- 时间戳
    created_at            TEXT DEFAULT (datetime('now')),
    updated_at             TEXT DEFAULT (datetime('now')),
    created_by             TEXT,
    updated_by             TEXT
);

-- ============================================
-- 索引
-- ============================================

-- bd_project 索引
CREATE INDEX IF NOT EXISTS idx_bdp_name ON bd_project(bd_project_name);
CREATE INDEX IF NOT EXISTS idx_bdp_sponsor ON bd_project(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_bdp_stage ON bd_project(bd_stage);
CREATE INDEX IF NOT EXISTS idx_bdp_type ON bd_project(bd_type);
CREATE INDEX IF NOT EXISTS idx_bdp_status ON bd_project(status);
CREATE INDEX IF NOT EXISTS idx_bdp_assigned ON bd_project(assigned_bd_id);
CREATE INDEX IF NOT EXISTS idx_bdp_source ON bd_project(source);
CREATE INDEX IF NOT EXISTS idx_bdp_project ON bd_project(project_id);
CREATE INDEX IF NOT EXISTS idx_bdp_created ON bd_project(created_at);

-- bd_project_action 索引
CREATE INDEX IF NOT EXISTS idx_bdp_act_project ON bd_project_action(bd_project_id);
CREATE INDEX IF NOT EXISTS idx_bdp_act_type ON bd_project_action(action_type);
CREATE INDEX IF NOT EXISTS idx_bdp_act_created ON bd_project_action(created_at);

-- visit_record 索引
CREATE INDEX IF NOT EXISTS idx_vr_sponsor ON visit_record(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_vr_bd_project ON visit_record(bd_project_id);
CREATE INDEX IF NOT EXISTS idx_vr_date ON visit_record(visit_date);
CREATE INDEX IF NOT EXISTS idx_vr_type ON visit_record(visit_type);
CREATE INDEX IF NOT EXISTS idx_vr_status ON visit_record(status);
CREATE INDEX IF NOT EXISTS idx_vr_created ON visit_record(created_at);

-- ============================================
-- 触发器
-- ============================================

-- 触发器1: BD项目阶段变更时自动记录日志
CREATE TRIGGER IF NOT EXISTS trg_bd_stage_change
AFTER UPDATE OF bd_stage ON bd_project
FOR EACH ROW
BEGIN
    INSERT INTO bd_project_action (action_id, bd_project_id, action_type, action_content, from_stage, to_stage, created_at, created_by, created_by_name)
    VALUES (
        lower(hex(randomblob(16))),
        NEW.bd_project_id,
        'STAGE_CHANGE',
        '阶段从 ' || OLD.bd_stage || ' 变更为 ' || NEW.bd_stage,
        OLD.bd_stage,
        NEW.bd_stage,
        datetime('now'),
        NEW.updated_by,
        (SELECT user_name FROM users WHERE user_id = NEW.updated_by)
    );
END;

-- 触发器2: 拜访记录创建/删除时更新BD项目统计
CREATE TRIGGER IF NOT EXISTS trg_visit_count_on_insert
AFTER INSERT ON visit_record
FOR EACH ROW
BEGIN
    UPDATE bd_project 
    SET visit_count = visit_count + 1,
        last_visit_date = NEW.visit_date,
        updated_at = datetime('now')
    WHERE bd_project_id = NEW.bd_project_id;
END;

CREATE TRIGGER IF NOT EXISTS trg_visit_count_on_delete
AFTER DELETE ON visit_record
FOR EACH ROW
BEGIN
    UPDATE bd_project 
    SET visit_count = MAX(0, visit_count - 1),
        updated_at = datetime('now')
    WHERE bd_project_id = OLD.bd_project_id;
END;

-- ============================================
-- 枚举值速查
-- ============================================

-- bd_project.bd_type
-- NEW_CLIENT          新客户开发
-- EXISTING_EXPANSION 现有客户扩展

-- bd_project.bd_stage
-- INITIAL             初步接触
-- PROSPECTING         需求确认
-- QUALIFICATION       方案报价
-- QUOTATION           商务谈判
-- NEGOTIATION         签约
-- SIGNED              已签约(转化中)
-- WON                 成功(已转化为正式项目)
-- LOST                失败关闭

-- bd_project.source
-- EXHIBITION          展会获客
-- REFERRAL            客户转介绍
-- PROACTIVE           主动开发
-- OTHER               其他来源

-- bd_project.status
-- ACTIVE              进行中
-- ARCHIVED            已归档

-- visit_record.visit_type
-- FIRST_VISIT         首次拜访
-- REGULAR_VISIT       定期回访
-- NEGOTIATION         项目洽谈
-- AFTER_SALES         售后回访

-- visit_record.status
-- DRAFT               草稿
-- COMPLETED           已完成
-- CANCELLED           已取消

-- visit_record.key_points 结构
-- [{"title":"要点标题","content":"要点内容"}]

-- visit_record.attachments 结构
-- [{"name":"文件名","url":"文件地址","size":12345}]

-- competitor_info 结构
-- [{"name":"竞品名称","strength":"优势","weakness":"劣势","price_range":"价格区间"}]
```

---

## 三、表关系说明

```
┌─────────────────────────────────────────────────────────────────┐
│                         BD模块 (bd.db)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐      1:N        ┌─────────────────────┐        │
│  │ bd_project  │◄────────────────│bd_project_action   │        │
│  │ (BD项目)    │                │(BD项目跟进记录)     │        │
│  └──────┬──────┘                └─────────────────────┘        │
│         │                                                       │
│         │ N:1               1:N                                  │
│         ▼                       ▼                               │
│  ┌─────────────┐           ┌─────────────┐                     │
│  │sponsor_     │◄──────────│ visit_record│                     │
│  │master       │           │ (拜访记录)   │                     │
│  │(申办方主档)  │           └─────────────┘                     │
│  └─────────────┘                                                │
│         │                                                        │
│         │ 1:1 (转化后)                                           │
│         ▼                                                        │
│  ┌─────────────┐                                                │
│  │  project   │                                                │
│  │ (正式项目)  │                                                │
│  └─────────────┘                                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 四、跨域关联说明

### 4.1 与申办方对象线 (sponsor.db)

| 本表字段 | 关联表 | 说明 |
|---------|--------|------|
| bd_project.sponsor_id | sponsor_master.sponsor_id | BD项目关联的申办方 |
| visit_record.sponsor_id | sponsor_master.sponsor_id | 拜访记录关联的申办方 |
| visit_record.contact_id | sponsor_contact.contact_id | 对接联系人 |

**查询申办方信息：**
```javascript
// 在bd模块中通过HTTP调用sponsor API
const sponsorApiBase = process.env.SPONSOR_API_BASE || 'http://localhost:3000';
const sponsor = await fetch(`${sponsorApiBase}/api/sponsor/masters/${sponsor_id}`);
```

### 4.2 与项目对象线 (project.db)

| 本表字段 | 关联表 | 说明 |
|---------|--------|------|
| bd_project.project_id | project.project_id | BD项目转化为正式项目 |

**创建正式项目时更新BD项目：**
```javascript
// BD项目转化为正式项目后
UPDATE bd_project 
SET project_id = ?, 
    bd_stage = 'SIGNED',
    updated_at = ?
WHERE bd_project_id = ?;
```

---

## 五、第一版不做

- ❌ BD项目竞争对手分析功能
- ❌ BD项目预期收益自动计算
- ❌ 拜访路线优化
- ❌ 拜访任务自动派发
- ❌ BD项目ROI分析
- ❌ 竞品数据库管理
- ❌ 智能成单概率预测

---

*文档版本 V1.0 | 2026-06-15*
