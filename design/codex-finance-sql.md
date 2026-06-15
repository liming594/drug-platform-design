# 财务模块 SQL建表脚本

> 数据库：budget.db（7表）+ finance.db（7表），双库独立零耦合
> 版本：V1.0 2026-06-14

---

## 一、budget.db（第9号线 预算及执行）

### 1. 费用类别字典

```sql
CREATE TABLE IF NOT EXISTS budget_category (
    category_id    TEXT PRIMARY KEY,
    category_code  TEXT UNIQUE NOT NULL,
    category_name  TEXT NOT NULL,
    category_group TEXT NOT NULL,            -- DIRECT/INDIRECT 直接成本/间接成本
    cost_type     TEXT NOT NULL,            -- AUTO/MANUAL 自动计算/手动录入
    is_active     INTEGER DEFAULT 1,
    sort_order    INTEGER DEFAULT 0,
    created_at    TEXT DEFAULT (datetime('now'))
);
```

### 2. 预算主表

```sql
CREATE TABLE IF NOT EXISTS budget (
    budget_id     TEXT PRIMARY KEY,
    budget_type   TEXT NOT NULL,             -- PROJECT/DEPARTMENT
    ref_id        TEXT NOT NULL,             -- 项目→project_id, 部门→department_id
    ref_name      TEXT NOT NULL,             -- 项目名/部门名（冗余展示用）
    fiscal_year   INTEGER NOT NULL,
    total_budget  REAL NOT NULL DEFAULT 0,   -- 预算总额（从budget_item汇总）
    status        TEXT NOT NULL DEFAULT 'DRAFT', -- DRAFT/SUBMITTED/APPROVING/APPROVED/REJECTED/CHANGING/CLOSED
    version       INTEGER NOT NULL DEFAULT 1,
    description   TEXT,
    created_by    TEXT,
    created_at    TEXT DEFAULT (datetime('now')),
    updated_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(budget_type, ref_id, fiscal_year, version)
);

CREATE INDEX IF NOT EXISTS idx_budget_type ON budget(budget_type);
CREATE INDEX IF NOT EXISTS idx_budget_status ON budget(status);
CREATE INDEX IF NOT EXISTS idx_budget_ref ON budget(ref_id);
```

### 3. 预算项明细

```sql
CREATE TABLE IF NOT EXISTS budget_item (
    item_id       TEXT PRIMARY KEY,
    budget_id     TEXT NOT NULL,             -- FK→budget
    category_id   TEXT NOT NULL,             -- FK→budget_category
    sub_name      TEXT,                      -- 子项名称（如"Q1差旅"、"年度外包"）
    budget_amount REAL NOT NULL,             -- 预算金额（元）
    remark        TEXT,
    created_at    TEXT DEFAULT (datetime('now')),
    updated_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(budget_id, category_id, sub_name)
);

CREATE INDEX IF NOT EXISTS idx_bi_budget ON budget_item(budget_id);
```

### 4. 审批日志

```sql
CREATE TABLE IF NOT EXISTS budget_approval_log (
    log_id        TEXT PRIMARY KEY,
    budget_id     TEXT NOT NULL,
    version       INTEGER NOT NULL,
    action        TEXT NOT NULL,             -- SUBMIT/APPROVE/REJECT/CHANGE_REQUEST/CLOSE
    actor_id      TEXT NOT NULL,
    actor_name    TEXT NOT NULL,
    actor_role    TEXT NOT NULL,             -- SUBMITTER/APPROVER/FINANCE/ADMIN
    comment       TEXT,
    created_at    TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_bal_budget ON budget_approval_log(budget_id);
```

### 5. 预算变更记录

```sql
CREATE TABLE IF NOT EXISTS budget_change (
    change_id     TEXT PRIMARY KEY,
    budget_id     TEXT NOT NULL,
    from_version  INTEGER NOT NULL,
    to_version    INTEGER NOT NULL,
    change_type   TEXT NOT NULL,             -- INCREASE/DECREASE/ADJUST/REALLOCATE
    change_reason TEXT NOT NULL,
    total_change  REAL NOT NULL DEFAULT 0,
    status        TEXT NOT NULL DEFAULT 'PENDING', -- PENDING/APPROVED/REJECTED
    created_by    TEXT,
    created_at    TEXT DEFAULT (datetime('now')),
    approved_at   TEXT,
    approved_by   TEXT
);

CREATE INDEX IF NOT EXISTS idx_bc_budget ON budget_change(budget_id);
```

### 6. 执行汇总快照

```sql
CREATE TABLE IF NOT EXISTS budget_execution (
    exec_id       TEXT PRIMARY KEY,
    budget_id     TEXT NOT NULL,
    category_id   TEXT NOT NULL,             -- FK→budget_category
    budget_amount REAL NOT NULL DEFAULT 0,
    actual_amount REAL NOT NULL DEFAULT 0,
    variance      REAL NOT NULL DEFAULT 0,
    exec_rate     REAL NOT NULL DEFAULT 0,
    snapshot_date TEXT NOT NULL,
    source_type   TEXT NOT NULL,             -- AUTO_LABOR/AUTO_COST/MANUAL
    created_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(budget_id, category_id, snapshot_date)
);

CREATE INDEX IF NOT EXISTS idx_be_budget ON budget_execution(budget_id);
CREATE INDEX IF NOT EXISTS idx_be_date ON budget_execution(snapshot_date);
```

### 7. 费用明细记录

```sql
CREATE TABLE IF NOT EXISTS cost_record (
    record_id    TEXT PRIMARY KEY,
    budget_id    TEXT,                       -- FK→budget（可选，关联预算项）
    project_id   TEXT NOT NULL,
    category_id  TEXT NOT NULL,              -- FK→budget_category
    cost_date    TEXT NOT NULL,              -- 费用发生日期
    amount       REAL NOT NULL,              -- 金额（元）
    description  TEXT,
    source_type  TEXT NOT NULL DEFAULT 'MANUAL', -- MANUAL/AUTO_LABOR/AUTO_COST
    source_ref   TEXT,                       -- 来源引用（10号线单据ID/工时月度等）
    project_site_id TEXT,                    -- 关联中心（可选）
    remark       TEXT,
    created_at   TEXT DEFAULT (datetime('now')),
    updated_at   TEXT DEFAULT (datetime('now')),
    created_by   TEXT
);

CREATE INDEX IF NOT EXISTS idx_cr_project ON cost_record(project_id);
CREATE INDEX IF NOT EXISTS idx_cr_category ON cost_record(category_id);
CREATE INDEX IF NOT EXISTS idx_cr_date ON cost_record(cost_date);
CREATE INDEX IF NOT EXISTS idx_cr_site ON cost_record(project_site_id);
CREATE INDEX IF NOT EXISTS idx_cr_source ON cost_record(source_type);
```

### 预置32类费用类别

```sql
INSERT OR IGNORE INTO budget_category (category_id, category_code, category_name, category_group, cost_type, sort_order) VALUES
-- 直接成本
('LABOR',           'LABOR',           '人工成本',          'DIRECT', 'AUTO',   1),
('TRAVEL',          'TRAVEL',          '差旅费',           'DIRECT', 'MANUAL', 2),
('ACCOMMODATION',   'ACCOMMODATION',   '住宿费',           'DIRECT', 'MANUAL', 3),
('PATIENT_COMP',    'PATIENT_COMP',    '受试者补偿',        'DIRECT', 'MANUAL', 4),
('PATIENT_RECRUIT', 'PATIENT_RECRUIT', '受试者招募费',      'DIRECT', 'MANUAL', 5),
('INVESTIGATOR',    'INVESTIGATOR',    '研究者费',          'DIRECT', 'MANUAL', 6),
('SITE_MGMT',       'SITE_MGMT',       '中心管理费/机构费',  'DIRECT', 'MANUAL', 7),
('ETHICS',          'ETHICS',          '伦理审查费',        'DIRECT', 'MANUAL', 8),
('DRUG_SUPPLY',     'DRUG_SUPPLY',     '试验药品/器械费',   'DIRECT', 'MANUAL', 9),
('LAB_TEST',        'LAB_TEST',        '检验检查费',        'DIRECT', 'MANUAL', 10),
('DATA_MGMT',       'DATA_MGMT',       '数据管理费(EDC/CDMS)', 'DIRECT', 'MANUAL', 11),
('BIOSTAT',         'BIOSTAT',         '生物统计费',        'DIRECT', 'MANUAL', 12),
('SAFETY_REPORT',   'SAFETY_REPORT',   '安全性报告/SAE报告', 'DIRECT', 'MANUAL', 13),
('OUTSOURCE_CRO',   'OUTSOURCE_CRO',   'CRO外包服务费',     'DIRECT', 'MANUAL', 14),
('OUTSOURCE_SMO',   'OUTSOURCE_SMO',   'SMO服务费/CRC外包', 'DIRECT', 'MANUAL', 15),
('OUTSOURCE_LAB',   'OUTSOURCE_LAB',   '中央实验室/第三方检验', 'DIRECT', 'MANUAL', 16),
('OUTSOURCE_IWRS',  'OUTSOURCE_IWRS',  'IWRS/IRT系统费',   'DIRECT', 'MANUAL', 17),
('REGULATORY',      'REGULATORY',      '注册申报费',        'DIRECT', 'MANUAL', 18),
('TRANSLATION',     'TRANSLATION',     '翻译费',           'DIRECT', 'MANUAL', 19),
('INSURANCE',       'INSURANCE',       '保险费/受试者保险',  'DIRECT', 'MANUAL', 20),
('PRINT_MAIL',      'PRINT_MAIL',      '印刷快递费',        'DIRECT', 'MANUAL', 21),
('EQUIPMENT',       'EQUIPMENT',       '设备购置/租赁',     'DIRECT', 'MANUAL', 22),
('MATERIALS',       'MATERIALS',       '物料耗材费',        'DIRECT', 'MANUAL', 23),
('SAMPLE_SHIP',     'SAMPLE_SHIP',     '样本运输/冷链物流',  'DIRECT', 'MANUAL', 24),
('ARCHIVE',         'ARCHIVE',         '档案保管费',        'DIRECT', 'MANUAL', 25),
('TRAINING',        'TRAINING',        '培训费',           'DIRECT', 'MANUAL', 26),
('MEETING',         'MEETING',         '会议费(启动会/中期会/总结会)', 'DIRECT', 'MANUAL', 27),
('OTHER_DIRECT',    'OTHER_DIRECT',    '其他直接成本',      'DIRECT', 'MANUAL', 28),
-- 间接成本
('MANAGEMENT',      'MANAGEMENT',      '项目管理费',        'INDIRECT', 'MANUAL', 29),
('OVERHEAD',        'OVERHEAD',        '间接分摊/机构管理费', 'INDIRECT', 'MANUAL', 30),
('CONTINGENCY',     'CONTINGENCY',     '预备金/不可预见费',  'INDIRECT', 'MANUAL', 31),
('TAX',             'TAX',             '税费',             'INDIRECT', 'MANUAL', 32),
('OTHER_INDIRECT',  'OTHER_INDIRECT',  '其他间接成本',      'INDIRECT', 'MANUAL', 33);
```

---

## 二、finance.db（第10号线 费用管理）

### 1. 报销单

```sql
CREATE TABLE IF NOT EXISTS expense_report (
    report_id     TEXT PRIMARY KEY,
    report_no     TEXT UNIQUE NOT NULL,      -- 报销单号 BX-2026-00001
    applicant_id  TEXT NOT NULL,             -- 申请人member_id
    applicant_name TEXT NOT NULL,            -- 申请人姓名（冗余）
    department_id TEXT,                      -- 部门ID
    project_id    TEXT,                      -- 关联项目（可选，走项目预算）
    expense_type  TEXT NOT NULL,             -- TRAVEL/TRAINING/OFFICE/OTHER
    total_amount  REAL NOT NULL DEFAULT 0,   -- 报销总额
    status        TEXT NOT NULL DEFAULT 'DRAFT', -- DRAFT/SUBMITTED/APPROVING/APPROVED/REJECTED/PAID/CLOSED
    budget_id     TEXT,                      -- 关联预算（预算校验用）
    payment_method TEXT DEFAULT 'BANK_TRANSFER', -- BANK_TRANSFER/CASH
    remark        TEXT,
    created_at    TEXT DEFAULT (datetime('now')),
    updated_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(report_no)
);

CREATE INDEX IF NOT EXISTS idx_er_applicant ON expense_report(applicant_id);
CREATE INDEX IF NOT EXISTS idx_er_project ON expense_report(project_id);
CREATE INDEX IF NOT EXISTS idx_er_status ON expense_report(status);
```

### 2. 报销明细

```sql
CREATE TABLE IF NOT EXISTS expense_item (
    item_id       TEXT PRIMARY KEY,
    report_id     TEXT NOT NULL,             -- FK→expense_report
    category_id   TEXT NOT NULL,             -- FK→budget_category
    expense_date  TEXT NOT NULL,             -- 费用发生日期
    amount        REAL NOT NULL,             -- 金额
    description   TEXT NOT NULL,             -- 费用说明
    invoice_no    TEXT,                      -- 发票号（关联invoice表）
    project_site_id TEXT,                    -- 关联中心（可选）
    attachment    TEXT,                      -- 附件路径
    created_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(report_id, category_id, expense_date, description)
);

CREATE INDEX IF NOT EXISTS idx_ei_report ON expense_item(report_id);
```

### 3. 付款单

```sql
CREATE TABLE IF NOT EXISTS payment (
    payment_id    TEXT PRIMARY KEY,
    payment_no    TEXT UNIQUE NOT NULL,      -- 付款单号 FK-2026-00001
    payee_type    TEXT NOT NULL,             -- VENDOR/SITE/SMO/EMPLOYEE/OTHER
    payee_id      TEXT NOT NULL,             -- 收款方ID
    payee_name    TEXT NOT NULL,             -- 收款方名称（冗余）
    project_id    TEXT,                      -- 关联项目
    contract_id   TEXT,                      -- 关联合同
    category_id   TEXT NOT NULL,             -- FK→budget_category
    amount        REAL NOT NULL,             -- 付款金额
    payment_date  TEXT,                      -- 付款日期
    payment_method TEXT DEFAULT 'BANK_TRANSFER',
    bank_account  TEXT,                      -- 收款账号
    bank_name     TEXT,                      -- 收款银行
    invoice_ids   TEXT,                      -- 关联发票ID列表（JSON数组）
    status        TEXT NOT NULL DEFAULT 'DRAFT', -- DRAFT/SUBMITTED/APPROVING/APPROVED/PAID/REJECTED/CLOSED
    budget_id     TEXT,                      -- 关联预算
    remark        TEXT,
    created_by    TEXT,
    created_at    TEXT DEFAULT (datetime('now')),
    updated_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(payment_no)
);

CREATE INDEX IF NOT EXISTS idx_pay_payee ON payment(payee_type, payee_id);
CREATE INDEX IF NOT EXISTS idx_pay_project ON payment(project_id);
CREATE INDEX IF NOT EXISTS idx_pay_status ON payment(status);
```

### 4. 借款单

```sql
CREATE TABLE IF NOT EXISTS loan (
    loan_id       TEXT PRIMARY KEY,
    loan_no       TEXT UNIQUE NOT NULL,      -- 借款单号 JK-2026-00001
    applicant_id  TEXT NOT NULL,             -- 借款人member_id
    applicant_name TEXT NOT NULL,            -- 借款人姓名
    department_id TEXT,
    project_id    TEXT,                      -- 关联项目
    amount        REAL NOT NULL,             -- 借款金额
    purpose       TEXT NOT NULL,             -- 借款用途
    repay_deadline TEXT NOT NULL,            -- 预计还款日期
    repaid_amount REAL NOT NULL DEFAULT 0,   -- 已冲抵金额
    repaid_at     TEXT,                      -- 全部冲抵日期
    status        TEXT NOT NULL DEFAULT 'DRAFT', -- DRAFT/SUBMITTED/APPROVING/APPROVED/PAID/PARTIAL_REPAID/REPAID/OVERDUE
    remark        TEXT,
    created_at    TEXT DEFAULT (datetime('now')),
    updated_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(loan_no)
);

CREATE INDEX IF NOT EXISTS idx_loan_applicant ON loan(applicant_id);
CREATE INDEX IF NOT EXISTS idx_loan_status ON loan(status);
```

### 5. 借款冲抵记录

```sql
CREATE TABLE IF NOT EXISTS loan_repayment (
    repayment_id  TEXT PRIMARY KEY,
    loan_id       TEXT NOT NULL,             -- FK→loan
    report_id     TEXT,                      -- FK→expense_report（用报销单冲抵）
    payment_id    TEXT,                      -- FK→payment（用付款冲抵）
    amount        REAL NOT NULL,             -- 冲抵金额
    created_at    TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_lr_loan ON loan_repayment(loan_id);
```

### 6. 发票

```sql
CREATE TABLE IF NOT EXISTS invoice (
    invoice_id    TEXT PRIMARY KEY,
    invoice_no    TEXT UNIQUE NOT NULL,      -- 发票号码
    invoice_type  TEXT NOT NULL,             -- SPECIAL/NORMAL/RECEIPT 增值税专票/普票/收据
    invoice_code  TEXT,                      -- 发票代码
    issuer_name   TEXT NOT NULL,             -- 开票方名称
    issuer_tax_no TEXT,                      -- 开票方税号
    amount        REAL NOT NULL,             -- 不含税金额
    tax_amount    REAL NOT NULL DEFAULT 0,   -- 税额
    total_amount  REAL NOT NULL,             -- 价税合计
    invoice_date  TEXT NOT NULL,             -- 开票日期
    verified      INTEGER DEFAULT 0,         -- 是否验真 0/1
    verified_at   TEXT,                      -- 验真时间
    project_id    TEXT,                      -- 关联项目
    category_id   TEXT,                      -- FK→budget_category
    linked_type   TEXT,                      -- REPORT/PAYMENT 关联报销单/付款单
    linked_id     TEXT,                      -- 关联单据ID
    attachment    TEXT,                      -- 发票扫描件路径
    status        TEXT NOT NULL DEFAULT 'RECEIVED', -- RECEIVED/VERIFIED/REJECTED/LINKED/ARCHIVED
    remark        TEXT,
    created_at    TEXT DEFAULT (datetime('now')),
    updated_at    TEXT DEFAULT (datetime('now')),

    UNIQUE(invoice_no)
);

CREATE INDEX IF NOT EXISTS idx_inv_project ON invoice(project_id);
CREATE INDEX IF NOT EXISTS idx_inv_status ON invoice(status);
CREATE INDEX IF NOT EXISTS idx_inv_linked ON invoice(linked_type, linked_id);
```

### 7. 财务审批日志

```sql
CREATE TABLE IF NOT EXISTS finance_approval_log (
    log_id        TEXT PRIMARY KEY,
    doc_type      TEXT NOT NULL,             -- REPORT/PAYMENT/LOAN 单据类型
    doc_id        TEXT NOT NULL,             -- 单据ID
    action        TEXT NOT NULL,             -- SUBMIT/APPROVE/REJECT/WITHDRAW/PAY/CLOSE
    actor_id      TEXT NOT NULL,
    actor_name    TEXT NOT NULL,
    actor_role    TEXT NOT NULL,             -- SUBMITTER/MANAGER/FINANCE/CFO/ADMIN
    comment       TEXT,
    created_at    TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_fal_doc ON finance_approval_log(doc_type, doc_id);
```
