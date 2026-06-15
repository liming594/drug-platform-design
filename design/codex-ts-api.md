# Timesheet API路由规范 (对象线8号: Timesheet)

> 后端: Node.js + Express
> 数据库: timesheet.db (better-sqlite3, WAL模式)
> 跨域JOIN: member_id→member.db读姓名/岗位，project_id→project.db读项目名

---

## 1. 文件结构

```
server/routes/
├── ts/
│   ├── db.js              ← timesheet.db 连接 + 建表
│   ├── entry.js           ← 工时填报（CRUD+提交+暂存）
│   ├── team-plan.js       ← 团队工时安排（经理层）
│   ├── my.js              ← 我的工时（历史查看）
│   ├── stats.js           ← 工时统计（5个仪表盘）
│   ├── admin.js           ← 管理者汇总（大表格透视+导出）
│   ├── category.js        ← 工作类别管理
│   └── budget.js          ← 工时预算管理
├── project-timesheet.js   ← 项目中心工时（项目维度）
└── project-site-timesheet.js ← 中心工时（中心维度）
```

---

## 2. db.js 模板

```javascript
const path = require('path');
const fs = require('fs');
const Database = require('better-sqlite3');

const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

const DB_PATH = path.join(DATA_DIR, 'timesheet.db');
const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// 建表（idempotent）— 将 codex-ts-sql.md 中的全部SQL粘贴于此
const SCHEMA = `...`;
db.exec(SCHEMA);

module.exports = db;
```

---

## 3. 路由注册

```javascript
// 工时模块
app.use('/api/timesheet/entry', require('./routes/ts/entry'));
app.use('/api/timesheet/team', require('./routes/ts/team-plan'));
app.use('/api/timesheet/my', require('./routes/ts/my'));
app.use('/api/timesheet/stats', require('./routes/ts/stats'));
app.use('/api/timesheet/admin', require('./routes/ts/admin'));
app.use('/api/timesheet/categories', require('./routes/ts/category'));
app.use('/api/timesheet/budget', require('./routes/ts/budget'));
// 项目中心
app.use('/api/projects/:projectId/timesheet', require('./routes/project-timesheet'));
app.use('/api/projects/:projectId/sites/:projectSiteId/timesheet', require('./routes/project-site-timesheet'));
```

---

## 4. 通用规则

- 所有 POST/PUT 返回完整对象，前端不用二次查询
- 列表接口统一支持分页: `?page=1&size=20` (默认size=20)
- 列表接口统一支持排序: `?sort=created_at&order=desc`
- 错误统一格式: `{ code: 400/404/409/500, message: "具体原因" }`
- UUID用 `crypto.randomUUID()`
- 跨域JOIN：member_id→member.db读name/position_type，project_id→project.db读project_name
- 周期参数period: `this_week`/`last_week`/`this_month`/`last_month`/`custom`(需传start+end)

---

## 5. 工时填报 (entry.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | /current | 获取当前周工时填报数据，?week_start=(可选，默认本周) |
| POST | / | 新增一条工时（项目/非项目） |
| PUT | /:entryId | 编辑一条工时 |
| DELETE | /:entryId | 删除一条工时（仅PLANNING状态） |
| POST | /submit | 提交本周工时（PLANNING→REPORTED） |
| POST | /save-draft | 暂存本周工时 |

**GET /current 响应：**
```json
{
  "week_start": "2026-06-08",
  "plan_period": { "start": "2026-06-13", "end": "2026-06-19" },
  "actual_period": { "start": "2026-06-06", "end": "2026-06-12" },
  "deadline": "2026-06-12T16:00:00",
  "status": "PLANNING",
  "plan_total": 40,
  "actual_total": 38,
  "entries": [
    {
      "entry_id": "...",
      "project_id": "PD-001",
      "project_name": "肿瘤项目",
      "project_site_id": "PS-001",
      "site_name": "北京协和",
      "position_role": "CRA",
      "publisher_id": "...",
      "publisher_name": "张三",
      "is_non_project": 0,
      "plan_category_id": "...",
      "plan_category_name": "常规监查",
      "plan_content": "SDV+源数据核查",
      "plan_hours": 16,
      "actual_category_id": "...",
      "actual_category_name": "常规监查",
      "actual_content": "完成SDV",
      "actual_hours": 14,
      "adhoc_task": "",
      "entry_status": "PLANNING"
    }
  ]
}
```

**POST / body：**
```json
{
  "member_id": "uuid",
  "project_id": "uuid",
  "project_site_id": "uuid",
  "publisher_id": "uuid",
  "position_role": "CRA",
  "is_non_project": 0,
  "plan_category_id": "uuid",
  "plan_content": "SDV+源数据核查",
  "plan_hours": 16,
  "actual_category_id": "uuid",
  "actual_content": "完成SDV",
  "actual_hours": 14,
  "adhoc_task": "",
  "remark": ""
}
```

**POST /submit body：**
```json
{ "week_start": "2026-06-08" }
```
逻辑：将该人该周所有PLANNING状态 → REPORTED

**POST /save-draft body：**
```json
{
  "week_start": "2026-06-08",
  "entries": [
    { "entry_id": "uuid", "plan_hours": 16, "actual_hours": 14, "actual_content": "完成SDV" }
  ]
}
```
逻辑：批量更新entries，不改变status

---

## 6. 团队工时安排 (team-plan.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | /plan | 团队下周计划概览，?project_id=&week_start= |
| POST | /plan | 给成员安排计划（publisher_id=当前用户） |
| PUT | /plan/:entryId | 修改已安排的计划 |
| GET | /saturation | 团队饱和度列表，?project_id=&week_start= |

**GET /plan 响应：**
```json
{
  "projects": [
    {
      "project_id": "PD-001",
      "project_name": "肿瘤项目",
      "members": [
        {
          "member_id": "...",
          "member_name": "王五",
          "position_type": "CRA",
          "position_role": "CRA",
          "current_load_pct": 70,
          "plans": [
            {
              "entry_id": "...",
              "site_name": "北京协和",
              "plan_category_name": "常规监查",
              "plan_content": "SDV+源数核",
              "plan_hours": 16,
              "publisher_name": "张三"
            }
          ],
          "plan_total": 28
        }
      ]
    }
  ],
  "saturation_summary": { "normal": 4, "moderate": 2, "low": 3, "over": 0 }
}
```

**POST /plan body：**
```json
{
  "member_id": "uuid",
  "project_id": "uuid",
  "project_site_id": "uuid",
  "position_role": "CRA",
  "plan_category_id": "uuid",
  "plan_content": "SDV+源数据核查",
  "plan_hours": 16
}
```
逻辑：publisher_id自动设为当前用户member_id

**GET /saturation 响应：**
```json
{
  "members": [
    {
      "member_id": "...",
      "member_name": "王五",
      "position_type": "CRA",
      "plan_total": 28,
      "max_hours": 40,
      "load_pct": 70,
      "level": "moderate"
    }
  ]
}
```

**饱和度level规则：**
- `low`: < 32h (80%)
- `moderate`: 32-36h (80-90%)
- `normal`: 36-40h (90-100%)
- `over`: > 40h

---

## 7. 我的工时 (my.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | /weekly | 指定周工时明细，?week_start=2026-06-08 |
| GET | /monthly | 月度汇总，?year=2026&month=6 |
| GET | /range | 日期范围汇总，?start=2026-06-01&end=2026-06-30 |

**GET /weekly 响应：**
```json
{
  "week_start": "2026-06-08",
  "plan_period": { "start": "2026-06-06", "end": "2026-06-12" },
  "actual_period": { "start": "2026-05-30", "end": "2026-06-05" },
  "status": "CONFIRMED",
  "plan_total": 40,
  "actual_total": 34,
  "deviation": -6,
  "entries": [...]
}
```

**GET /monthly 响应：**
```json
{
  "year": 2026,
  "month": 6,
  "projects": [
    { "project_id": "PD-001", "project_name": "肿瘤项目", "plan_total": 60, "actual_total": 54, "deviation": -6 },
    { "project_id": null, "project_name": "非项目", "plan_total": 12, "actual_total": 14, "deviation": 2 }
  ],
  "plan_total": 80,
  "actual_total": 74,
  "deviation": -6
}
```

---

## 8. 工时统计 (stats.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | /saturation | 人员饱和度，?period=&project_id=&company_id=&dept_id=&position_type= |
| GET | /project | 项目工时投入，?period=&project_id= |
| GET | /position | 按岗位工时分布，?period=&position_type= |
| GET | /category | 工作类别分布，?period=&project_id= |
| GET | /budget | 预算vs实际对比，?project_id= |

**GET /saturation 响应：**
```json
{
  "period": "this_week",
  "filters": { "project_id": null, "company_id": null, "dept_id": null, "position_type": null },
  "summary": { "normal": 4, "moderate": 2, "low": 3, "over": 0 },
  "members": [
    {
      "member_id": "...",
      "member_name": "张三",
      "position_type": "PM",
      "company_name": "兴德通",
      "dept_name": "运营部",
      "plan_total": 40,
      "actual_total": 40,
      "max_hours": 40,
      "load_pct": 100,
      "level": "normal"
    }
  ]
}
```

**GET /project 响应：**
```json
{
  "period": "this_month",
  "projects": [
    {
      "project_id": "PD-001",
      "project_name": "肿瘤项目",
      "plan_total": 120,
      "actual_total": 108,
      "deviation": -12,
      "budget_total": 2000,
      "budget_used_pct": 5.4,
      "members_count": 6
    }
  ]
}
```

**GET /budget 响应：**
```json
{
  "project_id": "PD-001",
  "project_name": "肿瘤项目",
  "roles": [
    { "position_role": "PM", "budget_hours": 200, "actual_hours": 48, "used_pct": 24 },
    { "position_role": "CRA", "budget_hours": 600, "actual_hours": 112, "used_pct": 18.7 }
  ]
}
```

---

## 9. 管理者汇总 (admin.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | /summary | 管理者汇总明细表，?period=&project_id=&company_id=&dept_id=&position_type=&status=&keyword= |
| GET | /summary/by-member | 按人员汇总，?period=&project_id= |
| GET | /summary/by-project | 按项目汇总，?period= |
| GET | /summary/export | 导出Excel，同summary参数 |

**GET /summary 响应：**
```json
{
  "period": "this_week",
  "week_start": "2026-06-08",
  "filters": { "project_id": null, "company_id": null, "dept_id": null, "position_type": null, "status": null, "keyword": null },
  "summary": {
    "total_members": 8,
    "reported_count": 7,
    "pending_count": 1,
    "plan_total": 320,
    "actual_total": 298
  },
  "entries": [
    {
      "entry_id": "...",
      "member_id": "...",
      "member_name": "张三",
      "position_type": "PM",
      "dept_name": "运营部",
      "project_id": "PD-001",
      "project_name": "肿瘤项目",
      "project_site_id": null,
      "site_name": "—",
      "position_role": "PM",
      "publisher_name": "张三",
      "plan_category_name": "工作规划",
      "plan_content": "任务下达",
      "plan_hours": 20,
      "actual_category_name": "工作规划",
      "actual_content": "任务下达",
      "actual_hours": 20,
      "entry_status": "REPORTED"
    }
  ]
}
```

**GET /summary/by-member 响应：**
```json
{
  "period": "this_week",
  "members": [
    { "member_id": "...", "member_name": "张三", "position_type": "PM", "plan_total": 40, "actual_total": 40, "deviation": 0, "load_pct": 100, "level": "normal" }
  ]
}
```

**GET /summary/by-project 响应：**
```json
{
  "period": "this_week",
  "projects": [
    { "project_id": "PD-001", "project_name": "肿瘤项目", "plan_total": 200, "actual_total": 178, "deviation": -22, "member_count": 5 },
    { "project_id": null, "project_name": "非项目", "plan_total": 72, "actual_total": 78, "deviation": 6, "member_count": 4 }
  ]
}
```

---

## 10. 项目中心工时 (project-timesheet.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 项目工时明细，?period=&project_site_id=&position_type=&keyword= |
| POST | / | 在项目内新增工时（project_id自动锁定为URL中的projectId） |
| PUT | /:entryId | 编辑工时（校验entry属于本项目） |
| DELETE | /:entryId | 删除工时（仅PLANNING状态，校验属于本项目） |
| GET | /summary | 项目工时汇总，?period= |
| GET | /by-site | 按中心汇总，?period= |
| GET | /by-role | 按角色汇总（含预算对比），?period= |

**POST / body：**
```json
{
  "member_id": "uuid",
  "project_site_id": "uuid",
  "publisher_id": "uuid",
  "position_role": "CRA",
  "plan_category_id": "uuid",
  "plan_content": "SDV+源数据核查",
  "plan_hours": 16,
  "actual_category_id": "uuid",
  "actual_content": "完成SDV",
  "actual_hours": 14,
  "adhoc_task": "",
  "remark": ""
}
```
注意：project_id不需要传，自动从URL取

**GET /summary 响应：**
```json
{
  "project_id": "PD-001",
  "project_name": "肿瘤项目",
  "period": "this_week",
  "week_summary": { "plan_total": 96, "actual_total": 88, "deviation": -8, "member_count": 6 },
  "month_summary": { "plan_total": 320, "actual_total": 298, "deviation": -22, "member_count": 6 },
  "budget_summary": { "budget_total": 2000, "used_total": 88, "used_pct": 4.4 }
}
```

**GET /by-site 响应：**
```json
{
  "project_id": "PD-001",
  "period": "this_week",
  "sites": [
    { "project_site_id": "PS-001", "site_name": "北京协和", "plan_total": 40, "actual_total": 36, "deviation": -4 },
    { "project_site_id": null, "site_name": "未关联中心", "plan_total": 36, "actual_total": 36, "deviation": 0 }
  ]
}
```

**GET /by-role 响应：**
```json
{
  "project_id": "PD-001",
  "period": "this_week",
  "roles": [
    { "position_role": "PM", "plan_total": 20, "actual_total": 20, "deviation": 0, "budget_hours": 200, "used_hours": 20, "used_pct": 10 },
    { "position_role": "CRA", "plan_total": 28, "actual_total": 24, "deviation": -4, "budget_hours": 600, "used_hours": 24, "used_pct": 4 }
  ]
}
```

---

## 11. 中心工时 (project-site-timesheet.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 中心工时明细，?period= |
| POST | / | 在中心内新增工时（project_id+project_site_id自动锁定） |
| PUT | /:entryId | 编辑工时（校验entry属于本中心） |
| DELETE | /:entryId | 删除工时（仅PLANNING状态，校验属于本中心） |
| GET | /trend | 中心工时趋势（近4周） |

**POST / body：**
```json
{
  "member_id": "uuid",
  "publisher_id": "uuid",
  "position_role": "CRA",
  "plan_category_id": "uuid",
  "plan_content": "SDV+源数据核查",
  "plan_hours": 16,
  "actual_category_id": "uuid",
  "actual_content": "完成SDV",
  "actual_hours": 14,
  "adhoc_task": "",
  "remark": ""
}
```
注意：project_id和project_site_id不需要传，自动从URL取

**GET /trend 响应：**
```json
{
  "project_id": "PD-001",
  "project_site_id": "PS-001",
  "site_name": "北京协和医院",
  "weeks": [
    { "week_start": "2026-05-18", "week_label": "第21周", "plan_total": 40, "actual_total": 36 },
    { "week_start": "2026-05-25", "week_label": "第22周", "plan_total": 40, "actual_total": 40 },
    { "week_start": "2026-06-01", "week_label": "第23周", "plan_total": 40, "actual_total": 38 },
    { "week_start": "2026-06-08", "week_label": "第24周", "plan_total": 40, "actual_total": 36 }
  ]
}
```

---

## 12. 工作类别管理 (category.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | / | 工作类别列表，?group=&is_active=1 |
| POST | / | 新增工作类别 |
| PUT | /:categoryId | 编辑工作类别 |
| PUT | /:categoryId/toggle | 启停工作类别，body: `{ is_active: 0/1 }` |

**POST / body：**
```json
{
  "category_code": "SITE_DAILY",
  "category_name": "中心日常维护与管理",
  "category_group": "CENTER_OPS",
  "is_site_required": 1,
  "sort_order": 10
}
```

---

## 13. 工时预算管理 (budget.js)

| Method | Path | Description |
|--------|------|-------------|
| GET | /:projectId | 获取项目工时预算 |
| POST | / | 新增工时预算 |
| PUT | /:budgetId | 编辑工时预算 |
| DELETE | /:budgetId | 删除工时预算 |

**POST / body：**
```json
{
  "project_id": "uuid",
  "position_role": "PM",
  "budget_hours": 200,
  "start_from": "从完成数据库锁库阶段开始",
  "remark": ""
}
```

**GET /:projectId 响应：**
```json
{
  "project_id": "PD-001",
  "project_name": "肿瘤项目",
  "budgets": [
    { "budget_id": "...", "position_role": "PM", "budget_hours": 200, "actual_hours": 48, "used_pct": 24, "start_from": "" },
    { "budget_id": "...", "position_role": "CRA", "budget_hours": 600, "actual_hours": 112, "used_pct": 18.7, "start_from": "" }
  ],
  "total_budget": 800,
  "total_actual": 160,
  "total_used_pct": 20
}
```

---

## 14. 第一版不做

- ❌ 工时审批流（先自填自报，后续加审批）
- ❌ 自动同步领导任务安排（第一版手动填，后续接任务系统）
- ❌ 移动端工时填写
- ❌ 工时自动排班/智能推荐
- ❌ 仪表盘自定义拖拽布局（第一版固定5个仪表盘）
- ❌ 工时导出PDF（只做Excel导出）
