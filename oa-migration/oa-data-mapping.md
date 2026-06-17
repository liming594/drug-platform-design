# OA→新平台 数据映射文档

**日期**：2026-06-18  
**来源**：老OA数据库 xdtoa (989表/365万行/1.64GB)  
**目标**：新平台独立DB (hr.db/project.db/contract.db/partner.db/finance.db/admin.db等)  
**原则**：每域独立库零耦合，跨域走HTTP API

---

## 一、域分类总览

| 新平台域 | 目标库 | OA源表数 | OA总行数 | 映射率 | 价值评估 |
|----------|--------|----------|----------|--------|----------|
| HR | hr.db | 49 | 17,330 | 高 | ⭐⭐⭐ 核心 |
| 项目管理 | project.db | 72 | 21,286 | 中 | ⭐⭐⭐ 核心 |
| 合同 | contract.db | 9 | 21,227 | 高 | ⭐⭐⭐ 核心 |
| 合作方/中心 | partner.db | 13 | 1,702 | 高 | ⭐⭐⭐ 核心 |
| 财务 | finance.db | 9 | 14,984 | 中 | ⭐⭐ 重要 |
| 办公/用品 | office.db | 20 | 30,147 | 低 | ⭐ 参考用 |
| 会议 | meeting.db | 13 | 2,559 | 低 | ⭐ 参考用 |
| 档案 | archive.db | 19 | 724 | 低 | ⭐ 参考用 |
| 审批 | admin.db | 1 | 168 | 低 | ⭐ 仅flow_annex |
| 计划/OKR | — | 17 | 3,071 | 低 | ❌ 不迁移 |
| 系统/权限 | admin.db | 13 | 4,204 | 中 | ⭐⭐ 权限参考 |
| 消息 | — | 2 | 67 | 无 | ❌ 不迁移 |

---

## 二、HR域映射（hr.db）

### 2.1 核心映射

| 新表 | OA源表 | 行数 | 关键字段映射 | 备注 |
|------|--------|------|------------|------|
| employees | oa_staff_staffbasic + oa_org_staff | 1,050→108在职 | staff_id→id, name, gender, loginname(新增), password(默认xdt888) | ✅ 已出SQL |
| departments | oa_org_department_job | 47 | dept_id→id, name, parent_id, company_id | ✅ 已有TSV |
| companies | oa_org_company | 9 | company_id→id, name | ✅ 已有TSV |
| job_titles | oa_org_department_job(岗位部分) | 200+ | job_id→id, name, dept_id | 需从TSV提取 |
| employee_job_map | oa_org_jobstaffmap | 633 | staff_id, job_id, is_primary | ✅ 已有TSV |

### 2.2 扩展表（待评估）

| 新表 | OA源表 | 行数 | 价值 | 建议 |
|------|--------|------|------|------|
| employee_education | oa_staff_staffeduc | ~100 | 高 | 迁移 |
| employee_contract | oa_staff_staffpact | ~100 | 高 | 迁移 |
| employee_experience | oa_staff_staffexperience | ~50 | 中 | 迁移 |
| employee_insurance | oa_staff_staffinsurance | ~50 | 中 | 暂缓 |
| salary_info | oa_staff_paymentinfo | 9,844 | 高 | 需脱敏后迁移 |
| attendance | oa_staff_attendanceinfo | 39,809 | 中 | 数据量大，按需迁 |
| vacation | oa_staff_hols/holsitem/vacation | ~3,000 | 中 | 迁移 |

---

## 三、项目管理域映射（project.db）

### 3.1 项目核心

| 新表 | OA源表 | 行数 | 映射说明 |
|------|--------|------|----------|
| projects | oa_item_info | 35 | 145列→精简为~30列，含项目名/类型/阶段/日期/负责人等 |
| project_types | oa_item_types | 56 | 项目分类树 |
| project_members | oa_item_sigs + oa_item_workmodel | 631 | 项目-人员-角色映射 |
| project_milestones | oa_item_milestone/milestonebatch/milestonetype | 507 | 里程碑+批次+类型 |
| project_progress | oa_item_speed/speedfilework/taskprogerss | 156 | 进度跟踪 |

### 3.2 项目成本

| 新表 | OA源表 | 行数 | 映射说明 |
|------|--------|------|----------|
| project_costs | oa_item_staffcostinfo + oa_item_mcainfosjk | 9,695 | 成本明细（最大数据量） |
| project_cost_categories | oa_item_ysfea + oa_item_ysbatch | 389 | 成本分类/批次 |
| project_daily_account | oa_item_dayaccount/dayaccountbasic/monthinfo | 93 | 日结/月结 |

### 3.3 项目合同/收款

| 新表 | OA源表 | 行数 | 映射说明 |
|------|--------|------|----------|
| project_contracts | oa_item_pactnode | 474 | 项目关联合同节点 |
| project_payments | oa_item_pactpaynote | 421 | 项目收款记录 |
| project_advance | oa_item_advancetime* | 247 | 预付款 |

### 3.4 oa_item_info 关键字段映射（145列→30列）

**保留字段**：
- id → project_id
- name → project_name  
- company_id → company_id
- type → project_type
- feature_id → current_phase (项目阶段)
- staff_id → pm_id (项目经理)
- j_name → contract_name (合同名称)
- bidding → bidding_method (招标方式)
- startdate/enddate → start_date/end_date
- zigeyushen_passdate → qualification_date
- zhongbiaodate → winning_bid_date
- exam_date → examination_date
- drug_name → drug_name (药名)
- indication → indication (适应症)
- phase → clinical_phase (临床分期)
- pre_code → project_code (项目编号)
- client_id → client_id (申办方)
- total_cost → budget_amount (总预算)
- status → status

**废弃字段**（~115列）：各种内部流程状态/审批标记/UI控制位/冗余时间戳

---

## 四、合同域映射（contract.db）

| 新表 | OA源表 | 行数 | 映射说明 |
|------|--------|------|----------|
| contracts | oa_contract_clientexport | 17,105 | 合同主表，含客户合同明细 |
| contract_products | oa_contract_product | 1,247 | 合同关联合同产品 |
| contract_contacts | oa_contract_jflxr | 1,780 | 合同甲方联系人 |
| contract_categories | oa_contract_category + oa_contract_type | ~10 | 合同分类 |
| invoices | oa_pact_invoice | 1,077 | 发票记录 |
| pact_info | oa_pact_info | ~30 | 协议信息 |

⚠️ oa_contract_clientexport(17,105行) 是最大的合同表，含大量导出历史数据，需去重后才是有效合同

---

## 五、合作方/中心域映射（partner.db）

| 新表 | OA源表 | 行数 | 映射说明 |
|------|--------|------|----------|
| partners | oa_signatory_info + oa_signatory_otherinfo | 1,362 | 中心1,196 + 其他合作方166 |
| partner_contacts | oa_signatory_yflxr + oa_signatory_otherlxr | 1,622 | 中心联系人1,264 + 其他31 |
| partner_categories | oa_signatory_category + oa_signatory_othercat | 13 | 中心2分类 + 其他11分类 |
| center_details | oa_signatory_sercon + oa_signatory_serconjob | 2,726 | 中心服务+岗位 |
| center_types | oa_center_infomanger + oa_center_training | 14 | 中心类型+培训 |

✅ 此域数据已在之前导出整理过，质量较好

---

## 六、财务域映射（finance.db）

| 新表 | OA源表 | 行数 | 映射说明 |
|------|--------|------|----------|
| budgets | oa_department_plan/planinfo/planstaff | 75,573 | 部门预算（最大数据源） |
| budget_batches | oa_department_planbatch | 2,590 | 预算批次 |
| reimbursements | oa_out_apply + apply* | 24,719 | 差旅报销 |
| payments | oa_sc_subpay + oa_sc_subset | 2,037 | 付款记录 |
| cost_categories | oa_cost_category + oa_cost_category1 | 887 | 成本分类 |

⚠️ oa_department_planstaff(35,959行) 数据量最大但多为历史预算，需按年度筛选

---

## 七、不迁移的数据

| OA模块 | 表数 | 行数 | 原因 |
|--------|------|------|------|
| flow_models备份(3表) | 3 | 1,022,769 | 垃圾数据，纯备份 |
| 消息/通知(3表) | 3 | 849,957 | 系统日志，无业务价值 |
| 审计日志 | 1 | 235,153 | 旧审计，新平台有统一审计表 |
| OKR/计划 | 17 | 3,071 | 使用率极低，功能不再实现 |
| 备忘录 | 3 | 16,496 | 个人便签，不迁移 |
| 空表 | ~650 | 0 | 从未使用或已废弃 |

**总计不迁移**：~674张表/213万行，占总数据量58%

---

## 八、迁移优先级

| 优先级 | 域 | 原因 |
|--------|-----|------|
| P0 | HR (hr.db) | 人员数据是一切基础，已出SQL |
| P0 | 合作方/中心 (partner.db) | CRO核心数据，已有整理 |
| P1 | 项目管理 (project.db) | 核心业务，需字段精简 |
| P1 | 合同 (contract.db) | 需去重 |
| P2 | 财务 (finance.db) | 需按年度筛选 |
| P3 | 审批 (admin.db) | 流程定义参考 |
| — | 办公/会议/档案 | 仅作参考，暂不迁移 |

---

## 九、数据清洗规则

1. **去重**：oa_contract_clientexport等导出表需按业务主键去重
2. **状态过滤**：只迁移在职员工、进行中/已完成项目、有效合同
3. **字段精简**：oa_item_info 145列→30列，删除冗余流程控制位
4. **编码统一**：gender 男→M/女→F，state 在职→active
5. **ID保持**：OA的staff_id/item_id等主键在新库保持不变，便于追溯
6. **空值处理**：OA中大量空字符串''→新库统一为NULL
7. **时间格式**：OA的日期格式不统一，统一转为ISO 8601
