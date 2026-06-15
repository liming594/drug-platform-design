# 其他合作方模块 SQL建表脚本 (对象线7号: Partner / ProjectPartner)

> 数据库: partner.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js
> 核心逻辑复用SMO模式，关键差异：partner_type字段区分类型

```sql
-- ============================================
-- partner.db 全量建表脚本
-- 对象线7号: Partner / ProjectPartner
-- ============================================

-- 0. 合作方类型枚举 (注释定义，便于维护)
-- LAB: 检测公司/中心检测实验室
-- IRC: 独立评审委员会
-- DATA_MANAGER: 数据管理
-- STAT_ANALYST: 统计分析
-- OTHER: 其他

-- 1. 其他合作方主档 (Partner Master)
CREATE TABLE IF NOT EXISTS partner_master (
    partner_id              TEXT PRIMARY KEY,
    partner_type            TEXT NOT NULL,            -- LAB/IRC/DATA_MANAGER/STAT_ANALYST/OTHER
    partner_name            TEXT NOT NULL,            -- 合作方全称
    short_name              TEXT NOT NULL,            -- 简称
    credit_code             TEXT,                    -- 统一社会信用代码
    legal_person            TEXT,                    -- 法人代表
    registered_address      TEXT,                    -- 注册地址
    office_address          TEXT,                    -- 办公地址
    contact_phone           TEXT,                    -- 联系电话
    contact_email           TEXT,                    -- 联系邮箱
    -- 通用扩展字段
    rating                  REAL DEFAULT 3.0,        -- 1.0-5.0, 半星精度
    standard_rate           REAL,                    -- 标准报价(元/服务项)
    cooperation_terms       TEXT,                    -- 合作条件
    partner_status          TEXT DEFAULT 'ACTIVE',   -- ACTIVE/INACTIVE/BLACKLISTED
    -- 冗余统计
    site_count              INTEGER DEFAULT 0,      -- 覆盖中心数
    project_count           INTEGER DEFAULT 0,      -- 合作项目数
    -- LAB类型扩展字段
    test_scope              TEXT,                    -- JSON: ["血液","病理","基因"]
    cert_level              TEXT,                    -- JSON: ["CNAS","CMA","CAP"]
    report_cycle            TEXT,                    -- JSON: ["3天","7天"]
    -- IRC类型扩展字段
    review_field             TEXT,                   -- JSON: ["肿瘤","心血管"]
    committee_size          INTEGER DEFAULT 0,      -- 委员规模
    review_frequency        TEXT,                    -- JSON: ["常规","紧急"]
    -- DATA_MANAGER类型扩展字段
    data_system             TEXT,                    -- JSON: ["EDC","ePRO"]
    data_standard           TEXT,                    -- JSON: ["CDISC","G×P"]
    -- STAT_ANALYST类型扩展字段
    analysis_service        TEXT,                    -- JSON: ["生物统计","药物警戒"]
    software_capability     TEXT,                    -- JSON: ["SAS","R","Python"]
    -- 时间戳
    remark                  TEXT,
    created_at              TEXT DEFAULT (datetime('now')),
    updated_at              TEXT DEFAULT (datetime('now')),
    created_by              TEXT,
    updated_by              TEXT
);

-- 2. 合作方联系人 (Partner Contact)
CREATE TABLE IF NOT EXISTS partner_contact (
    contact_id      TEXT PRIMARY KEY,
    partner_id      TEXT NOT NULL,
    contact_name    TEXT NOT NULL,
    department      TEXT,
    position        TEXT,
    mobile          TEXT NOT NULL,
    email           TEXT,
    is_primary      INTEGER DEFAULT 0,               -- 是否主联系人
    remark          TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    created_by      TEXT,
    updated_by      TEXT
);

-- 3. 合作方资质文件 (Partner Qualification)
CREATE TABLE IF NOT EXISTS partner_qualification (
    qualification_id   TEXT PRIMARY KEY,
    partner_id         TEXT NOT NULL,
    doc_type           TEXT NOT NULL,                -- 根据partner_type区分类型
    doc_name           TEXT NOT NULL,
    file_path          TEXT,                         -- 文件存储路径
    file_size          INTEGER,                      -- 文件大小(字节)
    upload_date        TEXT,
    expiry_date        TEXT,                         -- 有效期(可不填,如营业执照)
    cert_status        TEXT DEFAULT 'VALID',          -- VALID/EXPIRING/EXPIRED
    remark             TEXT,
    created_at         TEXT DEFAULT (datetime('now')),
    updated_at         TEXT DEFAULT (datetime('now')),
    created_by         TEXT,
    updated_by         TEXT
);

-- 4. 项目合作方关联 (Project Partner)
CREATE TABLE IF NOT EXISTS project_partner (
    project_partner_id     TEXT PRIMARY KEY,
    project_id             TEXT NOT NULL,
    partner_id             TEXT NOT NULL,
    project_partner_status TEXT DEFAULT 'ACTIVE',    -- PENDING/ACTIVE/SUSPENDED/CLOSED
    site_count             INTEGER DEFAULT 0,        -- 覆盖中心数(冗余)
    -- 合同信息(关联contract表,但冗余存储便于查询)
    contract_id            TEXT,                      -- FK→contract.contract_id
    contract_no            TEXT,
    contract_amount        REAL,
    contract_start_date    TEXT,
    contract_end_date      TEXT,
    contract_file_path     TEXT,
    contract_status        TEXT,                      -- DRAFT/SIGNED/ACTIVE/EXPIRED/TERMINATED
    -- 绩效评分(按项目)
    service_quality_score  REAL DEFAULT 0,            -- 服务质量评分(1-5)
    response_speed_score   REAL DEFAULT 0,            -- 响应速度评分(1-5)
    data_accuracy_score    REAL DEFAULT 0,            -- 数据准确度评分(1-5,仅DATA/STAT适用)
    overall_score          REAL DEFAULT 0,            -- 综合评分(1-5)
    -- 累计金额(冗余,定期刷新)
    total_fee              REAL DEFAULT 0,            -- 累计服务费
    total_payment          REAL DEFAULT 0,           -- 累计付款
    -- 时间戳
    effective_date         TEXT,                     -- 生效日期
    closed_date            TEXT,                     -- 关闭日期
    close_reason           TEXT,                     -- 关闭原因
    remark                 TEXT,
    created_at             TEXT DEFAULT (datetime('now')),
    updated_at             TEXT DEFAULT (datetime('now')),
    created_by             TEXT,
    updated_by             TEXT,
    UNIQUE(project_id, partner_id)
);

-- 5. 项目合作方覆盖中心 (Project Partner - Site Coverage)
CREATE TABLE IF NOT EXISTS project_partner_site (
    id                  TEXT PRIMARY KEY,
    project_partner_id  TEXT NOT NULL,
    project_site_id     TEXT NOT NULL,               -- FK→project_site.project_site_id
    test_count          INTEGER DEFAULT 0,            -- 该中心检测量(冗余,LAB类型)
    sample_status       TEXT DEFAULT 'NORMAL',       -- NORMAL/ABNORMAL(样本状态)
    status              TEXT DEFAULT 'ACTIVE',        -- ACTIVE/REMOVED
    remove_date         TEXT,                        -- 移除日期
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT,
    UNIQUE(project_partner_id, project_site_id)
);

-- 6. 项目合作方服务记录 (Project Partner Service Record)
CREATE TABLE IF NOT EXISTS project_partner_service (
    service_id          TEXT PRIMARY KEY,
    project_partner_id  TEXT NOT NULL,
    project_id          TEXT NOT NULL,
    partner_id          TEXT NOT NULL,
    project_site_id     TEXT,                         -- 可选,中心级服务
    service_type        TEXT NOT NULL,               -- LAB: BLOOD/PATHOLOGY/GENE/IMAGE/OTHER
                                                     -- IRC: REVIEW/ADHOC_REVIEW
                                                     -- DATA: DATA_ENTRY/QUERY/MAPPING
                                                     -- STAT: ANALYSIS/REPORT
    service_no          TEXT NOT NULL,               -- 服务编号
    service_amount      REAL NOT NULL,               -- 服务金额
    service_date        TEXT NOT NULL,               -- 服务日期
    report_date         TEXT,                        -- 报告日期(仅LAB)
    service_status      TEXT DEFAULT 'COMPLETED',    -- PENDING/COMPLETED/REJECTED
    payment_id          TEXT,                        -- 关联付款记录(Finance模块)
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 7. 项目合作方费用 (Project Partner Fee) - 关联第9/10号线
CREATE TABLE IF NOT EXISTS project_partner_fee (
    fee_id              TEXT PRIMARY KEY,
    project_partner_id  TEXT NOT NULL,
    project_id          TEXT NOT NULL,
    partner_id          TEXT NOT NULL,
    fee_type            TEXT NOT NULL,               -- SERVICE/MANAGEMENT/OTHER
    fee_amount          REAL NOT NULL,
    fee_date            TEXT NOT NULL,
    related_contract_id TEXT,                        -- 关联合同
    payment_id          TEXT,                        -- 关联付款记录(Finance模块)
    status              TEXT DEFAULT 'PENDING',      -- PENDING/APPROVED/PAID
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- 8. 项目合作方付款 (Project Partner Payment) - 关联第10号线finance.db
CREATE TABLE IF NOT EXISTS project_partner_payment (
    payment_id          TEXT PRIMARY KEY,
    project_partner_id  TEXT NOT NULL,
    project_id          TEXT NOT NULL,
    partner_id          TEXT NOT NULL,
    payment_no          TEXT NOT NULL,               -- FP-YYYY-NNNNN
    payment_amount      REAL NOT NULL,
    payment_date        TEXT NOT NULL,
    payment_type        TEXT,                        -- BANK_TRANSFER/CHEQUE/CASH/OTHER
    payment_purpose     TEXT,                        -- 付款用途
    payment_status      TEXT DEFAULT 'PENDING',       -- PENDING/APPROVED/PAID/REJECTED
    invoice_no          TEXT,                        -- 关联发票号
    remark              TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now')),
    created_by          TEXT,
    updated_by          TEXT
);

-- ============================================
-- 索引
-- ============================================

-- partner_master 索引
CREATE INDEX IF NOT EXISTS idx_pm_type ON partner_master(partner_type);
CREATE INDEX IF NOT EXISTS idx_pm_name ON partner_master(partner_name);
CREATE INDEX IF NOT EXISTS idx_pm_short_name ON partner_master(short_name);
CREATE INDEX IF NOT EXISTS idx_pm_status ON partner_master(partner_status);
CREATE INDEX IF NOT EXISTS idx_pm_rating ON partner_master(rating);
CREATE INDEX IF NOT EXISTS idx_pm_created ON partner_master(created_at);

-- partner_contact 索引
CREATE INDEX IF NOT EXISTS idx_pc_partner ON partner_contact(partner_id);
CREATE INDEX IF NOT EXISTS idx_pc_primary ON partner_contact(partner_id, is_primary);

-- partner_qualification 索引
CREATE INDEX IF NOT EXISTS idx_pq_partner ON partner_qualification(partner_id);
CREATE INDEX IF NOT EXISTS idx_pq_expiry ON partner_qualification(partner_id, expiry_date);
CREATE INDEX IF NOT EXISTS idx_pq_status ON partner_qualification(cert_status);

-- project_partner 索引
CREATE INDEX IF NOT EXISTS idx_pp_project ON project_partner(project_id);
CREATE INDEX IF NOT EXISTS idx_pp_partner ON project_partner(partner_id);
CREATE INDEX IF NOT EXISTS idx_pp_status ON project_partner(project_partner_status);
CREATE INDEX IF NOT EXISTS idx_pp_project_partner ON project_partner(project_id, partner_id);

-- project_partner_site 索引
CREATE INDEX IF NOT EXISTS idx_pps_pp ON project_partner_site(project_partner_id);
CREATE INDEX IF NOT EXISTS idx_pps_site ON project_partner_site(project_site_id);
CREATE INDEX IF NOT EXISTS idx_pps_pp_site ON project_partner_site(project_partner_id, project_site_id);

-- project_partner_service 索引
CREATE INDEX IF NOT EXISTS idx_ppserv_pp ON project_partner_service(project_partner_id);
CREATE INDEX IF NOT EXISTS idx_ppserv_project ON project_partner_service(project_id);
CREATE INDEX IF NOT EXISTS idx_ppserv_partner ON project_partner_service(partner_id);
CREATE INDEX IF NOT EXISTS idx_ppserv_type ON project_partner_service(service_type);
CREATE INDEX IF NOT EXISTS idx_ppserv_status ON project_partner_service(service_status);

-- project_partner_fee 索引
CREATE INDEX IF NOT EXISTS idx_ppf_pp ON project_partner_fee(project_partner_id);
CREATE INDEX IF NOT EXISTS idx_ppf_project ON project_partner_fee(project_id);
CREATE INDEX IF NOT EXISTS idx_ppf_partner ON project_partner_fee(partner_id);
CREATE INDEX IF NOT EXISTS idx_ppf_type ON project_partner_fee(fee_type);
CREATE INDEX IF NOT EXISTS idx_ppf_status ON project_partner_fee(status);

-- project_partner_payment 索引
CREATE INDEX IF NOT EXISTS idx_ppp_pp ON project_partner_payment(project_partner_id);
CREATE INDEX IF NOT EXISTS idx_ppp_project ON project_partner_payment(project_id);
CREATE INDEX IF NOT EXISTS idx_ppp_partner ON project_partner_payment(partner_id);
CREATE INDEX IF NOT EXISTS idx_ppp_status ON project_partner_payment(payment_status);

-- ============================================
-- 触发器
-- ============================================

-- 自动更新 partner_master.updated_at
CREATE TRIGGER IF NOT EXISTS trg_partner_master_update
AFTER UPDATE ON partner_master
BEGIN
    UPDATE partner_master SET updated_at = datetime('now') WHERE partner_id = NEW.partner_id;
END;

-- 自动更新 partner_contact.updated_at
CREATE TRIGGER IF NOT EXISTS trg_partner_contact_update
AFTER UPDATE ON partner_contact
BEGIN
    UPDATE partner_contact SET updated_at = datetime('now') WHERE contact_id = NEW.contact_id;
END;

-- 自动更新 partner_qualification.updated_at
CREATE TRIGGER IF NOT EXISTS trg_partner_qualification_update
AFTER UPDATE ON partner_qualification
BEGIN
    UPDATE partner_qualification SET updated_at = datetime('now') WHERE qualification_id = NEW.qualification_id;
END;

-- 自动更新 project_partner.updated_at
CREATE TRIGGER IF NOT EXISTS trg_project_partner_update
AFTER UPDATE ON project_partner
BEGIN
    UPDATE project_partner SET updated_at = datetime('now') WHERE project_partner_id = NEW.project_partner_id;
END;

-- 自动更新 project_partner_site.updated_at
CREATE TRIGGER IF NOT EXISTS trg_project_partner_site_update
AFTER UPDATE ON project_partner_site
BEGIN
    UPDATE project_partner_site SET updated_at = datetime('now') WHERE id = NEW.id;
END;

-- 自动更新 project_partner_service.updated_at
CREATE TRIGGER IF NOT EXISTS trg_project_partner_service_update
AFTER UPDATE ON project_partner_service
BEGIN
    UPDATE project_partner_service SET updated_at = datetime('now') WHERE service_id = NEW.service_id;
END;

-- 自动更新 project_partner_fee.updated_at
CREATE TRIGGER IF NOT EXISTS trg_project_partner_fee_update
AFTER UPDATE ON project_partner_fee
BEGIN
    UPDATE project_partner_fee SET updated_at = datetime('now') WHERE fee_id = NEW.fee_id;
END;

-- 自动更新 project_partner_payment.updated_at
CREATE TRIGGER IF NOT EXISTS trg_project_partner_payment_update
AFTER UPDATE ON project_partner_payment
BEGIN
    UPDATE project_partner_payment SET updated_at = datetime('now') WHERE payment_id = NEW.payment_id;
END;

-- 资质状态自动更新触发器
CREATE TRIGGER IF NOT EXISTS trg_partner_qualification_status
AFTER INSERT ON partner_qualification
WHEN NEW.expiry_date IS NOT NULL
BEGIN
    UPDATE partner_qualification SET cert_status = 
        CASE
            WHEN date(NEW.expiry_date) < date('now') THEN 'EXPIRED'
            WHEN date(NEW.expiry_date) <= date('now', '+30 days') THEN 'EXPIRING'
            ELSE 'VALID'
        END
    WHERE qualification_id = NEW.qualification_id;
END;
```

---

## 枚举值速查

```
-- partner_master.partner_type
LAB                    -- 检测公司/中心检测实验室
IRC                    -- 独立评审委员会
DATA_MANAGER           -- 数据管理
STAT_ANALYST           -- 统计分析
OTHER                  -- 其他

-- partner_master.partner_status
ACTIVE / INACTIVE / BLACKLISTED

-- partner_master.test_scope (LAB类型)
["血液","病理","基因","影像","其他"]

-- partner_master.cert_level (LAB类型)
["CNAS","CMA","CAP","其他"]

-- partner_master.report_cycle (LAB类型)
["1天","3天","7天","14天","30天"]

-- partner_master.review_field (IRC类型)
["肿瘤","心血管","神经","代谢","其他"]

-- partner_master.review_frequency (IRC类型)
["常规","紧急","加急"]

-- partner_master.data_system (DATA_MANAGER类型)
["EDC","ePRO","随机化","其他"]

-- partner_master.data_standard (DATA_MANAGER类型)
["CDISC","G×P","其他"]

-- partner_master.analysis_service (STAT_ANALYST类型)
["生物统计","药物警戒","医学写作","其他"]

-- partner_master.software_capability (STAT_ANALYST类型)
["SAS","R","Python","其他"]

-- partner_qualification.doc_type
-- LAB类型
BUSINESS_LICENSE / CNAS_CERT / CMA_CERT / CAP_CERT / OTHER_CERT
-- IRC类型
BUSINESS_LICENSE / IRC_CERT / MEMBER_LIST / OTHER
-- DATA_MANAGER类型
BUSINESS_LICENSE / SYSTEM_CERT / SOP_DOC / OTHER
-- STAT_ANALYST类型
BUSINESS_LICENSE / QUALIFICATION / SOP_DOC / OTHER
-- 通用
OTHER

-- partner_qualification.cert_status
VALID / EXPIRING / EXPIRED

-- project_partner.project_partner_status
PENDING / ACTIVE / SUSPENDED / CLOSED

-- project_partner.contract_status
DRAFT / SIGNED / ACTIVE / EXPIRED / TERMINATED

-- project_partner_site.sample_status (LAB类型)
NORMAL / ABNORMAL

-- project_partner_site.status
ACTIVE / REMOVED

-- project_partner_service.service_type
-- LAB类型
BLOOD / PATHOLOGY / GENE / IMAGE / OTHER
-- IRC类型
REVIEW / ADHOC_REVIEW
-- DATA_MANAGER类型
DATA_ENTRY / QUERY / MAPPING
-- STAT_ANALYST类型
ANALYSIS / REPORT

-- project_partner_service.service_status
PENDING / COMPLETED / REJECTED

-- project_partner_fee.fee_type
SERVICE / MANAGEMENT / OTHER

-- project_partner_fee.status
PENDING / APPROVED / PAID

-- project_partner_payment.payment_type
BANK_TRANSFER / CHEQUE / CASH / OTHER

-- project_partner_payment.payment_status
PENDING / APPROVED / PAID / REJECTED
```

---

## 表关系说明

```
┌─────────────────┐       ┌─────────────────┐
│ partner_master  │──1:N──│ partner_contact │
│ (合作方主档)     │       │ (联系人)         │
└──────┬──────────┘       └─────────────────┘
       │
       │ 1:N
       ▼
┌─────────────────┐       ┌─────────────────┐
│ partner_        │──N:1──│   project       │
│ qualification   │       │                 │
│ (资质文件)       │       └────────┬────────┘
└─────────────────┘                │
                                    │ 1:N
                                    ▼
                         ┌─────────────────┐       ┌─────────────────┐
                         │ project_partner │──N:1──│  partner_master │
                         │ (项目合作方)     │       │                 │
                         └──────┬──────────┘       └─────────────────┘
                                │
                                │ 1:N              1:N
                                ▼                 ────
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│ project_partner │──N:1──│ project_site   │       │    contract     │
│ _site           │       │ (中心)           │       │ (合同模块-入口) │
│ (覆盖中心)       │       │ (跨库引用)       │       └─────────────────┘
└─────────────────┘       └─────────────────┘

┌─────────────────┐       ┌─────────────────┐
│ project_partner │──1:N──│ project_partner │
│ _service        │       │ _fee            │
│ (服务记录)       │       │ (费用)           │
└──────┬──────────┘       └──────┬──────────┘
       │                         │
       │ 1:N                     │ 1:N
       ▼                         ▼
┌─────────────────┐       ┌─────────────────┐
│ project_partner │       │ project_partner │
│ _payment        │       │ _payment        │
│ (付款)           │       │ (付款)           │
└─────────────────┘       └─────────────────┘
```

---

## 跨库引用说明

| 本表字段 | 引用表 | 说明 |
|---------|--------|------|
| project_partner.project_id | project.db | 项目ID |
| project_partner_site.project_site_id | project.db | 中心ID |
| project_partner_fee.project_id | project.db | 项目ID |
| project_partner_payment.project_id | project.db | 项目ID |
| project_partner_fee.payment_id | finance.db | 付款记录ID |
| project_partner_payment.payment_id | finance.db | 付款记录ID |

**跨域数据调用规则：**
- 跨库关联数据不走物理外键
- 前端通过API调用获取关联数据
- 后端查询时用 LEFT JOIN 或应用层聚合
- 合同模块仅保留入口，完整CRUD在contract.db

---

## 与SMO的字段差异对照

| SMO字段 | Partner对应 | 说明 |
|---------|------------|------|
| smo_master.smo_id | partner_master.partner_id | 主键 |
| smo_master.smo_name | partner_master.partner_name | 合作方全称 |
| smo_master.short_name | partner_master.short_name | 简称 |
| smo_master.smo_status | partner_master.partner_status | 状态 |
| smo_master.crc_count | 删除 | 替换为类型扩展字段 |
| smo_master.service_region | 删除 | 替换为类型扩展字段 |
| 新增 | partner_master.partner_type | 合作方类型(LAB/IRC/DATA_MANAGER/STAT_ANALYST/OTHER) |
| 新增(LAB) | partner_master.test_scope | 检测项目范围 |
| 新增(LAB) | partner_master.cert_level | 资质等级 |
| 新增(LAB) | partner_master.report_cycle | 报告周期 |
| 新增(IRC) | partner_master.review_field | 评审领域 |
| 新增(IRC) | partner_master.committee_size | 委员规模 |
| 新增(IRC) | partner_master.review_frequency | 评审频率 |
| 新增(DATA) | partner_master.data_system | 数据管理系统 |
| 新增(DATA) | partner_master.data_standard | 数据标准 |
| 新增(STAT) | partner_master.analysis_service | 分析服务 |
| 新增(STAT) | partner_master.software_capability | 软件能力 |
| smo_contact | partner_contact | 联系人表 |
| smo_qualification | partner_qualification | 资质文件表 |
| project_smo | project_partner | 项目合作方 |
| project_smo_site | project_partner_site | 项目合作方覆盖中心 |
| 新增 | project_partner_service | 服务记录表(LAB/IRC/DATA/STAT专用) |
| project_smo_fee | project_partner_fee | 项目合作方费用 |
| project_smo_payment | project_partner_payment | 项目合作方付款 |

---

## 第一版不做

- ❌ 完整合作方绩效自动计算
- ❌ 合作方资质自动校验提醒
- ❌ 合作方服务记录完整功能
- ❌ 合同完整CRUD（只保留入口）

---

*文档版本 V1.0 | 2026-06-20*
