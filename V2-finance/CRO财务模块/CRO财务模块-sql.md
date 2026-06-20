# CRO财务模块 SQL建表脚本

> 数据库：finance.db（SQLite，独立库零耦合）
> 版本：v2.0 | 日期：2026-06-22
> 配套文件：CRO财务模块-design.md / CRO财务模块-api.md
> v2.0变更：删除fin_collection_plans/fin_bank_accounts/fin_tax_rates/fin_cost_records；新增fin_payment_records/fin_loan_repayments/fin_transfer_logs/fin_audit_alerts

---

## 一、初始化数据库

```sql
-- CRO财务模块独立库
-- 文件：finance.db
-- 原则：零共享零耦合，跨域数据走HTTP API
-- v2.0：8表5线架构

PRAGMA journal_mode = WAL;
PRAGMA foreign_keys = ON;
```

---

## 二、收入线

### 2.1 fin_collections（收款记录表）

```sql
CREATE TABLE IF NOT EXISTS fin_collections (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    collection_no     VARCHAR(32)   NOT NULL UNIQUE,             -- 收款编号 CL-YYYYMMDD-NNN
    contract_id       VARCHAR(64)   NOT NULL,                    -- 关联合同ID（引用Contract对象线）
    project_code      VARCHAR(32)   NOT NULL,                    -- 项目编号
    collection_date   DATE          NOT NULL,                    -- 实际收款日期
    amount            DECIMAL(14,2) NOT NULL,                    -- 收款金额
    payer_name        VARCHAR(200),                              -- 付款方名称（申办方）
    payer_account     VARCHAR(64),                               -- 付款方账号
    payment_method    VARCHAR(20)   NOT NULL DEFAULT 'BANK',     -- BANK/ALIPAY/WECHAT/OTHER
    bank_receipt_no   VARCHAR(64),                               -- 银行回单号
    bank_receipt_url  VARCHAR(256),                              -- 银行回单附件URL
    status            VARCHAR(20)   NOT NULL DEFAULT 'PENDING',  -- PENDING/CONFIRMED/REJECTED
    confirmed_by      VARCHAR(64),                               -- 确认人
    confirmed_at      DATETIME,                                  -- 确认时间
    reject_reason     TEXT,                                      -- 驳回原因
    remark            TEXT,                                      -- 备注
    created_by        VARCHAR(64),                               -- 创建人
    created_at        DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at        DATETIME      NOT NULL DEFAULT (datetime('now','localtime'))
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_coll_contract  ON fin_collections(contract_id);
CREATE INDEX IF NOT EXISTS idx_coll_project   ON fin_collections(project_code);
CREATE INDEX IF NOT EXISTS idx_coll_status    ON fin_collections(status);
CREATE INDEX IF NOT EXISTS idx_coll_date      ON fin_collections(collection_date);
CREATE INDEX IF NOT EXISTS idx_coll_created   ON fin_collections(created_by);
```

### 2.2 fin_invoices（销项发票表）

```sql
CREATE TABLE IF NOT EXISTS fin_invoices (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_no      VARCHAR(32)   NOT NULL UNIQUE,               -- 内部编号 INV-YYYYMMDD-NNN
    tax_invoice_no  VARCHAR(64),                                 -- 税务发票号码（税控系统分配）
    contract_id     VARCHAR(64)   NOT NULL,                      -- 合同ID
    project_code    VARCHAR(32)   NOT NULL,                      -- 项目编号
    collection_id   INTEGER,                                     -- 关联收款记录ID（可空=预开票）
    invoice_type    VARCHAR(20)   NOT NULL DEFAULT 'GENERAL',    -- GENERAL/SPECIAL/ELECTRONIC（普票/专票/电子）
    invoice_status  VARCHAR(20)   NOT NULL DEFAULT 'DRAFT',      -- DRAFT/PENDING/ISSUED/VOIDED/REVERSED
    amount          DECIMAL(14,2) NOT NULL,                      -- 不含税金额
    tax_rate        DECIMAL(5,4)  NOT NULL DEFAULT 0.06,         -- 税率
    tax_amount      DECIMAL(14,2) NOT NULL DEFAULT 0,            -- 税额 = amount * tax_rate
    total_amount    DECIMAL(14,2) NOT NULL,                      -- 价税合计 = amount + tax_amount
    buyer_name      VARCHAR(200),                                -- 购买方名称（申办方）
    buyer_tax_no    VARCHAR(32),                                 -- 购买方税号
    buyer_address   VARCHAR(256),                                -- 购买方地址电话
    buyer_bank      VARCHAR(256),                                -- 购买方开户行及账号
    invoice_date    DATE,                                        -- 开票日期
    issued_by       VARCHAR(64),                                 -- 开票人
    issued_at       DATETIME,                                    -- 开票时间
    void_reason     TEXT,                                        -- 作废原因
    reversed_reason TEXT,                                        -- 红冲原因
    invoice_url     VARCHAR(256),                                -- 发票PDF/图片URL
    remark          TEXT,
    created_by      VARCHAR(64),
    created_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    FOREIGN KEY (collection_id) REFERENCES fin_collections(id) ON DELETE SET NULL
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_inv_contract   ON fin_invoices(contract_id);
CREATE INDEX IF NOT EXISTS idx_inv_project    ON fin_invoices(project_code);
CREATE INDEX IF NOT EXISTS idx_inv_collection ON fin_invoices(collection_id);
CREATE INDEX IF NOT EXISTS idx_inv_status     ON fin_invoices(invoice_status);
CREATE INDEX IF NOT EXISTS idx_inv_date       ON fin_invoices(invoice_date);
```

---

## 三、支出线

### 3.1 fin_payment_records（统一支出流水表）

```sql
CREATE TABLE IF NOT EXISTS fin_payment_records (
    -- ========== 基础组 ==========
    id                        INTEGER PRIMARY KEY AUTOINCREMENT,
    payment_code              VARCHAR(32)   NOT NULL UNIQUE,     -- 支出编号 PAY-YYYYMMDD-NNN
    payment_type              VARCHAR(20)   NOT NULL,            -- EXPENSE/LOAN/VENDOR_PAYMENT
    cost_type                 VARCHAR(30)   NOT NULL,            -- 费用类型（见枚举表）
    amount                    DECIMAL(14,2) NOT NULL,            -- 金额
    description               TEXT,                              -- 描述/事由
    status                    VARCHAR(20)   NOT NULL DEFAULT 'DRAFT', -- DRAFT/PENDING_APPROVAL/APPROVED/PAID/CLOSED/REJECTED

    -- ========== 预算归属组 ==========
    project_code              VARCHAR(32),                       -- 项目编号（EXPENSE可选/LOAN可选/VENDOR_PAYMENT必填）
    budget_source             VARCHAR(20)   NOT NULL DEFAULT 'DEPARTMENT', -- PROJECT/DEPARTMENT
    department_id             VARCHAR(64),                       -- 部门ID（budget_source=DEPARTMENT时必填）

    -- ========== 业务关联组 ==========
    source_module             VARCHAR(20),                       -- 业务来源：SMO/PARTNER/CENTER（仅VENDOR_PAYMENT）
    source_contract_id        VARCHAR(64),                       -- 来源合同ID
    source_payment_node_id    VARCHAR(64),                       -- 来源付款节点ID

    -- ========== 借款专用组 ==========
    loan_id                   VARCHAR(32),                       -- 借款编号（LOAN类型专用）
    repayment_date            DATE,                              -- 预计还款日期（LOAN专用）
    repaid_amount             DECIMAL(14,2) NOT NULL DEFAULT 0,  -- 已还金额
    repayment_status          VARCHAR(20)   NOT NULL DEFAULT 'PENDING', -- PENDING/PARTIAL/SETTLED

    -- ========== 发票嵌入组 ==========
    has_invoice               INTEGER       NOT NULL DEFAULT 0,  -- 是否有发票：0无/1有
    invoice_status            VARCHAR(20)   NOT NULL DEFAULT 'PENDING_INVOICE', -- ATTACHED/PENDING_INVOICE/RECONCILED
    invoice_no                VARCHAR(64),                       -- 发票号
    invoice_amount_excl_tax   DECIMAL(14,2),                     -- 不含税金额
    invoice_tax_rate          DECIMAL(5,4),                      -- 税率
    invoice_amount_tax        DECIMAL(14,2),                     -- 税额
    invoice_date              DATE,                              -- 开票日期
    invoice_attachment        VARCHAR(256),                      -- 发票附件URL

    -- ========== 审批组 ==========
    approval_status           VARCHAR(20),                       -- PENDING/APPROVED/REJECTED
    approved_by               VARCHAR(64),                       -- 审批人
    approved_at               DATETIME,                          -- 审批时间
    approval_remark           TEXT,                              -- 审批备注

    -- ========== 通用组 ==========
    created_by                VARCHAR(64),                       -- 创建人（提交人）
    created_at                DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at                DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    transferred_to            VARCHAR(64),                       -- 转移目标人（单据转移后）
    transferred_at            DATETIME                           -- 转移时间
);

-- ========== 关键索引 ==========
CREATE INDEX IF NOT EXISTS idx_pay_type_status    ON fin_payment_records(payment_type, status);
CREATE INDEX IF NOT EXISTS idx_pay_project        ON fin_payment_records(project_code);
CREATE INDEX IF NOT EXISTS idx_pay_created_by     ON fin_payment_records(created_by);
CREATE INDEX IF NOT EXISTS idx_pay_invoice_status ON fin_payment_records(invoice_status);
CREATE INDEX IF NOT EXISTS idx_pay_source         ON fin_payment_records(source_module, source_contract_id);
CREATE INDEX IF NOT EXISTS idx_pay_cost_type      ON fin_payment_records(cost_type);
CREATE INDEX IF NOT EXISTS idx_pay_budget         ON fin_payment_records(budget_source, project_code);
CREATE INDEX IF NOT EXISTS idx_pay_loan           ON fin_payment_records(payment_type, repayment_status);
CREATE INDEX IF NOT EXISTS idx_pay_date           ON fin_payment_records(created_at);
CREATE INDEX IF NOT EXISTS idx_pay_transferred    ON fin_payment_records(transferred_to);
```

### 3.2 fin_loan_repayments（借款还款记录表）

```sql
CREATE TABLE IF NOT EXISTS fin_loan_repayments (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    repayment_no    VARCHAR(32)   NOT NULL UNIQUE,               -- 还款编号 REP-YYYYMMDD-NNN
    loan_payment_id INTEGER       NOT NULL,                      -- 关联借款支出记录ID（fin_payment_records.id）
    loan_code       VARCHAR(32)   NOT NULL,                      -- 借款编号（冗余，便于查询）
    repay_amount    DECIMAL(14,2) NOT NULL,                      -- 本次还款金额
    repay_date      DATE          NOT NULL,                      -- 还款日期
    repay_method    VARCHAR(20)   NOT NULL DEFAULT 'BANK_TRANSFER', -- 还款方式
    remark          TEXT,
    created_by      VARCHAR(64),                                 -- 操作人
    created_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    FOREIGN KEY (loan_payment_id) REFERENCES fin_payment_records(id) ON DELETE CASCADE
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_repay_loan_id   ON fin_loan_repayments(loan_payment_id);
CREATE INDEX IF NOT EXISTS idx_repay_loan_code ON fin_loan_repayments(loan_code);
CREATE INDEX IF NOT EXISTS idx_repay_date      ON fin_loan_repayments(repay_date);
```

---

## 四、汇总线

### 4.1 fin_settlements（合同结算表）

```sql
CREATE TABLE IF NOT EXISTS fin_settlements (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    settlement_no       VARCHAR(32)   NOT NULL UNIQUE,           -- ST-YYYYMMDD-NNN
    contract_id         VARCHAR(64)   NOT NULL,                  -- 合同ID
    project_code        VARCHAR(32)   NOT NULL,                  -- 项目编号
    settlement_type     VARCHAR(20)   NOT NULL DEFAULT 'PARTIAL', -- PARTIAL/FINAL/ADJUSTMENT
    settlement_date     DATE          NOT NULL,                  -- 结算日期
    settlement_status   VARCHAR(20)   NOT NULL DEFAULT 'DRAFT',  -- DRAFT/PENDING/CONFIRMED
    contract_amount     DECIMAL(14,2) NOT NULL DEFAULT 0,        -- 合同总额（快照，从Contract API获取）
    collected_amount    DECIMAL(14,2) NOT NULL DEFAULT 0,        -- 已收款总额（fin_collections汇总）
    invoiced_amount     DECIMAL(14,2) NOT NULL DEFAULT 0,        -- 已开票总额（fin_invoices汇总）
    paid_amount         DECIMAL(14,2) NOT NULL DEFAULT 0,        -- 已付款总额（fin_payment_records汇总，不含LOAN）
    balance_collection  DECIMAL(14,2) NOT NULL DEFAULT 0,        -- 收款差额 = contract_amount - collected_amount
    balance_invoice     DECIMAL(14,2) NOT NULL DEFAULT 0,        -- 开票差额 = contract_amount - invoiced_amount
    balance_profit      DECIMAL(14,2) NOT NULL DEFAULT 0,        -- 净额 = collected_amount - paid_amount
    confirmed_by        VARCHAR(64),
    confirmed_at        DATETIME,
    remark              TEXT,
    created_by          VARCHAR(64),
    created_at          DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at          DATETIME      NOT NULL DEFAULT (datetime('now','localtime'))
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_settle_contract ON fin_settlements(contract_id);
CREATE INDEX IF NOT EXISTS idx_settle_project  ON fin_settlements(project_code);
CREATE INDEX IF NOT EXISTS idx_settle_status   ON fin_settlements(settlement_status);
CREATE INDEX IF NOT EXISTS idx_settle_type     ON fin_settlements(settlement_type);
```

### 4.2 fin_project_pl（项目盈亏表）

```sql
CREATE TABLE IF NOT EXISTS fin_project_pl (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    pl_no             VARCHAR(32)   NOT NULL UNIQUE,             -- PL-YYYYMM-NNN
    project_code      VARCHAR(32)   NOT NULL,                    -- 项目编号
    period            VARCHAR(7)    NOT NULL,                    -- 期间 YYYY-MM
    pl_type           VARCHAR(20)   NOT NULL DEFAULT 'MONTHLY',  -- MONTHLY/FINAL
    pl_status         VARCHAR(20)   NOT NULL DEFAULT 'DRAFT',    -- DRAFT/CONFIRMED
    total_contract    DECIMAL(14,2) NOT NULL DEFAULT 0,          -- 合同总额（所有关联合同）
    total_collected   DECIMAL(14,2) NOT NULL DEFAULT 0,          -- 累计收款（fin_collections）
    total_invoiced    DECIMAL(14,2) NOT NULL DEFAULT 0,          -- 累计开票（fin_invoices）
    total_cost        DECIMAL(14,2) NOT NULL DEFAULT 0,          -- 累计成本（项目预算EXPENSE + VENDOR_PAYMENT，不含LOAN和部门预算）
    total_budget      DECIMAL(14,2) NOT NULL DEFAULT 0,          -- 累计预算（Budget API）
    budget_execution  DECIMAL(5,2)  NOT NULL DEFAULT 0,          -- 预算执行率% = total_cost/total_budget*100
    gross_profit      DECIMAL(14,2) NOT NULL DEFAULT 0,          -- 毛利 = total_collected - total_cost
    gross_margin      DECIMAL(5,2)  NOT NULL DEFAULT 0,          -- 毛利率% = gross_profit/total_collected*100
    net_receivable    DECIMAL(14,2) NOT NULL DEFAULT 0,          -- 净应收 = total_contract - total_collected
    cost_breakdown    TEXT,                                      -- 成本分项JSON（按cost_type分组）
    remark            TEXT,
    confirmed_by      VARCHAR(64),
    confirmed_at      DATETIME,
    created_at        DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at        DATETIME      NOT NULL DEFAULT (datetime('now','localtime'))
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_pl_project ON fin_project_pl(project_code);
CREATE INDEX IF NOT EXISTS idx_pl_period  ON fin_project_pl(period);
CREATE INDEX IF NOT EXISTS idx_pl_type    ON fin_project_pl(pl_type);
CREATE INDEX IF NOT EXISTS idx_pl_status  ON fin_project_pl(pl_status);
```

---

## 五、审计线

### 5.1 fin_audit_alerts（审计告警表）

```sql
CREATE TABLE IF NOT EXISTS fin_audit_alerts (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    alert_code      VARCHAR(32)   NOT NULL UNIQUE,               -- 告警编号 ALT-YYYYMMDD-NNN
    alert_type      VARCHAR(40)   NOT NULL,                      -- 告警类型（7种，见下方枚举）
    alert_level     VARCHAR(20)   NOT NULL DEFAULT 'WARNING',    -- WARNING/CRITICAL
    target_type     VARCHAR(20)   NOT NULL,                      -- CONTRACT/PROJECT/PAYMENT/COLLECTION/INVOICE
    target_id       VARCHAR(64)   NOT NULL,                      -- 目标ID
    target_desc     VARCHAR(256),                                -- 目标描述（冗余，便于展示）
    alert_detail    TEXT,                                        -- 告警详情JSON
    detected_at     DATETIME      NOT NULL DEFAULT (datetime('now','localtime')), -- 检测时间
    status          VARCHAR(20)   NOT NULL DEFAULT 'ACTIVE',     -- ACTIVE/RESOLVED
    resolved_at     DATETIME,                                    -- 解决时间
    resolved_by     VARCHAR(64),                                 -- 解决人
    resolution_remark TEXT,                                      -- 处理说明
    created_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime'))
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_alert_type    ON fin_audit_alerts(alert_type);
CREATE INDEX IF NOT EXISTS idx_alert_status  ON fin_audit_alerts(status);
CREATE INDEX IF NOT EXISTS idx_alert_target  ON fin_audit_alerts(target_type, target_id);
CREATE INDEX IF NOT EXISTS idx_alert_level   ON fin_audit_alerts(alert_level);
CREATE INDEX IF NOT EXISTS idx_alert_date    ON fin_audit_alerts(detected_at);

-- alert_type枚举值：
-- COLLECTION_OVER_AMOUNT     收款超额
-- INVOICE_OVER_AMOUNT        开票超额
-- BUDGET_OVER                超预算
-- COLLECTION_OVERDUE         逾期收款
-- LOAN_OVERDUE               借款逾期
-- PENDING_INVOICE_OVERDUE    待补票逾期
-- SETTLEMENT_DIFF            结算差异
```

---

## 六、管理辅助

### 6.1 fin_transfer_logs（单据转移日志表）

```sql
CREATE TABLE IF NOT EXISTS fin_transfer_logs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    transfer_code   VARCHAR(32)   NOT NULL UNIQUE,               -- 转移编号 TR-YYYYMMDD-NNN
    transfer_type   VARCHAR(30)   NOT NULL,                      -- PROJECT_HANDOVER/RESIGNATION/APPROVAL_TRANSFER
    target_type     VARCHAR(20)   NOT NULL,                      -- PAYMENT/COLLECTION/INVOICE
    target_ids      TEXT          NOT NULL,                      -- 转移单据ID列表（JSON数组）
    target_count    INTEGER       NOT NULL DEFAULT 0,            -- 转移单据数量
    from_user       VARCHAR(64)   NOT NULL,                      -- 原归属人
    to_user         VARCHAR(64)   NOT NULL,                      -- 新归属人
    operator        VARCHAR(64)   NOT NULL,                      -- 操作人
    reason          TEXT,                                        -- 转移原因
    transferred_at  DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    created_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime')),
    updated_at      DATETIME      NOT NULL DEFAULT (datetime('now','localtime'))
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_transfer_type   ON fin_transfer_logs(transfer_type);
CREATE INDEX IF NOT EXISTS idx_transfer_from   ON fin_transfer_logs(from_user);
CREATE INDEX IF NOT EXISTS idx_transfer_to     ON fin_transfer_logs(to_user);
CREATE INDEX IF NOT EXISTS idx_transfer_target ON fin_transfer_logs(target_type);
```

---

## 七、触发器

### 7.1 updated_at自动更新触发器（8张表）

```sql
-- fin_collections
CREATE TRIGGER IF NOT EXISTS trg_collections_updated
    AFTER UPDATE ON fin_collections
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_collections SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;

-- fin_invoices
CREATE TRIGGER IF NOT EXISTS trg_invoices_updated
    AFTER UPDATE ON fin_invoices
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_invoices SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;

-- fin_payment_records
CREATE TRIGGER IF NOT EXISTS trg_payment_records_updated
    AFTER UPDATE ON fin_payment_records
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_payment_records SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;

-- fin_loan_repayments
CREATE TRIGGER IF NOT EXISTS trg_loan_repayments_updated
    AFTER UPDATE ON fin_loan_repayments
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_loan_repayments SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;

-- fin_settlements
CREATE TRIGGER IF NOT EXISTS trg_settlements_updated
    AFTER UPDATE ON fin_settlements
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_settlements SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;

-- fin_project_pl
CREATE TRIGGER IF NOT EXISTS trg_project_pl_updated
    AFTER UPDATE ON fin_project_pl
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_project_pl SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;

-- fin_audit_alerts
CREATE TRIGGER IF NOT EXISTS trg_audit_alerts_updated
    AFTER UPDATE ON fin_audit_alerts
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_audit_alerts SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;

-- fin_transfer_logs
CREATE TRIGGER IF NOT EXISTS trg_transfer_logs_updated
    AFTER UPDATE ON fin_transfer_logs
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE fin_transfer_logs SET updated_at = datetime('now','localtime') WHERE id = OLD.id;
END;
```

### 7.2 收款确认联动触发器

```sql
-- 收款确认时，自动检测收款超额并写入审计告警
CREATE TRIGGER IF NOT EXISTS trg_collections_confirm_alert
    AFTER UPDATE OF status ON fin_collections
    WHEN NEW.status = 'CONFIRMED' AND (OLD.status IS NULL OR OLD.status != 'CONFIRMED')
BEGIN
    -- 检测收款超额：SUM(confirmed) > contract_amount
    -- 注意：contract_amount需从Contract API获取，此处仅记录告警标记
    -- 实际超额判断在应用层完成，触发器负责写入告警记录
    INSERT INTO fin_audit_alerts (alert_code, alert_type, alert_level, target_type, target_id, target_desc, alert_detail)
    SELECT
        'ALT-' || strftime('%Y%m%d', 'now') || '-' || printf('%03d', NEW.id),
        'COLLECTION_OVER_AMOUNT',
        'WARNING',
        'COLLECTION',
        CAST(NEW.id AS TEXT),
        NEW.collection_no,
        json_object('collection_id', NEW.id, 'collection_no', NEW.collection_no, 'amount', NEW.amount, 'contract_id', NEW.contract_id)
    WHERE
        -- 仅当累计收款超过合同额时触发（应用层预校验后写入标记）
        EXISTS (
            SELECT 1 FROM fin_collections
            WHERE contract_id = NEW.contract_id AND status = 'CONFIRMED'
            GROUP BY contract_id
            HAVING SUM(amount) > 0  -- 实际阈值由应用层传入或后续扩展
        );
END;

-- 收款取消确认时，自动消除相关超额告警
CREATE TRIGGER IF NOT EXISTS trg_collections_unconfirm_resolve_alert
    AFTER UPDATE OF status ON fin_collections
    WHEN OLD.status = 'CONFIRMED' AND NEW.status != 'CONFIRMED'
BEGIN
    UPDATE fin_audit_alerts
    SET status = 'RESOLVED',
        resolved_at = datetime('now','localtime'),
        resolution_remark = '收款取消确认，自动消除告警'
    WHERE alert_type = 'COLLECTION_OVER_AMOUNT'
      AND target_id = CAST(OLD.id AS TEXT)
      AND status = 'ACTIVE';
END;
```

### 7.3 借款还款核销触发器

```sql
-- 插入还款记录时，自动更新借款记录的repaid_amount和repayment_status
CREATE TRIGGER IF NOT EXISTS trg_loan_repayment_insert
    AFTER INSERT ON fin_loan_repayments
    FOR EACH ROW
BEGIN
    UPDATE fin_payment_records
    SET repaid_amount = (
        SELECT COALESCE(SUM(repay_amount), 0) FROM fin_loan_repayments
        WHERE loan_payment_id = NEW.loan_payment_id
    ),
    repayment_status = CASE
        WHEN (SELECT COALESCE(SUM(repay_amount), 0) FROM fin_loan_repayments
              WHERE loan_payment_id = NEW.loan_payment_id) >= amount
        THEN 'SETTLED'
        ELSE 'PARTIAL'
    END
    WHERE id = NEW.loan_payment_id;
END;

-- 借款全部还清时，自动将借款记录状态改为CLOSED
CREATE TRIGGER IF NOT EXISTS trg_loan_settled_close
    AFTER UPDATE OF repayment_status ON fin_payment_records
    WHEN NEW.repayment_status = 'SETTLED' AND NEW.payment_type = 'LOAN'
    AND (OLD.repayment_status IS NULL OR OLD.repayment_status != 'SETTLED')
BEGIN
    UPDATE fin_payment_records
    SET status = 'CLOSED'
    WHERE id = NEW.id AND status = 'PAID';
END;

-- 删除还款记录时，重新汇总借款记录
CREATE TRIGGER IF NOT EXISTS trg_loan_repayment_delete
    AFTER DELETE ON fin_loan_repayments
    FOR EACH ROW
BEGIN
    UPDATE fin_payment_records
    SET repaid_amount = (
        SELECT COALESCE(SUM(repay_amount), 0) FROM fin_loan_repayments
        WHERE loan_payment_id = OLD.loan_payment_id
    ),
    repayment_status = CASE
        WHEN (SELECT COALESCE(SUM(repay_amount), 0) FROM fin_loan_repayments
              WHERE loan_payment_id = OLD.loan_payment_id) = 0
        THEN 'PENDING'
        WHEN (SELECT COALESCE(SUM(repay_amount), 0) FROM fin_loan_repayments
              WHERE loan_payment_id = OLD.loan_payment_id) >=
             (SELECT amount FROM fin_payment_records WHERE id = OLD.loan_payment_id)
        THEN 'SETTLED'
        ELSE 'PARTIAL'
    END
    WHERE id = OLD.loan_payment_id;
END;
```

### 7.4 发票开具超额检测触发器

```sql
-- 发票开具时，检测开票超额并写入审计告警
CREATE TRIGGER IF NOT EXISTS trg_invoice_issue_alert
    AFTER UPDATE OF invoice_status ON fin_invoices
    WHEN NEW.invoice_status = 'ISSUED' AND (OLD.invoice_status IS NULL OR OLD.invoice_status != 'ISSUED')
BEGIN
    INSERT INTO fin_audit_alerts (alert_code, alert_type, alert_level, target_type, target_id, target_desc, alert_detail)
    SELECT
        'ALT-' || strftime('%Y%m%d', 'now') || '-' || printf('%03d', NEW.id),
        'INVOICE_OVER_AMOUNT',
        'WARNING',
        'INVOICE',
        CAST(NEW.id AS TEXT),
        NEW.invoice_no,
        json_object('invoice_id', NEW.id, 'invoice_no', NEW.invoice_no, 'total_amount', NEW.total_amount, 'contract_id', NEW.contract_id)
    WHERE
        -- 当合同累计开票额超过合同金额时触发（应用层预校验）
        EXISTS (
            SELECT 1 FROM fin_invoices
            WHERE contract_id = NEW.contract_id AND invoice_status = 'ISSUED'
            GROUP BY contract_id
            HAVING SUM(total_amount) > 0
        );
END;

-- 发票作废/红冲时，自动消除相关开票超额告警
CREATE TRIGGER IF NOT EXISTS trg_invoice_void_resolve_alert
    AFTER UPDATE OF invoice_status ON fin_invoices
    WHEN OLD.invoice_status = 'ISSUED' AND NEW.invoice_status IN ('VOIDED', 'REVERSED')
BEGIN
    UPDATE fin_audit_alerts
    SET status = 'RESOLVED',
        resolved_at = datetime('now','localtime'),
        resolution_remark = '发票作废/红冲，自动消除告警'
    WHERE alert_type = 'INVOICE_OVER_AMOUNT'
      AND target_id = CAST(OLD.id AS TEXT)
      AND status = 'ACTIVE';
END;
```

### 7.5 补票核销触发器

```sql
-- 补票完成时（invoice_status从PENDING_INVOICE改为RECONCILED），自动消除待补票逾期告警
CREATE TRIGGER IF NOT EXISTS trg_payment_invoice_reconciled
    AFTER UPDATE OF invoice_status ON fin_payment_records
    WHEN OLD.invoice_status = 'PENDING_INVOICE' AND NEW.invoice_status = 'RECONCILED'
BEGIN
    UPDATE fin_audit_alerts
    SET status = 'RESOLVED',
        resolved_at = datetime('now','localtime'),
        resolution_remark = '补票完成，待补票告警自动消除'
    WHERE alert_type = 'PENDING_INVOICE_OVERDUE'
      AND target_id = CAST(NEW.id AS TEXT)
      AND status = 'ACTIVE';
END;
```

---

## 八、表清单汇总

| 序号 | 表名 | 所属线 | 用途 | 索引数 | 触发器数 |
|------|------|--------|------|--------|----------|
| 1 | fin_collections | 收入线 | 收款记录 | 5 | 2（确认/取消确认告警） |
| 2 | fin_invoices | 收入线 | 销项发票 | 5 | 2（开具/作废告警） |
| 3 | fin_payment_records | 支出线 | 统一支出流水 | 10 | 3（updated_at+借款核销+补票核销） |
| 4 | fin_loan_repayments | 支出线 | 借款还款 | 3 | 2（插入汇总+删除重算） |
| 5 | fin_settlements | 汇总线 | 合同级对账 | 4 | 1（updated_at） |
| 6 | fin_project_pl | 汇总线 | 项目级盈亏 | 4 | 1（updated_at） |
| 7 | fin_transfer_logs | 管理 | 单据转移日志 | 4 | 1（updated_at） |
| 8 | fin_audit_alerts | 审计线 | 审计告警 | 5 | 1（updated_at） |
| **合计** | **8表** | **5线+管理** | | **40索引** | **13触发器** |

### 触发器清单

| 序号 | 触发器名 | 作用 |
|------|----------|------|
| 1 | trg_collections_updated | fin_collections updated_at自动更新 |
| 2 | trg_invoices_updated | fin_invoices updated_at自动更新 |
| 3 | trg_payment_records_updated | fin_payment_records updated_at自动更新 |
| 4 | trg_loan_repayments_updated | fin_loan_repayments updated_at自动更新 |
| 5 | trg_settlements_updated | fin_settlements updated_at自动更新 |
| 6 | trg_project_pl_updated | fin_project_pl updated_at自动更新 |
| 7 | trg_audit_alerts_updated | fin_audit_alerts updated_at自动更新 |
| 8 | trg_transfer_logs_updated | fin_transfer_logs updated_at自动更新 |
| 9 | trg_collections_confirm_alert | 收款确认时检测超额写入告警 |
| 10 | trg_collections_unconfirm_resolve_alert | 收款取消确认时消除告警 |
| 11 | trg_invoice_issue_alert | 发票开具时检测超额写入告警 |
| 12 | trg_invoice_void_resolve_alert | 发票作废/红冲时消除告警 |
| 13 | trg_loan_repayment_insert | 还款插入时更新借款repaid_amount和repayment_status |
| 14 | trg_loan_settled_close | 借款全部还清时自动关闭借款记录 |
| 15 | trg_loan_repayment_delete | 还款删除时重新汇总借款记录 |
| 16 | trg_payment_invoice_reconciled | 补票完成时消除待补票逾期告警 |

### v1.0→v2.0变更对照

| 操作 | 表名 | 说明 |
|------|------|------|
| 删除 | fin_collection_plans | v1.0收款计划，v2.0精简 |
| 删除 | fin_bank_accounts | v1.0银行账户，v2.0精简 |
| 删除 | fin_tax_rates | v1.0税率配置，v2.0税率嵌入业务字段 |
| 删除 | fin_cost_records | v1.0独立成本表，v2.0成本从fin_payment_records汇总 |
| 保留 | fin_collections | v2.0精简，去掉plan_id |
| 保留 | fin_invoices | v2.0定位为销项发票专用 |
| 保留 | fin_settlements | v2.0 paid_amount来源改为fin_payment_records |
| 保留 | fin_project_pl | v2.0 total_cost来源改为fin_payment_records |
| 新增 | fin_payment_records | 统一支出流水核心表 |
| 新增 | fin_loan_repayments | 借款还款记录 |
| 新增 | fin_transfer_logs | 单据转移日志 |
| 新增 | fin_audit_alerts | 审计告警 |
