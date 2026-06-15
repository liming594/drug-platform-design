# SMO Module API路由规范 (对象线5号: SMO / ProjectSMO)

> 后端: Node.js + Express
> 数据库: smo.db (better-sqlite3, WAL模式)

---

## 1. 文件结构

```
server/routes/
├── smo/
│   ├── db.js              ← smo.db 连接 + 建表
│   ├── master.js           ← SMO主档 CRUD
│   ├── contact.js         ← SMO联系人 CRUD
│   ├── qualification.js   ← SMO资质文件 CRUD
│   ├── contract.js         ← SMO合同 CRUD
│   ├── project-smo.js      ← 项目SMO CRUD
│   ├── project-smo-site.js ← 项目SMO覆盖中心
│   ├── crc-assignment.js   ← CRC分配 (关联team_assignment)
│   ├── fee.js              ← 项目SMO费用
│   └── payment.js          ← 项目SMO付款
└── project-site-smo.js     ← 中心SMO信息 (驾驶舱嵌入)
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'smo.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-smo-sql.md 中的全部SQL粘贴于此
const SCHEMA = `
-- smo_master
CREATE TABLE IF NOT EXISTS smo_master (...);
-- smo_contact
CREATE TABLE IF NOT EXISTS smo_contact (...);
-- ... 其余表
`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// SMO模块
app.use('/api/smo/masters', require('./routes/smo/master'));
app.use('/api/smo/contacts', require('./routes/smo/contact'));
app.use('/api/smo/qualifications', require('./routes/smo/qualification'));
app.use('/api/smo/contracts', require('./routes/smo/contract'));
app.use('/api/smo/sites', require('./routes/smo/site-smo'));  // 中心SMO查询
// 项目SMO
app.use('/api/projects/:projectId/smo', require('./routes/smo/project-smo'));
app.use('/api/projects/:projectId/smo/:projectSmoId/sites', require('./routes/smo/project-smo-site'));
app.use('/api/projects/:projectId/smo/:projectSmoId/crc-assignments', require('./routes/smo/crc-assignment'));
app.use('/api/projects/:projectId/smo/:projectSmoId/fees', require('./routes/smo/fee'));
app.use('/api/projects/:projectId/smo/:projectSmoId/payments', require('./routes/smo/payment'));
// 中心驾驶舱嵌入
app.use('/api/projects/:projectId/sites/:projectSiteId/smo', require('./routes/smo/project-site-smo'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 删除需校验引用，有子数据返回 `{ code: 409, message: "该SMO下有关联项目，无法删除" }`
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- **跨域调用：** 调用其他模块API获取关联数据（详见各接口说明）

---

## 5. SMO主档 CRUD (master.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?status=&rating=&keyword=&page=&size=` |
| GET | /:smoId | 详情，含 contacts[] + qualifications[] + project_summary |
| POST | / | 新增 |
| PUT | /:smoId | 编辑 |
| PUT | /:smoId/status | 变更状态，body: `{ smo_status: "ACTIVE"/"INACTIVE"/"BLACKLISTED" }` |
| DELETE | /:smoId | 删除，校验: 无project_smo引用 |

**GET / 响应：**
```json
{
  "total": 15,
  "list": [{
    "smo_id": "uuid",
    "smo_name": "恒瑞医药SMO有限公司",
    "short_name": "恒瑞SMO",
    "smo_status": "ACTIVE",
    "crc_count": 25,
    "service_region": ["北京", "上海"],
    "rating": 4.5,
    "standard_rate": 180,
    "site_count": 8,
    "project_count": 3
  }]
}
```

**GET /:smoId 响应：**
```json
{
  "smo_id": "uuid",
  "smo_name": "恒瑞医药SMO有限公司",
  "short_name": "恒瑞SMO",
  "credit_code": "91320000xxx",
  "legal_person": "张三",
  "registered_address": "上海市浦东新区xxx",
  "office_address": "上海市浦东新区xxx",
  "contact_phone": "021-xxx",
  "contact_email": "contact@henruismo.cn",
  "crc_count": 25,
  "service_region": ["北京", "上海", "广州"],
  "rating": 4.5,
  "standard_rate": 180,
  "cooperation_terms": "含GCP培训、驻场CRC服务",
  "smo_status": "ACTIVE",
  "site_count": 8,
  "project_count": 3,
  "contacts": [
    { "contact_id": "uuid", "contact_name": "王经理", "department": "商务部", "position": "总监", "mobile": "139...", "is_primary": 1 }
  ],
  "qualifications": [
    { "qualification_id": "uuid", "doc_type": "SMO_CERT", "doc_name": "SMO资质证书.pdf", "expiry_date": "2027-01-14", "cert_status": "VALID" }
  ],
  "project_summary": {
    "total": 3,
    "active": 2,
    "closed": 1
  }
}
```

**POST body：**
```json
{
  "smo_name": "恒瑞医药SMO有限公司",
  "short_name": "恒瑞SMO",
  "credit_code": "91320000xxx",
  "legal_person": "张三",
  "registered_address": "上海市浦东新区xxx",
  "office_address": "上海市浦东新区xxx",
  "contact_phone": "021-xxx",
  "contact_email": "contact@henruismo.cn",
  "crc_count": 25,
  "service_region": ["北京", "上海", "广州"],
  "rating": 4.5,
  "standard_rate": 180,
  "cooperation_terms": "含GCP培训、驻场CRC服务"
}
```

---

## 6. SMO联系人 CRUD (contact.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?smo_id=xxx` |
| POST | / | 新增 |
| PUT | /:contactId | 编辑 |
| DELETE | /:contactId | 删除 |

**POST body：**
```json
{
  "smo_id": "uuid",
  "contact_name": "王经理",
  "department": "商务部",
  "position": "总监",
  "mobile": "13900139000",
  "email": "wang@henruismo.cn",
  "is_primary": 1
}
```

---

## 7. SMO资质文件 CRUD (qualification.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?smo_id=xxx` |
| POST | / | 上传资质（文件上传） |
| PUT | /:qualificationId | 编辑信息 |
| DELETE | /:qualificationId | 删除 |

**POST body（multipart/form-data）：**
```json
{
  "smo_id": "uuid",
  "doc_type": "SMO_CERT",
  "expiry_date": "2027-01-14"
}
```
文件通过 `req.file` 获取，保存到 `/uploads/smo/qualifications/`

**资质状态自动更新：**
- expiry_date 为空 → cert_status = 'VALID'
- expiry_date ≤ 30天后 → cert_status = 'EXPIRING'
- expiry_date < 今天 → cert_status = 'EXPIRED'

---

## 8. SMO合同 CRUD (contract.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_id=&smo_id=&status=` |
| GET | /:contractId | 详情 |
| POST | / | 新增/上传合同 |
| PUT | /:contractId | 编辑 |
| PUT | /:contractId/status | 变更合同状态 |
| DELETE | /:contractId | 删除（仅DRAFT状态可删） |

**POST body（multipart/form-data）：**
```json
{
  "project_id": "uuid",
  "project_smo_id": "uuid",         // 可空
  "smo_id": "uuid",
  "project_site_id": "uuid",        // 每中心一合同时必填
  "contract_no": "SMO-PD001-XH-001",
  "contract_name": "北京协和医院SMO服务合同",
  "contract_amount": 100000,
  "contract_start_date": "2024-01-01",
  "contract_end_date": "2025-12-31",
  "party_a": "申办方名称",
  "party_b": "恒瑞SMO"
}
```
合同文件通过 `req.file` 获取

**合同状态流转：**
- DRAFT → SIGNED → ACTIVE → EXPIRED
- 任一状态 → TERMINATED（提前终止）

---

## 9. 项目SMO CRUD (project-smo.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_id=&status=&keyword=&page=&size=` |
| GET | /:projectSmoId | 详情，含 sites[] + crc_assignments[] + fees_summary |
| POST | / | 新增项目SMO |
| PUT | /:projectSmoId | 编辑 |
| PUT | /:projectSmoId/status | 变更状态 |
| DELETE | /:projectSmoId | 删除（仅PENDING状态可删） |

**GET / 响应：**
```json
{
  "total": 5,
  "summary": { "active": 3, "suspended": 1, "closed": 1 },
  "list": [{
    "project_smo_id": "uuid",
    "smo_id": "uuid",
    "smo_name": "恒瑞SMO",
    "short_name": "恒瑞SMO",
    "project_smo_status": "ACTIVE",
    "site_count": 5,
    "crc_count": 8,
    "total_fee": 180000,
    "total_payment": 150000,
    "contract_no": "SMO-PD001-001",
    "enrollment_rate": 45,
    "overall_score": 4.0
  }]
}
```

**GET /:projectSmoId 响应：**
```json
{
  "project_smo_id": "uuid",
  "project_id": "uuid",
  "smo_id": "uuid",
  "smo_name": "恒瑞SMO",
  "short_name": "恒瑞SMO",
  "project_smo_status": "ACTIVE",
  "site_count": 5,
  "crc_count": 8,
  "contract_id": "uuid",
  "contract_no": "SMO-PD001-001",
  "contract_amount": 500000,
  "total_fee": 180000,
  "total_management_fee": 30000,
  "total_payment": 150000,
  "enrollment_rate": 45,
  "data_quality_score": 4.0,
  "response_speed_score": 4.5,
  "overall_score": 4.0,
  "sites": [
    { "project_smo_site_id": "uuid", "project_site_id": "uuid", "site_name": "北京协和医院", "enrollment_count": 5, "crc_count": 2 }
  ],
  "crc_assignments": [
    { "assignment_id": "uuid", "member_id": "uuid", "member_name": "张A", "site_count": 3, "assignment_status": "ACTIVE" }
  ],
  "fees_summary": {
    "total_fee": 180000,
    "total_management_fee": 30000,
    "total_other_fee": 0,
    "pending_fee": 30000
  }
}
```

**POST body：**
```json
{
  "smo_id": "uuid",
  "project_smo_status": "ACTIVE",
  "site_ids": ["siteId1", "siteId2", "siteId3"],
  "contract_no": "SMO-PD001-001",
  "contract_amount": 500000,
  "contract_start_date": "2024-01-01",
  "contract_end_date": "2025-12-31"
}
```

**POST 逻辑（事务）：**
1. INSERT project_smo
2. INSERT project_smo_site (遍历site_ids)
3. UPDATE smo_master.site_count += site_ids.length
4. INSERT smo_contract (可选)
5. 返回完整 project_smo 对象

**PUT /:projectSmoId/status body：**
```json
{
  "project_smo_status": "SUSPENDED",
  "change_reason": "SMO内部调整",
  "effective_date": "2024-06-15"
}
```

---

## 10. 项目SMO覆盖中心 (project-smo-site.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_smo_id=xxx` |
| POST | / | 新增覆盖中心 |
| PUT | /:id | 编辑 |
| DELETE | /:id | 移除中心 |

**POST body：**
```json
{
  "project_smo_id": "uuid",
  "project_site_id": "uuid"
}
```

**DELETE 逻辑：**
- UPDATE project_smo_site SET status='REMOVED', remove_date=今天
- UPDATE project_smo SET site_count -= 1

---

## 11. CRC分配 (crc-assignment.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_smo_id=xxx&status=` |
| POST | / | 添加CRC |
| PUT | /:assignmentId | 编辑分配 |
| PUT | /:assignmentId/replace | 替换CRC |
| PUT | /:assignmentId/release | 释放CRC |

**CRC分配关联HR模块：**
- CRC人员数据来自 member.db (position_type='CRC')
- 分配记录写入 team_assignment 表 (assignment_type='SMO')
- 通过 HTTP 调用 HR模块API

**GET / 响应：**
```json
{
  "total": 8,
  "list": [{
    "assignment_id": "uuid",
    "member_id": "uuid",
    "member_name": "张A",
    "mobile": "139...",
    "gcp_certified": 1,
    "gcp_expiry_date": "2027-01-01",
    "project_role": "CRC",
    "site_count": 3,
    "allocation_pct": 100,
    "start_date": "2024-03-01",
    "assignment_status": "ACTIVE",
    "total_hours": 160
  }]
}
```

**POST body：**
```json
{
  "member_id": "uuid",
  "site_ids": ["siteId1", "siteId2", "siteId3"],
  "allocation_pct": 100,
  "start_date": "2024-06-15"
}
```

**POST 逻辑（事务+跨域）：**
1. 校验 member_id 存在且 member_status='ACTIVE'
2. INSERT team_assignment (assignment_type='SMO', project_smo_id关联)
3. UPDATE project_smo.crc_count += 1
4. **HTTP调用** member.db 更新成员负载 (availability_pct)

**PUT /:assignmentId/replace body：**
```json
{
  "new_member_id": "uuid",
  "replace_date": "2024-06-20",
  "site_ids": ["siteId1", "siteId2"]
}
```

**PUT /:assignmentId/replace 逻辑（事务）：**
1. 原 team_assignment → `assignment_status='REPLACED'`, `replaced_by_member_id=new_member_id`, `replaced_date=replace_date`
2. INSERT 新 team_assignment (new_member_id, 同 project_smo_id/role, status='ACTIVE')
3. 释放未交接的site_ids（如果传了）
4. **HTTP调用** member.db 更新两人负载

**PUT /:assignmentId/release body：**
```json
{
  "end_date": "2024-06-20",
  "release_reason": "项目调整"
}
```

---

## 12. 项目SMO费用 (fee.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_smo_id=&fee_type=&status=&page=&size=` |
| POST | / | 新增费用 |
| PUT | /:feeId | 编辑 |
| DELETE | /:feeId | 删除 |

**费用关联财务模块（第9/10号线）：**
- 费用审批后同步到 budget.db 的 cost_record
- 费用付款后更新 status='PAID'

**POST body：**
```json
{
  "project_smo_id": "uuid",
  "project_id": "uuid",
  "smo_id": "uuid",
  "fee_type": "CRC_SERVICE",
  "fee_amount": 15000,
  "fee_date": "2024-06-15",
  "related_contract_id": "uuid",
  "remark": "6月CRC服务费"
}
```

**POST 逻辑：**
1. INSERT project_smo_fee
2. UPDATE project_smo.total_fee += fee_amount
3. 返回完整对象

---

## 13. 项目SMO付款 (payment.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?project_smo_id=&status=&page=&size=` |
| POST | / | 新增付款申请 |
| PUT | /:paymentId | 编辑 |
| PUT | /:paymentId/approve | 审批付款 |
| DELETE | /:paymentId | 删除（仅PENDING状态可删） |

**付款关联财务模块（第10号线）：**
- 实际付款走 finance.db 的 payment 表 (payee_type='SMO')
- 这里只做SMO付款申请记录

**POST body：**
```json
{
  "project_smo_id": "uuid",
  "project_id": "uuid",
  "smo_id": "uuid",
  "payment_amount": 50000,
  "payment_date": "2024-06-20",
  "payment_type": "BANK_TRANSFER",
  "payment_purpose": "CRC服务费-6月",
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
1. INSERT finance.db payment (payee_type='SMO', payee_id=smo_id)
2. UPDATE project_smo_payment.payment_status='PAID'
3. UPDATE project_smo.total_payment += payment_amount

---

## 14. 中心SMO信息 (project-site-smo.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心关联的SMO+CRC信息（轻量） |

**GET / 响应：**
```json
{
  "smo": {
    "smo_id": "uuid",
    "smo_name": "恒瑞SMO",
    "short_name": "恒瑞SMO",
    "rating": 4.5,
    "contract_status": "ACTIVE",
    "contract_no": "SMO-PD001-XH-001",
    "contract_amount": 100000,
    "total_fee": 45000
  },
  "crc": {
    "member_id": "uuid",
    "member_name": "张A",
    "mobile": "139...",
    "gcp_certified": 1,
    "gcp_expiry_date": "2027-01-01",
    "enrollment_count": 5,
    "total_hours": 160,
    "assignment_status": "ACTIVE"
  }
}
```

**数据来源：**
- SMO信息：JOIN project_smo_site + project_smo + smo_master
- CRC信息：GET /api/hr/assignments?project_site_id=xxx&assignment_type=CENTER

---

## 15. 跨域API调用示例

### 15.1 调用HR模块获取CRC列表
```javascript
// 在 crc-assignment.js 中
const memberDb = require('../hr/db');  // HR模块db实例

// 查询CRC人员
const crcs = memberDb.prepare(`
  SELECT member_id, name, mobile, gcp_certified, gcp_expiry_date
  FROM member
  WHERE position_type = 'CRC' AND member_status = 'ACTIVE'
`).all();
```

### 15.2 调用财务模块写入付款
```javascript
// 在 payment.js 中
const financeDb = require('../finance/db');  // Finance模块db实例

// 审批通过后同步付款
financeDb.prepare(`
  INSERT INTO payment (...)
`).run({...});
```

### 15.3 调用项目模块获取中心列表
```javascript
// 在 project-smo-site.js 中
const projectDb = require('../project/db');  // Project模块db实例

// 获取项目中心列表
const sites = projectDb.prepare(`
  SELECT ps.project_site_id, s.site_name
  FROM project_site ps
  JOIN site s ON s.site_id = ps.site_id
  WHERE ps.project_id = ?
`).all(projectId);
```

---

## 16. 第一版不做

- ❌ 完整CRC人力调度系统（工时、排班、调度优化）
- ❌ SMO绩效自动计算（暂由PM手动评分）
- ❌ SMO资质自动校验提醒（前端展示+人工跟进）
- ❌ SMO合同模板管理
- ❌ SMO报价单生成
- ❌ SMO竞品分析
- ❌ 费用预算校验（与第9号线联动后续补）

---

*文档版本 V1.0 | 2026-06-15*
