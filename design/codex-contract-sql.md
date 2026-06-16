# Contract Module SQL建表脚本 (对象线17号: Contract / 合同管理)

> 数据库: contract.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js

---

## 一、设计理念

### 1.1 核心表设计思路

**合同管理模块围绕"合同主档→收款计划→收款确认→开票申请→发票记录"的生命周期展开：**

1. **合同是核心**：合同主表(contract)是一切的起点
2. **收款计划是执行**：收款计划(contract_payment)定义分阶段收款
3. **收款记录是确认**：收款记录(contract_collection)记录实际收款
4. **发票是闭环**：发票记录(contract_invoice)管理开票流程
5. **变更是追溯**：合同变更(contract_change)记录历史修改
6. **附件是凭证**：合同附件(contract_document)存储扫描件等

### 1.2 与其他模块的关系

```
project.db ──project_id──→ contract ──party_type/party_id──→ sponsor.db/smo.db/partner.db/project.db
                                     │
                                     ↓
                    contract_payment ←─┐
                                     │
                    contract_collection
                                     │
                    contract_invoice ←─┘
```

**跨库引用说明：**
| 字段 | 引用表 | 说明 |
|------|--------|------|
| project_id | project.db | 项目ID |
| party_type + party_id | sponsor.db / smo.db / partner.db / project.db | 多态关联 |

---

## 二、全量建表脚本

```sql
-- ============================================
-- contract.db 全量建表脚本
-- 对象线17号: Contract / 合同管理
-- ============================================

-- 1. 合同主表 (Contract)
CREATE TABLE IF NOT EXISTS contract (
    contract_id            TEXT PRIMARY KEY,
    contract_no           TEXT NOT NULL UNIQUE,   -- HT-YYYY-NNNNN格式
    
    -- 合同基本信息
    contract_name         TEXT NOT NULL,    -- 合同名称
    contract_type         TEXT NOT NULL,    -- MAIN/SUPPLEMENT/NDA/FRAMEWORK
    project_id           TEXT NOT NULL,                       -- FK→project.db (逻辑外键)
    
    -- 合同对方（多态关联）
    party_type            TEXT NOT NULL,    -- SPONSOR/SMO/SITE/PARTNER
    party_id              TEXT NOT NULL,                       -- FK对应库的逻辑外键
    
    -- 金额信息
    contract_amount      REAL NOT NULL DEFAULT 0,   -- 合同总金额
    collected_amount     REAL DEFAULT 0,            -- 已收款金额
    invoiced_amount      REAL DEFAULT 0,            -- 已开票金额
    pending_amount       REAL DEFAULT 0,             -- 应收未收(计算: contract_amount - collected_amount)
    
    -- 日期信息
    sign_date            TEXT,             -- 签署日期
    effective_date       TEXT,             -- 生效日期
    expiry_date          TEXT,             -- 到期日期
    
    -- 状态
    contract_status      TEXT DEFAULT 'DRAFT',  -- DRAFT/PENDING_APPROVAL/PENDING_SIGN/ACTIVE/CHANGING/EXPIRED/TERMINATED
    
    -- 关联（补充协议关联主合同）
    parent_contract_id   TEXT,             -- 关联主合同ID(补充协议用)
    
    -- 附件
    related_files        TEXT,             -- JSON: [{file_id, file_name, file_path, file_type}]
    
    -- 冗余统计字段
    payment_count        INTEGER DEFAULT 0,        -- 收款计划数
    payment_complete_count INTEGER DEFAULT 0,     -- 已收款计划数
    
    -- 审计字段
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 2. 收款计划 (Contract Payment Plan)
CREATE TABLE IF NOT EXISTS contract_payment (
    payment_id           TEXT PRIMARY KEY,
    payment_no           TEXT NOT NULL,    -- SKP-YYYY-NNNNN (Payment Plan编号)
    contract_id          TEXT NOT NULL,                       -- FK→contract (逻辑外键)
    
    -- 计划信息
    payment_stage        TEXT NOT NULL,    -- 第1期/第2期...（文本描述）
    payment_amount       REAL NOT NULL,    -- 计划收款金额
    payment_date        TEXT NOT NULL,    -- 计划收款日期
    
    -- 状态
    payment_status       TEXT DEFAULT 'PLANNED',  -- PLANNED/OVERDUE/PARTIAL/RECEIVED
    
    -- 实际收款（关联到contract_collection）
    collection_id        TEXT,             -- 关联收款记录ID
    
    -- 审计字段
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 3. 收款记录 (Contract Collection)
CREATE TABLE IF NOT EXISTS contract_collection (
    collection_id        TEXT PRIMARY KEY,
    collection_no       TEXT NOT NULL UNIQUE,   -- SK-YYYY-NNNNN
    
    -- 关联
    contract_id          TEXT NOT NULL,                       -- FK→contract (逻辑外键)
    payment_id           TEXT,             -- 关联收款计划ID(可为空)
    
    -- 收款信息
    collection_amount    REAL NOT NULL,    -- 实际收款金额
    collection_date      TEXT NOT NULL,    -- 实际收款日期
    collection_method    TEXT NOT NULL,    -- BANK_TRANSFER/CHEQUE/CASH/OTHER
    
    -- 银行信息
    bank_name            TEXT,             -- 开户银行
    bank_account         TEXT,             -- 银行账号
    counterparty_account TEXT,             -- 对方账户名
    
    -- 凭证
    receipt_file_path    TEXT,             -- 收款凭证文件路径
    receipt_file_name    TEXT,             -- 原始文件名
    
    -- 审计字段
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 4. 发票记录 (Contract Invoice)
CREATE TABLE IF NOT EXISTS contract_invoice (
    invoice_id           TEXT PRIMARY KEY,
    invoice_no          TEXT NOT NULL UNIQUE,   -- FP-YYYY-NNNNN
    
    -- 关联
    contract_id          TEXT NOT NULL,                       -- FK→contract (逻辑外键)
    
    -- 发票信息
    invoice_type        TEXT NOT NULL,    -- VAT_SPECIAL/VAT_NORMAL
    invoice_amount      REAL NOT NULL,    -- 发票金额
    invoice_date        TEXT NOT NULL,    -- 开票日期
    
    -- 购买方信息（从合作方开票信息自动填充）
    buyer_name          TEXT NOT NULL,    -- 购买方名称
    buyer_tax_number    TEXT NOT NULL,    -- 购买方税号
    buyer_bank          TEXT,             -- 购买方开户行
    buyer_account       TEXT,             -- 购买方账号
    buyer_address       TEXT,             -- 购买方地址电话
    
    -- 销售方信息（我方）
    seller_name         TEXT NOT NULL,    -- 销售方名称
    seller_tax_number   TEXT NOT NULL,    -- 销售方税号
    seller_bank         TEXT,             -- 销售方开户行
    seller_account      TEXT,             -- 销售方账号
    
    -- 状态
    invoice_status      TEXT DEFAULT 'PENDING',  -- PENDING/APPROVED/ISSUED/CANCELLED
    
    -- 作废关联
    cancelled_invoice_id TEXT,            -- 原发票ID(作废时关联)
    cancel_reason       TEXT,             -- 作废原因
    
    -- 审计字段
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 5. 合同变更记录 (Contract Change)
CREATE TABLE IF NOT EXISTS contract_change (
    change_id            TEXT PRIMARY KEY,
    change_no           TEXT NOT NULL UNIQUE,   -- BG-YYYY-NNNNN
    
    -- 关联
    contract_id          TEXT NOT NULL,                       -- FK→contract (逻辑外键)
    
    -- 变更信息
    change_type         TEXT NOT NULL,    -- AMOUNT/TERMS/PARTY/OTHER
    
    -- 变更内容
    old_value           TEXT,             -- 原值(JSON格式)
    change_value        TEXT,             -- 变更值(JSON格式)
    new_value           TEXT,             -- 新值(JSON格式)
    
    -- 变更原因
    reason              TEXT NOT NULL,    -- 变更原因
    
    -- 审批状态
    approval_status     TEXT DEFAULT 'PENDING',  -- PENDING/APPROVED/REJECTED
    approved_by         TEXT,             -- 审批人
    approved_date       TEXT,             -- 审批日期
    approval_comment    TEXT,             -- 审批意见
    
    -- 审计字段
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 6. 合同附件 (Contract Document)
CREATE TABLE IF NOT EXISTS contract_document (
    doc_id              TEXT PRIMARY KEY,
    doc_no              TEXT UNIQUE,      -- DOC-YYYY-NNNNN
    
    -- 关联
    contract_id          TEXT NOT NULL,                       -- FK→contract (逻辑外键)
    
    -- 文档信息
    doc_type            TEXT NOT NULL,    -- CONTRACT_SCAN/SUPPLEMENT/CORRESPONDENCE/OTHER
    doc_name            TEXT NOT NULL,    -- 原始文件名
    file_path           TEXT NOT NULL,    -- 存储路径
    file_size           INTEGER,          -- 文件大小(字节)
    
    -- 版本控制
    version             INTEGER DEFAULT 1,  -- 版本号
    
    -- 审计字段
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 7. 操作日志 (Operation Log)
CREATE TABLE IF NOT EXISTS contract_log (
    log_id              TEXT PRIMARY KEY,
    entity_type          TEXT NOT NULL,    -- CONTRACT/PAYMENT/COLLECTION/INVOICE/CHANGE/DOCUMENT
    entity_id            TEXT NOT NULL,    -- 关联实体ID
    
    -- 操作信息
    action              TEXT NOT NULL,    -- CREATE/UPDATE/STATUS_CHANGE/COLLECTION/INVOICE/DELETE
    actor_id             TEXT,                        -- FK→member.db
    actor_name           TEXT,             -- 操作人姓名（冗余便于查询）
    
    -- 变更详情
    old_value           TEXT,             -- 变更前值(JSON)
    new_value           TEXT,             -- 变更后值(JSON)
    change_summary      TEXT,             -- 变更摘要
    
    -- 上下文
    ip_address          TEXT,             -- 操作IP
    user_agent          TEXT,             -- 浏览器信息
    
    -- 时间戳
    created_at          TEXT DEFAULT (datetime('now'))
);
```

---

## 三、索引设计

```sql
-- ============================================
-- 索引
-- ============================================

-- contract 索引
CREATE INDEX IF NOT EXISTS idx_contract_no ON contract(contract_no);
CREATE INDEX IF NOT EXISTS idx_contract_name ON contract(contract_name);
CREATE INDEX IF NOT EXISTS idx_contract_project ON contract(project_id);
CREATE INDEX IF NOT EXISTS idx_contract_party_type ON contract(party_type);
CREATE INDEX IF NOT EXISTS idx_contract_party_id ON contract(party_id);
CREATE INDEX IF NOT EXISTS idx_contract_type ON contract(contract_type);
CREATE INDEX IF NOT EXISTS idx_contract_status ON contract(contract_status);
CREATE INDEX IF NOT EXISTS idx_contract_sign_date ON contract(sign_date);
CREATE INDEX IF NOT EXISTS idx_contract_expiry ON contract(expiry_date);
CREATE INDEX IF NOT EXISTS idx_contract_parent ON contract(parent_contract_id);
CREATE INDEX IF NOT EXISTS idx_contract_created ON contract(created_at);

-- contract_payment 索引
CREATE INDEX IF NOT EXISTS idx_payment_contract ON contract_payment(contract_id);
CREATE INDEX IF NOT EXISTS idx_payment_no ON contract_payment(payment_no);
CREATE INDEX IF NOT EXISTS idx_payment_status ON contract_payment(payment_status);
CREATE INDEX IF NOT EXISTS idx_payment_date ON contract_payment(payment_date);
CREATE INDEX IF NOT EXISTS idx_payment_collection ON contract_payment(collection_id);
CREATE INDEX IF NOT EXISTS idx_payment_created ON contract_payment(created_at);

-- contract_collection 索引
CREATE INDEX IF NOT EXISTS idx_collection_no ON contract_collection(collection_no);
CREATE INDEX IF NOT EXISTS idx_collection_contract ON contract_collection(contract_id);
CREATE INDEX IF NOT EXISTS idx_collection_payment ON contract_collection(payment_id);
CREATE INDEX IF NOT EXISTS idx_collection_date ON contract_collection(collection_date);
CREATE INDEX IF NOT EXISTS idx_collection_method ON contract_collection(collection_method);
CREATE INDEX IF NOT EXISTS idx_collection_created ON contract_collection(created_at);

-- contract_invoice 索引
CREATE INDEX IF NOT EXISTS idx_invoice_no ON contract_invoice(invoice_no);
CREATE INDEX IF NOT EXISTS idx_invoice_contract ON contract_invoice(contract_id);
CREATE INDEX IF NOT EXISTS idx_invoice_type ON contract_invoice(invoice_type);
CREATE INDEX IF NOT EXISTS idx_invoice_status ON contract_invoice(invoice_status);
CREATE INDEX IF NOT EXISTS idx_invoice_date ON contract_invoice(invoice_date);
CREATE INDEX IF NOT EXISTS idx_invoice_created ON contract_invoice(created_at);

-- contract_change 索引
CREATE INDEX IF NOT EXISTS idx_change_no ON contract_change(change_no);
CREATE INDEX IF NOT EXISTS idx_change_contract ON contract_change(contract_id);
CREATE INDEX IF NOT EXISTS idx_change_type ON contract_change(change_type);
CREATE INDEX IF NOT EXISTS idx_change_approval ON contract_change(approval_status);
CREATE INDEX IF NOT EXISTS idx_change_created ON contract_change(created_at);

-- contract_document 索引
CREATE INDEX IF NOT EXISTS idx_doc_contract ON contract_document(contract_id);
CREATE INDEX IF NOT EXISTS idx_doc_type ON contract_document(doc_type);
CREATE INDEX IF NOT EXISTS idx_doc_created ON contract_document(created_at);

-- contract_log 索引
CREATE INDEX IF NOT EXISTS idx_log_entity ON contract_log(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_log_actor ON contract_log(actor_id);
CREATE INDEX IF NOT EXISTS idx_log_action ON contract_log(action);
CREATE INDEX IF NOT EXISTS idx_log_created ON contract_log(created_at);
```

---

## 四、枚举值速查表

```
-- contract.contract_type (合同类型)
MAIN       -- 主合同（CRO与申办方的临床研究服务合同）
SUPPLEMENT -- 补充协议（项目范围变更/金额调整）
NDA        -- NDA（保密协议）
FRAMEWORK  -- 框架协议（长期合作框架）

-- contract.contract_status (合同状态)
DRAFT              -- 草稿
PENDING_APPROVAL  -- 待审批
PENDING_SIGN       -- 待签署
ACTIVE             -- 执行中
CHANGING          -- 变更中
EXPIRED            -- 已到期
TERMINATED        -- 已终止

-- contract.party_type (合同对方类型)
SPONSOR  -- 申办方
SMO      -- SMO公司
SITE     -- 中心
PARTNER  -- 其他合作方

-- contract_payment.payment_status (收款计划状态)
PLANNED  -- 计划中
OVERDUE  -- 逾期
PARTIAL  -- 部分收款
RECEIVED -- 已收

-- contract_collection.collection_method (收款方式)
BANK_TRANSFER -- 银行转账
CHEQUE        -- 支票
CASH          -- 现金
OTHER         -- 其他

-- contract_invoice.invoice_type (发票类型)
VAT_SPECIAL -- 增值税专用发票
VAT_NORMAL  -- 增值税普通发票

-- contract_invoice.invoice_status (发票状态)
PENDING    -- 待开票
APPROVED   -- 已审批
ISSUED     -- 已开具
CANCELLED  -- 已作废

-- contract_change.change_type (变更类型)
AMOUNT -- 金额调整
TERMS  -- 条款变更
PARTY  -- 主体变更
OTHER  -- 其他

-- contract_change.approval_status (审批状态)
PENDING   -- 待审批
APPROVED  -- 已审批
REJECTED  -- 已驳回

-- contract_document.doc_type (文档类型)
CONTRACT_SCAN    -- 合同扫描件
SUPPLEMENT       -- 补充协议文件
CORRESPONDENCE   -- 往来函件
OTHER            -- 其他

-- contract_log.action (操作类型)
CREATE        -- 创建
UPDATE        -- 更新
STATUS_CHANGE -- 状态变更
COLLECTION    -- 收款
INVOICE       -- 开票
DELETE        -- 删除
```

---

## 五、表关系说明

```
┌─────────────────┐
│    contract     │
│   (合同主表)     │
└────────┬────────┘
         │
         │ 1:N
         ├─────────────────────────┐
         │                         │
         ▼                         ▼
┌─────────────────┐     ┌─────────────────┐
│contract_payment │     │ contract_change  │
│  (收款计划)      │     │  (合同变更)      │
└────────┬────────┘     └────────┬────────┘
         │                      │
         │ 1:1                  │
         ▼                      │
┌─────────────────┐     ┌────────┴────────┐
│contract_collection│     │ contract_log   │
│   (收款记录)      │     │  (操作日志)     │
└────────┬────────┘     └─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────┐
│ contract_invoice│
│   (发票记录)     │
└─────────────────┘

跨库引用:
┌─────────────────┐
│    contract     │──project_id──→ project.db
│    contract     │─party_type──┐
│    contract     │            └→ sponsor.db/smo.db/partner.db/project.db
└─────────────────┘
```

---

## 六、编号规则

### 6.1 合同编号 (contract_no)
```
格式: HT-YYYY-NNNNN
示例: HT-2024-00001

规则:
- HT: 前缀(Contract)
- YYYY: 年份
- NNNNN: 当年流水号(00001-99999)
```

### 6.2 收款编号 (collection_no)
```
格式: SK-YYYY-NNNNN
示例: SK-2024-00001

规则:
- SK: 前缀(ShouKuan)
- YYYY: 年份
- NNNNN: 当年流水号
```

### 6.3 发票编号 (invoice_no)
```
格式: FP-YYYY-NNNNN
示例: FP-2024-00001

规则:
- FP: 前缀(FaPiao)
- YYYY: 年份
- NNNNN: 当年流水号
```

### 6.4 变更编号 (change_no)
```
格式: BG-YYYY-NNNNN
示例: BG-2024-00001

规则:
- BG: 前缀(BianGeng)
- YYYY: 年份
- NNNNN: 当年流水号
```

### 6.5 附件编号 (doc_no)
```
格式: DOC-YYYY-NNNNN
示例: DOC-2024-00001

规则:
- DOC: 前缀(DOCument)
- YYYY: 年份
- NNNNN: 当年流水号
```

---

## 七、视图定义（可选）

```sql
-- 1. 合同汇总视图（用于仪表盘）
CREATE VIEW IF NOT EXISTS v_contract_summary AS
SELECT 
    c.*,
    (SELECT COUNT(*) FROM contract_payment cp WHERE cp.contract_id = c.contract_id) AS payment_total,
    (SELECT COUNT(*) FROM contract_payment cp WHERE cp.contract_id = c.contract_id AND cp.payment_status = 'RECEIVED') AS payment_received,
    p.project_name,
    CASE c.party_type
        WHEN 'SPONSOR' THEN (SELECT sponsor_name FROM sponsor_master WHERE sponsor_id = c.party_id)
        WHEN 'SMO' THEN (SELECT smo_name FROM smo_master WHERE smo_id = c.party_id)
        WHEN 'SITE' THEN (SELECT site_name FROM project_site WHERE project_site_id = c.party_id)
        WHEN 'PARTNER' THEN (SELECT partner_name FROM partner_master WHERE partner_id = c.party_id)
    END AS party_name
FROM contract c
LEFT JOIN project p ON p.project_id = c.project_id;

-- 2. 应收未收汇总视图
CREATE VIEW IF NOT EXISTS v_pending_collection AS
SELECT 
    contract_id,
    contract_no,
    contract_name,
    party_name,
    project_name,
    contract_amount,
    collected_amount,
    pending_amount,
    contract_status,
    expiry_date,
    CASE 
        WHEN expiry_date < date('now') AND contract_status = 'ACTIVE' THEN 1 
        ELSE 0 
    END AS is_overdue
FROM v_contract_summary
WHERE contract_status IN ('ACTIVE', 'CHANGING');

-- 3. 合同统计视图（按项目）
CREATE VIEW IF NOT EXISTS v_project_contract_stats AS
SELECT 
    project_id,
    COUNT(*) AS contract_count,
    SUM(contract_amount) AS total_amount,
    SUM(collected_amount) AS total_collected,
    SUM(pending_amount) AS total_pending,
    SUM(invoiced_amount) AS total_invoiced
FROM contract
WHERE contract_status != 'TERMINATED'
GROUP BY project_id;
```

---

## 八、触发器定义（可选）

```sql
-- 1. 收款后自动更新合同已收款金额
CREATE TRIGGER IF NOT EXISTS trg_update_collected_amount
AFTER INSERT ON contract_collection
BEGIN
    UPDATE contract 
    SET 
        collected_amount = (
            SELECT COALESCE(SUM(collection_amount), 0) 
            FROM contract_collection 
            WHERE contract_id = NEW.contract_id
        ),
        pending_amount = contract_amount - (
            SELECT COALESCE(SUM(collection_amount), 0) 
            FROM contract_collection 
            WHERE contract_id = NEW.contract_id
        ),
        updated_at = datetime('now')
    WHERE contract_id = NEW.contract_id;
END;

-- 2. 开票后自动更新合同已开票金额
CREATE TRIGGER IF NOT EXISTS trg_update_invoiced_amount
AFTER INSERT ON contract_invoice
BEGIN
    UPDATE contract 
    SET 
        invoiced_amount = (
            SELECT COALESCE(SUM(invoice_amount), 0) 
            FROM contract_invoice 
            WHERE contract_id = NEW.contract_id AND invoice_status != 'CANCELLED'
        ),
        updated_at = datetime('now')
    WHERE contract_id = NEW.contract_id;
END;

-- 3. 合同状态自动更新触发器
CREATE TRIGGER IF NOT EXISTS trg_contract_status_update
AFTER UPDATE OF contract_status ON contract
BEGIN
    -- 到期检查：到期日期到达自动变更为EXPIRED
    IF NEW.expiry_date <= date('now') AND OLD.contract_status = 'ACTIVE' THEN
        UPDATE contract 
        SET contract_status = 'EXPIRED', updated_at = datetime('now')
        WHERE contract_id = NEW.contract_id;
    END IF;
END;

-- 4. 操作日志自动记录触发器
CREATE TRIGGER IF NOT EXISTS trg_contract_log
AFTER INSERT ON contract
BEGIN
    INSERT INTO contract_log (log_id, entity_type, entity_id, action, actor_id, actor_name, new_value, created_at)
    VALUES (
        lower(hex(randomblob(16))),
        'CONTRACT',
        NEW.contract_id,
        'CREATE',
        NEW.created_by,
        (SELECT name FROM member WHERE member_id = NEW.created_by),
        json_object('contract_no', NEW.contract_no, 'contract_name', NEW.contract_name, 'contract_amount', NEW.contract_amount),
        datetime('now')
    );
END;
```

---

## 九、第一版不做

- ❌ 触发器实现（第一版用应用层代码处理）
- ❌ 视图定义（按需创建）
- ❌ 附件版本控制
- ❌ 电子签章集成
- ❌ 合同履约评价

---

*文档版本 V1.0 | 2026-06-20*
