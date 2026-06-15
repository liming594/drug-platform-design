# SMO Module SQL建表脚本 (对象线5号: SMO / ProjectSMO)

> 数据库: smo.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js

```sql
-- ============================================
-- smo.db 全量建表脚本
-- 对象线5号: SMO / ProjectSMO
-- ============================================

-- 1. SMO主档 (SMO Master)
CREATE TABLE IF NOT EXISTS smo_master (
    smo_id              TEXT PRIMARY KEY,
    smo_name            TEXT NOT NULL,
    short_name          TEXT NOT NULL,
    credit_code         TEXT,
    legal_person        TEXT,
    registered_address  TEXT,
    office_address      TEXT,
    contact_phone       TEXT,
    contact_email       TEXT,
    crc_count           INTEGER DEFAULT 0,
    service_region      TEXT,             -- JSON: ["北京","上海","广州"]
    rating              REAL DEFAULT 3.0,  -- 1.0-5.0, 半星精度
    standard_rate       REAL,             -- 标准报价(元/小时)
    cooperation_terms   TEXT,             -- 合作条件
    smo_status          TEXT DEFAULT 'ACTIVE',  -- ACTIVE/INACTIVE/BLACKLISTED
    site_count          INTEGER DEFAULT 0, -- 覆盖中心数(冗余统计)
    project_count       INTEGER DEFAULT 0,-- 合作项目数(冗余统计)
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 2. SMO联系人 (SMO Contact)
CREATE TABLE IF NOT EXISTS smo_contact (
    contact_id      TEXT PRIMARY KEY,
    smo_id          TEXT NOT NULL,
    contact_name    TEXT NOT NULL,
    department      TEXT,
    position        TEXT,
    mobile          TEXT NOT NULL,
    email           TEXT,
    is_primary      INTEGER DEFAULT 0,    -- 是否主联系人
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 3. SMO资质文件 (SMO Qualification)
CREATE TABLE IF NOT EXISTS smo_qualification (
    qualification_id   TEXT PRIMARY KEY,
    smo_id             TEXT NOT NULL,
    doc_type           TEXT NOT NULL,    -- BUSINESS_LICENSE/SMO_CERT/CRC_CERT/GCP_CERT/OTHER
    doc_name           TEXT NOT NULL,
    file_path          TEXT,             -- 文件存储路径
    file_size          INTEGER,          -- 文件大小(字节)
    upload_date        TEXT,
    expiry_date        TEXT,             -- 有效期(可不填,如营业执照)
    cert_status        TEXT DEFAULT 'VALID',  -- VALID/EXPIRING/EXPIRED
    remark             TEXT,
    created_at         TEXT DEFAULT (datetime('now')),
    updated_at         TEXT DEFAULT (datetime('now')),
    created_by         TEXT,
    updated_by         TEXT
);

-- 4. 项目SMO关联 (Project SMO)
CREATE TABLE IF NOT EXISTS project_smo (
    project_smo_id         TEXT PRIMARY KEY,
    project_id             TEXT NOT NULL,
    smo_id                 TEXT NOT NULL,
    project_smo_status     TEXT DEFAULT 'ACTIVE',  -- PENDING/ACTIVE/SUSPENDED/CLOSED
    site_count             INTEGER DEFAULT 0,      -- 覆盖中心数(冗余)
    crc_count              INTEGER DEFAULT 0,      -- 分配CRC数(冗余)
    -- 合同信息(关联contract表,但冗余存储便于查询)
    contract_id            TEXT,                    -- FK→contract.contract_id
    contract_no            TEXT,
    contract_amount        REAL,
    contract_start_date    TEXT,
    contract_end_date      TEXT,
    contract_file_path     TEXT,
    contract_status        TEXT,                    -- DRAFT/SIGNED/ACTIVE/EXPIRED/TERMINATED
    -- 绩效评分(按项目)
    enrollment_rate        REAL DEFAULT 0,        -- 入组贡献率(%)
    data_quality_score    REAL DEFAULT 0,        -- 数据质量评分(1-5)
    response_speed_score   REAL DEFAULT 0,        -- 响应速度评分(1-5)
    overall_score          REAL DEFAULT 0,        -- 综合评分(1-5)
    -- 累计金额(冗余,定期刷新)
    total_fee              REAL DEFAULT 0,        -- 累计CRC服务费
    total_management_fee   REAL DEFAULT 0,        -- 累计管理费
    total_other_fee        REAL DEFAULT 0,        -- 累计其他费用
    total_payment          REAL DEFAULT 0,        -- 累计付款
    -- 时间戳
    effective_date         TEXT,                    -- 生效日期
    closed_date            TEXT,                    -- 关闭日期
    close_reason           TEXT,                    -- 关闭原因
    remark                 TEXT,
    created_at             TEXT DEFAULT (datetime('now')),
    updated_at             TEXT DEFAULT (datetime('now')),
    created_by             TEXT,
    updated_by             TEXT,
    UNIQUE(project_id, smo_id)
);

-- 5. 项目SMO覆盖中心 (Project SMO - Site Coverage)
CREATE TABLE IF NOT EXISTS project_smo_site (
    id                  TEXT PRIMARY KEY,
    project_smo_id      TEXT NOT NULL,
    project_site_id     TEXT NOT NULL,            -- FK→project_site.project_site_id
    enrollment_count     INTEGER DEFAULT 0,        -- 该中心入组数(冗余)
    crc_count            INTEGER DEFAULT 0,        -- 该中心CRC数(冗余)
    status               TEXT DEFAULT 'ACTIVE',    -- ACTIVE/REMOVED
    remove_date          TEXT,                     -- 移除日期
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT,
    UNIQUE(project_smo_id, project_site_id)
);

-- 6. 项目SMO费用 (Project SMO Fee) - 关联第9/10号线
CREATE TABLE IF NOT EXISTS project_smo_fee (
    fee_id              TEXT PRIMARY KEY,
    project_smo_id      TEXT NOT NULL,
    project_id          TEXT NOT NULL,
    smo_id              TEXT NOT NULL,
    fee_type            TEXT NOT NULL,    -- CRC_SERVICE/MANAGEMENT/OTHER
    fee_amount          REAL NOT NULL,
    fee_date            TEXT NOT NULL,
    related_contract_id TEXT,             -- 关联合同
    payment_id          TEXT,             -- 关联付款记录(Finance模块)
    status              TEXT DEFAULT 'PENDING',  -- PENDING/APPROVED/PAID
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 7. 项目SMO付款 (Project SMO Payment) - 关联第10号线finance.db
CREATE TABLE IF NOT EXISTS project_smo_payment (
    payment_id          TEXT PRIMARY KEY,
    project_smo_id      TEXT NOT NULL,
    project_id          TEXT NOT NULL,
    smo_id              TEXT NOT NULL,
    payment_no          TEXT NOT NULL,    -- FK-PYYYY-NNNNN
    payment_amount      REAL NOT NULL,
    payment_date        TEXT NOT NULL,
    payment_type        TEXT,             -- BANK_TRANSFER/CHEQUE/CASH/OTHER
    payment_purpose     TEXT,             -- 付款用途
    payment_status      TEXT DEFAULT 'PENDING',  -- PENDING/APPROVED/PAID/REJECTED
    invoice_no          TEXT,             -- 关联发票号
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 8. SMO合同主表 (SMO Contract) - 统一走contract表,此处仅作索引/缓存
CREATE TABLE IF NOT EXISTS smo_contract (
    contract_id         TEXT PRIMARY KEY,
    project_id          TEXT NOT NULL,
    project_smo_id      TEXT,                        -- 可空,仅项目SMO关联
    smo_id              TEXT NOT NULL,
    project_site_id     TEXT,                        -- 每中心一合同时必填
    contract_type       TEXT DEFAULT 'SMO',          -- 固定SMO
    contract_no         TEXT NOT NULL,
    contract_name       TEXT,
    contract_amount     REAL,
    contract_start_date TEXT,
    contract_end_date   TEXT,
    contract_file_path  TEXT,
    contract_status    TEXT DEFAULT 'DRAFT',        -- DRAFT/SIGNED/ACTIVE/EXPIRED/TERMINATED
    sign_date           TEXT,                        -- 签订日期
    party_a             TEXT,                        -- 甲方(申办方/CRO)
    party_b             TEXT,                        -- 乙方(SMO)
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- ============================================
-- 索引
-- ============================================

-- smo_master 索引
CREATE INDEX IF NOT EXISTS idx_smo_name ON smo_master(smo_name);
CREATE INDEX IF NOT EXISTS idx_smo_short_name ON smo_master(short_name);
CREATE INDEX IF NOT EXISTS idx_smo_status ON smo_master(smo_status);
CREATE INDEX IF NOT EXISTS idx_smo_rating ON smo_master(rating);

-- smo_contact 索引
CREATE INDEX IF NOT EXISTS idx_sc_smo ON smo_contact(smo_id);
CREATE INDEX IF NOT EXISTS idx_sc_primary ON smo_contact(smo_id, is_primary);

-- smo_qualification 索引
CREATE INDEX IF NOT EXISTS idx_sq_smo ON smo_qualification(smo_id);
CREATE INDEX IF NOT EXISTS idx_sq_expiry ON smo_qualification(smo_id, expiry_date);
CREATE INDEX IF NOT EXISTS idx_sq_status ON smo_qualification(cert_status);

-- project_smo 索引
CREATE INDEX IF NOT EXISTS idx_ps_project ON project_smo(project_id);
CREATE INDEX IF NOT EXISTS idx_ps_smo ON project_smo(smo_id);
CREATE INDEX IF NOT EXISTS idx_ps_status ON project_somo(project_smo_status);
CREATE INDEX IF NOT EXISTS idx_ps_project_smo ON project_smo(project_id, smo_id);

-- project_smo_site 索引
CREATE INDEX IF NOT EXISTS idx_pss_psmo ON project_smo_site(project_smo_id);
CREATE INDEX IF NOT EXISTS idx_pss_site ON project_smo_site(project_site_id);
CREATE INDEX IF NOT EXISTS idx_pss_psmo_site ON project_smo_site(project_smo_id, project_site_id);

-- project_smo_fee 索引
CREATE INDEX IF NOT EXISTS idx_psf_psmo ON project_smo_fee(project_smo_id);
CREATE INDEX IF NOT EXISTS idx_psf_project ON project_smo_fee(project_id);
CREATE INDEX IF NOT EXISTS idx_psf_smo ON project_smo_fee(smo_id);
CREATE INDEX IF NOT EXISTS idx_psf_type ON project_smo_fee(fee_type);
CREATE INDEX IF NOT EXISTS idx_psf_status ON project_smo_fee(status);

-- project_smo_payment 索引
CREATE INDEX IF NOT EXISTS idx_psp_psmo ON project_smo_payment(project_smo_id);
CREATE INDEX IF NOT EXISTS idx_psp_project ON project_smo_payment(project_id);
CREATE INDEX IF NOT EXISTS idx_psp_smo ON project_smo_payment(smo_id);
CREATE INDEX IF NOT EXISTS idx_psp_status ON project_smo_payment(payment_status);

-- smo_contract 索引
CREATE INDEX IF NOT EXISTS idx_sc_project ON smo_contract(project_id);
CREATE INDEX IF NOT EXISTS idx_sc_psmo ON smo_contract(project_smo_id);
CREATE INDEX IF NOT EXISTS idx_sc_smo ON smo_contract(smo_id);
CREATE INDEX IF NOT EXISTS idx_sc_site ON smo_contract(project_site_id);
CREATE INDEX IF NOT EXISTS idx_sc_status ON smo_contract(contract_status);
```

---

## 枚举值速查

```
-- smo_master.smo_status
ACTIVE / INACTIVE / BLACKLISTED

-- smo_master.service_region (JSON数组)
["北京","上海","广州","深圳","全国","其他"]

-- smo_qualification.doc_type
BUSINESS_LICENSE / SMO_CERT / CRC_CERT / GCP_CERT / OTHER

-- smo_qualification.cert_status
VALID / EXPIRING / EXPIRED

-- project_smo.project_smo_status
PENDING / ACTIVE / SUSPENDED / CLOSED

-- project_smo.contract_status
DRAFT / SIGNED / ACTIVE / EXPIRED / TERMINATED

-- project_smo_site.status
ACTIVE / REMOVED

-- project_smo_fee.fee_type
CRC_SERVICE / MANAGEMENT / OTHER

-- project_smo_fee.status
PENDING / APPROVED / PAID

-- project_smo_payment.payment_type
BANK_TRANSFER / CHEQUE / CASH / OTHER

-- project_smo_payment.payment_status
PENDING / APPROVED / PAID / REJECTED

-- smo_contract.contract_type
SMO (固定值)

-- smo_contract.contract_status
DRAFT / SIGNED / ACTIVE / EXPIRED / TERMINATED

-- team_assignment.assignment_type (HR模块关联)
PROJECT / CENTER / SMO / VENDOR
```

---

## 表关系说明

```
┌─────────────┐       ┌─────────────┐
│ smo_master  │──1:N──│ smo_contact │
│ (SMO主档)   │       │ (联系人)     │
└──────┬──────┘       └─────────────┘
       │
       │ 1:N
       ▼
┌─────────────┐       ┌─────────────┐
│ project_smo │──N:1──│  project    │
│ (项目SMO)   │       │             │
└──────┬──────┘       └─────────────┘
       │
       │ 1:N              1:N
       ▼                 ────
┌─────────────┐       ┌─────────────┐
│project_smo  │──N:1──│project_site │
│_site        │       │ (中心)       │
│(覆盖中心)    │       │ (跨库引用)   │
└─────────────┘       └─────────────┘
       │
       │ 1:N              1:N
       ▼                 ────
┌─────────────┐       ┌─────────────┐
│project_smo  │       │  team_      │
│_fee         │       │ assignment  │
│(费用)        │       │ (HR模块)    │
└──────┬──────┘       └─────────────┘
       │                       │
       │ 1:N                   │
       ▼                       │
┌─────────────┐               │
│project_smo  │               │
│_payment     │               │
│(付款)        │               │
└─────────────┘               │
                              │
       ───────────────────────
              (跨库)

┌─────────────┐       ┌─────────────┐
│ smo_contract│──引用──│  contract   │
│ (SMO合同)   │       │(合同模块)   │
└─────────────┘       └─────────────┘
```

---

## 跨库引用说明

| 本表字段 | 引用表 | 说明 |
|---------|--------|------|
| project_smo.project_id | project.db | 项目ID |
| project_smo_site.project_site_id | project.db | 中心ID |
| project_smo_fee.project_id | project.db | 项目ID |
| project_smo_payment.project_id | project.db | 项目ID |
| team_assignment.member_id | member.db | CRC人员ID |
| project_smo_fee.payment_id | finance.db | 付款记录ID |

**跨域数据调用规则：**
- 跨库关联数据不走物理外键
- 前端通过API调用获取关联数据
- 后端查询时用 LEFT JOIN 或应用层聚合

---

## 第一版不做

- ❌ 完整CRC工时调度系统
- ❌ SMO绩效自动计算
- ❌ SMO资质自动校验提醒
- ❌ SMO竞品分析

---

*文档版本 V1.0 | 2026-06-15*
