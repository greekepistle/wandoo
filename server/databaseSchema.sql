drop database if exists `wandoo`;
create database `wandoo`;
use wandoo;

-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'wandoo'
--
-- ---

DROP TABLE IF EXISTS `wandoo`;

CREATE TABLE `wandoo` (
  `wandooID` INTEGER AUTO_INCREMENT,
  `userID` INTEGER NULL DEFAULT NULL,
  `text` VARCHAR(255) NULL DEFAULT NULL,
  `start_time` DATETIME NULL DEFAULT NULL,
  `end_time` DATETIME NULL DEFAULT NULL,
  `post_time` DATETIME NULL DEFAULT NULL,
  `latitude` DECIMAL(13,10) NULL DEFAULT NULL,
  `longitude` DECIMAL(13,10) NULL DEFAULT NULL,
  `num_people` INTEGER NULL DEFAULT NULL,
  `status` CHAR(1) NULL DEFAULT NULL,
  PRIMARY KEY (`wandooID`)
);

-- ---
-- Table 'user'
--
-- ---

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `userID` INTEGER AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `facebookID` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `age` INTEGER NULL DEFAULT NULL,
  `sex` CHAR(1) NULL DEFAULT NULL,
  `profile_picture` VARCHAR(100) NULL DEFAULT NULL,
  `employer` VARCHAR(100) NULL DEFAULT NULL,
  `job_title` VARCHAR(100) NULL DEFAULT NULL,
  `latitude` DECIMAL(13,10) NULL DEFAULT NULL,
  `longitude` DECIMAL(13,10) NULL DEFAULT NULL,
  `objectID` VARCHAR(15) NULL DEFAULT NULL,
  PRIMARY KEY (`userID`)
);

-- ---
-- Table 'room'
--
-- ---

DROP TABLE IF EXISTS `room`;

CREATE TABLE `room` (
  `roomID` INTEGER AUTO_INCREMENT,
  `expiry_time` DATETIME NULL DEFAULT NULL,
  `wandooID` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`roomID`)
);

-- ---
-- Table 'user_interest'
--
-- ---

DROP TABLE IF EXISTS `user_interest`;

CREATE TABLE `user_interest` (
  `userID` INTEGER,
  `interest` VARCHAR(100),
  PRIMARY KEY (`userID`, `interest`)
);

-- ---
-- Table 'user_friendship'
--
-- ---

DROP TABLE IF EXISTS `user_friendship`;

CREATE TABLE `user_friendship` (
  `userID_1` INTEGER,
  `userID_2` INTEGER,
  PRIMARY KEY (`userID_1`, `userID_2`)
);

-- ---
-- Table 'user_education'
--
-- ---

DROP TABLE IF EXISTS `user_education`;

CREATE TABLE `user_education` (
  `userID` INTEGER,
  `institution_name` VARCHAR(100),
  PRIMARY KEY (`userID`, `institution_name`)
);

-- ---
-- Table 'wandoo_tag'
--
-- ---

DROP TABLE IF EXISTS `wandoo_tag`;

CREATE TABLE `wandoo_tag` (
  `wandooID` INTEGER,
  `tagID` INTEGER,
  PRIMARY KEY (`wandooID`, `tagID`)
);

-- ---
-- Table 'wandoo_interest'
--
-- ---

DROP TABLE IF EXISTS `wandoo_interest`;

CREATE TABLE `wandoo_interest` (
  `wandooID` INTEGER,
  `userID` INTEGER,
  `selected` TINYINT(1) NULL DEFAULT 0,
  `rejected` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`wandooID`, `userID`)
);

-- ---
-- Table 'tag'
--
-- ---

DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
  `tagID` INTEGER AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`tagID`)
);

-- ---
-- Table 'room_user'
--
-- ---

DROP TABLE IF EXISTS `room_user`;

CREATE TABLE `room_user` (
  `roomID` INTEGER,
  `userID` INTEGER,
  PRIMARY KEY (`roomID`, `userID`)
);

-- ---
-- Table 'wandoo_status'
--
-- ---

DROP TABLE IF EXISTS `wandoo_status`;

CREATE TABLE `wandoo_status` (
  `status` CHAR(1),
  `description` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`status`)
);

-- ---
-- Foreign Keys
-- ---

ALTER TABLE `wandoo` ADD FOREIGN KEY (userID) REFERENCES `user` (`userID`);
ALTER TABLE `wandoo` ADD FOREIGN KEY (status) REFERENCES `wandoo_status` (`status`);
ALTER TABLE `room` ADD FOREIGN KEY (wandooID) REFERENCES `wandoo` (`wandooID`);
ALTER TABLE `user_interest` ADD FOREIGN KEY (userID) REFERENCES `user` (`userID`);
ALTER TABLE `user_friendship` ADD FOREIGN KEY (userID_1) REFERENCES `user` (`userID`);
ALTER TABLE `user_friendship` ADD FOREIGN KEY (userID_2) REFERENCES `user` (`userID`);
ALTER TABLE `user_education` ADD FOREIGN KEY (userID) REFERENCES `user` (`userID`);
ALTER TABLE `wandoo_tag` ADD FOREIGN KEY (wandooID) REFERENCES `wandoo` (`wandooID`);
ALTER TABLE `wandoo_tag` ADD FOREIGN KEY (tagID) REFERENCES `tag` (`tagID`);
ALTER TABLE `wandoo_interest` ADD FOREIGN KEY (wandooID) REFERENCES `wandoo` (`wandooID`);
ALTER TABLE `wandoo_interest` ADD FOREIGN KEY (userID) REFERENCES `user` (`userID`);
ALTER TABLE `room_user` ADD FOREIGN KEY (roomID) REFERENCES `room` (`roomID`);
ALTER TABLE `room_user` ADD FOREIGN KEY (userID) REFERENCES `user` (`userID`);

INSERT INTO `wandoo_status` (`status`,`description`) VALUES
('A','Active and visible on feed'),
('P','Passive wandoo that is no longer visible on feed, but has an active room'),
('E','Expired wandoo that is no longer visible on feed and has no active room')
;

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `wandoo` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `user` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `room` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `user_interest` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `user_friendship` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `user_education` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `wandoo_tag` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `wandoo_interest` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `tag` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `room_user` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `wandoo_status` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `wandoo` (`wandooID`,`userID`,`text`,`start_time`,`end_time`,`post_time`,`latitude`,`longitude`,`num_people`,`status`) VALUES
-- ('','','','','','','','','','');
-- INSERT INTO `user` (`userID`,`name`,`facebookID`,`email`,`age`,`sex`,`profile_picture`,`employer`,`job_title`,`latitude`,`longitude`) VALUES
-- ('','','','','','','','','','','');
-- INSERT INTO `room` (`roomID`,`expiry_time`,`wandooID`) VALUES
-- ('','','');
-- INSERT INTO `user_interest` (`userID`,`interest`) VALUES
-- ('','');
-- INSERT INTO `user_friendship` (`userID_1`,`userID_2`) VALUES
-- ('','');
-- INSERT INTO `user_education` (`userID`,`institution_name`) VALUES
-- ('','');
-- INSERT INTO `wandoo_tag` (`wandooID`,`tagID`) VALUES
-- ('','');
-- INSERT INTO `wandoo_interest` (`wandooID`,`userID`,`selected`,`rejected`) VALUES
-- ('','','','');
-- INSERT INTO `tag` (`tagID`,`name`) VALUES
-- ('','');
-- INSERT INTO `room_user` (`roomID`,`userID`) VALUES
-- ('','');
-- INSERT INTO `wandoo_status` (`status`,`description`) VALUES
-- ('','');
