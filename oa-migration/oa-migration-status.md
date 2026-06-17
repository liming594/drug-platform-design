# OA数据迁移状态报告 v2

**更新时间**：2026-06-18 03:30  
**TSV文件**：full-export=69 + manual=21 = 去重后90个  
**6大域关键表**：全部就绪 ✅  

---

## 迁移SQL脚本

| # | 文件 | 目标库 | 记录数 | 状态 |
|---|------|--------|--------|------|
| 1 | hr-migration-v2.sql | hr.db | 108条员工+1个字段变更 | ✅ 完整 |
| 2 | project-migration.sql | project.db | 753条项目(145→43列) | ✅ 完整v2 |
| 3 | partner-migration.sql | partner.db | 1518中心+1591联系人+166合作方 | ✅ 完整 |
| 4 | contract-migration.sql | contract.db | 98合同+1291产品 | ✅ 完整 |
| 5 | client-migration.sql | partner.db | 1179客户(16771去重) | ✅ 完整 |
| 6 | finance-migration.sql | finance.db | 92766条(5表) | ✅ 完整 |

## 数据映射文档

| 文件 | 说明 |
|------|------|
| oa-data-mapping.md | 全域映射总览(989表→6大域) |
| oa-item-info-mapping.md | oa_item_info字段精简(145→43列) |
| hr-schema-change-report.md | hr.db变更报告 |
| oa-database-tables.md | 989张表按89模块分组清单 |

## 重要发现

1. **oa_item_info实际753行**：之前只导出35行（主项目），新导出含全部子项目（药物×适应症组合）
2. **oa_contract_clientexport是客户数据**：16771行去重后1179个唯一客户，归入partner.db
3. **财务数据9.3万行**：最大表oa_department_planstaff(4.6万)+oa_department_planinfo(2.6万)
4. **6大域全部关键表已到位**：HR(14) + Project(14) + Contract(7) + Partner(6) + Finance(8) + Approval(2) = 51张

## 待完成项

1. 财务域字段映射需等finance.db schema设计完成后再补充INSERT细节
2. 项目成员映射：oa_item_sigs(1114)+oa_item_workmodel(1948)→project_members
3. 里程碑映射：oa_item_milestone(308)+batch(79)+type(120)→project_milestones
4. hr.db字段扩充执行：loginname+默认密码xdt888+108条INSERT（用户自行执行）
5. 7条线独立DB拆分（遗留）
