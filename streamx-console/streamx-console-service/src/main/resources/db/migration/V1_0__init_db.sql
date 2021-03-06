SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_app_backup
-- ----------------------------
DROP TABLE IF EXISTS `t_app_backup`;
CREATE TABLE `t_app_backup` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`APP_ID` bigint DEFAULT NULL,
`SQL_ID` bigint DEFAULT NULL,
`CONFIG_ID` bigint DEFAULT NULL,
`VERSION` int DEFAULT NULL,
`PATH` varchar(255) DEFAULT NULL,
`DESCRIPTION` varchar(255) DEFAULT NULL,
`CREATE_TIME` datetime DEFAULT NULL,
PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flame_graph
-- ----------------------------
DROP TABLE IF EXISTS `t_flame_graph`;
CREATE TABLE `t_flame_graph` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`APP_ID` bigint DEFAULT NULL,
`PROFILER` varchar(255) DEFAULT NULL,
`TIMELINE` datetime DEFAULT NULL,
`CONTENT` varchar(2000) DEFAULT NULL,
PRIMARY KEY (`ID`) USING BTREE,
KEY `INX_TIME` (`TIMELINE`) USING HASH,
KEY `INX_APPID` (`APP_ID`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_app
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_app`;

CREATE TABLE `t_flink_app` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`JOB_TYPE` tinyint DEFAULT NULL,
`EXECUTION_MODE` tinyint DEFAULT NULL,
`PROJECT_ID` varchar(64) DEFAULT NULL,
`JOB_NAME` varchar(255) DEFAULT NULL,
`MODULE` varchar(255) DEFAULT NULL,
`JAR` varchar(255) DEFAULT NULL,
`MAIN_CLASS` varchar(255) DEFAULT NULL,
`ARGS` varchar(255) DEFAULT NULL,
`OPTIONS` text,
`USER_ID` bigint DEFAULT NULL,
`APP_ID` varchar(255) DEFAULT NULL,
`APP_TYPE` tinyint DEFAULT NULL,
`DURATION` bigint DEFAULT NULL,
`JOB_ID` varchar(64) DEFAULT NULL,
`STATE` varchar(50) DEFAULT NULL,
`RESTART_SIZE` int DEFAULT NULL,
`RESTART_COUNT` int DEFAULT NULL,
`CP_THRESHOLD` int DEFAULT NULL,
`DYNAMIC_OPTIONS` text,
`DESCRIPTION` varchar(255) DEFAULT NULL,
`RESOLVE_ORDER` tinyint DEFAULT NULL,
`FLAME_GRAPH` tinyint DEFAULT '0',
`JM_MEMORY` int DEFAULT NULL,
`TM_MEMORY` int DEFAULT NULL,
`TOTAL_TASK` int DEFAULT NULL,
`TOTAL_TM` int DEFAULT NULL,
`TOTAL_SLOT` int DEFAULT NULL,
`AVAILABLE_SLOT` int DEFAULT NULL,
`OPTION_STATE` tinyint DEFAULT NULL,
`TRACKING` tinyint DEFAULT NULL,
`CREATE_TIME` datetime DEFAULT NULL,
`DEPLOY` tinyint DEFAULT '0',
`START_TIME` datetime DEFAULT NULL,
`END_TIME` datetime DEFAULT NULL,
`ALERT_EMAIL` varchar(255) DEFAULT NULL,
PRIMARY KEY (`ID`) USING BTREE,
KEY `INX_STATE` (`STATE`) USING BTREE,
KEY `INX_JOB_TYPE` (`JOB_TYPE`) USING BTREE,
KEY `INX_TRACK` (`TRACKING`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_config
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_config`;
CREATE TABLE `t_flink_config` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`APP_ID` bigint NOT NULL,
`FORMAT` tinyint NOT NULL DEFAULT '0',
`VERSION` int NOT NULL,
`LATEST` tinyint NOT NULL DEFAULT '0',
`CONTENT` text NOT NULL,
`CREATE_TIME` datetime DEFAULT NULL,
PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_effective
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_effective`;
CREATE TABLE `t_flink_effective` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`APP_ID` bigint NOT NULL,
`TARGET_TYPE` tinyint NOT NULL COMMENT '1) config 2) flink sql',
`TARGET_ID` bigint NOT NULL COMMENT 'configId or sqlId',
`CREATE_TIME` datetime DEFAULT NULL,
PRIMARY KEY (`ID`) USING BTREE,
UNIQUE KEY `UN_INX` (`APP_ID`,`TARGET_TYPE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_log
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_log`;
CREATE TABLE `t_flink_log` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`APP_ID` bigint DEFAULT NULL,
`YARN_APP_ID` varchar(50) DEFAULT NULL,
`SUCCESS` tinyint DEFAULT NULL,
`EXCEPTION` text,
`START_TIME` datetime DEFAULT NULL,
PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_project
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_project`;
CREATE TABLE `t_flink_project` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`NAME` varchar(255) DEFAULT NULL,
`URL` varchar(1000) DEFAULT NULL,
`BRANCHES` varchar(1000) DEFAULT NULL,
`USERNAME` varchar(255) DEFAULT NULL,
`PASSWORD` varchar(255) DEFAULT NULL,
`POM` varchar(255) DEFAULT NULL,
`TYPE` tinyint DEFAULT NULL,
`REPOSITORY` tinyint DEFAULT NULL,
`DATE` datetime DEFAULT NULL,
`LASTBUILD` datetime DEFAULT NULL,
`DESCRIPTION` varchar(255) DEFAULT NULL,
`BUILDSTATE` tinyint DEFAULT '-1',
PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_savepoint
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_savepoint`;
CREATE TABLE `t_flink_savepoint` (
`ID` bigint NOT NULL AUTO_INCREMENT,
`APP_ID` bigint NOT NULL,
`TYPE` tinyint DEFAULT NULL,
`PATH` varchar(255) DEFAULT NULL,
`LATEST` tinyint NOT NULL,
`TRIGGER_TIME` datetime DEFAULT NULL,
`CREATE_TIME` datetime DEFAULT NULL,
PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_sql
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_sql`;
CREATE TABLE `t_flink_sql` (
`ID` bigint NOT NULL,
`APP_ID` bigint DEFAULT NULL,
`SQL` text,
`DEPENDENCY` text,
`VERSION` int DEFAULT NULL,
`CANDIDATE` tinyint NOT NULL DEFAULT '0',
`CREATE_TIME` datetime DEFAULT NULL,
PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_tutorial
-- ----------------------------
DROP TABLE IF EXISTS `t_flink_tutorial`;
CREATE TABLE `t_flink_tutorial` (
`ID` int NOT NULL AUTO_INCREMENT,
`TYPE` tinyint DEFAULT NULL,
`NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
`CONTENT` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
`CREATE_TIME` datetime DEFAULT NULL,
PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_menu`;
CREATE TABLE `t_menu` (
`MENU_ID` bigint NOT NULL AUTO_INCREMENT COMMENT '??????/??????ID',
`PARENT_ID` bigint NOT NULL COMMENT '????????????ID',
`MENU_NAME` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '??????/????????????',
`PATH` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '????????????path',
`COMPONENT` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '??????????????????component',
`PERMS` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '????????????',
`ICON` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '??????',
`TYPE` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '?????? 0?????? 1??????',
`DISPLAY` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '??????????????????',
`ORDER_NUM` double(20,0) DEFAULT NULL COMMENT '??????',
`CREATE_TIME` datetime NOT NULL COMMENT '????????????',
`MODIFY_TIME` datetime DEFAULT NULL COMMENT '????????????',
  PRIMARY KEY (`MENU_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role` (
`ROLE_ID` bigint NOT NULL AUTO_INCREMENT COMMENT '??????ID',
`ROLE_NAME` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '????????????',
`REMARK` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '????????????',
`CREATE_TIME` datetime NOT NULL COMMENT '????????????',
`MODIFY_TIME` datetime DEFAULT NULL COMMENT '????????????',
`ROLE_CODE` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '????????????',
PRIMARY KEY (`ROLE_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_role_menu`;
CREATE TABLE `t_role_menu` (
`ROLE_ID` bigint NOT NULL,
`MENU_ID` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_setting
-- ----------------------------
DROP TABLE IF EXISTS `t_setting`;
CREATE TABLE `t_setting` (
`NUM` int DEFAULT NULL,
`KEY` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
`VALUE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
`TITLE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
`DESCRIPTION` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
`TYPE` tinyint NOT NULL COMMENT '1: input 2: boolean 3: number',
PRIMARY KEY (`KEY`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
`USER_ID` bigint NOT NULL AUTO_INCREMENT COMMENT '??????ID',
`USERNAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '???????????????',
`NICK_NAME` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '??????',
`SALT` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '????????????',
`PASSWORD` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '??????',
`DEPT_ID` bigint DEFAULT NULL COMMENT '??????ID',
`EMAIL` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '??????',
`MOBILE` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '????????????',
`STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '?????? 0?????? 1??????',
`CREATE_TIME` datetime NOT NULL COMMENT '????????????',
`MODIFY_TIME` datetime DEFAULT NULL COMMENT '????????????',
`LAST_LOGIN_TIME` datetime DEFAULT NULL COMMENT '??????????????????',
`SEX` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '?????? 0??? 1??? 2??????',
`DESCRIPTION` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '??????',
`AVATAR` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '????????????',
`USER_TYPE` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '2' COMMENT '???????????? 1???????????? 2????????????',
PRIMARY KEY (`USER_ID`) USING BTREE,
UNIQUE KEY `UN_USERNAME` (`NICK_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_user_role
-- ----------------------------
DROP TABLE IF EXISTS `t_user_role`;
CREATE TABLE `t_user_role` (
`USER_ID` bigint DEFAULT NULL COMMENT '??????ID',
`ROLE_ID` bigint DEFAULT NULL COMMENT '??????ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT
