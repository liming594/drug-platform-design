# Sponsor Module SQL建表脚本 (对象线4号: Sponsor / ProjectSponsor)

> 数据库: sponsor.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js
> **注意：合同/收款/发票已移至独立合同对象线，本库仅保留申办方主数据**

```sql
-- ============================================
-- sponsor.db 全量建表脚本
-- 对象线4号: Sponsor / ProjectSponsor
-- ============================================

-- 1. 申办方主档 (Sponsor Master)
CREATE TABLE IF NOT EXISTS sponsor_master (
    sponsor_id              TEXT PRIMARY KEY,
    sponsor_name            TEXT NOT NULL,
    short_name              TEXT NOT NULL,
    credit_code             TEXT,
    legal_person            TEXT,
    registered_address      TEXT,
    office_address          TEXT,
    contact_phone           TEXT,
    contact_email           TEXT,
    website                 TEXT,
    -- 申办方扩展信息
    sponsor_type            TEXT NOT NULL,           -- LARGE_PHARMA/BIOTECH/CRO/OTHER
    is_listed               INTEGER DEFAULT 0,       -- 是否上市公司 0/1
    stock_code              TEXT,                   -- 股票代码
    vip_level               TEXT DEFAULT 'NORMAL',   -- VIP/IMPORTANT/NORMAL
    rating                  REAL DEFAULT 3.0,        -- 1.0-5.0, 半星精度
    drug_pipeline           TEXT,                    -- 在研药品管线(文本描述)
    -- 冗余统计字段（合同数据来自合同对象线，本字段由后台同步更新）
    project_count           INTEGER DEFAULT 0,        -- 合作项目数
    contract_count          INTEGER DEFAULT 0,        -- 合同数量（冗余）
    total_contract_amount   REAL DEFAULT 0,           -- 累计合同金额（冗余）
    total_collection        REAL DEFAULT 0,           -- 累计收款（冗余）
    -- 状态
    sponsor_status          TEXT DEFAULT 'ACTIVE',   -- ACTIVE/INACTIVE/BLACKLISTED
    remark                  TEXT,
    created_at              TEXT DEFAULT (datetime('now')),
    updated_at              TEXT DEFAULT (datetime('now')),
    created_by              TEXT,
    updated_by              TEXT
);

-- 2. 申办方联系人 (Sponsor Contact)
CREATE TABLE IF NOT EXISTS sponsor_contact (
    contact_id      TEXT PRIMARY KEY,
    sponsor_id      TEXT NOT NULL,
    contact_name    TEXT NOT NULL,
    department      TEXT,
    position        TEXT,
    mobile          TEXT NOT NULL,
    email           TEXT,
    is_primary      INTEGER DEFAULT 0,            -- 是否主联系人
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 3. 申办方资质文件 (Sponsor Qualification)
CREATE TABLE IF NOT EXISTS sponsor_qualification (
    qualification_id   TEXT PRIMARY KEY,
    sponsor_id         TEXT NOT NULL,
    doc_type           TEXT NOT NULL,              -- BUSINESS_LICENSE/GCP_CERT/GMP_CERT/DRUG_REG_CERT/OTHER
    doc_name           TEXT NOT NULL,
    file_path          TEXT,                        -- 文件存储路径
    file_size          INTEGER,                     -- 文件大小(字节)
    upload_date        TEXT,
    expiry_date        TEXT,                        -- 有效期(可不填,如营业执照)
    cert_status        TEXT DEFAULT 'VALID',        -- VALID/EXPIRING/EXPIRED
    remark             TEXT,
    created_at         TEXT DEFAULT (datetime('now')),
    updated_at         TEXT DEFAULT (datetime('now')),
    created_by         TEXT,
    updated_by         TEXT
);

-- 4. 申办方开票信息 (Sponsor Invoice Info)
-- 这是申办方主数据（开票抬头、税号等），与合同无关，保留
CREATE TABLE IF NOT EXISTS sponsor_invoice_info (
    info_id            TEXT PRIMARY KEY,
    sponsor_id         TEXT NOT NULL UNIQUE,
    invoice_title      TEXT NOT NULL,               -- 发票抬头
    tax_number         TEXT NOT NULL,               -- 税号
    bank_name          TEXT,                        -- 开户行
    bank_account       TEXT,                        -- 银行账号
    address            TEXT,                        -- 地址
    phone              TEXT,                        -- 电话
    remark             TEXT,
    created_at         TEXT DEFAULT (datetime('now')),
    updated_at         TEXT DEFAULT (datetime('now')),
    created_by         TEXT,
    updated_by         TEXT
);

-- 5. 项目申办方关联 (Project Sponsor)
CREATE TABLE IF NOT EXISTS project_sponsor (
    project_sponsor_id     TEXT PRIMARY KEY,
    project_id             TEXT NOT NULL UNIQUE,    -- 一个项目只能有一个申办方
    sponsor_id             TEXT NOT NULL,
    project_sponsor_status TEXT DEFAULT 'ACTIVE',   -- PENDING/ACTIVE/SUSPENDED/CLOSED
    -- 绩效评分(按项目)
    contract_score         REAL DEFAULT 0,           -- 合同履约评分(1-5)
    payment_score          REAL DEFAULT 0,           -- 付款及时评分(1-5)
    cooperation_score     REAL DEFAULT 0,           -- 合作配合评分(1-5)
    overall_score          REAL DEFAULT 0,           -- 综合评分(1-5)
    -- 冗余统计字段（合同数据来自合同对象线，由后台同步更新）
    contract_count         INTEGER DEFAULT 0,        -- 合同数量（冗余）
    total_contract_amount  REAL DEFAULT 0,            -- 合同总额（冗余）
    total_collection       REAL DEFAULT 0,            -- 已收款（冗余）
    total_invoice          REAL DEFAULT 0,            -- 已开票（冗余）
    -- 时间戳
    effective_date         TEXT,                     -- 生效日期
    closed_date            TEXT,                     -- 关闭日期
    close_reason           TEXT,                     -- 关闭原因
    remark                 TEXT,
    created_at             TEXT DEFAULT (datetime('now')),
    updated_at             TEXT DEFAULT (datetime('now')),
    created_by             TEXT,
    updated_by             TEXT
);

-- ============================================
-- 已删除的表（合同对象线接管）
-- ============================================
-- ❌ project_sponsor_contract    (项目申办方合同) → 合同对象线
-- ❌ project_sponsor_collection   (项目申办方收款) → 合同对象线
-- ❌ project_sponsor_invoice     (项目申办方开票) → 合同对象线

-- ============================================
-- 索引
-- ============================================

-- sponsor_master 索引
CREATE INDEX IF NOT EXISTS idx_sm_name ON sponsor_master(sponsor_name);
CREATE INDEX IF NOT EXISTS idx_sm_short_name ON sponsor_master(short_name);
CREATE INDEX IF NOT EXISTS idx_sm_status ON sponsor_master(sponsor_status);
CREATE INDEX IF NOT EXISTS idx_sm_type ON sponsor_master(sponsor_type);
CREATE INDEX IF NOT EXISTS idx_sm_vip ON sponsor_master(vip_level);
CREATE INDEX IF NOT EXISTS idx_sm_rating ON sponsor_master(rating);
CREATE INDEX IF NOT EXISTS idx_sm_listed ON sponsor_master(is_listed);

-- sponsor_contact 索引
CREATE INDEX IF NOT EXISTS idx_sc_sponsor ON sponsor_contact(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_sc_primary ON sponsor_contact(sponsor_id, is_primary);

-- sponsor_qualification 索引
CREATE INDEX IF NOT EXISTS idx_sq_sponsor ON sponsor_qualification(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_sq_expiry ON sponsor_qualification(sponsor_id, expiry_date);
CREATE INDEX IF NOT EXISTS idx_sq_status ON sponsor_qualification(cert_status);

-- sponsor_invoice_info 索引
CREATE INDEX IF NOT EXISTS idx_sii_sponsor ON sponsor_invoice_info(sponsor_id);

-- project_sponsor 索引
CREATE INDEX IF NOT EXISTS idx_ps_project ON project_sponsor(project_id);
CREATE INDEX IF NOT EXISTS idx_ps_sponsor ON project_sponsor(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_ps_status ON project_sponsor(project_sponsor_status);
```

---

## 枚举值速查

```
-- sponsor_master.sponsor_type
LARGE_PHARMA / BIOTECH / CRO / OTHER

-- sponsor_master.vip_level
VIP / IMPORTANT / NORMAL

-- sponsor_master.sponsor_status
ACTIVE / INACTIVE / BLACKLISTED

-- sponsor_qualification.doc_type
BUSINESS_LICENSE / GCP_CERT / GMP_CERT / DRUG_REG_CERT / OTHER

-- sponsor_qualification.cert_status
VALID / EXPIRING / EXPIRED

-- project_sponsor.project_sponsor_status
PENDING / ACTIVE / SUSPENDED / CLOSED
```

---

## 表关系说明

```
┌─────────────┐       ┌─────────────┐
│sponsor_master│──1:N──│sponsor_contact│
│ (申办方主档) │       │ (联系人)      │
└──────┬──────┘       └─────────────┘
       │
       │ 1:N              1:1
       ▼                 ────
┌─────────────┐       ┌─────────────┐
│sponsor_     │       │sponsor_     │
│qualification │       │invoice_info  │
│ (资质文件)   │       │ (开票信息)   │
└─────────────┘       └─────────────┘
       │
       │ 1:N              1:1
       ▼                 ────
┌─────────────┐       ┌─────────────┐
│project_     │──N:1──│  project     │
│sponsor      │       │  (项目)      │
│(项目申办方)   │       │              │
└─────────────┘       └─────────────┘
       │
       │ (跨域关联)
       ▼
┌─────────────────────────────────────┐
│  合同对象线 (独立DB)                 │
│  - contract (合同主档)              │
│  - contract_payment (付款计划)       │
│  - contract_collection (收款记录)   │
│  - contract_invoice (发票记录)      │
└─────────────────────────────────────┘
```

---

## 冗余字段同步机制

由于合同数据已移至独立合同对象线，sponsor_master 和 project_sponsor 中的统计字段需要定期同步：

**同步时机：**
1. 合同创建/修改/删除后，通过事件或消息队列触发同步
2. 定时任务（如每日凌晨）全量刷新统计

**同步字段：**
| 源表（合同对象线） | 目标字段 | 说明 |
|------------------|---------|------|
| contract | sponsor_master.contract_count | 申办方合同总数 |
| contract | sponsor_master.total_contract_amount | 申办方合同总额 |
| contract | project_sponsor.contract_count | 项目合同数 |
| contract | project_sponsor.total_contract_amount | 项目合同总额 |
| contract_collection | sponsor_master.total_collection | 累计收款 |
| contract_collection | project_sponsor.total_collection | 项目已收款 |
| contract_invoice | project_sponsor.total_invoice | 项目已开票 |

---

## 第一版不做

- ❌ 申办方药品管线详情管理
- ❌ 申办方信用评估
- ❌ 发票OCR识别
- ❌ 自动资质校验提醒

---

*文档版本 V2.0 | 2026-06-15*
*修改说明：删除 project_sponsor_contract/collection/invoice 三表，合同数据由合同对象线提供*
