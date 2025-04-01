/*
 Navicat Premium Data Transfer

 Source Server         : root
 Source Server Type    : MySQL
 Source Server Version : 80032
 Source Host           : localhost:3306
 Source Schema         : xuanke

 Target Server Type    : MySQL
 Target Server Version : 80032
 File Encoding         : 65001

 Date: 29/03/2025 11:49:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class`  (
  `class_id` bigint NOT NULL,
  `class_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班级名称',
  `major` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '专业名称',
  `required_credits` smallint UNSIGNED NULL DEFAULT 160 COMMENT '毕业所需学分',
  `enroll_year` year NULL DEFAULT NULL COMMENT '入学年份',
  PRIMARY KEY (`class_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of class
-- ----------------------------
INSERT INTO `class` VALUES (1234567890, '一班', '软件工程', 0, 0000);
INSERT INTO `class` VALUES (2234567890, '二班', '软件工程', 0, 0000);

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `course_id` bigint NOT NULL,
  `course_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程姓名',
  `credit` tinyint UNSIGNED NOT NULL COMMENT '学分',
  `teacher_id` bigint NOT NULL COMMENT '授课教师ID',
  `max_seats` smallint UNSIGNED NOT NULL DEFAULT 100 COMMENT '最大选课人数',
  `current_seats` smallint UNSIGNED NULL DEFAULT 0 COMMENT '已选人数',
  `exam_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '闭卷' COMMENT '考试类型',
  PRIMARY KEY (`course_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------

-- ----------------------------
-- Table structure for enrollment
-- ----------------------------
DROP TABLE IF EXISTS `enrollment`;
CREATE TABLE `enrollment`  (
  `enroll_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `course_id` bigint NOT NULL,
  `status` tinyint(1) NOT NULL COMMENT '选课状态（1有效/0退选）',
  `enroll_time` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建（选课）时间',
  PRIMARY KEY (`enroll_id`) USING BTREE,
  INDEX `idx_user_semester`(`student_id`, `status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enrollment
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '学工号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `password` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `class_id` bigint NOT NULL COMMENT '班级编号（学生-所属班级，老师-所管班级）',
  `gender` tinyint(1) NOT NULL COMMENT '性别（0: 女, 1: 男）',
  `user_type` tinyint(1) NOT NULL COMMENT '用户类型（0: 学生, 1: 老师）',
  `phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (111, '姓名', '123456', 111, 0, 0, '01234567890', '2025-03-15 15:10:44', '2025-03-15 15:10:44');

SET FOREIGN_KEY_CHECKS = 1;
