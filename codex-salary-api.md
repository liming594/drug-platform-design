# HR 薪资管理模块 API路由规范 (salary-api.md)
> 后端: Node.js + Express
> 数据库: salary.db (better-sqlite3, WAL模式)
> 路由前缀: /api/salary/
> 零耦合原则: 独立DB, 跨域走HTTP API

---

## 1. 文件结构

```
server/routes/salary/
├── db.js                  ← salary.db 连接 + 建表
├── structure.js           ← 薪资结构 CRUD + 调薪
├── social-insurance.js    ← 社保公积金配置 CRUD
├── tax-config.js          ← 个税配置 CRUD
├── batch.js               ← 发薪批次管理
├── record.js              ← 薪资明细查看/编辑
├── report.js              ← 薪资报表
└── calculator.js          ← 薪资计算引擎
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'salary.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表(idempotent) — 将 salary-sql.md 中的全部SQL粘贴于此
const SCHEMA = `...`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

在 server/app.js 或 index.js 中：

```javascript
// 薪资管理模块
app.use('/api/salary/structures', require('./routes/salary/structure'));
app.use('/api/salary/social-insurance', require('./routes/salary/social-insurance'));
app.use('/api/salary/tax-config', require('./routes/salary/tax-config'));
app.use('/api/salary/batches', require('./routes/salary/batch'));
app.use('/api/salary/records', require('./routes/salary/record'));
app.use('/api/salary/reports', require('./routes/salary/report'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- 逻辑外键不建物理FK，应用层校验关联数据存在性
- UUID用 `crypto.randomUUID()`
- created_at/updated_at 用 `new Date().toISOString()`
- 跨域获取人员数据: HTTP GET /api/hr/members (通过axios/fetch)
- 权限中间件: 所有路由需校验角色权限

---

## 5. 薪资结构 CRUD (structure.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?member_id=&department_name=&position_type=&keyword=&is_current=&page=&size=` |
| GET | /current/:memberId | 获取某员工当前生效薪资结构 |
| GET | /history/:memberId | 获取某员工薪资变更历史 |
| POST | / | 新增薪资结构(含调薪逻辑) |
| PUT | /:structureId | 编辑(仅DRAFT/未使用的结构可编辑) |
| DELETE | /:structureId | 删除(仅未使用的结构可删) |

**POST / body：**
```json
{
  "member_id": "uuid",
  "base_salary": 4000,
  "position_allowance": 2500,
  "rank_salary": 6000,
  "duty_salary": 5500,
  "position_grade": "B-2",
  "rank_grade": "PM-1",
  "transport_subsidy": 100,
  "computer_subsidy": 100,
  "meal_subsidy": 345,
  "other_subsidy": 0,
  "effective_date": "2026-06-01",
  "change_reason": "入职定薪",
  "remark": ""
}
```

**POST / 逻辑（调薪）：**
1. 校验member_id存在(调用HR API: GET /api/hr/members/:memberId)
2. 获取member当前薪资结构(如存在)
3. 旧结构 → `is_current=0`
4. INSERT新结构 → `is_current=1`, `previous_structure_id=旧结构ID`
5. INSERT salary_change_log
6. 返回新结构完整对象

**GET /current/:memberId 响应：**
```json
{
  "structure_id": "uuid",
  "member_id": "uuid",
  "member_name": "王英辉",
  "department_name": "医学运营部",
  "base_salary": 4000,
  "position_allowance": 2500,
  "rank_salary": 6000,
  "duty_salary": 5500,
  "total_monthly": 18545,
  "effective_date": "2026-03-01",
  "is_current": 1,
  "change_reason": "晋升调薪",
  "region_code": "BJ"
}
```

---

## 6. 社保公积金配置 CRUD (social-insurance.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?region_code=&config_year=&status=&page=&size=` |
| GET | /:insuranceId | 详情 |
| POST | / | 新增配置 |
| PUT | /:insuranceId | 编辑 |
| DELETE | /:insuranceId | 删除(仅未被引用的可删) |
| POST | /copy | 按区域复制(新年度复用去年比例) |

**POST / body：**
```json
{
  "region_code": "BJ",
  "region_name": "北京",
  "config_year": 2026,
  "base_min": 6326,
  "base_max": 35283,
  "pension_company": 16,
  "pension_personal": 8,
  "medical_company": 9.8,
  "medical_personal": 2,
  "unemployment_company": 0.5,
  "unemployment_personal": 0.5,
  "injury_company": 0.2,
  "injury_personal": 0,
  "maternity_company": 0.8,
  "maternity_personal": 0,
  "housing_company": 12,
  "housing_personal": 12,
  "disability_company": 1.5,
  "disability_personal": 0
}
```

**POST /copy body：**
```json
{
  "source_year": 2025,
  "target_year": 2026,
  "region_code": "BJ",
  "update_base": true,
  "base_min": 6326,
  "base_max": 35283
}
```

---

## 7. 个税配置 CRUD (tax-config.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?config_year=`，默认返回当年 |
| GET | /:taxId | 详情 |
| POST | / | 新增税率档位 |
| PUT | /:taxId | 编辑 |
| DELETE | /:taxId | 删除 |
| POST | /init-year | 初始化年度税率表(复制上一年) |

**POST / body：**
```json
{
  "config_year": 2026,
  "tax_threshold": 5000,
  "bracket_min": 0,
  "bracket_max": 36000,
  "tax_rate": 3,
  "quick_deduction": 0,
  "sort_order": 1
}
```

**POST /init-year body：**
```json
{
  "source_year": 2025,
  "target_year": 2026
}
```

---

## 8. 发薪批次管理 (batch.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?batch_month=&batch_status=&page=&size=` |
| GET | /:batchId | 详情，含汇总统计 |
| POST | / | 新建批次 |
| POST | /:batchId/generate | 生成薪资明细 |
| POST | /:batchId/submit | 提交审批 |
| POST | /:batchId/approve | 审批通过(审批回调) |
| POST | /:batchId/pay | 确认发放 |
| POST | /:batchId/cancel | 作废批次 |
| POST | /:batchId/import | 导入OA历史数据 |

**POST / body（新建批次）：**
```json
{
  "batch_month": "2026-06",
  "batch_name": "2026年6月薪资",
  "remark": ""
}
```

**POST /:batchId/generate 逻辑（核心）：**
1. 校验batch_status=DRAFT或GENERATED
2. 调用HR API获取在职人员列表: GET /api/hr/members?status=ACTIVE,PROBATION
3. 过滤已有record的member（跳过，支持追加）
4. 遍历每位人员：
   a. 获取当前薪资结构: GET /api/salary/structures/current/:memberId
   b. 获取社保配置: 根据member的region_code查salary_social_insurance
   c. 计算应发合计
   d. 计算社保公积金(公司/个人)
   e. 计算个税(累计预扣法，查询本年1月至上月已有record)
   f. 计算实发
   g. INSERT salary_record
5. 更新batch: employee_count, 各total字段, batch_status=GENERATED
6. 返回批次详情

**POST /:batchId/submit 逻辑：**
1. 校验batch_status=GENERATED
2. 调用审批API创建审批单
3. batch_status=PENDING_APPROVAL, submitted_at=now
4. 返回批次对象

**POST /:batchId/approve 逻辑：**
1. 校验batch_status=PENDING_APPROVAL
2. batch_status=APPROVED, approved_at=now
3. 返回批次对象

**POST /:batchId/pay 逻辑：**
1. 校验batch_status=APPROVED
2. batch_status=PAID, paid_at=now
3. 返回批次对象

**POST /:batchId/import body（导入OA数据）：**
```json
{
  "records": [
    {
      "member_id": "uuid",
      "member_name": "王英辉",
      "department_name": "医学运营部",
      "base_salary": 4000,
      "position_allowance": 2500,
      "rank_salary": 6000,
      "duty_salary": 5500,
      "gross_pay": 18545,
      "attendance_days": 23,
      "clock_days": 23,
      "leave_days": 0,
      "attendance_pay": 18000,
      "salary_pay": 18000,
      "transport_subsidy": 100,
      "computer_subsidy": 100,
      "meal_subsidy": 345,
      "company_pension": 760,
      "personal_pension": 320,
      "company_medical": 508,
      "personal_medical": 104.6,
      "company_unemployment": 32,
      "personal_unemployment": 8,
      "company_injury": 10.16,
      "company_maternity": 40.64,
      "company_housing": 1200,
      "personal_housing": 1200,
      "company_disability": 50.16,
      "personal_disability": 9.12,
      "pre_tax_amount": 16903.28,
      "tax_amount": 2345.82,
      "net_pay": 14557.46,
      "company_cost": 22396.12,
      "region_code": "BJ",
      "position_grade": "B-2",
      "rank_grade": "PM-1",
      "is_probation": 0
    }
  ]
}
```

**GET /:batchId 响应：**
```json
{
  "batch_id": "uuid",
  "batch_no": "SB-202606",
  "batch_month": "2026-06",
  "batch_name": "2026年6月薪资",
  "employee_count": 156,
  "gross_pay_total": 852340,
  "net_pay_total": 621580,
  "company_cost_total": 1024150,
  "tax_total": 128860,
  "social_insurance_company_total": 128000,
  "social_insurance_personal_total": 54230,
  "housing_fund_company_total": 48672,
  "housing_fund_personal_total": 48672,
  "batch_status": "GENERATED",
  "generated_at": "2026-06-18T10:00:00Z",
  "records": [
    {
      "record_id": "uuid",
      "member_id": "uuid",
      "member_name": "王英辉",
      "department_name": "医学运营部",
      "position_type": "PM",
      "gross_pay": 18545,
      "personal_total": 2841.72,
      "tax_amount": 2345.82,
      "net_pay": 14557.46,
      "company_cost": 22396.12
    }
  ],
  "summary": {
    "by_department": [
      { "department_name": "临床运营部", "count": 68, "gross_pay": 380000, "net_pay": 277000 },
      { "department_name": "医学部", "count": 24, "gross_pay": 120000, "net_pay": 87000 }
    ],
    "by_position": [
      { "position_type": "PM", "count": 8, "gross_pay": 144000, "net_pay": 105000 },
      { "position_type": "CRA", "count": 42, "gross_pay": 252000, "net_pay": 184000 }
    ]
  }
}
```

---

## 9. 薪资明细 (record.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 列表，`?batch_id=&member_id=&department_name=&position_type=&keyword=&page=&size=` |
| GET | /:recordId | 详情(含完整计算过程) |
| PUT | /:recordId | 编辑(手动调整) |
| GET | /member/:memberId/history | 某人月度薪资历史 |
| GET | /member/:memberId/current-month | 某人当月薪资 |

**PUT /:recordId body（手动调整）：**
```json
{
  "attendance_deduction": 0,
  "other_deduction": 0,
  "adjustment": 0,
  "bonus": 0,
  "remark": "手动调整: 补发3月差旅",
  "is_manual": 1
}
```

**PUT / 逻辑：**
1. 仅GENERATED状态的批次中的record可编辑
2. 手动调整后重新计算: pre_tax_amount → tax_amount → net_pay → company_cost
3. 更新batch汇总total字段

**GET /:recordId 响应（完整计算过程）：**
```json
{
  "record_id": "uuid",
  "batch_id": "uuid",
  "member_id": "uuid",
  "member_name": "王英辉",
  "department_name": "医学运营部",
  "position_type": "PM",
  "position_grade": "B-2",
  "rank_grade": "PM-1",
  "region_code": "BJ",
  "is_probation": 0,
  "base_salary": 4000,
  "position_allowance": 2500,
  "rank_salary": 6000,
  "duty_salary": 5500,
  "transport_subsidy": 100,
  "computer_subsidy": 100,
  "meal_subsidy": 345,
  "gross_pay": 18545,
  "attendance_days": 23,
  "clock_days": 23,
  "leave_days": 0,
  "attendance_pay": 18000,
  "salary_pay": 18000,
  "attendance_deduction": 0,
  "other_deduction": 0,
  "adjustment": 0,
  "bonus": 0,
  "company_pension": 760,
  "company_medical": 508,
  "company_unemployment": 32,
  "company_injury": 10.16,
  "company_maternity": 40.64,
  "company_housing": 1200,
  "company_disability": 50.16,
  "company_social_total": 2600.96,
  "company_housing_total": 1200,
  "company_total": 3851.12,
  "personal_pension": 320,
  "personal_medical": 104.6,
  "personal_unemployment": 8,
  "personal_housing": 1200,
  "personal_social_total": 1641.72,
  "personal_housing_total": 1200,
  "personal_total": 2841.72,
  "pre_tax_amount": 16903.28,
  "cumulative_income": 101419.68,
  "cumulative_taxable": 37419.68,
  "tax_rate": 10,
  "quick_deduction": 2520,
  "cumulative_tax": 1201.97,
  "cumulative_paid_tax": 0,
  "tax_amount": 2345.82,
  "net_pay": 14557.46,
  "company_cost": 22396.12,
  "is_manual": 0,
  "remark": ""
}
```

---

## 10. 薪资报表 (report.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | /monthly-summary | 月度汇总，`?batch_month=` |
| GET | /department-stats | 部门统计，`?batch_month=` |
| GET | /yearly-accumulation | 年度累计，`?year=` |
| GET | /cost-analysis | 人力成本分析，`?project_id=&year=&month=` |
| GET | /dashboard | 总览Dashboard数据 |

**GET /monthly-summary 响应：**
```json
{
  "batch_month": "2026-06",
  "employee_count": 156,
  "gross_pay_total": 852340,
  "net_pay_total": 621580,
  "company_cost_total": 1024150,
  "tax_total": 128860,
  "social_insurance_company_total": 128000,
  "social_insurance_personal_total": 54230,
  "housing_fund_company_total": 48672,
  "housing_fund_personal_total": 48672,
  "trend": [
    { "month": "2026-01", "gross_pay": 780000, "net_pay": 570000, "count": 148 },
    { "month": "2026-02", "gross_pay": 795000, "net_pay": 581000, "count": 149 },
    { "month": "2026-03", "gross_pay": 810000, "net_pay": 592000, "count": 150 },
    { "month": "2026-04", "gross_pay": 798000, "net_pay": 585000, "count": 151 },
    { "month": "2026-05", "gross_pay": 826000, "net_pay": 605000, "count": 153 },
    { "month": "2026-06", "gross_pay": 852340, "net_pay": 621580, "count": 156 }
  ]
}
```

**GET /department-stats 响应：**
```json
{
  "batch_month": "2026-06",
  "departments": [
    {
      "department_name": "临床运营部",
      "employee_count": 68,
      "gross_pay": 380000,
      "net_pay": 277000,
      "company_cost": 456000,
      "avg_gross": 5588,
      "avg_net": 4074
    },
    {
      "department_name": "医学部",
      "employee_count": 24,
      "gross_pay": 120000,
      "net_pay": 87000,
      "company_cost": 144000,
      "avg_gross": 5000,
      "avg_net": 3625
    }
  ]
}
```

**GET /yearly-accumulation 响应：**
```json
{
  "year": 2026,
  "months_count": 6,
  "total_employees": 156,
  "gross_pay_ytd": 5021000,
  "net_pay_ytd": 3659000,
  "company_cost_ytd": 6048000,
  "tax_ytd": 772000,
  "monthly_detail": [
    { "month": "2026-01", "gross_pay": 780000, "net_pay": 570000, "count": 148 },
    { "month": "2026-02", "gross_pay": 795000, "net_pay": 581000, "count": 149 },
    { "month": "2026-03", "gross_pay": 810000, "net_pay": 592000, "count": 150 },
    { "month": "2026-04", "gross_pay": 798000, "net_pay": 585000, "count": 151 },
    { "month": "2026-05", "gross_pay": 826000, "net_pay": 605000, "count": 153 },
    { "month": "2026-06", "gross_pay": 852340, "net_pay": 621580, "count": 156 }
  ]
}
```

**GET /dashboard 响应：**
```json
{
  "current_month": "2026-06",
  "current_batch_status": "GENERATED",
  "stats": {
    "gross_pay": 852340,
    "net_pay": 621580,
    "company_cost": 1024150,
    "employee_count": 156,
    "new_hires": 3,
    "gross_pay_change_pct": 3.2
  },
  "trend_6m": [...],
  "department_distribution": [
    { "department_name": "临床运营部", "gross_pay": 380000 },
    { "department_name": "医学部", "gross_pay": 120000 }
  ],
  "pending_actions": [
    { "type": "generate", "message": "6月薪资批次未生成", "batch_id": "uuid" },
    { "type": "approve", "message": "5月批次待审批", "batch_id": "uuid" },
    { "type": "paid", "message": "4月批次已发放", "batch_id": "uuid" }
  ]
}
```

---

## 11. 薪资计算引擎 (calculator.js)

```javascript
/**
 * 计算社保公积金
 * @param {number} grossPay - 应发合计
 * @param {object} config - salary_social_insurance配置行
 * @returns {object} { company: {...}, personal: {...}, contribution_base }
 */
function calculateSocialInsurance(grossPay, config) {
  // 确定缴纳基数
  const base = Math.min(Math.max(grossPay, config.base_min), config.base_max);

  return {
    contribution_base: base,
    company: {
      pension: base * config.pension_company / 100,
      medical: base * config.medical_company / 100,
      unemployment: base * config.unemployment_company / 100,
      injury: base * config.injury_company / 100,
      maternity: base * config.maternity_company / 100,
      housing: base * config.housing_company / 100,
      disability: base * (config.disability_company || 0) / 100,
    },
    personal: {
      pension: base * config.pension_personal / 100,
      medical: base * config.medical_personal / 100,
      unemployment: base * config.unemployment_personal / 100,
      injury: base * (config.injury_personal || 0) / 100,
      maternity: base * (config.maternity_personal || 0) / 100,
      housing: base * config.housing_personal / 100,
      disability: base * (config.disability_personal || 0) / 100,
    }
  };
}

/**
 * 计算个税(累计预扣法)
 * @param {number} currentPreTax - 本月税前金额
 * @param {number} cumulativeIncome - 年初至上月累计收入
 * @param {number} cumulativePaidTax - 年初至上月已缴个税
 * @param {number} cumulativeSocialPersonal - 年初至上月累计社保公积金(个人)
 * @param {number} months - 累计月数(含本月)
 * @param {Array} taxBrackets - salary_tax_config当前年税率表
 * @returns {object} { tax_amount, cumulative_income, cumulative_taxable, tax_rate, ... }
 */
function calculateTax(currentPreTax, cumulativeIncome, cumulativePaidTax,
                       cumulativeSocialPersonal, months, taxBrackets) {
  const threshold = 5000; // 月起征点
  const currentSocialPersonal = 0; // 由调用方传入本月社保公积金(个人)

  // 累计收入
  const newCumulativeIncome = cumulativeIncome + currentPreTax;

  // 累计免税额
  const cumulativeExemption = threshold * months;

  // 累计专项扣除(社保公积金个人部分)
  const cumulativeSpecialDeduction = cumulativeSocialPersonal + currentSocialPersonal;

  // 累计应纳税所得额
  const cumulativeTaxable = Math.max(0,
    newCumulativeIncome - cumulativeExemption - cumulativeSpecialDeduction
  );

  // 查税率表
  let taxRate = 0.03;
  let quickDeduction = 0;
  for (const bracket of taxBrackets) {
    if (cumulativeTaxable > bracket.bracket_min) {
      taxRate = bracket.tax_rate / 100;
      quickDeduction = bracket.quick_deduction;
    }
  }

  // 累计应纳税额
  const cumulativeTax = cumulativeTaxable * taxRate - quickDeduction;

  // 本月个税
  const taxAmount = Math.max(0, cumulativeTax - cumulativePaidTax);

  return {
    cumulative_income: newCumulativeIncome,
    cumulative_taxable: cumulativeTaxable,
    tax_rate: taxRate * 100,
    quick_deduction: quickDeduction,
    cumulative_tax: cumulativeTax,
    cumulative_paid_tax: cumulativePaidTax,
    tax_amount: taxAmount
  };
}

module.exports = { calculateSocialInsurance, calculateTax };
```

---

## 12. 第一版不做

- ❌ 专项附加扣除自动申报
- ❌ 银行代发接口对接
- ❌ 工资条自动推送
- ❌ 考勤系统自动集成
- ❌ 薪资审批流完整对接(仅做状态流转, 审批走外部审批中心)
