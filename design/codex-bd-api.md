# BD Module API路由规范 (对象线: BD / 商务拓展)

> 后端: Node.js + Express
> 数据库: bd.db (better-sqlite3, WAL模式)
> 挂载路径: /api/bd/

---

## 一、文件结构

```
server/routes/
├── bd/
│   ├── db.js                     ← bd.db 连接 + 建表
│   ├── bd-project.js             ← BD项目 CRUD + 业务接口
│   └── visit-record.js           ← 拜访记录 CRUD
│
└── sponsor/                       ← 申办方对象线（独立模块）
    ├── master.js                 ← 申办方主档
    └── contact.js                ← 联系人管理
```

---

## 二、db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'bd.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-bd-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
-- bd_project
CREATE TABLE IF NOT EXISTS bd_project (
    bd_project_id           TEXT PRIMARY KEY,
    bd_project_name        TEXT NOT NULL,
    sponsor_id             TEXT,
    sponsor_name           TEXT,
    bd_type                TEXT NOT NULL,
    estimated_value        REAL DEFAULT 0,
    probability            REAL DEFAULT 0,
    expected_close_date    TEXT,
    assigned_bd_id         TEXT,
    assigned_bd_name       TEXT,
    source                 TEXT,
    source_detail          TEXT,
    competitor_info        TEXT,
    bd_stage               TEXT DEFAULT 'INITIAL',
    stage_changed_at       TEXT,
    project_id             TEXT,
    loss_reason            TEXT,
    status                 TEXT DEFAULT 'ACTIVE',
    description            TEXT,
    contact_person         TEXT,
    contact_phone          TEXT,
    visit_count            INTEGER DEFAULT 0,
    last_visit_date        TEXT,
    created_at             TEXT DEFAULT (datetime('now')),
    updated_at             TEXT DEFAULT (datetime('now')),
    created_by             TEXT,
    updated_by             TEXT
);

-- bd_project_action
CREATE TABLE IF NOT EXISTS bd_project_action (
    action_id              TEXT PRIMARY KEY,
    bd_project_id         TEXT NOT NULL,
    action_type           TEXT NOT NULL,
    action_content        TEXT,
    from_stage            TEXT,
    to_stage              TEXT,
    attachments           TEXT,
    created_at            TEXT DEFAULT (datetime('now')),
    created_by            TEXT,
    created_by_name       TEXT
);

-- visit_record
CREATE TABLE IF NOT EXISTS visit_record (
    visit_id              TEXT PRIMARY KEY,
    sponsor_id            TEXT NOT NULL,
    sponsor_name          TEXT,
    bd_project_id         TEXT,
    visit_date            TEXT NOT NULL,
    visit_type            TEXT NOT NULL,
    visit_purpose         TEXT,
    visitor_ids           TEXT,
    visitor_names         TEXT,
    contact_id            TEXT,
    contact_person        TEXT,
    contact_phone         TEXT,
    contact_position      TEXT,
    location              TEXT,
    content_summary       TEXT,
    key_points            TEXT,
    follow_up_plan        TEXT,
    next_visit_date       TEXT,
    attachments           TEXT,
    status                TEXT DEFAULT 'COMPLETED',
    visit_effectiveness   REAL,
    client_satisfaction   REAL,
    created_at            TEXT DEFAULT (datetime('now')),
    updated_at            TEXT DEFAULT (datetime('now')),
    created_by            TEXT,
    updated_by            TEXT
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_bdp_name ON bd_project(bd_project_name);
CREATE INDEX IF NOT EXISTS idx_bdp_sponsor ON bd_project(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_bdp_stage ON bd_project(bd_stage);
CREATE INDEX IF NOT EXISTS idx_bdp_status ON bd_project(status);
CREATE INDEX IF NOT EXISTS idx_bdp_assigned ON bd_project(assigned_bd_id);

CREATE INDEX IF NOT EXISTS idx_vr_sponsor ON visit_record(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_vr_bd_project ON visit_record(bd_project_id);
CREATE INDEX IF NOT EXISTS idx_vr_date ON visit_record(visit_date);
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 三、路由注册

在 server/app.js 中：

```javascript
// BD模块
app.use('/api/bd/projects', require('./routes/bd/bd-project'));
app.use('/api/bd/visits', require('./routes/bd/visit-record'));
```

---

## 四、通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该BD项目下有关联拜访记录，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- JSON字段存储: `JSON.stringify()` 后存入，取出时 `JSON.parse()`

---

## 五、BD项目 CRUD + 业务接口 (bd-project.js)

### 5.1 接口一览

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?status=&stage=&bd_type=&sponsor_id=&assigned_bd_id=&keyword=&page=&size=` |
| GET | /:bdProjectId | 详情，含 actions[] + recent_visits[] |
| POST | / | 新增 |
| PUT | /:bdProjectId | 编辑 |
| DELETE | /:bdProjectId | 删除 |
| PUT | /:bdProjectId/stage | 推进/变更阶段 |
| POST | /:bdProjectId/convert | 转化为正式项目 |
| GET | /:bdProjectId/actions | 跟进记录列表 |

### 5.2 GET / 列表

**Query参数：**
- `status`: ACTIVE/ARCHIVED
- `stage`: INITIAL/PROSPECTING/QUALIFICATION/QUOTATION/NEGOTIATION/SIGNED/WON/LOST
- `bd_type`: NEW_CLIENT/EXISTING_EXPANSION
- `sponsor_id`: 申办方ID
- `assigned_bd_id`: 负责BD用户ID
- `keyword`: 项目名称/申办方名称搜索
- `page`, `size`: 分页
- `sort`, `order`: 排序，默认 created_at desc

**响应：**
```json
{
  "total": 25,
  "page": 1,
  "size": 20,
  "list": [
    {
      "bd_project_id": "uuid",
      "bd_project_name": "恒瑞医药PD-1项目BD",
      "sponsor_id": "uuid",
      "sponsor_name": "恒瑞医药股份有限公司",
      "bd_type": "NEW_CLIENT",
      "bd_stage": "NEGOTIATION",
      "estimated_value": 15000000,
      "probability": 60,
      "expected_close_date": "2026-07-15",
      "assigned_bd_name": "张三",
      "source": "REFERRAL",
      "visit_count": 3,
      "last_visit_date": "2026-06-10",
      "created_at": "2026-05-01T10:00:00Z"
    }
  ]
}
```

### 5.3 GET /:bdProjectId 详情

**响应：**
```json
{
  "bd_project_id": "uuid",
  "bd_project_name": "恒瑞医药PD-1项目BD",
  "sponsor_id": "uuid",
  "sponsor_name": "恒瑞医药股份有限公司",
  "bd_type": "NEW_CLIENT",
  "estimated_value": 15000000,
  "probability": 60,
  "expected_close_date": "2026-07-15",
  "assigned_bd_id": "user-uuid",
  "assigned_bd_name": "张三",
  "source": "REFERRAL",
  "source_detail": "老客户王总介绍",
  "competitor_info": [
    {"name": "泰格医药", "strength": "品牌知名度高", "weakness": "价格偏高", "price_range": "1500-1800万"}
  ],
  "bd_stage": "NEGOTIATION",
  "stage_changed_at": "2026-06-01T10:00:00Z",
  "project_id": null,
  "loss_reason": null,
  "status": "ACTIVE",
  "description": "恒瑞医药有意向开展PD-1抑制剂临床研究",
  "contact_person": "王经理",
  "contact_phone": "13900139000",
  "visit_count": 3,
  "last_visit_date": "2026-06-10",
  "created_at": "2026-05-01T10:00:00Z",
  "updated_at": "2026-06-15T14:30:00Z",
  "actions": [
    {
      "action_id": "uuid",
      "action_type": "STAGE_CHANGE",
      "action_content": "阶段从 PROSPECTING 变更为 QUALIFICATION",
      "from_stage": "PROSPECTING",
      "to_stage": "QUALIFICATION",
      "created_at": "2026-06-01T10:00:00Z",
      "created_by_name": "张三"
    }
  ],
  "recent_visits": [
    {
      "visit_id": "uuid",
      "visit_date": "2026-06-10",
      "visit_type": "NEGOTIATION",
      "location": "恒瑞医药上海总部",
      "content_summary": "讨论了临床方案和报价细节"
    }
  ]
}
```

### 5.4 POST / 新增

**请求体：**
```json
{
  "bd_project_name": "恒瑞医药PD-1项目BD",
  "sponsor_id": "uuid",
  "bd_type": "NEW_CLIENT",
  "estimated_value": 15000000,
  "probability": 50,
  "expected_close_date": "2026-07-15",
  "assigned_bd_id": "user-uuid",
  "source": "REFERRAL",
  "source_detail": "老客户王总介绍",
  "competitor_info": [],
  "bd_stage": "INITIAL",
  "description": "恒瑞医药有意向开展PD-1抑制剂临床研究",
  "contact_person": "王经理",
  "contact_phone": "13900139000"
}
```

**必填字段：** bd_project_name, bd_type
**可选自动获取：** 如果传了 sponsor_id，自动获取 sponsor_name

**响应：** 返回完整对象 (201)

### 5.5 PUT /:bdProjectId 编辑

**请求体：** 同 POST，支持部分更新

**限制：** 
- bd_stage 为 WON/LOST 时不允许编辑基本字段
- 已转化为正式项目的BD项目不允许编辑

### 5.6 PUT /:bdProjectId/stage 变更阶段

**请求体：**
```json
{
  "bd_stage": "QUALIFICATION",
  "remark": "需求已确认，准备提供方案"
}
```

**阶段推进规则：**
```
INITIAL → PROSPECTING → QUALIFICATION → QUOTATION → NEGOTIATION → SIGNED → WON
                                                              ↘ LOST
```

**特殊阶段变更：**
- → LOST：必须提供 loss_reason
- → WON：必须关联 project_id（通过 convert 接口）

### 5.7 POST /:bdProjectId/convert 转化为正式项目

**请求体：**
```json
{
  "project_id": "uuid"
}
```

**前置校验：**
1. bd_stage 必须是 NEGOTIATION
2. project_id 必须存在且属于同一 sponsor_id
3. bd_project.project_id 必须为空

**业务逻辑：**
1. UPDATE bd_project SET bd_stage = 'SIGNED', project_id = ?, updated_at = ?
2. INSERT bd_project_action (STAGE_CHANGE: NEGOTIATION → SIGNED)

**注意：** 转化为正式项目后，BD项目状态变为已签约(SIGNED)，前端可继续查看，但不能再变更阶段。

### 5.8 DELETE /:bdProjectId

**前置校验：**
- 无关联的拜访记录 (visit_count = 0)
- bd_stage 不是 WON/LOST

**返回：** 200 OK

### 5.9 GET /:bdProjectId/actions

**响应：**
```json
{
  "total": 10,
  "list": [
    {
      "action_id": "uuid",
      "action_type": "STAGE_CHANGE",
      "action_content": "阶段从 PROSPECTING 变更为 QUALIFICATION",
      "from_stage": "PROSPECTING",
      "to_stage": "QUALIFICATION",
      "attachments": [],
      "created_at": "2026-06-01T10:00:00Z",
      "created_by": "user-uuid",
      "created_by_name": "张三"
    }
  ]
}
```

---

## 六、拜访记录 CRUD (visit-record.js)

### 6.1 接口一览

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?sponsor_id=&bd_project_id=&visit_type=&status=&start_date=&end_date=&page=&size=` |
| GET | /:visitId | 详情 |
| POST | / | 新增 |
| PUT | /:visitId | 编辑 |
| DELETE | /:visitId | 删除 |

### 6.2 GET / 列表

**Query参数：**
- `sponsor_id`: 申办方ID
- `bd_project_id`: BD项目ID
- `visit_type`: FIRST_VISIT/REGULAR_VISIT/NEGOTIATION/AFTER_SALES
- `status`: DRAFT/COMPLETED/CANCELLED
- `start_date`, `end_date`: 拜访日期范围
- `keyword`: 拜访内容搜索
- `page`, `size`: 分页
- `sort`, `order`: 排序，默认 visit_date desc

**响应：**
```json
{
  "total": 50,
  "page": 1,
  "size": 20,
  "list": [
    {
      "visit_id": "uuid",
      "sponsor_id": "uuid",
      "sponsor_name": "恒瑞医药股份有限公司",
      "bd_project_id": "uuid",
      "bd_project_name": "恒瑞医药PD-1项目BD",
      "visit_date": "2026-06-10",
      "visit_type": "NEGOTIATION",
      "visit_purpose": "项目洽谈",
      "visitor_names": "张三, 李四",
      "contact_person": "王经理",
      "location": "恒瑞医药上海总部",
      "content_summary": "讨论了临床方案和报价细节",
      "status": "COMPLETED",
      "visit_effectiveness": 4.5,
      "created_at": "2026-06-10T18:00:00Z"
    }
  ]
}
```

### 6.3 GET /:visitId 详情

**响应：**
```json
{
  "visit_id": "uuid",
  "sponsor_id": "uuid",
  "sponsor_name": "恒瑞医药股份有限公司",
  "bd_project_id": "uuid",
  "bd_project_name": "恒瑞医药PD-1项目BD",
  "visit_date": "2026-06-10",
  "visit_type": "NEGOTIATION",
  "visit_purpose": "项目洽谈",
  "visitor_ids": ["user-uuid-1", "user-uuid-2"],
  "visitor_names": "张三, 李四",
  "contact_id": "contact-uuid",
  "contact_person": "王经理",
  "contact_phone": "13900139000",
  "contact_position": "BD总监",
  "location": "恒瑞医药上海总部",
  "content_summary": "讨论了临床方案和报价细节",
  "key_points": [
    {"title": "客户需求", "content": "希望在Q4启动临床试验"},
    {"title": "预算范围", "content": "1500-1800万"},
    {"title": "竞品信息", "content": "竞品报价1600万，我们有价格优势"}
  ],
  "follow_up_plan": "1. 准备详细临床方案 2. 安排下次技术对接",
  "next_visit_date": "2026-06-25",
  "attachments": [
    {"name": "会议纪要.pdf", "url": "/uploads/bd/visits/xxx.pdf", "size": 102400}
  ],
  "status": "COMPLETED",
  "visit_effectiveness": 4.5,
  "client_satisfaction": 4.0,
  "created_at": "2026-06-10T18:00:00Z",
  "updated_at": "2026-06-10T20:00:00Z",
  "created_by": "user-uuid",
  "created_by_name": "张三"
}
```

### 6.4 POST / 新增

**请求体：**
```json
{
  "sponsor_id": "uuid",
  "bd_project_id": "uuid",
  "visit_date": "2026-06-10",
  "visit_type": "NEGOTIATION",
  "visit_purpose": "项目洽谈",
  "visitor_ids": ["user-uuid-1", "user-uuid-2"],
  "contact_id": "contact-uuid",
  "contact_person": "王经理",
  "contact_phone": "13900139000",
  "contact_position": "BD总监",
  "location": "恒瑞医药上海总部",
  "content_summary": "讨论了临床方案和报价细节",
  "key_points": [
    {"title": "客户需求", "content": "希望在Q4启动临床试验"}
  ],
  "follow_up_plan": "准备详细临床方案",
  "next_visit_date": "2026-06-25",
  "attachments": [],
  "status": "COMPLETED",
  "visit_effectiveness": 4.5,
  "client_satisfaction": 4.0
}
```

**必填字段：** sponsor_id, visit_date, visit_type
**自动处理：** 
- 如果传了 sponsor_id，自动获取 sponsor_name
- 如果传了 bd_project_id，自动获取 bd_project_name
- visitor_ids 为 JSON 数组，自动转为字符串存储

**响应：** 返回完整对象 (201)

### 6.5 PUT /:visitId 编辑

**请求体：** 同 POST，支持部分更新

### 6.6 DELETE /:visitId

**前置校验：**
- status 不是 DRAFT 时不允许删除（只能取消）

---

## 七、调用申办方对象线API

### 7.1 获取申办方信息

```javascript
// 在bd-project.js或visit-record.js中
const SPONSOR_API_BASE = process.env.SPONSOR_API_BASE || 'http://localhost:3000';

async function getSponsorInfo(sponsorId) {
  const response = await fetch(`${SPONSOR_API_BASE}/api/sponsor/masters/${sponsorId}`);
  if (!response.ok) return null;
  const data = await response.json();
  return { sponsor_name: data.sponsor_name, short_name: data.short_name };
}
```

### 7.2 获取联系人信息

```javascript
async function getContactInfo(contactId) {
  const response = await fetch(`${SPONSOR_API_BASE}/api/sponsor/contacts/${contactId}`);
  if (!response.ok) return null;
  return await response.json();
}
```

---

## 八、调用项目对象线API

### 8.1 创建正式项目后更新BD项目

```javascript
// 在项目对象线中，项目创建成功后
const BD_API_BASE = process.env.BD_API_BASE || 'http://localhost:3000';

async function onProjectCreated(projectId, sponsorId) {
  // 查找对应的BD项目并更新
  await fetch(`${BD_API_BASE}/api/bd/projects/convert/${bdProjectId}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ project_id: projectId })
  });
}
```

---

## 九、第一版不做

- ❌ BD项目竞争对手分析功能
- ❌ BD项目预期收益自动计算
- ❌ 拜访路线优化
- ❌ 拜访任务自动派发
- ❌ BD项目ROI分析
- ❌ 竞品数据库管理
- ❌ 智能成单概率预测
- ❌ 批量操作（批量归档、批量分配）

---

*文档版本 V1.0 | 2026-06-15*
