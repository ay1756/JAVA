-- =====================================================================
-- sky_login 数据库初始化脚本
-- 项目：sky-login-vue（前端 Vue3 + Vite）+ springBootTest（后端 SpringBoot3 + MyBatis-Plus）
--
-- 使用方法（任选其一）：
--   1. 命令行：
--        mysql -uroot -p123456 < sky_login.sql
--   2. IDEA Database 工具 / Navicat / DBeaver：直接打开本文件执行
--   3. 进入 mysql 命令行后：source D:/你的路径/sky_login.sql;
--
-- 数据库连接信息（与后端 application.properties 对应）：
--   host=localhost  port=3306  user=root  password=123456  database=sky_login
-- =====================================================================

-- 如果数据库已存在则先删除（演示用，生产环境慎用）
DROP DATABASE IF EXISTS `sky_login`;

-- 创建数据库，统一使用 utf8mb4 字符集，支持 emoji 等 4 字节字符
CREATE DATABASE `sky_login` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `sky_login`;

-- ---------------------------------------------------------------------
-- 用户表 user
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
    `username`    VARCHAR(50)  NOT NULL                COMMENT '用户名',
    `password`    VARCHAR(64)  NOT NULL                COMMENT '密码（MD5 加盐后存入，固定 32 位，留 64 防扩展）',
    `faction`     VARCHAR(20)  DEFAULT NULL            COMMENT '阵营：光崽 / 先祖 / 国王',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     TINYINT      DEFAULT 0               COMMENT '逻辑删除：0 未删除 1 已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)     -- 用户名唯一
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ---------------------------------------------------------------------
-- 初始化测试数据
-- 密码加密规则：MD5(明文密码 + SALT)，其中 SALT = "sky_login_2025"
--   admin   / 123456 -> MD5("123456sky_login_2025")
--   traveler/ 123456 -> MD5("123456sky_login_2025")
-- 下面 password 字段值为 "123456" 经过上述规则加密后的结果，可直接登录
-- ---------------------------------------------------------------------
-- admin（先祖）密码同为 123456，直接用 MD5("123456"+"sky_login_2025") 加密入库
INSERT INTO `user` (`username`, `password`, `faction`) VALUES
    ('admin', MD5(CONCAT('123456', 'sky_login_2025')), '先祖');

-- 再插入一条旅人测试账号，密码同为 123456
INSERT INTO `user` (`username`, `password`, `faction`) VALUES
    ('traveler', MD5(CONCAT('123456', 'sky_login_2025')), '光崽');

-- ---------------------------------------------------------------------
-- 验证
-- ---------------------------------------------------------------------
SELECT id, username, faction, create_time, deleted FROM `user`;

-- 测试账号一览：
--   admin    / 123456
--   traveler / 123456
