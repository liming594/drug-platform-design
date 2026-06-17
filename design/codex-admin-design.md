# 平台管理模块 — 设计文档

> 全平台统一身份/权限/组织基础设施，所有业务模块共享 admin.db。
> 核心目标：**一套RBAC管全平台，业务模块不再自建用户/角色/权限。**

---

## 一、定位与边界

```
┌──────────────────────────────────────────────────┐
│              平台管理 Admin（L1）                   │
│  用户·角色·权限·部门·字典·配置·日志·模块            │
│  admin.db — 唯一身份权限源                          │
└──────────┬──────────┬──────────┬──────────────────┘
           │          │          │
    ┌──────▼──┐ ┌─────▼───┐ ┌───▼──────┐
    │审批引擎  │ │预算/费用 │ │其他业务模块│
    │查动态审批人│ │查角色权限 │ │查用户/部门│
    └─────────┘ └─────────┘ └──────────┘
     只读admin API，不直接访问admin.db
```

**管什么：**
- 用户全生命周期（创建→分配角色→停用）
- RBAC三件套（角色→权限→数据范围）
- 组织架构（部门树+负责人）
- 数据字典（下拉选项统一管理）
- 系统配置（全局参数）
- 操作日志（审计追踪）
- 模块注册（平台内模块发现与状态管理）

**不管什么：**
- 业务数据（各模块独立库）
- 审批流程（approval.db）
- 前端路由守卫（前端按权限树渲染菜单，admin只提供数据）

---

## 二、架构设计

### 2.1 RBAC模型（三层角色驱动）

```
┌─ 第一层：组织岗位权限（HR自动驱动，覆盖90%的人）──────────┐
│                                                           │
│   HR入职定岗 → position_type + is_leader                  │
│       ↓                                                   │
│   岗位权限配置（position_role_mapping + accessible_modules）│
│       ↓                                                   │
│   部门负责人(HR组织架构) → 审批权 + 部门数据范围            │
│   普通员工 → 基础权限底座 + 本人数据范围                    │
│   岗位叠加权限 → 对应业务菜单 + API权限                     │
│                                                           │
│   不需要任何人手动操作，入职即生效                          │
└───────────────────────────────────────────────────────────┘

┌─ 第二层：项目岗位权限（项目团队驱动）─────────────────────┐
│                                                           │
│   加入项目团队 → project_role (PM/APM/PI/中心负责人/医学负责人) │
│       ↓                                                   │
│   项目岗位权限配置（project_role_mapping + accessible_modules）│
│       ↓                                                   │
│   同一人不同项目可以有不同角色                              │
│   例：入职CRA → 项目内担任APM → 获得项目管理模块权限        │
│   项目PM → 项目内全模块读写                                │
│   中心负责人 → 本中心数据权限                              │
│                                                           │
│   项目管理员配置，审批流程按项目角色路由                    │
└───────────────────────────────────────────────────────────┘

┌─ 第三层：领域管理员/权限包（admin手动分配，少数人）───────┐
│                                                           │
│   按业务大类封装"小超管"权限包：                            │
│   ┌────────────┬────────────────────────────────┐         │
│   │ 权限包      │ 覆盖范围                       │         │
│   ├────────────┼────────────────────────────────┤         │
│   │ 财务管理包  │ 预算+费用+合同 全模块读写       │         │
│   │ 项目管理包  │ 项目+中心+审批 全模块读写       │         │
│   │ 行政管理包  │ 行政+物资+印章 全模块读写       │         │
│   │ HR管理包    │ 人员+培训+考勤 全模块读写       │         │
│   │ 全平台管理包│ 等同超级管理员(慎用)            │         │
│   └────────────┴────────────────────────────────┘         │
│       ↓                                                   │
│   管理员在admin界面将权限包分配给任何人                      │
│   例：CEO不是财务岗位，但分配"财务管理包"→可看所有财务数据   │
│       BD总监需要看项目进度，分配"项目管理包(只读)"           │
│                                                           │
│   admin是"特殊角色逃逸口"，权限包是标准化分配方式           │
└───────────────────────────────────────────────────────────┘
```

**权限合并规则（取并集，就高不就低）：**

```
最终权限 = HR基础权限 ∪ 项目权限(项目内) ∪ admin特殊权限

示例：
张三 HR定岗CRA → CRA基础权限
张三 在项目A当PM → 项目A内叠加PM权限
张三 在项目B当CRA → 项目B只有CRA权限
张三 被admin加了"数据管理员" → 全平台额外加数据管理权限
```

**角色获取优先级（非项目资源）：**
1. HR基础角色（岗位自动映射）
2. admin追加的特殊角色
3. 合并后取并集

**角色获取优先级（项目资源）：**
1. 项目内角色（team_assignment）
2. HR基础角色
3. admin追加的特殊角色
4. 合并后取并集

### 2.2 权限树结构

权限以树形组织，支持两级：

```
项目管理 (menu: project)
├── 项目列表 (menu: project:list)     → 前端菜单项
├── 创建项目 (api: POST /api/...)     → API权限
├── 删除项目 (api: DELETE /api/...)   → API权限
└── 查看全部 (data: project:all)      → 数据权限

审批管理 (menu: approval)
├── 审批中心 (menu: approval:center)
├── 流程配置 (menu: approval:config)
└── 查看本部门 (data: approval:dept)
```

### 2.3 部门树与审批引擎的关系

```
admin.db                     approval.db
admin_departments            approval_instances
├── 临床研究部                （提交审批时）
│   ├── PM组                  → 查部门负责人: GET /api/admin/departments/head
│   ├── CRA组                 → 查直属上级:   GET /api/admin/users/:id/manager
│   └── CRC组
└── 质量管理部

审批引擎跨域调用 admin API，不直接访问 admin.db
```

---

## 三、数据库设计（admin.db）

### 3.1 完整表清单（17表）

| # | 表名 | 说明 | 核心字段 |
|---|------|------|---------|
| 1 | admin_users | 用户 | username, password_hash, real_name, member_id, status |
| 2 | admin_roles | 角色（权限包定义） | role_code, role_name, is_system, status |
| 3 | admin_permissions | 权限 | perm_code, perm_type(menu/api/data), parent_id |
| 4 | admin_role_permissions | 角色↔权限 | role_id, permission_id |
| 5 | admin_user_roles | 用户↔角色 | user_id, role_id, role_source(hr/project/admin), permission_pack_id |
| 6 | admin_departments | 部门 | dept_code, dept_name, parent_id, hr_dept_id, leader_user_id |
| 7 | admin_dept_users | 部门↔用户 | dept_id, user_id, is_primary |
| 8 | admin_data_scopes | 数据范围 | role_id, scope_type, scope_value |
| 9 | admin_position_role_mapping | 岗位权限配置 | position_type, is_leader, role_code, accessible_modules, data_scope |
| 10 | admin_data_dict | 数据字典 | category, dict_code, value, label |
| 11 | admin_sys_config | 系统配置 | config_key, config_value, config_type |
| 12 | admin_operation_logs | 操作日志 | user_id, module, action, detail, ip |
| 13 | admin_modules | 模块注册 | module_code, base_url, status |
| 14 | admin_user_preferences | 用户偏好 | user_id, pref_key, pref_value |
| 15 | admin_project_role_mapping | 项目岗位权限 | project_role, allowed_positions, role_code, accessible_modules |
| 16 | admin_permission_packs | 权限包 | name, pack_type(domain/composite/custom), modules, data_scope |
| 17 | admin_permission_pack_users | 权限包↔用户 | pack_id, user_id, assigned_by |

### 3.2 各表详细字段

**admin_users**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| username | TEXT | UNIQUE NOT NULL | 登录名 |
| password_hash | TEXT | NOT NULL | bcrypt |
| real_name | TEXT | NOT NULL | 真实姓名 |
| email | TEXT | | 邮箱 |
| phone | TEXT | | 手机号 |
| avatar | TEXT | | 头像URL |
| member_id | INTEGER | | 关联HR member表ID，入职时同步写入 |
| status | TEXT | DEFAULT 'active' | active/disabled/locked |
| last_login_at | TEXT | | ISO8601 |
| created_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |
| updated_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |

**admin_roles**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| role_code | TEXT | UNIQUE NOT NULL | 角色编码 |
| role_name | TEXT | NOT NULL | 角色名称 |
| description | TEXT | | |
| is_system | INTEGER | DEFAULT 0 | 系统内置角色不可删除 |
| status | TEXT | DEFAULT 'active' | active/disabled |
| created_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |
| updated_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |

**admin_permissions**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| perm_code | TEXT | UNIQUE NOT NULL | 权限编码，如 project:list |
| perm_name | TEXT | NOT NULL | 显示名称 |
| perm_type | TEXT | NOT NULL | menu / api / data |
| parent_id | INTEGER | FK→self | 0=顶级 |
| path | TEXT | | API路径（perm_type=api时） |
| method | TEXT | | HTTP方法（perm_type=api时） |
| icon | TEXT | | 菜单图标（perm_type=menu时） |
| route | TEXT | | 前端路由（perm_type=menu时） |
| sort_order | INTEGER | DEFAULT 0 | |
| status | TEXT | DEFAULT 'active' | |
| created_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |

**admin_role_permissions**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| role_id | INTEGER | FK→admin_roles NOT NULL | |
| permission_id | INTEGER | FK→admin_permissions NOT NULL | |
| UNIQUE(role_id, permission_id) | | | |

**admin_user_roles**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| user_id | INTEGER | FK→admin_users NOT NULL | |
| role_id | INTEGER | FK→admin_roles NOT NULL | |
| role_source | TEXT | NOT NULL DEFAULT 'hr' | hr=HR岗位自动分配 / project=项目团队分配 / admin=管理员手动分配 |
| project_id | TEXT | | role_source=project时关联的项目ID |
| UNIQUE(user_id, role_id, role_source, project_id) | | | |

**admin_departments**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| dept_code | TEXT | UNIQUE NOT NULL | 部门编码 |
| dept_name | TEXT | NOT NULL | |
| parent_id | INTEGER | DEFAULT 0 | 0=顶级部门 |
| hr_dept_id | INTEGER | | 关联HR department表ID，组织架构同步用 |
| leader_user_id | INTEGER | FK→admin_users | 部门负责人 |
| sort_order | INTEGER | DEFAULT 0 | |
| status | TEXT | DEFAULT 'active' | active/disabled |
| created_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |
| updated_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |

**admin_dept_users**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| dept_id | INTEGER | FK→admin_departments NOT NULL | |
| user_id | INTEGER | FK→admin_users NOT NULL | |
| is_primary | INTEGER | DEFAULT 1 | 主部门=1，兼职=0 |
| UNIQUE(dept_id, user_id) | | | |

**admin_data_scopes**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| role_id | INTEGER | FK→admin_roles NOT NULL | |
| scope_type | TEXT | NOT NULL | all/dept/dept_sub/self/custom |
| scope_value | TEXT | | scope_type=custom时存部门ID列表JSON |

**admin_position_role_mapping（岗位→角色映射，HR联动核心）**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| position_type | TEXT | NOT NULL | HR岗位编码：PM/CRA/CRC/QA/DM/BD/财务/人事/... |
| is_leader | INTEGER | NOT NULL DEFAULT 0 | 是否部门负责人：1=是/0=否 |
| role_code | TEXT | NOT NULL FK→admin_roles | 对应的角色编码 |
| description | TEXT | | 说明 |
| UNIQUE(position_type, is_leader) | | | 同岗位+是否负责人唯一 |

**映射逻辑：** HR入职/调岗时，根据 position_type + is_leader 自动查此表，写入 admin_user_roles(role_source='hr')

**admin_data_dict**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| category | TEXT | NOT NULL | 分类：project_type/contract_status/... |
| dict_code | TEXT | NOT NULL | 字典编码 |
| value | TEXT | NOT NULL | 存储值 |
| label | TEXT | NOT NULL | 显示值 |
| sort_order | INTEGER | DEFAULT 0 | |
| status | TEXT | DEFAULT 'active' | active/disabled |
| created_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |
| UNIQUE(category, dict_code) | | | |

**admin_sys_config**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| config_key | TEXT | UNIQUE NOT NULL | 配置键 |
| config_value | TEXT | | 配置值 |
| config_type | TEXT | DEFAULT 'string' | string/number/json/boolean |
| description | TEXT | | |
| created_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |
| updated_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |

**admin_operation_logs**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| user_id | INTEGER | | 操作人 |
| module | TEXT | NOT NULL | 模块名 |
| action | TEXT | NOT NULL | create/read/update/delete/login |
| target_type | TEXT | | 操作对象类型 |
| target_id | TEXT | | 操作对象ID |
| detail | TEXT | | JSON详情 |
| ip | TEXT | | 客户端IP |
| user_agent | TEXT | | |
| created_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |

**admin_modules**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| module_code | TEXT | UNIQUE NOT NULL | 模块编码 |
| module_name | TEXT | NOT NULL | 模块名称 |
| module_type | TEXT | DEFAULT 'business' | core/business |
| base_url | TEXT | | 模块API基础路径 |
| icon | TEXT | | 菜单图标 |
| sort_order | INTEGER | DEFAULT 0 | |
| status | TEXT | DEFAULT 'active' | active/disabled/maintenance |
| registered_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |

**admin_user_preferences**
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INTEGER | PK AUTO | |
| user_id | INTEGER | FK→admin_users NOT NULL | |
| pref_key | TEXT | NOT NULL | 偏好键 |
| pref_value | TEXT | | 偏好值 |
| updated_at | TEXT | DEFAULT CURRENT_TIMESTAMP | |
| UNIQUE(user_id, pref_key) | | | |

---

## 四、预置数据

### 4.1 系统角色（is_system=1）

| role_code | role_name | 说明 | 来源 |
|-----------|-----------|------|------|
| super_admin | 超级管理员 | 全平台权限，不可删除 | admin手动 |
| admin | 管理员 | 用户/角色/部门管理 | admin手动 |
| pm | 项目经理 | 项目全模块读写 | HR岗位映射 |
| cra | CRA | 临床监查相关 | HR岗位映射 |
| crc | CRC | 临床协调相关 | HR岗位映射 |
| dm | 数据管理员 | 数据管理相关 | HR岗位映射 |
| qa | 质量管理员 | QA相关 | HR岗位映射 |
| bd | 商务发展 | BD相关 | HR岗位映射 |
| finance | 财务 | 预算/费用/合同 | HR岗位映射 |
| hr | 人事 | HR管理 | HR岗位映射 |
| dept_head | 部门负责人 | 部门审批权+部门数据范围 | HR岗位映射(is_leader=1) |
| viewer | 只读用户 | 全平台只读 | 默认兜底 |

### 4.2 预置部门

| dept_code | dept_name | parent_id |
|-----------|-----------|-----------|
| HQ | 总部 | 0 |
| clinical | 临床研究部 | HQ |
| quality | 质量管理部 | HQ |
| finance_dept | 财务部 | HQ |
| hr_dept | 人力资源部 | HQ |
| bd_dept | 商务发展部 | HQ |
| data_mgmt | 数据管理部 | clinical |
| pm_group | PM组 | clinical |
| cra_group | CRA组 | clinical |
| crc_group | CRC组 | clinical |

### 4.3 预置权限树

```
项目管理 (menu)
├── 项目列表 (menu, route=/project)
├── 创建项目 (api, POST /api/project)
├── 编辑项目 (api, PUT /api/project/:id)
├── 删除项目 (api, DELETE /api/project/:id)
├── 查看全部项目 (data, project:all)
├── 查看本部门项目 (data, project:dept)
└── 查看自己的项目 (data, project:self)

审批管理 (menu)
├── 审批中心 (menu, route=/approval)
├── 流程配置 (menu, route=/approval/config)
├── 提交审批 (api, POST /api/approval/instances)
├── 审批操作 (api, PUT /api/approval/instances/:id/action)
└── 查看全部审批 (data, approval:all)

预算管理 (menu)
├── 预算列表 (menu, route=/budget)
├── 创建预算 (api, POST /api/budget)
└── 审批预算 (api, PUT /api/budget/:id/approve)

费用管理 (menu)
├── 费用列表 (menu, route=/expense)
├── 创建报销 (api, POST /api/expense)
└── 审批费用 (api, PUT /api/expense/:id/approve)

合同管理 (menu)
├── 合同列表 (menu, route=/contract)
├── 创建合同 (api, POST /api/contract)
└── 查看全部合同 (data, contract:all)

系统管理 (menu)
├── 用户管理 (menu, route=/admin/users)
├── 角色管理 (menu, route=/admin/roles)
├── 部门管理 (menu, route=/admin/departments)
├── 数据字典 (menu, route=/admin/dict)
├── 系统配置 (menu, route=/admin/config)
├── 操作日志 (menu, route=/admin/logs)
├── 模块管理 (menu, route=/admin/modules)
├── 管理用户 (api, POST /api/admin/users)
├── 管理角色 (api, POST /api/admin/roles)
├── 管理部门 (api, POST /api/admin/departments)
└── 管理配置 (api, PUT /api/admin/config/:key)
```

### 4.4 预置数据字典

| category | dict_code | value | label |
|----------|-----------|-------|-------|

### 4.5 岗位→角色映射（position_role_mapping）

| position_type | is_leader | role_code | 说明 |
|---------------|-----------|-----------|------|
| PM | 0 | pm | 项目经理 |
| PM | 1 | dept_head | PM组负责人 |
| CRA | 0 | cra | 临床监查员 |
| CRA | 1 | dept_head | CRA组负责人 |
| CRC | 0 | crc | 临床协调员 |
| CRC | 1 | dept_head | CRC组负责人 |
| DM | 0 | dm | 数据管理员 |
| DM | 1 | dept_head | 数据管理部负责人 |
| QA | 0 | qa | 质量管理员 |
| QA | 1 | dept_head | 质量管理部负责人 |
| BD | 0 | bd | 商务发展 |
| BD | 1 | dept_head | BD组负责人 |
| 财务 | 0 | finance | 财务人员 |
| 财务 | 1 | dept_head | 财务部负责人 |
| 人事 | 0 | hr | HR人员 |
| 人事 | 1 | dept_head | HR部负责人 |

**映射规则：**
- HR入职定岗(position_type) → 自动查此表 → 写入admin_user_roles(role_source='hr')
- HR调岗 → 删除旧角色(hr source) → 写入新角色(hr source)
- is_leader=1的人额外获得dept_head角色 → 审批权 + 本部门数据范围
| project_type | ct | ct | CT |
| project_type | be | be | BE |
| project_type | pk | pk | PK |
| project_status | planning | planning | 规划中 |
| project_status | ongoing | ongoing | 进行中 |
| project_status | completed | completed | 已完成 |
| project_status | suspended | suspended | 已暂停 |
| contract_type | service | service | 服务合同 |
| contract_type | purchase | purchase | 采购合同 |
| contract_type | nda | nda | 保密协议 |
| expense_type | travel | travel | 差旅 |
| expense_type | office | office | 办公 |
| expense_type | professional | professional | 专业服务 |
| currency | CNY | CNY | 人民币 |
| currency | USD | USD | 美元 |

---

## 五、认证与鉴权流程

### 5.1 登录流程

```
客户端                     admin服务
  │                          │
  │ POST /auth/login         │
  │ {username, password}     │
  │ ──────────────────────→  │
  │                          │ bcrypt比对
  │                          │ 生成JWT (access+refresh)
  │ ←──────────────────────  │
  │ {access_token, refresh}  │
  │                          │
  │ GET /auth/profile        │
  │ Authorization: Bearer    │
  │ ──────────────────────→  │
  │                          │ 查用户+角色+权限
  │ ←──────────────────────  │
  │ {user, roles, menus,    │
  │  permissions}            │
```

### 5.2 Token策略

| Token | 有效期 | 存储 | 用途 |
|-------|--------|------|------|
| access_token | 2小时 | 内存 | API请求 |
| refresh_token | 7天 | httpOnly cookie | 续签 |

### 5.3 权限校验中间件

```javascript
// 路由级权限校验
async function requirePermission(permCode) {
  return async (req, res, next) => {
    const userId = req.user.id
    // 1. 查用户角色
    const roles = await db.all(`
      SELECT r.role_code FROM admin_user_roles ur
      JOIN admin_roles r ON ur.role_id = r.id
      WHERE ur.user_id = ? AND r.status = 'active'`, [userId])
    
    // 2. super_admin直接放行
    if (roles.some(r => r.role_code === 'super_admin')) return next()
    
    // 3. 查角色权限
    const perms = await db.all(`
      SELECT p.perm_code FROM admin_role_permissions rp
      JOIN admin_permissions p ON rp.permission_id = p.id
      JOIN admin_user_roles ur ON ur.role_id = rp.role_id
      WHERE ur.user_id = ? AND p.perm_code = ? AND p.status = 'active'`,
      [userId, permCode])
    
    if (perms.length === 0) return res.status(403).json({code: 403, msg: '无权限'})
    next()
  }
}
```

### 5.4 数据范围过滤

```javascript
// 查询时自动追加数据范围条件
async function applyDataScope(userId, tableName) {
  const scope = await getDataScope(userId)
  switch (scope.scope_type) {
    case 'all': return '' // 无过滤
    case 'self': return `AND ${tableName}.created_by = ${userId}`
    case 'dept':
      const dept = await getPrimaryDept(userId)
      return `AND ${tableName}.dept_id = ${dept.id}`
    case 'dept_sub':
      const deptIds = await getDeptAndSubDepts(userId)
      return `AND ${tableName}.dept_id IN (${deptIds.join(',')})`
    case 'custom':
      return `AND ${tableName}.dept_id IN (${scope.scope_value})`
  }
}
```

---

## 六、审批引擎依赖接口

admin 模块需对外暴露以下API，供审批引擎跨域调用：

| API | 用途 | 审批人类型 |
|-----|------|-----------|
| GET /api/admin/users/:id/manager | 查直属上级 | dynamic_report |
| GET /api/admin/departments/head?userId=:id | 查部门负责人 | dynamic_dept |
| GET /api/admin/users/:id | 查用户基本信息 | 通用 |

**直属上级逻辑：**
1. 查用户主部门 (admin_dept_users.is_primary=1)
2. 查该部门的 leader_user_id
3. 若无负责人 → 向上递归查父部门
4. 到顶仍无 → 返回 null，审批引擎走 fallback_approver

---

## 七、前端架构

### 7.1 L1 平台管理（系统管理员视角）

```
左侧菜单                     右侧内容
┌─────────────┐    ┌──────────────────────────────────────┐
│ 系统管理 ▼   │    │ 用户管理                              │
│  用户管理    │    │ [搜索] [从HR添加用户] [添加系统账号]    │
│  角色管理    │    │ ┌──┬────┬────┬────┬──────┬────┐     │
│  部门管理    │    │ │  │用户名│姓名 │部门 │角色来源│操作│     │
│  岗位权限    │    │ ├──┼────┼────┼────┼──────┼────┤     │
│  项目岗位权限│    │ │1 │admin│管理员│总部 │admin  │编辑│     │
│  权限包      │    │ │2 │E052│王五 │PM组 │HR入职  │编辑│     │
│  数据字典    │    │ │3 │E053│赵六 │CRA │HR入职  │编辑│     │
│  模块管理    │    │ │4 │svc01│API服务│—  │系统    │编辑│     │
└─────────────┘    │ └──┴────┴────┴────┴──────┴────┘     │
                   │ 角色来源: 🟢HR入职 🔵项目 🟠admin手动  │
                   └──────────────────────────────────────┘
```

**从HR添加用户弹窗（主要入口）：**
```
┌──────────────────────────────────────┐
│ 从HR添加用户                          │
│                                      │
│ [搜索HR人员：姓名/工号/部门/岗位]      │
│ ┌──┬────┬────┬────┬──────┐          │
│ │☐ │姓名 │工号 │部门 │岗位    │          │
│ ├──┼────┼────┼────┼──────┤          │
│ │☑ │赵六 │E053│CRA组│CRA    │          │
│ │☐ │钱七 │E054│CRC组│CRC    │          │
│ │☐ │孙八 │E055│PM组 │PM     │          │
│ └──┴────┴────┴────┴──────┘          │
│                                      │
│ 已选: 赵六(E053/CRA组/CRA)           │
│ 自动生成: 用户名=E053               │
│ 自动角色: CRA (来自岗位映射)          │
│                                      │
│ 追加特殊角色: [选择角色 ▼] [+添加]    │
│  当前角色: 🟢CRA(HR映射)             │
│                                      │
│         [取消]  [确认添加]             │
└──────────────────────────────────────┘
逻辑：调 GET /api/admin/hr/members 搜索HR人员 → 选人后自动映射角色
```

**添加系统账号弹窗（仅用于API服务/机器人等非人员账号）：**
```
┌──────────────────────────────────────┐
│ 添加系统账号                          │
│                                      │
│ 用户名: [____________]               │
│ 用途说明: [____________]             │
│ 角色:   [选择角色 ▼] [+添加]          │
│                                      │
│         [取消]  [确认添加]             │
└──────────────────────────────────────┘
```

### 7.2 角色管理页面

```
┌─────────────────────────────────────────────────────────┐
│ 角色管理                                                 │
│ ┌──────────┐ ┌─────────────────────────────┐            │
│ │ 角色列表   │ │ 权限配置（树形勾选）          │            │
│ │           │ │                             │            │
│ │ ● 超级管理 │ │ ☑ 项目管理                  │            │
│ │ ● 管理员   │ │   ☑ 项目列表               │            │
│ │ ● PM 🟢   │ │   ☑ 创建项目               │            │
│ │ ● CRA 🟢  │ │   ☐ 删除项目               │            │
│ │ ● CRC 🟢 ←│ │ ☑ 审批管理                  │            │
│ │ ● 财务 🟢 │ │   ☑ 审批中心               │            │
│ │ ● 部门负责🟢│ │   ☐ 流程配置               │            │
│ │ ● 数据管理🟠│ │ ☐ 系统管理                  │            │
│ │           │ │                             │            │
│ │ [+新增]   │ │ 数据范围: [本部门+下级 ▼]     │            │
│ │           │ │                             │            │
│ │           │ │ 角色来源: 🟢HR映射 🟠admin手动 │            │
│ └──────────┘ └─────────────────────────────┘            │
│                                                         │
│ 角色来源说明：                                           │
│ 🟢 HR映射 = 由岗位映射自动分配，is_system=0              │
│ 🟠 admin手动 = 管理员手动创建/分配，用于特殊权限           │
│ 🔵 项目角色 = 项目团队分配（不在角色管理页管理）           │
└─────────────────────────────────────────────────────────┘
```

### 7.3 岗位权限管理页面

```
┌──────────────────────────────────────────────────────────────┐
│ 岗位权限管理（入职自动生效）                                   │
│                                                              │
│ ┌─ 基础权限（所有员工共享底座）──────────────────────────────┐ │
│ │ ☑ 首页  ☑ 个人中心  ☑ 修改密码  ☑ 审批中心(发起/查看)     │ │
│ │ ☑ 通知消息  ☐ 任何模块的管理/创建/删除权限                  │ │
│ │ 说明：所有入职员工自动获得，无需配置                         │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
│ [搜索岗位: PM/CRA/CRC/...]                    [+新增岗位配置] │
│ ┌──────┬────────┬───────────────────────────┬────┐          │
│ │ 岗位  │ 自动角色 │ 可访问模块                │操作│          │
│ ├──────┼────────┼───────────────────────────┼────┤          │
│ │ PM   │ pm     │ 项目管理✓ 中心管理✓ 审批✓  │编辑│          │
│ │ CRA  │ cra    │ 项目管理✓ 中心管理✓        │编辑│          │
│ │ CRC  │ crc    │ 项目管理✓ 中心管理✓(有限)  │编辑│          │
│ │ DM   │ dm     │ 数据管理✓ 项目管理✓(只读)  │编辑│          │
│ │ QA   │ qa     │ 质量管理✓ 项目管理✓(只读)  │编辑│          │
│ │ BD   │ bd     │ 商务管理✓ 申办方✓          │编辑│          │
│ │ 财务  │ finance│ 预算✓ 费用✓ 合同✓          │编辑│          │
│ │ 人事  │ hr     │ HR管理✓ 培训✓              │编辑│          │
│ └──────┴────────┴───────────────────────────┴────┘          │
│                                                              │
│ 💡 岗位+是否负责人 → 自动角色 → 自动权限。入职即生效，无需手动│
│    部门负责人由HR组织架构决定，自动获dept_head角色+审批权      │
└──────────────────────────────────────────────────────────────┘
```

**岗位权限配置弹窗：**
```
┌──────────────────────────────────────────────────┐
│ 配置岗位权限                                      │
│                                                  │
│ 岗位: [PM ▼]   负责人额外角色: [dept_head ▼]      │
│ 基础角色: [pm ▼] (可多选)                         │
│                                                  │
│ 可访问模块（勾选=该岗位可看到此菜单）:              │
│ ┌──┬────────────┬──────────────────────┐        │
│ │☑ │ 项目管理     │ ☑列表 ☑创建 ☐删除      │        │
│ │☑ │ 中心管理     │ ☑列表 ☑编辑 ☐删除      │        │
│ │☑ │ 审批管理     │ ☑审批中心 ☑流程配置     │        │
│ │☐ │ 预算管理     │                       │        │
│ │☐ │ 费用管理     │                       │        │
│ │☐ │ 合同管理     │                       │        │
│ │☐ │ HR管理       │                       │        │
│ │☐ │ 系统管理     │                       │        │
│ └──┴────────────┴──────────────────────┘        │
│                                                  │
│ 数据范围: [本部门+下级 ▼]                          │
│                                                  │
│            [取消]  [保存配置]                       │
└──────────────────────────────────────────────────┘
```

**权限生效链路：**
```
HR入职 → position_type=PM, is_leader=0
    ↓
查岗位权限配置 → 角色pm + 数据范围dept_sub + 可访问模块
    ↓
自动写入admin_user_roles(role_source='hr')
    ↓
登录时：基础权限底座 ∪ 岗位权限 → 渲染菜单+控制API
```

### 7.4 项目岗位权限管理页面

```
┌──────────────────────────────────────────────────────────────┐
│ 项目岗位权限（项目内角色→项目模块权限）                         │
│                                                              │
│ 说明：入职岗位是CRA，但项目内担任APM → 在项目内获得PM权限      │
│                                                              │
│ [搜索项目岗位: PM/APM/PI/CRA/...]              [+新增配置]    │
│ ┌──────┬──────────┬─────────────────────────────┬────┐      │
│ │项目岗位│ 允许来源岗 │ 项目内可访问模块            │操作│      │
│ ├──────┼──────────┼─────────────────────────────┼────┤      │
│ │ PM   │ PM       │ 项目全模块+中心+审批         │编辑│      │
│ │ APM  │ CRA/CRC  │ 项目管理✓ 中心管理✓ 审批✓    │编辑│      │
│ │ PI   │ —        │ 项目管理(只读) 中心管理✓      │编辑│      │
│ │ CRA  │ CRA      │ 项目管理(有限) 中心管理✓      │编辑│      │
│ │ CRC  │ CRC      │ 项目管理(有限) 中心管理(有限) │编辑│      │
│ │ DM   │ DM       │ 数据管理✓ 项目(只读)          │编辑│      │
│ └──────┴──────────┴─────────────────────────────┴────┘      │
│                                                              │
│ 💡 项目团队分配角色时自动查此表，项目内权限覆盖组织岗位权限     │
│    离开项目 → 项目权限自动失效，回到组织岗位权限               │
└──────────────────────────────────────────────────────────────┘
```

**项目岗位权限配置弹窗：**
```
┌──────────────────────────────────────────────────┐
│ 配置项目岗位权限                                   │
│                                                  │
│ 项目岗位: [APM ▼]                                │
│ 允许来源岗位: [CRA ▼] [+添加] (限制哪些岗位可担任)│
│ 对应角色: [pm ▼] (项目内生效的角色)                │
│                                                  │
│ 项目内可访问模块：                                 │
│ ☑ 项目管理 (☑列表 ☑编辑 ☐删除)                    │
│ ☑ 中心管理 (☑列表 ☑编辑 ☐删除)                    │
│ ☑ 审批管理 (☑审批中心 ☐流程配置)                   │
│ ☐ 预算管理   ☐ 合同管理   ☐ HR管理               │
│                                                  │
│ 项目数据范围: [本项目+下级 ▼]                       │
│                                                  │
│            [取消]  [保存配置]                       │
└──────────────────────────────────────────────────┘
```

### 7.5 权限包管理页面

```
┌──────────────────────────────────────────────────────────────┐
│ 权限包管理（领域管理员/复合角色快速分配）                       │
│                                                              │
│ 类型筛选: [全部 ▼]  ○单领域包 ○复合包 ○自定义包              │
│                                                              │
│ [搜索权限包]                          [+新建权限包]           │
│ ┌──────────┬─────┬──────────────────────┬──────┬────┐      │
│ │ 权限包    │类型  │ 覆盖模块              │已分配 │操作│      │
│ ├──────────┼─────┼──────────────────────┼──────┼────┤      │
│ │ 财务管理包│单领域│ 预算+费用+合同 全读写  │ 3人  │编辑│      │
│ │ 项目管理包│单领域│ 项目+中心+审批 全读写  │ 5人  │编辑│      │
│ │ 行政管理包│单领域│ 行政+物资+印章 全读写  │ 2人  │编辑│      │
│ │ HR管理包  │单领域│ 人员+培训+考勤 全读写  │ 2人  │编辑│      │
│ │ 副总裁包  │复合  │ 财务+项目+HR+审批      │ 2人  │编辑│      │
│ │ COO包    │复合  │ 全模块(只读)+审批终审   │ 1人  │编辑│      │
│ │ CEO包    │复合  │ 全模块读写+全审批       │ 1人  │编辑│      │
│ │ 审计监察包│自定义│ 全模块只读+操作日志     │ 1人  │编辑│      │
│ └──────────┴─────┴──────────────────────┴──────┴────┘      │
│                                                              │
│ 💡 单领域包 = 某业务大类的"小超管"                            │
│    复合包 = 多领域组合，如"副总裁"=财务+项目+HR               │
│    自定义包 = 完全自由勾选，如"审计"=全平台只读+日志           │
│    支持只读版：如"项目管理包(只读)"                           │
│    一键分配给任何人，不受岗位限制                              │
└──────────────────────────────────────────────────────────────┘
```

**权限包详情/编辑弹窗：**
```
┌──────────────────────────────────────────────────┐
│ 编辑权限包                                       │
│                                                  │
│ 名称: [副总裁包        ]                          │
│ 类型: ●复合包  ○单领域  ○自定义                   │
│                                                  │
│ 覆盖模块（勾选=包含此模块权限）:                    │
│ ┌────────────┬──────────────────────────┐       │
│ │ ☑ 项目管理  │ ☑全部 ☑列表 ☑创建 ☑删除  │       │
│ │ ☑ 中心管理  │ ☑全部 ☑列表 ☑编辑 ☐删除  │       │
│ │ ☑ 审批管理  │ ☑审批中心 ☑流程配置       │       │
│ │ ☑ 预算管理  │ ☑全部 ☑列表 ☑创建 ☑审批  │       │
│ │ ☑ 费用管理  │ ☑全部 ☑列表 ☑创建 ☑审批  │       │
│ │ ☑ 合同管理  │ ☑全部 ☑列表 ☑创建 ☑审批  │       │
│ │ ☑ HR管理    │ ☑只读 ☐创建 ☐编辑        │       │
│ │ ☐ 行政管理  │                          │       │
│ │ ☐ 系统管理  │                          │       │
│ └────────────┴──────────────────────────┘       │
│                                                  │
│ 数据范围: [全平台 ▼]                               │
│                                                  │
│ 快捷操作: [复制为只读版] [另存为新包]               │
│                                                  │
│ 已分配人员：                                      │
│ ┌──┬────┬────┬──────┐                           │
│ │  │姓名 │部门 │岗位    │                           │
│ ├──┼────┼────┼──────┤                           │
│ │1 │刘总 │总办 │副总裁  │                           │
│ │2 │陈总 │总办 │副总裁  │                           │
│ └──┴────┴────┴──────┘                           │
│ [+分配给人员]  [-移除]                             │
│                                                  │
│            [取消]  [保存]                          │
└──────────────────────────────────────────────────┘
```

**权限包生效链路：**
```
admin分配"副总裁包"给刘总
    ↓
写入admin_user_roles(role_source='admin', permission_pack_id=5)
    ↓
刘总登录时：基础权限底座 ∪ 组织岗位权限 ∪ 权限包权限 → 渲染菜单
    ↓
权限包覆盖范围 > 岗位权限（就高不就低）
```

### 7.6 部门管理页面

```
┌──────────────────────────────────────────────────────────┐
│ 部门管理（数据源：HR同步，负责人取HR组织架构）              │
│                                                          │
│ ┌────────────────┐ ┌───────────────────────────────┐    │
│ │ 临床研究部 ▼     │ │ 部门详情                      │    │
│ │  ├── PM组       │ │ 名称: PM组                    │    │
│ │  ├── CRA组  ←── │ │ HR部门: PM组 (已关联 ✓)       │    │
│ │  ├── CRC组      │ │ 负责人: 王五 (来自HR ✓)       │    │
│ │  └── 数据管理部  │ │ 数据范围: [本部门+下级 ▼]     │    │
│ │ 质量管理部      │ │                               │    │
│ │ 财务部          │ │ 成员列表:                     │    │
│ │ 人力资源部      │ │ ┌──┬────┬────┬──────┐       │    │
│ │                │ │ │  │姓名 │角色│来源    │       │    │
│ │ [🔄从HR同步]   │ │ ├──┼────┼────┼──────┤       │    │
│ │                │ │ │1 │李四 │PM │🟢HR   │       │    │
│ │                │ │ │2 │张三 │admin│🟠手动 │       │    │
│ │                │ │ └──┴────┴────┴──────┘       │    │
│ └────────────────┘ │ [编辑权限属性]                  │    │
│                    └───────────────────────────────┘    │
│                                                          │
│ 说明：部门增删改+负责人 → 均在HR组织架构中维护              │
│       此处仅配置权限相关属性（数据范围等）                   │
│       点击 [🔄从HR同步] 可手动触发部门+负责人同步           │
└──────────────────────────────────────────────────────────┘
```

**部门数据流向：**
```
HR module (组织架构维护)          admin module (权限属性配置)
┌──────────────┐                 ┌──────────────────┐
│ department   │──hr_dept_id───→│ admin_departments │
│ (业务部门)    │   同步          │ (权限部门)         │
│ 负责人设置    │──leader同步───→│ +leader_user_id  │ ← 取HR值
│ 增/删/改名    │                 │ +data_scope      │
│ 调整层级      │                 │ 只改权限相关属性   │
└──────────────┘                 └──────────────────┘
```

---

## 八、操作日志规则

### 8.1 自动记录范围

| 模块 | action | 记录内容 |
|------|--------|---------|
| auth | login/logout | 登录登出 |
| users | create/update/status/reset-pwd | 用户变更 |
| roles | create/update/delete/assign-perm | 角色变更 |
| departments | create/update/delete/assign-user | 部门变更 |
| dict | create/update/delete | 字典变更 |
| config | create/update | 配置变更 |
| modules | register/update/status | 模块变更 |

### 8.2 日志中间件

```javascript
async function logOperation(module, action, detail) {
  return async (req, res, next) => {
    // 响应后记录
    res.on('finish', async () => {
      if (res.statusCode < 400) {
        await adminDb.run(`
          INSERT INTO admin_operation_logs 
          (user_id, module, action, target_type, target_id, detail, ip, user_agent)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
          [req.user?.id, module, action, 
           req.params?.id ? 'id' : null,
           req.params?.id || null,
           JSON.stringify(detail || req.body),
           req.ip, req.headers['user-agent']])
      }
    })
    next()
  }
}
```

---

## 九、与业务模块的交互协议

### 9.1 业务模块接入规则

1. **用户信息**：业务模块不建用户表，通过admin API查用户信息
2. **权限校验**：业务模块的API路由挂载admin权限中间件
3. **数据范围**：业务模块查询时调用admin的DataScope服务
4. **部门归属**：业务模块只存dept_id，部门树由admin管理

### 9.2 审批引擎→admin 依赖清单

| 审批人类型 | 调用接口 | 返回 |
|-----------|---------|------|
| dynamic_report | GET /api/admin/users/:id/manager | {manager_id, manager_name} |
| dynamic_dept | GET /api/admin/departments/head?userId=:id | {head_user_id, head_user_name} |
| dynamic_pm | 业务模块自行实现 | — |
| single_role | 查admin_role_users | 角色对应人员列表 |
| applicant | 直接用提交人 | — |

---

## 十、安全设计

| 项目 | 策略 |
|------|------|
| 密码存储 | bcrypt, cost=12 |
| 登录失败 | 5次锁定30分钟 |
| Token | JWT RS256, access 2h + refresh 7d |
| API鉴权 | 中间件统一拦截，校验角色+权限 |
| 数据范围 | 查询层自动追加过滤，不依赖前端传参 |
| 操作日志 | 管理操作全部记录，不可关闭 |
| 超级管理员 | 仅super_admin可管理用户/角色/配置，不可删除自身 |

---

## 十一、与HR模块联动

### 11.1 数据关联

```
member.db (HR)                    admin.db (平台管理)
┌──────────┐                      ┌──────────────┐
│ member   │──member_id──────────→│ admin_users  │
│ (业务人)  │   1:1绑定             │ (系统账号)    │
│ id=5     │                      │ member_id=5  │
└──────────┘                      └──────────────┘
│ department│──hr_dept_id────────→│ admin_departments │
│ (业务部门) │   1:1绑定             │ (权限部门)        │
│ id=2     │                      │ hr_dept_id=2      │
└──────────┘                      └──────────────────┘
```

- **admin_users.member_id** → member.id，员工与账号1:1
- **admin_departments.hr_dept_id** → department.id，权限部门与业务部门1:1
- 两个ID均为可选字段：纯系统账号（如API服务账号）不需要member_id

### 11.2 职责边界

| 场景 | admin管 | HR管 |
|------|---------|------|
| 新员工入职 | — | ✅ 创建member+分配部门 |
| 给员工开系统账号 | ✅ 创建admin_user+分配角色 | — |
| 调整菜单/API权限 | ✅ 改角色权限 | — |
| 调整数据范围 | ✅ 改data_scope | — |
| 员工转岗/调动 | — | ✅ 改member+team_assignment |
| 员工离职 | — | ✅ 走离职流程 |
| 离职后禁用账号 | ✅ status→disabled | — |
| 查审批人直属上级 | ✅ 查部门leader递归 | — |
| 查员工薪资/考勤 | — | ✅ HR专有数据 |

### 11.3 入职联动流程

```
HR入职流程完成
    │
    ▼
POST /api/admin/hr/onboard (HR模块回调，X-Service-Token鉴权)
    │
    ├─ member_id = member.id
    ├─ real_name = member.name
    ├─ phone = member.phone
    ├─ hr_dept_id = department.id → 查admin_departments匹配dept_id
    ├─ position_type = 岗位编码 (CRA/PM/CRC/...)
    ├─ is_leader = 是否部门负责人
    │
    ▼ admin服务自动处理:
    ├─ username = 工号或手机号
    ├─ password = 初始密码(工号后6位)
    ├─ 创建 admin_user + 写入 member_id
    ├─ 查 admin_position_role_mapping(position_type, is_leader) → 自动分配角色(role_source='hr')
    └─ 分配到对应部门
```

**两种入口创建用户账号：**
1. **HR回调自动创建（主流程）**：HR入职→回调HR-1 API→自动创建账号+自动映射角色
2. **admin界面手动创建（补充流程）**：管理员在"从HR添加用户"弹窗选择已有HR人员→调USER-2创建→同样自动映射角色
3. **系统账号（特殊）**：API服务/机器人等非人员账号，通过"添加系统账号"弹窗手动创建，不关联member_id

### 11.4 离职联动流程

```
HR离职流程完成
    │
    ▼
PUT /api/admin/users/:id/status (HR模块回调)
    │
    ├─ status = disabled
    ├─ 保留所有历史数据（日志/审批记录）
    └─ 已禁用账号不可登录，已有审批自动转交部门负责人
```

### 11.5 部门同步

部门组织架构由HR统一维护，admin不建部门，只同步+配置权限属性：

- **HR建部门** → 自动/手动同步到admin_departments（写入hr_dept_id关联）
- **HR改部门** → 调 HR-3 API 同步更新（名称/层级/负责人）
- **HR删部门** → admin_departments.status → disabled（保留历史数据）
- **admin部门管理页**：只配置权限属性（leader_user_id、数据范围），不提供"新增部门"功能
- **手动同步**：部门管理页提供"🔄从HR同步"按钮，触发全量同步

### 11.6 信息查询方向

| 需求 | 查询方向 | 说明 |
|------|---------|------|
| 审批查直属上级 | admin → admin_departments | 递归查leader_user_id |
| 审批查部门负责人 | admin → admin_departments | 同上 |
| 查员工岗位/级别 | admin → member (跨域API) | GET /api/hr/members/:id |
| 查员工薪资 | 不允许 | admin无权查薪资 |
| 查部门人数 | admin → admin_dept_users | 权限维度人数 |
| 查部门业务人数 | HR → member | 业务维度人数 |
