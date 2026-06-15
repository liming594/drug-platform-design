# Sponsor Module API路由规范 (对象线4号: Sponsor / ProjectSponsor)

> 后端: Node.js + Express
> 数据库: sponsor.db (better-sqlite3, WAL模式)
> **注意：合同/收款/发票API已移至独立合同对象线，本模块仅保留跳转说明**

---

## 1. 文件结构

```
server/routes/
├── sponsor/
│   ├── db.js                     ← sponsor.db 连接 + 建表
│   ├── master.js                 ← 申办方主档 CRUD
│   ├── contact.js                ← 申办方联系人 CRUD
│   ├── qualification.js          ← 申办方资质文件 CRUD
│   ├── invoice-info.js           ← 申办方开票信息 CRUD
│   └── project-sponsor.js        ← 项目申办方关联 CRUD
│
└── contract/                      ← 合同对象线（独立模块）
    ├── contract.js               ← 合同主档 CRUD
    ├── collection.js             ← 收款记录 CRUD
    └── invoice.js                ← 开票记录 CRUD
```

**说明：**
- contract.js、collection.js、invoice.js 已移至合同对象线目录
- sponsor 模块通过 HTTP 调用合同对象线 API 获取数据

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'sponsor.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-sponsor-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
-- sponsor_master
CREATE TABLE IF NOT EXISTS sponsor_master (...);
-- sponsor_contact
CREATE TABLE IF NOT EXISTS sponsor_contact (...);
-- sponsor_qualification
CREATE TABLE IF NOT EXISTS sponsor_qualification (...);
-- sponsor_invoice_info
CREATE TABLE IF NOT EXISTS sponsor_invoice_info (...);
-- project_sponsor
CREATE TABLE IF NOT EXISTS project_sponsor (...);
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// Sponsor模块（保留）
app.use('/api/sponsor/masters', require('./routes/sponsor/master'));
app.use('/api/sponsor/contacts', require('./routes/sponsor/contact'));
app.use('/api/sponsor/qualifications', require('./routes/sponsor/qualification'));
app.use('/api/sponsor/invoice-info', require('./routes/sponsor/invoice-info'));
app.use('/api/projects/:projectId/sponsor', require('./routes/sponsor/project-sponsor'));

// 合同对象线（独立路由）
app.use('/api/contracts', require('./routes/contract/contract'));
app.use('/api/contracts/:contractId/collections', require('./routes/contract/collection'));
app.use('/api/contracts/:contractId/invoices', require('./routes/contract/invoice'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该申办方下有关联项目，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`

---

## 5. 申办方主档 CRUD (master.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?status=&type=&vip_level=&keyword=&page=&size=` |
| GET | /:sponsorId | 详情，含 contacts[] + qualifications[] + invoice_info + project_summary |
| POST | / | 新增 |
| PUT | /:sponsorId | 编辑 |
| PUT | /:sponsorId/status | 变更状态，body: `{ sponsor_status: "ACTIVE"/"INACTIVE"/"BLACKLISTED" }` |
| DELETE | /:sponsorId | 删除，校验: 无project_sponsor引用 |

**GET / 响应：**
```json
{
  "total": 15,
  "list": [{
    "sponsor_id": "uuid",
    "sponsor_name": "恒瑞医药股份有限公司",
    "short_name": "恒瑞",
    "sponsor_type": "LARGE_PHARMA",
    "sponsor_status": "ACTIVE",
    "is_listed": 1,
    "stock_code": "600276",
    "vip_level": "VIP",
    "rating": 4.5,
    "project_count": 5,
    "contract_count": 8,
    "total_contract_amount": 28000000,
    "total_collection": 18000000
  }]
}
```

**GET /:sponsorId 响应：**
```json
{
  "sponsor_id": "uuid",
  "sponsor_name": "恒瑞医药股份有限公司",
  "short_name": "恒瑞",
  "credit_code": "91320000xxx",
  "legal_person": "张三",
  "registered_address": "上海市浦东新区xxx",
  "office_address": "上海市浦东新区xxx",
  "contact_phone": "021-xxx",
  "contact_email": "contact@hengrui.cn",
  "website": "www.hengrui.cn",
  "sponsor_type": "LARGE_PHARMA",
  "is_listed": 1,
  "stock_code": "600276",
  "vip_level": "VIP",
  "rating": 4.5,
  "drug_pipeline": "PD-1抑制剂、ADC药物...",
  "sponsor_status": "ACTIVE",
  "project_count": 5,
  "contract_count": 8,
  "total_contract_amount": 28000000,
  "total_collection": 18000000,
  "contacts": [
    { "contact_id": "uuid", "contact_name": "王经理", "department": "BD部", "position": "总监", "mobile": "139...", "email": "wang@hengrui.cn", "is_primary": 1 }
  ],
  "qualifications": [
    { "qualification_id": "uuid", "doc_type": "GCP_CERT", "doc_name": "GCP证书.pdf", "expiry_date": "2027-01-14", "cert_status": "VALID" }
  ],
  "invoice_info": {
    "info_id": "uuid",
    "invoice_title": "恒瑞医药股份有限公司",
    "tax_number": "91320000xxx",
    "bank_name": "工商银行上海分行",
    "bank_account": "62xxxxxx",
    "address": "上海市浦东新区xxx",
    "phone": "021-xxx"
  },
  "project_summary": {
    "total": 5,
    "active": 2,
    "closed": 3,
    "contract_count": 8,
    "total_contract_amount": 28000000,
    "total_collection": 18000000
  }
}
```

**POST body：**
```json
{
  "sponsor_name": "恒瑞医药股份有限公司",
  "short_name": "恒瑞",
  "credit_code": "91320000xxx",
  "legal_person": "张三",
  "registered_address": "上海市浦东新区xxx",
  "office_address": "上海市浦东新区xxx",
  "contact_phone": "021-xxx",
  "contact_email": "contact@hengrui.cn",
  "website": "www.hengrui.cn",
  "sponsor_type": "LARGE_PHARMA",
  "is_listed": 1,
  "stock_code": "600276",
  "vip_level": "VIP",
  "rating": 4.5,
  "drug_pipeline": "PD-1抑制剂、ADC药物..."
}
```

**PUT /:sponsorId/status body：**
```json
{
  "sponsor_status": "INACTIVE",
  "change_reason": "长期无合作"
}
```

---

## 6. 申办方联系人 CRUD (contact.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?sponsor_id=xxx` |
| POST | / | 新增 |
| PUT | /:contactId | 编辑 |
| DELETE | /:contactId | 删除 |

**POST body：**
```json
{
  "sponsor_id": "uuid",
  "contact_name": "王经理",
  "department": "BD部",
  "position": "总监",
  "mobile": "13900139000",
  "email": "wang@hengrui.cn",
  "is_primary": 1
}
```

**DELETE 逻辑：**
- 如果删除的是主联系人，自动将其他联系人设为主联系人

---

## 7. 申办方资质文件 CRUD (qualification.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?sponsor_id=xxx` |
| POST | / | 上传资质（文件上传） |
| PUT | /:qualificationId | 编辑信息 |
| DELETE | /:qualificationId | 删除 |

**POST body（multipart/form-data）：**
```json
{
  "sponsor_id": "uuid",
  "doc_type": "GCP_CERT",
  "expiry_date": "2027-01-14"
}
```
文件通过 `req.file` 获取，保存到 `/uploads/sponsor/qualifications/`

**资质状态自动更新：**
- expiry_date 为空 → cert_status = 'VALID'
- expiry_date ≤ 30天后 → cert_status = 'EXPIRING'
- expiry_date < 今天 → cert_status = 'EXPIRED'

---

## 8. 申办方开票信息 CRUD (invoice-info.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 获取，`?sponsor_id=xxx` |
| POST | / | 新增/设置开票信息 |
| PUT | /:infoId | 编辑 |
| DELETE | /:infoId | 删除 |

**POST body：**
```json
{
  "sponsor_id": "uuid",
  "invoice_title": "恒瑞医药股份有限公司",
  "tax_number": "91320000xxx",
  "bank_name": "工商银行上海分行",
  "bank_account": "62xxxxxx",
  "address": "上海市浦东新区xxx",
  "phone": "021-xxx"
}
```

**POST 逻辑：**
- 使用 `INSERT OR REPLACE` 语法，保证一个申办方只有一个开票信息

---

## 9. 项目申办方关联 CRUD (project-sponsor.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 获取项目申办方信息，`?project_id=xxx` |
| POST | / | 新增/关联项目申办方 |
| PUT | /:projectSponsorId | 编辑（评分等） |
| PUT | /:projectSponsorId/status | 变更状态 |
| DELETE | /:projectSponsorId | 删除（校验无关联合同） |

**GET / 响应（单项目）：**
```json
{
  "project_sponsor_id": "uuid",
  "project_id": "uuid",
  "sponsor_id": "uuid",
  "sponsor_name": "恒瑞医药股份有限公司",
  "short_name": "恒瑞",
  "sponsor_type": "LARGE_PHARMA",
  "vip_level": "VIP",
  "is_listed": 1,
  "stock_code": "600276",
  "rating": 4.5,
  "project_sponsor_status": "ACTIVE",
  "contract_score": 4.5,
  "payment_score": 4.0,
  "cooperation_score": 4.5,
  "overall_score": 4.3,
  "contract_count": 2,
  "total_contract_amount": 12000000,
  "total_collection": 8000000,
  "total_invoice": 8500000,
  "primary_contact": {
    "contact_name": "王经理",
    "department": "BD部",
    "position": "总监",
    "mobile": "139...",
    "email": "wang@hengrui.cn"
  },
  "contract_api_docs": "/api/contracts?project_id=xxx&sponsor_id=xxx"
}
```

**POST body：**
```json
{
  "sponsor_id": "uuid"
}
```

**POST 逻辑：**
1. 校验项目未有关联的申办方
2. INSERT project_sponsor
3. UPDATE sponsor_master.project_count += 1
4. 返回完整对象（含申办方信息）

**DELETE 校验：**
- 项目下有合同（调用合同对象线API检查）→ 返回409

---

## 10. 合同相关API说明

**合同/收款/发票的完整API已移至合同对象线，sponsor模块不再实现。**

### 10.1 合同API（合同对象线）

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/contracts | 列表，`?project_id=&sponsor_id=&status=` |
| GET | /api/contracts/:contractId | 详情 |
| POST | /api/contracts | 新增合同 |
| PUT | /api/contracts/:contractId | 编辑 |
| DELETE | /api/contracts/:contractId | 删除 |

### 10.2 收款API（合同对象线）

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/contracts/:contractId/collections | 收款列表 |
| POST | /api/contracts/:contractId/collections | 新增收款 |
| PUT | /api/contracts/:contractId/collections/:id | 编辑 |

### 10.3 开票API（合同对象线）

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/contracts/:contractId/invoices | 发票列表 |
| POST | /api/contracts/:contractId/invoices | 新增开票 |
| PUT | /api/contracts/:contractId/invoices/:id | 编辑 |

### 10.4 Sponsor模块中的合同入口

在 sponsor 模块的 project-sponsor.js 中，提供合同跳转信息：

```javascript
// GET /api/projects/:projectId/sponsor 时返回合同入口
{
  // ... sponsor info ...
  "contracts_summary": {
    "total_count": 2,
    "total_amount": 12000000,
    "collection_amount": 8000000,
    "collection_rate": 66.7
  },
  "contract_module_url": "/contracts?project_id=xxx&sponsor_id=xxx"
}
```

前端根据 `contract_module_url` 或通过链接按钮跳转至合同管理模块。

---

## 11. 调用合同对象线API

### 11.1 获取项目合同汇总

```javascript
// 在 project-sponsor.js 中调用合同对象线获取汇总
const contractApiBase = process.env.CONTRACT_API_BASE || 'http://localhost:3001';

async function getContractSummary(projectId, sponsorId) {
  const response = await fetch(
    `${contractApiBase}/api/contracts/summary?project_id=${projectId}&sponsor_id=${sponsorId}`
  );
  return response.json();
}
```

### 11.2 同步统计字段

合同对象线在合同创建/修改/删除后，通过事件或直接调用更新 sponsor 库的统计字段：

```javascript
// 合同对象线中 - 合同创建后同步
async function onContractCreated(contract) {
  // 更新 sponsor_master
  await sponsorDb.prepare(`
    UPDATE sponsor_master 
    SET contract_count = contract_count + 1,
        total_contract_amount = total_contract_amount + ?,
        updated_at = ?
    WHERE sponsor_id = ?
  `).run(contract.contract_amount, new Date().toISOString(), contract.sponsor_id);

  // 更新 project_sponsor
  await sponsorDb.prepare(`
    UPDATE project_sponsor
    SET contract_count = contract_count + 1,
        total_contract_amount = total_contract_amount + ?,
        updated_at = ?
    WHERE project_id = ? AND sponsor_id = ?
  `).run(contract.contract_amount, new Date().toISOString(), contract.project_id, contract.sponsor_id);
}
```

---

## 12. 第一版不做

- ❌ 申办方药品管线详情管理
- ❌ 申办方信用评估
- ❌ 发票OCR识别
- ❌ 批量开票
- ❌ 自动资质校验提醒
- ❌ 申办方评级自动升降级规则
- ❌ 合同/收款/开票的完整CRUD（由合同对象线提供）

---

*文档版本 V2.0 | 2026-06-15*
*修改说明：删除 contract.js/collection.js/invoice.js，合同API由合同对象线提供*
