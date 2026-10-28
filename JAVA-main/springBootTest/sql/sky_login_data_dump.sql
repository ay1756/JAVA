-- =====================================================================
-- sky_login 真实数据快照（由本机 MySQL 用 Navicat 导出，2026-10-22）
-- 用途：把【当前真实数据】恢复到另一台电脑（含测试账号 花环）
--
-- 与 init_safe.sql 的区别：
--   - init_safe.sql 只做“建库 + 种子”，仅写入 admin / traveler 两个账号；
--   - 本文件是“整表覆盖”：先 DROP 旧 user 表，再写入当前全部真实数据。
--
-- 使用方式（任选其一，先确保 sky_login 库已存在）：
--   1. 命令行：  mysql -uroot -p123456 sky_login < sky_login_data_dump.sql
--   2. Navicat / DBeaver：直接打开本文件执行
--
-- 注意：本文件【不】 DROP DATABASE，只 DROP TABLE，安全，不会误删其它库。
-- =====================================================================

USE `sky_login`;

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
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 真实数据（密码均为 123456 经 MD5(明文 + 'sky_login_2025') 加密，可直接登录）
INSERT INTO `user` (`id`, `username`, `password`, `faction`, `create_time`, `update_time`, `deleted`) VALUES
    (1, 'admin',    'fc46d036e81f8f89d8d8785e455abda3', '先祖', '2026-10-21 11:45:22', '2026-10-21 11:45:22', 0),
    (2, 'traveler', 'fc46d036e81f8f89d8d8785e455abda3', NULL,   '2026-10-21 11:45:22', '2026-10-21 11:45:22', 0),
    (4, '花环',     'fc46d036e81f8f89d8d8785e455abda3', NULL,   '2026-10-21 12:22:20', '2026-10-21 12:22:20', 0);
