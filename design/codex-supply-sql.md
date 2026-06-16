-- Supply Module 数据库建表 SQL (supply.db)
-- 独立库零耦合，通过ID引用关联project.db/contract.db

-- ============================================
-- 1. supply_category 物资分类表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_category (
    category_id      TEXT PRIMARY KEY,
    category_code    TEXT NOT NULL UNIQUE,           -- 分类编码：IP/REAGENT/CRF/ICF/DEVICE/EMERGENCY/STATIONERY/PRINT/IT/DAILY
    category_name    TEXT NOT NULL,                   -- 分类名称
    supply_type      TEXT NOT NULL,                  -- CLINICAL_SUPPLY/OFFICE_SUPPLY
    parent_code      TEXT,                            -- 上级分类编码（预留）
    description      TEXT,                            -- 分类描述
    requires_batch   INTEGER DEFAULT 0,              -- 是否需要批号管理
    requires_temp    INTEGER DEFAULT 0,               -- 是否需要温度记录
    is_active        INTEGER DEFAULT 1,
    display_order    INTEGER DEFAULT 0,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now'))
);

-- 预设分类数据
INSERT INTO supply_category (category_id, category_code, category_name, supply_type, requires_batch, requires_temp, display_order) VALUES
('CAT001', 'IP', '试验用药', 'CLINICAL_SUPPLY', 1, 1, 10),
('CAT002', 'REAGENT', '试剂盒/实验室耗材', 'CLINICAL_SUPPLY', 1, 1, 20),
('CAT003', 'CRF', 'CRF表/问卷/患者日记卡', 'CLINICAL_SUPPLY', 0, 0, 30),
('CAT004', 'ICF', '知情同意书', 'CLINICAL_SUPPLY', 0, 0, 40),
('CAT005', 'DEVICE', '温度记录仪/冷链设备', 'CLINICAL_SUPPLY', 0, 1, 50),
('CAT006', 'EMERGENCY', '急救设备', 'CLINICAL_SUPPLY', 0, 0, 60),
('CAT007', 'STATIONERY', '办公文具', 'OFFICE_SUPPLY', 0, 0, 70),
('CAT008', 'PRINT', '打印耗材', 'OFFICE_SUPPLY', 0, 0, 80),
('CAT009', 'IT', 'IT设备/配件', 'OFFICE_SUPPLY', 0, 0, 90),
('CAT010', 'DAILY', '生活用品', 'OFFICE_SUPPLY', 0, 0, 100);

-- ============================================
-- 2. supply_warehouse 仓库表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_warehouse (
    warehouse_id     TEXT PRIMARY KEY,
    warehouse_code   TEXT NOT NULL UNIQUE,
    warehouse_name   TEXT NOT NULL,
    warehouse_type   TEXT DEFAULT 'MAIN',              -- MAIN(主仓)/SUB(分仓)/TEMP(临时仓)
    address         TEXT,
    contact_person   TEXT,
    contact_phone   TEXT,
    is_default      INTEGER DEFAULT 0,
    is_active       INTEGER DEFAULT 1,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now'))
);

-- 默认仓库
INSERT INTO supply_warehouse (warehouse_id, warehouse_code, warehouse_name, warehouse_type, is_default) VALUES
('WH001', 'WH-MAIN-01', '中央物资仓库', 'MAIN', 1),
('WH002', 'WH-SUB-01', '区域分仓-华东', 'SUB', 0),
('WH003', 'WH-SUB-02', '区域分仓-华北', 'SUB', 0);

-- ============================================
-- 3. supply_supplier 供应商表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_supplier (
    supplier_id      TEXT PRIMARY KEY,
    supplier_code    TEXT NOT NULL UNIQUE,
    supplier_name    TEXT NOT NULL,
    supplier_type    TEXT,                            -- 物资供应商/服务提供商
    contact_person   TEXT,
    contact_phone    TEXT,
    contact_email    TEXT,
    address          TEXT,
    business_license TEXT,                           -- 营业执照编号
    license_expire   TEXT,                           -- 证照到期日
    tax_rate         REAL DEFAULT 0,
    payment_terms    TEXT,                            -- 付款条款
    bank_name        TEXT,
    bank_account     TEXT,
    status           TEXT DEFAULT 'ACTIVE',           -- ACTIVE/INACTIVE/BLACKLIST
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now'))
);

-- ============================================
-- 4. supply_item 物资主数据表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_item (
    item_id          TEXT PRIMARY KEY,
    item_code        TEXT NOT NULL UNIQUE,           -- 物资编码：SUPPLY-{TYPE}-{YYYY}-{NNNNNN}
    item_name        TEXT NOT NULL,
    category_id      TEXT NOT NULL,
    category_code    TEXT NOT NULL,
    supply_type      TEXT NOT NULL,                  -- CLINICAL_SUPPLY/OFFICE_SUPPLY
    unit             TEXT DEFAULT '件',               -- 计量单位
    spec             TEXT,                            -- 规格
    model            TEXT,                            -- 型号
    manufacturer     TEXT,                            -- 生产厂家
    reference_price  REAL DEFAULT 0,                 -- 参考单价
    safety_stock     REAL DEFAULT 0,                 -- 安全库存
    reorder_point    REAL DEFAULT 0,                 -- 再订货点
    reorder_qty      REAL DEFAULT 0,                 -- 每次采购量
    lead_time_days   INTEGER DEFAULT 7,              -- 采购提前期(天)
    requires_batch   INTEGER DEFAULT 0,              -- 是否需要批号
    requires_temp    INTEGER DEFAULT 0,               -- 是否需要温控
    storage_condition TEXT,                           -- 存储条件
    shelf_life_days  INTEGER,                         -- 有效期(天)
    is_hazardous     INTEGER DEFAULT 0,               -- 是否危险品
    is_active        INTEGER DEFAULT 1,
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (category_id) REFERENCES supply_category(category_id)
);

-- ============================================
-- 5. supply_stock 库存表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_stock (
    stock_id         TEXT PRIMARY KEY,
    warehouse_id     TEXT NOT NULL,
    item_id          TEXT NOT NULL,
    item_code        TEXT NOT NULL,
    item_name        TEXT NOT NULL,
    quantity         REAL DEFAULT 0,                  -- 当前库存
    available_qty    REAL DEFAULT 0,                  -- 可用库存
    reserved_qty     REAL DEFAULT 0,                  -- 预留库存
    frozen_qty       REAL DEFAULT 0,                  -- 冻结库存
    unit             TEXT,
    last_in_date     TEXT,                            -- 最后入库日期
    last_out_date    TEXT,                            -- 最后出库日期
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (warehouse_id) REFERENCES supply_warehouse(warehouse_id),
    FOREIGN KEY (item_id) REFERENCES supply_item(item_id)
);

-- ============================================
-- 6. supply_request 物资申请表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_request (
    request_id       TEXT PRIMARY KEY,
    request_no       TEXT NOT NULL UNIQUE,           -- 申请单号：REQ-{YYYY}-{NNNNNN}
    project_id       TEXT NOT NULL,                   -- 关联项目ID
    project_name     TEXT,                            -- 项目名称(冗余)
    center_id        TEXT NOT NULL,                    -- 申请中心ID
    center_name      TEXT,                            -- 中心名称(冗余)
    supply_type      TEXT NOT NULL,                   -- CLINICAL_SUPPLY/OFFICE_SUPPLY
    request_status   TEXT DEFAULT 'PENDING',          -- PENDING/APPROVED/REJECTED/CANCELLED/PROCESSING/PARTIAL/SHIPPED/RECEIVED
    urgency          TEXT DEFAULT 'NORMAL',            -- NORMAL/URGENT/CRITICAL
    requester_id     TEXT NOT NULL,                   -- 申请人ID
    requester_name   TEXT NOT NULL,
    request_date     TEXT NOT NULL,                   -- 申请日期
    expected_date    TEXT,                            -- 期望日期
    approved_by      TEXT,                            -- 审批人ID
    approved_name    TEXT,
    approved_date    TEXT,                            -- 审批日期
    approval_comment TEXT,                            -- 审批意见
    total_amount     REAL DEFAULT 0,                  -- 申请总金额
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (project_id) REFERENCES project(id),
    FOREIGN KEY (center_id) REFERENCES project_site(site_id)
);

-- ============================================
-- 7. supply_request_item 申请明细表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_request_item (
    item_id          TEXT PRIMARY KEY,
    request_id       TEXT NOT NULL,
    item_code        TEXT NOT NULL,
    item_name        TEXT NOT NULL,
    category_id      TEXT,
    category_code    TEXT,
    unit             TEXT,
    request_qty      REAL NOT NULL,                   -- 申请数量
    approved_qty     REAL,                            -- 审批数量
    shipped_qty      REAL DEFAULT 0,                  -- 已发货数量
    received_qty     REAL DEFAULT 0,                  -- 已收货数量
    unit_price       REAL DEFAULT 0,                  -- 单价
    amount           REAL DEFAULT 0,                   -- 金额
    batch_no         TEXT,                            -- 批号(临床物资)
    expire_date      TEXT,                            -- 效期(临床物资)
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (request_id) REFERENCES supply_request(request_id)
);

-- ============================================
-- 8. supply_approval 审批记录表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_approval (
    approval_id      TEXT PRIMARY KEY,
    request_id       TEXT NOT NULL,
    approver_id      TEXT NOT NULL,
    approver_name    TEXT NOT NULL,
    approval_status  TEXT NOT NULL,                   -- APPROVED/REJECTED/MODIFIED
    approval_date    TEXT NOT NULL,
    approval_comment TEXT,
    original_data    TEXT,                            -- 原申请数据(JSON)
    modified_data    TEXT,                            -- 修改后数据(JSON)
    created_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (request_id) REFERENCES supply_request(request_id)
);

-- ============================================
-- 9. supply_purchase_order 采购订单表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_purchase_order (
    po_id            TEXT PRIMARY KEY,
    po_no            TEXT NOT NULL UNIQUE,            -- 采购单号：PO-{YYYY}-{NNNNNN}
    supplier_id      TEXT NOT NULL,
    supplier_name    TEXT NOT NULL,
    contract_id      TEXT,                            -- 关联合同(可选)
    po_status        TEXT DEFAULT 'DRAFT',            -- DRAFT/SUBMITTED/CONFIRMED/SHIPPED/PARTIAL_RECEIVED/RECEIVED/CANCELLED
    project_id       TEXT,                            -- 关联项目(采购用于特定项目)
    total_amount     REAL DEFAULT 0,
    order_date       TEXT,
    expected_date    TEXT,
    actual_date      TEXT,
    shipping_method  TEXT,                            -- 运输方式
    tracking_no      TEXT,                            -- 运单号
    received_by      TEXT,
    received_date    TEXT,
    remark           TEXT,
    created_by       TEXT,
    created_name     TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (supplier_id) REFERENCES supply_supplier(supplier_id)
);

-- ============================================
-- 10. supply_purchase_item 采购明细表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_purchase_item (
    po_item_id       TEXT PRIMARY KEY,
    po_id            TEXT NOT NULL,
    item_id          TEXT NOT NULL,
    item_code        TEXT NOT NULL,
    item_name        TEXT NOT NULL,
    category_code    TEXT,
    unit             TEXT,
    order_qty        REAL NOT NULL,                    -- 订购数量
    received_qty     REAL DEFAULT 0,                  -- 已到货数量
    unit_price       REAL NOT NULL,
    amount           REAL NOT NULL,
    batch_no         TEXT,                            -- 到货批号
    expire_date      TEXT,                            -- 效期
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (po_id) REFERENCES supply_purchase_order(po_id),
    FOREIGN KEY (item_id) REFERENCES supply_item(item_id)
);

-- ============================================
-- 11. supply_delivery 发放/出库单表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_delivery (
    delivery_id      TEXT PRIMARY KEY,
    delivery_no      TEXT NOT NULL UNIQUE,            -- 出库单号：DO-{YYYY}-{NNNNNN}
    request_id       TEXT,                            -- 关联申请(可选，直发时为空)
    project_id       TEXT,
    center_id        TEXT NOT NULL,
    center_name      TEXT NOT NULL,
    delivery_status  TEXT DEFAULT 'PENDING',         -- PENDING/PROCESSING/SHIPPED/IN_TRANSIT/DELIVERED/RECEIVED
    warehouse_id     TEXT NOT NULL,
    delivery_method  TEXT,                            -- 自提/快递/送货上门
    tracking_no      TEXT,
    shipped_by        TEXT,
    shipped_date     TEXT,
    expected_date    TEXT,
    delivered_date   TEXT,
    total_amount     REAL DEFAULT 0,
    total_quantity   REAL DEFAULT 0,
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (center_id) REFERENCES project_site(site_id),
    FOREIGN KEY (warehouse_id) REFERENCES supply_warehouse(warehouse_id)
);

-- ============================================
-- 12. supply_delivery_item 发放明细表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_delivery_item (
    item_id          TEXT PRIMARY KEY,
    delivery_id      TEXT NOT NULL,
    item_code        TEXT NOT NULL,
    item_name        TEXT NOT NULL,
    category_code    TEXT,
    unit             TEXT,
    quantity         REAL NOT NULL,
    unit_price       REAL DEFAULT 0,
    amount           REAL DEFAULT 0,
    batch_no         TEXT,
    production_date  TEXT,                            -- 生产日期
    expire_date      TEXT,
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (delivery_id) REFERENCES supply_delivery(delivery_id)
);

-- ============================================
-- 13. supply_receive 收货确认表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_receive (
    receive_id       TEXT PRIMARY KEY,
    receive_no       TEXT NOT NULL UNIQUE,            -- 收货单号：RCV-{YYYY}-{NNNNNN}
    delivery_id      TEXT NOT NULL,
    delivery_no      TEXT NOT NULL,
    request_id       TEXT,
    center_id        TEXT NOT NULL,
    center_name      TEXT NOT NULL,
    receiver_id      TEXT NOT NULL,                   -- 收货人
    receiver_name   TEXT NOT NULL,
    receive_date     TEXT NOT NULL,
    receive_status  TEXT DEFAULT 'COMPLETE',        -- COMPLETE/PARTIAL/DAMAGED
    is_confirmed     INTEGER DEFAULT 1,
    confirm_date     TEXT,
    signed_file      TEXT,                            -- 签收单文件路径
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (delivery_id) REFERENCES supply_delivery(delivery_id),
    FOREIGN KEY (center_id) REFERENCES project_site(site_id)
);

-- ============================================
-- 14. supply_receive_item 收货明细表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_receive_item (
    item_id          TEXT PRIMARY KEY,
    receive_id       TEXT NOT NULL,
    delivery_item_id TEXT,
    item_code        TEXT NOT NULL,
    item_name        TEXT NOT NULL,
    unit             TEXT,
    expected_qty     REAL,                            -- 期望数量
    actual_qty       REAL NOT NULL,                   -- 实收数量
    qualified_qty    REAL,                            -- 合格数量
    damaged_qty      REAL DEFAULT 0,                  -- 损坏数量
    batch_no         TEXT,                            -- 实收批号
    temp_record      TEXT,                            -- 温度记录(冷链物资)
    is_qualified     INTEGER DEFAULT 1,              -- 是否合格
    problem_desc     TEXT,                            -- 问题描述
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (receive_id) REFERENCES supply_receive(receive_id)
);

-- ============================================
-- 15. supply_stock_log 库存流水表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_stock_log (
    log_id           TEXT PRIMARY KEY,
    stock_id         TEXT,
    warehouse_id     TEXT NOT NULL,
    item_id          TEXT NOT NULL,
    item_code        TEXT NOT NULL,
    operation_type   TEXT NOT NULL,                  -- IN/OUT/CHECK/TRANSFER/RETURN
    quantity         REAL NOT NULL,                   -- 变动数量(正负)
    before_qty       REAL NOT NULL,                   -- 变动前库存
    after_qty        REAL NOT NULL,                   -- 变动后库存
    reference_type   TEXT,                            -- 关联单据类型
    reference_id     TEXT,                            -- 关联单据ID
    reference_no     TEXT,                            -- 关联单据号
    batch_no         TEXT,
    expire_date      TEXT,
    operator_id      TEXT,
    operator_name    TEXT,
    operate_date     TEXT NOT NULL,
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (warehouse_id) REFERENCES supply_warehouse(warehouse_id),
    FOREIGN KEY (item_id) REFERENCES supply_item(item_id)
);

-- ============================================
-- 16. supply_temp_record 温度记录表(临床物资专用)
-- ============================================
CREATE TABLE IF NOT EXISTS supply_temp_record (
    record_id        TEXT PRIMARY KEY,
    delivery_id      TEXT,
    receive_id       TEXT,
    item_id          TEXT,
    item_code        TEXT,
    batch_no         TEXT,
    temp_device_no   TEXT,                            -- 温度记录仪编号
    record_start     TEXT NOT NULL,                   -- 记录开始时间
    record_end       TEXT NOT NULL,                   -- 记录结束时间
    min_temp         REAL,                            -- 最低温度
    max_temp         REAL,                            -- 最高温度
    avg_temp         REAL,                            -- 平均温度
    is_normal        INTEGER DEFAULT 1,              -- 是否正常
    exceed_desc      TEXT,                            -- 超标说明
    file_path        TEXT,                            -- 温度记录文件
    created_at       TEXT DEFAULT (datetime('now'))
);

-- ============================================
-- 17. supply_alert 库存预警表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_alert (
    alert_id         TEXT PRIMARY KEY,
    alert_type       TEXT NOT NULL,                  -- LOW_STOCK/EXPIRE/QUALIFICATION
    warehouse_id     TEXT,
    item_id          TEXT NOT NULL,
    item_code        TEXT NOT NULL,
    item_name        TEXT NOT NULL,
    current_qty      REAL,
    threshold        REAL,
    alert_level      TEXT DEFAULT 'WARNING',        -- INFO/WARNING/CRITICAL
    alert_status     TEXT DEFAULT 'UNREAD',          -- UNREAD/READ/RESOLVED
    description      TEXT,
    resolved_by      TEXT,
    resolved_date    TEXT,
    created_at       TEXT DEFAULT (datetime('now'))
);

-- ============================================
-- 18. supply_qualification 供应商资质表
-- ============================================
CREATE TABLE IF NOT EXISTS supply_qualification (
    qual_id          TEXT PRIMARY KEY,
    supplier_id     TEXT NOT NULL,
    qual_type        TEXT NOT NULL,                  -- LICENSE/CERTIFICATE/PERMISSION
    qual_name        TEXT NOT NULL,                  -- 资质名称
    qual_no          TEXT,                            -- 资质编号
    issue_date       TEXT,                            -- 发证日期
    expire_date      TEXT,                            -- 到期日期
    issuing_authority TEXT,                          -- 发证机关
    file_path        TEXT,                            -- 资质文件
    status           TEXT DEFAULT 'VALID',           -- VALID/EXPIRING/EXPIRED
    remark           TEXT,
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (supplier_id) REFERENCES supply_supplier(supplier_id)
);

-- ============================================
-- 索引
-- ============================================
CREATE INDEX IF NOT EXISTS idx_supply_item_category ON supply_item(category_id);
CREATE INDEX IF NOT EXISTS idx_supply_item_type ON supply_item(supply_type);
CREATE INDEX IF NOT EXISTS idx_supply_stock_item ON supply_stock(item_id);
CREATE INDEX IF NOT EXISTS idx_supply_stock_warehouse ON supply_stock(warehouse_id);
CREATE INDEX IF NOT EXISTS idx_supply_request_project ON supply_request(project_id);
CREATE INDEX IF NOT EXISTS idx_supply_request_center ON supply_request(center_id);
CREATE INDEX IF NOT EXISTS idx_supply_request_status ON supply_request(request_status);
CREATE INDEX IF NOT EXISTS idx_supply_request_date ON supply_request(request_date);
CREATE INDEX IF NOT EXISTS idx_supply_purchase_order_supplier ON supply_purchase_order(supplier_id);
CREATE INDEX IF NOT EXISTS idx_supply_purchase_order_status ON supply_purchase_order(po_status);
CREATE INDEX IF NOT EXISTS idx_supply_delivery_center ON supply_delivery(center_id);
CREATE INDEX IF NOT EXISTS idx_supply_delivery_status ON supply_delivery(delivery_status);
CREATE INDEX IF NOT EXISTS idx_supply_receive_center ON supply_receive(center_id);
CREATE INDEX IF NOT EXISTS idx_supply_receive_date ON supply_receive(receive_date);
CREATE INDEX IF NOT EXISTS idx_supply_stock_log_item ON supply_stock_log(item_id);
CREATE INDEX IF NOT EXISTS idx_supply_stock_log_date ON supply_stock_log(operate_date);
CREATE INDEX IF NOT EXISTS idx_supply_alert_status ON supply_alert(alert_status);
CREATE INDEX IF NOT EXISTS idx_supply_qualification_expire ON supply_qualification(expire_date);
