-- MySQL 8.0 schema and mock data for the comic forum.
-- Import into an empty schema. This file intentionally does not drop existing tables.
-- Mock row counts: user 8, classify 4, forum 8, comment 14, board 3, likes 14, collects 10.

CREATE DATABASE IF NOT EXISTS `comic_forum`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `comic_forum`;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(64) NOT NULL,
  `nickname` VARCHAR(64) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `enabled` VARCHAR(8) NOT NULL DEFAULT '3',
  `email` VARCHAR(255) NOT NULL,
  `userface` VARCHAR(255) DEFAULT NULL,
  `depiction` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_user_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `classify` (
  `classify_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`classify_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `forum` (
  `forum_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `content` VARCHAR(255),
  `classify_id` INT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `collects` INT NOT NULL DEFAULT 0,
  `likes` INT NOT NULL DEFAULT 0,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`forum_id`),
  KEY `idx_forum_classify_id` (`classify_id`),
  KEY `idx_forum_user_id` (`user_id`),
  CONSTRAINT `fk_forum_classify`
    FOREIGN KEY (`classify_id`) REFERENCES `classify` (`classify_id`),
  CONSTRAINT `fk_forum_user`
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `comment` (
  `comment_id` INT NOT NULL AUTO_INCREMENT,
  `content` VARCHAR(255),
  `user_id` BIGINT NOT NULL,
  `forum_id` INT NOT NULL,
  -- The application uses 0 to represent a root comment or an empty reply target.
  `root_comment_id` INT NOT NULL DEFAULT 0,
  `to_comment_id` INT NOT NULL DEFAULT 0,
  `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `idx_comment_user_id` (`user_id`),
  KEY `idx_comment_forum_root` (`forum_id`, `root_comment_id`, `time`),
  CONSTRAINT `fk_comment_user`
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `fk_comment_forum`
    FOREIGN KEY (`forum_id`) REFERENCES `forum` (`forum_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `board` (
  `board_id` INT NOT NULL AUTO_INCREMENT,
  `content` VARCHAR(255),
  `board_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `likes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `forum_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_likes_user_id` (`user_id`),
  KEY `idx_likes_forum_id` (`forum_id`),
  CONSTRAINT `fk_likes_user`
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_likes_forum`
    FOREIGN KEY (`forum_id`) REFERENCES `forum` (`forum_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `collects` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `forum_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_collects_user_id` (`user_id`),
  KEY `idx_collects_forum_id` (`forum_id`),
  CONSTRAINT `fk_collects_user`
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_collects_forum`
    FOREIGN KEY (`forum_id`) REFERENCES `forum` (`forum_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `user`
  (`user_id`, `username`, `nickname`, `password`, `enabled`, `email`, `userface`, `depiction`)
VALUES
  (1, 'admin', '星海管理员', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '1', 'admin@example.local', '', '本地演示管理员'),
  (2, 'sakura', '樱花同学', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '2', 'sakura@example.local', '', '喜欢日常番和音乐'),
  (3, 'mikan', '柑橘汽水', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '2', 'mikan@example.local', '', '国创动画爱好者'),
  (4, 'aozora', '青空', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '2', 'aozora@example.local', '', '周末补番中'),
  (5, 'hoshi', '星野', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '2', 'hoshi@example.local', '', '关注动画制作幕后'),
  (6, 'nami', '波子', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '2', 'nami@example.local', '', '3D动画学习者'),
  (7, 'haru', '春日', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '2', 'haru@example.local', '', '喜欢分享观后感'),
  (8, 'yuki', '雪见', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '2', 'yuki@example.local', '', '不定期更新收藏夹');

INSERT INTO `classify` (`classify_id`, `title`, `description`)
VALUES
  (1, '日漫', '日本动画新番、经典作品与观后感'),
  (2, '国创', '国产动画作品与创作交流'),
  (3, '3D动画', '三维动画、建模与制作分享'),
  (4, '美漫', '欧美动画与动画电影讨论');

INSERT INTO `forum`
  (`forum_id`, `title`, `content`, `classify_id`, `user_id`, `collects`, `likes`, `create_time`)
VALUES
  (1, '最近重看这部日常番，还是很治愈', '分享几个让我印象很深的日常片段，大家最近在补什么？', 1, 2, 2, 3, '2026-11-18 10:20:00'),
  (2, '国创动画的配乐也太惊喜了', '想整理一份近几年喜欢的动画配乐清单，欢迎推荐。', 2, 3, 1, 2, '2026-11-18 13:15:00'),
  (3, '求推荐适合入门的动画电影', '周末想看一部节奏舒服、画面也好看的动画电影。', 1, 4, 1, 2, '2026-11-19 09:30:00'),
  (4, '分享一次3D角色建模练习', '最近在练习角色建模，记录一下从草模到材质的过程。', 3, 6, 2, 2, '2026-11-19 14:05:00'),
  (5, '你最喜欢的动画片头曲是哪一首？', '片头曲有时会让人立刻进入作品的氛围，来聊聊吧。', 1, 5, 1, 1, '2026-11-20 08:45:00'),
  (6, '一部作品的分镜是怎么设计的', '最近开始注意分镜和镜头衔接，想听听大家的观察。', 2, 1, 1, 2, '2026-11-20 11:10:00'),
  (7, '周末补番清单互换', '我准备看两部短篇动画，欢迎交换不剧透的推荐。', 4, 7, 2, 1, '2026-11-20 16:40:00'),
  (8, '推荐几部适合全家一起看的动画', '想找一些轻松有趣、不同年龄都能看的作品。', 4, 8, 0, 1, '2026-11-21 09:00:00');

INSERT INTO `comment`
  (`comment_id`, `content`, `user_id`, `forum_id`, `root_comment_id`, `to_comment_id`, `time`)
VALUES
  (1, '最近在补《夏目友人帐》，氛围特别舒服。', 3, 1, 0, 0, '2026-11-18 11:00:00'),
  (2, '这部我也很喜欢，配乐也很加分。', 4, 1, 1, 0, '2026-11-18 11:12:00'),
  (3, '可以看看《日常》，轻松又有很多名场面。', 5, 1, 1, 0, '2026-11-18 11:26:00'),
  (4, '我最近循环听一首国创动画的片尾曲。', 2, 2, 0, 0, '2026-11-18 14:02:00'),
  (5, '如果有歌单的话记得分享一下！', 6, 2, 4, 0, '2026-11-18 14:30:00'),
  (6, '《狼的孩子雨和雪》很适合周末看。', 1, 3, 0, 0, '2026-11-19 10:05:00'),
  (7, '收到，谢谢推荐！', 4, 3, 6, 0, '2026-11-19 10:19:00'),
  (8, '布线阶段花的时间比我想的长很多。', 2, 4, 0, 0, '2026-11-19 15:10:00'),
  (9, '可以先把拓扑拆成几个简单区域来处理。', 3, 4, 8, 0, '2026-11-19 15:34:00'),
  (10, '这个建议很实用，我再试试。', 6, 4, 8, 9, '2026-11-19 16:02:00'),
  (11, '最近很喜欢《葬送的芙莉莲》的片头。', 8, 5, 0, 0, '2026-11-20 09:12:00'),
  (12, '我会反复看镜头运动和人物走位。', 7, 6, 0, 0, '2026-11-20 12:20:00'),
  (13, '分镜草稿阶段多做几版对比很有帮助。', 2, 6, 12, 0, '2026-11-20 13:05:00'),
  (14, '我推荐《寻梦环游记》，适合一起看。', 5, 8, 0, 0, '2026-11-21 10:15:00');

INSERT INTO `board` (`board_id`, `content`, `board_time`)
VALUES
  (1, '欢迎来到动漫论坛，发帖交流请保持友善。', '2026-11-18 08:00:00'),
  (2, '本地演示数据仅用于开发和测试。', '2026-11-19 08:00:00'),
  (3, '发帖前请先选择对应的动画板块。', '2026-11-20 08:00:00');

INSERT INTO `likes` (`id`, `user_id`, `forum_id`)
VALUES
  (1, 3, 1), (2, 4, 1), (3, 5, 1),
  (4, 1, 2), (5, 5, 2),
  (6, 2, 3), (7, 5, 3),
  (8, 2, 4), (9, 3, 4),
  (10, 3, 5),
  (11, 2, 6), (12, 4, 6),
  (13, 2, 7),
  (14, 4, 8);

INSERT INTO `collects` (`id`, `user_id`, `forum_id`)
VALUES
  (1, 3, 1), (2, 5, 1),
  (3, 1, 2),
  (4, 2, 3),
  (5, 2, 4), (6, 5, 4),
  (7, 7, 5),
  (8, 3, 6),
  (9, 5, 7), (10, 8, 7);
