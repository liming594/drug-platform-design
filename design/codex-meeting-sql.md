# Meeting Module SQL建表脚本 (对象线15号: Meeting)

> 数据库: meeting.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js

```sql
-- ============================================
-- meeting.db 全量建表脚本
-- 对象线15号: Meeting (会议管理)
-- ============================================

-- 1. 会议主表 (Meeting)
CREATE TABLE IF NOT EXISTS meeting (
    meeting_id          TEXT PRIMARY KEY,
    meeting_title       TEXT NOT NULL,
    project_id          TEXT NOT NULL,                    -- FK→project.project_id (跨库)
    meeting_type        TEXT NOT NULL,                    -- 枚举见下方
    meeting_status      TEXT DEFAULT 'SCHEDULED',         -- 枚举见下方
    meeting_mode        TEXT NOT NULL,                    -- ONLINE/OFFLINE
    -- 时间信息
    start_time          TEXT NOT NULL,                    -- ISO8601格式
    end_time            TEXT NOT NULL,                    -- ISO8601格式
    duration_minutes    INTEGER,                          -- 计算得出
    -- 地点信息
    room_id             TEXT,                             -- 会议室ID (可空，会议室管理后续)
    room_name           TEXT,                             -- 会议室名称冗余
    location            TEXT,                             -- 自定义地点描述
    meeting_link        TEXT,                             -- 线上会议链接
    -- 主持人/组织者
    host_member_id      TEXT,                             -- FK→member.member_id (跨库)
    host_member_name    TEXT,                             -- 姓名冗余
    organizer_id        TEXT,                             -- 组织者ID
    organizer_name      TEXT,                             -- 组织者姓名冗余
    -- 纪要相关
    minutes_status     TEXT DEFAULT 'PENDING',           -- PENDING/DRAFT/COMPLETED
    minutes_id         TEXT,                             -- FK→meeting_minutes.minutes_id
    minutes_by         TEXT,                             -- 纪要录入人
    minutes_at          TEXT,                             -- 纪要录入时间
    -- 统计/冗余字段
    participant_count   INTEGER DEFAULT 0,               -- 参会人数
    resolution_count    INTEGER DEFAULT 0,                -- 决议数量
    pending_resolution  INTEGER DEFAULT 0,                -- 待跟进决议数量
    -- 会议室容量(冗余)
    room_capacity       INTEGER,                          -- 会议室可容纳人数
    -- 附件
    attachment_count    INTEGER DEFAULT 0,                -- 附件数量
    -- 备注
    remark             TEXT,
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 2. 参会人员表 (Meeting Participant)
CREATE TABLE IF NOT EXISTS meeting_participant (
    participant_id      TEXT PRIMARY KEY,
    meeting_id          TEXT NOT NULL,
    member_id           TEXT NOT NULL,                    -- FK→member.member_id (跨库)
    member_name         TEXT NOT NULL,                    -- 姓名冗余
    department          TEXT,                             -- 部门冗余
    position_type       TEXT,                             -- 职位类型冗余
    participant_role    TEXT DEFAULT 'ATTENDEE',          -- 角色：HOST/ATTENDEE/OBSERVER
    attendance_status   TEXT DEFAULT 'PENDING',           -- PENDING/ATTENDED/ABSENT/LEAVE
    -- 通知相关
    notified_at         TEXT,                             -- 通知发送时间
    reminder_count      INTEGER DEFAULT 0,                -- 提醒次数
    -- 请假相关
    leave_reason        TEXT,                             -- 请假原因
    leave_approved_by   TEXT,                             -- 准假人
    -- 签到
    check_in_time       TEXT,                             -- 签到时间
    check_out_time      TEXT,                             -- 签退时间
    actual_duration     INTEGER,                          -- 实际参会时长(分钟)
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT,
    UNIQUE(meeting_id, member_id)
);

-- 3. 会议议程表 (Meeting Agenda)
CREATE TABLE IF NOT EXISTS meeting_agenda (
    agenda_id           TEXT PRIMARY KEY,
    meeting_id          TEXT NOT NULL,
    agenda_order        INTEGER NOT NULL,                -- 序号
    topic               TEXT NOT NULL,                    -- 议程主题
    description         TEXT,                             -- 详细描述
    duration_minutes    INTEGER NOT NULL,                 -- 预计时长
    responsible_id      TEXT,                             -- 负责人ID
    responsible_name    TEXT,                             -- 负责人姓名冗余
    -- 完成状态
    agenda_status       TEXT DEFAULT 'PENDING',           -- PENDING/IN_PROGRESS/COMPLETED/SKIPPED
    actual_duration     INTEGER,                          -- 实际时长
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 4. 会议纪要表 (Meeting Minutes)
CREATE TABLE IF NOT EXISTS meeting_minutes (
    minutes_id          TEXT PRIMARY KEY,
    meeting_id          TEXT NOT NULL,
    -- 纪要内容
    meeting_summary     TEXT,                             -- 会议概况(富文本)
    resolutions_summary  TEXT,                             -- 决议汇总(富文本)
    next_meeting_plan   TEXT,                             -- 下次会议安排
    next_meeting_time   TEXT,                             -- 下次会议时间
    next_meeting_topic  TEXT,                             -- 下次会议议题
    -- 附件
    attachment_id      TEXT,                             -- 纪要附件ID
    attachment_name     TEXT,                             -- 纪要附件名
    attachment_path     TEXT,                             -- 纪要附件路径
    -- 状态
    minutes_status     TEXT DEFAULT 'DRAFT',             -- DRAFT/COMPLETED
    -- 录入信息
    created_by          TEXT,                             -- 录入人ID
    created_by_name     TEXT,                             -- 录入人姓名
    created_at          TEXT,
    -- 时间戳
    updated_at          TEXT DEFAULT (datetime('now')),
    updated_by          TEXT
);

-- 5. 会议决议/待办表 (Meeting Resolution)
CREATE TABLE IF NOT EXISTS meeting_resolution (
    resolution_id       TEXT PRIMARY KEY,
    meeting_id          TEXT NOT NULL,
    project_id          TEXT,                             -- FK→project.project_id (跨库)
    project_site_id     TEXT,                             -- FK→project_site.project_site_id (跨库，可空)
    resolution_order    INTEGER,                          -- 序号
    resolution_content  TEXT NOT NULL,                    -- 决议内容
    -- 责任人
    responsible_id      TEXT NOT NULL,                    -- 负责人ID
    responsible_name    TEXT NOT NULL,                    -- 负责人姓名冗余
    department          TEXT,                             -- 部门冗余
    -- 时间要求
    due_date            TEXT,                             -- 截止日期
    priority            TEXT DEFAULT 'MEDIUM',            -- HIGH/MEDIUM/LOW
    -- 状态
    resolution_status   TEXT DEFAULT 'PENDING',           -- PENDING/IN_PROGRESS/COMPLETED/OVERDUE
    -- 完成信息
    completion_date     TEXT,                             -- 完成日期
    completion_result   TEXT,                             -- 完成情况
    completed_by        TEXT,                             -- 完成操作人
    -- 关联类型
    related_type        TEXT,                             -- 关联类型：MILESTONE/ETHICS/MONITORING/OTHER
    related_id          TEXT,                             -- 关联ID
    -- 替换信息(用于替换操作)
    replaced_by_id      TEXT,                             -- 被谁替换
    replaced_at         TEXT,                             -- 替换时间
    -- 备注
    remark              TEXT,
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 6. 会议材料附件表 (Meeting Material)
CREATE TABLE IF NOT EXISTS meeting_material (
    material_id         TEXT PRIMARY KEY,
    meeting_id          TEXT NOT NULL,
    material_type       TEXT NOT NULL,                    -- 枚举见下方
    material_name       TEXT NOT NULL,                    -- 文件名
    file_path           TEXT NOT NULL,                    -- 存储路径
    file_size           INTEGER,                          -- 文件大小(字节)
    file_extension      TEXT,                             -- 扩展名
    mime_type           TEXT,                             -- MIME类型
    -- 上传信息
    uploaded_by         TEXT,                             -- 上传人ID
    uploaded_by_name    TEXT,                             -- 上传人姓名
    uploaded_at        TEXT,
    -- 文档类型
    doc_category        TEXT,                             -- PPT/PDF/WORD/EXCEL/IMAGE/OTHER
    -- 时机
    upload_timing       TEXT DEFAULT 'BEFORE',           -- BEFORE/DURING/AFTER (会前/会中/会后)
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 7. 会议通知记录表 (Meeting Notification)
CREATE TABLE IF NOT EXISTS meeting_notification (
    notification_id     TEXT PRIMARY KEY,
    meeting_id          TEXT NOT NULL,
    participant_id      TEXT,                             -- 可空(全体通知)
    notification_type   TEXT NOT NULL,                    -- INVITE/REMINDER/CANCEL/MINUTES
    -- 通知渠道
    channel             TEXT DEFAULT 'SYSTEM',           -- SYSTEM/EMAIL/SMS
    -- 发送状态
    sent_status         TEXT DEFAULT 'PENDING',          -- PENDING/SENT/FAILED
    sent_at             TEXT,                             -- 发送时间
    read_status         TEXT DEFAULT 'UNREAD',           -- UNREAD/READ
    read_at             TEXT,                             -- 阅读时间
    -- 通知内容
    title               TEXT,
    content             TEXT,
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now'))
);

-- ============================================
-- 索引
-- ============================================

-- meeting 索引
CREATE INDEX IF NOT EXISTS idx_meeting_project ON meeting(project_id);
CREATE INDEX IF NOT EXISTS idx_meeting_type ON meeting(meeting_type);
CREATE INDEX IF NOT EXISTS idx_meeting_status ON meeting(meeting_status);
CREATE INDEX IF NOT EXISTS idx_meeting_start_time ON meeting(start_time);
CREATE INDEX IF NOT EXISTS idx_meeting_host ON meeting(host_member_id);
CREATE INDEX IF NOT EXISTS idx_meeting_minutes ON meeting(minutes_id);
CREATE INDEX IF NOT EXISTS idx_meeting_created ON meeting(created_at);

-- meeting_participant 索引
CREATE INDEX IF NOT EXISTS idx_part_meeting ON meeting_participant(meeting_id);
CREATE INDEX IF NOT EXISTS idx_part_member ON meeting_participant(member_id);
CREATE INDEX IF NOT EXISTS idx_part_status ON meeting_participant(attendance_status);
CREATE INDEX IF NOT EXISTS idx_part_role ON meeting_participant(participant_role);

-- meeting_agenda 索引
CREATE INDEX IF NOT EXISTS idx_agenda_meeting ON meeting_agenda(meeting_id);
CREATE INDEX IF NOT EXISTS idx_agenda_order ON meeting_agenda(meeting_id, agenda_order);
CREATE INDEX IF NOT EXISTS idx_agenda_responsible ON meeting_agenda(responsible_id);

-- meeting_minutes 索引
CREATE INDEX IF NOT EXISTS idx_minutes_meeting ON meeting_minutes(meeting_id);
CREATE INDEX IF NOT EXISTS idx_minutes_status ON meeting_minutes(minutes_status);

-- meeting_resolution 索引
CREATE INDEX IF NOT EXISTS idx_res_meeting ON meeting_resolution(meeting_id);
CREATE INDEX IF NOT EXISTS idx_res_project ON meeting_resolution(project_id);
CREATE INDEX IF NOT EXISTS idx_res_site ON meeting_resolution(project_site_id);
CREATE INDEX IF NOT EXISTS idx_res_responsible ON meeting_resolution(responsible_id);
CREATE INDEX IF NOT EXISTS idx_res_status ON meeting_resolution(resolution_status);
CREATE INDEX IF NOT EXISTS idx_res_due_date ON meeting_resolution(due_date);
CREATE INDEX IF NOT EXISTS idx_res_priority ON meeting_resolution(priority);

-- meeting_material 索引
CREATE INDEX IF NOT EXISTS idx_mat_meeting ON meeting_material(meeting_id);
CREATE INDEX IF NOT EXISTS idx_mat_type ON meeting_material(material_type);
CREATE INDEX IF NOT EXISTS idx_mat_timing ON meeting_material(upload_timing);
CREATE INDEX IF NOT EXISTS idx_mat_uploader ON meeting_material(uploaded_by);

-- meeting_notification 索引
CREATE INDEX IF NOT EXISTS idx_notif_meeting ON meeting_notification(meeting_id);
CREATE INDEX IF NOT EXISTS idx_notif_participant ON meeting_notification(participant_id);
CREATE INDEX IF NOT EXISTS idx_notif_sent ON meeting_notification(sent_status);
```

---

## 枚举值速查

```
-- meeting.meeting_type
PROJECT_INITIATION  -- 项目启动会
KICKOFF              -- 启动会
MONITORING           -- 监查会 (CRA监查汇报)
DATA_REVIEW          -- 数据审核会
CLOSE_OUT            -- 关中心会
SITE_INITIATION      -- 中心启动会
PROTOCOL_DISCUSSION  -- 方案讨论会
SAE_REVIEW           -- SAE审阅会
STEERING_COMMITTEE   -- 指导委员会
OTHER                -- 其他

-- meeting.meeting_status
SCHEDULED            -- 待召开
IN_PROGRESS          -- 进行中
COMPLETED            -- 已完成
CANCELLED            -- 已取消

-- meeting.meeting_mode
ONLINE               -- 线上
OFFLINE              -- 线下

-- meeting.minutes_status
PENDING              -- 待写
DRAFT                -- 草稿
COMPLETED            -- 已完成

-- meeting_participant.participant_role
HOST                 -- 主持人
ATTENDEE             -- 参会人
OBSERVER             -- 列席

-- meeting_participant.attendance_status
PENDING              -- 待确认
ATTENDED             -- 已出席
ABSENT               -- 缺席
LEAVE                -- 请假

-- meeting_agenda.agenda_status
PENDING              -- 待进行
IN_PROGRESS          -- 进行中
COMPLETED            -- 已完成
SKIPPED              -- 已跳过

-- meeting_minutes.minutes_status
DRAFT                -- 草稿
COMPLETED            -- 已完成

-- meeting_resolution.resolution_status
PENDING              -- 待处理
IN_PROGRESS          -- 进行中
COMPLETED            -- 已完成
OVERDUE              -- 已逾期

-- meeting_resolution.priority
HIGH                 -- 高
MEDIUM               -- 中
LOW                  -- 低

-- meeting_resolution.related_type
MILESTONE            -- 项目里程碑
ETHICS               -- 伦理审批
MONITORING           -- 监查计划
OTHER                -- 其他

-- meeting_material.material_type
PPT                  -- 会议PPT
PROTOCOL             -- 方案文件
DATA_REPORT          -- 数据报告
ICF                  -- ICF文件
OTHER                -- 其他

-- meeting_material.doc_category
PPT                  -- PowerPoint
PDF                  -- PDF文档
WORD                 -- Word文档
EXCEL                -- Excel表格
IMAGE                -- 图片
OTHER                -- 其他

-- meeting_material.upload_timing
BEFORE               -- 会前
DURING               -- 会中
AFTER                -- 会后

-- meeting_notification.notification_type
INVITE               -- 会议邀请
REMINDER             -- 会议提醒
CANCEL               -- 取消通知
MINUTES              -- 纪要发布

-- meeting_notification.channel
SYSTEM               -- 站内通知
EMAIL                -- 邮件
SMS                  -- 短信

-- meeting_notification.sent_status
PENDING              -- 待发送
SENT                 -- 已发送
FAILED               -- 发送失败

-- meeting_notification.read_status
UNREAD               -- 未读
READ                 -- 已读
```

---

## 表关系说明

```
┌─────────────┐       ┌─────────────────────┐
│   meeting   │──1:N──│ meeting_participant │
│ (会议主表)   │       │    (参会人员)        │
└──────┬──────┘       └─────────────────────┘
       │
       │ 1:N
       ▼
┌─────────────┐       ┌─────────────────────┐
│meeting_     │──1:N──│  meeting_agenda     │
│minutes      │       │    (会议议程)        │
│(会议纪要)    │       └─────────────────────┘
└──────┬──────┘
       │
       │ 1:N
       ▼
┌─────────────────────┐       ┌─────────────────────┐
│ meeting_resolution  │       │  meeting_material   │
│   (会议决议/待办)    │       │   (会议材料附件)     │
└──────┬──────────────┘       └─────────────────────┘
       │
       │ N:1              (跨库引用)
       ▼                  ─────────
┌─────────────┐       ┌─────────────────────┐
│   project   │       │   project_site      │
│   (项目)     │       │     (中心)           │
│ (跨库)       │       │   (跨库)             │
└─────────────┘       └─────────────────────┘

       ─────────────────────
              (跨库)

┌─────────────┐       ┌─────────────────────┐
│   member    │       │      room           │
│   (人员)     │       │    (会议室)          │
│ (跨库)       │       │   (后续扩展)         │
└─────────────┘       └─────────────────────┘
```

---

## 跨库引用说明

| 本表字段 | 引用表 | 说明 |
|---------|--------|------|
| meeting.project_id | project.db | 项目ID |
| meeting.host_member_id | member.db | 主持人ID |
| meeting_participant.member_id | member.db | 参会人员ID |
| meeting_agenda.responsible_id | member.db | 议程负责人ID |
| meeting_resolution.project_id | project.db | 项目ID |
| meeting_resolution.project_site_id | project.db | 中心ID |
| meeting_resolution.responsible_id | member.db | 决议负责人ID |

**跨域数据调用规则：**
- 跨库关联数据不走物理外键
- 前端通过API调用获取关联数据
- 后端查询时用 LEFT JOIN 或应用层聚合

---

## 触发器/自动更新

### 会议时长自动计算
```sql
CREATE TRIGGER IF NOT EXISTS tr_meeting_duration 
AFTER INSERT ON meeting
WHEN NEW.start_time IS NOT NULL AND NEW.end_time IS NOT NULL
BEGIN
    UPDATE meeting SET 
        duration_minutes = (
            CAST((julianday(NEW.end_time) - julianday(NEW.start_time)) * 24 * 60 AS INTEGER)
        )
    WHERE meeting_id = NEW.meeting_id;
END;
```

### 参会人数自动更新
```sql
CREATE TRIGGER IF NOT EXISTS tr_meeting_participant_count
AFTER INSERT ON meeting_participant
BEGIN
    UPDATE meeting SET 
        participant_count = (
            SELECT COUNT(*) FROM meeting_participant 
            WHERE meeting_id = NEW.meeting_id
        )
    WHERE meeting_id = NEW.meeting_id;
END;

CREATE TRIGGER IF NOT EXISTS tr_meeting_participant_count_del
AFTER DELETE ON meeting_participant
BEGIN
    UPDATE meeting SET 
        participant_count = (
            SELECT COUNT(*) FROM meeting_participant 
            WHERE meeting_id = OLD.meeting_id
        )
    WHERE meeting_id = OLD.meeting_id;
END;
```

### 决议数量自动更新
```sql
CREATE TRIGGER IF NOT EXISTS tr_meeting_resolution_count
AFTER INSERT ON meeting_resolution
BEGIN
    UPDATE meeting SET 
        resolution_count = (
            SELECT COUNT(*) FROM meeting_resolution 
            WHERE meeting_id = NEW.meeting_id
        ),
        pending_resolution = (
            SELECT COUNT(*) FROM meeting_resolution 
            WHERE meeting_id = NEW.meeting_id 
            AND resolution_status IN ('PENDING', 'IN_PROGRESS')
        )
    WHERE meeting_id = NEW.meeting_id;
END;

CREATE TRIGGER IF NOT EXISTS tr_meeting_resolution_update
AFTER UPDATE OF resolution_status ON meeting_resolution
BEGIN
    UPDATE meeting SET 
        pending_resolution = (
            SELECT COUNT(*) FROM meeting_resolution 
            WHERE meeting_id = OLD.meeting_id 
            AND resolution_status IN ('PENDING', 'IN_PROGRESS')
        )
    WHERE meeting_id = OLD.meeting_id;
END;

CREATE TRIGGER IF NOT EXISTS tr_meeting_resolution_count_del
AFTER DELETE ON meeting_resolution
BEGIN
    UPDATE meeting SET 
        resolution_count = (
            SELECT COUNT(*) FROM meeting_resolution 
            WHERE meeting_id = OLD.meeting_id
        ),
        pending_resolution = (
            SELECT COUNT(*) FROM meeting_resolution 
            WHERE meeting_id = OLD.meeting_id 
            AND resolution_status IN ('PENDING', 'IN_PROGRESS')
        )
    WHERE meeting_id = OLD.meeting_id;
END;
```

---

## 第一版不做

- ❌ 会议室管理（会议室增删改查、排期、容量管理）
- ❌ 会议视频录制与回放存储
- ❌ 会议签到二维码生成与扫码签到
- ❌ 会议AI摘要（语音转文字+摘要生成）
- ❌ 会议与其他系统集成（钉钉/飞书会议API对接）
- ❌ 周期性会议自动创建与提醒
- ❌ 会议参与度统计（是否查看纪要）
- ❌ 会议投票/问卷功能

---

*文档版本 V1.0 | 2026-06-20*
