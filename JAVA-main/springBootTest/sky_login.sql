/*
 Navicat Premium Dump SQL

 Source Server         : 王母娘娘
 Source Server Type    : MySQL
 Source Server Version : 80408 (8.4.8)
 Source Host           : localhost:3306
 Source Schema         : sky_login

 Target Server Type    : MySQL
 Target Server Version : 80408 (8.4.8)
 File Encoding         : 65001

 Date: 22/10/2026 00:20:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '涓婚敭 ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鐢ㄦ埛鍚',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '瀵嗙爜锛圡D5 鍔犵洂鍚庡瓨鍏ワ紝鍥哄畾 32 浣嶏紝鐣?64 闃叉墿灞曪級',
  `faction` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  `deleted` tinyint NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎锛? 鏈?垹闄?1 宸插垹闄',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鐢ㄦ埛琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'fc46d036e81f8f89d8d8785e455abda3', '先祖', '2026-10-21 11:45:22', '2026-10-21 11:45:22', 0);
INSERT INTO `user` VALUES (2, 'traveler', 'fc46d036e81f8f89d8d8785e455abda3', NULL, '2026-10-21 11:45:22', '2026-10-21 11:45:22', 0);
INSERT INTO `user` VALUES (4, '花环', 'fc46d036e81f8f89d8d8785e455abda3', NULL, '2026-10-21 12:22:20', '2026-10-21 12:22:20', 0);

SET FOREIGN_KEY_CHECKS = 1;
