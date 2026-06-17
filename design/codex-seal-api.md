# 用印管理 Module API路由规范 (对象线16号: SEAL)

> 后端: Node.js + Express
> 数据库: seal.db (better-sqlite3, WAL模式)

---

## 1. 文件结构

```
server/routes/
├── seal/
│   ├── db.js              ← seal.db 连接 + 建表
│   ├── registry.js         ← 印章登记 CRUD
│   ├── request.js          ← 用印申请 CRUD
│   ├── approval.js         ← 审批记录 CRUD
│   ├── usage.js            ← 用印记录 CRUD
│   ├── document.js         ← 文件追踪 CRUD
│   ├── stats.js            ← 统计接口
│   └── project-seal.js    ← 项目用印 (L2)
└── project-site-seal.js    ← 中心用印 (L3)
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'seal.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-seal-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
-- seal_registry
CREATE TABLE IF NOT EXISTS seal_registry (...);
-- seal_request
CREATE TABLE IF NOT EXISTS seal_request (...);
-- seal_approval
CREATE TABLE IF NOT EXISTS seal_approval (...);
-- seal_usage_log
CREATE TABLE IF NOT EXISTS seal_usage_log (...);
-- seal_document
CREATE TABLE IF NOT EXISTS seal_document (...);
-- 索引
CREATE INDEX IF NOT EXISTS idx_sr_seal_no ON seal_registry(seal_no);
-- ... 其余索引
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// 用印管理模块
app.use('/api/seal', require('./routes/seal/registry'));      // 印章登记
app.use('/api/seal/requests', require('./routes/seal/request'));  // 用印申请
app.use('/api/seal/approvals', require('./routes/seal/approval')); // 审批记录
app.use('/api/seal/usages', require('./routes/seal/usage'));     // 用印记录
app.use('/api/seal/documents', require('./routes/seal/document')); // 文件追踪
app.use('/api/seal/stats', require('./routes/seal/stats'));       // 统计接口
// 项目用印
app.use('/api/projects/:projectId/seal', require('./routes/seal/project-seal'));
// 中心用印
app.use('/api/projects/:projectId/sites/:projectSiteId/seal', require('./routes/seal/project-site-seal'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该用印申请下有关联记录，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- **跨域调用：** 调用其他模块API获取关联数据（详见各接口说明）

---

## 5. 统计接口 (stats.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 全局用印统计 |
| GET | /summary | 按状态/类型聚合 |
| GET | /monthly | 月度趋势 |

**GET / 响应：**
```json
{
  "monthly": {
    "total_requests": 28,
    "pending_approval": 5,
    "completed_usage": 23,
    "total_usage_count": 156
  },
  "overdue_return": 3,
  "seal_stats": [
    { "seal_type": "公章", "usage_count": 45, "in_use": 1 },
    { "seal_type": "合同专用章", "usage_count": 32, "in_use": 0 }
  ]
}
```

**GET /monthly?year=2024&month=6 响应：**
```json
{
  "daily": [
    { "date": "2024-06-01", "requests": 2, "completed": 2 },
    { "date": "2024-06-02", "requests": 1, "completed": 1 },
    ...
  ]
}
```

---

## 6. 印章登记 CRUD (registry.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?seal_type=&status=&keyword=&page=&size=` |
| GET | /:sealId | 详情 |
| GET | /:sealId/usage-history | 使用历史 |
| POST | / | 新增印章 |
| PUT | /:sealId | 编辑 |
| PUT | /:sealId/status | 变更状态 |
| PUT | /:sealId/holder | 更新持有人 |
| DELETE | /:sealId | 删除（仅RETIRED状态可删） |

**GET / 响应：**
```json
{
  "total": 5,
  "list": [{
    "seal_id": "uuid",
    "seal_no": "YZ-2024-001",
    "seal_type": "公章",
    "seal_name": "公司公章",
    "keeping_department": "综合管理部",
    "keeper_name": "赵印章",
    "seal_status": "AVAILABLE",
    "effective_date": "2024-01-01"
  }]
}
```

**GET /:sealId 响应：**
```json
{
  "seal_id": "uuid",
  "seal_no": "YZ-2024-001",
  "seal_type": "公章",
  "seal_name": "公司公章",
  "keeping_department": "综合管理部",
  "keeper_id": "uuid",
  "keeper_name": "赵印章",
  "keeper_phone": "13800138000",
  "effective_date": "2024-01-01",
  "seal_image": "/uploads/seal/YZ-2024-001.png",
  "seal_status": "AVAILABLE",
  "current_holder_id": null,
  "current_holder_name": null,
  "remark": "",
  "usage_stats": {
    "total_usage": 156,
    "this_month": 12,
    "last_usage_at": "2024-06-18 15:30"
  }
}
```

**POST body：**
```json
{
  "seal_no": "YZ-2024-001",
  "seal_type": "公章",
  "seal_name": "公司公章",
  "keeping_department": "综合管理部",
  "keeper_id": "uuid",
  "keeper_phone": "13800138000",
  "effective_date": "2024-01-01",
  "remark": ""
}
```
文件通过 `req.file` 获取seal_image

**PUT /:sealId/holder body：**
```json
{
  "holder_id": "uuid",
  "holder_name": "张经理",
  "action": "borrow" | "return"
}
```

**状态变更逻辑：**
- borrow: seal_status → IN_USE, 更新 current_holder_id/name
- return: seal_status → AVAILABLE, 清空 current_holder_id/name

---

## 7. 用印申请 CRUD (request.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?seal_type=&status=&category=&keyword=&page=&size=&start_date=&end_date=` |
| GET | /:requestId | 详情，含 approvals[] + usages[] + documents[] |
| POST | / | 新增申请 |
| PUT | /:requestId | 编辑（仅PENDING状态可编辑） |
| PUT | /:requestId/withdraw | 撤回申请 |
| PUT | /:requestId/cancel | 取消申请 |
| DELETE | /:requestId | 删除（仅PENDING状态可删） |

**GET / 响应：**
```json
{
  "total": 50,
  "summary": {
    "PENDING": 5,
    "APPROVING": 3,
    "APPROVED": 40,
    "REJECTED": 2
  },
  "list": [{
    "request_id": "uuid",
    "request_no": "YY-202406-00001",
    "request_category": "PROJECT",
    "request_category_display": "项目类",
    "project_id": "uuid",
    "project_name": "PD-001",
    "seal_type": "公章",
    "seal_type_display": "公章",
    "applicant_name": "张经理",
    "usage_purpose": "合同盖章",
    "copy_count": 3,
    "approval_status": "APPROVING",
    "approval_status_display": "审批中",
    "current_node": "法务",
    "created_at": "2024-06-18 10:30"
  }]
}
```

**GET /:requestId 响应：**
```json
{
  "request_id": "uuid",
  "request_no": "YY-202406-00001",
  "request_category": "PROJECT",
  "request_category_display": "项目类",
  "project_id": "uuid",
  "project_name": "PD-001",
  "project_site_id": "uuid",
  "project_site_name": "北京协和医院",
  "applicant_id": "uuid",
  "applicant_name": "张经理",
  "applicant_dept": "研发部",
  "applicant_phone": "13800138000",
  "seal_type": "公章",
  "usage_purpose": "合同盖章",
  "copy_count": 3,
  "document_name": "PD-001项目临床试验合同",
  "document_count": 3,
  "contract_id": "uuid",
  "attachment_paths": ["/uploads/seal/contract.pdf"],
  "approval_flow": [
    { "node": "部门经理", "node_type": "DEPT_MANAGER", "required": true },
    { "node": "法务", "node_type": "LEGAL", "required": true },
    { "node": "总经理", "node_type": "GM", "required": false }
  ],
  "current_step": 2,
  "approval_status": "APPROVING",
  "estimated_amount": 800000,
  "requires_legal": true,
  "requires_gm": true,
  "remark": "",
  "rejection_reason": null,
  "created_at": "2024-06-18 10:30",
  "approvals": [
    {
      "approval_id": "uuid",
      "step": 1,
      "node_name": "部门经理",
      "approver_id": "uuid",
      "approver_name": "李总监",
      "approval_status": "APPROVED",
      "comment": "同意盖章",
      "approved_at": "2024-06-18 14:00"
    },
    {
      "approval_id": "uuid",
      "step": 2,
      "node_name": "法务",
      "approver_id": "uuid",
      "approver_name": "王法务",
      "approval_status": "APPROVING",
      "comment": "",
      "approved_at": null
    }
  ],
  "usages": [
    {
      "usage_id": "uuid",
      "seal_id": "uuid",
      "seal_no": "YZ-2024-001",
      "seal_type": "公章",
      "actual_count": 3,
      "usage_time": "2024-06-18 15:30",
      "sealer_name": "赵印章",
      "recipient_name": "张经理",
      "return_status": "RETURNED",
      "returned_at": "2024-06-20 17:00"
    }
  ],
  "documents": [
    {
      "document_id": "uuid",
      "document_name": "合同.pdf",
      "document_count": 3,
      "tracking_type": "SHIPPED",
      "tracking_no": "SF1234567890",
      "document_status": "SIGNED"
    }
  ]
}
```

**POST body：**
```json
{
  "request_category": "PROJECT",
  "project_id": "uuid",
  "project_site_id": "uuid",
  "seal_type": "公章",
  "usage_purpose": "合同盖章",
  "copy_count": 3,
  "document_name": "PD-001项目临床试验合同",
  "document_count": 3,
  "contract_id": "uuid",
  "estimated_amount": 800000,
  "remark": "",
  "attachment": "file"
}
```

**POST 逻辑（事务）：**
1. 校验 request_category 有效（PROJECT / NON_PROJECT）
2. **项目类校验：** request_category=PROJECT 时 project_id 必填
3. 校验 seal_type 有效
4. 校验申请人存在
5. 校验关联项目/中心存在（如果传了）
6. 生成 request_no（自动编号）
7. **根据 request_category + seal_type + estimated_amount 生成审批流程**
8. INSERT seal_request
9. INSERT seal_approval（生成审批节点）
10. 初始状态为 APPROVING
11. 返回完整对象

**审批流程自动生成规则：**
```javascript
function generateApprovalFlow(requestCategory, sealType, estimatedAmount) {
  const flow = [];
  
  // 项目类：项目经理为首节点
  if (requestCategory === 'PROJECT') {
    flow.push({ node: "项目经理", node_type: "PROJECT_MANAGER", required: true });
  }
  
  // 部门经理（非项目类为首节点，项目类为第二节点）
  flow.push({ node: "部门经理", node_type: "DEPT_MANAGER", required: true });
  
  // 合同盖章必须法务
  if (sealType === '合同专用章' || usagePurpose === '合同盖章') {
    flow.push({ node: "法务", node_type: "LEGAL", required: true });
  }
  
  // 授权委托书必须总经理
  if (usagePurpose === '授权委托书') {
    flow.push({ node: "总经理", node_type: "GM", required: true });
  }
  
  // 大额合同需总经理
  if (estimatedAmount > 500000) {
    if (!flow.find(f => f.node_type === 'GM')) {
      flow.push({ node: "总经理", node_type: "GM", required: true });
    }
  }
  
  return flow;
}
```

---

## 8. 审批记录 (approval.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?request_id=&status=&page=&size=` |
| GET | /:approvalId | 详情 |
| PUT | /:approvalId/approve | 通过审批 |
| PUT | /:approvalId/reject | 驳回审批 |

**当前用户可审批的申请：**
```
GET /api/seal/approvals/pending?approver_id=xxx
```

**PUT /:approvalId/approve body：**
```json
{
  "comment": "同意盖章"
}
```

**PUT /:approvalId/reject body：**
```json
{
  "comment": "文件内容有误，请修改后再提交"
}
```

**审批逻辑（事务）：**
1. 校验 approval_id 存在且状态为 PENDING
2. 校验审批人是当前登录人
3. 校验 request 当前节点匹配
4. UPDATE seal_approval SET status + comment + approved_at
5. 如果 APPROVED：
   - 查找下一个节点
   - 如果有下一个节点：UPDATE seal_request SET current_step += 1
   - 如果没有下一个节点：UPDATE seal_request SET approval_status='APPROVED', approval_status='APPROVED'
6. 如果 REJECTED：
   - UPDATE seal_request SET approval_status='REJECTED', rejection_reason=comment

---

## 9. 用印记录 (usage.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?request_id=&seal_id=&status=&page=&size=` |
| GET | /:usageId | 详情 |
| POST | / | 新增用印记录（执行用印） |
| PUT | /:usageId/return | 归还 |
| DELETE | /:usageId | 删除（需校验） |

**POST body（执行用印）：**
```json
{
  "request_id": "uuid",
  "seal_id": "uuid",
  "actual_count": 3,
  "usage_time": "2024-06-18 15:30",
  "sealer_id": "uuid",
  "recipient_name": "张经理",
  "recipient_phone": "13800138000",
  "recipient_time": "2024-06-18 15:30",
  "need_return": true,
  "return_deadline": "2024-06-21",
  "remark": ""
}
```

**POST 逻辑（事务）：**
1. 校验 request_id 存在且 approval_status='APPROVED'
2. 校验 seal_id 存在且 seal_status='AVAILABLE'
3. 校验 actual_count ≤ request.copy_count
4. INSERT seal_usage_log
5. UPDATE seal_registry SET seal_status='IN_USE', current_holder_id/name
6. UPDATE seal_request SET approval_status='USED'
7. 返回完整对象

**PUT /:usageId/return body：**
```json
{
  "returner_id": "uuid",
  "returner_name": "张经理",
  "returned_at": "2024-06-20 17:00",
  "is_overdue": false,
  "archive_no": "GD-2024-00001",
  "is_archived": true,
  "remark": ""
}
```

**归还逻辑（事务）：**
1. 校验 usage_id 存在且 return_status='PENDING'
2. 计算是否逾期
3. UPDATE seal_usage_log SET return_* 字段
4. UPDATE seal_registry SET seal_status='AVAILABLE', 清空 holder
5. 返回完整对象

---

## 10. 文件追踪 (document.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?request_id=&status=&page=&size=` |
| GET | /:documentId | 详情 |
| POST | / | 新增文件追踪记录 |
| PUT | /:documentId/ship | 登记寄出 |
| PUT | /:documentId/sign | 登记签收 |
| PUT | /:documentId/archive | 登记归档 |
| DELETE | /:documentId | 删除 |

**POST body：**
```json
{
  "request_id": "uuid",
  "usage_id": "uuid",
  "document_name": "合同.pdf",
  "document_count": 3,
  "tracking_type": "SELF_PICKUP"
}
```

**PUT /:documentId/ship body：**
```json
{
  "shipped_count": 2,
  "recipient_name": "王经理",
  "recipient_address": "北京市朝阳区xxx",
  "courier_company": "顺丰速运",
  "tracking_no": "SF1234567890",
  "shipped_at": "2024-06-18 16:00",
  "remark": ""
}
```

**PUT /:documentId/sign body：**
```json
{
  "signed_count": 2,
  "signed_by": "王经理",
  "signed_at": "2024-06-20 10:00",
  "sign_remark": "外包装完好"
}
```

**PUT /:documentId/archive body：**
```json
{
  "archived_count": 2,
  "archive_no": "GD-2024-00001",
  "archived_at": "2024-06-20 11:00",
  "remark": ""
}
```

---

## 11. 项目用印 (project-seal.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?seal_type=&status=&page=&size=` |
| GET | /:requestId | 详情 |
| POST | / | 新增项目用印申请 |
| PUT | /:requestId | 编辑 |
| PUT | /:requestId/withdraw | 撤回 |
| PUT | /:requestId/cancel | 取消 |
| DELETE | /:requestId | 删除 |

**GET / 响应：** 同 /api/seal/requests，但自动携带 projectId 筛选

**POST body：** 同 /api/seal/requests，自动关联 projectId

---

## 12. 中心用印 (project-site-seal.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心用印概览（轻量） |

**GET / 响应：**
```json
{
  "project_site_id": "uuid",
  "total_usage": 5,
  "this_month": 1,
  "recent_usages": [
    {
      "request_id": "uuid",
      "request_no": "YY-202406-00001",
      "seal_type": "公章",
      "usage_purpose": "合同盖章",
      "approval_status": "APPROVED",
      "created_at": "2024-06-18 10:30"
    }
  ]
}
```

---

## 13. 跨域API调用示例

### 13.1 调用HR模块获取人员列表
```javascript
// 在 request.js 中
const memberDb = require('../hr/db');

// 查询部门经理
const managers = memberDb.prepare(`
  SELECT member_id, name, department, position
  FROM member
  WHERE position LIKE '%经理%' AND member_status = 'ACTIVE'
`).all();
```

### 13.2 调用项目模块获取项目信息
```javascript
// 在 request.js 中
const projectDb = require('../project/db');

// 获取项目名称
const project = projectDb.prepare(`
  SELECT project_id, project_name, project_code
  FROM project
  WHERE project_id = ?
`).get(projectId);
```

### 13.3 调用合同模块获取合同信息
```javascript
// 在 request.js 中
const contractDb = require('../contract/db');

// 获取关联合同
const contract = contractDb.prepare(`
  SELECT contract_id, contract_no, contract_amount
  FROM contract
  WHERE contract_id = ?
`).get(contractId);
```

---

## 14. 自动编号实现

```javascript
// 生成用印申请编号 YY-YYYYMM-NNNNN
function generateRequestNo(db) {
  const yearMonth = new Date().toISOString().slice(0, 7).replace('-', '');
  const prefix = `YY-${yearMonth}-`;
  
  const last = db.prepare(`
    SELECT request_no FROM seal_request
    WHERE request_no LIKE ?
    ORDER BY created_at DESC LIMIT 1
  `).get(`${prefix}%`);
  
  let seq = 1;
  if (last) {
    seq = parseInt(last.request_no.split('-')[2]) + 1;
  }
  
  return `${prefix}${String(seq).padStart(5, '0')}`;
}

// 生成印章编号 YZ-YYYY-NNN
function generateSealNo(db) {
  const year = new Date().getFullYear();
  const prefix = `YZ-${year}-`;
  
  const last = db.prepare(`
    SELECT seal_no FROM seal_registry
    WHERE seal_no LIKE ?
    ORDER BY created_at DESC LIMIT 1
  `).get(`${prefix}%`);
  
  let seq = 1;
  if (last) {
    seq = parseInt(last.seal_no.split('-')[2]) + 1;
  }
  
  return `${prefix}${String(seq).padStart(3, '0')}`;
}
```

---

## 15. 第一版不做

- ❌ 用印审批流自定义配置（固定流程先跑）
- ❌ 电子印章/电子签名集成
- ❌ 用印提醒自动推送（邮件/短信）
- ❌ 用印数据导出Excel
- ❌ 印章使用统计图表
- ❌ 用印审计报告自动生成
- ❌ 移动端用印审批

---

*文档版本 V1.0 | 2026-06-18*
