# Supply Module API 路由文档 (supply.db)

> RESTful API 路由设计，按三层视角组织
> **Base URL: /api/supply**

---

## 一、通用接口 (/api/supply/common)

### 1.1 物资分类

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/common/categories | 获取物资分类列表 |
| GET | /api/supply/common/categories/:id | 获取分类详情 |
| GET | /api/supply/common/categories/tree | 获取分类树结构 |

**Response:**
```json
{
  "code": 0,
  "data": [
    {
      "category_id": "CAT001",
      "category_code": "IP",
      "category_name": "试验用药",
      "supply_type": "CLINICAL_SUPPLY",
      "requires_batch": true,
      "requires_temp": true
    }
  ]
}
```

### 1.2 物资主数据

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/common/items | 获取物资列表 |
| GET | /api/supply/common/items/:id | 获取物资详情 |
| GET | /api/supply/common/items/search | 搜索物资 |

**Query Params:**
- `category_id` - 分类ID
- `supply_type` - CLINICAL_SUPPLY/OFFICE_SUPPLY
- `keyword` - 关键词搜索
- `page` / `size` - 分页

**Response:**
```json
{
  "code": 0,
  "data": {
    "items": [
      {
        "item_id": "uuid",
        "item_code": "SUPPLY-IP-2024-000001",
        "item_name": "研究药物A 10mg",
        "category_code": "IP",
        "unit": "盒",
        "spec": "10mg×30片",
        "reference_price": 500.00,
        "safety_stock": 100,
        "is_active": true
      }
    ],
    "total": 100,
    "page": 1,
    "size": 20
  }
}
```

### 1.3 仓库管理

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/common/warehouses | 获取仓库列表 |
| GET | /api/supply/common/warehouses/:id | 获取仓库详情 |

---

## 二、L1 平台管理接口 (/api/supply/l1)

### 2.1 申请审批

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l1/requests | 获取所有申请列表 |
| GET | /api/supply/l1/requests/pending | 获取待审批申请 |
| GET | /api/supply/l1/requests/:id | 获取申请详情 |
| PUT | /api/supply/l1/requests/:id/approve | 审批通过 |
| PUT | /api/supply/l1/requests/:id/reject | 审批拒绝 |
| POST | /api/supply/l1/requests/batch-approve | 批量审批 |

**PUT /api/supply/l1/requests/:id/approve**
```json
{
  "approved_qty_map": {
    "item_id_1": 100,
    "item_id_2": 50
  },
  "comment": "同意，按库存发货"
}
```

**PUT /api/supply/l1/requests/:id/reject**
```json
{
  "reject_reason": "库存不足，建议调整数量"
}
```

**GET /api/supply/l1/requests/pending Response:**
```json
{
  "code": 0,
  "data": {
    "requests": [
      {
        "request_id": "uuid",
        "request_no": "REQ-2024-000001",
        "project_name": "PD-001 肿瘤药物试验",
        "center_name": "北京协和医院",
        "supply_type": "CLINICAL_SUPPLY",
        "urgency": "URGENT",
        "requester_name": "张三",
        "request_date": "2024-06-20",
        "expected_date": "2024-06-25",
        "total_amount": 5000.00,
        "item_count": 5
      }
    ],
    "total": 50,
    "pending_count": 12
  }
}
```

### 2.2 采购管理

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l1/purchase-orders | 获取采购订单列表 |
| GET | /api/supply/l1/purchase-orders/:id | 获取采购订单详情 |
| POST | /api/supply/l1/purchase-orders | 新建采购订单 |
| PUT | /api/supply/l1/purchase-orders/:id | 更新采购订单 |
| DELETE | /api/supply/l1/purchase-orders/:id | 删除采购订单(草稿) |
| PUT | /api/supply/l1/purchase-orders/:id/submit | 提交采购订单 |
| PUT | /api/supply/l1/purchase-orders/:id/receive | 入库确认 |

**POST /api/supply/l1/purchase-orders**
```json
{
  "supplier_id": "uuid",
  "project_id": "uuid",
  "expected_date": "2024-06-30",
  "items": [
    {
      "item_id": "uuid",
      "order_qty": 200,
      "unit_price": 100.00
    }
  ],
  "remark": "紧急采购"
}
```

**Response:**
```json
{
  "code": 0,
  "data": {
    "po_id": "uuid",
    "po_no": "PO-2024-000001"
  }
}
```

### 2.3 库存管理

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l1/stock | 获取库存列表 |
| GET | /api/supply/l1/stock/:warehouse_id/:item_id | 获取指定库存 |
| GET | /api/supply/l1/stock/summary | 库存汇总 |
| GET | /api/supply/l1/stock/alerts | 库存预警列表 |
| PUT | /api/supply/l1/stock/adjust | 库存调整(盘点) |
| GET | /api/supply/l1/stock/logs | 库存流水 |

**GET /api/supply/l1/stock Response:**
```json
{
  "code": 0,
  "data": {
    "stocks": [
      {
        "stock_id": "uuid",
        "warehouse_name": "中央物资仓库",
        "item_code": "SUPPLY-IP-2024-000001",
        "item_name": "研究药物A",
        "category_code": "IP",
        "quantity": 500,
        "available_qty": 450,
        "reserved_qty": 50,
        "safety_stock": 100,
        "is_low_stock": false
      }
    ],
    "total_quantity": 50000,
    "total_value": 500000.00,
    "low_stock_count": 5
  }
}
```

### 2.4 供应商管理

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l1/suppliers | 获取供应商列表 |
| GET | /api/supply/l1/suppliers/:id | 获取供应商详情 |
| POST | /api/supply/l1/suppliers | 新增供应商 |
| PUT | /api/supply/l1/suppliers/:id | 更新供应商 |
| DELETE | /api/supply/l1/suppliers/:id | 删除供应商 |
| GET | /api/supply/l1/suppliers/:id/qualifications | 获取供应商资质 |
| POST | /api/supply/l1/suppliers/:id/qualifications | 添加资质 |

### 2.5 发放管理

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l1/deliveries | 获取发放单列表 |
| GET | /api/supply/l1/deliveries/:id | 获取发放单详情 |
| POST | /api/supply/l1/deliveries | 新建发放单 |
| PUT | /api/supply/l1/deliveries/:id | 更新发放单 |
| PUT | /api/supply/l1/deliveries/:id/ship | 发货确认 |
| PUT | /api/supply/l1/deliveries/:id/track | 更新物流状态 |
| GET | /api/supply/l1/deliveries/in-transit | 在途物资 |

### 2.6 统计分析

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l1/stats/dashboard | 仪表盘统计 |
| GET | /api/supply/l1/stats/purchase-amount | 采购金额统计 |
| GET | /api/supply/l1/stats/fulfillment-rate | 申请满足率 |
| GET | /api/supply/l1/stats/turnover | 库存周转率 |
| GET | /api/supply/l1/stats/consumption | 物资消耗报表 |

**GET /api/supply/l1/stats/dashboard Response:**
```json
{
  "code": 0,
  "data": {
    "pending_approvals": 12,
    "low_stock_alerts": 5,
    "monthly_purchase_amount": 150000.00,
    "in_transit_count": 8,
    "fulfillment_rate": 92.5,
    "today_deliveries": 15
  }
}
```

### 2.7 仓库管理

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l1/warehouses | 获取仓库列表 |
| POST | /api/supply/l1/warehouses | 新增仓库 |
| PUT | /api/supply/l1/warehouses/:id | 更新仓库 |
| DELETE | /api/supply/l1/warehouses/:id | 删除仓库 |

---

## 三、L2 项目中心接口 (/api/supply/l2)

### 3.1 物资申请(项目维度)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l2/:project_id/requests | 获取项目所有申请 |
| GET | /api/supply/l2/:project_id/requests/summary | 项目申请汇总 |

**Query Params:**
- `center_id` - 中心筛选
- `status` - 状态筛选
- `supply_type` - 物资类型筛选
- `date_from` / `date_to` - 日期范围

**GET /api/supply/l2/:project_id/requests/summary Response:**
```json
{
  "code": 0,
  "data": {
    "total_requests": 50,
    "total_amount": 250000.00,
    "by_center": [
      {
        "center_id": "uuid",
        "center_name": "北京协和医院",
        "request_count": 15,
        "pending_count": 3,
        "approved_count": 10,
        "received_count": 8,
        "total_amount": 75000.00
      }
    ],
    "by_status": {
      "PENDING": 5,
      "APPROVED": 10,
      "PROCESSING": 8,
      "SHIPPED": 15,
      "RECEIVED": 12
    }
  }
}
```

### 3.2 物资分配(项目维度)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l2/:project_id/distributions | 获取项目物资分配 |
| GET | /api/supply/l2/:project_id/delivery-progress | 获取配送进度 |

**GET /api/supply/l2/:project_id/delivery-progress Response:**
```json
{
  "code": 0,
  "data": {
    "by_center": [
      {
        "center_id": "uuid",
        "center_name": "北京协和医院",
        "requested": 10,
        "approved": 8,
        "shipped": 6,
        "received": 5,
        "progress_rate": 50.0
      }
    ]
  }
}
```

### 3.3 预算统计(项目维度)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l2/:project_id/budget | 获取项目物资预算 |
| GET | /api/supply/l2/:project_id/budget/usage | 预算使用情况 |
| GET | /api/supply/l2/:project_id/consumption | 物资消耗明细 |

**GET /api/supply/l2/:project_id/budget/usage Response:**
```json
{
  "code": 0,
  "data": {
    "total_budget": 500000.00,
    "used_amount": 250000.00,
    "pending_amount": 50000.00,
    "available_amount": 200000.00,
    "usage_rate": 50.0,
    "is_warning": false,
    "by_category": [
      {
        "category_name": "试验用药",
        "budget": 300000.00,
        "used": 150000.00,
        "usage_rate": 50.0
      }
    ]
  }
}
```

---

## 四、L3 中心申请接口 (/api/supply/l3)

### 4.1 物资申请(中心维度)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l3/:center_id/requests | 获取中心申请历史 |
| GET | /api/supply/l3/:center_id/requests/pending | 获取待处理申请 |
| POST | /api/supply/l3/:center_id/requests | 新建物资申请 |
| DELETE | /api/supply/l3/:center_id/requests/:id | 取消申请(待审批) |

**POST /api/supply/l3/:center_id/requests**
```json
{
  "project_id": "uuid",
  "supply_type": "CLINICAL_SUPPLY",
  "urgency": "NORMAL",
  "expected_date": "2024-06-30",
  "items": [
    {
      "item_id": "uuid",
      "request_qty": 10,
      "remark": "试验用药补充"
    }
  ],
  "remark": "项目急需，请尽快处理"
}
```

**Response:**
```json
{
  "code": 0,
  "data": {
    "request_id": "uuid",
    "request_no": "REQ-2024-000001",
    "status": "PENDING",
    "message": "申请提交成功，等待审批"
  }
}
```

### 4.2 收货确认(中心维度)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l3/:center_id/deliveries/pending | 获取待收货列表 |
| POST | /api/supply/l3/:center_id/receive | 确认收货 |
| GET | /api/supply/l3/:center_id/receive/history | 收货历史 |

**POST /api/supply/l3/:center_id/receive**
```json
{
  "delivery_id": "uuid",
  "receive_items": [
    {
      "delivery_item_id": "uuid",
      "actual_qty": 10,
      "qualified_qty": 10,
      "damaged_qty": 0,
      "batch_no": "BATCH-2024-001",
      "is_qualified": true
    }
  ],
  "signed_file": "upload_path",
  "remark": "外观完好，数量核对正确"
}
```

### 4.3 库存查询(中心维度)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/l3/:center_id/stock | 获取中心常用物资库存 |
| GET | /api/supply/l3/:center_id/quick-items | 快速申请物资列表 |

---

## 五、通用查询接口

### 5.1 字典接口

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/supply/dict/urgency | 紧急程度枚举 |
| GET | /api/supply/dict/unit | 计量单位枚举 |
| GET | /api/supply/dict/delivery-status | 发放状态枚举 |
| GET | /api/supply/dict/purchase-status | 采购状态枚举 |

---

## 六、错误码定义

| 错误码 | 说明 |
|-------|------|
| 10001 | 物资不存在 |
| 10002 | 库存不足 |
| 10003 | 申请不存在 |
| 10004 | 申请已审批无法修改 |
| 10005 | 采购单不存在 |
| 10006 | 供应商不存在 |
| 10007 | 仓库不存在 |
| 10008 | 发放单不存在 |
| 10009 | 收货单不存在 |
| 10010 | 权限不足 |

---

*文档版本 V1.0 | 2026-06-20*
