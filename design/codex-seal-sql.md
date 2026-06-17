# 用印管理 Module SQL建表脚本 (对象线16号: SEAL)

> 数据库: seal.db (SQLite, better-sqlite3, WAL模式)
> 直接执行，idempotent (IF NOT EXISTS)
> 零共享零耦合原则：每个业务域独立DB/routes/db.js

```sql
-- ============================================
-- seal.db 全量建表脚本
-- 对象线16号: 用印管理 (SEAL)
-- ============================================

-- 1. 印章登记 (Seal Registry)
CREATE TABLE IF NOT EXISTS seal_registry (
    seal_id              TEXT PRIMARY KEY,
    seal_no              TEXT NOT NULL UNIQUE,     -- 印章编号 YZ-YYYY-NNN
    seal_type            TEXT NOT NULL,           -- 公章/合同专用章/财务专用章/法人章/部门章
    seal_name            TEXT NOT NULL,            -- 印章名称
    keeping_department   TEXT,                     -- 保管部门
    keeper_id            TEXT,                     -- 保管人ID (member.member_id)
    keeper_name          TEXT,                     -- 保管人姓名(冗余)
    keeper_phone         TEXT,                     -- 保管人电话(冗余)
    effective_date       TEXT,                     -- 启用日期
    seal_image           TEXT,                     -- 印章图片路径
    seal_status          TEXT DEFAULT 'AVAILABLE', -- AVAILABLE/IN_USE/MAINTENANCE/RETIRED
    current_holder_id    TEXT,                     -- 当前持有人ID(借用中)
    current_holder_name  TEXT,                     -- 当前持有人姓名
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 2. 用印申请 (Seal Request)
CREATE TABLE IF NOT EXISTS seal_request (
    request_id           TEXT PRIMARY KEY,
    request_no           TEXT NOT NULL UNIQUE,     -- 编号 YY-YYYYMM-NNNNN
    request_category     TEXT NOT NULL DEFAULT 'PROJECT', -- 用印类别: PROJECT(项目类)/NON_PROJECT(非项目类)
    project_id           TEXT,                     -- 关联项目(project.db)，项目类必填
    project_site_id      TEXT,                     -- 关联中心(project.db)
    -- 基本信息
    applicant_id         TEXT NOT NULL,            -- 申请人ID
    applicant_name       TEXT NOT NULL,            -- 申请人姓名
    applicant_dept       TEXT,                     -- 申请人部门
    applicant_phone      TEXT,                     -- 申请人电话
    -- 用印信息
    seal_type            TEXT NOT NULL,            -- 印章类型
    usage_purpose        TEXT NOT NULL,            -- 用印事由
    copy_count           INTEGER NOT NULL,         -- 申请份数
    -- 文件信息
    document_name        TEXT NOT NULL,            -- 文件名称
    document_count       INTEGER DEFAULT 1,        -- 文件份数
    contract_id          TEXT,                     -- 关联合同(contract.db)
    attachment_paths     TEXT,                     -- 附件路径(JSON数组)
    -- 审批流程
    approval_flow        TEXT NOT NULL,            -- 审批流程定义(JSON数组)
    current_step         INTEGER DEFAULT 1,       -- 当前审批节点(1-based)
    approval_status      TEXT DEFAULT 'PENDING',   -- PENDING/APPROVING/APPROVED/REJECTED/WITHDRAWN/CANCELLED
    -- 金额相关(决定审批流程)
    estimated_amount     REAL,                     -- 预估金额(决定审批层级)
    requires_legal       INTEGER DEFAULT 0,        -- 是否需要法务审批
    requires_gm          INTEGER DEFAULT 0,        -- 是否需要总经理审批
    -- 其他
    remark               TEXT,                     -- 申请备注
    rejection_reason     TEXT,                     -- 驳回原因
    withdrawn_reason     TEXT,                     -- 撤回原因
    withdrawn_at         TEXT,                     -- 撤回时间
    cancelled_reason     TEXT,                     -- 取消原因
    cancelled_at         TEXT,                     -- 取消时间
    -- 时间戳
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 3. 审批记录 (Seal Approval)
CREATE TABLE IF NOT EXISTS seal_approval (
    approval_id          TEXT PRIMARY KEY,
    request_id           TEXT NOT NULL,
    step                 INTEGER NOT NULL,          -- 审批步骤(1-based)
    node_name            TEXT NOT NULL,            -- 节点名称(部门经理/法务/总经理)
    approver_id          TEXT,                     -- 审批人ID
    approver_name        TEXT,                     -- 审批人姓名
    approver_dept        TEXT,                     -- 审批人部门
    -- 审批结果
    approval_status      TEXT NOT NULL,            -- PENDING/APPROVED/REJECTED
    comment              TEXT,                     -- 审批意见
    -- 时间
    assigned_at          TEXT,                     -- 指派时间
    approved_at          TEXT,                     -- 审批时间
    -- 备注
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT,
    UNIQUE(request_id, step)
);

-- 4. 用印记录 (Seal Usage Log)
CREATE TABLE IF NOT EXISTS seal_usage_log (
    usage_id             TEXT PRIMARY KEY,
    request_id           TEXT NOT NULL,
    -- 印章信息
    seal_id              TEXT NOT NULL,            -- 使用印章ID
    seal_no              TEXT,                     -- 印章编号(冗余)
    seal_type            TEXT,                     -- 印章类型(冗余)
    seal_name            TEXT,                     -- 印章名称(冗余)
    -- 用印信息
    actual_count         INTEGER NOT NULL,         -- 实际盖章份数
    usage_time           TEXT NOT NULL,            -- 用印时间
    sealer_id            TEXT,                     -- 盖章人ID
    sealer_name          TEXT,                     -- 盖章人姓名
    -- 领取信息
    recipient_name       TEXT NOT NULL,            -- 取件人姓名
    recipient_phone      TEXT,                     -- 取件人电话
    recipient_time       TEXT,                     -- 领取时间
    -- 归还信息
    need_return          INTEGER DEFAULT 1,        -- 是否需要归还
    return_deadline      TEXT,                     -- 规定归还时间
    return_status        TEXT DEFAULT 'PENDING',   -- PENDING/RETURNED/OVERDUE
    returner_id          TEXT,                     -- 归还人ID
    returner_name        TEXT,                     -- 归还人姓名
    returned_at          TEXT,                     -- 实际归还时间
    return_status_type   TEXT,                     -- 正常归还/OVERDUE逾期
    archive_no           TEXT,                     -- 归档编号
    is_archived          INTEGER DEFAULT 0,        -- 是否已存档
    -- 备注
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- 5. 用印文件追踪 (Seal Document Tracking)
CREATE TABLE IF NOT EXISTS seal_document (
    document_id          TEXT PRIMARY KEY,
    request_id           TEXT NOT NULL,
    usage_id              TEXT,                     -- 关联用印记录
    -- 文件信息
    document_name        TEXT NOT NULL,            -- 文件名称
    document_count       INTEGER NOT NULL,         -- 文件份数
    original_count       INTEGER NOT NULL,         -- 原申请份数
    -- 追踪状态
    tracking_type        TEXT DEFAULT 'SELF_PICKUP', -- SHIPPED/自取
    -- 寄出信息
    shipped_count        INTEGER,                   -- 寄出份数
    recipient_name       TEXT,                     -- 收件人
    recipient_address    TEXT,                     -- 收件地址
    courier_company      TEXT,                     -- 快递公司
    tracking_no          TEXT,                     -- 快递单号
    shipped_at           TEXT,                     -- 寄出时间
    -- 签收信息
    signed_count         INTEGER,                   -- 签收份数
    signed_by            TEXT,                     -- 签收人
    signed_at            TEXT,                     -- 签收时间
    sign_remark          TEXT,                     -- 签收备注
    -- 归档信息
    archived_count       INTEGER,                   -- 归档份数
    archive_no           TEXT,                     -- 归档编号
    archived_at          TEXT,                     -- 归档时间
    -- 状态
    document_status      TEXT DEFAULT 'PENDING',  -- PENDING/SHIPPED/SIGNED/ARCHIVED
    -- 备注
    remark               TEXT,
    created_at           TEXT DEFAULT (datetime('now')),
    updated_at           TEXT DEFAULT (datetime('now')),
    created_by           TEXT,
    updated_by           TEXT
);

-- ============================================
-- 索引
-- ============================================

-- seal_registry 索引
CREATE INDEX IF NOT EXISTS idx_sr_seal_no ON seal_registry(seal_no);
CREATE INDEX IF NOT EXISTS idx_sr_seal_type ON seal_registry(seal_type);
CREATE INDEX IF NOT EXISTS idx_sr_seal_status ON seal_registry(seal_status);
CREATE INDEX IF NOT EXISTS idx_sr_keeper ON seal_registry(keeper_id);
CREATE INDEX IF NOT EXISTS idx_sr_department ON seal_registry(keeping_department);

-- seal_request 索引
CREATE INDEX IF NOT EXISTS idx_sq_request_no ON seal_request(request_no);
CREATE INDEX IF NOT EXISTS idx_sq_project ON seal_request(project_id);
CREATE INDEX IF NOT EXISTS idx_sq_project_site ON seal_request(project_site_id);
CREATE INDEX IF NOT EXISTS idx_sq_applicant ON seal_request(applicant_id);
CREATE INDEX IF NOT EXISTS idx_sq_seal_type ON seal_request(seal_type);
CREATE INDEX IF NOT EXISTS idx_sq_approval_status ON seal_request(approval_status);
CREATE INDEX IF NOT EXISTS idx_sq_created_at ON seal_request(created_at);
CREATE INDEX IF NOT EXISTS idx_sq_current_step ON seal_request(request_id, current_step);

-- seal_approval 索引
CREATE INDEX IF NOT EXISTS idx_sa_request ON seal_approval(request_id);
CREATE INDEX IF NOT EXISTS idx_sa_approver ON seal_approval(approver_id);
CREATE INDEX IF NOT EXISTS idx_sa_status ON seal_approval(approval_status);

-- seal_usage_log 索引
CREATE INDEX IF NOT EXISTS idx_sul_request ON seal_usage_log(request_id);
CREATE INDEX IF NOT EXISTS idx_sul_seal ON seal_usage_log(seal_id);
CREATE INDEX IF NOT EXISTS idx_sul_sealer ON seal_usage_log(sealer_id);
CREATE INDEX IF NOT EXISTS idx_sul_return_status ON seal_usage_log(return_status);
CREATE INDEX IF NOT EXISTS idx_sul_usage_time ON seal_usage_log(usage_time);

-- seal_document 索引
CREATE INDEX IF NOT EXISTS idx_sd_request ON seal_document(request_id);
CREATE INDEX IF NOT EXISTS idx_sd_usage ON seal_document(usage_id);
CREATE INDEX IF NOT EXISTS idx_sd_tracking_no ON seal_document(tracking_no);
CREATE INDEX IF NOT EXISTS idx_sd_document_status ON seal_document(document_status);
CREATE INDEX IF NOT EXISTS idx_sd_archive_no ON seal_document(archive_no);
```

---

## 枚举值速查

```
-- seal_registry.seal_type
公章 / 合同专用章 / 财务专用章 / 法人章 / 部门章

-- seal_registry.seal_status
AVAILABLE / IN_USE / MAINTENANCE / RETIRED

-- seal_request.usage_purpose
合同盖章 / 协议签署 / 授权委托书 / 资质文件 / 证明文件 / 公证材料 / 其他

-- seal_request.approval_status
PENDING / APPROVING / APPROVED / REJECTED / WITHDRAWN / CANCELLED

-- seal_request.approval_flow (JSON数组)
[
  { "node": "部门经理", "node_type": "DEPT_MANAGER", "required": true },
  { "node": "法务", "node_type": "LEGAL", "required": false },
  { "node": "总经理", "node_type": "GM", "required": false }
]

-- seal_approval.approval_status
PENDING / APPROVED / REJECTED

-- seal_usage_log.return_status
PENDING / RETURNED / OVERDUE

-- seal_usage_log.return_status_type
正常归还 / OVERDUE逾期

-- seal_document.tracking_type
SHIPPED / 自取

-- seal_document.document_status
PENDING / SHIPPED / SIGNED / ARCHIVED
```

---

## 表关系说明

```
┌─────────────────┐
│  seal_registry  │
│  (印章登记)      │
└────────┬────────┘
         │ 1:N
         ▼
┌─────────────────┐       ┌─────────────────┐
│ seal_request    │──N:1──│   project       │
│ (用印申请)       │       │  (project.db)   │
└────────┬────────┘       └─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────┐       ┌─────────────────┐
│ seal_approval   │       │   member        │
│ (审批记录)       │       │  (member.db)    │
└─────────────────┘       └─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────┐       ┌─────────────────┐
│ seal_usage_log  │──N:1──│ seal_registry   │
│ (用印记录)       │       │  (印章)          │
└────────┬────────┘       └─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────┐
│ seal_document  │
│ (文件追踪)       │
└─────────────────┘
```

---

## 跨库引用说明

| 本表字段 | 引用表 | 说明 |
|---------|--------|------|
| seal_request.project_id | project.db | 项目ID(可选) |
| seal_request.project_site_id | project.db | 中心ID(可选) |
| seal_request.contract_id | contract.db | 关联合同(可选) |
| seal_request.applicant_id | member.db | 申请人ID |
| seal_usage_log.sealer_id | member.db | 盖章人ID |
| seal_usage_log.current_holder_id | seal_registry | 印章当前持有人 |

**跨域数据调用规则：**
- 跨库关联数据不走物理外键
- 前端通过API调用获取关联数据
- 后端查询时用应用层JOIN

---

## 自动编号规则

### 印章编号 YZ-YYYY-NNN
```
YZ-2024-001  (第1位从001开始，每年重置)
```

### 用印申请编号 YY-YYYYMM-NNNNN
```
YY-202406-00001  (5位序号，每月重置)
```

### 归档编号 GD-YYYY-NNNNN
```
GD-2024-00001  (5位序号，每年重置)
```

---

## 第一版不做

- ❌ 用印审批流自定义配置（固定流程先跑）
- ❌ 电子印章/电子签名集成
- ❌ 用印提醒自动推送
- ❌ 用印数据导出Excel
- ❌ 印章使用统计图表
- ❌ 用印审计报告自动生成

---

*文档版本 V1.0 | 2026-06-18*

-- 索引: 按类别查询
CREATE INDEX IF NOT EXISTS idx_sreq_category ON seal_request(request_category);
-- 约束: 项目类申请必须有project_id（应用层校验）