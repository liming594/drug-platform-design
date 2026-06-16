# Quality/CAPA Module API路由规范 (对象线12号: Quality/CAPA)

> 后端: Node.js + Express
> 数据库: quality.db (better-sqlite3, WAL模式)

---

## 1. 文件结构

```
server/routes/
├── quality/
│   ├── db.js                   ← quality.db 连接 + 建表
│   ├── finding.js              ← 质量发现 CRUD
│   ├── capa.js                 ← CAPA措施 CRUD
│   ├── capa-task.js            ← CAPA任务 CRUD
│   ├── audit.js                ← 质量稽查/检查 CRUD
│   ├── indicator.js            ← 质量指标
│   ├── document.js             ← 文档管理
│   └── log.js                  ← 操作日志
├── project-quality.js           ← L2-项目质量管理
└── project-site-quality.js      ← L3-中心质量管理(驾驶舱嵌入)
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'quality.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-quality-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
-- 完整建表脚本见 codex-quality-sql.md
CREATE TABLE IF NOT EXISTS quality_finding (...);
CREATE TABLE IF NOT EXISTS capa (...);
CREATE TABLE IF NOT EXISTS capa_task (...);
CREATE TABLE IF NOT EXISTS quality_audit (...);
CREATE TABLE IF NOT EXISTS quality_indicator (...);
CREATE TABLE IF NOT EXISTS quality_log (...);
CREATE TABLE IF NOT EXISTS quality_document (...);
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// Quality模块
app.use('/api/quality/findings', require('./routes/quality/finding'));
app.use('/api/quality/capas', require('./routes/quality/capa'));
app.use('/api/quality/capas/:capaId/tasks', require('./routes/quality/capa-task'));
app.use('/api/quality/audits', require('./routes/quality/audit'));
app.use('/api/quality/indicators', require('./routes/quality/indicator'));
app.use('/api/quality/documents', require('./routes/quality/document'));
app.use('/api/quality/logs', require('./routes/quality/log'));
app.use('/api/quality/dashboard', require('./routes/quality/dashboard'));

// 项目级
app.use('/api/projects/:projectId/quality', require('./routes/project-quality'));
// 中心级
app.use('/api/projects/:projectId/sites/:projectSiteId/quality', require('./routes/project-site-quality'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该发现下有关联CAPA，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- **跨域调用：** 调用其他模块API获取关联数据（详见各接口说明）

---

## 5. 仪表盘 (dashboard.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 获取质量概览统计 |

**GET / 响应：**
```json
{
  "summary": {
    "open": 12,
    "in_progress": 28,
    "pending_approval": 8,
    "verified": 45,
    "closed": 156,
    "overdue": 3,
    "closure_rate": 85.2
  },
  "by_severity": {
    "critical": 5,
    "major": 35,
    "minor": 120,
    "observation": 89
  },
  "by_type": {
    "internal_audit": 50,
    "sponsor_audit": 80,
    "regulatory_inspection": 20,
    "deviation": 70,
    "other": 29
  },
  "capa_summary": {
    "pending": 25,
    "in_progress": 30,
    "pending_verification": 8,
    "verified": 45,
    "overdue": 5
  }
}
```

**数据来源：**
- 统计各状态finding/capa数量
- 超期 = due_date/target_close_date < today AND status ∉ (VERIFIED/CLOSED)
- 闭环率 = (verified + closed) / total × 100%

---

## 6. 质量发现 CRUD (finding.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_id=&project_site_id=&type=&severity=&status=&keyword=&page=&size=` |
| GET | /:findingId | 详情，含 capas[] + documents[] + logs[] |
| POST | / | 新增发现 |
| PUT | /:findingId | 编辑 |
| PUT | /:findingId/status | 变更状态 |
| PUT | /:findingId/close | 关闭发现 |
| DELETE | /:findingId | 删除（仅OPEN状态可删） |

**GET / 列表响应：**
```json
{
  "total": 150,
  "page": 1,
  "size": 20,
  "list": [{
    "finding_id": "uuid",
    "finding_no": "QF-2024-0001",
    "project_id": "uuid",
    "project_name": "PD-001",
    "project_site_id": "uuid",
    "site_name": "北京协和医院",
    "finding_type": "SPONSOR_AUDIT",
    "severity": "MAJOR",
    "found_date": "2024-06-15",
    "target_close_date": "2024-07-15",
    "finding_status": "IN_PROGRESS",
    "capa_count": 3,
    "capa_closed_count": 1,
    "is_overdue": false,
    "created_at": "2024-06-15T10:00:00Z"
  }]
}
```

**GET /:findingId 详情响应：**
```json
{
  "finding_id": "uuid",
  "finding_no": "QF-2024-0001",
  "project_id": "uuid",
  "project_name": "PD-001",
  "project_site_id": "uuid",
  "site_name": "北京协和医院",
  "finding_type": "SPONSOR_AUDIT",
  "severity": "MAJOR",
  "found_date": "2024-06-15",
  "target_close_date": "2024-07-15",
  "description": "知情同意书签署不规范...",
  "root_cause": "培训不到位",
  "impact_assessment": "轻度影响",
  "regulatory_reference": "GCP第5.2条",
  "finding_status": "IN_PROGRESS",
  "actual_close_date": null,
  "related_audit_id": "uuid",
  "related_files": [
    { "file_id": "uuid", "file_name": "稽查报告.pdf", "file_path": "/uploads/..." }
  ],
  "capa_count": 3,
  "capa_closed_count": 1,
  "is_overdue": false,
  "capas": [
    {
      "capa_id": "uuid",
      "capa_no": "CA-QF-2024-0001-001",
      "capa_type": "CA",
      "description": "重新培训...",
      "responsible_name": "张CRA",
      "due_date": "2024-06-30",
      "status": "VERIFIED"
    }
  ],
  "documents": [
    { "doc_id": "uuid", "doc_name": "稽查报告.pdf", "doc_type": "AUDIT_REPORT" }
  ],
  "logs": [
    { "log_id": "uuid", "action": "CREATE", "actor_name": "张三", "created_at": "..." }
  ],
  "created_at": "2024-06-15T10:00:00Z",
  "updated_at": "2024-06-15T10:00:00Z",
  "created_by": "uuid",
  "created_by_name": "张三"
}
```

**POST body：**
```json
{
  "project_id": "uuid",
  "project_site_id": "uuid",
  "finding_type": "SPONSOR_AUDIT",
  "severity": "MAJOR",
  "found_date": "2024-06-15",
  "target_close_date": "2024-07-15",
  "description": "知情同意书签署不规范...",
  "root_cause": "培训不到位",
  "impact_assessment": "轻度影响",
  "regulatory_reference": "GCP第5.2条",
  "related_audit_id": "uuid",
  "remark": ""
}
```

**编号自动生成逻辑：**
```javascript
// 获取当年最大编号
const maxNo = db.prepare(`
  SELECT finding_no FROM quality_finding 
  WHERE finding_no LIKE ? 
  ORDER BY finding_no DESC LIMIT 1
`).get(`QF-${year}-%`);

// 解析流水号并+1
const seq = maxNo ? parseInt(maxNo.split('-')[2]) + 1 : 1;
const finding_no = `QF-${year}-${String(seq).padStart(4, '0')}`;
```

**PUT /:findingId/status body：**
```json
{
  "finding_status": "VERIFIED",
  "remark": ""
}
```

**状态变更规则：**
- OPEN → IN_PROGRESS：创建CAPA时自动触发
- IN_PROGRESS → PENDING_APPROVAL：所有CAPA都VERIFIED时自动触发
- PENDING_APPROVAL → VERIFIED：验证人手动确认
- VERIFIED → CLOSED：关闭操作

**PUT /:findingId/close body：**
```json
{
  "actual_close_date": "2024-07-20",
  "remark": "所有CAPA已验证通过"
}
```

---

## 7. CAPA措施 CRUD (capa.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?finding_id=&project_id=&project_site_id=&type=&status=&priority=&responsible_id=&keyword=&page=&size=` |
| GET | /:capaId | 详情，含 tasks[] + documents[] + logs[] |
| POST | / | 新增CAPA |
| PUT | /:capaId | 编辑 |
| PUT | /:capaId/status | 变更状态 |
| PUT | /:capaId/complete | 完成任务 |
| PUT | /:capaId/verify | 验证CAPA |
| PUT | /:capaId/reject | 反驳CAPA |
| DELETE | /:capaId | 删除（仅PENDING状态可删） |

**GET / 列表响应：**
```json
{
  "total": 80,
  "list": [{
    "capa_id": "uuid",
    "capa_no": "CA-QF-2024-0001-001",
    "finding_id": "uuid",
    "finding_no": "QF-2024-0001",
    "project_id": "uuid",
    "project_name": "PD-001",
    "project_site_id": "uuid",
    "site_name": "北京协和医院",
    "capa_type": "CA",
    "description": "重新培训...",
    "priority": "HIGH",
    "responsible_id": "uuid",
    "responsible_name": "张CRA",
    "due_date": "2024-06-30",
    "status": "IN_PROGRESS",
    "is_overdue": false,
    "task_count": 2,
    "task_completed": 1,
    "created_at": "2024-06-15T10:00:00Z"
  }]
}
```

**GET /:capaId 详情响应：**
```json
{
  "capa_id": "uuid",
  "capa_no": "CA-QF-2024-0001-001",
  "finding_id": "uuid",
  "finding_no": "QF-2024-0001",
  "project_id": "uuid",
  "project_name": "PD-001",
  "project_site_id": "uuid",
  "site_name": "北京协和医院",
  "capa_type": "CA",
  "description": "对全部涉及受试者进行ICF签署规范再培训...",
  "priority": "HIGH",
  "responsible_id": "uuid",
  "responsible_name": "张CRA",
  "due_date": "2024-06-30",
  "status": "IN_PROGRESS",
  "verification_method": "FILE_REVIEW",
  "verified_by": null,
  "verified_date": null,
  "verification_comment": null,
  "completion_date": null,
  "completion_desc": null,
  "rejected_by": null,
  "rejected_date": null,
  "rejection_reason": null,
  "is_overdue": false,
  "tasks": [
    {
      "task_id": "uuid",
      "task_description": "组织培训",
      "assignee_id": "uuid",
      "assignee_name": "张CRA",
      "due_date": "2024-06-25",
      "task_status": "COMPLETED",
      "completed_date": "2024-06-20",
      "completion_comment": "已完成培训"
    }
  ],
  "documents": [],
  "logs": [],
  "created_at": "2024-06-15T10:00:00Z",
  "updated_at": "2024-06-15T10:00:00Z"
}
```

**POST body：**
```json
{
  "finding_id": "uuid",
  "capa_type": "CA",
  "description": "对全部涉及受试者进行ICF签署规范再培训...",
  "priority": "HIGH",
  "responsible_id": "uuid",
  "due_date": "2024-06-30",
  "verification_method": "FILE_REVIEW",
  "remark": ""
}
```

**编号自动生成逻辑：**
```javascript
// 获取该发现下CAPA流水号
const maxNo = db.prepare(`
  SELECT capa_no FROM capa WHERE finding_id = ?
  ORDER BY capa_no DESC LIMIT 1
`).get(findingId);

const prefix = capa_type === 'CA' ? 'CA' : 'PA';
const findingNo = db.prepare('SELECT finding_no FROM quality_finding WHERE finding_id = ?').get(findingId).finding_no;
const seq = maxNo ? parseInt(maxNo.split('-')[3]) + 1 : 1;
const capa_no = `${prefix}-${findingNo}-${String(seq).padStart(3, '0')}`;
```

**PUT /:capaId/status body：**
```json
{
  "status": "IN_PROGRESS",
  "remark": ""
}
```

**状态流转规则：**
- PENDING → IN_PROGRESS：开始执行
- IN_PROGRESS → PENDING_VERIFICATION：提交完成
- PENDING_VERIFICATION → VERIFIED：验证通过
- PENDING_VERIFICATION → REJECTED：验证打回
- VERIFIED → CLOSED：CAPA正式闭环

**PUT /:capaId/complete body（完成任务）：**
```json
{
  "completion_date": "2024-06-25",
  "completion_desc": "已完成培训，附培训签到表和培训材料",
  "completion_evidence": [
    { "file_id": "uuid", "file_name": "培训签到表.pdf" }
  ]
}
```

**PUT /:capaId/verify body（验证通过）：**
```json
{
  "verified_by": "uuid",
  "verified_date": "2024-06-26",
  "verification_comment": "验证通过，文件齐全"
}
```

**PUT /:capaId/reject body（反驳）：**
```json
{
  "rejected_by": "uuid",
  "rejected_date": "2024-06-26",
  "rejection_reason": "培训记录不完整，缺少考核成绩"
}
```

**反驳后状态自动回退：** REJECTED → IN_PROGRESS

---

## 8. CAPA任务 CRUD (capa-task.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?capa_id=&assignee_id=&status=` |
| GET | /:taskId | 详情 |
| POST | / | 新增任务 |
| PUT | /:taskId | 编辑 |
| PUT | /:taskId/complete | 完成任务 |
| PUT | /:taskId/cancel | 取消任务 |
| DELETE | /:taskId | 删除（仅PENDING状态可删） |

**POST body：**
```json
{
  "capa_id": "uuid",
  "task_description": "组织ICF规范培训会议",
  "assignee_id": "uuid",
  "due_date": "2024-06-25",
  "remark": ""
}
```

**PUT /:taskId/complete body：**
```json
{
  "completed_date": "2024-06-20",
  "completion_comment": "已完成培训会议",
  "completion_evidence": [
    { "file_id": "uuid", "file_name": "会议纪要.pdf" }
  ]
}
```

**任务完成后的级联逻辑：**
- 当 capa 下所有 task.task_status = COMPLETED 时
- 自动将 capa.status → PENDING_VERIFICATION
- 发送通知给验证人

---

## 9. 质量稽查/检查 CRUD (audit.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_id=&project_site_id=&type=&status=&keyword=&page=&size=` |
| GET | /:auditId | 详情，含 findings[] |
| POST | / | 新增稽查记录 |
| PUT | /:auditId | 编辑 |
| PUT | /:auditId/status | 变更状态 |
| DELETE | /:auditId | 删除 |

**GET / 列表响应：**
```json
{
  "total": 30,
  "list": [{
    "audit_id": "uuid",
    "audit_no": "AUDIT-2024-0001",
    "project_id": "uuid",
    "project_name": "PD-001",
    "project_site_id": "uuid",
    "site_name": "北京协和医院",
    "audit_type": "SPONSOR",
    "audit_org": "恒瑞申办方",
    "auditor": "王稽查",
    "audit_date": "2024-06-15",
    "findings_count": 5,
    "audit_status": "COMPLETED",
    "created_at": "2024-06-10T10:00:00Z"
  }]
}
```

**POST body：**
```json
{
  "project_id": "uuid",
  "project_site_id": "uuid",
  "audit_type": "SPONSOR",
  "audit_org": "恒瑞申办方",
  "auditor": "王稽查",
  "audit_date": "2024-06-15",
  "findings_count": 5,
  "scheduled_date": "2024-06-10",
  "remark": ""
}
```

---

## 10. 质量指标 (indicator.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 指标列表，`?project_id=&project_site_id=&type=&period_type=&period_value=` |
| POST | / | 生成指标快照 |
| GET | /trend | 趋势数据，`?project_id=&project_site_id=&type=&period_count=6` |

**GET /trend 响应：**
```json
{
  "indicators": [
    {
      "period": "2024-06",
      "deviation_rate": 3.5,
      "capa_close_rate": 85.2,
      "timely_resolution_rate": 92.0
    },
    {
      "period": "2024-05",
      "deviation_rate": 4.2,
      "capa_close_rate": 82.0,
      "timely_resolution_rate": 88.5
    }
  ]
}
```

**指标计算公式：**
```
偏差率 = 本月偏差发现数 / 本月入组总数 × 100%
CAPA闭环率 = 本月已闭环CAPA / 本月应闭环CAPA × 100%
及时整改率 = 按时完成CAPA数 / 应完成CAPA数 × 100%
```

---

## 11. 文档管理 (document.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 文档列表，`?entity_type=&entity_id=&doc_type=` |
| POST | / | 上传文档 |
| PUT | /:docId | 编辑文档信息 |
| DELETE | /:docId | 删除文档 |

**POST body（multipart/form-data）：**
```
entity_type: FINDING
entity_id: uuid
doc_type: AUDIT_REPORT
file: (文件)
remark: (可选)
```

**文件存储路径：**
```
/uploads/quality/
  ├── {year}/
  │   ├── {month}/
  │   │   ├── {doc_id}/
  │   │   │   ├── {original_filename}
  │   │   │   └── ...
```

---

## 12. 操作日志 (log.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 日志列表，`?entity_type=&entity_id=&action=&actor_id=&page=&size=` |

**GET / 响应：**
```json
{
  "total": 500,
  "list": [{
    "log_id": "uuid",
    "entity_type": "CAPA",
    "entity_id": "uuid",
    "action": "STATUS_CHANGE",
    "actor_id": "uuid",
    "actor_name": "张三",
    "old_value": "{\"status\": \"IN_PROGRESS\"}",
    "new_value": "{\"status\": \"PENDING_VERIFICATION\"}",
    "change_summary": "状态变更为待验证",
    "created_at": "2024-06-20T10:00:00Z"
  }]
}
```

---

## 13. L2 项目质量管理 (project-quality.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 项目质量概览 |
| GET | /findings | 项目发现列表 |
| GET | /capas | 项目CAPA列表 |
| GET | /indicators | 项目质量指标 |
| GET | /sites/ranking | 中心质量排名 |

**GET / 响应：**
```json
{
  "project_id": "uuid",
  "project_name": "PD-001",
  "summary": {
    "total_findings": 45,
    "open": 3,
    "in_progress": 8,
    "closed": 34,
    "overdue": 1,
    "closure_rate": 87.2
  },
  "by_severity": {
    "critical": 2,
    "major": 15,
    "minor": 25,
    "observation": 3
  }
}
```

**GET /sites/ranking 响应：**
```json
{
  "rankings": [
    { "project_site_id": "uuid", "site_name": "北京协和医院", "findings_count": 12, "rank": 1 },
    { "project_site_id": "uuid", "site_name": "北医三院", "findings_count": 8, "rank": 2 },
    { "project_site_id": "uuid", "site_name": "阜外医院", "findings_count": 4, "rank": 3 }
  ]
}
```

---

## 14. L3 中心质量管理 (project-site-quality.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心质量概览（轻量） |

**GET / 响应：**
```json
{
  "project_site_id": "uuid",
  "site_name": "北京协和医院",
  "summary": {
    "total_findings": 12,
    "by_severity": {
      "critical": 1,
      "major": 4,
      "minor": 7
    },
    "capa_status": {
      "pending": 2,
      "in_progress": 3,
      "verified": 5,
      "closed": 2
    },
    "overdue_capas": 0
  },
  "recent_findings": [
    {
      "finding_id": "uuid",
      "finding_no": "QF-2024-0001",
      "finding_type": "SPONSOR_AUDIT",
      "severity": "MAJOR",
      "finding_status": "IN_PROGRESS"
    }
  ]
}
```

---

## 15. 跨域API调用示例

### 15.1 调用Project模块获取项目信息
```javascript
// 在 finding.js 中
const projectDb = require('../project/db');  // Project模块db实例

// 获取项目名称
const project = projectDb.prepare(`
  SELECT project_id, project_name FROM project WHERE project_id = ?
`).get(projectId);
```

### 15.2 调用Member模块获取人员信息
```javascript
// 在 capa.js 中
const memberDb = require('../hr/member/db');  // HR模块db实例

// 获取负责人信息
const responsible = memberDb.prepare(`
  SELECT member_id, name, email, mobile FROM member WHERE member_id = ?
`).get(responsibleId);
```

### 15.3 发送站内通知
```javascript
// 通知服务调用
const notifyService = require('../services/notification');

// CAPA超期通知
notifyService.send({
  type: 'CAPA_OVERDUE',
  recipient_ids: [capa.responsible_id],
  title: 'CAPA超期提醒',
  content: `CAPA ${capa.capa_no} 已超期，请尽快处理。`
});
```

---

## 16. 权限控制说明

| 角色 | 发现 | CAPA | 稽查 | 指标 |
|------|------|------|------|------|
| QA | 全部 | 全部 | 全部 | 全部 |
| PM | 项目内 | 项目内 | 项目内 | 项目内 |
| CRA | 中心内 | 中心内 | 中心内 | 中心内 |
| CRC | 观察 | 观察 | 观察 | 观察 |

**前端鉴权逻辑：**
```javascript
// 根据用户角色过滤可操作数据
function filterByRole(userRole, userId, projectId, siteId) {
  switch(userRole) {
    case 'QA':
      return {};  // 不过滤
    case 'PM':
      return { project_id: projectId };  // 仅项目内
    case 'CRA':
      return { project_site_id: siteId };  // 仅中心内
    case 'CRC':
      return { project_site_id: siteId, readonly: true };  // 仅观察
    default:
      return { project_id: projectId, readonly: true };
  }
}
```

---

## 17. 第一版不做

- ❌ 完整权限系统（第一版前端模拟权限）
- ❌ 站内通知/邮件提醒
- ❌ 与eTMF系统对接
- ❌ 与监管系统对接（NMPA整改报告）
- ❌ CAPA看板拖拽功能
- ❌ 自定义指标配置
- ❌ PDF报告自动生成
- ❌ 移动端适配

---

*文档版本 V1.0 | 2026-06-20*
