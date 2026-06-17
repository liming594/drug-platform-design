# oa_item_info 字段精简映射

**源表**：oa_item_info (35行 × 145列)  
**目标**：project.db → projects (35行 × 43列)  
**精简率**：145→43，废弃102列(70%)

---

## 映射明细

| # | OA原字段 | 新字段 | 类型 | 填充率 | 说明 |
|---|---------|--------|------|--------|------|
| 1 | id | project_id | INTEGER PRIMARY KEY | 35/35 | 项目ID |
| 2 | company_id | company_id | INTEGER | 35/35 | 所属公司ID |
| 3 | number | project_code | TEXT | 31/35 | 项目编号(自动生成) |
| 4 | precoding_number | pre_code | TEXT | 24/35 | 项目编号(预编) |
| 5 | name | project_name | TEXT NOT NULL | 35/35 | 项目名称 |
| 6 | j_name | client_name | TEXT | 35/35 | 申办方/客户名称 |
| 7 | j_name_id | client_id | INTEGER | 35/35 | 申办方ID |
| 8 | cpname | product_name | TEXT | 18/35 | 产品/药物名称 |
| 9 | sbf_id | sponsor_id | INTEGER | 35/35 | 申办方ID(冗余) |
| 10 | feature_id | current_phase_id | INTEGER | 35/35 | 当前阶段ID |
| 11 | typeid | project_type_id | INTEGER | 5/35 | 项目类型ID |
| 12 | test_type | test_type | TEXT | 32/35 | 试验类型 |
| 13 | test_stage | test_stage | TEXT | 31/35 | 试验阶段 |
| 14 | xmstate | project_state_id | INTEGER | 35/35 | 项目状态ID |
| 15 | item_state | item_state_id | INTEGER | 26/35 | 项目流程状态ID |
| 16 | year | project_year | INTEGER | 35/35 | 项目年度 |
| 17 | zccatid | category_id | INTEGER | 23/35 | 项目分类ID |
| 18 | create_staff | created_by | INTEGER | 35/35 | 创建人ID |
| 19 | manager | manager_id | INTEGER | 28/35 | 项目总监ID |
| 20 | manager_name | manager_name | TEXT | 28/35 | 项目总监姓名 |
| 21 | xmfzr | pm_ids | TEXT | 35/35 | 项目经理ID列表(逗号分隔) |
| 22 | created | created_at | DATETIME | 35/35 | 创建时间 |
| 23 | startdate | start_date | DATE | 5/35 | 项目开始日期 |
| 24 | enddate | end_date | DATE | 0/35 | 项目结束日期 |
| 25 | state | status | INTEGER DEFAULT 1 | 35/35 | 数据状态(0正常) |
| 26 | spstate | approval_status | TEXT | 35/35 | 审批状态(pass/pending) |
| 27 | fenpeistate | assign_status | INTEGER | 35/35 | 分配状态 |
| 28 | isdelete | is_deleted | INTEGER DEFAULT 0 | 35/35 | 是否删除 |
| 29 | yjyy | budget_amount | DECIMAL DEFAULT 0 | 35/35 | 预算金额 |
| 30 | fact_companyid | actual_company_id | INTEGER | 35/35 | 实际执行公司ID |
| 31 | formal_num | formal_number | INTEGER | 23/35 | 正式编号序号 |
| 32 | formal_year | formal_year | INTEGER | 23/35 | 正式编号年份 |
| 33 | lcbtype_id | milestone_type_id | INTEGER | 35/35 | 里程碑类型ID |
| 34 | zigeyushen_ispass | qual_passed | INTEGER DEFAULT 0 | 35/35 | 资格预审是否通过 |
| 35 | iszhongbiao | is_winning_bid | INTEGER DEFAULT 0 | 35/35 | 是否中标 |
| 36 | exam_isbaoming | exam_registered | INTEGER DEFAULT 0 | 35/35 | 是否报名 |
| 37 | exam_job | exam_status | INTEGER DEFAULT 0 | 35/35 | 考试状态 |
| 38 | remark | remark | TEXT | 9/35 | 项目备注 |
| 39 | gcgk | overview | TEXT | 8/35 | 项目概述 |
| 40 | jflxr_id | contact_ids | TEXT | 4/35 | 甲方联系人ID列表 |
| 41 | num | serial_number | INTEGER | 26/35 | 序号 |
| 42 | week_time | week_hours | DECIMAL DEFAULT 0 | 17/35 | 周工时 |
| 43 | competitor | competitor_ids | TEXT | 1/35 | 竞争对手ID列表 |

---

## 废弃列分类 (102列)

### 1. 建筑工程字段 (50+列)
address, area, sum, q_meter, q_cubemeter, q_scaledetail, kind, frame, height, function, advice, execute, layout, use, build, invest, bidding, start, project, source, design, audit, supervision, finish, check, pro, building, floors, underground, structure, fire, green, park, other, basement, type2, type3...

**原因**：这些是ZF框架自带的"项目管理"模板字段，适用于建筑工程，CRO临床试验完全不用，全部为空值。

### 2. 流程/审批控制位 (20+列)
各字段含 flow_batch_id, lock_state, is_locked 等内部流程引擎字段

**原因**：新平台有独立的审批中心，不需要OA的流程控制位。

### 3. 冗余关联 (10+列)
多个字段是其他表的冗余快照或显示用中间字段

**原因**：新平台通过API跨域查询，不需要冗余存储。

### 4. 其他空列 (20+列)
填充率=0或纯默认值的字段

**原因**：从未使用。

---

## 数据清洗规则

1. **state=0→status=1**：OA中0=正常，新平台1=正常
2. **isdelete=1的行跳过**：已删除项目不迁移
3. **pm_ids去前后逗号**：OA格式",65,"→新平台"65"
4. **日期格式统一**：OA无日期的置NULL，不填0
5. **budget_amount**：OA全为0.00，保留字段但数据需后续从合同域补充
6. **client_id/client_name**：需与partner.db的申办方数据交叉验证
