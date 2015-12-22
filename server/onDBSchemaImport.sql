drop database if exists `wandoo`;
create database `wandoo`;
use wandoo;

INSERT INTO `wandoo_status` (`status`,`description`) VALUES
('A','Active and visible on feed'),
('P','Passive wandoo that is no longer visible on feed, but has an active room'),
('E','Expired wandoo that is no longer visible on feed and has no active room'),
;

-- change all DECIMAL to DECIMAL(13,10)
