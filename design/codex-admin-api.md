# 平台管理模块 — API路由规范

> 基础路径：`/api/admin`
> 认证方式：JWT Bearer Token（除登录接口外）
> 数据库：admin.db（独立库）
> 共69个API

---

## 通用约定

### 请求/响应格式

```json
// 成功响应
{ "code": 0, "msg": "ok", "data": {...} }

// 列表响应
{ "code": 0, "msg": "ok", "data": { "list": [...], "total": 100, "page": 1, "page_size": 20 } }

// 失败响应
{ "code": 40001, "msg": "用户名已存在" }
```

### 错误码

| 范围 | 说明 |
|------|------|
| 40001-40099 | 参数错误 |
| 40101-40199 | 认证错误 |
| 40301-40399 | 权限错误 |
| 40401-40499 | 资源不存在 |
| 50001-50099 | 服务器内部错误 |

### 分页参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| page | 1 | 页码 |
| page_size | 20 | 每页条数（最大100） |

---

## 一、认证接口（5个）

### AUTH-1 登录

```
POST /api/admin/auth/login
```

**请求：**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**响应：**
```json
{
  "code": 0,
  "data": {
    "access_token": "eyJhbGci...",
    "refresh_token": "eyJhbGci...",
    "expires_in": 7200,
    "user": {
      "id": 1,
      "username": "admin",
      "real_name": "超级管理员",
      "avatar": null
    }
  }
}
```

**逻辑：**
1. 查admin_users WHERE username AND status='active'
2. bcrypt比对密码
3. 检查锁定状态（失败5次锁定30分钟）
4. 生成JWT双token
5. 更新last_login_at
6. 记录操作日志

---

### AUTH-2 登出

```
POST /api/admin/auth/logout
Authorization: Bearer {access_token}
```

**响应：** `{ "code": 0 }`

**逻辑：** 将当前access_token加入黑名单（Redis或内存，TTL=剩余有效期）

---

### AUTH-3 续签Token

```
POST /api/admin/auth/refresh
```

**请求：**
```json
{
  "refresh_token": "eyJhbGci..."
}
```

**响应：**
```json
{
  "code": 0,
  "data": {
    "access_token": "eyJhbGci...",
    "expires_in": 7200
  }
}
```

---

### AUTH-4 获取当前用户信息

```
GET /api/admin/auth/profile
Authorization: Bearer {access_token}
```

**响应：**
```json
{
  "code": 0,
  "data": {
    "user": {
      "id": 1,
      "username": "admin",
      "real_name": "超级管理员",
      "email": "admin@sinocro.cn",
      "phone": null,
      "avatar": null,
      "status": "active"
    },
    "roles": ["super_admin"],
    "permissions": ["project", "project:list", "approval", ...],
    "menus": [
      {
        "code": "project",
        "name": "项目管理",
        "icon": "folder",
        "route": "/project",
        "children": [
          { "code": "project:list", "name": "项目列表", "route": "/project/list" }
        ]
      }
    ],
    "data_scope": {
      "scope_type": "all"
    },
    "department": {
      "id": 1,
      "name": "总部",
      "is_primary": true
    }
  }
}
```

**逻辑：**
1. 查用户基本信息
2. 查用户角色列表
3. 聚合角色→权限（menu类型权限构建菜单树）
4. 查数据范围
5. 查主部门

---

### AUTH-5 修改密码

```
PUT /api/admin/auth/password
Authorization: Bearer {access_token}
```

**请求：**
```json
{
  "old_password": "admin123",
  "new_password": "NewPass123!"
}
```

**校验：**
- 旧密码正确
- 新密码≥8位
- 新旧不同

---

## 二、用户管理（7个）

### USER-1 用户列表

```
GET /api/admin/users?page=1&page_size=20&keyword=&status=active&dept_id=
```

**权限：** system:manage_users

**响应：**
```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "id": 1,
        "username": "admin",
        "real_name": "超级管理员",
        "email": null,
        "phone": null,
        "status": "active",
        "member_id": null,
        "last_login_at": "2026-06-17 10:00:00",
        "roles": [
          { "id": 1, "role_code": "super_admin", "role_name": "超级管理员", "source": "admin" }
        ],
        "department": {
          "id": 1,
          "name": "总部"
        }
      },
      {
        "id": 2,
        "username": "E053",
        "real_name": "赵六",
        "status": "active",
        "member_id": 5,
        "roles": [
          { "id": 4, "role_code": "cra", "role_name": "CRA", "source": "hr" },
          { "id": 8, "role_code": "data_manager", "role_name": "数据管理员", "source": "admin" }
        ],
        "department": {
          "id": 10,
          "name": "CRA组"
        }
      }
    ],
    "total": 50,
    "page": 1,
    "page_size": 20
  }
}
```

---

### USER-2 创建用户（从HR选人）

```
POST /api/admin/users
```

**权限：** system:manage_users

**说明：** 从HR已有人员中选人创建系统账号，自动映射岗位角色。不可从零建人。

**请求：**
```json
{
  "member_id": 5,
  "username": "E053",
  "password": "InitialPass123!",
  "extra_role_ids": [8]
}
```

**逻辑：**
1. 查HR API获取member信息（GET /api/hr/members/:id）
2. 自动带入：real_name, phone, email, dept_id(通过hr_dept_id映射)
3. 根据 position_type + is_leader 查 admin_position_role_mapping 自动分配基础角色(role_source='hr')
4. extra_role_ids 为admin手动追加的特殊角色(role_source='admin')
5. username唯一性校验
6. password≥8位

**响应：**
```json
{
  "code": 0,
  "data": {
    "user_id": 12,
    "username": "E053",
    "real_name": "赵六",
    "assigned_roles": [
      {"role_code": "cra", "role_name": "CRA", "source": "hr"},
      {"role_code": "data_manager", "role_name": "数据管理员", "source": "admin"}
    ]
  }
}
```

### USER-2B 创建系统账号（非人员）

```
POST /api/admin/users/system
```

**权限：** system:manage_users

**说明：** 仅用于创建API服务/机器人等非人员账号，不关联HR member。

**请求：**
```json
{
  "username": "svc_archive",
  "password": "ServicePass123!",
  "real_name": "档案服务",
  "role_ids": [5]
}
```

**逻辑：**
1. member_id = null（不关联HR）
2. role_source = 'admin'
3. 不走岗位映射

---

### USER-3 用户详情

```
GET /api/admin/users/:id
```

**权限：** system:manage_users

**响应：** 用户完整信息 + 角色 + 部门

---

### USER-4 更新用户

```
PUT /api/admin/users/:id
```

**权限：** system:manage_users

**请求：**
```json
{
  "real_name": "张三丰",
  "email": "zhangsanfeng@sinocro.cn",
  "phone": "13800138001"
}
```

---

### USER-5 更新用户状态

```
PUT /api/admin/users/:id/status
```

**权限：** system:manage_users

**请求：**
```json
{
  "status": "disabled"
}
```

**限制：** 不可禁用自己；不可禁用最后一个super_admin

---

### USER-6 重置密码

```
POST /api/admin/users/:id/reset-password
```

**权限：** system:manage_users

**请求：**
```json
{
  "new_password": "NewPass123!"
}
```

---

### USER-7 查询用户直属上级（审批引擎依赖）

```
GET /api/admin/users/:id/manager
```

**权限：** 内部调用（服务间鉴权，不走用户JWT）

**逻辑：**
1. 查用户主部门 → admin_dept_users (is_primary=1)
2. 查该部门 leader_user_id → admin_departments
3. 若无 → 递归向上查parent_id部门的leader
4. 到顶仍无 → 返回 `{ "manager_id": null }`

**响应：**
```json
{
  "code": 0,
  "data": {
    "manager_id": 5,
    "manager_name": "王五",
    "department_id": 2,
    "department_name": "临床研究部"
  }
}
```

---

## 三、角色管理（6个）

### ROLE-1 角色列表

```
GET /api/admin/roles?keyword=
```

**权限：** system:manage_roles

**响应：**
```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "id": 1,
        "role_code": "super_admin",
        "role_name": "超级管理员",
        "description": "全平台权限",
        "is_system": true,
        "status": "active",
        "user_count": 1,
        "data_scope": {
          "scope_type": "all"
        }
      }
    ]
  }
}
```

---

### ROLE-2 创建角色

```
POST /api/admin/roles
```

**权限：** system:manage_roles

**请求：**
```json
{
  "role_code": "data_manager",
  "role_name": "数据管理员",
  "description": "数据管理部成员",
  "permission_ids": [1, 2, 3, 8, 9],
  "data_scope": {
    "scope_type": "dept_sub",
    "scope_value": null
  }
}
```

---

### ROLE-3 角色详情

```
GET /api/admin/roles/:id
```

**权限：** system:manage_roles

**响应：** 角色信息 + 权限ID列表 + 数据范围

---

### ROLE-4 更新角色

```
PUT /api/admin/roles/:id
```

**权限：** system:manage_roles

**请求：**
```json
{
  "role_name": "高级数据管理员",
  "description": "数据管理部负责人",
  "permission_ids": [1, 2, 3, 8, 9, 10],
  "data_scope": {
    "scope_type": "dept_sub"
  }
}
```

**限制：** is_system=1的角色不可修改role_code

---

### ROLE-5 删除角色

```
DELETE /api/admin/roles/:id
```

**权限：** system:manage_roles

**限制：**
- is_system=1不可删除
- 角色下有用户时不可删除（需先解绑用户）

---

### ROLE-6 批量分配用户角色

```
PUT /api/admin/roles/:id/users
```

**权限：** system:manage_roles

**请求：**
```json
{
  "user_ids": [2, 3, 5]
}
```

**逻辑：** 全量替换该角色的用户列表（先删后插）

---

## 四、权限管理（5个）

### PERM-1 权限列表（平铺）

```
GET /api/admin/permissions?type=menu&parent_id=0
```

**权限：** system:manage_roles

**参数：**
- type: menu/api/data（可选，筛选权限类型）
- parent_id: 父权限ID（可选，0=顶级）

---

### PERM-2 权限树

```
GET /api/admin/permissions/tree
```

**权限：** system:manage_roles

**响应：**
```json
{
  "code": 0,
  "data": [
    {
      "id": 1,
      "perm_code": "project",
      "perm_name": "项目管理",
      "perm_type": "menu",
      "icon": "folder",
      "route": "/project",
      "children": [
        {
          "id": 7,
          "perm_code": "project:list",
          "perm_name": "项目列表",
          "perm_type": "menu",
          "children": []
        }
      ]
    }
  ]
}
```

---

### PERM-3 创建权限

```
POST /api/admin/permissions
```

**权限：** system:manage_roles

**请求：**
```json
{
  "perm_code": "timesheet",
  "perm_name": "工时管理",
  "perm_type": "menu",
  "parent_id": 0,
  "icon": "clock",
  "route": "/timesheet",
  "sort_order": 7
}
```

---

### PERM-4 更新权限

```
PUT /api/admin/permissions/:id
```

**权限：** system:manage_roles

---

### PERM-5 删除权限

```
DELETE /api/admin/permissions/:id
```

**权限：** system:manage_roles

**限制：** 有子权限时不可删除；有关联角色时不可删除

---

## 五、部门管理（6个）

### DEPT-1 部门列表（平铺）

```
GET /api/admin/departments?status=active
```

**权限：** system:manage_departments

---

### DEPT-2 部门树

```
GET /api/admin/departments/tree
```

**权限：** 登录即可（审批引擎也调用）

**响应：**
```json
{
  "code": 0,
  "data": [
    {
      "id": 1,
      "dept_code": "HQ",
      "dept_name": "总部",
      "leader_user_id": 1,
      "leader_name": "超级管理员",
      "children": [
        {
          "id": 2,
          "dept_code": "clinical",
          "dept_name": "临床研究部",
          "children": [...]
        }
      ]
    }
  ]
}
```

---

### DEPT-3 创建部门（仅HR回调使用）

```
POST /api/admin/departments
```

**权限：** 内部调用（HR-3同步回调，X-Service-Token鉴权）

**说明：** admin前端不提供"新增部门"功能，部门增删改由HR模块操作，通过HR-3同步API创建到admin。

**请求：**
```json
{
  "dept_code": "qa_group",
  "dept_name": "QA组",
  "parent_id": 3,
  "leader_user_id": 5,
  "sort_order": 1
}
```

---

### DEPT-4 更新部门

```
PUT /api/admin/departments/:id
```

**权限：** system:manage_departments

**说明：** admin只修改权限相关属性（leader_user_id、sort_order），不修改部门名称/层级（由HR同步）

---

### DEPT-5 删除部门

```
DELETE /api/admin/departments/:id
```

**权限：** system:manage_departments

**说明：** 仅标记status=disabled，不物理删除。实际删部门走HR模块。

**限制：**
- 有子部门不可禁用（需先在HR调整层级）
- 有用户不可禁用（需先在HR调离）

---

### DEPT-6 查询部门负责人（审批引擎依赖）

```
GET /api/admin/departments/head?userId=:id
```

**权限：** 内部调用（服务间鉴权）

**逻辑：**
1. 查用户主部门 → admin_dept_users (is_primary=1)
2. 查部门leader_user_id
3. 若无 → 递归向上查parent
4. 到顶仍无 → 返回 null

**响应：**
```json
{
  "code": 0,
  "data": {
    "head_user_id": 5,
    "head_user_name": "王五",
    "department_id": 2,
    "department_name": "临床研究部"
  }
}
```

---

## 六、部门用户关联（3个）

### DEPT-USER-1 添加部门用户

```
POST /api/admin/departments/:id/users
```

**权限：** system:manage_departments

**请求：**
```json
{
  "user_ids": [3, 5],
  "is_primary": false
}
```

---

### DEPT-USER-2 移除部门用户

```
DELETE /api/admin/departments/:id/users/:userId
```

**权限：** system:manage_departments

**限制：** 不可移除用户的主部门（需先切换主部门）

---

### DEPT-USER-3 设为主部门

```
PUT /api/admin/departments/:id/users/:userId/primary
```

**权限：** system:manage_departments

**逻辑：** 将当前主部门置为非主，目标部门置为主

---

## 七、数据字典（5个）

### DICT-1 字典列表

```
GET /api/admin/dict?category=project_type&status=active
```

**权限：** 登录即可

---

### DICT-2 按分类查询

```
GET /api/admin/dict/:category
```

**权限：** 登录即可

**响应：**
```json
{
  "code": 0,
  "data": [
    { "id": 1, "dict_code": "ct", "value": "ct", "label": "CT", "sort_order": 1 }
  ]
}
```

---

### DICT-3 创建字典项

```
POST /api/admin/dict
```

**权限：** system:manage_config

**请求：**
```json
{
  "category": "project_type",
  "dict_code": "iv",
  "value": "iv",
  "label": "IV",
  "sort_order": 4
}
```

---

### DICT-4 更新字典项

```
PUT /api/admin/dict/:id
```

**权限：** system:manage_config

---

### DICT-5 删除字典项

```
DELETE /api/admin/dict/:id
```

**权限：** system:manage_config

---

## 八、系统配置（5个）

### CONFIG-1 配置列表

```
GET /api/admin/config
```

**权限：** system:manage_config

---

### CONFIG-2 配置详情

```
GET /api/admin/config/:key
```

**权限：** 登录即可

---

### CONFIG-3 创建配置

```
POST /api/admin/config
```

**权限：** system:manage_config

**请求：**
```json
{
  "config_key": "max_upload_size",
  "config_value": "50",
  "config_type": "number",
  "description": "最大上传文件大小(MB)"
}
```

---

### CONFIG-4 更新配置

```
PUT /api/admin/config/:key
```

**权限：** system:manage_config

**请求：**
```json
{
  "config_value": "100"
}
```

---

### CONFIG-5 删除配置

```
DELETE /api/admin/config/:key
```

**权限：** system:manage_config

---

## 九、操作日志（2个）

### LOG-1 日志列表

```
GET /api/admin/logs?page=1&page_size=20&user_id=&module=&action=&start_date=&end_date=
```

**权限：** system:logs

---

### LOG-2 日志详情

```
GET /api/admin/logs/:id
```

**权限：** system:logs

---

## 十、模块管理（4个）

### MODULE-1 模块列表

```
GET /api/admin/modules?type=core&status=active
```

**权限：** 登录即可

---

### MODULE-2 注册模块

```
POST /api/admin/modules
```

**权限：** system:manage_config

**请求：**
```json
{
  "module_code": "archive",
  "module_name": "档案管理",
  "module_type": "business",
  "base_url": "/api/archive",
  "icon": "archive",
  "sort_order": 15
}
```

---

### MODULE-3 更新模块

```
PUT /api/admin/modules/:id
```

**权限：** system:manage_config

---

### MODULE-4 切换模块状态

```
PUT /api/admin/modules/:id/status
```

**权限：** system:manage_config

**请求：**
```json
{
  "status": "maintenance"
}
```

---

## 十一、用户偏好（2个）

### PREF-1 获取偏好

```
GET /api/admin/preferences
Authorization: Bearer {access_token}
```

**权限：** 登录即可（只能查自己）

**响应：**
```json
{
  "code": 0,
  "data": {
    "notification_channels": "site,wework",
    "default_landing": "/project",
    "theme": "light"
  }
}
```

---

### PREF-2 更新偏好

```
PUT /api/admin/preferences
Authorization: Bearer {access_token}
```

**权限：** 登录即可

**请求：**
```json
{
  "preferences": {
    "notification_channels": "site,email",
    "default_landing": "/approval",
    "theme": "dark"
  }
}
```

**逻辑：** 全量upsert（INSERT OR REPLACE）

---

## 十二、API汇总

| 分组 | 数量 | API编号 |
|------|------|---------|
| 认证 Auth | 5 | AUTH-1~5 |
| 用户 Users | 8 | USER-1~2B, 3~7 |
| 角色 Roles | 6 | ROLE-1~6 |
| 权限 Permissions | 5 | PERM-1~5 |
| 部门 Departments | 6 | DEPT-1~6 |
| 部门用户 | 3 | DEPT-USER-1~3 |
| 数据字典 Dict | 5 | DICT-1~5 |
| 系统配置 Config | 5 | CONFIG-1~5 |
| 操作日志 Logs | 2 | LOG-1~2 |
| 模块管理 Modules | 4 | MODULE-1~4 |
| 用户偏好 Preferences | 2 | PREF-1~2 |
| HR联动 | 5 | HR-0~4 |
| 岗位权限 PositionPerm | 4 | POS-1~4 |
| 项目岗位权限 ProjRolePerm | 4 | PROJ-1~4 |
| 权限包 PermissionPack | 5 | PACK-1~5 |
| **合计** | **69** | |

---

## 十三、审批引擎依赖接口速查

| API | 方法 | 路径 | 用途 |
|-----|------|------|------|
| USER-7 | GET | /api/admin/users/:id/manager | dynamic_report 查直属上级 |
| DEPT-6 | GET | /api/admin/departments/head?userId=:id | dynamic_dept 查部门负责人 |
| USER-3 | GET | /api/admin/users/:id | 通用查用户信息 |

**服务间鉴权：** 审批引擎调用admin API时，使用服务间Token（非用户JWT），Header: `X-Service-Token: {shared_secret}`

---

## 十四、路由文件结构

```
server/routes/admin/
├── db.js              ← admin.db 连接
├── index.js           ← 路由汇总 + 鉴权中间件
├── auth.js            ← AUTH-1~5
├── users.js           ← USER-1~7
├── roles.js           ← ROLE-1~6
├── permissions.js     ← PERM-1~5
├── departments.js     ← DEPT-1~6 + DEPT-USER-1~3
├── dict.js            ← DICT-1~5
├── config.js          ← CONFIG-1~5
├── logs.js            ← LOG-1~2
├── modules.js         ← MODULE-1~4
├── preferences.js     ← PREF-1~2
└── middleware.js       ← requirePermission / applyDataScope / logOperation
```

---

## 十五、HR联动接口（4个）

> HR模块入职/离职流程完成后，回调admin API同步账号状态。
> 鉴权方式：服务间Token，Header: `X-Service-Token: {shared_secret}`

### HR-0 搜索HR人员（admin界面选人用）

```
GET /api/admin/hr/members?keyword=赵&dept_id=&position_type=
```

**权限：** system:manage_users

**说明：** admin界面"从HR添加用户"弹窗搜索HR人员时调用。跨域调HR API获取。

**响应：**
```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "member_id": 5,
        "name": "赵六",
        "employee_no": "E053",
        "dept_name": "CRA组",
        "position_type": "CRA",
        "is_leader": false,
        "has_account": false
      },
      {
        "member_id": 8,
        "name": "赵云",
        "employee_no": "E058",
        "dept_name": "PM组",
        "position_type": "PM",
        "is_leader": false,
        "has_account": true,
        "admin_user_id": 15
      }
    ],
    "total": 2
  }
}
```

**逻辑：**
1. 跨域调 GET /api/hr/members，传keyword/dept/position筛选
2. 逐个检查 admin_users.member_id 是否已关联账号（has_account）
3. 已关联的标注admin_user_id，避免重复创建

### HR-1 入职创建账号

```
POST /api/admin/hr/onboard
X-Service-Token: {shared_secret}
```

**触发时机：** HR模块入职流程完成后自动调用

**请求：**
```json
{
  "member_id": 5,
  "real_name": "张三",
  "phone": "13800138000",
  "email": "zhangsan@sinocro.cn",
  "hr_dept_id": 2,
  "position_type": "CRA",
  "is_leader": false
}
```

**逻辑：**
1. 检查 member_id 是否已关联账号（防重复创建）
2. 根据 hr_dept_id 查 admin_departments.id（无匹配则放总部）
3. username = 工号或手机号，password = 初始密码
4. 创建 admin_user + 写入 member_id 关联
5. **根据 position_type + is_leader 查 admin_position_role_mapping，自动分配角色**（role_source='hr'）
   - position_type=CRA, is_leader=0 → 分配 cra 角色
   - position_type=CRA, is_leader=1 → 分配 cra + dept_head 角色
6. 分配部门

**响应：**
```json
{
  "code": 0,
  "data": {
    "user_id": 12,
    "username": "13800138000",
    "initial_password": "Zs@138000",
    "assigned_roles": ["cra"]
  }
}
```

---

### HR-2 离职禁用账号

```
PUT /api/admin/hr/offboard
X-Service-Token: {shared_secret}
```

**触发时机：** HR模块离职流程完成后自动调用

**请求：**
```json
{
  "member_id": 5
}
```

**逻辑：**
1. 根据 member_id 查 admin_user
2. status → disabled
3. 已有pending审批自动转交部门负责人
4. 保留所有历史数据（日志/审批记录不删）

**响应：**
```json
{
  "code": 0,
  "data": {
    "user_id": 12,
    "status": "disabled",
    "transferred_approvals": 2
  }
}
```

---

### HR-3 部门同步

```
POST /api/admin/hr/sync-department
X-Service-Token: {shared_secret}
```

**触发时机：** HR模块新增/变更部门时调用

**请求：**
```json
{
  "hr_dept_id": 2,
  "dept_name": "临床研究部",
  "parent_hr_dept_id": 1,
  "leader_member_id": 5
}
```

**逻辑：**
1. 查 hr_dept_id 是否已关联 admin_departments
2. 已关联 → 更新 dept_name / leader
3. 未关联 → 新建 admin_department + 写入 hr_dept_id
4. leader_member_id → 查 admin_users.member_id 获取 leader_user_id

**响应：**
```json
{
  "code": 0,
  "data": {
    "dept_id": 2,
    "action": "updated"
  }
}
```

---

### HR-4 调岗同步角色

```
PUT /api/admin/hr/position-change
X-Service-Token: {shared_secret}
```

**触发时机：** HR模块调岗/晋升/变更部门负责人时调用

**请求：**
```json
{
  "member_id": 5,
  "old_position_type": "CRA",
  "new_position_type": "PM",
  "is_leader": true,
  "hr_dept_id": 8
}
```

**逻辑：**
1. 根据 member_id 查 admin_user
2. 删除旧角色：DELETE admin_user_roles WHERE user_id=? AND role_source='hr'
3. 查 admin_position_role_mapping(position_type='PM', is_leader=1) → ['pm', 'dept_head']
4. 写入新角色：INSERT admin_user_roles(role_source='hr')
5. 若 hr_dept_id 变更 → 同步更新 admin_dept_users

**响应：**
```json
{
  "code": 0,
  "data": {
    "user_id": 12,
    "removed_roles": ["cra"],
    "added_roles": ["pm", "dept_head"]
  }
}
```

---

## 十六、岗位权限管理（4个）

> 管理组织岗位与可访问模块的权限配置，入职自动生效。

### POS-1 查询岗位权限列表

```
GET /api/admin/position-permissions
```

**权限：** system:manage_roles

**响应：**
```json
{
  "code": 0,
  "data": [
    {
      "id": 1,
      "position_type": "PM",
      "is_leader": false,
      "role_code": "pm",
      "role_name": "项目经理",
      "accessible_modules": ["project", "center", "approval"],
      "data_scope": "dept_sub",
      "description": "项目经理"
    },
    {
      "id": 2,
      "position_type": "PM",
      "is_leader": true,
      "role_code": "dept_head",
      "role_name": "部门负责人",
      "accessible_modules": ["project", "center", "approval"],
      "data_scope": "dept_sub"
    }
  ]
}
```

---

### POS-2 创建/更新岗位权限配置

```
POST /api/admin/position-permissions
```

**权限：** system:manage_roles

**请求：**
```json
{
  "position_type": "PM",
  "is_leader": false,
  "role_code": "pm",
  "accessible_modules": ["project", "center", "approval"],
  "data_scope": "dept_sub",
  "description": "项目经理"
}
```

**逻辑：** UPSERT（按 position_type + is_leader 唯一约束），更新后自动刷新该岗位所有在线用户的菜单缓存

---

### POS-3 删除岗位权限配置

```
DELETE /api/admin/position-permissions/:id
```

**权限：** system:manage_roles

**逻辑：** 删除前检查是否有用户正在使用此配置（role_source='hr'），有则拒绝

---

### POS-4 查询基础权限底座

```
GET /api/admin/position-permissions/base
```

**权限：** system:manage_roles

**响应：**
```json
{
  "code": 0,
  "data": {
    "accessible_modules": ["home", "profile", "password", "approval"],
    "description": "所有员工共享的基础权限"
  }
}
```

---

## 十六B、项目岗位权限管理（4个）

> 管理项目内角色权限，解决"入职CRA但项目内担任APM"的权限覆盖问题。

### PROJ-1 查询项目岗位权限列表

```
GET /api/admin/project-role-permissions
```

**权限：** system:manage_roles

**响应：**
```json
{
  "code": 0,
  "data": [
    {
      "id": 1,
      "project_role": "APM",
      "allowed_positions": ["CRA", "CRC"],
      "role_code": "pm",
      "accessible_modules": ["project", "center", "approval"],
      "data_scope": "project_sub",
      "description": "助理PM-CRA/CRC可担任"
    }
  ]
}
```

---

### PROJ-2 创建/更新项目岗位权限

```
POST /api/admin/project-role-permissions
```

**权限：** system:manage_roles

**请求：**
```json
{
  "project_role": "APM",
  "allowed_positions": ["CRA", "CRC"],
  "role_code": "pm",
  "accessible_modules": ["project", "center", "approval"],
  "data_scope": "project_sub",
  "description": "助理PM-CRA/CRC可担任"
}
```

---

### PROJ-3 删除项目岗位权限

```
DELETE /api/admin/project-role-permissions/:id
```

**权限：** system:manage_roles

---

### PROJ-4 验证项目角色分配

```
POST /api/admin/project-role-permissions/validate
```

**权限：** system:manage_roles

**请求：**
```json
{
  "user_position_type": "CRA",
  "project_role": "APM"
}
```

**响应：**
```json
{
  "code": 0,
  "data": {
    "allowed": true,
    "accessible_modules": ["project", "center", "approval"],
    "data_scope": "project_sub"
  }
}
```

**逻辑：** 检查 allowed_positions 是否包含用户的 position_type，返回项目内可获得的权限

---

## 十六C、权限包管理（5个）

> 管理领域管理员/复合角色的权限包，支持单领域包、复合包、自定义包，一键分配给任何人。

### PACK-1 查询权限包列表

```
GET /api/admin/permission-packs?type=domain|composite|custom
```

**权限：** system:manage_roles

**响应：**
```json
{
  "code": 0,
  "data": [
    {
      "id": 5,
      "name": "副总裁包",
      "pack_type": "composite",
      "modules": {"budget": "full", "expense": "full", "contract": "full", "project": "read", "hr": "read", "approval": "full"},
      "data_scope": "all",
      "description": "财务全读写+项目HR只读+审批",
      "assigned_count": 2,
      "assigned_users": [
        {"user_id": 10, "real_name": "刘总", "department": "总办", "position": "副总裁"},
        {"user_id": 11, "real_name": "陈总", "department": "总办", "position": "副总裁"}
      ]
    }
  ]
}
```

---

### PACK-2 创建/更新权限包

```
POST /api/admin/permission-packs
```

**权限：** system:manage_roles

**请求：**
```json
{
  "name": "副总裁包",
  "pack_type": "composite",
  "modules": {
    "budget": "full",
    "expense": "full",
    "contract": "full",
    "project": "read",
    "hr": "read",
    "approval": "full"
  },
  "data_scope": "all",
  "description": "财务全读写+项目HR只读+审批"
}
```

**逻辑：** modules中key为模块编码，value为权限级别：full/read/none。name唯一约束。

---

### PACK-3 删除权限包

```
DELETE /api/admin/permission-packs/:id
```

**权限：** system:manage_roles

**逻辑：** 删除前检查是否有人正在使用（assigned_count > 0），有则需先移除分配

---

### PACK-4 分配权限包给用户

```
POST /api/admin/permission-packs/:id/assign
```

**权限：** system:manage_roles

**请求：**
```json
{
  "user_ids": [10, 11]
}
```

**逻辑：**
1. 写入 admin_permission_pack_users
2. 将权限包中的模块权限写入 admin_user_roles（role_source='admin', permission_pack_id=:id）
3. 自动刷新用户菜单缓存

---

### PACK-5 移除权限包分配

```
POST /api/admin/permission-packs/:id/revoke
```

**权限：** system:manage_roles

**请求：**
```json
{
  "user_ids": [11]
}
```

**逻辑：**
1. 删除 admin_permission_pack_users 记录
2. 删除 admin_user_roles 中 role_source='admin' AND permission_pack_id=:id 的记录
3. 保留该用户其他来源的角色（hr/project）
4. 自动刷新用户菜单缓存
