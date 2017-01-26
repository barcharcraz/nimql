/*
Navicat SQLite Data Transfer

Source Server         : testdb
Source Server Version : 31300
Source Host           : :0

Target Server Type    : SQLite
Target Server Version : 31300
File Encoding         : 65001

Date: 2017-01-26 01:07:53
*/

PRAGMA foreign_keys = OFF;

-- ----------------------------
-- Table structure for test1
-- ----------------------------
DROP TABLE IF EXISTS "main"."test1";
CREATE TABLE test1 ( id integer primary key , value1 integer not null default 0);
PRAGMA foreign_keys = ON;
