-- ============================================================
-- project.db: 项目中心关联 + 周报迁移 v3
-- 生成时间: 2026-06-19
-- 目标表: cr_centers(17列), project_weekly_progress(14列)
-- 源: oa_item_sigs(1113) + oa_item_milestone(308)
-- ============================================================

BEGIN TRANSACTION;

-- ===== cr_centers (17列) ===== (1058行)
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1, '4', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', '01', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-02-22', NULL, NULL, '2017-02-22', '2017-02-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (2, '4', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-02-28', NULL, NULL, '2017-02-28', '2017-02-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (3, '4', '首都医科大学附属北京朝阳医院', NULL, '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-02-28', NULL, NULL, '2017-02-28', '2017-02-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (4, '5', '首都医科大学附属北京朝阳医院', '01', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (5, '5', '宁夏医科大学总医院', '02', '宁夏医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (6, '5', '华中科技大学同济医学院附属同济医院', '03', '华中科技大学同济医学院附属同济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (7, '5', '上海市同济医院（同济大学附属同济医院）', '04', '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (8, '5', '天津市人民医院', '05', '天津市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (9, '5', '首都医科大学附属北京佑安医院', '07', '首都医科大学附属北京佑安医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (10, '5', '中南大学湘雅三医院', '08', '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (11, '5', '广东医科大学附属医院', '09', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (12, '8', '中南大学湘雅三医院', '01', '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (13, '8', '中南大学湘雅二医院', '02', '中南大学湘雅二医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (14, '8', '华中科技大学同济医学院附属同济医院', '03', '华中科技大学同济医学院附属同济医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (15, '8', '常德市第一人民医院', '04', '常德市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (16, '8', '浙江大学医学院附属第二医院', '05', '浙江大学医学院附属第二医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (17, '8', '广东医科大学附属医院', '03', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (18, '8', '中山大学附属第三医院', '05', '中山大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (19, '8', '首都医科大学附属北京佑安医院', '08', '首都医科大学附属北京佑安医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (20, '8', '河北医科大学第三医院', '09', '河北医科大学第三医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (22, '8', '吉林大学中日联谊医院', '11', '吉林大学中日联谊医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (23, '8', '长沙市第三医院', '12', '长沙市第三医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (24, '6', '内蒙古科技大学包头医学院第一附属医院', '02', '内蒙古科技大学包头医学院第一附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (25, '6', '天津医科大学总医院', '02', '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (26, '6', '天津市第一中心医院', '04', '天津市第一中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (27, '6', '大连医科大学附属第二医院', '06', '大连医科大学附属第二医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (28, '6', '首都医科大学附属北京佑安医院', '01', '首都医科大学附属北京佑安医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (29, '7', '北京医院', '01', '北京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (30, '7', '西安交通大学第一附属医院', '02', '西安交通大学第一附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (31, '7', '河北医科大学第二附属医院', '03', '河北医科大学第二附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (32, '7', '徐州医学院附属医院', '04', '徐州医学院附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (33, '7', '内蒙古科技大学包头医学院第一附属医院', '02', '内蒙古科技大学包头医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (34, '7', '中国医科大学附属第一医院', '06', '中国医科大学附属第一医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (35, '7', '南京医科大学第一附属医院 （原江苏省人民医院）', '07', '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (36, '7', '首都医科大学附属北京安贞医院', '08', '首都医科大学附属北京安贞医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (37, '7', '首都医科大学附属北京朝阳医院', '09', '首都医科大学附属北京朝阳医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (38, '7', '四川大学华西医院', '10', '四川大学华西医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (39, '7', '南京市第二医院', '03', '南京市第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (40, '9', '中南大学湘雅二医院', '01', '中南大学湘雅二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (42, '9', '黑龙江中医药大学附属第二医院', '03', '黑龙江中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (43, '9', '湖南中医药大学第一附属医院', '04', '湖南中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (44, '9', '湖南中医药大学第二附属医院', '05', '湖南中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (45, '9', '湖北省中医院', '06', '湖北省中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (46, '9', '天津中医药大学第一附属医院', '07', '天津中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-13', NULL, NULL, '2017-03-13', '2017-03-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (47, '10', '北京中医药大学东直门医院', '01', '北京中医药大学东直门医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (48, '10', '长春中医药大学附属医院', '02', '长春中医药大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (49, '10', '黑龙江中医药大学附属第一医院', '03', '黑龙江中医药大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (50, '10', '黑龙江中医药大学附属第二医院', '04', '黑龙江中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (51, '10', '湖南中医药大学第一附属医院', '05', '湖南中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (52, '10', '湖南中医药大学第二附属医院', '06', '湖南中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (53, '10', '吉林省中西医结合医院', '07', '吉林省中西医结合医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (54, '10', '郑州人民医院', '08', '郑州人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (55, '10', '辽宁中医药大学附属第二医院', '09', '辽宁中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (56, '10', '内蒙古民族大学附属医院', '10', '内蒙古民族大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (57, '10', '内蒙古自治区中蒙医医院', '11', '内蒙古自治区中蒙医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (58, '10', '上海中医药大学附属龙华医院', '12', '上海中医药大学附属龙华医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (59, '10', '天津中医药大学第一附属医院', '13', '天津中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (60, '10', '天津中医药大学第二附属医院', '14', '天津中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-03-21', NULL, NULL, '2017-03-21', '2017-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (62, '19', '首都医科大学附属北京朝阳医院', '01', '首都医科大学附属北京朝阳医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-05-15', NULL, NULL, '2017-05-15', '2017-05-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (63, '14', '常州市第二人民医院', '23', '常州市第二人民医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-05-21', NULL, NULL, '2017-05-21', '2017-05-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (64, '14', '上海市同济医院（同济大学附属同济医院）', '01', '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-05-23', NULL, NULL, '2017-05-23', '2017-05-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (65, '17', '北京大学第三医院', '02', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-05-23', NULL, NULL, '2017-05-23', '2017-05-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (66, '14', '河南科技大学第一附属医院', NULL, '河南科技大学第一附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-05-24', NULL, NULL, '2017-05-24', '2017-05-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (67, '12', '北京中医药大学东直门医院', '01', '北京中医药大学东直门医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-05-31', NULL, NULL, '2017-05-31', '2017-05-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (68, '12', '黑龙江中医药大学附属第一医院', '03', '黑龙江中医药大学附属第一医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-09-05', NULL, NULL, '2017-09-05', '2017-09-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (69, '14', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-10-16', NULL, NULL, '2017-10-16', '2017-10-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (70, '20', '首都医科大学附属北京朝阳医院', '01', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (71, '20', '广东医科大学附属医院', '03', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (72, '20', '上海市同济医院（同济大学附属同济医院）', '04', '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (73, '20', '中南大学湘雅三医院', '05', '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (74, '20', '中山大学附属第三医院', '06', '中山大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (75, '20', '重庆医科大学附属第一医院', '07', '重庆医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (76, '20', '西安交通大学第二附属医院（西北医院）', '09', '西安交通大学第二附属医院（西北医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (77, '20', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', '10', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (78, '20', '中南大学湘雅二医院', '11', '中南大学湘雅二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (79, '20', '常德市第一人民医院', '12', '常德市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-11-02', NULL, NULL, '2017-11-02', '2017-11-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (80, '12', '蚌埠医学院第一附属医院', '02', '蚌埠医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (82, '12', '黑龙江中医药大学附属第二医院', '04', '黑龙江中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (83, '12', '吉林省中医药科学院第一临床医院', '05', '吉林省中医药科学院第一临床医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (84, '12', '天津中医药大学第二附属医院', '06', '天津中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (85, '12', '东南大学附属中大医院', '07', '东南大学附属中大医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (86, '12', '温州市中医院', '08', '温州市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (87, '12', '温州市中医院', '09', '温州市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (88, '12', '保定市第一中医院', '10', '保定市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (89, '4', '宁夏医科大学总医院', NULL, '宁夏医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (90, '4', '华中科技大学同济医学院附属同济医院', NULL, '华中科技大学同济医学院附属同济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (91, '4', '上海市同济医院（同济大学附属同济医院）', NULL, '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-26', NULL, NULL, '2017-12-26', '2017-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (92, '26', '北京回龙观医院', '01', '北京回龙观医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (93, '26', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (94, '26', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (95, '27', '北京回龙观医院', '01', '北京回龙观医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (96, '27', '上海市同济医院（同济大学附属同济医院）', NULL, '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (97, '28', '北京回龙观医院', '01', '北京回龙观医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (98, '28', '上海市同济医院（同济大学附属同济医院）', NULL, '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (99, '25', '上海市公共卫生临床中心', '01', '上海市公共卫生临床中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (100, '25', '上海市同济医院（同济大学附属同济医院）', NULL, '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (102, '29', '上海市同济医院（同济大学附属同济医院）', NULL, '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (103, '31', '深圳市第二人民医院', '01', '深圳市第二人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-27', NULL, NULL, '2017-12-27', '2017-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (104, '17', '北京大学第一医院', '03', '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (105, '17', '首都医科大学附属宣武医院', '04', '首都医科大学附属宣武医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (106, '17', '上海市第一人民医院 （上海交通大学附属第一人民医院）', '05', '上海市第一人民医院 （上海交通大学附属第一人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (107, '17', '上海闵行区中心医院', '06', '上海闵行区中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (108, '17', '中山大学附属第二医院', '07', '中山大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (109, '17', '广东医科大学附属医院', '10', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (110, '17', '广州市第一人民医院', '11', '广州市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (111, '17', '暨南大学附属第一医院(广州华侨医院)', '12', '暨南大学附属第一医院(广州华侨医院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (112, '17', '南方医院（南方医科大学第一临床医学院）', '13', '南方医院（南方医科大学第一临床医学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (113, '17', '吉林大学第一医院', '15', '吉林大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (114, '17', '中国医科大学附属第一医院', '16', '中国医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (115, '17', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', '17', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (116, '17', '浙江大学医学院附属第二医院', '19', '浙江大学医学院附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (117, '17', '温州医科大学附属第一医院', '20', '温州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (118, '17', '苏州大学附属第一医院', '27', '苏州大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (119, '17', '苏北人民医院', '28', '苏北人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (120, '17', '中国人民解放军东部战区总医院（原南京军区南京总医院）', '29', '中国人民解放军东部战区总医院（原南京军区南京总医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (122, '17', '内蒙古科技大学包头医学院第一附属医院', '32', '内蒙古科技大学包头医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (123, '17', '华中科技大学同济医学院附属同济医院', '36', '华中科技大学同济医学院附属同济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (124, '17', '长沙市第一医院', '40', '长沙市第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (125, '17', '锦州市中心医院', '41', '锦州市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (126, '17', '大庆油田总医院', '42', '大庆油田总医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (127, '6', '上海市公共卫生临床中心', '05', '上海市公共卫生临床中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (128, '6', '广州市第八人民医院', '06', '广州市第八人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (129, '6', '郑州市第六人民医院（河南省传染病医院）', '07', '郑州市第六人民医院（河南省传染病医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (130, '6', '温州医科大学附属第一医院', '08', '温州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (131, '6', '新乡医学院第一附属医院', '09', '新乡医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (132, '7', '青海大学附属医院', '05', '青海大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (133, '7', '丽水市中心医院', '06', '丽水市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (134, '7', '蚌埠医学院第一附属医院', '07', '蚌埠医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (135, '7', '新疆维吾尔自治区人民医院', '08', '新疆维吾尔自治区人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (136, '7', '湖州市第三人民医院', '09', '湖州市第三人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (137, '7', '北京大学首钢医院', '10', '北京大学首钢医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (138, '7', '延边大学附属医院', '11', '延边大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (139, '7', '郑州人民医院', '12', '郑州人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2017-12-28', NULL, NULL, '2017-12-28', '2017-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (140, '10', '湖北省中医院', '15', '湖北省中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (142, '11', '中国医学科学院阜外医院', '02', '中国医学科学院阜外医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (143, '11', '广东省人民医院（广东省心血管病研究所）', '03', '广东省人民医院（广东省心血管病研究所）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (144, '11', '中山大学附属第一医院', '04', '中山大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (145, '11', '上海交通大学医学院附属瑞金医院', '05', '上海交通大学医学院附属瑞金医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (146, '11', '上海长征医院（第二军医大学长征医院）', '06', '上海长征医院（第二军医大学长征医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (147, '11', '武汉亚洲心脏病医院', '07', '武汉亚洲心脏病医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (148, '11', '武汉大学人民医院（湖北省人民医院）', '08', '武汉大学人民医院（湖北省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (149, '11', '南京医科大学第一附属医院 （原江苏省人民医院）', '09', '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (150, '11', '中南大学湘雅医院', '10', '中南大学湘雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (151, '11', '中南大学湘雅二医院', '11', '中南大学湘雅二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (152, '11', '华中科技大学同济医学院附属同济医院', '13', '华中科技大学同济医学院附属同济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (153, '11', '首都医科大学附属北京安贞医院', '14', '首都医科大学附属北京安贞医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (154, '11', '中日友好医院', '15', '中日友好医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-04', NULL, NULL, '2018-01-04', '2018-01-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (155, '13', '广东省人民医院（广东省心血管病研究所）', '01', '广东省人民医院（广东省心血管病研究所）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (156, '13', '中国医学科学院北京协和医院', '02', '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (157, '13', '哈尔滨医科大学附属肿瘤医院', '03', '哈尔滨医科大学附属肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (158, '13', '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', '04', '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (159, '13', '华中科技大学同济医学院附属同济医院', '07', '华中科技大学同济医学院附属同济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (160, '13', '四川大学附属华西医院', '09', '四川大学附属华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (162, '13', '浙江大学医学院附属第二医院', '11', '浙江大学医学院附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (163, '13', '中国人民解放军东部战区总医院（原南京军区南京总医院）', '12', '中国人民解放军东部战区总医院（原南京军区南京总医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (164, '13', '苏北人民医院', '13', '苏北人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (165, '13', '广西壮族自治区人民医院', '14', '广西壮族自治区人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (166, '13', '中山大学附属第一医院', '15', '中山大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (167, '13', '广州医科大学附属肿瘤医院（广州市肿瘤医院）', '16', '广州医科大学附属肿瘤医院（广州市肿瘤医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (168, '13', '广州市番禺区中心医院（广州番禺区人民医院）', '17', '广州市番禺区中心医院（广州番禺区人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (169, '13', '佛山市第一人民医院', '18', '佛山市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (170, '13', '深圳市人民医院', '19', '深圳市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (171, '13', '东莞市人民医院', '20', '东莞市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (172, '6', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-05', NULL, NULL, '2018-01-05', '2018-01-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (173, '7', '天津市人民医院', NULL, '天津市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-08', NULL, NULL, '2018-01-08', '2018-01-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (174, '35', '长沙市第三医院', '01', '长沙市第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-10', NULL, NULL, '2018-01-10', '2018-01-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (175, '14', '北京大学人民医院', '01', '北京大学人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (176, '14', '北京大学第三医院', '02', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (177, '14', '首都医科大学附属北京朝阳医院', '03', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (178, '14', '上海交通大学医学院附属瑞金医院', '04', '上海交通大学医学院附属瑞金医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (179, '14', '天津医科大学肿瘤医院（天津市肿瘤医院）', '05', '天津医科大学肿瘤医院（天津市肿瘤医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (180, '14', '浙江大学医学院附属第一医院', '06', '浙江大学医学院附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (182, '14', '温州医科大学附属第一医院', '08', '温州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (183, '14', '吉林大学第一医院', '09', '吉林大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (184, '14', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', '10', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (185, '14', '东南大学附属中大医院', '11', '东南大学附属中大医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (186, '14', '中南大学湘雅医院', '12', '中南大学湘雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (187, '14', '南方医院（南方医科大学第一临床医学院）', '14', '南方医院（南方医科大学第一临床医学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (188, '14', '中国人民解放军总医院（第一医学中心/301医院）', '15', '中国人民解放军总医院（第一医学中心/301医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (189, '14', '苏州大学附属第一医院', '16', '苏州大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (190, '14', '海军军医大学第一附属医院（上海长海医院）', '18', '海军军医大学第一附属医院（上海长海医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (191, '14', '上海长征医院（第二军医大学长征医院）', '22', '上海长征医院（第二军医大学长征医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (192, '14', '重庆医科大学附属第一医院', '19', '重庆医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (193, '14', '北京医院', '17', '北京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (194, '14', '西安交通大学第一附属医院', '21', '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (195, '14', '常州市第二人民医院', '23', '常州市第二人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (196, '14', '贵州医科大学附属医院（贵阳医学院附属医院）', '20', '贵州医科大学附属医院（贵阳医学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (197, '14', '中南大学湘雅三医院', '13', '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (198, '14', '丽水市人民医院', '24', '丽水市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (199, '14', '邯郸市中心医院', '26', '邯郸市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (200, '15', '上海市第一人民医院 （上海交通大学附属第一人民医院）', '01', '上海市第一人民医院 （上海交通大学附属第一人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (202, '15', '复旦大学附属华东医院', '03', '复旦大学附属华东医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (203, '15', '首都医科大学附属北京朝阳医院', '04', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (204, '15', '河北医科大学第二医院', '05', '河北医科大学第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (205, '15', '南京医科大学第一附属医院 （原江苏省人民医院）', '06', '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (206, '15', '大连医科大学附属第一医院', '07', '大连医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (207, '15', '重庆医科大学附属第一医院', '08', '重庆医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (208, '15', '山西医科大学第一医院', '09', '山西医科大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (209, '16', '天津医科大学肿瘤医院（天津市肿瘤医院）', '10', '天津医科大学肿瘤医院（天津市肿瘤医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (210, '16', '南方医院（南方医科大学第一临床医学院）', NULL, '南方医院（南方医科大学第一临床医学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (211, '16', '中南大学湘雅医院', NULL, '中南大学湘雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (212, '16', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (213, '16', '哈尔滨医科大学附属肿瘤医院', '09', '哈尔滨医科大学附属肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (214, '16', '吉林大学第一医院', NULL, '吉林大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (215, '16', '广东医科大学附属医院', '12', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (216, '18', '中国医学科学院阜外医院', '01', '中国医学科学院阜外医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (217, '18', '北京市平谷区医院', '01-1', '北京市平谷区医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (218, '18', '北京医院', '02', '北京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (219, '18', '中国医学科学院北京协和医院', '03', '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (220, '18', '首都医科大学附属宣武医院', '04', '首都医科大学附属宣武医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (222, '18', '首都医科大学附属北京朝阳医院', '06', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (223, '18', '银川市第一人民医院（宁夏医学院第二附属医院）', '07', '银川市第一人民医院（宁夏医学院第二附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (224, '18', '中国人民武装警察部队后勤学院附属医院', '08', '中国人民武装警察部队后勤学院附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (225, '18', '山西医学科学院（山西大医院）', '09', '山西医学科学院（山西大医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (226, '18', '山西医科大学第一医院', '10', '山西医科大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (227, '18', '山西省心血管病医院（山西省心血管病研究所）', '11', '山西省心血管病医院（山西省心血管病研究所）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (228, '18', '开滦总医院', '12', '开滦总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (229, '18', '河北北方学院附属第一医院', '13', '河北北方学院附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (230, '18', '包头医学院第二附属医院', '14', '包头医学院第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (231, '18', '天津市蓟县人民医院', '15', '天津市蓟县人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (232, '18', '大连医科大学附属第一医院', '16', '大连医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (233, '18', '哈尔滨医科大学附属第一医院', '17', '哈尔滨医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (234, '18', '红兴隆中心医院', '18', '红兴隆中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (235, '18', '本溪市铁路医院', '19', '本溪市铁路医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (236, '18', '上海市第一人民医院 （上海交通大学附属第一人民医院）', '20', '上海市第一人民医院 （上海交通大学附属第一人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (237, '18', '山东大学齐鲁医院', '22', '山东大学齐鲁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (238, '18', '苏北人民医院', '23', '苏北人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (239, '18', '济宁市第一人民医院', '24', '济宁市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (240, '18', '镇江市第一人民医院（江苏大学附属人民医院）', '25', '镇江市第一人民医院（江苏大学附属人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (242, '18', '汕头大学医学院第二附属医院', '27', '汕头大学医学院第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (243, '18', '深圳市孙逸仙心血管医院', '28', '深圳市孙逸仙心血管医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (244, '18', '广西医科大学第一附属医院', '29', '广西医科大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (245, '18', '广西中医药大学第一附属医院（广西中医药大学第一临床医学院、广西中医医院）', '30', '广西中医药大学第一附属医院（广西中医药大学第一临床医学院、广西中医医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (246, '18', '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', '31', '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (247, '18', '郑州大学第一附属医院', '32', '郑州大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (248, '18', '南昌大学第二附属医院', '33', '南昌大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (249, '18', '南昌第六医院', '33-1', '南昌第六医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (250, '18', '周口市中心医院', '34', '周口市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (251, '18', '湖南康雅医院', '35', '湖南康雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (252, '18', '武汉大学人民医院（湖北省人民医院）', '21', '武汉大学人民医院（湖北省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (253, '18', '西安交通大学第一附属医院', '36', '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (254, '18', '兰州大学第二医院', '37', '兰州大学第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (255, '18', '新疆医科大学第一附属医院', '38', '新疆医科大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (256, '18', '四川大学华西医院', '39', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (257, '18', '四川大学华西医院', '40', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (258, '18', '昆明医科大学第二附属医院', '41', '昆明医科大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (259, '18', '昆明市延安医院（云南心血管病医院、昆明医科大学附属延安医院）', '43', '昆明市延安医院（云南心血管病医院、昆明医科大学附属延安医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (260, '18', '昆明市第一人民医院(昆明医科大学附属甘美医院)', '41-2', '昆明市第一人民医院(昆明医科大学附属甘美医院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (262, '24', '华中科技大学同济医学院附属协和医院', '01', '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (263, '24', '首都医科大学附属北京友谊医院', '04', '首都医科大学附属北京友谊医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (264, '24', '北京妇产医院', '08', '北京妇产医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (265, '24', '天津医科大学总医院', '09', '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-14', NULL, NULL, '2018-01-14', '2018-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (266, '34', '北京医院', '01', '北京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-17', NULL, NULL, '2018-01-17', '2018-01-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (267, '34', '首都医科大学附属北京朝阳医院', '02', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-01-17', NULL, NULL, '2018-01-17', '2018-01-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (268, '27', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-02-11', NULL, NULL, '2018-02-11', '2018-02-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (269, '17', '北京大学第三医院', '03', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-02-27', NULL, NULL, '2018-02-27', '2018-02-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (270, '17', '大庆油田总医院', '42', '大庆油田总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-03-09', NULL, NULL, '2018-03-09', '2018-03-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (271, '40', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-03-21', NULL, NULL, '2018-03-21', '2018-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (272, '29', '首都医科大学附属北京佑安医院', NULL, '首都医科大学附属北京佑安医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-03-21', NULL, NULL, '2018-03-21', '2018-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (273, '28', '首都医科大学附属北京佑安医院', NULL, '首都医科大学附属北京佑安医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-03-21', NULL, NULL, '2018-03-21', '2018-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (274, '27', '首都医科大学附属北京佑安医院', NULL, '首都医科大学附属北京佑安医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-03-21', NULL, NULL, '2018-03-21', '2018-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (275, '26', '首都医科大学附属北京佑安医院', NULL, '首都医科大学附属北京佑安医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-03-21', NULL, NULL, '2018-03-21', '2018-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (276, '35', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-03-22', NULL, NULL, '2018-03-22', '2018-03-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (277, '47', '广东医科大学附属医院', NULL, '广东医科大学附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2018-03-28', NULL, NULL, '2018-03-28', '2018-03-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (278, '7', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-04-02', NULL, NULL, '2018-04-02', '2018-04-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (279, '12', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-04-17', NULL, NULL, '2018-04-17', '2018-04-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (280, '12', '中南大学湘雅二医院', NULL, '中南大学湘雅二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-04-18', NULL, NULL, '2018-04-18', '2018-04-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (282, '35', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-04-25', NULL, NULL, '2018-04-25', '2018-04-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (283, '34', '麻醉科', NULL, '麻醉科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2018-05-02', NULL, NULL, '2018-05-02', '2018-05-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (284, '34', '宁夏医科大学总医院', NULL, '宁夏医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-05-02', NULL, NULL, '2018-05-02', '2018-05-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (285, '34', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-05-02', NULL, NULL, '2018-05-02', '2018-05-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (286, '29', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-05-04', NULL, NULL, '2018-05-04', '2018-05-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (287, '35', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-05-28', NULL, NULL, '2018-05-28', '2018-05-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (288, '41', '常德市第一人民医院', NULL, '常德市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-06-01', NULL, NULL, '2018-06-01', '2018-06-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (289, '41', '上海市公共卫生临床中心', NULL, '上海市公共卫生临床中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-06-01', NULL, NULL, '2018-06-01', '2018-06-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (290, '41', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-06-19', NULL, NULL, '2018-06-19', '2018-06-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (291, '6', '佳木斯市肿瘤医院', '11', '佳木斯市肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-06-27', NULL, NULL, '2018-06-27', '2018-06-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (292, '6', '武汉市传染病医院', '10', '武汉市传染病医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-06-27', NULL, NULL, '2018-06-27', '2018-06-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (293, '17', '郑州大学第一附属医院', '44', '郑州大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-06-28', NULL, NULL, '2018-06-28', '2018-06-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (294, '17', '新乡市第一人民医院', '46', '新乡市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-06-28', NULL, NULL, '2018-06-28', '2018-06-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (295, '28', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-07-04', NULL, NULL, '2018-07-04', '2018-07-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (296, '47', '麻醉科', NULL, '麻醉科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2018-07-09', NULL, NULL, '2018-07-09', '2018-07-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (297, '52', '中南大学湘雅三医院', '01', '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-08-08', NULL, NULL, '2018-08-08', '2018-08-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (298, '38', '浙江大学医学院附属第二医院', NULL, '浙江大学医学院附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-08-09', NULL, NULL, '2018-08-09', '2018-08-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (299, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-08-13', NULL, NULL, '2018-08-13', '2018-08-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (300, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2018-08-13', NULL, NULL, '2018-08-13', '2018-08-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (302, '12', '药物临床试验机构', NULL, '药物临床试验机构', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-08-15', NULL, NULL, '2018-08-15', '2018-08-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (303, '52', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-08-17', NULL, NULL, '2018-08-17', '2018-08-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (304, '0', '中南大学湘雅二医院', NULL, '中南大学湘雅二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-08-28', NULL, NULL, '2018-08-28', '2018-08-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (305, '0', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-08-28', NULL, NULL, '2018-08-28', '2018-08-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (306, '40', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', '01', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-09-07', NULL, NULL, '2018-09-07', '2018-09-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (307, '29', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-09-19', NULL, NULL, '2018-09-19', '2018-09-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (308, '26', '中山大学附属第三医院', NULL, '中山大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-09-19', NULL, NULL, '2018-09-19', '2018-09-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (309, '40', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-09-25', NULL, NULL, '2018-09-25', '2018-09-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (310, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-12', NULL, NULL, '2018-10-12', '2018-10-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (311, '12', '连云港中医院', '11', '连云港中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (312, '12', '湖南省中医药研究院附属医院', '12', '湖南省中医药研究院附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (313, '12', '湖南中医药大学第一附属医院', '13', '湖南中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (314, '12', '上海市第七人民医院', '14', '上海市第七人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (315, '12', '上海岳阳中西医结合病医院', '15', '上海岳阳中西医结合病医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (316, '12', '常州市中医院', '16', '常州市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (317, '12', '佛山市中医院', '17', '佛山市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (318, '12', '潍坊市中医院', '18', '潍坊市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-19', NULL, NULL, '2018-10-19', '2018-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (319, '54', '长沙市第三医院', '01', '长沙市第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-25', NULL, NULL, '2018-10-25', '2018-10-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (320, '52', '中南大学湘雅三医院', '01', '中南大学湘雅三医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2018-10-25', NULL, NULL, '2018-10-25', '2018-10-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (322, '41', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2018-10-30', NULL, NULL, '2018-10-30', '2018-10-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (323, '41', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-30', NULL, NULL, '2018-10-30', '2018-10-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (324, '25', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-10-31', NULL, NULL, '2018-10-31', '2018-10-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (325, '40', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-11-01', NULL, NULL, '2018-11-01', '2018-11-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (326, '35', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-11-09', NULL, NULL, '2018-11-09', '2018-11-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (327, '7', '温州医科大学附属第一医院', '04', '温州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-11-21', NULL, NULL, '2018-11-21', '2018-11-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (328, '63', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-11-23', NULL, NULL, '2018-11-23', '2018-11-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (329, '54', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-11-27', NULL, NULL, '2018-11-27', '2018-11-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (330, '54', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-12-04', NULL, NULL, '2018-12-04', '2018-12-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (331, '12', '吉林大学中日联谊医院', NULL, '吉林大学中日联谊医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-12-10', NULL, NULL, '2018-12-10', '2018-12-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (332, '54', '药物临床试验机构', NULL, '药物临床试验机构', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-12-12', NULL, NULL, '2018-12-12', '2018-12-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (333, '6', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-12-24', NULL, NULL, '2018-12-24', '2018-12-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (334, '54', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2018-12-26', NULL, NULL, '2018-12-26', '2018-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (335, '54', '麻醉科', NULL, '麻醉科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2018-12-26', NULL, NULL, '2018-12-26', '2018-12-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (336, '7', '北京清华长庚医院', '08', '北京清华长庚医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (337, '7', '河南省人民医院', NULL, '河南省人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (338, '7', '树兰（杭州）医院有限公司', NULL, '树兰（杭州）医院有限公司', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (339, '7', '泉州市第一医院', '14', '泉州市第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (340, '7', '衢州市人民医院', '13', '衢州市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (342, '7', '首都医科大学附属北京胸科医院', '17', '首都医科大学附属北京胸科医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (343, '7', '温州医科大学附属第一医院', '04', '温州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (344, '7', '中国人民解放军南京军区福州总医院', '15', '中国人民解放军南京军区福州总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-02', NULL, NULL, '2019-01-02', '2019-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (345, '31', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-09', NULL, NULL, '2019-01-09', '2019-01-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (346, '29', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-09', NULL, NULL, '2019-01-09', '2019-01-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (347, '8', '岳阳市人民医院', '11', '岳阳市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-23', NULL, NULL, '2019-01-23', '2019-01-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (348, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-24', NULL, NULL, '2019-01-24', '2019-01-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (349, '19', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-01-29', NULL, NULL, '2019-01-29', '2019-01-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (350, '54', '长沙市第三医院', NULL, '长沙市第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-02-27', NULL, NULL, '2019-02-27', '2019-02-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (351, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-03-05', NULL, NULL, '2019-03-05', '2019-03-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (352, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-03-05', NULL, NULL, '2019-03-05', '2019-03-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (353, '65', '首都医科大学附属北京朝阳医院', NULL, '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-03-05', NULL, NULL, '2019-03-05', '2019-03-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (354, '5', '药物临床试验机构', NULL, '药物临床试验机构', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-03-11', NULL, NULL, '2019-03-11', '2019-03-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (355, '6', '药物临床试验机构', NULL, '药物临床试验机构', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-03-11', NULL, NULL, '2019-03-11', '2019-03-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (356, '8', '新乡市第一人民医院', '09', '新乡市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-03-12', NULL, NULL, '2019-03-12', '2019-03-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (357, '27', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-03-29', NULL, NULL, '2019-03-29', '2019-03-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (358, '66', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-04-01', NULL, NULL, '2019-04-01', '2019-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (359, '66', '中南大学湘雅医院', '01', '中南大学湘雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-04-01', NULL, NULL, '2019-04-01', '2019-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (360, '54', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-04-01', NULL, NULL, '2019-04-01', '2019-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (362, '68', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-05-21', NULL, NULL, '2019-05-21', '2019-05-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (363, '6', '西安市胸科医院', '12', '西安市胸科医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-06-10', NULL, NULL, '2019-06-10', '2019-06-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (364, '7', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-06-18', NULL, NULL, '2019-06-18', '2019-06-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (365, '68', '天津医科大学总医院', NULL, '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-06-28', NULL, NULL, '2019-06-28', '2019-06-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (366, '53', '天津医科大学总医院', NULL, '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-06-28', NULL, NULL, '2019-06-28', '2019-06-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (367, '53', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-06-28', NULL, NULL, '2019-06-28', '2019-06-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (368, '68', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-07', NULL, NULL, '2019-08-07', '2019-08-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (369, '66', '大连医科大学附属第二医院', NULL, '大连医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-07', NULL, NULL, '2019-08-07', '2019-08-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (370, '66', '麻醉科', NULL, '麻醉科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2019-08-07', NULL, NULL, '2019-08-07', '2019-08-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (371, '6', '首都医科大学附属北京胸科医院', '13', '首都医科大学附属北京胸科医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-14', NULL, NULL, '2019-08-14', '2019-08-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (372, '6', '衢州市人民医院', '14', '衢州市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-19', NULL, NULL, '2019-08-19', '2019-08-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (373, '70', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-22', NULL, NULL, '2019-08-22', '2019-08-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (374, '70', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-22', NULL, NULL, '2019-08-22', '2019-08-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (375, '70', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-23', NULL, NULL, '2019-08-23', '2019-08-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (376, '70', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-29', NULL, NULL, '2019-08-29', '2019-08-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (377, '70', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-08-29', NULL, NULL, '2019-08-29', '2019-08-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (378, '66', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-09-09', NULL, NULL, '2019-09-09', '2019-09-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (379, '53', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-09-16', NULL, NULL, '2019-09-16', '2019-09-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (380, '72', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-09-20', NULL, NULL, '2019-09-20', '2019-09-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (382, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-09-25', NULL, NULL, '2019-09-25', '2019-09-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (383, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-09-25', NULL, NULL, '2019-09-25', '2019-09-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (384, '73', '中国中医科学院西苑医院', '01', '中国中医科学院西苑医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-10-12', NULL, NULL, '2019-10-12', '2019-10-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (385, '53', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-10-28', NULL, NULL, '2019-10-28', '2019-10-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (386, '72', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', '01', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-10-28', NULL, NULL, '2019-10-28', '2019-10-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (387, '79', '北京中医药大学东直门医院', '01', '北京中医药大学东直门医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (388, '79', '湖南中医药大学第一附属医院', '02', '湖南中医药大学第一附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (389, '71', '中国中医科学院广安门医院', '01', '中国中医科学院广安门医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (390, '71', '上海中医药大学附属曙光医院', '02', '上海中医药大学附属曙光医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (391, '71', '广州中医药大学第一附属医院', '03', '广州中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (392, '71', '广东省第二中医院', '04', '广东省第二中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (393, '71', '北京大学第一医院', '05', '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (394, '71', '成都中医药大学附属医院', '07', '成都中医药大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (395, '71', '浙江中医药大学附属第三医院', '06', '浙江中医药大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-08', NULL, NULL, '2019-11-08', '2019-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (396, '72', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', '01', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-14', NULL, NULL, '2019-11-14', '2019-11-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (397, '66', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-18', NULL, NULL, '2019-11-18', '2019-11-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (398, '60', '湖南省肿瘤医院', '01', '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (399, '61', '湖南省肿瘤医院', '01', '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (400, '64', '湖南省肿瘤医院', '01', '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (402, '83', '广东医科大学附属医院', '01', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (403, '84', '郑州大学第一附属医院', '01', '郑州大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (404, '85', '河南省肿瘤医院', '01', '河南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (405, '86', '上海市肺科医院', '01', '上海市肺科医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (406, '87', '首都医科大学附属北京世纪坛医院', '01', '首都医科大学附属北京世纪坛医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (407, '88', '连云港市第一人民医院', '01', '连云港市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (408, '89', '中南大学湘雅医院', '01', '中南大学湘雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (409, '89', '河南省人民医院', '02', '河南省人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (410, '90', '北京清华长庚医院', '01', '北京清华长庚医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (411, '91', '辽宁中医药大学附属医院', '01', '辽宁中医药大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (412, '101', '中山大学附属肿瘤防治中心', '01', '中山大学附属肿瘤防治中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (413, '92', '广东医科大学附属医院', '01', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (414, '93', '北京医院', '01', '北京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (415, '94', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (416, '95', '连云港市第一人民医院', '01', '连云港市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (417, '96', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (418, '97', '广东医科大学附属医院', '01', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (419, '98', '沈阳市胸科医院', '01', '沈阳市胸科医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (420, '99', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (422, '100', '华中科技大学同济医学院附属协和医院', '02', '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-11-28', NULL, NULL, '2019-11-28', '2019-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (423, '103', '沈阳市第四人民医院', '01', '沈阳市第四人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-03', NULL, NULL, '2019-12-03', '2019-12-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (424, '66', '大连医科大学附属第二医院', NULL, '大连医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-11', NULL, NULL, '2019-12-11', '2019-12-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (425, '66', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-11', NULL, NULL, '2019-12-11', '2019-12-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (426, '73', '河北以岭医院', '03', '河北以岭医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (427, '73', '上海市中医医院', '04', '上海市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (428, '73', '辽宁中医药大学附属医院', '05', '辽宁中医药大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (429, '73', '四川大学华西医院', '06', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (430, '73', '天津中医药大学第二附属医院', '02', '天津中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (431, '73', '泰州市中医院', '07', '泰州市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (432, '73', '中山市中医院', '08', '中山市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (433, '73', '厦门市中医院', '09', '厦门市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (434, '73', '云南省中医医院', '10', '云南省中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (435, '73', '广东省第二中医院', '11', '广东省第二中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-16', NULL, NULL, '2019-12-16', '2019-12-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (436, '72', '药物临床试验机构', NULL, '药物临床试验机构', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2019-12-17', NULL, NULL, '2019-12-17', '2019-12-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (437, '8', '合肥市第二人民医院', '10', '合肥市第二人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-03', NULL, NULL, '2020-01-03', '2020-01-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (438, '74', '上海交通大学医学院附属仁济医院', '01', '上海交通大学医学院附属仁济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (439, '74', '中国医学科学院北京协和医院', '02', '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (440, '74', '中国医科大学附属盛京医院', '03', '中国医科大学附属盛京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (442, '74', '南方医院（南方医科大学第一临床医学院）', '05', '南方医院（南方医科大学第一临床医学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (443, '74', '上海市同济医院（同济大学附属同济医院）', '06', '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (444, '74', '南京鼓楼医院（南京大学医学院附属鼓楼医院）', '07', '南京鼓楼医院（南京大学医学院附属鼓楼医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (445, '74', '华中科技大学同济医学院附属同济医院', '08', '华中科技大学同济医学院附属同济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (446, '74', '上海交通大学医学院附属第九人民医院', '09', '上海交通大学医学院附属第九人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (447, '74', '武汉大学人民医院（湖北省人民医院）', '10', '武汉大学人民医院（湖北省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (448, '74', '南京医科大学第一附属医院 （原江苏省人民医院）', '11', '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (449, '74', '复旦大学附属中山医院（上海中山医院）', '12', '复旦大学附属中山医院（上海中山医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (450, '74', '华中科技大学同济医学院附属协和医院', '13', '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (451, '74', '青岛大学附属医院', '14', '青岛大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (452, '74', '山东大学齐鲁医院', '15', '山东大学齐鲁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (453, '74', '四川省人民医院（四川省医学科学院）', '16', '四川省人民医院（四川省医学科学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (454, '74', '郑州大学第一附属医院', '17', '郑州大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (455, '74', '中山大学孙逸仙纪念医院', '18', '中山大学孙逸仙纪念医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (456, '74', '浙江大学医学院附属邵逸夫医院', '19', '浙江大学医学院附属邵逸夫医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (457, '74', '天津医科大学总医院', '20', '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-07', NULL, NULL, '2020-01-07', '2020-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (458, '107', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-08', NULL, NULL, '2020-01-08', '2020-01-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (459, '105', '湖南省肿瘤医院', '01', '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-08', NULL, NULL, '2020-01-08', '2020-01-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (460, '68', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-09', NULL, NULL, '2020-01-09', '2020-01-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (462, '111', '首都医科大学附属北京同仁医院', '01', '首都医科大学附属北京同仁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-19', NULL, NULL, '2020-01-19', '2020-01-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (463, '110', '湖南省肿瘤医院', '01', '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-19', NULL, NULL, '2020-01-19', '2020-01-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (464, '109', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-19', NULL, NULL, '2020-01-19', '2020-01-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (465, '108', '郴州市第一人民医院', '01', '郴州市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-01-19', NULL, NULL, '2020-01-19', '2020-01-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (466, '129', '河北医科大学第四医院（河北省肿瘤医院）', '30', '河北医科大学第四医院（河北省肿瘤医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-18', NULL, NULL, '2020-03-18', '2020-03-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (467, '80', '呼吸科', NULL, '呼吸科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-18', NULL, NULL, '2020-03-18', '2020-03-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (468, '73', '青岛市中医医院', '12', '青岛市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-30', NULL, NULL, '2020-03-30', '2020-03-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (469, '80', '首都医科大学附属北京世纪坛医院', '01', '首都医科大学附属北京世纪坛医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-30', NULL, NULL, '2020-03-30', '2020-03-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (470, '115', '辽宁省人民医院', '01', '辽宁省人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-30', NULL, NULL, '2020-03-30', '2020-03-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (471, '129', '福建省肿瘤医院', '29', '福建省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (472, '129', '中国医科大学附属第一医院', '28', '中国医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (473, '129', '吉林大学中日联谊医院', '27', '吉林大学中日联谊医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (474, '129', '江苏省肿瘤医院', '26', '江苏省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (475, '129', '四川大学华西医院', '25', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (476, '129', '南方医院（南方医科大学第一临床医学院）', '24', '南方医院（南方医科大学第一临床医学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (477, '129', '浙江大学医学院附属邵逸夫医院', '23', '浙江大学医学院附属邵逸夫医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (478, '129', '复旦大学附属肿瘤医院', '22', '复旦大学附属肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (479, '129', '中国医学科学院肿瘤医院', '21', '中国医学科学院肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (480, '129', '天津医科大学总医院', '20', '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (482, '129', '大连医科大学附属第一医院', '17', '大连医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (483, '129', '山西省肿瘤医院', '16', '山西省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (484, '129', '吉林大学白求恩第一医院', '15', '吉林大学白求恩第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (485, '129', '哈尔滨医科大学附属肿瘤医院', '14', '哈尔滨医科大学附属肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (486, '129', '北京大学第一医院', '13', '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (487, '129', '中国人民解放军东部战区总医院（原南京军区南京总医院）', '12', '中国人民解放军东部战区总医院（原南京军区南京总医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (488, '129', '温州医科大学附属第二医院', '11', '温州医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (489, '129', '复旦大学附属中山医院（上海中山医院）', '10', '复旦大学附属中山医院（上海中山医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (490, '129', '青岛大学医学院附属医院', '09', '青岛大学医学院附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (491, '129', '天津医科大学肿瘤医院（天津市肿瘤医院）', '08', '天津医科大学肿瘤医院（天津市肿瘤医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (492, '129', '首都医科大学附属宣武医院', '07', '首都医科大学附属宣武医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (493, '129', '首都医科大学附属北京友谊医院', '06', '首都医科大学附属北京友谊医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (494, '129', '北京大学人民医院', '05', '北京大学人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (495, '129', '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', '04', '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (496, '129', '北京大学肿瘤医院', '03', '北京大学肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (497, '129', '南京医科大学第一附属医院 （原江苏省人民医院）', '02', '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (498, '129', '中国人民解放军总医院（第一医学中心/301医院）', '01', '中国人民解放军总医院（第一医学中心/301医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (499, '20', '首都医科大学附属北京佑安医院', '02', '首都医科大学附属北京佑安医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (500, '20', '西安交通大学第一附属医院', '08', '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-03-31', NULL, NULL, '2020-03-31', '2020-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (502, '114', '四川大学华西医院', '02', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (503, '114', '河北燕达陆道培医院', '03', '河北燕达陆道培医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (504, '114', '吉林大学白求恩第一医院', '04', '吉林大学白求恩第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (505, '114', '山东大学齐鲁医院', '05', '山东大学齐鲁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (506, '114', '南方医院（南方医科大学第一临床医学院）', '06', '南方医院（南方医科大学第一临床医学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (507, '114', '西安交通大学第一附属医院', '07', '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (508, '114', '山东省立医院（山东第一医科大学附属省立医院）', '08', '山东省立医院（山东第一医科大学附属省立医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (509, '114', '上海交通大学医学院附属瑞金医院', '09', '上海交通大学医学院附属瑞金医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (510, '114', '上海市同济医院（同济大学附属同济医院）', '10', '上海市同济医院（同济大学附属同济医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (511, '114', '安徽医科大学第二附属医院', '11', '安徽医科大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (512, '114', '河南省人民医院', '12', '河南省人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (513, '67', '温州医科大学附属第一医院', '01', '温州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (514, '67', '浙江省人民医院', '02', '浙江省人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (515, '67', '瑞安市人民医院（温州医科大学附属第三医院）', '03', '瑞安市人民医院（温州医科大学附属第三医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (516, '67', '衢州市人民医院', '04', '衢州市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (517, '67', '广州医科大学附属第三医院', '05', '广州医科大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (518, '67', '中山大学孙逸仙纪念医院', '06', '中山大学孙逸仙纪念医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (519, '67', '广州医科大学附属第一医院', '07', '广州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (520, '67', '晋中市第一人民医院（山西医科大学附属医院）', '08', '晋中市第一人民医院（山西医科大学附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (522, '67', '首都医科大学附属北京朝阳医院', '10', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (523, '67', '首都医科大学附属北京天坛医院', '11', '首都医科大学附属北京天坛医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (524, '67', '武汉大学中南医院', '12', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (525, '67', '武汉市第三医院（武汉大学附属同仁医院）', '13', '武汉市第三医院（武汉大学附属同仁医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (526, '67', '贵州医科大学附属医院（贵阳医学院附属医院）', '14', '贵州医科大学附属医院（贵阳医学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (527, '67', '南通市第一人民医院', '15', '南通市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (528, '67', '北华大学附属医院', '16', '北华大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (529, '67', '通化市中心医院', '17', '通化市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (530, '67', '西南医科大学附属医院', '18', '西南医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (531, '67', '赤峰学院附属医院', '19', '赤峰学院附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (532, '66', '河北医科大学第三医院', NULL, '河北医科大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-01', NULL, NULL, '2020-04-01', '2020-04-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (533, '79', '浙江中医药大学附属第三医院', '002', '浙江中医药大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-02', NULL, NULL, '2020-04-02', '2020-04-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (534, '79', '北京市房山区中医医院', '003', '北京市房山区中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-02', NULL, NULL, '2020-04-02', '2020-04-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (535, '65', '首都医科大学附属北京世纪坛医院', '01', '首都医科大学附属北京世纪坛医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-05', NULL, NULL, '2020-04-05', '2020-04-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (536, '133', '长沙市第三医院', '01', '长沙市第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-07', NULL, NULL, '2020-04-07', '2020-04-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (537, '115', '天津市第一中心医院', NULL, '天津市第一中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-13', NULL, NULL, '2020-04-13', '2020-04-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (538, '133', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-17', NULL, NULL, '2020-04-17', '2020-04-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (539, '115', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-21', NULL, NULL, '2020-04-21', '2020-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (540, '38', '北京医院', '01', '北京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-27', NULL, NULL, '2020-04-27', '2020-04-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (542, '38', '中国人民解放军总医院第六医学中心（海军总医院）', '02', '中国人民解放军总医院第六医学中心（海军总医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (543, '38', '吉林大学第一医院', '04', '吉林大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (544, '38', '中山大学附属第三医院', '05', '中山大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (545, '38', '广州医科大学附属第二医院', '06', '广州医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (546, '38', '广东医科大学附属医院', '07', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (547, '38', '重庆医科大学附属第一医院', '08', '重庆医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (548, '38', '中南大学湘雅二医院', '09', '中南大学湘雅二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (549, '38', '常德市第一人民医院', '10', '常德市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (550, '38', '南京市第一医院', '11', '南京市第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-04-28', NULL, NULL, '2020-04-28', '2020-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (551, '68', '内蒙古科技大学包头医学院第一附属医院', NULL, '内蒙古科技大学包头医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-05-15', NULL, NULL, '2020-05-15', '2020-05-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (552, '114', '风湿免疫科', NULL, '风湿免疫科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-05-27', NULL, NULL, '2020-05-27', '2020-05-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (553, '73', '温州市中医院', '13', '温州市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-04', NULL, NULL, '2020-06-04', '2020-06-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (554, '73', '麻醉科', NULL, '麻醉科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2020-06-04', NULL, NULL, '2020-06-04', '2020-06-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (555, '72', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-17', NULL, NULL, '2020-06-17', '2020-06-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (556, '73', '北京医院', NULL, '北京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-18', NULL, NULL, '2020-06-18', '2020-06-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (557, '73', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-18', NULL, NULL, '2020-06-18', '2020-06-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (558, '68', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-18', NULL, NULL, '2020-06-18', '2020-06-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (559, '73', '风湿免疫科', NULL, '风湿免疫科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-23', NULL, NULL, '2020-06-23', '2020-06-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (560, '133', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-24', NULL, NULL, '2020-06-24', '2020-06-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (562, '133', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-28', NULL, NULL, '2020-06-28', '2020-06-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (563, '69', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-29', NULL, NULL, '2020-06-29', '2020-06-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (564, '73', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-29', NULL, NULL, '2020-06-29', '2020-06-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (565, '66', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-30', NULL, NULL, '2020-06-30', '2020-06-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (566, '53', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-30', NULL, NULL, '2020-06-30', '2020-06-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (567, '68', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-30', NULL, NULL, '2020-06-30', '2020-06-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (568, '72', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-30', NULL, NULL, '2020-06-30', '2020-06-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (569, '35', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-06-30', NULL, NULL, '2020-06-30', '2020-06-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (570, '133', '西安交通大学第一附属医院', NULL, '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-06', NULL, NULL, '2020-07-06', '2020-07-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (571, '72', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-06', NULL, NULL, '2020-07-06', '2020-07-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (572, '147', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-23', NULL, NULL, '2020-07-23', '2020-07-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (573, '145', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-23', NULL, NULL, '2020-07-23', '2020-07-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (574, '144', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-23', NULL, NULL, '2020-07-23', '2020-07-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (575, '143', '四川省人民医院（四川省医学科学院）', '01', '四川省人民医院（四川省医学科学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-23', NULL, NULL, '2020-07-23', '2020-07-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (576, '143', '成都医学院第一附属医院', '02', '成都医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-23', NULL, NULL, '2020-07-23', '2020-07-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (577, '142', '连云港市第一人民医院', NULL, '连云港市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-23', NULL, NULL, '2020-07-23', '2020-07-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (578, '132', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-07-23', NULL, NULL, '2020-07-23', '2020-07-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (579, '146', '四川大学华西医院', '01', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-03', NULL, NULL, '2020-08-03', '2020-08-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (580, '69', '中国中医科学院西苑医院', '01', '中国中医科学院西苑医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-03', NULL, NULL, '2020-08-03', '2020-08-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (582, '106', '温州医科大学附属第二医院', '01', '温州医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-06', NULL, NULL, '2020-08-06', '2020-08-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (583, '114', '上海市第一人民医院 （上海交通大学附属第一人民医院）', '13', '上海市第一人民医院 （上海交通大学附属第一人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-11', NULL, NULL, '2020-08-11', '2020-08-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (584, '114', '上海交通大学医学院附属仁济医院', '14', '上海交通大学医学院附属仁济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-11', NULL, NULL, '2020-08-11', '2020-08-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (585, '156', '解放军总医院第五医学中心感染性疾病诊疗与研究中心', '01', '解放军总医院第五医学中心感染性疾病诊疗与研究中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-19', NULL, NULL, '2020-08-19', '2020-08-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (586, '146', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-20', NULL, NULL, '2020-08-20', '2020-08-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (587, '72', '河北医科大学第二附属医院', NULL, '河北医科大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-21', NULL, NULL, '2020-08-21', '2020-08-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (588, '115', '呼吸科', NULL, '呼吸科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-21', NULL, NULL, '2020-08-21', '2020-08-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (589, '80', '首都医科大学附属北京朝阳医院', NULL, '首都医科大学附属北京朝阳医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2020-08-21', NULL, NULL, '2020-08-21', '2020-08-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (590, '162', '武汉市肺科医院（武汉市结核病防治所）', '01', '武汉市肺科医院（武汉市结核病防治所）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-26', NULL, NULL, '2020-08-26', '2020-08-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (591, '80', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-28', NULL, NULL, '2020-08-28', '2020-08-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (592, '52', '徐州医学院附属医院', NULL, '徐州医学院附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-08-28', NULL, NULL, '2020-08-28', '2020-08-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (593, '73', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-09-04', NULL, NULL, '2020-09-04', '2020-09-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (594, '68', '浙江大学医学院附属第二医院', NULL, '浙江大学医学院附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-09-14', NULL, NULL, '2020-09-14', '2020-09-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (595, '52', '中国医科大学附属第一医院', NULL, '中国医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-11-13', NULL, NULL, '2020-11-13', '2020-11-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (596, '71', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-11-23', NULL, NULL, '2020-11-23', '2020-11-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (597, '79', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-11-23', NULL, NULL, '2020-11-23', '2020-11-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (598, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-12-01', NULL, NULL, '2020-12-01', '2020-12-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (599, '52', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-12-01', NULL, NULL, '2020-12-01', '2020-12-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (600, '6', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2020-12-02', NULL, NULL, '2020-12-02', '2020-12-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (602, '191', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-01-06', NULL, NULL, '2021-01-06', '2021-01-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (603, '191', '航天中心医院（北京大学航天临床医学院）', NULL, '航天中心医院（北京大学航天临床医学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-01-08', NULL, NULL, '2021-01-08', '2021-01-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (604, '115', '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-01-11', NULL, NULL, '2021-01-11', '2021-01-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (605, '185', '药物临床试验机构', NULL, '药物临床试验机构', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2021-01-15', NULL, NULL, '2021-01-15', '2021-01-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (606, '185', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-01-15', NULL, NULL, '2021-01-15', '2021-01-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (607, '184', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-01-15', NULL, NULL, '2021-01-15', '2021-01-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (608, '114', '天津市人民医院', NULL, '天津市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-01-25', NULL, NULL, '2021-01-25', '2021-01-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (609, '73', '首都医科大学附属北京安贞医院', NULL, '首都医科大学附属北京安贞医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-02-01', NULL, NULL, '2021-02-01', '2021-02-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (610, '194', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-02-02', NULL, NULL, '2021-02-02', '2021-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (611, '52', '呼吸科', NULL, '呼吸科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-02-22', NULL, NULL, '2021-02-22', '2021-02-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (612, '5', '药物临床试验机构', NULL, '药物临床试验机构', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-02-28', NULL, NULL, '2021-02-28', '2021-02-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (613, '204', '武汉市精神卫生中心', NULL, '武汉市精神卫生中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-03-12', NULL, NULL, '2021-03-12', '2021-03-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (614, '191', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-03-12', NULL, NULL, '2021-03-12', '2021-03-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (615, '204', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-03-15', NULL, NULL, '2021-03-15', '2021-03-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (616, '194', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-03-16', NULL, NULL, '2021-03-16', '2021-03-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (617, '194', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-03-16', NULL, NULL, '2021-03-16', '2021-03-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (618, '209', '浙江医院', NULL, '浙江医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-03-29', NULL, NULL, '2021-03-29', '2021-03-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (619, '194', '首都医科大学附属北京同仁医院', NULL, '首都医科大学附属北京同仁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-03-30', NULL, NULL, '2021-03-30', '2021-03-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (620, '185', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-09', NULL, NULL, '2021-04-09', '2021-04-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (622, '184', '首都医科大学附属北京同仁医院', '01', '首都医科大学附属北京同仁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (623, '184', '沧州市人民医院', '02', '沧州市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (624, '184', '岳阳市人民医院', '03', '岳阳市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (625, '184', '新乡市第一人民医院', '04', '新乡市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (626, '184', '广东医科大学附属医院', '05', '广东医科大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (627, '184', '沧州市中心医院', '06', '沧州市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (628, '184', '菏泽市立医院', '08', '菏泽市立医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (629, '184', '新乡市中心医院', '09', '新乡市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (630, '184', '山东省立第三医院', '10', '山东省立第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (631, '184', '新乡医学院第三附属医院', '11', '新乡医学院第三附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (632, '184', '泰安市中心医院', '12', '泰安市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (633, '184', '洛阳市第三人民医院', '13', '洛阳市第三人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (634, '184', '驻马店市中心医院', '14', '驻马店市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (635, '184', '宁夏回族自治区人民医院', '15', '宁夏回族自治区人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (636, '184', '河南科技大学第一附属医院', '16', '河南科技大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (637, '184', '安徽医科大学第二附属医院', '17', '安徽医科大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (638, '184', '武汉市第三医院（武汉大学附属同仁医院）', '19', '武汉市第三医院（武汉大学附属同仁医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (639, '185', '武汉大学中南医院', '01', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (640, '185', '中国医学科学院北京协和医院', '02', '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (642, '185', '荆州市中心医院', '04', '荆州市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (643, '185', '武汉市中心医院/华中科技大学同济医学院附属武汉中心医院', '05', '武汉市中心医院/华中科技大学同济医学院附属武汉中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (644, '185', '武汉市第五医院', '06', '武汉市第五医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (645, '185', '北京大学首钢医院', '08', '北京大学首钢医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (646, '185', '应急总医院', '09', '应急总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (647, '185', '盘锦辽油宝石花医院', '10', '盘锦辽油宝石花医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (648, '185', '沈阳市第五人民医院', '11', '沈阳市第五人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (649, '185', '河南大学淮河医院', '12', '河南大学淮河医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (650, '185', '山东大学齐鲁医院', '13', '山东大学齐鲁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (651, '185', '十堰市太和医院', '14', '十堰市太和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (652, '185', '四平市中心医院/四平市中心人民医院', '15', '四平市中心医院/四平市中心人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (653, '185', '遵义市第一人民医院', '16', '遵义市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (654, '185', '东莞东华医院', '17', '东莞东华医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (655, '185', '重钢总医院', '18', '重钢总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-04-28', NULL, NULL, '2021-04-28', '2021-04-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (656, '209', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-05-10', NULL, NULL, '2021-05-10', '2021-05-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (657, '69', '天津医科大学总医院', NULL, '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-05-24', NULL, NULL, '2021-05-24', '2021-05-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (658, '202', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-05-28', NULL, NULL, '2021-05-28', '2021-05-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (659, '256', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-01', NULL, NULL, '2021-06-01', '2021-06-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (660, '235', '黑龙江中医药大学附属第二医院', '01', '黑龙江中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-03', NULL, NULL, '2021-06-03', '2021-06-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (662, '140', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-09', NULL, NULL, '2021-06-09', '2021-06-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (663, '275', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-11', NULL, NULL, '2021-06-11', '2021-06-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (664, '246', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-11', NULL, NULL, '2021-06-11', '2021-06-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (665, '34', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', '1001', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-15', NULL, NULL, '2021-06-15', '2021-06-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (666, '270', '河南大学淮河医院', NULL, '河南大学淮河医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-15', NULL, NULL, '2021-06-15', '2021-06-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (667, '202', '南京高新医院', NULL, '南京高新医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-21', NULL, NULL, '2021-06-21', '2021-06-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (668, '235', '开封市中医院', '02', '开封市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-22', NULL, NULL, '2021-06-22', '2021-06-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (669, '235', '湖南省中医院', '03', '湖南省中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-23', NULL, NULL, '2021-06-23', '2021-06-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (670, '73', '湖南中医药大学第一附属医院', NULL, '湖南中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-25', NULL, NULL, '2021-06-25', '2021-06-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (671, '246', '武汉市传染病医院', NULL, '武汉市传染病医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-29', NULL, NULL, '2021-06-29', '2021-06-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (672, '203', '肾内科', NULL, '肾内科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-29', NULL, NULL, '2021-06-29', '2021-06-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (673, '184', '精神科', NULL, '精神科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-29', NULL, NULL, '2021-06-29', '2021-06-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (674, '203', '江苏大学附属医院', NULL, '江苏大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-06-30', NULL, NULL, '2021-06-30', '2021-06-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (675, '279', '延边大学附属医院', NULL, '延边大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-06', NULL, NULL, '2021-07-06', '2021-07-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (676, '185', '针灸科', NULL, '针灸科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-07', NULL, NULL, '2021-07-07', '2021-07-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (677, '185', '针灸科', NULL, '针灸科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-12', NULL, NULL, '2021-07-12', '2021-07-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (678, '184', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-12', NULL, NULL, '2021-07-12', '2021-07-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (679, '184', '黑龙江中医药大学附属第二医院', NULL, '黑龙江中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-12', NULL, NULL, '2021-07-12', '2021-07-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (680, '279', '湖南中医药大学第二附属医院', NULL, '湖南中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-14', NULL, NULL, '2021-07-14', '2021-07-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (682, '235', '保定市第一中医院', '06', '保定市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-28', NULL, NULL, '2021-07-28', '2021-07-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (683, '235', '浙江中医药大学附属第三医院', '08', '浙江中医药大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-30', NULL, NULL, '2021-07-30', '2021-07-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (684, '184', '湖北省中医院', NULL, '湖北省中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-30', NULL, NULL, '2021-07-30', '2021-07-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (685, '184', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-07-30', NULL, NULL, '2021-07-30', '2021-07-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (686, '185', '吉林大学中日联谊医院', NULL, '吉林大学中日联谊医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-02', NULL, NULL, '2021-08-02', '2021-08-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (687, '235', '连云港市中医院', '09', '连云港市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-05', NULL, NULL, '2021-08-05', '2021-08-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (688, '202', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-06', NULL, NULL, '2021-08-06', '2021-08-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (689, '235', '岳阳市中医医院', '12', '岳阳市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-11', NULL, NULL, '2021-08-11', '2021-08-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (690, '235', '宜昌市中医医院', '15', '宜昌市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-11', NULL, NULL, '2021-08-11', '2021-08-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (691, '249', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-13', NULL, NULL, '2021-08-13', '2021-08-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (692, '291', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-13', NULL, NULL, '2021-08-13', '2021-08-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (693, '184', '精神心理科', NULL, '精神心理科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-19', NULL, NULL, '2021-08-19', '2021-08-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (694, '185', '精神心理科', NULL, '精神心理科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-19', NULL, NULL, '2021-08-19', '2021-08-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (695, '277', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-20', NULL, NULL, '2021-08-20', '2021-08-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (696, '184', '天津中医药大学第一附属医院', NULL, '天津中医药大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-23', NULL, NULL, '2021-08-23', '2021-08-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (697, '277', '延边大学附属医院', '01', '延边大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-24', NULL, NULL, '2021-08-24', '2021-08-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (698, '184', '心身科', NULL, '心身科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-24', NULL, NULL, '2021-08-24', '2021-08-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (699, '249', '连云港市第一人民医院', NULL, '连云港市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-26', NULL, NULL, '2021-08-26', '2021-08-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (700, '80', '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, '南京医科大学第一附属医院 （原江苏省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-26', NULL, NULL, '2021-08-26', '2021-08-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (702, '276', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-08-31', NULL, NULL, '2021-08-31', '2021-08-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (703, '291', '脑病科', NULL, '脑病科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-02', NULL, NULL, '2021-09-02', '2021-09-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (704, '277', '湖南中医药大学第二附属医院', NULL, '湖南中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-04', NULL, NULL, '2021-09-04', '2021-09-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (705, '277', '脑病科', NULL, '脑病科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-06', NULL, NULL, '2021-09-06', '2021-09-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (706, '276', '武汉市传染病医院', NULL, '武汉市传染病医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-07', NULL, NULL, '2021-09-07', '2021-09-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (707, '73', '青岛市中医医院', '12', '青岛市中医医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2021-09-08', NULL, NULL, '2021-09-08', '2021-09-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (708, '291', '湖南中医药大学第二附属医院', NULL, '湖南中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-08', NULL, NULL, '2021-09-08', '2021-09-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (709, '235', '河南省中医药研究院附属医院', '05', '河南省中医药研究院附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-14', NULL, NULL, '2021-09-14', '2021-09-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (710, '276', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-17', NULL, NULL, '2021-09-17', '2021-09-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (711, '291', '延边大学附属医院', NULL, '延边大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-17', NULL, NULL, '2021-09-17', '2021-09-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (712, '276', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-17', NULL, NULL, '2021-09-17', '2021-09-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (713, '235', '长春中医药大附属医院', '13', '长春中医药大附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-09-28', NULL, NULL, '2021-09-28', '2021-09-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (714, '185', '包头医学院第二附属医院', NULL, '包头医学院第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-10-08', NULL, NULL, '2021-10-08', '2021-10-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (715, '235', '保定市第一中医院', NULL, '保定市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-10-09', NULL, NULL, '2021-10-09', '2021-10-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (716, '185', '黑龙江中医药大学附属第二医院', NULL, '黑龙江中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-10-09', NULL, NULL, '2021-10-09', '2021-10-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (717, '249', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-10-09', NULL, NULL, '2021-10-09', '2021-10-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (718, '249', '风湿科', NULL, '风湿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-10-21', NULL, NULL, '2021-10-21', '2021-10-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (719, '73', '北京大学第三医院', NULL, '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-11-03', NULL, NULL, '2021-11-03', '2021-11-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (720, '184', '北京大学第一医院', NULL, '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-11-18', NULL, NULL, '2021-11-18', '2021-11-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (722, '140', '北京大学第一医院', NULL, '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-11-22', NULL, NULL, '2021-11-22', '2021-11-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (723, '184', '黑龙江中医药大学附属第一医院', NULL, '黑龙江中医药大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-11-24', NULL, NULL, '2021-11-24', '2021-11-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (724, '184', '盘锦辽油宝石花医院', '20', '盘锦辽油宝石花医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-11-24', NULL, NULL, '2021-11-24', '2021-11-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (725, '184', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-11-25', NULL, NULL, '2021-11-25', '2021-11-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (726, '184', '针灸科', NULL, '针灸科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-07', NULL, NULL, '2021-12-07', '2021-12-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (727, '184', '吉林大学中日联谊医院', NULL, '吉林大学中日联谊医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-08', NULL, NULL, '2021-12-08', '2021-12-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (728, '184', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-12', NULL, NULL, '2021-12-12', '2021-12-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (729, '184', '北京市平谷区医院', NULL, '北京市平谷区医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-12', NULL, NULL, '2021-12-12', '2021-12-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (730, '184', '中国医学科学院北京协和医院', NULL, '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-12', NULL, NULL, '2021-12-12', '2021-12-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (731, '185', '中国医学科学院北京协和医院', NULL, '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-12', NULL, NULL, '2021-12-12', '2021-12-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (732, '185', '眉山市人民医院', '20', '眉山市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-20', NULL, NULL, '2021-12-20', '2021-12-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (733, '184', '淄博市第一医院', '21', '淄博市第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-20', NULL, NULL, '2021-12-20', '2021-12-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (734, '318', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2021-12-27', NULL, NULL, '2021-12-27', '2021-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (735, '295', '通化市中心医院', NULL, '通化市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-01-11', NULL, NULL, '2022-01-11', '2022-01-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (736, '185', '北京大学第一医院', NULL, '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-01-12', NULL, NULL, '2022-01-12', '2022-01-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (737, '184', '北京大学第一医院', NULL, '北京大学第一医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2022-01-12', NULL, NULL, '2022-01-12', '2022-01-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (738, '304', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-01-13', NULL, NULL, '2022-01-13', '2022-01-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (739, '295', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-01-13', NULL, NULL, '2022-01-13', '2022-01-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (740, '146', '四川大学华西医院', '01', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-01-14', NULL, NULL, '2022-01-14', '2022-01-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (742, '317', '连云港市第一人民医院', NULL, '连云港市第一人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-02-10', NULL, NULL, '2022-02-10', '2022-02-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (743, '304', '延边大学附属医院', NULL, '延边大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-02-10', NULL, NULL, '2022-02-10', '2022-02-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (744, '184', '锦州医科大学附属第三医院', '22', '锦州医科大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-02-11', NULL, NULL, '2022-02-11', '2022-02-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (745, '185', '锦州医科大学附属第三医院', '22', '锦州医科大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-02-11', NULL, NULL, '2022-02-11', '2022-02-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (746, '304', '湖南中医药大学第二附属医院', NULL, '湖南中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-02-28', NULL, NULL, '2022-02-28', '2022-02-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (747, '184', '南阳市第二人民医院', '24', '南阳市第二人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-02-28', NULL, NULL, '2022-02-28', '2022-02-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (748, '185', '辽宁中医药大学附属第二医院', '21', '辽宁中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-07', NULL, NULL, '2022-03-07', '2022-03-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (749, '185', '沈阳医学院附属中心医院', '23', '沈阳医学院附属中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-14', NULL, NULL, '2022-03-14', '2022-03-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (750, '316', '通化市中心医院', NULL, '通化市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-22', NULL, NULL, '2022-03-22', '2022-03-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (751, '332', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-23', NULL, NULL, '2022-03-23', '2022-03-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (752, '328', '武汉市第三医院', NULL, '武汉市第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-23', NULL, NULL, '2022-03-23', '2022-03-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (753, '308', '河南大学淮河医院', NULL, '河南大学淮河医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-23', NULL, NULL, '2022-03-23', '2022-03-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (754, '300', '新乡医学院第三附属医院', NULL, '新乡医学院第三附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (755, '293', '复旦大学附属中山医院', NULL, '复旦大学附属中山医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (756, '263', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (757, '294', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (758, '320', '华中科技大学同济医学院附属协和医院', NULL, '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (759, '320', '湖北省肿瘤医院', NULL, '湖北省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (760, '241', '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', NULL, '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (762, '228', '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', NULL, '辽宁省肿瘤医院(大连医科大学临床肿瘤学院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (763, '227', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-24', NULL, NULL, '2022-03-24', '2022-03-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (764, '295', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-25', NULL, NULL, '2022-03-25', '2022-03-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (765, '316', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-25', NULL, NULL, '2022-03-25', '2022-03-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (766, '289', '河南省人民医院', NULL, '河南省人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-28', NULL, NULL, '2022-03-28', '2022-03-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (767, '177', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-28', NULL, NULL, '2022-03-28', '2022-03-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (768, '158', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-28', NULL, NULL, '2022-03-28', '2022-03-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (769, '152', '武汉大学中南医院', NULL, '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-28', NULL, NULL, '2022-03-28', '2022-03-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (770, '122', '河南大学淮河医院', NULL, '河南大学淮河医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-28', NULL, NULL, '2022-03-28', '2022-03-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (771, '294', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-03-31', NULL, NULL, '2022-03-31', '2022-03-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (772, '292', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-04-06', NULL, NULL, '2022-04-06', '2022-04-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (773, '0', '首都医科大学附属北京安贞医院', NULL, '首都医科大学附属北京安贞医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-04-06', NULL, NULL, '2022-04-06', '2022-04-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (774, '184', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-04-13', NULL, NULL, '2022-04-13', '2022-04-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (775, '294', '首都医科大学附属北京同仁医院', NULL, '首都医科大学附属北京同仁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-04-20', NULL, NULL, '2022-04-20', '2022-04-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (776, '294', '中国医学科学院北京协和医院', NULL, '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-04-20', NULL, NULL, '2022-04-20', '2022-04-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (777, '185', '北京中医药大学东方医院', NULL, '北京中医药大学东方医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-05-10', NULL, NULL, '2022-05-10', '2022-05-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (778, '185', '平煤神马医疗集团总医院', '25', '平煤神马医疗集团总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-05-30', NULL, NULL, '2022-05-30', '2022-05-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (779, '282', NULL, NULL, NULL, NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2022-06-02', NULL, NULL, '2022-06-02', '2022-06-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (780, '282', NULL, NULL, NULL, NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2022-06-02', NULL, NULL, '2022-06-02', '2022-06-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (782, '282', NULL, NULL, NULL, NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2022-06-02', NULL, NULL, '2022-06-02', '2022-06-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (783, '282', '北京大学第三医院', '01', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-06', NULL, NULL, '2022-06-06', '2022-06-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (784, '282', '首都医科大学附属北京朝阳医院', '02', '首都医科大学附属北京朝阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-06', NULL, NULL, '2022-06-06', '2022-06-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (785, '282', '中日友好医院', '03', '中日友好医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-06', NULL, NULL, '2022-06-06', '2022-06-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (786, '282', '武汉大学人民医院（湖北省人民医院）', '04', '武汉大学人民医院（湖北省人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-06', NULL, NULL, '2022-06-06', '2022-06-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (787, '282', '衢州市人民医院', '05', '衢州市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-06', NULL, NULL, '2022-06-06', '2022-06-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (788, '317', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-20', NULL, NULL, '2022-06-20', '2022-06-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (789, '185', '内蒙古科技大学包头医学院第一附属医院', NULL, '内蒙古科技大学包头医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-21', NULL, NULL, '2022-06-21', '2022-06-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (790, '185', '北京中医药大学东直门医院', NULL, '北京中医药大学东直门医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-21', NULL, NULL, '2022-06-21', '2022-06-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (791, '185', '内蒙古科技大学包头医学院第一附属医院', NULL, '内蒙古科技大学包头医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-06-28', NULL, NULL, '2022-06-28', '2022-06-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (792, '354', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-07-24', NULL, NULL, '2022-07-24', '2022-07-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (793, '185', '本溪市铁路医院', NULL, '本溪市铁路医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-08-01', NULL, NULL, '2022-08-01', '2022-08-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (794, '317', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-08-31', NULL, NULL, '2022-08-31', '2022-08-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (795, '295', '延边大学附属医院', NULL, '延边大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-09-22', NULL, NULL, '2022-09-22', '2022-09-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (796, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-10-24', NULL, NULL, '2022-10-24', '2022-10-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (797, '295', '湖南中医药大学第二附属医院', NULL, '湖南中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-11-14', NULL, NULL, '2022-11-14', '2022-11-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (798, '330', '通化市中心医院', NULL, '通化市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-11-15', NULL, NULL, '2022-11-15', '2022-11-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (799, '330', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2022-11-17', NULL, NULL, '2022-11-17', '2022-11-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (800, '282', '大连医科大学附属第一医院', NULL, '大连医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-01-03', NULL, NULL, '2023-01-03', '2023-01-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (802, '437', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-01-30', NULL, NULL, '2023-01-30', '2023-01-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (803, '439', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (804, '439', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (805, '434', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (806, '416', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (807, '391', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (808, '419', '湖南省儿童医院', NULL, '湖南省儿童医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (809, '414', '中南大学湘雅医院', NULL, '中南大学湘雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (810, '381', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (811, '361', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (812, '356', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (813, '353', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (814, '352', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-02', NULL, NULL, '2023-02-02', '2023-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (815, '320', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-07', NULL, NULL, '2023-02-07', '2023-02-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (816, '272', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-07', NULL, NULL, '2023-02-07', '2023-02-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (817, '225', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-08', NULL, NULL, '2023-02-08', '2023-02-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (818, '192', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-08', NULL, NULL, '2023-02-08', '2023-02-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (819, '176', '湖南省肿瘤医院', NULL, '湖南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-08', NULL, NULL, '2023-02-08', '2023-02-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (820, '294', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-02-13', NULL, NULL, '2023-02-13', '2023-02-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (822, '330', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-06', NULL, NULL, '2023-04-06', '2023-04-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (823, '467', '天津医科大学总医院', NULL, '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-11', NULL, NULL, '2023-04-11', '2023-04-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (824, '536', '河北以岭医院（Ⅰ期病房）', '01', '河北以岭医院（Ⅰ期病房）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-14', NULL, NULL, '2023-04-14', '2023-04-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (825, '504', '邢台医学高等专科学校第二附属医院', '01', '邢台医学高等专科学校第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-16', NULL, NULL, '2023-04-16', '2023-04-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (826, '504', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-16', NULL, NULL, '2023-04-16', '2023-04-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (827, '344', '首都医科大学附属北京友谊医院', '01', '首都医科大学附属北京友谊医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (828, '344', '天津医科大学总医院', '04', '天津医科大学总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (829, '344', '中国医科大学附属盛京医院', '05', '中国医科大学附属盛京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (830, '344', '山东大学齐鲁医院', '17', '山东大学齐鲁医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (831, '339', '鄂州市中心医院', NULL, '鄂州市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (832, '339', '蚌埠医学院第一附属医院', NULL, '蚌埠医学院第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (833, '339', '湖北省妇幼保健院', NULL, '湖北省妇幼保健院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (834, '344', '复旦大学附属中山医院', '19', '复旦大学附属中山医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (835, '339', '湖南省儿童医院', NULL, '湖南省儿童医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (836, '339', '安徽医科大学第二附属医院/儿科', NULL, '安徽医科大学第二附属医院/儿科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (837, '339', '首都医科大学附属北京儿童医院/呼吸科', NULL, '首都医科大学附属北京儿童医院/呼吸科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (838, '366', '广东省第二人民医院', NULL, '广东省第二人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (839, '366', '北京大学第三医院', '02', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (840, '366', '浙江医院/美容科', NULL, '浙江医院/美容科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-21', NULL, NULL, '2023-04-21', '2023-04-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (842, '344', '郑州大学第一附属医院', '07', '郑州大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-23', NULL, NULL, '2023-04-23', '2023-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (843, '344', '华中科技大学同济医学院附属协和医院', '10', '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-23', NULL, NULL, '2023-04-23', '2023-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (844, '344', '浙江大学医学院附属第一医院', '14', '浙江大学医学院附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-23', NULL, NULL, '2023-04-23', '2023-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (845, '344', '福建医科大学附属第一医院', '09', '福建医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-23', NULL, NULL, '2023-04-23', '2023-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (846, '344', '中南大学湘雅医院', '03', '中南大学湘雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-23', NULL, NULL, '2023-04-23', '2023-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (847, '344', '南昌大学第一附属医院', '15', '南昌大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-23', NULL, NULL, '2023-04-23', '2023-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (848, '344', '北京大学第三医院', '02', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-23', NULL, NULL, '2023-04-23', '2023-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (849, '344', '四川省人民医院（四川省医学科学院）', '08', '四川省人民医院（四川省医学科学院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-25', NULL, NULL, '2023-04-25', '2023-04-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (850, '344', '中国医科大学附属盛京医院', '20', '中国医科大学附属盛京医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-26', NULL, NULL, '2023-04-26', '2023-04-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (851, '344', '重庆市人民医院/消化科', '12', '重庆市人民医院/消化科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-04-26', NULL, NULL, '2023-04-26', '2023-04-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (852, '344', '重庆市人民医院/消化科', '12', '重庆市人民医院/消化科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2023-04-26', NULL, NULL, '2023-04-26', '2023-04-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (853, '535', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-05-04', NULL, NULL, '2023-05-04', '2023-05-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (854, '535', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-05-04', NULL, NULL, '2023-05-04', '2023-05-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (855, '282', '河北中石油中心医院', '06', '河北中石油中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-05-06', NULL, NULL, '2023-05-06', '2023-05-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (856, '535', '萍乡市人民医院', NULL, '萍乡市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-05-08', NULL, NULL, '2023-05-08', '2023-05-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (857, '421', '黑龙江中医药大学附属第二医院', '01', '黑龙江中医药大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-05-08', NULL, NULL, '2023-05-08', '2023-05-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (858, '305', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-05-12', NULL, NULL, '2023-05-12', '2023-05-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (859, '535', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-06-05', NULL, NULL, '2023-06-05', '2023-06-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (860, '421', '天津市第五中心医院', '03', '天津市第五中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-06-08', NULL, NULL, '2023-06-08', '2023-06-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (862, '433', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-06-09', NULL, NULL, '2023-06-09', '2023-06-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (863, '535', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-06-21', NULL, NULL, '2023-06-21', '2023-06-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (864, '580', '武汉市精神卫生中心', NULL, '武汉市精神卫生中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-18', NULL, NULL, '2023-07-18', '2023-07-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (865, '580', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-18', NULL, NULL, '2023-07-18', '2023-07-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (866, '580', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-18', NULL, NULL, '2023-07-18', '2023-07-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (867, '580', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-18', NULL, NULL, '2023-07-18', '2023-07-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (868, '421', '河南大学淮河医院', '04', '河南大学淮河医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-18', NULL, NULL, '2023-07-18', '2023-07-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (869, '184', '复旦大学附属华东医院', NULL, '复旦大学附属华东医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-21', NULL, NULL, '2023-07-21', '2023-07-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (870, '536', '洛阳市中心医院', '01', '洛阳市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-25', NULL, NULL, '2023-07-25', '2023-07-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (871, '421', '广州医科大学附属中医医院', '02', '广州医科大学附属中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-25', NULL, NULL, '2023-07-25', '2023-07-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (872, '185', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-26', NULL, NULL, '2023-07-26', '2023-07-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (873, '536', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-26', NULL, NULL, '2023-07-26', '2023-07-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (874, '344', '包头医学院第二附属医院', NULL, '包头医学院第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-07-31', NULL, NULL, '2023-07-31', '2023-07-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (875, '459', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-08-02', NULL, NULL, '2023-08-02', '2023-08-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (876, '556', '浙江大学医学院附属第一医院骨髓移植中心', '01', '浙江大学医学院附属第一医院骨髓移植中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-08-17', NULL, NULL, '2023-08-17', '2023-08-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (877, '556', '郑州大学第一附属医院', '03', '郑州大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-08-17', NULL, NULL, '2023-08-17', '2023-08-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (878, '421', '河南大学第一附属医院', '05', '河南大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-08-23', NULL, NULL, '2023-08-23', '2023-08-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (879, '536', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-08-25', NULL, NULL, '2023-08-25', '2023-08-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (880, '459', '北京大学第一医院', NULL, '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-08-31', NULL, NULL, '2023-08-31', '2023-08-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (882, '536', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-09-12', NULL, NULL, '2023-09-12', '2023-09-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (883, '0', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-09-12', NULL, NULL, '2023-09-12', '2023-09-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (884, '0', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-09-12', NULL, NULL, '2023-09-12', '2023-09-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (885, '459', '广西中医药大学第一附属医院（广西中医药大学第一临床医学院、广西中医医院）', NULL, '广西中医药大学第一附属医院（广西中医药大学第一临床医学院、广西中医医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-09-21', NULL, NULL, '2023-09-21', '2023-09-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (886, '421', '石家庄市中医院', '06', '石家庄市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-12', NULL, NULL, '2023-10-12', '2023-10-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (887, '421', '青岛市第三人民医院', '07', '青岛市第三人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-17', NULL, NULL, '2023-10-17', '2023-10-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (888, '599', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-18', NULL, NULL, '2023-10-18', '2023-10-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (889, '590', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-18', NULL, NULL, '2023-10-18', '2023-10-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (890, '590', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-18', NULL, NULL, '2023-10-18', '2023-10-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (891, '590', '武汉市精神卫生中心', '01', '武汉市精神卫生中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-18', NULL, NULL, '2023-10-18', '2023-10-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (892, '504', '河南（郑州）中汇心血管病医院', '01', '河南（郑州）中汇心血管病医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-19', NULL, NULL, '2023-10-19', '2023-10-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (893, '344', '黑龙江省医院', '22', '黑龙江省医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-23', NULL, NULL, '2023-10-23', '2023-10-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (894, '344', '滨州医学院附属医院', '27', '滨州医学院附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-23', NULL, NULL, '2023-10-23', '2023-10-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (895, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-23', NULL, NULL, '2023-10-23', '2023-10-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (896, '504', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-23', NULL, NULL, '2023-10-23', '2023-10-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (897, '344', '广州医科大学附属第二医院', NULL, '广州医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-24', NULL, NULL, '2023-10-24', '2023-10-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (898, '421', '华北医疗健康集团峰峰总医院', '08', '华北医疗健康集团峰峰总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-10-25', NULL, NULL, '2023-10-25', '2023-10-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (899, '590', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-01', NULL, NULL, '2023-11-01', '2023-11-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (900, '459', '肾内科', NULL, '肾内科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-09', NULL, NULL, '2023-11-09', '2023-11-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (902, '599', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-17', NULL, NULL, '2023-11-17', '2023-11-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (903, '599', '武汉市精神卫生中心', '01', '武汉市精神卫生中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-20', NULL, NULL, '2023-11-20', '2023-11-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (904, '599', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-20', NULL, NULL, '2023-11-20', '2023-11-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (905, '605', '广州市花都区人民医院', '04', '广州市花都区人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-24', NULL, NULL, '2023-11-24', '2023-11-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (906, '605', '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', '03', '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-24', NULL, NULL, '2023-11-24', '2023-11-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (907, '569', '中国医学科学院北京协和医院', '01', '中国医学科学院北京协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (908, '605', '昆明市儿童医院', NULL, '昆明市儿童医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (909, '605', '国立台湾大学医学院', NULL, '国立台湾大学医学院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (910, '605', '广州医科大学附属肿瘤医院（广州市肿瘤医院）', NULL, '广州医科大学附属肿瘤医院（广州市肿瘤医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (911, '605', '广州医科大学附属肿瘤医院（广州市肿瘤医院）', NULL, '广州医科大学附属肿瘤医院（广州市肿瘤医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (912, '605', '江门市妇幼保健院', NULL, '江门市妇幼保健院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (913, '605', '珠海市妇幼保健院', NULL, '珠海市妇幼保健院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (914, '344', '河南科技大学第一附属医院', '25', '河南科技大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-29', NULL, NULL, '2023-11-29', '2023-11-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (915, '605', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-30', NULL, NULL, '2023-11-30', '2023-11-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (916, '569', '河北北方学院附属第一医院', NULL, '河北北方学院附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-30', NULL, NULL, '2023-11-30', '2023-11-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (917, '459', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-30', NULL, NULL, '2023-11-30', '2023-11-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (918, '344', '宁波大学附属第一医院', '26', '宁波大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-11-30', NULL, NULL, '2023-11-30', '2023-11-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (919, '344', '西安交通大学第一附属医院', NULL, '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-04', NULL, NULL, '2023-12-04', '2023-12-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (920, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-04', NULL, NULL, '2023-12-04', '2023-12-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (922, '421', '迁安市中医医院', '09', '迁安市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-08', NULL, NULL, '2023-12-08', '2023-12-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (923, '605', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-11', NULL, NULL, '2023-12-11', '2023-12-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (924, '339', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-11', NULL, NULL, '2023-12-11', '2023-12-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (925, '344', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-12', NULL, NULL, '2023-12-12', '2023-12-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (926, '569', '湖南康雅医院', NULL, '湖南康雅医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-14', NULL, NULL, '2023-12-14', '2023-12-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (927, '344', '红兴隆中心医院', NULL, '红兴隆中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-14', NULL, NULL, '2023-12-14', '2023-12-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (928, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-14', NULL, NULL, '2023-12-14', '2023-12-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (929, '599', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-15', NULL, NULL, '2023-12-15', '2023-12-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (930, '366', '北京大学第三医院', '02', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-22', NULL, NULL, '2023-12-22', '2023-12-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (931, '597', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-22', NULL, NULL, '2023-12-22', '2023-12-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (932, '366', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-25', NULL, NULL, '2023-12-25', '2023-12-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (933, '344', '安徽医科大学附属第二医院', '23', '安徽医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2023-12-28', NULL, NULL, '2023-12-28', '2023-12-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (934, '624', '武汉市精神卫生中心', '01', '武汉市精神卫生中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-02', NULL, NULL, '2024-01-02', '2024-01-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (935, '344', '首都医科大学附属北京潞河医院', '24', '首都医科大学附属北京潞河医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-03', NULL, NULL, '2024-01-03', '2024-01-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (936, '344', '赤峰市医院', '29', '赤峰市医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-03', NULL, NULL, '2024-01-03', '2024-01-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (937, '421', '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', NULL, '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-08', NULL, NULL, '2024-01-08', '2024-01-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (938, '599', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-08', NULL, NULL, '2024-01-08', '2024-01-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (939, '605', '湖南省儿童医院/感染科', NULL, '湖南省儿童医院/感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-09', NULL, NULL, '2024-01-09', '2024-01-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (940, '601', '石家庄市中医院', '06', '石家庄市中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-29', NULL, NULL, '2024-01-29', '2024-01-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (942, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-29', NULL, NULL, '2024-01-29', '2024-01-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (943, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-29', NULL, NULL, '2024-01-29', '2024-01-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (944, '344', '天津市蓟县人民医院', NULL, '天津市蓟县人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-29', NULL, NULL, '2024-01-29', '2024-01-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (945, '344', '黑龙江中医药大学附属第一医院', NULL, '黑龙江中医药大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-29', NULL, NULL, '2024-01-29', '2024-01-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (946, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-29', NULL, NULL, '2024-01-29', '2024-01-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (947, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-30', NULL, NULL, '2024-01-30', '2024-01-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (948, '344', '开滦总医院', NULL, '开滦总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-30', NULL, NULL, '2024-01-30', '2024-01-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (949, '344', '昆明市第一人民医院(昆明医科大学附属甘美医院)', NULL, '昆明市第一人民医院(昆明医科大学附属甘美医院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-30', NULL, NULL, '2024-01-30', '2024-01-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (950, '344', '昆明市第一人民医院(昆明医科大学附属甘美医院)', NULL, '昆明市第一人民医院(昆明医科大学附属甘美医院)', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-30', NULL, NULL, '2024-01-30', '2024-01-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (951, '624', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-01-31', NULL, NULL, '2024-01-31', '2024-01-31');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (952, '601', '昆明医科大学第二附属医院', NULL, '昆明医科大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-02', NULL, NULL, '2024-02-02', '2024-02-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (953, '605', '昆明市儿童医院', '02', '昆明市儿童医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-06', NULL, NULL, '2024-02-06', '2024-02-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (954, '601', '山西省汾阳医院', '02', '山西省汾阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (955, '601', '中国中医科学院西苑医院', '01', '中国中医科学院西苑医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (956, '601', '阳泉煤业（集团）有限责任公司总医院', '03', '阳泉煤业（集团）有限责任公司总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (957, '601', '华北医疗健康集团峰峰总医院', '04', '华北医疗健康集团峰峰总医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (958, '601', '保定市第一中医院', '05', '保定市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (959, '601', '鄂州市中心医院', '07', '鄂州市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (960, '601', '武汉市中医医院', '08', '武汉市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (962, '601', '华北理工大学附属医院', '10', '华北理工大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (963, '601', '泰安市中医医院', '11', '泰安市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (964, '601', '山东省立第三医院', '12', '山东省立第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (965, '601', '九江市第三人民医院', '13', '九江市第三人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (966, '601', '北京中医药大学东直门医院洛阳医院', '14', '北京中医药大学东直门医院洛阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (967, '601', '眉山市人民医院', '16', '眉山市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (968, '601', '常州市中医医院', '17', '常州市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (969, '601', '河北省沧州中西医结合医院', '19', '河北省沧州中西医结合医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (970, '601', '涿州市医院', '20', '涿州市医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-19', NULL, NULL, '2024-02-19', '2024-02-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (971, '601', '风湿免疫科', NULL, '风湿免疫科', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2024-02-20', NULL, NULL, '2024-02-20', '2024-02-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (972, '601', '红兴隆中心医院', NULL, '红兴隆中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-20', NULL, NULL, '2024-02-20', '2024-02-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (973, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-20', NULL, NULL, '2024-02-20', '2024-02-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (974, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-20', NULL, NULL, '2024-02-20', '2024-02-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (975, '624', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-28', NULL, NULL, '2024-02-28', '2024-02-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (976, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-02-28', NULL, NULL, '2024-02-28', '2024-02-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (977, '624', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-03-18', NULL, NULL, '2024-03-18', '2024-03-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (978, '344', '洛阳市第一中医院', NULL, '洛阳市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-03-20', NULL, NULL, '2024-03-20', '2024-03-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (979, '624', '洛阳市第一中医院', NULL, '洛阳市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-03-20', NULL, NULL, '2024-03-20', '2024-03-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (980, '556', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-03-21', NULL, NULL, '2024-03-21', '2024-03-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (982, '601', '南昌第六医院', NULL, '南昌第六医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-07', NULL, NULL, '2024-04-07', '2024-04-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (983, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-07', NULL, NULL, '2024-04-07', '2024-04-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (984, '556', '华中科技大学同济医学院附属协和医院', '06', '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-09', NULL, NULL, '2024-04-09', '2024-04-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (985, '556', '中国中医科学院血液病医院', '02', '中国中医科学院血液病医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-10', NULL, NULL, '2024-04-10', '2024-04-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (986, '556', '安徽省公共卫生临床中心', '05', '安徽省公共卫生临床中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-10', NULL, NULL, '2024-04-10', '2024-04-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (987, '556', '青岛大学附属医院', '04', '青岛大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-10', NULL, NULL, '2024-04-10', '2024-04-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (988, '556', '海南省肿瘤医院', NULL, '海南省肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-10', NULL, NULL, '2024-04-10', '2024-04-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (989, '640', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-18', NULL, NULL, '2024-04-18', '2024-04-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (990, '660', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-18', NULL, NULL, '2024-04-18', '2024-04-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (991, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-22', NULL, NULL, '2024-04-22', '2024-04-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (992, '660', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-23', NULL, NULL, '2024-04-23', '2024-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (993, '660', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-23', NULL, NULL, '2024-04-23', '2024-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (994, '601', '秦皇岛市中医医院', '18', '秦皇岛市中医医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-04-23', NULL, NULL, '2024-04-23', '2024-04-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (995, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-05-07', NULL, NULL, '2024-05-07', '2024-05-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (996, '536', '洛阳市第一中医院', NULL, '洛阳市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-05-08', NULL, NULL, '2024-05-08', '2024-05-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (997, '599', '洛阳市第一中医院', NULL, '洛阳市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-05-08', NULL, NULL, '2024-05-08', '2024-05-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (998, '660', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-05-29', NULL, NULL, '2024-05-29', '2024-05-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (999, '471', '武汉市第三医院', NULL, '武汉市第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-06-06', NULL, NULL, '2024-06-06', '2024-06-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1000, '471', '华中科技大学同济医学院附属协和医院', '01', '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-06-11', NULL, NULL, '2024-06-11', '2024-06-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1002, '660', '武汉市精神卫生中心', '01', '武汉市精神卫生中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-06-11', NULL, NULL, '2024-06-11', '2024-06-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1003, '660', '山西省心血管病医院（山西省心血管病研究所）', NULL, '山西省心血管病医院（山西省心血管病研究所）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-06-12', NULL, NULL, '2024-06-12', '2024-06-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1004, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-06-21', NULL, NULL, '2024-06-21', '2024-06-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1005, '601', '江西中医药大学附属医院', '15', '江西中医药大学附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-06-25', NULL, NULL, '2024-06-25', '2024-06-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1006, '660', '洛阳市第一中医院', NULL, '洛阳市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-07-05', NULL, NULL, '2024-07-05', '2024-07-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1007, '640', '洛阳市第一中医院', NULL, '洛阳市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-07-05', NULL, NULL, '2024-07-05', '2024-07-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1008, '601', '风湿免疫科', NULL, '风湿免疫科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-07-15', NULL, NULL, '2024-07-15', '2024-07-15');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1009, '459', '汕头大学医学院第二附属医院', NULL, '汕头大学医学院第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-07-16', NULL, NULL, '2024-07-16', '2024-07-16');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1010, '682', '树兰（杭州）医院', NULL, '树兰（杭州）医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-07-25', NULL, NULL, '2024-07-25', '2024-07-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1011, '471', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-07-26', NULL, NULL, '2024-07-26', '2024-07-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1012, '706', '山西省心血管病医院（山西省心血管病研究所）', NULL, '山西省心血管病医院（山西省心血管病研究所）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-08-22', NULL, NULL, '2024-08-22', '2024-08-22');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1013, '706', '武汉市精神卫生中心', NULL, '武汉市精神卫生中心', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-08-27', NULL, NULL, '2024-08-27', '2024-08-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1014, '706', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-05', NULL, NULL, '2024-09-05', '2024-09-05');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1015, '706', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-06', NULL, NULL, '2024-09-06', '2024-09-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1016, '601', '南昌第六医院', NULL, '南昌第六医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-10', NULL, NULL, '2024-09-10', '2024-09-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1017, '682', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-11', NULL, NULL, '2024-09-11', '2024-09-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1018, '598', '上海闵行区中心医院', NULL, '上海闵行区中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-14', NULL, NULL, '2024-09-14', '2024-09-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1019, '598', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-14', NULL, NULL, '2024-09-14', '2024-09-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1020, '626', '浙江大学医学院附属邵逸夫医院', '01', '浙江大学医学院附属邵逸夫医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1022, '626', '北京大学第一医院', '03', '北京大学第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1023, '626', '福建医科大学附属第一医院', '05', '福建医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1024, '626', '二龙路医院（北京市肛肠医院）', '04', '二龙路医院（北京市肛肠医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1025, '626', '江苏省中医院', '06', '江苏省中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1026, '626', '中山大学附属第六医院', '07', '中山大学附属第六医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1027, '626', '南昌大学第二附属医院', '08', '南昌大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1028, '626', '南方医科大学深圳医院', '09', '南方医科大学深圳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1029, '626', '南京鼓楼医院（南京大学医学院附属鼓楼医院）', '10', '南京鼓楼医院（南京大学医学院附属鼓楼医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1030, '626', '四川大学华西医院', '11', '四川大学华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1031, '626', '上海中医药大学附属龙华医院', '12', '上海中医药大学附属龙华医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1032, '626', '武汉大学中南医院', '13', '武汉大学中南医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1033, '626', '郑州大学第二附属医院', '14', '郑州大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1034, '626', '中国医科大学附属第一医院', '15', '中国医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1035, '626', '浙江大学医学院附属第二医院', '16', '浙江大学医学院附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1036, '626', '中南大学湘雅二医院', '17', '中南大学湘雅二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1037, '626', '宁波大学附属第一医院', '18', '宁波大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1038, '626', '温州医科大学附属第二医院', '19', '温州医科大学附属第二医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-18', NULL, NULL, '2024-09-18', '2024-09-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1039, '682', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-19', NULL, NULL, '2024-09-19', '2024-09-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1040, '641', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-20', NULL, NULL, '2024-09-20', '2024-09-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1042, '598', '上海市第一人民医院 （上海交通大学附属第一人民医院）', NULL, '上海市第一人民医院 （上海交通大学附属第一人民医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-26', NULL, NULL, '2024-09-26', '2024-09-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1043, '638', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-26', NULL, NULL, '2024-09-26', '2024-09-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1044, '626', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-26', NULL, NULL, '2024-09-26', '2024-09-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1045, '598', '北京大学第三医院', '02', '北京大学第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-26', NULL, NULL, '2024-09-26', '2024-09-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1046, '626', '麻醉科', NULL, '麻醉科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-26', NULL, NULL, '2024-09-26', '2024-09-26');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1047, '598', '上海交通大学医学院附属第九人民医院', '01', '上海交通大学医学院附属第九人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-27', NULL, NULL, '2024-09-27', '2024-09-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1048, '598', '华中科技大学同济医学院附属协和医院', '05', '华中科技大学同济医学院附属协和医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-09-29', NULL, NULL, '2024-09-29', '2024-09-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1049, '598', '浙江省人民医院1', '08', '浙江省人民医院1', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-08', NULL, NULL, '2024-10-08', '2024-10-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1050, '598', '延安大学咸阳医院', '10', '延安大学咸阳医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-08', NULL, NULL, '2024-10-08', '2024-10-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1051, '721', '北京大学肿瘤医院', '01', '北京大学肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-11', NULL, NULL, '2024-10-11', '2024-10-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1052, '641', '绵阳市中心医院', NULL, '绵阳市中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-12', NULL, NULL, '2024-10-12', '2024-10-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1053, '598', '北京大学深圳医院2', '09', '北京大学深圳医院2', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-17', NULL, NULL, '2024-10-17', '2024-10-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1054, '598', '复旦大学附属华山医院1', '04', '复旦大学附属华山医院1', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-17', NULL, NULL, '2024-10-17', '2024-10-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1055, '598', '武汉市第三医院', '06', '武汉市第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-17', NULL, NULL, '2024-10-17', '2024-10-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1056, '598', '延安大学咸阳医院', '10', '延安大学咸阳医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2024-10-17', NULL, NULL, '2024-10-17', '2024-10-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1057, '598', '天津市人民医院', NULL, '天津市人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-25', NULL, NULL, '2024-10-25', '2024-10-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1058, '598', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-10-29', NULL, NULL, '2024-10-29', '2024-10-29');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1059, '598', '西安交通大学第二附属医院（西北医院）', '07', '西安交通大学第二附属医院（西北医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-01', NULL, NULL, '2024-11-01', '2024-11-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1060, '598', '中山大学附属第三医院', '03', '中山大学附属第三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-01', NULL, NULL, '2024-11-01', '2024-11-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1062, '598', '上海中医药大学附属龙华医院', NULL, '上海中医药大学附属龙华医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-06', NULL, NULL, '2024-11-06', '2024-11-06');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1063, '708', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-08', NULL, NULL, '2024-11-08', '2024-11-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1064, '708', '浙江医院/美容科', NULL, '浙江医院/美容科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-10', NULL, NULL, '2024-11-10', '2024-11-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1065, '707', '西安交通大学第一附属医院', NULL, '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-11', NULL, NULL, '2024-11-11', '2024-11-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1066, '598', '深圳市孙逸仙心血管医院', NULL, '深圳市孙逸仙心血管医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-13', NULL, NULL, '2024-11-13', '2024-11-13');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1067, '708', '重庆星荣整形外科医院', NULL, '重庆星荣整形外科医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-14', NULL, NULL, '2024-11-14', '2024-11-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1068, '708', '重庆星荣整形外科医院', NULL, '重庆星荣整形外科医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-14', NULL, NULL, '2024-11-14', '2024-11-14');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1069, '707', '感染科', NULL, '感染科', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-18', NULL, NULL, '2024-11-18', '2024-11-18');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1070, '682', '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, '中国人民解放军北部战区总医院 （原沈阳军区总医院、解放军第202医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-19', NULL, NULL, '2024-11-19', '2024-11-19');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1071, '598', '西安交通大学第一附属医院', NULL, '西安交通大学第一附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-20', NULL, NULL, '2024-11-20', '2024-11-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1072, '708', '红兴隆中心医院', NULL, '红兴隆中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-21', NULL, NULL, '2024-11-21', '2024-11-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1073, '708', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-21', NULL, NULL, '2024-11-21', '2024-11-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1074, '708', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-27', NULL, NULL, '2024-11-27', '2024-11-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1075, '708', '郑州人民医院', NULL, '郑州人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-28', NULL, NULL, '2024-11-28', '2024-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1076, '708', '北京潞河医院', '02', '北京潞河医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-28', NULL, NULL, '2024-11-28', '2024-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1077, '708', '北京大学深圳医院2', NULL, '北京大学深圳医院2', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-28', NULL, NULL, '2024-11-28', '2024-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1078, '598', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-11-28', NULL, NULL, '2024-11-28', '2024-11-28');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1079, '598', '山西医学科学院（山西大医院）', NULL, '山西医学科学院（山西大医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-02', NULL, NULL, '2024-12-02', '2024-12-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1080, '626', '四川大学附属华西医院', NULL, '四川大学附属华西医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-03', NULL, NULL, '2024-12-03', '2024-12-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1082, '626', '常州市第二人民医院', '20', '常州市第二人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-10', NULL, NULL, '2024-12-10', '2024-12-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1083, '626', '湖南中医药高等专科学校附属第一医院（湖南省直中医医院）', '21', '湖南中医药高等专科学校附属第一医院（湖南省直中医医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-10', NULL, NULL, '2024-12-10', '2024-12-10');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1084, '708', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-11', NULL, NULL, '2024-12-11', '2024-12-11');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1085, '556', '红兴隆中心医院', NULL, '红兴隆中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-17', NULL, NULL, '2024-12-17', '2024-12-17');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1086, '707', '中南大学湘雅三医院', NULL, '中南大学湘雅三医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-20', NULL, NULL, '2024-12-20', '2024-12-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1087, '569', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-23', NULL, NULL, '2024-12-23', '2024-12-23');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1088, '595', '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, '中国人民解放军第三〇七医院（中国人民解放军军事医学科学院附属医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-25', NULL, NULL, '2024-12-25', '2024-12-25');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1089, '707', '洛阳市第一中医院', NULL, '洛阳市第一中医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2024-12-27', NULL, NULL, '2024-12-27', '2024-12-27');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1090, '556', '红兴隆中心医院', NULL, '红兴隆中心医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-01-03', NULL, NULL, '2025-01-03', '2025-01-03');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1091, '601', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-01-07', NULL, NULL, '2025-01-07', '2025-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1092, '723', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-01-07', NULL, NULL, '2025-01-07', '2025-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1093, '598', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-01-07', NULL, NULL, '2025-01-07', '2025-01-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1094, '658', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-03-04', NULL, NULL, '2025-03-04', '2025-03-04');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1095, '601', '湛江中心人民医院', '21', '湛江中心人民医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-04-02', NULL, NULL, '2025-04-02', '2025-04-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1096, '344', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-04-02', NULL, NULL, '2025-04-02', '2025-04-02');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1097, '605', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-04-07', NULL, NULL, '2025-04-07', '2025-04-07');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1098, '626', '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', '22', '惠州市中心人民医院（中山大学广东医学院附属惠州医院）', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-04-09', NULL, NULL, '2025-04-09', '2025-04-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1099, '626', '南方医科大学顺德医院', '23', '南方医科大学顺德医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-04-09', NULL, NULL, '2025-04-09', '2025-04-09');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1100, '736', '华中科技大学同济医学院附属同济医院', NULL, '华中科技大学同济医学院附属同济医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-04-24', NULL, NULL, '2025-04-24', '2025-04-24');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1102, '649', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-07-01', NULL, NULL, '2025-07-01', '2025-07-01');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1103, '767', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-07-21', NULL, NULL, '2025-07-21', '2025-07-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1104, '764', '天津中医药大学第二附属医院', NULL, '天津中医药大学第二附属医院', NULL, NULL, 'INACTIVE', NULL, NULL, NULL, NULL, '2025-07-30', NULL, NULL, '2025-07-30', '2025-07-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1105, '764', '温州医科大学附属第一医院', NULL, '温州医科大学附属第一医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-07-30', NULL, NULL, '2025-07-30', '2025-07-30');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1106, '722', '复旦大学附属肿瘤医院', NULL, '复旦大学附属肿瘤医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-08-12', NULL, NULL, '2025-08-12', '2025-08-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1107, '721', '北京高博医院', NULL, '北京高博医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-08-12', NULL, NULL, '2025-08-12', '2025-08-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1108, '647', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20', '2025-08-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1109, '764', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20', '2025-08-20');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1110, '774', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21', '2025-08-21');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1111, '601', '山东中医药大学第二附属医院', '22', '山东中医药大学第二附属医院', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2025-09-08', NULL, NULL, '2025-09-08', '2025-09-08');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1112, '777', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2026-01-12', NULL, NULL, '2026-01-12', '2026-01-12');
INSERT INTO cr_centers (id, project_code, center_name, center_code, hospital_name, pi_name, pi_phone, status, plan_subjects, actual_subjects, dropout_count, sae_count, start_date, first_enrollment_date, close_date, created_at, updated_at)
VALUES (1113, '779', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2026-01-19', NULL, NULL, '2026-01-19', '2026-01-19');

-- ===== project_weekly_progress (14列) =====
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (1, '34', NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (2, '73', NULL, NULL, NULL, NULL, NULL, '2', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (3, '47', NULL, NULL, NULL, NULL, NULL, '3', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (4, '47', NULL, NULL, NULL, NULL, NULL, '6', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (5, '103', NULL, NULL, NULL, NULL, NULL, '23', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (6, '100', NULL, NULL, NULL, NULL, NULL, '24', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (7, '98', NULL, NULL, NULL, NULL, NULL, '26', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (8, '92', NULL, NULL, NULL, NULL, NULL, '36', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (9, '88', NULL, NULL, NULL, NULL, NULL, '40', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (10, '134', NULL, NULL, NULL, NULL, NULL, '47', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (11, '134', NULL, NULL, NULL, NULL, NULL, '48', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (12, '134', NULL, NULL, NULL, NULL, NULL, '49', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (13, '132', NULL, NULL, NULL, NULL, NULL, '50', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (14, '132', NULL, NULL, NULL, NULL, NULL, '51', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (15, '132', NULL, NULL, NULL, NULL, NULL, '52', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (16, '132', NULL, NULL, NULL, NULL, NULL, '53', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (17, '130', NULL, NULL, NULL, NULL, NULL, '54', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (18, '130', NULL, NULL, NULL, NULL, NULL, '55', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (19, '120', NULL, NULL, NULL, NULL, NULL, '62', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (20, '120', NULL, NULL, NULL, NULL, NULL, '63', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (21, '120', NULL, NULL, NULL, NULL, NULL, '64', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (22, '120', NULL, NULL, NULL, NULL, NULL, '65', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (23, '119', NULL, NULL, NULL, NULL, NULL, '66', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (24, '119', NULL, NULL, NULL, NULL, NULL, '67', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (25, '119', NULL, NULL, NULL, NULL, NULL, '68', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (26, '119', NULL, NULL, NULL, NULL, NULL, '69', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (27, '111', NULL, NULL, NULL, NULL, NULL, '70', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (28, '110', NULL, NULL, NULL, NULL, NULL, '73', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (29, '109', NULL, NULL, NULL, NULL, NULL, '81', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (30, '108', NULL, NULL, NULL, NULL, NULL, '85', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (31, '108', NULL, NULL, NULL, NULL, NULL, '86', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (32, '106', NULL, NULL, NULL, NULL, NULL, '92', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (33, '106', NULL, NULL, NULL, NULL, NULL, '93', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (34, '114', NULL, NULL, NULL, NULL, NULL, '96', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (35, '105', NULL, NULL, NULL, NULL, NULL, '101', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (36, '105', NULL, NULL, NULL, NULL, NULL, '102', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (37, '103', NULL, NULL, NULL, NULL, NULL, '105', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (38, '103', NULL, NULL, NULL, NULL, NULL, '106', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (39, '103', NULL, NULL, NULL, NULL, NULL, '107', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (40, '99', NULL, NULL, NULL, NULL, NULL, '113', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (41, '99', NULL, NULL, NULL, NULL, NULL, '114', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (42, '98', NULL, NULL, NULL, NULL, NULL, '117', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (43, '71', NULL, NULL, NULL, NULL, NULL, '121', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (44, '96', NULL, NULL, NULL, NULL, NULL, '130', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (45, '96', NULL, NULL, NULL, NULL, NULL, '131', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (46, '95', NULL, NULL, NULL, NULL, NULL, '133', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (47, '95', NULL, NULL, NULL, NULL, NULL, '134', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (48, '94', NULL, NULL, NULL, NULL, NULL, '137', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (49, '94', NULL, NULL, NULL, NULL, NULL, '138', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (50, '93', NULL, NULL, NULL, NULL, NULL, '141', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (51, '93', NULL, NULL, NULL, NULL, NULL, '142', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (52, '92', NULL, NULL, NULL, NULL, NULL, '145', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (53, '89', NULL, NULL, NULL, NULL, NULL, '160', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (54, '89', NULL, NULL, NULL, NULL, NULL, '161', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (55, '87', NULL, NULL, NULL, NULL, NULL, '167', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (56, '85', NULL, NULL, NULL, NULL, NULL, '170', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (57, '85', NULL, NULL, NULL, NULL, NULL, '171', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (58, '84', NULL, NULL, NULL, NULL, NULL, '178', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (59, '84', NULL, NULL, NULL, NULL, NULL, '179', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (60, '83', NULL, NULL, NULL, NULL, NULL, '182', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (61, '83', NULL, NULL, NULL, NULL, NULL, '183', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (62, '82', NULL, NULL, NULL, NULL, NULL, '191', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (63, '5', NULL, NULL, NULL, NULL, NULL, '194', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (64, '5', NULL, NULL, NULL, NULL, NULL, '195', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (65, '5', NULL, NULL, NULL, NULL, NULL, '196', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (66, '68', NULL, NULL, NULL, NULL, NULL, '213', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (67, '6', NULL, NULL, NULL, NULL, NULL, '217', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (68, '6', NULL, NULL, NULL, NULL, NULL, '221', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (69, '69', NULL, NULL, NULL, NULL, NULL, '222', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (70, '86', NULL, NULL, NULL, NULL, NULL, '231', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (71, '17', NULL, NULL, NULL, NULL, NULL, '247', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (72, '17', NULL, NULL, NULL, NULL, NULL, '248', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (73, '17', NULL, NULL, NULL, NULL, NULL, '249', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (74, '147', NULL, NULL, NULL, NULL, NULL, '259', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (75, '64', NULL, NULL, NULL, NULL, NULL, '266', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (76, '64', NULL, NULL, NULL, NULL, NULL, '267', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (77, '133', NULL, NULL, NULL, NULL, NULL, '270', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (78, '133', NULL, NULL, NULL, NULL, NULL, '271', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (79, '115', NULL, NULL, NULL, NULL, NULL, '274', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (80, '61', NULL, NULL, NULL, NULL, NULL, '278', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (81, '61', NULL, NULL, NULL, NULL, NULL, '279', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (82, '80', NULL, NULL, NULL, NULL, NULL, '285', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (83, '66', NULL, NULL, NULL, NULL, NULL, '293', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (84, '53', NULL, NULL, NULL, NULL, NULL, '295', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (85, '53', NULL, NULL, NULL, NULL, NULL, '296', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO project_weekly_progress (id, project_code, week_start, week_end, enrollment_total, enrollment_week, dropout_week, milestone, risk, summary, next_plan, reporter_id, created_at, updated_at)
VALUES (86, '53', NULL, NULL, NULL, NULL, NULL, '297', NULL, NULL, NULL, NULL, NULL, NULL);

COMMIT;