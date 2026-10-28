-- =====================================================================
-- sky_login 数据库「幂等」初始化脚本（供启动脚本自动调用）
-- 特点：不会删除已有数据，可反复执行（每次开机都跑也安全）
--
-- 与 sql/sky_login.sql 的区别：
--   sky_login.sql 含 DROP DATABASE，会清空所有注册用户，仅用于「彻底重置」；
--   本脚本只 CREATE DATABASE/TABLE IF NOT EXISTS，并仅在缺失时补种子账号。
-- =====================================================================

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `sky_login`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `sky_login`;

CREATE TABLE IF NOT EXISTS `user` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
    `username`    VARCHAR(50)  NOT NULL                COMMENT '用户名',
    `password`    VARCHAR(64)  NOT NULL                COMMENT '密码（MD5 加盐后存入）',
    `faction`     VARCHAR(20)  DEFAULT NULL            COMMENT '阵营：光崽 / 先祖 / 国王',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     TINYINT      DEFAULT 0               COMMENT '逻辑删除：0 未删除 1 已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 仅在缺失时补种子账号（密码 = MD5('123456' + 'sky_login_2025')）
INSERT INTO `user` (`username`, `password`, `faction`)
SELECT 'admin', MD5(CONCAT('123456', 'sky_login_2025')), '先祖'
WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'admin');

INSERT INTO `user` (`username`, `password`, `faction`)
SELECT 'traveler', MD5(CONCAT('123456', 'sky_login_2025')), '光崽'
WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'traveler');
