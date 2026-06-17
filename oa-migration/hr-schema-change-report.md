# hr.db 数据库变更报告 v2

**日期**：2026-06-18  
**变更类型**：字段新增 + 数据迁移  
**影响库**：hr.db / employees 表  
**前置条件**：执行前备份 hr.db

---

## 一、变更概要

| 变更项 | 说明 |
|--------|------|
| 新增字段 | 1个（loginname） |
| 默认密码 | xdt888（全员统一初始密码） |
| 删除数据 | 28条假种子记录（id < 100） |
| 导入数据 | 108条真实在职员工（来自OA导出） |
| 暂不加字段 | interior/mobile2/staffnature/positive（数据质量差，后续按需加） |

---

## 二、新增字段明细

### loginname — 登录账号
| 属性 | 值 |
|------|-----|
| 类型 | TEXT |
| 默认值 | ''（空字符串） |
| 是否必填 | 否 |
| 数据来源 | OA oa_staff_staffbasic.loginname |
| 数据覆盖 | 108/108（100%有值） |
| 用途 | 系统登录账号，与企微对接时作为唯一标识 |
| 示例 | hmg / sinocro-liangxiao / xjsw-zqc |

**格式说明**：
- 总部员工：sinocro-姓名拼音（如 sinocro-liangxiao）
- 高管：简短格式（如 hmg）
- 子公司：子公司前缀-拼音（如 xjsw-zqc）
- 迁移后建议统一规范格式

### 默认密码 — xdt888
| 属性 | 值 |
|------|-----|
| 默认值 | xdt888 |
| 适用范围 | 全员统一初始密码 |
| 来源 | OA系统初始密码（oa_org_company.csmima字段） |
| 安全建议 | 首次登录强制修改密码 |

---

## 三、字段映射关系（OA → hr.db）

| OA字段 | hr.db字段 | 转换规则 | 数据质量 |
|--------|-----------|----------|----------|
| staff_id | id | 直接映射 | ✅ 唯一 |
| name | name | 直接映射 | ✅ |
| gender | gender | 男→M / 女→F | ✅ |
| company_id | company_id | 直接映射 | ✅ |
| department_id | department_id | 直接映射 | ✅ 108/108 |
| loginname | loginname | 直接映射（新增） | ✅ 100%有值 |
| — | password | 固定值 xdt888 | ✅ |
| mobile | phone | 直接映射 | ⚠️ 部分空 |
| email | email | 直接映射 | ⚠️ 大部分空 |
| birthday | birth_date | 直接映射 | ⚠️ 部分空 |
| education | education | 直接映射 | ⚠️ 部分空 |
| hire_date | hire_date | 直接映射 | ✅ |
| state | employment_status | 在职→active | ✅ |

---

## 四、数据质量报告

### 4.1 导入统计
- OA在职人员：112人
- 有效记录：108人
- 过滤：4条（非个人账号：出纳/组织部/科学事务部/培训中心）

### 4.2 关键字段空值率

| 字段 | 空值率 | 说明 |
|------|--------|------|
| loginname | 0% | ✅ 全部有值 |
| name | 0% | ✅ |
| gender | 0% | ✅ |
| hire_date | 0% | ✅ |
| department_id | 0% | ✅ |
| phone | ~14% | ⚠️ 需后续补充 |
| email | ~56% | 🔴 需从企微同步 |
| birth_date | ~37% | ⚠️ 中 |
| education | ~46% | ⚠️ 中 |

---

## 五、影响分析

### 5.1 API影响
- 员工相关API响应新增loginname字段
- 登录API可用loginname + password(xdt888)认证
- 无BREAKING CHANGE（新增字段有默认值）

### 5.2 前端影响
- 员工列表/详情页：新增loginname展示
- 登录页：支持loginname登录
- 无UI布局变更

### 5.3 安全影响
- 默认密码xdt888需首次登录强制修改
- 建议加密码过期策略

---

## 六、执行步骤

```bash
# 1. 备份
cp hr.db hr.db.bak.20260618

# 2. 执行
sqlite3 hr.db < hr-migration-v2.sql

# 3. 验证
sqlite3 hr.db "SELECT COUNT(*) FROM employees;"  # 应为108
sqlite3 hr.db "SELECT id, name, loginname, password FROM employees LIMIT 5;"
```

---

## 七、关联文件

- SQL脚本：`hr-migration-v2.sql`（同目录）
- OA原始数据：`oa-staff-full-join.tsv`（112条37字段）
- OA补全数据：`oa-staff-enriched.tsv`（含部门名/岗位名）
