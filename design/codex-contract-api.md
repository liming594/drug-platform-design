# Contract Module API路由规范 (对象线17号: Contract / 合同管理)

> 后端: Node.js + Express
> 数据库: contract.db (better-sqlite3, WAL模式)

---

## 1. 文件结构

```
server/routes/
├── contract/
│   ├── db.js                   ← contract.db 连接 + 建表
│   ├── contract.js             ← 合同主档 CRUD
│   ├── payment.js              ← 收款计划 CRUD
│   ├── collection.js           ← 收款记录 CRUD
│   ├── invoice.js             ← 发票记录 CRUD
│   ├── change.js              ← 合同变更 CRUD
│   ├── document.js            ← 文档管理
│   └── log.js                 ← 操作日志
├── project-contract.js         ← L2-项目合同管理
├── sponsor-contract.js          ← L3-申办方合同(只读)
├── smo-contract.js              ← L3-SMO合同(只读)
├── site-contract.js             ← L3-中心合同(只读)
└── partner-contract.js          ← L3-合作方合同(只读)
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'contract.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-contract-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
-- 完整建表脚本见 codex-contract-sql.md
CREATE TABLE IF NOT EXISTS contract (...);
CREATE TABLE IF NOT EXISTS contract_payment (...);
CREATE TABLE IF NOT EXISTS contract_collection (...);
CREATE TABLE IF NOT EXISTS contract_invoice (...);
CREATE TABLE IF NOT EXISTS contract_change (...);
CREATE TABLE IF NOT EXISTS contract_document (...);
CREATE TABLE IF NOT EXISTS contract_log (...);
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// Contract模块
app.use('/api/contract/contracts', require('./routes/contract/contract'));
app.use('/api/contract/payments', require('./routes/contract/payment'));
app.use('/api/contract/collections', require('./routes/contract/collection'));
app.use('/api/contract/invoices', require('./routes/contract/invoice'));
app.use('/api/contract/changes', require('./routes/contract/change'));
app.use('/api/contract/documents', require('./routes/contract/document'));
app.use('/api/contract/logs', require('./routes/contract/log'));
app.use('/api/contract/dashboard', require('./routes/contract/dashboard'));

// 项目级
app.use('/api/projects/:projectId/contracts', require('./routes/project-contract'));
// 申办方级
app.use('/api/sponsor/:sponsorId/contracts', require('./routes/sponsor-contract'));
// SMO级
app.use('/api/smo/:smoId/contracts', require('./routes/smo-contract'));
// 中心级
app.use('/api/projects/:projectId/sites/:projectSiteId/contracts', require('./routes/site-contract'));
// 合作方级
app.use('/api/partner/:partnerId/contracts', require('./routes/partner-contract'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该合同下有关联收款记录，无法删除" }`
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
| GET | / | 获取合同概览统计 |

**GET / 响应：**
```json
{
  "summary": {
    "total": 45,
    "draft": 3,
    "pending_approval": 2,
    "pending_sign": 3,
    "active": 32,
    "changing": 1,
    "expired": 2,
    "terminated": 2
  },
  "financial": {
    "total_amount": 18400000,
    "collected_amount": 15600000,
    "pending_amount": 2800000,
    "invoiced_amount": 12000000,
    "collection_rate": 84.78
  },
  "expiring_soon": {
    "this_month": 5,
    "contracts": [
      { "contract_id": "uuid", "contract_no": "HT-2024-00015", "contract_name": "...", "expiry_date": "2024-07-15" }
    ]
  }
}
```

**数据来源：**
- 统计各状态合同数量
- 财务数据 = SUM(contract.contract_amount / collected_amount / pending_amount)
- 本月到期 = expiry_date 在本月

---

## 6. 合同主档 CRUD (contract.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_id=&party_type=&party_id=&contract_type=&status=&keyword=&page=&size=` |
| GET | /:contractId | 详情，含 payments[] + collections[] + invoices[] + changes[] + documents[] |
| POST | / | 新增合同 |
| PUT | /:contractId | 编辑 |
| PUT | /:contractId/status | 变更状态 |
| DELETE | /:contractId | 删除（仅DRAFT状态可删） |

**GET / 列表响应：**
```json
{
  "total": 45,
  "page": 1,
  "size": 20,
  "list": [{
    "contract_id": "uuid",
    "contract_no": "HT-2024-00001",
    "contract_name": "CRO服务合同",
    "contract_type": "MAIN",
    "project_id": "uuid",
    "project_name": "PD-001 肿瘤药物试验",
    "party_type": "SPONSOR",
    "party_id": "uuid",
    "party_name": "恒瑞医药",
    "contract_amount": 5000000,
    "collected_amount": 3000000,
    "pending_amount": 2000000,
    "sign_date": "2024-05-15",
    "effective_date": "2024-05-15",
    "expiry_date": "2025-05-14",
    "contract_status": "ACTIVE",
    "payment_count": 3,
    "payment_complete_count": 1,
    "created_at": "2024-05-15T10:00:00Z"
  }]
}
```

**GET /:contractId 详情响应：**
```json
{
  "contract_id": "uuid",
  "contract_no": "HT-2024-00001",
  "contract_name": "CRO服务合同",
  "contract_type": "MAIN",
  "project_id": "uuid",
  "project_name": "PD-001 肿瘤药物试验",
  "party_type": "SPONSOR",
  "party_id": "uuid",
  "party_name": "恒瑞医药",
  "contract_amount": 5000000,
  "collected_amount": 3000000,
  "pending_amount": 2000000,
  "invoiced_amount": 2000000,
  "sign_date": "2024-05-15",
  "effective_date": "2024-05-15",
  "expiry_date": "2025-05-14",
  "contract_status": "ACTIVE",
  "parent_contract_id": null,
  "related_files": [
    { "doc_id": "uuid", "doc_name": "合同扫描件.pdf", "doc_type": "CONTRACT_SCAN" }
  ],
  "payment_count": 3,
  "payment_complete_count": 1,
  "payments": [
    {
      "payment_id": "uuid",
      "payment_no": "SKP-2024-00001",
      "payment_stage": "第1期",
      "payment_amount": 2000000,
      "payment_date": "2024-06-15",
      "payment_status": "RECEIVED",
      "collection_id": "uuid"
    }
  ],
  "collections": [
    {
      "collection_id": "uuid",
      "collection_no": "SK-2024-00001",
      "collection_amount": 2000000,
      "collection_date": "2024-06-16",
      "collection_method": "BANK_TRANSFER"
    }
  ],
  "invoices": [
    {
      "invoice_id": "uuid",
      "invoice_no": "FP-2024-00001",
      "invoice_type": "VAT_SPECIAL",
      "invoice_amount": 2000000,
      "invoice_date": "2024-06-20",
      "invoice_status": "ISSUED"
    }
  ],
  "changes": [
    {
      "change_id": "uuid",
      "change_no": "BG-2024-00001",
      "change_type": "AMOUNT",
      "old_value": "{\"contract_amount\": 5000000}",
      "new_value": "{\"contract_amount\": 5500000}",
      "reason": "项目范围扩大",
      "approval_status": "APPROVED"
    }
  ],
  "documents": [
    { "doc_id": "uuid", "doc_name": "合同扫描件.pdf", "doc_type": "CONTRACT_SCAN" }
  ],
  "logs": [
    { "log_id": "uuid", "action": "CREATE", "actor_name": "张三", "created_at": "..." }
  ],
  "created_at": "2024-05-15T10:00:00Z",
  "updated_at": "2024-05-15T10:00:00Z",
  "created_by": "uuid"
}
```

**POST body：**
```json
{
  "contract_name": "CRO服务合同",
  "contract_type": "MAIN",
  "project_id": "uuid",
  "party_type": "SPONSOR",
  "party_id": "uuid",
  "contract_amount": 5000000,
  "sign_date": "2024-05-15",
  "effective_date": "2024-05-15",
  "expiry_date": "2025-05-14",
  "payment_schedule": [
    { "payment_stage": "第1期", "payment_amount": 2000000, "payment_date": "2024-06-15" },
    { "payment_stage": "第2期", "payment_amount": 1500000, "payment_date": "2024-09-15" },
    { "payment_stage": "第3期", "payment_amount": 1500000, "payment_date": "2024-12-15" }
  ],
  "remark": ""
}
```

**PUT /:contractId/status body：**
```json
{
  "contract_status": "ACTIVE",
  "remark": ""
}
```

**状态变更规则：**
- DRAFT → PENDING_APPROVAL：提交审批
- PENDING_APPROVAL → PENDING_SIGN：审批通过
- PENDING_SIGN → ACTIVE：签署完成
- ACTIVE → CHANGING：发起变更
- CHANGING → ACTIVE：变更审批通过
- ACTIVE → TERMINATED：提前终止

---

## 7. 收款计划 CRUD (payment.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?contract_id=&status=` |
| POST | / | 新增收款计划 |
| PUT | /:paymentId | 编辑 |
| DELETE | /:paymentId | 删除（仅PLANNED状态可删） |

**POST body：**
```json
{
  "contract_id": "uuid",
  "payment_stage": "第4期",
  "payment_amount": 500000,
  "payment_date": "2025-03-15",
  "remark": ""
}
```

---

## 8. 收款记录 CRUD (collection.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?contract_id=&payment_id=&start_date=&end_date=&page=&size=` |
| GET | /:collectionId | 详情 |
| POST | / | 收款确认 |
| PUT | /:collectionId | 编辑 |
| DELETE | /:collectionId | 删除（仅当天可删） |

**GET / 列表响应：**
```json
{
  "total": 25,
  "list": [{
    "collection_id": "uuid",
    "collection_no": "SK-2024-00001",
    "contract_id": "uuid",
    "contract_no": "HT-2024-00001",
    "contract_name": "CRO服务合同",
    "payment_id": "uuid",
    "payment_stage": "第1期",
    "collection_amount": 2000000,
    "collection_date": "2024-06-16",
    "collection_method": "BANK_TRANSFER",
    "bank_name": "工商银行",
    "bank_account": "62xxxxxx",
    "created_at": "2024-06-16T10:00:00Z"
  }]
}
```

**POST body：**
```json
{
  "contract_id": "uuid",
  "payment_id": "uuid",
  "collection_amount": 1500000,
  "collection_date": "2024-09-20",
  "collection_method": "BANK_TRANSFER",
  "bank_name": "工商银行上海分行",
  "bank_account": "62xxxxxx",
  "counterparty_account": "恒瑞医药股份有限公司",
  "receipt_file": "(文件)",
  "remark": ""
}
```

**收款确认后的级联逻辑：**
1. 更新 contract.collected_amount += collection_amount
2. 更新 contract.pending_amount = contract_amount - collected_amount
3. 更新 contract_payment.payment_status → RECEIVED
4. 更新 contract_payment.collection_id → new collection_id
5. 发送站内通知给项目经理

---

## 9. 发票记录 CRUD (invoice.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?contract_id=&status=&invoice_type=&page=&size=` |
| GET | /:invoiceId | 详情 |
| POST | / | 开票申请 |
| PUT | /:invoiceId | 编辑 |
| PUT | /:invoiceId/status | 变更状态 |
| PUT | /:invoiceId/cancel | 作废发票 |
| DELETE | /:invoiceId | 删除（仅PENDING状态可删） |

**GET / 列表响应：**
```json
{
  "total": 30,
  "list": [{
    "invoice_id": "uuid",
    "invoice_no": "FP-2024-00001",
    "contract_id": "uuid",
    "contract_no": "HT-2024-00001",
    "contract_name": "CRO服务合同",
    "buyer_name": "恒瑞医药",
    "invoice_type": "VAT_SPECIAL",
    "invoice_amount": 2000000,
    "invoice_date": "2024-06-20",
    "invoice_status": "ISSUED",
    "created_at": "2024-06-18T10:00:00Z"
  }]
}
```

**POST body：**
```json
{
  "contract_id": "uuid",
  "invoice_type": "VAT_SPECIAL",
  "invoice_amount": 1500000,
  "invoice_date": "2024-09-25",
  "buyer_name": "恒瑞医药股份有限公司",
  "buyer_tax_number": "91320000xxx",
  "buyer_bank": "工商银行上海分行",
  "buyer_account": "62xxxxxx",
  "buyer_address": "021-xxx",
  "seller_name": "我方公司名称",
  "seller_tax_number": "91310000xxx",
  "seller_bank": "招商银行",
  "seller_account": "00xxxxxx",
  "remark": ""
}
```

**PUT /:invoiceId/status body（审批/开具）：**
```json
{
  "invoice_status": "ISSUED",
  "remark": ""
}
```

**PUT /:invoiceId/cancel body（作废）：**
```json
{
  "cancel_reason": "发票信息错误，需重新开具"
}
```

**作废逻辑：**
1. 原发票 invoice_status → CANCELLED
2. 原发票 cancelled_invoice_id → null
3. 创建新发票（复制原发票信息，invoice_status = PENDING）

---

## 10. 合同变更 CRUD (change.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?contract_id=` |
| POST | / | 新增变更 |
| PUT | /:changeId/approve | 审批变更 |
| PUT | /:changeId/reject | 驳回变更 |

**POST body：**
```json
{
  "contract_id": "uuid",
  "change_type": "AMOUNT",
  "old_value": { "contract_amount": 5000000 },
  "change_value": { "contract_amount": 5500000 },
  "new_value": { "contract_amount": 5500000 },
  "reason": "项目范围扩大，增加中心3个",
  "remark": ""
}
```

**PUT /:changeId/approve body（审批通过）：**
```json
{
  "approval_comment": "同意变更",
  "remark": ""
}
```

**审批通过后的级联逻辑：**
1. 更新 contract.contract_amount → new_value.contract_amount
2. 更新 contract.contract_status → ACTIVE（从CHANGING恢复）
3. contract_change.approval_status → APPROVED

---

## 11. 文档管理 (document.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 文档列表，`?contract_id=&doc_type=` |
| POST | / | 上传文档 |
| PUT | /:docId | 编辑文档信息 |
| DELETE | /:docId | 删除文档 |

**POST body（multipart/form-data）：**
```
contract_id: uuid
doc_type: CONTRACT_SCAN
file: (文件)
remark: (可选)
```

**文件存储路径：**
```
/uploads/contract/
  ├── {year}/
  │   ├── {contract_no}/
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
    "entity_type": "CONTRACT",
    "entity_id": "uuid",
    "action": "STATUS_CHANGE",
    "actor_id": "uuid",
    "actor_name": "张三",
    "old_value": "{\"contract_status\": \"DRAFT\"}",
    "new_value": "{\"contract_status\": \"PENDING_APPROVAL\"}",
    "change_summary": "合同状态变更为待审批",
    "created_at": "2024-05-15T10:00:00Z"
  }]
}
```

---

## 13. L2 项目合同管理 (project-contract.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 项目合同概览 |
| GET | /contracts | 项目合同列表 |

**GET / 响应：**
```json
{
  "project_id": "uuid",
  "project_name": "PD-001 肿瘤药物试验",
  "summary": {
    "contract_count": 4,
    "total_amount": 12000000,
    "collected_amount": 8000000,
    "pending_amount": 4000000,
    "invoiced_amount": 6000000,
    "collection_rate": 66.67
  },
  "contracts": [
    {
      "contract_id": "uuid",
      "contract_no": "HT-2024-00001",
      "contract_name": "CRO服务合同",
      "contract_type": "MAIN",
      "contract_amount": 5000000,
      "collected_amount": 3000000,
      "contract_status": "ACTIVE",
      "is_parent": true,
      "supplements": [
        { "contract_id": "uuid", "contract_no": "HT-2024-00002", "contract_name": "补充协议-01", "contract_amount": 500000 }
      ]
    }
  ]
}
```

---

## 14. L3 合作方合同（只读）

### 14.1 申办方合同 (sponsor-contract.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 申办方合同概览 |

**GET / 响应：**
```json
{
  "party_type": "SPONSOR",
  "party_id": "uuid",
  "party_name": "恒瑞医药",
  "summary": {
    "contract_count": 2,
    "total_amount": 12000000,
    "collected_amount": 8000000,
    "pending_amount": 4000000,
    "invoiced_amount": 6000000
  },
  "contracts": [
    {
      "contract_id": "uuid",
      "contract_no": "HT-2024-00001",
      "contract_name": "CRO服务合同",
      "contract_type": "MAIN",
      "contract_amount": 5000000,
      "collected_amount": 3000000,
      "contract_status": "ACTIVE"
    }
  ]
}
```

### 14.2 SMO合同 (smo-contract.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | SMO合同概览 |

**GET / 响应：**
```json
{
  "party_type": "SMO",
  "party_id": "uuid",
  "party_name": "泰和诚医学研究有限公司",
  "summary": {
    "contract_count": 1,
    "total_amount": 800000,
    "collected_amount": 500000,
    "pending_amount": 300000
  },
  "contracts": []
}
```

### 14.3 中心合同 (site-contract.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心合同概览 |

**GET / 响应：**
```json
{
  "party_type": "SITE",
  "party_id": "uuid",
  "party_name": "北京协和医院",
  "summary": {
    "contract_count": 1,
    "total_amount": 300000,
    "collected_amount": 150000,
    "pending_amount": 150000
  },
  "contracts": []
}
```

### 14.4 合作方合同 (partner-contract.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 合作方合同概览 |

**GET / 响应：**
```json
{
  "party_type": "PARTNER",
  "party_id": "uuid",
  "party_name": "某某检测中心",
  "summary": {
    "contract_count": 2,
    "total_amount": 500000,
    "collected_amount": 350000,
    "pending_amount": 150000
  },
  "contracts": []
}
```

---

## 15. 跨域API调用示例

### 15.1 调用Project模块获取项目信息
```javascript
// 在 contract.js 中
const projectDb = require('../project/db');  // Project模块db实例

// 获取项目名称
const project = projectDb.prepare(`
  SELECT project_id, project_name FROM project WHERE project_id = ?
`).get(projectId);
```

### 15.2 调用Sponsor模块获取申办方信息
```javascript
// 在 contract.js 中
const sponsorDb = require('../sponsor/db');  // Sponsor模块db实例

// 获取申办方名称
const sponsor = sponsorDb.prepare(`
  SELECT sponsor_id, sponsor_name, short_name FROM sponsor_master WHERE sponsor_id = ?
`).get(sponsorId);
```

### 15.3 调用其他合作方模块
```javascript
// SMO模块
const smoDb = require('../smo/db');

// SITE模块
const projectDb = require('../project/db');

// PARTNER模块
const partnerDb = require('../partner/db');

// 根据party_type动态调用
const partyGetters = {
  'SPONSOR': () => sponsorDb.prepare('SELECT sponsor_name FROM sponsor_master WHERE sponsor_id = ?').get(partyId),
  'SMO': () => smoDb.prepare('SELECT smo_name FROM smo_master WHERE smo_id = ?').get(partyId),
  'SITE': () => projectDb.prepare('SELECT site_name FROM project_site WHERE project_site_id = ?').get(partyId),
  'PARTNER': () => partnerDb.prepare('SELECT partner_name FROM partner_master WHERE partner_id = ?').get(partyId)
};
```

### 15.4 发送站内通知
```javascript
// 通知服务调用
const notifyService = require('../services/notification');

// 收款确认通知
notifyService.send({
  type: 'COLLECTION_CONFIRMED',
  recipient_ids: [pmId],
  title: '合同收款确认',
  content: `合同 ${contract.contract_no} 收到款项 ¥${collectionAmount}，请查收。`
});

// 发票开具通知
notifyService.send({
  type: 'INVOICE_ISSUED',
  recipient_ids: [sponsorContactId],
  title: '发票开具通知',
  content: `发票 ${invoice.invoice_no} 已开具，金额 ¥${invoiceAmount}，请注意查收。`
});
```

---

## 16. 编号自动生成逻辑

```javascript
// 合同编号
function generateContractNo(db) {
  const year = new Date().getFullYear();
  const maxNo = db.prepare(`
    SELECT contract_no FROM contract 
    WHERE contract_no LIKE ? 
    ORDER BY contract_no DESC LIMIT 1
  `).get(`HT-${year}-%`);
  
  const seq = maxNo ? parseInt(maxNo.split('-')[2]) + 1 : 1;
  return `HT-${year}-${String(seq).padStart(5, '0')}`;
}

// 收款编号
function generateCollectionNo(db) {
  const year = new Date().getFullYear();
  const maxNo = db.prepare(`
    SELECT collection_no FROM contract_collection 
    WHERE collection_no LIKE ? 
    ORDER BY collection_no DESC LIMIT 1
  `).get(`SK-${year}-%`);
  
  const seq = maxNo ? parseInt(maxNo.split('-')[2]) + 1 : 1;
  return `SK-${year}-${String(seq).padStart(5, '0')}`;
}

// 发票编号
function generateInvoiceNo(db) {
  const year = new Date().getFullYear();
  const maxNo = db.prepare(`
    SELECT invoice_no FROM contract_invoice 
    WHERE invoice_no LIKE ? 
    ORDER BY invoice_no DESC LIMIT 1
  `).get(`FP-${year}-%`);
  
  const seq = maxNo ? parseInt(maxNo.split('-')[2]) + 1 : 1;
  return `FP-${year}-${String(seq).padStart(5, '0')}`;
}

// 变更编号
function generateChangeNo(db) {
  const year = new Date().getFullYear();
  const maxNo = db.prepare(`
    SELECT change_no FROM contract_change 
    WHERE change_no LIKE ? 
    ORDER BY change_no DESC LIMIT 1
  `).get(`BG-${year}-%`);
  
  const seq = maxNo ? parseInt(maxNo.split('-')[2]) + 1 : 1;
  return `BG-${year}-${String(seq).padStart(5, '0')}`;
}
```

---

## 17. 权限控制说明

| 角色 | 合同 | 收款 | 发票 | 变更 |
|------|------|------|------|------|
| 财务 | 查看 | 确认/编辑 | 申请/作废 | 查看 |
| PM | 全部 | 查看 | 查看 | 发起/审批 |
| Admin | 全部 | 全部 | 全部 | 全部 |
| CRA | 查看 | 查看 | 查看 | 查看 |

**前端鉴权逻辑：**
```javascript
// 根据用户角色过滤可操作数据
function filterByRole(userRole, userId) {
  switch(userRole) {
    case '财务':
      return { canEditContract: false, canConfirmCollection: true, canManageInvoice: true };
    case 'PM':
      return { canEditContract: true, canConfirmCollection: false, canManageInvoice: false, canInitiateChange: true };
    case 'Admin':
      return { canEditContract: true, canConfirmCollection: true, canManageInvoice: true, canInitiateChange: true };
    case 'CRA':
    default:
      return { canEditContract: false, canConfirmCollection: false, canManageInvoice: false, canInitiateChange: false };
  }
}
```

---

## 18. 第一版不做

- ❌ 完整权限系统（第一版前端模拟权限）
- ❌ 合同审批工作流（状态手动切换）
- ❌ 站内通知/邮件提醒
- ❌ 与财务系统对接
- ❌ 移动端适配

---

*文档版本 V1.0 | 2026-06-20*
