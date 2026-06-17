# Meeting Module API路由规范 (对象线15号: Meeting)

> 后端: Node.js + Express
> 数据库: meeting.db (better-sqlite3, WAL模式)

---

## 1. 文件结构

```
server/routes/
├── meeting/
│   ├── db.js              ← meeting.db 连接 + 建表
│   ├── meeting.js          ← 会议主表 CRUD
│   ├── participant.js     ← 参会人员 CRUD
│   ├── agenda.js          ← 会议议程 CRUD
│   ├── minutes.js         ← 会议纪要 CRUD
│   ├── resolution.js      ← 会议决议/待办 CRUD
│   ├── material.js        ← 会议材料 CRUD
│   ├── notification.js    ← 会议通知
│   ├── stats.js           ← 统计数据
│   └── project-meeting.js ← 项目维度会议查询
│
└── project-site-meeting.js ← 中心维度会议信息 (驾驶舱嵌入)
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'meeting.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-meeting-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
// meeting主表
CREATE TABLE IF NOT EXISTS meeting (...);
// meeting_participant
CREATE TABLE IF NOT EXISTS meeting_participant (...);
// ... 其余表
`;
db.exec(SCHEMA);

// 触发器
const TRIGGERS = `
// 会议时长自动计算
CREATE TRIGGER IF NOT EXISTS tr_meeting_duration ...;
// 参会人数自动更新
CREATE TRIGGER IF NOT EXISTS tr_meeting_participant_count ...;
// 决议数量自动更新
CREATE TRIGGER IF NOT EXISTS tr_meeting_resolution_count ...;
`;
db.exec(TRIGGERS);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// Meeting模块
app.use('/api/meetings', require('./routes/meeting/meeting'));
app.use('/api/meetings/:meetingId/participants', require('./routes/meeting/participant'));
app.use('/api/meetings/:meetingId/agenda', require('./routes/meeting/agenda'));
app.use('/api/meetings/:meetingId/minutes', require('./routes/meeting/minutes'));
app.use('/api/meetings/:meetingId/resolutions', require('./routes/meeting/resolution'));
app.use('/api/meetings/:meetingId/materials', require('./routes/meeting/material'));
app.use('/api/meetings/:meetingId/notifications', require('./routes/meeting/notification'));
app.use('/api/meetings/stats', require('./routes/meeting/stats'));

// 项目维度会议
app.use('/api/projects/:projectId/meetings', require('./routes/meeting/project-meeting'));

// 中心维度会议（驾驶舱嵌入）
app.use('/api/projects/:projectId/sites/:projectSiteId/meetings', require('./routes/meeting/project-site-meeting'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该会议下有关联数据，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=start_time&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- **跨域调用：** 调用其他模块API获取关联数据（详见各接口说明）

---

## 5. 会议主表 CRUD (meeting.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?type=&status=&project_id=&start_date=&end_date=&keyword=&page=&size=` |
| GET | /:meetingId | 详情，含 participants[] + agenda[] + materials[] |
| POST | / | 新建会议 |
| PUT | /:meetingId | 编辑会议 |
| PUT | /:meetingId/status | 变更状态 |
| DELETE | /:meetingId | 删除（仅SCHEDULED状态可删） |

**GET / 响应：**
```json
{
  "total": 25,
  "list": [{
    "meeting_id": "uuid",
    "meeting_title": "PD-001项目启动会",
    "project_id": "uuid",
    "project_name": "PD-001 某项目",
    "meeting_type": "PROJECT_INITIATION",
    "meeting_status": "COMPLETED",
    "meeting_mode": "ONLINE",
    "start_time": "2024-06-20T10:00:00Z",
    "end_time": "2024-06-20T12:00:00Z",
    "duration_minutes": 120,
    "host_member_name": "张PM",
    "participant_count": 8,
    "minutes_status": "COMPLETED",
    "resolution_count": 3,
    "pending_resolution": 1
  }]
}
```

**GET /:meetingId 响应：**
```json
{
  "meeting_id": "uuid",
  "meeting_title": "PD-001项目启动会",
  "project_id": "uuid",
  "project_name": "PD-001 某项目",
  "meeting_type": "PROJECT_INITIATION",
  "meeting_status": "COMPLETED",
  "meeting_mode": "ONLINE",
  "start_time": "2024-06-20T10:00:00Z",
  "end_time": "2024-06-20T12:00:00Z",
  "duration_minutes": 120,
  "room_id": null,
  "room_name": null,
  "location": null,
  "meeting_link": "https://meeting.xxx.com/room/123",
  "host_member_id": "uuid",
  "host_member_name": "张PM",
  "organizer_id": "uuid",
  "organizer_name": "王助理",
  "minutes_status": "COMPLETED",
  "minutes_id": "uuid",
  "participant_count": 8,
  "resolution_count": 3,
  "pending_resolution": 1,
  "participants": [
    {
      "participant_id": "uuid",
      "member_id": "uuid",
      "member_name": "张PM",
      "department": "项目部",
      "participant_role": "HOST",
      "attendance_status": "ATTENDED"
    }
  ],
  "agenda": [
    {
      "agenda_id": "uuid",
      "agenda_order": 1,
      "topic": "项目概述与方案介绍",
      "duration_minutes": 30,
      "responsible_name": "张PM",
      "agenda_status": "COMPLETED"
    }
  ],
  "materials": [
    {
      "material_id": "uuid",
      "material_type": "PPT",
      "material_name": "启动会_v2.ppt",
      "file_extension": ".ppt",
      "uploaded_by_name": "张PM",
      "uploaded_at": "2024-06-18T09:00:00Z"
    }
  ],
  "created_at": "2024-06-15T08:00:00Z"
}
```

**POST body：**
```json
{
  "meeting_title": "PD-001项目启动会",
  "project_id": "uuid",
  "meeting_type": "PROJECT_INITIATION",
  "meeting_mode": "ONLINE",
  "start_time": "2024-06-20T10:00:00Z",
  "end_time": "2024-06-20T12:00:00Z",
  "room_id": null,
  "room_name": null,
  "location": null,
  "meeting_link": "https://meeting.xxx.com/room/123",
  "host_member_id": "uuid",
  "host_member_name": "张PM",
  "organizer_id": "uuid",
  "organizer_name": "王助理",
  "agenda_items": [
    {"topic": "项目概述", "duration_minutes": 30, "responsible_id": "uuid", "responsible_name": "张PM"},
    {"topic": "GCP要求", "duration_minutes": 20, "responsible_id": "uuid", "responsible_name": "李QA"}
  ],
  "participant_ids": ["uuid1", "uuid2", "uuid3"]
}
```

**POST 逻辑（事务）：**
1. INSERT meeting
2. INSERT meeting_agenda (遍历agenda_items)
3. INSERT meeting_participant (遍历participant_ids，HOST单独处理)
4. **发送通知** → 站内信/邮件通知参会人员
5. 返回完整 meeting 对象

**PUT /:meetingId/status body：**
```json
{
  "meeting_status": "IN_PROGRESS",
  "effective_time": "2024-06-20T10:05:00Z"
}
```

**状态流转：**
- SCHEDULED → IN_PROGRESS (到达开始时间自动更新或手动)
- SCHEDULED → CANCELLED (取消)
- IN_PROGRESS → COMPLETED (会议结束)
- IN_PROGRESS → CANCELLED (紧急取消)

---

## 6. 参会人员 CRUD (participant.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?meeting_id=xxx&status=` |
| POST | / | 添加参会人员 |
| PUT | /:participantId | 编辑参会人员 |
| PUT | /:participantId/attendance | 更新参会状态（签到/请假/缺席） |
| DELETE | /:participantId | 移除参会人员 |

**POST body：**
```json
{
  "meeting_id": "uuid",
  "member_id": "uuid",
  "member_name": "李CRA",
  "department": "CRA部",
  "position_type": "CRA",
  "participant_role": "ATTENDEE"
}
```

**PUT /:participantId/attendance body：**
```json
{
  "attendance_status": "ATTENDED",
  "check_in_time": "2024-06-20T10:00:00Z"
}
```

或

```json
{
  "attendance_status": "LEAVE",
  "leave_reason": "临时出差"
}
```

---

## 7. 会议议程 CRUD (agenda.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?meeting_id=xxx` |
| POST | / | 添加议程项 |
| PUT | /:agendaId | 编辑议程项 |
| PUT | /:agendaId/status | 更新议程状态 |
| DELETE | /:agendaId | 删除议程项 |
| PUT | /batch | 批量更新议程顺序 |

**POST body：**
```json
{
  "meeting_id": "uuid",
  "agenda_order": 4,
  "topic": "入组计划与时间线",
  "description": "详细讨论入组计划",
  "duration_minutes": 30,
  "responsible_id": "uuid",
  "responsible_name": "张PM"
}
```

**PUT /batch body：**
```json
{
  "agenda_items": [
    {"agenda_id": "uuid1", "agenda_order": 1},
    {"agenda_id": "uuid2", "agenda_order": 2},
    {"agenda_id": "uuid3", "agenda_order": 3}
  ]
}
```

---

## 8. 会议纪要 CRUD (minutes.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?meeting_id=xxx` |
| POST | / | 创建/编辑纪要 |
| PUT | /:minutesId | 更新纪要 |
| PUT | /:minutesId/submit | 提交纪要 |
| DELETE | /:minutesId | 删除纪要（仅DRAFT状态可删） |

**POST body：**
```json
{
  "meeting_id": "uuid",
  "meeting_summary": "本次会议于2024年6月20日召开，参会8人...",
  "resolutions_summary": "1. 各中心需在7月15日前完成伦理审批资料提交\n2. CRC人员名单需在6月30日前确认\n3. 首次监查时间定于7月20-25日",
  "next_meeting_plan": "下次会议安排",
  "next_meeting_time": "2024-07-10T14:00:00Z",
  "next_meeting_topic": "首次监查前准备会议"
}
```

**提交纪要后自动：**
1. UPDATE meeting.minutes_status='COMPLETED'
2. **发送通知** → 通知所有参会人员纪要已发布

---

## 9. 会议决议/待办 CRUD (resolution.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?meeting_id=&project_id=&status=&responsible_id=&page=&size=` |
| POST | / | 添加决议 |
| PUT | /:resolutionId | 编辑决议 |
| PUT | /:resolutionId/status | 更新决议状态 |
| PUT | /:resolutionId/complete | 完成决议 |
| PUT | /:resolutionId/replace | 替换负责人 |
| DELETE | /:resolutionId | 删除决议 |

**GET / 响应：**
```json
{
  "total": 15,
  "summary": { "pending": 5, "in_progress": 8, "completed": 50, "overdue": 2 },
  "list": [{
    "resolution_id": "uuid",
    "meeting_id": "uuid",
    "meeting_title": "PD-001项目启动会",
    "project_id": "uuid",
    "project_name": "PD-001 某项目",
    "resolution_order": 1,
    "resolution_content": "完成伦理审批资料提交",
    "responsible_id": "uuid",
    "responsible_name": "王CRC",
    "department": "SMO部",
    "due_date": "2024-07-15",
    "priority": "HIGH",
    "resolution_status": "IN_PROGRESS",
    "completion_date": null,
    "related_type": "ETHICS",
    "created_at": "2024-06-20T12:00:00Z"
  }]
}
```

**POST body：**
```json
{
  "meeting_id": "uuid",
  "project_id": "uuid",
  "project_site_id": "uuid",
  "resolution_order": 1,
  "resolution_content": "完成伦理审批资料提交",
  "responsible_id": "uuid",
  "responsible_name": "王CRC",
  "due_date": "2024-07-15",
  "priority": "HIGH",
  "related_type": "ETHICS",
  "remark": "需各中心统一版本"
}
```

**PUT /:resolutionId/complete body：**
```json
{
  "completion_result": "已联系各中心确认，资料已提交伦理",
  "completion_date": "2024-07-10"
}
```

**完成决议后：**
1. 发送通知给会议组织者和相关人员
2. 刷新会议表的pending_resolution计数

---

## 10. 会议材料 CRUD (material.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?meeting_id=xxx&type=&timing=` |
| POST | / | 上传材料（multipart/form-data） |
| PUT | /:materialId | 更新材料信息 |
| DELETE | /:materialId | 删除材料 |

**POST body（multipart/form-data）：**
```
meeting_id: uuid
material_type: PPT
doc_category: PPT
upload_timing: BEFORE
file: <binary>
```

文件保存到 `/uploads/meeting/materials/`

---

## 11. 会议通知 (notification.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?meeting_id=xxx&participant_id=xxx` |
| POST | /send | 发送通知（邀请/提醒/取消） |
| POST | /minutes-published | 纪要发布通知 |

**POST /send body：**
```json
{
  "meeting_id": "uuid",
  "participant_ids": ["uuid1", "uuid2"],  // 空数组表示全体
  "notification_type": "REMINDER",
  "channel": "SYSTEM",
  "title": "会议提醒",
  "content": "PD-001项目启动会将于30分钟后开始，请准时参加"
}
```

**发送后：**
1. INSERT meeting_notification
2. 发送站内信（调用通知服务）
3. 如channel=EMAIL，发送邮件
4. 返回发送结果

---

## 12. 会议统计 (stats.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 全局统计 `?start_date=&end_date=` |
| GET | /project/:projectId | 项目统计 |
| GET | /personal | 个人统计（我的待办决议） |

**GET / 响应：**
```json
{
  "monthly_count": 15,
  "upcoming_count": 5,
  "pending_minutes": 3,
  "pending_resolutions": 8,
  "trend": {
    "this_month": 15,
    "last_month": 12,
    "change_rate": 25
  }
}
```

**GET /personal 响应：**
```json
{
  "my_pending_resolutions": [
    {
      "resolution_id": "uuid",
      "resolution_content": "完成伦理审批资料提交",
      "meeting_title": "PD-001项目启动会",
      "due_date": "2024-07-15",
      "priority": "HIGH",
      "meeting_status": "COMPLETED"
    }
  ],
  "total_pending": 3,
  "overdue": 1
}
```

---

## 13. 项目维度会议 (project-meeting.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 项目会议列表 |
| GET | /:meetingId | 项目会议详情 |
| POST | / | 新建项目会议 |
| PUT | /:meetingId | 编辑项目会议 |
| DELETE | /:meetingId | 删除项目会议 |
| GET | /stats | 项目会议统计 |

**GET / 响应：** 同 GET /api/meetings，自动加 project_id 过滤

**POST /：** 同 POST /api/meetings，project_id 由URL参数带入

---

## 14. 中心维度会议 (project-site-meeting.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心会议列表（轻量） |
| GET | /resolutions | 中心决议列表 |

**GET / 响应：**
```json
{
  "site_meeting_summary": {
    "total_meetings": 8,
    "upcoming_meetings": 1,
    "last_meeting": {
      "meeting_id": "uuid",
      "meeting_title": "CRA第三次监查",
      "start_time": "2024-06-18T09:00:00Z",
      "meeting_status": "COMPLETED"
    }
  },
  "meetings": [
    {
      "meeting_id": "uuid",
      "meeting_title": "中心启动会",
      "meeting_type": "SITE_INITIATION",
      "start_time": "2024-03-01T10:00:00Z",
      "meeting_status": "COMPLETED",
      "host_member_name": "张PM",
      "participant_count": 10
    }
  ]
}
```

**数据来源：**
- JOIN meeting + meeting_participant (筛选 project_site_id 关联的参会人员)

**GET /resolutions 响应：**
```json
{
  "pending_count": 2,
  "resolutions": [
    {
      "resolution_id": "uuid",
      "resolution_content": "完成ICF更新",
      "due_date": "2024-06-30",
      "resolution_status": "IN_PROGRESS",
      "responsible_name": "王CRC",
      "meeting_title": "CRA第二次监查"
    }
  ]
}
```

---

## 15. 跨域API调用示例

### 15.1 调用项目模块获取项目信息
```javascript
// 在 meeting.js 中
const projectDb = require('../project/db');  // Project模块db实例

// 获取项目名称
const project = projectDb.prepare(`
  SELECT project_id, project_name, project_code
  FROM project
  WHERE project_id = ?
`).get(projectId);
```

### 15.2 调用HR模块获取人员信息
```javascript
// 在 participant.js 中
const memberDb = require('../hr/db');  // HR模块db实例

// 查询人员信息
const member = memberDb.prepare(`
  SELECT member_id, name, department, position_type, mobile, email
  FROM member
  WHERE member_id = ? AND member_status = 'ACTIVE'
`).get(memberId);
```

### 15.3 发送通知（调用通知服务）
```javascript
// 在 meeting.js 或 notification.js 中
const notificationService = require('../services/notification');

// 发送会议邀请
await notificationService.send({
  type: 'MEETING_INVITE',
  recipient_ids: participantIds,
  title: meeting.meeting_title,
  content: `会议时间: ${meeting.start_time}\n会议链接: ${meeting.meeting_link}`,
  data: { meeting_id: meeting.meeting_id }
});
```

---

## 16. 错误码规范

| 错误码 | 说明 | 场景 |
|--------|------|------|
| 400 | 参数错误 | 必填字段为空、格式错误 |
| 404 | 资源不存在 | 会议/参会人/决议不存在 |
| 409 | 冲突 | 删除有子数据的会议、重复添加参会人 |
| 500 | 服务器错误 | 数据库异常 |

**错误响应示例：**
```json
{
  "code": 409,
  "message": "该会议已有关联纪要，无法删除",
  "detail": {
    "minutes_id": "uuid",
    "minutes_status": "COMPLETED"
  }
}
```

---

## 17. 第一版不做

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
