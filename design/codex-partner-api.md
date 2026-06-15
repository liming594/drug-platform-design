# 其他合作方模块 API路由规范 (对象线7号: Partner / ProjectPartner)

> 后端: Node.js + Express
> 数据库: partner.db (better-sqlite3, WAL模式)
> 挂载路径: /api/partner/
> 核心逻辑复用SMO模式

---

## 1. 文件结构

```
server/routes/
├── partner/
│   ├── db.js                  ← partner.db 连接 + 建表
│   ├── master.js               ← 合作方主档 CRUD
│   ├── contact.js             ← 合作方联系人 CRUD
│   ├── qualification.js       ← 合作方资质文件 CRUD
│   ├── project-partner.js     ← 项目合作方 CRUD
│   ├── project-partner-site.js ← 项目合作方覆盖中心
│   ├── project-partner-service.js ← 服务记录 (LAB/IRC/DATA/STAT专用)
│   ├── fee.js                  ← 项目合作方费用
│   └── payment.js              ← 项目合作方付款
└── project-site-partner.js     ← 中心合作方信息 (驾驶舱嵌入)
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'partner.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-partner-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
-- partner_master
CREATE TABLE IF NOT EXISTS partner_master (...);
-- partner_contact
CREATE TABLE IF NOT EXISTS partner_contact (...);
-- partner_qualification
CREATE TABLE IF NOT EXISTS partner_qualification (...);
-- project_partner
CREATE TABLE IF NOT EXISTS project_partner (...);
-- project_partner_site
CREATE TABLE IF NOT EXISTS project_partner_site (...);
-- project_partner_service
CREATE TABLE IF NOT EXISTS project_partner_service (...);
-- project_partner_fee
CREATE TABLE IF NOT EXISTS project_partner_fee (...);
-- project_partner_payment
CREATE TABLE IF NOT EXISTS project_partner_payment (...);

-- 索引
CREATE INDEX IF NOT EXISTS idx_pm_type ON partner_master(partner_type);
-- ... 其余索引

-- 触发器
CREATE TRIGGER IF NOT EXISTS trg_partner_master_update ...;
-- ... 其余触发器
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// 其他合作方模块
app.use('/api/partner/masters', require('./routes/partner/master'));
app.use('/api/partner/contacts', require('./routes/partner/contact'));
app.use('/api/partner/qualifications', require('./routes/partner/qualification'));
app.use('/api/partner/sites', require('./routes/partner/partner-site'));  // 中心合作方查询
app.use('/api/partner/services', require('./routes/partner/project-partner-service')); // 服务记录

// 项目合作方
app.use('/api/projects/:projectId/partner', require('./routes/partner/project-partner'));
app.use('/api/projects/:projectId/partner/:projectPartnerId/sites', require('./routes/partner/project-partner-site'));
app.use('/api/projects/:projectId/partner/:projectPartnerId/services', require('./routes/partner/project-partner-service'));
app.use('/api/projects/:projectId/partner/:projectPartnerId/fees', require('./routes/partner/fee'));
app.use('/api/projects/:projectId/partner/:projectPartnerId/payments', require('./routes/partner/payment'));

// 中心驾驶舱嵌入
app.use('/api/projects/:projectId/sites/:projectSiteId/partner', require('./routes/partner/project-site-partner'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该合作方下有关联项目，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- **跨域调用：** 调用其他模块API获取关联数据（详见各接口说明）

---

## 5. 合作方主档 CRUD (master.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?partner_type=&status=&rating=&keyword=&page=&size=` |
| GET | /:partnerId | 详情，含 contacts[] + qualifications[] + project_summary |
| GET | /:partnerId/stats | 统计，`?partner_type=` 统计各类型数量 |
| POST | / | 新增 |
| PUT | /:partnerId | 编辑 |
| PUT | /:partnerId/status | 变更状态，body: `{ partner_status: "ACTIVE"/"INACTIVE"/"BLACKLISTED" }` |
| DELETE | /:partnerId | 删除，校验: 无project_partner引用 |

**GET / 响应：**
```json
{
  "total": 15,
  "summary": {
    "total": 28,
    "lab_count": 12,
    "irc_count": 8,
    "data_manager_count": 4,
    "stat_analyst_count": 2,
    "other_count": 2,
    "active_count": 25,
    "this_month_new": 3
  },
  "list": [{
    "partner_id": "uuid",
    "partner_type": "LAB",
    "partner_name": "金域医学检验集团",
    "short_name": "金域检测",
    "partner_status": "ACTIVE",
    "rating": 4.5,
    "standard_rate": 500,
    "site_count": 5,
    "project_count": 3,
    "qualification_status": "VALID"
  }]
}
```

**GET /:partnerId 响应：**
```json
{
  "partner_id": "uuid",
  "partner_type": "LAB",
  "partner_name": "金域医学检验集团",
  "short_name": "金域检测",
  "credit_code": "91440101xxx",
  "legal_person": "梁总",
  "registered_address": "广州市国际生物岛xxx",
  "office_address": "广州市国际生物岛xxx",
  "contact_phone": "020-xxx",
  "contact_email": "contact@kingmed.com.cn",
  "rating": 4.5,
  "standard_rate": 500,
  "cooperation_terms": "含加急服务，病理48h出报告",
  "partner_status": "ACTIVE",
  "site_count": 5,
  "project_count": 3,
  "test_scope": ["血液", "病理", "基因", "影像"],
  "cert_level": ["CNAS", "CMA", "CAP"],
  "report_cycle": ["3天", "7天"],
  "contacts": [
    { "contact_id": "uuid", "contact_name": "王经理", "department": "商务部", "position": "总监", "mobile": "139...", "is_primary": 1 }
  ],
  "qualifications": [
    { "qualification_id": "uuid", "doc_type": "CNAS_CERT", "doc_name": "CNAS证书.pdf", "expiry_date": "2027-01-14", "cert_status": "EXPIRING" }
  ],
  "project_summary": {
    "total": 3,
    "active": 2,
    "closed": 1
  }
}
```

**GET /:partnerId/stats 响应：**
```json
{
  "total": 28,
  "lab_count": 12,
  "irc_count": 8,
  "data_manager_count": 4,
  "stat_analyst_count": 2,
  "other_count": 2,
  "this_month_new": 3
}
```

**POST body：**
```json
{
  "partner_type": "LAB",
  "partner_name": "金域医学检验集团",
  "short_name": "金域检测",
  "credit_code": "91440101xxx",
  "legal_person": "梁总",
  "registered_address": "广州市国际生物岛xxx",
  "office_address": "广州市国际生物岛xxx",
  "contact_phone": "020-xxx",
  "contact_email": "contact@kingmed.com.cn",
  "rating": 4.5,
  "standard_rate": 500,
  "cooperation_terms": "含加急服务",
  "test_scope": ["血液", "病理", "基因", "影像"],
  "cert_level": ["CNAS", "CMA", "CAP"],
  "report_cycle": ["3天", "7天"]
}
```

---

## 6. 合作方联系人 CRUD (contact.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?partner_id=xxx` |
| POST | / | 新增 |
| PUT | /:contactId | 编辑 |
| DELETE | /:contactId | 删除 |

**POST body：**
```json
{
  "partner_id": "uuid",
  "contact_name": "王经理",
  "department": "商务部",
  "position": "总监",
  "mobile": "13900139000",
  "email": "wang@kingmed.com.cn",
  "is_primary": 1
}
```

---

## 7. 合作方资质文件 CRUD (qualification.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?partner_id=xxx` |
| POST | / | 上传资质（文件上传） |
| PUT | /:qualificationId | 编辑信息 |
| DELETE | /:qualificationId | 删除 |

**POST body（multipart/form-data）：**
```json
{
  "partner_id": "uuid",
  "doc_type": "CNAS_CERT",
  "expiry_date": "2027-01-14"
}
```
文件通过 `req.file` 获取，保存到 `/uploads/partner/qualifications/`

**资质类型映射（根据partner_type返回可选doc_type）：**
| partner_type | 可选doc_type |
|-------------|-------------|
| LAB | BUSINESS_LICENSE, CNAS_CERT, CMA_CERT, CAP_CERT, OTHER_CERT |
| IRC | BUSINESS_LICENSE, IRC_CERT, MEMBER_LIST, OTHER |
| DATA_MANAGER | BUSINESS_LICENSE, SYSTEM_CERT, SOP_DOC, OTHER |
| STAT_ANALYST | BUSINESS_LICENSE, QUALIFICATION, SOP_DOC, OTHER |
| OTHER | BUSINESS_LICENSE, OTHER |

**资质状态自动更新：**
- expiry_date 为空 → cert_status = 'VALID'
- expiry_date ≤ 30天后 → cert_status = 'EXPIRING'
- expiry_date < 今天 → cert_status = 'EXPIRED'

---

## 8. 项目合作方 CRUD (project-partner.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_id=&partner_type=&status=&keyword=&page=&size=` |
| GET | /:projectPartnerId | 详情，含 sites[] + services[] + fees_summary |
| POST | / | 新增项目合作方 |
| PUT | /:projectPartnerId | 编辑 |
| PUT | /:projectPartnerId/status | 变更状态 |
| DELETE | /:projectPartnerId | 删除（仅PENDING状态可删） |

**GET / 响应：**
```json
{
  "total": 5,
  "summary": { "active": 3, "suspended": 1, "closed": 1 },
  "list": [{
    "project_partner_id": "uuid",
    "partner_id": "uuid",
    "partner_type": "LAB",
    "partner_name": "金域医学检验集团",
    "short_name": "金域检测",
    "project_partner_status": "ACTIVE",
    "site_count": 5,
    "total_fee": 50000,
    "total_payment": 40000,
    "contract_no": "LAB-PD001-001",
    "overall_score": 4.5
  }]
}
```

**GET /:projectPartnerId 响应：**
```json
{
  "project_partner_id": "uuid",
  "project_id": "uuid",
  "partner_id": "uuid",
  "partner_type": "LAB",
  "partner_name": "金域医学检验集团",
  "short_name": "金域检测",
  "project_partner_status": "ACTIVE",
  "site_count": 3,
  "contract_id": "uuid",
  "contract_no": "LAB-PD001-001",
  "contract_amount": 80000,
  "total_fee": 50000,
  "total_payment": 40000,
  "pending_payment": 10000,
  "service_quality_score": 4.5,
  "response_speed_score": 4.0,
  "data_accuracy_score": 4.5,
  "overall_score": 4.3,
  "sites": [
    { "id": "uuid", "project_site_id": "uuid", "site_name": "北京协和医院", "test_count": 50, "sample_status": "NORMAL" }
  ],
  "services": [
    { "service_id": "uuid", "service_no": "SRV-2024-00001", "service_type": "PATHOLOGY", "service_amount": 5000, "service_date": "2024-06-15" }
  ],
  "fees_summary": {
    "total_fee": 50000,
    "pending_fee": 10000
  }
}
```

**POST body：**
```json
{
  "partner_id": "uuid",
  "project_partner_status": "ACTIVE",
  "site_ids": ["siteId1", "siteId2", "siteId3"],
  "contract_no": "LAB-PD001-001",
  "contract_amount": 80000,
  "contract_start_date": "2024-01-01",
  "contract_end_date": "2025-12-31"
}
```

**POST 逻辑（事务）：**
1. INSERT project_partner
2. INSERT project_partner_site (遍历site_ids, 仅LAB类型)
3. UPDATE partner_master.site_count += site_ids.length
4. UPDATE partner_master.project_count += 1
5. 返回完整 project_partner 对象

**PUT /:projectPartnerId/status body：**
```json
{
  "project_partner_status": "SUSPENDED",
  "change_reason": "服务调整",
  "effective_date": "2024-06-15"
}
```

---

## 9. 项目合作方覆盖中心 (project-partner-site.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_partner_id=xxx` |
| POST | / | 新增覆盖中心 |
| PUT | /:id | 编辑 |
| DELETE | /:id | 移除中心 |

**POST body：**
```json
{
  "project_partner_id": "uuid",
  "project_site_id": "uuid",
  "test_count": 0,
  "sample_status": "NORMAL"
}
```

**DELETE 逻辑：**
- UPDATE project_partner_site SET status='REMOVED', remove_date=今天
- UPDATE project_partner.site_count -= 1

---

## 10. 项目合作方服务记录 (project-partner-service.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_partner_id=&service_type=&status=` |
| POST | / | 新增服务记录 |
| PUT | /:serviceId | 编辑 |
| PUT | /:serviceId/status | 变更状态 |
| DELETE | /:serviceId | 删除 |

**服务类型映射（根据partner_type）：**
| partner_type | service_type |
|-------------|-------------|
| LAB | BLOOD, PATHOLOGY, GENE, IMAGE, OTHER |
| IRC | REVIEW, ADHOC_REVIEW |
| DATA_MANAGER | DATA_ENTRY, QUERY, MAPPING |
| STAT_ANALYST | ANALYSIS, REPORT |

**POST body：**
```json
{
  "project_partner_id": "uuid",
  "project_id": "uuid",
  "partner_id": "uuid",
  "project_site_id": "uuid",
  "service_type": "PATHOLOGY",
  "service_amount": 5000,
  "service_date": "2024-06-15",
  "report_date": "2024-06-18",
  "remark": "病理切片检测"
}
```

---

## 11. 项目合作方费用 (fee.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_partner_id=&fee_type=&status=&page=&size=` |
| POST | / | 新增费用 |
| PUT | /:feeId | 编辑 |
| DELETE | /:feeId | 删除 |

**费用关联财务模块（第9/10号线）：**
- 费用审批后同步到 budget.db 的 cost_record
- 费用付款后更新 status='PAID'

**POST body：**
```json
{
  "project_partner_id": "uuid",
  "project_id": "uuid",
  "partner_id": "uuid",
  "fee_type": "SERVICE",
  "fee_amount": 5000,
  "fee_date": "2024-06-15",
  "related_contract_id": "uuid",
  "remark": "6月检测服务费"
}
```

**POST 逻辑：**
1. INSERT project_partner_fee
2. UPDATE project_partner.total_fee += fee_amount
3. 返回完整对象

---

## 12. 项目合作方付款 (payment.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_partner_id=&status=&page=&size=` |
| POST | / | 新增付款申请 |
| PUT | /:paymentId | 编辑 |
| PUT | /:paymentId/approve | 审批付款 |
| DELETE | /:paymentId | 删除（仅PENDING状态可删） |

**付款关联财务模块（第10号线）：**
- 实际付款走 finance.db 的 payment 表 (payee_type='PARTNER')
- 这里只做合作方付款申请记录

**POST body：**
```json
{
  "project_partner_id": "uuid",
  "project_id": "uuid",
  "partner_id": "uuid",
  "payment_amount": 5000,
  "payment_date": "2024-06-20",
  "payment_type": "BANK_TRANSFER",
  "payment_purpose": "检测服务费-6月",
  "invoice_no": "FP-2024-00001"
}
```

**PUT /:paymentId/approve body：**
```json
{
  "payment_status": "APPROVED",
  "approved_by": "uuid",
  "approved_date": "2024-06-20",
  "comment": "同意付款"
}
```

**审批后跨域同步：**
1. INSERT finance.db payment (payee_type='PARTNER', payee_id=partner_id)
2. UPDATE project_partner_payment.payment_status='PAID'
3. UPDATE project_partner.total_payment += payment_amount

---

## 13. 中心合作方信息 (project-site-partner.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心关联的合作方信息（轻量） |

**GET / 响应：**
```json
{
  "lab": {
    "partner_id": "uuid",
    "partner_name": "金域医学检验集团",
    "short_name": "金域检测",
    "rating": 4.5,
    "contract_status": "ACTIVE",
    "contract_no": "LAB-PD001-XH-001",
    "contract_amount": 30000,
    "total_fee": 15000
  },
  "irc": {
    "partner_id": "uuid",
    "partner_name": "DIA IRC",
    "short_name": "DIA IRC",
    "rating": 4.5,
    "contract_status": "ACTIVE",
    "review_count": 5,
    "total_fee": 5000
  },
  "data_manager": {
    "partner_id": "uuid",
    "partner_name": "太美数据",
    "short_name": "太美数据",
    "rating": 4.0,
    "total_fee": 10000
  },
  "stat_analyst": {
    "partner_id": "uuid",
    "partner_name": "统计团队",
    "short_name": "统计",
    "rating": 4.5,
    "total_fee": 8000
  }
}
```

**数据来源：**
- 合作方信息：JOIN project_partner_site + project_partner + partner_master
- 按 partner_type 分组返回

---

## 14. 跨域API调用示例

### 14.1 调用项目模块获取中心列表
```javascript
// 在 project-partner-site.js 中
const projectDb = require('../project/db');  // Project模块db实例

// 获取项目中心列表
const sites = projectDb.prepare(`
  SELECT ps.project_site_id, s.site_name
  FROM project_site ps
  JOIN site s ON s.site_id = ps.site_id
  WHERE ps.project_id = ?
`).all(projectId);
```

### 14.2 调用财务模块写入付款
```javascript
// 在 payment.js 中
const financeDb = require('../finance/db');  // Finance模块db实例

// 审批通过后同步付款
financeDb.prepare(`
  INSERT INTO payment (payment_id, payee_type, payee_id, amount, ...)
`).run({...});
```

### 14.3 调用合同模块获取关联合同
```javascript
// 在 master.js 或 project-partner.js 中
const contractDb = require('../contract/db');  // Contract模块db实例

// 获取合作方关联合同
const contracts = contractDb.prepare(`
  SELECT contract_id, contract_no, contract_status
  FROM contract
  WHERE contract_type = 'PARTNER' AND related_id = ?
`).all(partnerId);
```

---

## 15. 请求/响应格式规范

### 15.1 通用列表响应
```json
{
  "total": 100,
  "page": 1,
  "size": 20,
  "list": []
}
```

### 15.2 通用详情响应
```json
{
  "xxx_id": "uuid",
  "...": "...",
  "created_at": "2024-01-01T00:00:00.000Z",
  "updated_at": "2024-01-01T00:00:00.000Z"
}
```

### 15.3 通用错误响应
```json
{
  "code": 400,
  "message": "错误原因描述"
}
```

### 15.4 业务错误响应
```json
{
  "code": 409,
  "message": "该合作方下有关联项目，无法删除"
}
```

---

## 16. 第一版不做

- ❌ 完整合作方绩效自动计算（暂由PM手动评分）
- ❌ 合作方资质自动校验提醒（前端展示+人工跟进）
- ❌ 合作方服务记录完整功能
- ❌ 合同完整CRUD（只保留入口）
- ❌ 合作方报价单生成
- ❌ 合作方竞品分析
- ❌ 费用预算校验（与第9号线联动后续补）

---

*文档版本 V1.0 | 2026-06-20*
