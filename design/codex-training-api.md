# 培训管理API路由规范 (对象线13号线: Training)

> 后端: Node.js + Express
> 数据库: training.db (better-sqlite3, WAL模式)

---

## 1. 文件结构

```
server/routes/
├── training/
│   ├── db.js                      ← training.db 连接 + 建表
│   ├── plan.js                    ← 培训计划 CRUD
│   ├── record.js                  ← 培训记录 CRUD
│   ├── certificate.js             ← 培训证书 CRUD
│   ├── material.js                ← 培训材料 CRUD
│   ├── attendance.js             ← 培训签到
│   ├── cert-template.js          ← 证书模板 CRUD
│   ├── project-plan.js           ← 项目培训计划 CRUD
│   ├── project-record.js         ← 项目培训记录 CRUD
│   ├── project-attendance.js     ← 项目培训签到
│   └── site-training.js          ← 中心培训信息(驾驶舱嵌入)
└── index.js                       ← 统一导出
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'training.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）
const SCHEMA = `
-- training_plan
CREATE TABLE IF NOT EXISTS training_plan (...);
-- training_record
CREATE TABLE IF NOT EXISTS training_record (...);
-- ... 其余表
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

```javascript
// 培训主档
app.use('/api/training/plans', require('./routes/training/plan'));
app.use('/api/training/records', require('./routes/training/record'));
app.use('/api/training/certificates', require('./routes/training/certificate'));
app.use('/api/training/materials', require('./routes/training/material'));
app.use('/api/training/attendance', require('./routes/training/attendance'));
app.use('/api/training/cert-templates', require('./routes/training/cert-template'));
app.use('/api/training/stats', require('./routes/training/stats'));

// 项目培训
app.use('/api/projects/:projectId/training', require('./routes/training/project-plan'));
app.use('/api/projects/:projectId/training/:projectPlanId/records', require('./routes/training/project-record'));
app.use('/api/projects/:projectId/training/:projectPlanId/attendance', require('./routes/training/project-attendance'));

// 中心驾驶舱嵌入
app.use('/api/projects/:projectId/sites/:projectSiteId/training', require('./routes/training/site-training'));

// 证书预警
app.use('/api/training/alerts', require('./routes/training/alerts'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "有关联数据，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- 自动编号：TP/TR/GCP-YYYY-NNNNN

---

## 5. 统计接口 (stats.js)

### GET /api/training/stats

获取培训统计概览。

**响应：**
```json
{
  "pending_training": 15,
  "in_progress": 8,
  "completed": 120,
  "cert_alerts": 5,
  "gcp_valid": 100,
  "gcp_expiring": 10,
  "gcp_expired": 10
}
```

---

## 6. 培训计划 CRUD (plan.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?type=&mode=&status=&keyword=&page=&size=` |
| GET | /:planId | 详情，含 attendance[] + material |
| POST | / | 新增 |
| PUT | /:planId | 编辑 |
| PUT | /:planId/status | 变更状态，body: `{ plan_status }` |
| PUT | /:planId/publish | 发布计划，触发通知 |
| DELETE | /:planId | 删除，仅DRAFT状态可删 |

**GET / 响应：**
```json
{
  "total": 25,
  "list": [{
    "plan_id": "uuid",
    "plan_no": "TP-2024-00001",
    "plan_name": "GCP培训",
    "training_type": "GCP",
    "training_mode": "线下",
    "training_date": "2024-06-20",
    "planned_count": 50,
    "attended_count": 45,
    "plan_status": "IN_PROGRESS"
  }]
}
```

**GET /:planId 响应：**
```json
{
  "plan_id": "uuid",
  "plan_no": "TP-2024-00001",
  "plan_name": "GCP培训",
  "training_type": "GCP",
  "training_mode": "线下",
  "training_date": "2024-06-20",
  "training_duration": 4,
  "training_outline": "GCP法规讲解...",
  "location": "会议室A",
  "department": "医学部",
  "trainer": "王博士",
  "target_type": "全体人员",
  "planned_count": 50,
  "plan_status": "IN_PROGRESS",
  "material": {
    "material_id": "uuid",
    "material_name": "GCP培训课件-2024版.pptx"
  },
  "attendance": [
    { "attendance_id": "uuid", "member_id": "uuid", "member_name": "张A", "attendance_status": "SIGNED" }
  ]
}
```

**POST body：**
```json
{
  "plan_name": "GCP培训",
  "training_type": "GCP",
  "training_mode": "线下",
  "training_date": "2024-06-20",
  "training_duration": 4,
  "training_outline": "GCP法规讲解...",
  "location": "会议室A",
  "department": "医学部",
  "trainer": "王博士",
  "target_type": "全体人员",
  "material_id": "uuid"
}
```

**PUT /:planId/status body：**
```json
{
  "plan_status": "COMPLETED",
  "remark": "培训已完成"
}
```

---

## 7. 培训记录 CRUD (record.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?plan_id=&date=&status=&page=&size=` |
| GET | /:recordId | 详情 |
| POST | / | 新增（培训完成后） |
| PUT | /:recordId | 编辑 |
| POST | /:recordId/generate-certs | 生成证书 |

**POST / body：**
```json
{
  "plan_id": "uuid",
  "training_date": "2024-06-20",
  "training_duration": 4,
  "attended_count": 45,
  "absent_count": 5,
  "completion_rate": 90,
  "has_exam": true,
  "pass_score": 60,
  "exam_pass_rate": 95,
  "record_file_path": "/uploads/training/records/xxx.docx",
  "photos_path": ["/uploads/training/photos/1.jpg"]
}
```

**POST /:recordId/generate-certs 响应：**
```json
{
  "generated": 43,
  "failed": 2,
  "certs": [
    { "cert_id": "uuid", "member_name": "张A", "cert_no": "GCP-2024-00001" }
  ]
}
```

---

## 8. 培训证书 CRUD (certificate.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?member_id=&type=&status=&keyword=&page=&size=` |
| GET | /:certId | 详情 |
| POST | / | 新增/上传证书 |
| PUT | /:certId | 编辑 |
| DELETE | /:certId | 删除 |
| GET | /member/:memberId | 人员证书列表 |
| PUT | /member/:memberId/check | 校验人员资质 |

**GET / 响应：**
```json
{
  "total": 120,
  "summary": {
    "valid": 100,
    "expiring": 10,
    "expired": 10
  },
  "list": [{
    "cert_id": "uuid",
    "cert_no": "GCP-2024-00001",
    "member_id": "uuid",
    "member_name": "张A",
    "cert_type": "GCP",
    "issue_date": "2024-01-15",
    "expiry_date": "2027-01-14",
    "cert_status": "VALID"
  }]
}
```

**GET /:certId 响应：**
```json
{
  "cert_id": "uuid",
  "cert_no": "GCP-2024-00001",
  "member_id": "uuid",
  "member_name": "张A",
  "cert_type": "GCP",
  "cert_name": "GCP证书",
  "issue_date": "2024-01-15",
  "expiry_date": "2027-01-14",
  "cert_status": "VALID",
  "cert_file_path": "/uploads/training/certs/xxx.pdf",
  "cert_source": "TRAINING",
  "training_plan": {
    "plan_id": "uuid",
    "plan_name": "GCP培训"
  }
}
```

**POST body（multipart/form-data）：**
```json
{
  "member_id": "uuid",
  "cert_type": "GCP",
  "cert_no": "GCP-2024-00001",
  "issue_date": "2024-01-15",
  "expiry_date": "2027-01-14"
}
```
文件通过 `req.file` 获取

**PUT /member/:memberId/check 响应：**
```json
{
  "member_id": "uuid",
  "member_name": "张A",
  "qualified": true,
  "certs": [
    { "cert_type": "GCP", "cert_status": "VALID", "expiry_date": "2027-01-14" }
  ],
  "expired_certs": [],
  "expiring_certs": []
}
```

---

## 9. 培训材料 CRUD (material.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?category=&type=&keyword=&folder_id=&page=&size=` |
| GET | /:materialId | 详情 |
| POST | / | 上传材料 |
| PUT | /:materialId | 编辑 |
| DELETE | /:materialId | 删除 |
| PUT | /:materialId/move | 移动文件/文件夹 |
| POST | /folder | 新建文件夹 |
| PUT | /:materialId/download | 记录下载次数 |

**GET / 响应：**
```json
{
  "total": 50,
  "list": [{
    "material_id": "uuid",
    "material_name": "GCP培训课件-2024版.pptx",
    "material_type": "课件",
    "file_type": "pptx",
    "file_size": 2621440,
    "category": "GCP",
    "download_count": 120,
    "is_folder": false
  }, {
    "material_id": "uuid",
    "material_name": "GCP培训",
    "material_type": "文件夹",
    "is_folder": true,
    "children_count": 5
  }]
}
```

**POST body（multipart/form-data）：**
```json
{
  "material_name": "GCP培训课件-2024版.pptx",
  "material_type": "课件",
  "category": "GCP",
  "folder_id": null
}
```

**PUT /:materialId/move body：**
```json
{
  "target_folder_id": "uuid"
}
```

---

## 10. 培训签到 (attendance.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?record_id=&member_id=&status=` |
| POST | / | 签到 |
| PUT | /:attendanceId | 编辑签到状态 |
| POST | /batch-sign | 批量签到 |
| GET | /export/:recordId | 导出签到表 |

**POST / body：**
```json
{
  "record_id": "uuid",
  "member_id": "uuid",
  "attendance_status": "SIGNED",
  "sign_in_time": "2024-06-20 09:00:00"
}
```

**POST /batch-sign body：**
```json
{
  "record_id": "uuid",
  "member_ids": ["uuid1", "uuid2", "uuid3"],
  "attendance_status": "SIGNED"
}
```

**GET /export/:recordId：**
- 返回 Excel 文件
- 字段：姓名/部门/职位/签到状态/签到时间/考核成绩/证书发放

---

## 11. 证书模板 CRUD (cert-template.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?cert_type=` |
| GET | /:templateId | 详情 |
| POST | / | 新增模板 |
| PUT | /:templateId | 编辑 |
| PUT | /:templateId/default | 设为默认 |
| DELETE | /:templateId | 删除 |

**GET / 响应：**
```json
{
  "list": [{
    "template_id": "uuid",
    "template_name": "GCP证书模板",
    "cert_type": "GCP",
    "is_default": 1,
    "template_status": "ACTIVE"
  }]
}
```

---

## 12. 项目培训计划 CRUD (project-plan.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?type=&status=&keyword=&page=&size=` |
| GET | /:projectPlanId | 详情，含 attendance[] |
| POST | / | 新增项目培训 |
| PUT | /:projectPlanId | 编辑 |
| PUT | /:projectPlanId/status | 变更状态 |
| DELETE | /:projectPlanId | 删除 |

**GET / 响应：**
```json
{
  "total": 10,
  "summary": {
    "total": 10,
    "completed": 5,
    "in_progress": 3,
    "pending": 2
  },
  "list": [{
    "project_plan_id": "uuid",
    "project_plan_no": "PTP-2024-00001",
    "plan_name": "PD-001启动会培训",
    "training_type": "方案",
    "training_mode": "线下",
    "training_date": "2024-06-15",
    "target_count": 20,
    "completed_count": 20,
    "completion_rate": 100,
    "plan_status": "COMPLETED"
  }]
}
```

**POST body：**
```json
{
  "plan_name": "PD-001启动会培训",
  "training_type": "方案",
  "training_mode": "线下",
  "training_date": "2024-06-15",
  "target_scope": "指定中心",
  "site_ids": ["siteId1", "siteId2"],
  "is_required": true,
  "need_exam": false,
  "issue_certificate": true,
  "cert_template_id": "uuid",
  "material_id": "uuid"
}
```

**POST 逻辑（事务）：**
1. INSERT project_training_plan
2. 根据 target_scope 获取成员列表（关联 project_site + team_assignment）
3. 生成 project_training_attendance 记录
4. 返回完整对象

---

## 13. 项目培训记录 CRUD (project-record.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表 |
| GET | /:projectRecordId | 详情 |
| POST | / | 新增记录 |
| PUT | /:projectRecordId | 编辑 |
| POST | /:projectRecordId/generate-certs | 生成证书 |

**POST body：**
```json
{
  "project_plan_id": "uuid",
  "training_date": "2024-06-15",
  "attended_count": 18,
  "completed_count": 18,
  "completion_rate": 100,
  "exam_count": 18,
  "exam_pass_count": 17,
  "exam_pass_rate": 94.4
}
```

---

## 14. 项目培训签到 (project-attendance.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_plan_id=&status=` |
| POST | / | 签到 |
| PUT | /:id | 编辑 |
| POST | /check-gcp | 批量GCP校验 |
| GET | /compliance/:projectId | 项目合规状态 |

**GET /compliance/:projectId 响应：**
```json
{
  "project_id": "uuid",
  "total_members": 30,
  "gcp_valid": 28,
  "gcp_expiring": 1,
  "gcp_expired": 1,
  "alerts": [
    { "member_id": "uuid", "member_name": "张三", "cert_type": "GCP", "status": "EXPIRED", "days_ago": 15 }
  ]
}
```

---

## 15. 中心培训信息 (site-training.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心培训信息（轻量） |

**GET / 响应：**
```json
{
  "site_training": {
    "total": 8,
    "completed": 7,
    "in_progress": 1,
    "completion_rate": 87.5
  },
  "certs": [
    { "cert_type": "GCP", "cert_status": "VALID", "expiry_date": "2027-01-15" },
    { "cert_type": "方案", "cert_status": "VALID" }
  ],
  "pending_trainings": [
    { "project_plan_id": "uuid", "plan_name": "SOP培训", "due_date": "2024-07-01" }
  ]
}
```

**数据来源：**
- 项目培训记录：JOIN project_training_plan + project_training_record
- 证书信息：training_certificate WHERE member_id
- 待完成培训：project_training_plan WHERE 未完成 AND 成员包含本中心

---

## 16. 证书预警 (alerts.js)

### GET /api/training/alerts

获取证书预警列表。

**Query:** `?days=30` (默认30天)

**响应：**
```json
{
  "alerts": [{
    "member_id": "uuid",
    "member_name": "张A",
    "cert_id": "uuid",
    "cert_type": "GCP",
    "cert_status": "EXPIRING",
    "expiry_date": "2024-07-15",
    "days_left": 25
  }],
  "summary": {
    "total": 15,
    "expiring": 10,
    "expired": 5
  }
}
```

### POST /api/training/alerts/remind

批量发送续证提醒。

**body:**
```json
{
  "member_ids": ["uuid1", "uuid2"],
  "cert_type": "GCP",
  "message": "您的GCP证书即将到期，请尽快参加续期培训"
}
```

---

## 17. 跨域API调用示例

### 17.1 调用HR模块获取人员列表

```javascript
// 在 plan.js 或 project-plan.js 中
const memberDb = require('../hr/db');  // HR模块db实例

// 获取全体人员或指定类型人员
const members = memberDb.prepare(`
  SELECT member_id, name, department, position, position_type
  FROM member
  WHERE member_status = 'ACTIVE'
  ${positionType ? 'AND position_type = ?' : ''}
`).all(positionType || undefined);
```

### 17.2 调用项目模块获取中心列表

```javascript
// 在 project-plan.js 中
const projectDb = require('../project/db');  // Project模块db实例

// 获取项目中心列表
const sites = projectDb.prepare(`
  SELECT ps.project_site_id, s.site_name, s.site_code
  FROM project_site ps
  JOIN site s ON s.site_id = ps.site_id
  WHERE ps.project_id = ? AND ps.site_status = 'ACTIVE'
`).all(projectId);
```

### 17.3 调用HR模块校验人员资质

```javascript
// 在 project-attendance.js 中
const memberDb = require('../hr/db');

// 校验人员GCP证书
const gcpCert = memberDb.prepare(`
  SELECT cert_id, expiry_date, cert_status
  FROM training_certificate
  WHERE member_id = ? AND cert_type = 'GCP'
  ORDER BY expiry_date DESC
  LIMIT 1
`).get(memberId);

const gcpValid = !gcpCert || 
  (gcpCert.cert_status !== 'EXPIRED' && 
   (!gcpCert.expiry_date || new Date(gcpCert.expiry_date) > new Date()));
```

---

## 18. 自动编号生成

```javascript
// 通用编号生成函数
function generateNo(prefix, table, column) {
  const year = new Date().getFullYear();
  const seqKey = `${prefix}-${year}`;
  
  // 获取当年最大序号
  const max = db.prepare(`
    SELECT ${column} FROM ${table}
    WHERE ${column} LIKE ?
    ORDER BY ${column} DESC LIMIT 1
  `).get(`${prefix}-${year}-%`);
  
  let seq = 1;
  if (max && max[column]) {
    const lastSeq = parseInt(max[column].split('-').pop());
    seq = lastSeq + 1;
  }
  
  return `${prefix}-${year}-${String(seq).padStart(5, '0')}`;
}

// 使用示例
const planNo = generateNo('TP', 'training_plan', 'plan_no');
const certNo = generateNo('GCP', 'training_certificate', 'cert_no');
```

---

## 19. 第一版不做

- ❌ 培训考核系统（在线答题）
- ❌ 培训效果评估（问卷调查）
- ❌ 外部培训对接（API同步）
- ❌ 证书OCR识别（自动录入）
- ❌ 证书自定义模板（设计器）
- ❌ 培训满意度分析

---

*文档版本 V1.0 | 2026-06-20*
