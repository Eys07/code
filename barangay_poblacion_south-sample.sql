/*
 Navicat Premium Dump SQL

 Source Server         : eFIND
 Source Server Type    : MariaDB
 Source Server Version : 110803 (11.8.3-MariaDB-ubu2404)
 Source Host           : 72.60.233.70:9008
 Source Schema         : barangay_poblacion_south

 Target Server Type    : MariaDB
 Target Server Version : 110803 (11.8.3-MariaDB-ubu2404)
 File Encoding         : 65001

 Date: 16/02/2026 01:27:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity_logs
-- ----------------------------
DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE `activity_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `user_role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `document_id` int(11) NULL DEFAULT NULL,
  `document_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `log_time` datetime NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_action`(`action` ASC) USING BTREE,
  INDEX `idx_log_time`(`log_time` ASC) USING BTREE,
  INDEX `idx_document`(`document_id` ASC, `document_type` ASC) USING BTREE,
  INDEX `idx_activity_user_action`(`user_id` ASC, `action` ASC) USING BTREE,
  CONSTRAINT `fk_activity_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 157 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activity_logs
-- ----------------------------
INSERT INTO `activity_logs` VALUES (1, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-02 23:15:46', '2026-02-02 23:15:46');
INSERT INTO `activity_logs` VALUES (2, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-03 01:52:46', '2026-02-03 01:52:46');
INSERT INTO `activity_logs` VALUES (3, NULL, 'Sierra Pearl Pacilan', NULL, 'logout', 'User logged out: sierra.pacilan1', '', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, NULL, '2026-02-03 01:56:55', '2026-02-03 01:56:55');
INSERT INTO `activity_logs` VALUES (4, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-03 01:57:09', '2026-02-03 01:57:09');
INSERT INTO `activity_logs` VALUES (5, NULL, 'Sierra Pearl Pacilan', NULL, 'logout', 'User logged out: sierra.pacilan1', '', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, NULL, '2026-02-03 01:58:21', '2026-02-03 01:58:21');
INSERT INTO `activity_logs` VALUES (6, NULL, 'erwin_staff', NULL, 'login', 'User logged in successfully', 'User: Erwin Bartolomeow, Role: staff', '10.0.1.11', NULL, NULL, 'system', '2026-02-03 01:58:43', '2026-02-03 01:58:43');
INSERT INTO `activity_logs` VALUES (7, NULL, 'Erwin Bartolomeow', 'staff', 'chatbot', 'Asked chatbot: What are the latest ordinances?', 'User Question: What are the latest ordinances? | Session: session_1770084082244_8ntavs8cq', '10.0.1.11', NULL, NULL, NULL, '2026-02-03 02:01:27', '2026-02-03 02:01:27');
INSERT INTO `activity_logs` VALUES (8, NULL, 'Erwin Bartolomeow', 'staff', 'chatbot', 'Chatbot responded', 'Bot Response: I\'m sorry, I wasn\'t able to find any ordinances. | Context: What are the latest ordinances? | Session: session_1770084082244_8ntavs8cq', '10.0.1.11', NULL, NULL, NULL, '2026-02-03 02:01:31', '2026-02-03 02:01:31');
INSERT INTO `activity_logs` VALUES (9, NULL, 'Erwin Bartolomeow', NULL, 'upload', 'ordinance upload: CamScanner_03-02-2026_10.06[1].jpg', 'Document uploaded successfully', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 698158, 'ordinance', '2026-02-03 02:08:53', '2026-02-03 02:08:53');
INSERT INTO `activity_logs` VALUES (10, NULL, 'Erwin Bartolomeow', NULL, 'create', 'ordinance create: #38 Yogad Street, Poblacion South, Solano, Nueva Vizcaya, 37O9 O9I73O8OI4I I', 'New ordinance created with reference number: ORD2026020001', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 8, 'ordinance', '2026-02-03 02:08:53', '2026-02-03 02:08:53');
INSERT INTO `activity_logs` VALUES (11, NULL, 'Erwin Bartolomeow', NULL, 'delete', 'ordinance delete: #38 Yogad Street, Poblacion South, Solano, Nueva Vizcaya, 37O9 O9I73O8OI4I I', 'Document permanently deleted', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 8, 'ordinance', '2026-02-03 02:11:25', '2026-02-03 02:11:25');
INSERT INTO `activity_logs` VALUES (12, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-03 02:19:29', '2026-02-03 02:19:29');
INSERT INTO `activity_logs` VALUES (13, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-03 04:40:41', '2026-02-03 04:40:41');
INSERT INTO `activity_logs` VALUES (14, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-03 04:56:20', '2026-02-03 04:56:20');
INSERT INTO `activity_logs` VALUES (15, NULL, NULL, NULL, 'failed_login', 'Invalid password', 'Username: sierra.pacilan1', '10.0.1.11', NULL, NULL, 'system', '2026-02-04 01:28:32', '2026-02-04 01:28:32');
INSERT INTO `activity_logs` VALUES (16, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-04 01:28:40', '2026-02-04 01:28:40');
INSERT INTO `activity_logs` VALUES (17, NULL, NULL, NULL, 'failed_login', 'Invalid password', 'Username: sierra.pacilan1', '10.0.1.11', NULL, NULL, 'system', '2026-02-04 01:29:51', '2026-02-04 01:29:51');
INSERT INTO `activity_logs` VALUES (18, NULL, NULL, NULL, 'failed_login', 'Invalid password', 'Username: sierra.pacilan1', '10.0.1.11', NULL, NULL, 'system', '2026-02-04 01:30:01', '2026-02-04 01:30:01');
INSERT INTO `activity_logs` VALUES (19, NULL, 'erwin_staff', NULL, 'login', 'Admin user logged in successfully', 'Admin: Sierra Pearl Pacilan', '10.0.1.11', NULL, NULL, 'system', '2026-02-04 01:30:15', '2026-02-04 01:30:15');
INSERT INTO `activity_logs` VALUES (20, NULL, 'Sierra Pearl Pacilan', NULL, 'upload', 'minute upload: Erythromycin 250mg RiteMed.jpg', 'Document uploaded successfully', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 6982, 'minute', '2026-02-04 01:30:58', '2026-02-04 01:30:58');
INSERT INTO `activity_logs` VALUES (21, NULL, 'Sierra Pearl Pacilan', NULL, 'upload', 'minute upload: fishbone.PNG', 'Document uploaded successfully', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 6982, 'minute', '2026-02-04 01:30:58', '2026-02-04 01:30:58');
INSERT INTO `activity_logs` VALUES (22, NULL, 'Sierra Pearl Pacilan', NULL, 'create', 'minute create: Techmology Process p', 'New minute created with reference number: MOM2026020001', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, 'minute', '2026-02-04 01:30:58', '2026-02-04 01:30:58');
INSERT INTO `activity_logs` VALUES (23, NULL, 'Sierra Pearl Pacilan', NULL, 'upload', 'resolution upload: Amoxicillin 250mg.jpg', 'Document uploaded successfully', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 6982, 'resolution', '2026-02-04 01:31:40', '2026-02-04 01:31:40');
INSERT INTO `activity_logs` VALUES (24, NULL, 'Sierra Pearl Pacilan', NULL, 'upload', 'resolution upload: Amoxicillin 500mg Amoxil.jpg', 'Document uploaded successfully', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 6982, 'resolution', '2026-02-04 01:31:41', '2026-02-04 01:31:41');
INSERT INTO `activity_logs` VALUES (25, NULL, 'Sierra Pearl Pacilan', NULL, 'create', 'resolution create: IOO Capsules,', 'New resolution created with reference number: RES2026020001', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, 'resolution', '2026-02-04 01:31:41', '2026-02-04 01:31:41');
INSERT INTO `activity_logs` VALUES (67, 5, 'admin_ace', NULL, 'login', 'User logged in successfully', 'User: Christian Ace C. Delfin, Role: admin', '10.0.1.11', NULL, NULL, 'system', '2026-02-04 01:46:23', '2026-02-04 01:46:23');
INSERT INTO `activity_logs` VALUES (68, 5, 'Christian Ace C. Delfin', NULL, 'logout', 'User logged out: admin_ace', '', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, NULL, '2026-02-04 01:47:01', '2026-02-04 01:47:01');
INSERT INTO `activity_logs` VALUES (74, 4, 'arlynfernandez16', NULL, 'login', 'Admin user logged in successfully', 'Admin: Lalang2', '10.0.1.11', NULL, NULL, 'system', '2026-02-09 13:28:07', '2026-02-09 05:28:07');
INSERT INTO `activity_logs` VALUES (75, 4, 'Arlyn Dawa Fernandez', 'admin', 'chatbot', 'Asked chatbot: try', 'User Question: try | Session: session_1770614982103_z7k7ooylm', '10.0.1.11', NULL, NULL, NULL, '2026-02-09 13:29:52', '2026-02-09 05:29:52');
INSERT INTO `activity_logs` VALUES (76, 4, 'Arlyn Dawa Fernandez', 'admin', 'chatbot', 'Chatbot responded', 'Bot Response: Your request is a bit vague. Could you please specify what you would like to \"or try\"?\n\nTo help me understand, please tell me:\n*   What kind of information are you looking for?\n*   Which specific data | Context: try | Session: session_1770614982103_z7k7ooylm', '10.0.1.11', NULL, NULL, NULL, '2026-02-09 13:29:55', '2026-02-09 05:29:55');
INSERT INTO `activity_logs` VALUES (77, 4, 'Arlyn Dawa Fernandez', 'admin', 'chatbot', 'Asked chatbot: hahahaaha', 'User Question: hahahaaha | Session: session_1770614982103_z7k7ooylm', '10.0.1.11', NULL, NULL, NULL, '2026-02-09 13:30:19', '2026-02-09 05:30:19');
INSERT INTO `activity_logs` VALUES (78, 4, 'Arlyn Dawa Fernandez', 'admin', 'chatbot', 'Chatbot responded', 'Bot Response: I\'m sorry, I cannot utilize the n8n tools to process \"or hahahaaha\" as it is not a recognizable query for data retrieval. The available tools are designed to interact with specific databases to fetch  | Context: hahahaaha | Session: session_1770614982103_z7k7ooylm', '10.0.1.11', NULL, NULL, NULL, '2026-02-09 13:30:21', '2026-02-09 05:30:21');
INSERT INTO `activity_logs` VALUES (79, 4, 'Arlyn Dawa Fernandez', 'admin', 'chatbot', 'Asked chatbot: latest ordinances', 'User Question: latest ordinances | Session: session_1770614982103_z7k7ooylm', '10.0.1.11', NULL, NULL, NULL, '2026-02-09 13:30:36', '2026-02-09 05:30:36');
INSERT INTO `activity_logs` VALUES (80, 4, 'Arlyn Dawa Fernandez', 'admin', 'chatbot', 'Chatbot responded', 'Bot Response: There are no ordinances in the database. I am sorry, I cannot provide the latest ordinances. | Context: latest ordinances | Session: session_1770614982103_z7k7ooylm', '10.0.1.11', NULL, NULL, NULL, '2026-02-09 13:30:39', '2026-02-09 05:30:39');
INSERT INTO `activity_logs` VALUES (96, NULL, 'TEST_USER', NULL, 'timestamp_test', 'Testing timestamp accuracy at 2026-02-11 00:47:08', NULL, '127.0.0.1', NULL, NULL, NULL, '2026-02-11 00:47:08', '2026-02-10 16:47:08');
INSERT INTO `activity_logs` VALUES (113, 4, 'arlynfernandez16', NULL, 'login', 'Admin user logged in successfully', 'Admin: Lalang2', '10.0.1.11', NULL, NULL, 'system', '2026-02-12 08:49:22', '2026-02-12 00:49:22');
INSERT INTO `activity_logs` VALUES (114, 4, 'Lalang2', NULL, 'logout', 'User logged out: lalang2', '', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', NULL, NULL, '2026-02-12 08:50:53', '2026-02-12 00:50:53');
INSERT INTO `activity_logs` VALUES (141, NULL, NULL, NULL, 'failed_login', 'Invalid password', 'Username: sierra.pacilan1', '10.0.1.11', NULL, NULL, 'system', '2026-02-15 06:42:02', '2026-02-14 22:42:02');

-- ----------------------------
-- Table structure for admin_users
-- ----------------------------
DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE `admin_users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `two_fa_enabled` tinyint(1) NULL DEFAULT 1,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `contact_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  `reset_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `reset_expires` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_users
-- ----------------------------
INSERT INTO `admin_users` VALUES (1, 'Sierra Pearl Pacilan', 'sierra.pacilan1', 'sierra.pacilan1@gmail.com', 1, '$2y$10$qwdd25JZaMk7.TQ9o41q7u8w5M54uqWwYCkdPmTTPiMQINV2uh64a', '0 9973 1902 16', '68db5c54bf59a.jpg', '2026-02-15 16:51:58', '2025-09-16 10:30:03', '2026-02-15 16:51:58', '259764', '2025-12-18 02:29:29');
INSERT INTO `admin_users` VALUES (2, 'Erwin Bartolome', 'Barts', 'erwinbartolome4@gmail.com', 1, '$2y$10$sk.6Jhj1CQo2N92Xt3pNwuY1ENTtBsnwbuxexhY25XCN3/GvT6FDG', '09560660652', 'admin_1764689321.jpg', NULL, '2025-12-02 15:28:41', '2025-12-02 15:28:41', NULL, NULL);
INSERT INTO `admin_users` VALUES (3, 'gsd', 'sgsd', 'wps@aldersgate.edu.ph', 1, '$2y$10$fyJhMNRZA1.ozTJjQECqU.HdeTgNyi8n8IWF8OpjrWsbrbIzeYh1i', 'gsdgsd', NULL, NULL, '2025-12-17 05:51:00', '2025-12-17 05:51:00', NULL, NULL);
INSERT INTO `admin_users` VALUES (4, 'Lalang2', 'lalang2', 'lalang2@gmail.com', 1, '$2y$10$jCCTPllAgNSnlyd7RcPqae9u6lbpD8n.6840GooqyAylvz2Deu0Va', '', NULL, '2026-02-12 00:50:53', '2025-12-23 07:48:49', '2026-02-12 00:50:53', NULL, NULL);

-- ----------------------------
-- Table structure for chat_logs
-- ----------------------------
DROP TABLE IF EXISTS `chat_logs`;
CREATE TABLE `chat_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `sender` enum('user','bot') CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `timestamp` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_logs
-- ----------------------------

-- ----------------------------
-- Table structure for developer
-- ----------------------------
DROP TABLE IF EXISTS `developer`;
CREATE TABLE `developer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `middle_initial` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `age` int(11) NOT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `course` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `birthday` date NULL DEFAULT NULL,
  `school` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of developer
-- ----------------------------
INSERT INTO `developer` VALUES (1, 'Christian Ace', 'C', 'Delfin', 23, 'Male', 'Bachelor of Science in Information Technology', '2002-07-10', 'Aldersgate College', '2026-01-20 16:18:38');
INSERT INTO `developer` VALUES (2, 'Erwin', 'D', 'Bartolome', 24, 'Male', 'Bachelor of Science in Information Technology', '2002-07-10', 'Aldersgate College', '2026-01-20 16:18:38');
INSERT INTO `developer` VALUES (3, 'Sierra Pearl', 'M', 'Pacilan', 24, 'Female', 'Bachelor of Science in Information Technology', '2002-07-10', 'Aldersgate College', '2026-01-20 16:18:38');

-- ----------------------------
-- Table structure for document_downloads
-- ----------------------------
DROP TABLE IF EXISTS `document_downloads`;
CREATE TABLE `document_downloads`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `document_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `document_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `downloaded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_document_downloads_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_downloads_user_doc`(`user_id` ASC, `document_type` ASC) USING BTREE,
  CONSTRAINT `document_downloads_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of document_downloads
-- ----------------------------
INSERT INTO `document_downloads` VALUES (1, NULL, 'MINUTES OF THE 27TH REGULAR SESSION', 'minute', 'uploads/68e7dc1ec0df5.jpg', '::1', '2025-10-13 16:12:06');

-- ----------------------------
-- Table structure for document_ocr_content
-- ----------------------------
DROP TABLE IF EXISTS `document_ocr_content`;
CREATE TABLE `document_ocr_content`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `document_type` enum('ordinance','resolution','meeting_minutes') CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT 'ordinance',
  `ocr_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_document`(`document_id` ASC, `document_type` ASC) USING BTREE,
  INDEX `idx_ocr_document`(`document_id` ASC, `document_type` ASC) USING BTREE,
  INDEX `idx_ocr_doc_type`(`document_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of document_ocr_content
-- ----------------------------
INSERT INTO `document_ocr_content` VALUES (6, 8, 'resolution', 'Republic of the Philippines \r\nProvince of Nueva Vizcaya  Municipality of Solano BARANGAY POBLACION SOUTH \r\n--OOOO—\r\nOFFICE OF THE SANGGUNIANG BARANGAY\r\nEXCERPTS FROM THE MINUTES OF THE 3I57 REGULAR SESSION OF THE\r\nSANGGUNIANG BARANGAY OF POBLACION SOUTH HELD ON MARCH 3, 2O25 FROM\r\n2:OO PM TO 3:3O PM HELD AT BARANGAY POBLACION SOUTH SESSION HALL.\r\nPRESENT:\r\nHON. MELCHOR E. MARZO Punong Barangay/PO\r\nHON. CARY GIL V. BASSI Sanguniang Barangay Member\r\nHON. JACKIE B. ABDULLAH Sanguniang Barangay Member\r\nHON. REYNALDO M. ROMANO Sanguniang Barangay Member\r\nHON. LUKE A. GATAN Sanguniang Barangay Member\r\nHON. KENNETH D. CEBALLOS Sanguniang Barangay Member\r\nHON. ROBELYN S. BAYANI Sanguniang Barangay Member O\r\nHON. ADELINA A. CALAJE Sanguniang Barangay Member\r\nHON. RAYMART E. FERNANDEZ SK Chairman\r\nARLYN D. FERNANDEZ Barangay Secretary\r\nNOVELITA R. BUSA Barangay Treasurer\r\nABSENT: NONE\r\n\r\nRESOLUTION NO. 8-S-2O24 3\r\nA RESOLUTION CERTIFYING THAT MR. CESAR L. BANTA AND MRS. g\r\nSOFIA H. BANTA HAVE REACHED THEIR 5O\" WEDDING ANNIVERSARY\r\n. AND HAVE BEEN LIVING TOGETHER AS COUPLE IN BARANGAY\r\nPOBLACION SOUTH, SOLANO, NUEVA VIZCAYA \r\n\r\n WHEREAS, the Sangguniang Panlalawigan of Nueva Vizcaya enacted Provincial Ordinance No. N~2O24-248, entitled “An Ordinance recognizing Married Couples celebrating their Golden Wedding Anniversary in the Province of Nueva Vizcaya, granting Benefits and Privileges therefor, and providing  funds thereof and for other purposes”, also known as the “Nueva Vizcaya Enduring Devotion Award\r\nOrdinance.\r\n\r\nWHEREAS, pursuant to Rule IV, Section 6 (b) of the IRR of Provincial Ordinance No. 2O24~\r\n248, this Sanggunian hereby certifies that Mr. Cesar L. Banta and Mrs. Sofia H. Banta have been living\r\ntogether harmoniously in this Barangay; \r\n\r\nWHEREAS, the couple is included in the Registry of Barangay Inhabitants (RBI) of Barangay\r\nPoblacion South, Solano, Nueva Vizcaya:\r\n\r\nNOW, THEREFORE, on motion of Hon. Luke A. Gatan, duly seconded by Hon. Adelina A. Calaje, be it:\r\n\r\nRESOLVED, as it is hereby resolved to certify that Mr. Cesar L. Banta and Mrs. Sofia H. Banta\r\nhave been living together in Barangay Poblacion South, Solano, Nueva Vizcaya.\r\n\r\nRESOLVED, FURTHER, that a copy of this Resolution be forwarded to Mr. and Mrs. Cesar L.\r\nBanta, for their information and appropriate action.\r\n\r\nCARRIED.\r\n\r\nI HEREBY CERTIFY to the correctness of the above foregoing Resolution.\r\n\r\nARLYNX D. FERNANDEZ\r\nBarangay Secretary\r\n\r\nATTESTTED BY:\r\nHON. CARY GIL V.  BASSI\r\nSangguniang Barangay Member \r\n\r\nHON.  JACKIE B. ABDULLAH\r\nSangguniang Barangay Member\r\n\r\nHON. REYNALDO M. ROMANO \r\nSangguniang Barangay Member\r\n\r\nHON. LUKE A. GATAN\r\nSangguniang Barangay Member\r\n\r\nHON. KENNETH D. CEBALLOS \r\nSangguniang Barangay Member\r\n\r\nHON. ROBELYN S. BAYANI\r\nSangguniang Bargngay Member\r\n\r\nHON. ADELINA. CALAJE\r\nSangguniang Barangay Member\r\n\r\nHON. RAYMART E. FERNANDEZ\r\nSangguniang Kabataan Chairman\r\n\r\nI APPROVED:\r\n\r\nHON. MELCHOR MARZO\r\nPunong Barangay', '2026-01-07 11:29:17', '2026-01-07 11:29:17');

-- ----------------------------
-- Table structure for login_logs
-- ----------------------------
DROP TABLE IF EXISTS `login_logs`;
CREATE TABLE `login_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `login_time` datetime NULL DEFAULT current_timestamp(),
  `status` enum('SUCCESS','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `user_role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_login_time`(`login_time` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_ip`(`ip_address` ASC) USING BTREE,
  INDEX `idx_login_logs_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_login_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `fk_login_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of login_logs
-- ----------------------------
INSERT INTO `login_logs` VALUES (1, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-02 23:15:46', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (2, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-03 01:52:46', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (3, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-03 01:57:09', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (4, 'erwin_staff', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-03 01:58:43', 'SUCCESS', 'Staff login', NULL, 'staff');
INSERT INTO `login_logs` VALUES (5, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-03 02:19:29', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (6, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-03 04:40:41', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (7, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-03 04:56:20', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (8, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-04 01:28:32', 'FAILED', 'Invalid admin password', NULL, NULL);
INSERT INTO `login_logs` VALUES (9, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-04 01:28:40', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (10, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-04 01:29:51', 'FAILED', 'Invalid admin password', NULL, NULL);
INSERT INTO `login_logs` VALUES (11, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-04 01:30:01', 'FAILED', 'Invalid admin password', NULL, NULL);
INSERT INTO `login_logs` VALUES (12, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-04 01:30:15', 'SUCCESS', 'Admin login', NULL, 'admin');
INSERT INTO `login_logs` VALUES (13, 'admin_ace', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-04 01:46:23', 'SUCCESS', 'Staff login', 5, 'admin');
INSERT INTO `login_logs` VALUES (17, 'lalang2', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-09 13:28:07', 'SUCCESS', 'Admin login', 4, 'admin');
INSERT INTO `login_logs` VALUES (21, 'lalang2', '10.0.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-12 08:49:22', 'SUCCESS', 'Admin login', 4, 'admin');
INSERT INTO `login_logs` VALUES (27, 'sierra.pacilan1', '10.0.1.11', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '2026-02-15 06:42:02', 'FAILED', 'Invalid admin password', NULL, NULL);

-- ----------------------------
-- Table structure for minutes_of_meeting
-- ----------------------------
DROP TABLE IF EXISTS `minutes_of_meeting`;
CREATE TABLE `minutes_of_meeting`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `date_posted` date NOT NULL,
  `meeting_date` date NOT NULL,
  `session_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `reference_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `status` enum('Active','Inactive','Pending','Approved','Rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL DEFAULT 'Active',
  `uploaded_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  FULLTEXT INDEX `ft_minutes_search`(`title`, `content`, `session_number`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of minutes_of_meeting
-- ----------------------------
INSERT INTO `minutes_of_meeting` VALUES (1, 'Techmology Process p', '=3\r\n=\r\n= 43\r\n\r\n---\r\n\r\nPeople\r\nTechmology Process p\r\nUnclear inventory Lack of training for\r\nSystem bugs or downtime procedures harmacy saft\r\nInadequatehardware I PoOr s racing methods Y\\ Limited ITknowledge\r\n(slow machines) among users\r\nDelayed data entry or updates\r\nCompatiiltyissues with 4 v or e Resistance to technology\r\nolder devices U N oion\r\no standardized repo uman error in data input —\r\nInternet connectivity problems - Inefficient\r\nPharmacy System\r\nUnoptimized user interface ——p Incorrectinventory Power interruptions Performance\r\nLimited hatbot Duplicste medicine et empersre\r\nfunctionality P damaging dvices\r\nSlowloading times A— foor lighting or cramped\r\nIncomplete feature workspace\r\nintegration —/Expired stock not lagged e/’ No IT supportin rural\r\nSoftware\r\nData Environment\r\n\r\n---', 'https://minio-gckgwk48ccskg4ogswwgk88s.craftmatrix.org/efind-documents/minutes/2026/02/6982a151ee74a_1770168657_0.jpg|https://minio-gckgwk48ccskg4ogswwgk88s.craftmatrix.org/efind-documents/minutes/2026/02/6982a15232bf1_1770168658_1.PNG', '2026-02-04', '2026-02-04', '65', 'MOM2026020001', 'Active', NULL);

-- ----------------------------
-- Table structure for ordinances
-- ----------------------------
DROP TABLE IF EXISTS `ordinances`;
CREATE TABLE `ordinances`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `ordinance_date` datetime NULL DEFAULT NULL,
  `date_posted` timestamp NULL DEFAULT NULL,
  `ordinance_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `date_issued` date NOT NULL,
  `date_approved` date NULL DEFAULT NULL,
  `image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `document_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `views` int(11) NOT NULL DEFAULT 0,
  `downloads` int(11) NOT NULL DEFAULT 0,
  `reference_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `ocr_status` enum('pending','processed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT 'pending',
  `ocr_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `ocr_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `uploaded_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ordinances_uploaded_by`(`uploaded_by`(100) ASC) USING BTREE,
  FULLTEXT INDEX `title`(`title`, `reference_number`, `description`),
  FULLTEXT INDEX `content`(`content`),
  FULLTEXT INDEX `content_2`(`content`),
  FULLTEXT INDEX `ocr_content`(`ocr_content`),
  FULLTEXT INDEX `title_2`(`title`, `description`, `content`),
  FULLTEXT INDEX `title_3`(`title`, `reference_number`, `content`),
  FULLTEXT INDEX `fulltext_search`(`title`, `reference_number`, `ordinance_number`, `content`),
  FULLTEXT INDEX `title_4`(`title`, `reference_number`, `content`),
  FULLTEXT INDEX `title_5`(`title`, `reference_number`, `content`),
  FULLTEXT INDEX `ft_ordinances_search`(`title`, `reference_number`, `ordinance_number`, `content`, `ocr_content`)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordinances
-- ----------------------------

-- ----------------------------
-- Table structure for resolutions
-- ----------------------------
DROP TABLE IF EXISTS `resolutions`;
CREATE TABLE `resolutions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `resolution_date` datetime NULL DEFAULT NULL,
  `resolution_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT 'Active',
  `date_issued` date NOT NULL,
  `date_approved` datetime NULL DEFAULT NULL,
  `image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `date_posted` date NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `views` int(11) NOT NULL DEFAULT 0,
  `downloads` int(11) NOT NULL DEFAULT 0,
  `reference_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `updated_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `uploaded_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_resolutions_uploaded_by`(`uploaded_by`(100) ASC) USING BTREE,
  FULLTEXT INDEX `title`(`title`, `reference_number`, `description`),
  FULLTEXT INDEX `title_2`(`title`, `description`, `content`),
  FULLTEXT INDEX `title_3`(`title`, `reference_number`, `content`),
  FULLTEXT INDEX `title_4`(`title`, `reference_number`, `content`),
  FULLTEXT INDEX `title_5`(`title`, `reference_number`, `content`),
  FULLTEXT INDEX `ft_resolutions_search`(`title`, `reference_number`, `resolution_number`, `content`)
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resolutions
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `contact_number` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NULL DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_users_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (4, 'Arlyn Dawa Fernandez', '09161691871', 'eurellouielyn.12@gmail.com', 'arlynfernandez16', '$2y$10$JPkV7Yc7Q8y7b8QT1Clsd.Hixq8Z1BTvDXPdhh9KOhSxJEuf0GcqC', 'admin', '', '2026-01-20 02:32:33', '2026-01-20 02:31:39', '2026-01-20 02:32:33');
INSERT INTO `users` VALUES (5, 'Christian Ace C. Delfin', '09654315748', 'eys.acads@gmail.com', 'admin_ace', '$2y$10$nVNOgbqrAH.Mf2yMrFSC2eVwQLz5Aix7Hcs5AMP7XhxBxqNW57xEi', 'admin', '', '2026-02-04 01:47:01', '2026-02-04 01:43:21', '2026-02-04 01:47:01');

-- ----------------------------
-- View structure for document_statistics
-- ----------------------------
DROP VIEW IF EXISTS `document_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `document_statistics` AS select 'ordinance' AS `document_type`,count(0) AS `total_count`,sum(`ordinances`.`views`) AS `total_views`,sum(`ordinances`.`downloads`) AS `total_downloads`,max(`ordinances`.`date_posted`) AS `latest_post` from `ordinances` where `ordinances`.`status` = 'Active' union all select 'resolution' AS `document_type`,count(0) AS `total_count`,sum(`resolutions`.`views`) AS `total_views`,sum(`resolutions`.`downloads`) AS `total_downloads`,max(`resolutions`.`date_posted`) AS `latest_post` from `resolutions` where `resolutions`.`status` = 'Active' union all select 'minutes' AS `document_type`,count(0) AS `total_count`,0 AS `total_views`,0 AS `total_downloads`,max(`minutes_of_meeting`.`date_posted`) AS `latest_post` from `minutes_of_meeting` where `minutes_of_meeting`.`status` = 'Active';

-- ----------------------------
-- View structure for user_activity_summary
-- ----------------------------
DROP VIEW IF EXISTS `user_activity_summary`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `user_activity_summary` AS select `u`.`id` AS `user_id`,`u`.`full_name` AS `full_name`,`u`.`username` AS `username`,`u`.`role` AS `role`,count(distinct `a`.`id`) AS `total_actions`,count(distinct `d`.`id`) AS `total_downloads`,max(`u`.`last_login`) AS `last_login`,count(distinct `l`.`id`) AS `total_logins` from (((`users` `u` left join `activity_logs` `a` on(`u`.`id` = `a`.`user_id`)) left join `document_downloads` `d` on(`u`.`id` = `d`.`user_id`)) left join `login_logs` `l` on(`u`.`id` = `l`.`user_id` and `l`.`status` = 'SUCCESS')) group by `u`.`id`,`u`.`full_name`,`u`.`username`,`u`.`role`;

-- ----------------------------
-- View structure for vw_uploaders_complete
-- ----------------------------
DROP VIEW IF EXISTS `vw_uploaders_complete`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `vw_uploaders_complete` AS select `all_uploaders`.`uploader_id` AS `uploader_id`,`all_uploaders`.`username` AS `username`,`all_uploaders`.`full_name` AS `full_name`,`all_uploaders`.`email` AS `email`,`all_uploaders`.`user_role` AS `user_role`,`all_uploaders`.`source_table` AS `source_table`,`all_uploaders`.`profile_picture` AS `profile_picture`,`all_uploaders`.`contact_number` AS `contact_number`,`all_uploaders`.`last_login` AS `last_login`,`all_uploaders`.`ordinances_count` AS `ordinances_count`,`all_uploaders`.`resolutions_count` AS `resolutions_count`,`all_uploaders`.`minutes_count` AS `minutes_count`,`all_uploaders`.`total_views_generated` AS `total_views_generated`,`all_uploaders`.`total_downloads_generated` AS `total_downloads_generated` from (select `u`.`id` AS `uploader_id`,`u`.`username` AS `username`,`u`.`full_name` AS `full_name`,`u`.`email` AS `email`,`u`.`role` AS `user_role`,'users' AS `source_table`,`u`.`profile_picture` AS `profile_picture`,`u`.`contact_number` AS `contact_number`,`u`.`last_login` AS `last_login`,(select count(0) from `ordinances` where `ordinances`.`uploaded_by` = `u`.`username`) AS `ordinances_count`,(select count(0) from `resolutions` where `resolutions`.`uploaded_by` = `u`.`username`) AS `resolutions_count`,(select count(0) from `minutes_of_meeting` where `minutes_of_meeting`.`uploaded_by` = `u`.`username`) AS `minutes_count`,coalesce((select sum(`ordinances`.`views`) from `ordinances` where `ordinances`.`uploaded_by` = `u`.`username`),0) + coalesce((select sum(`resolutions`.`views`) from `resolutions` where `resolutions`.`uploaded_by` = `u`.`username`),0) AS `total_views_generated`,coalesce((select sum(`ordinances`.`downloads`) from `ordinances` where `ordinances`.`uploaded_by` = `u`.`username`),0) + coalesce((select sum(`resolutions`.`downloads`) from `resolutions` where `resolutions`.`uploaded_by` = `u`.`username`),0) AS `total_downloads_generated` from `users` `u` union select `au`.`id` AS `uploader_id`,`au`.`username` AS `username`,`au`.`full_name` AS `full_name`,`au`.`email` AS `email`,'admin' AS `user_role`,'admin_users' AS `source_table`,`au`.`profile_picture` AS `profile_picture`,`au`.`contact_number` AS `contact_number`,`au`.`last_login` AS `last_login`,(select count(0) from `ordinances` where `ordinances`.`uploaded_by` = `au`.`username`) AS `ordinances_count`,(select count(0) from `resolutions` where `resolutions`.`uploaded_by` = `au`.`username`) AS `resolutions_count`,(select count(0) from `minutes_of_meeting` where `minutes_of_meeting`.`uploaded_by` = `au`.`username`) AS `minutes_count`,coalesce((select sum(`ordinances`.`views`) from `ordinances` where `ordinances`.`uploaded_by` = `au`.`username`),0) + coalesce((select sum(`resolutions`.`views`) from `resolutions` where `resolutions`.`uploaded_by` = `au`.`username`),0) AS `total_views_generated`,coalesce((select sum(`ordinances`.`downloads`) from `ordinances` where `ordinances`.`uploaded_by` = `au`.`username`),0) + coalesce((select sum(`resolutions`.`downloads`) from `resolutions` where `resolutions`.`uploaded_by` = `au`.`username`),0) AS `total_downloads_generated` from `admin_users` `au`) `all_uploaders`;

-- ----------------------------
-- View structure for vw_user_documents
-- ----------------------------
DROP VIEW IF EXISTS `vw_user_documents`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `vw_user_documents` AS select `u`.`id` AS `user_id`,`u`.`username` AS `username`,`u`.`full_name` AS `full_name`,`u`.`role` AS `role`,`u`.`profile_picture` AS `profile_picture`,`u`.`last_login` AS `last_login`,json_object('ordinances',(select json_arrayagg(json_object('id',`o`.`id`,'title',`o`.`title`,'ordinance_number',`o`.`ordinance_number`,'reference_number',`o`.`reference_number`,'uploaded_date',`o`.`created_at`,'views',`o`.`views`,'downloads',`o`.`downloads`,'status',`o`.`status`)) from `ordinances` `o` where `o`.`uploaded_by` = `u`.`username` and `o`.`status` = 'Active'),'resolutions',(select json_arrayagg(json_object('id',`r`.`id`,'title',`r`.`title`,'resolution_number',`r`.`resolution_number`,'reference_number',`r`.`reference_number`,'uploaded_date',`r`.`created_at`,'views',`r`.`views`,'downloads',`r`.`downloads`,'status',`r`.`status`)) from `resolutions` `r` where `r`.`uploaded_by` = `u`.`username` and `r`.`status` = 'Active'),'minutes',(select json_arrayagg(json_object('id',`m`.`id`,'title',`m`.`title`,'session_number',`m`.`session_number`,'reference_number',`m`.`reference_number`,'meeting_date',`m`.`meeting_date`,'uploaded_date',`m`.`date_posted`,'status',`m`.`status`)) from `minutes_of_meeting` `m` where `m`.`uploaded_by` = `u`.`username` and `m`.`status` = 'Active')) AS `documents_uploaded`,(select count(0) from `ordinances` `o` where `o`.`uploaded_by` = `u`.`username` and `o`.`status` = 'Active') AS `total_ordinances`,(select count(0) from `resolutions` `r` where `r`.`uploaded_by` = `u`.`username` and `r`.`status` = 'Active') AS `total_resolutions`,(select count(0) from `minutes_of_meeting` `m` where `m`.`uploaded_by` = `u`.`username` and `m`.`status` = 'Active') AS `total_minutes`,coalesce((select sum(`ordinances`.`views`) from `ordinances` where `ordinances`.`uploaded_by` = `u`.`username`),0) + coalesce((select sum(`resolutions`.`views`) from `resolutions` where `resolutions`.`uploaded_by` = `u`.`username`),0) AS `total_document_views`,coalesce((select sum(`ordinances`.`downloads`) from `ordinances` where `ordinances`.`uploaded_by` = `u`.`username`),0) + coalesce((select sum(`resolutions`.`downloads`) from `resolutions` where `resolutions`.`uploaded_by` = `u`.`username`),0) AS `total_document_downloads` from `users` `u` where `u`.`role` <> 'guest' order by `u`.`full_name`;

-- ----------------------------
-- Function structure for fn_get_uploader_info
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_get_uploader_info`;
delimiter ;;
CREATE FUNCTION `fn_get_uploader_info`(p_username VARCHAR(255))
 RETURNS text CHARSET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci
  READS SQL DATA 
  DETERMINISTIC
BEGIN
    DECLARE v_full_name VARCHAR(255);
    DECLARE v_email VARCHAR(100);
    DECLARE v_role VARCHAR(50);
    DECLARE v_source_table VARCHAR(50);
    
    -- Try to find in users table first
    SELECT full_name, email, role, 'users'
    INTO v_full_name, v_email, v_role, v_source_table
    FROM users 
    WHERE username = p_username;
    
    -- If not found, try admin_users table
    IF v_full_name IS NULL THEN
        SELECT full_name, email, 'admin', 'admin_users'
        INTO v_full_name, v_email, v_role, v_source_table
        FROM admin_users 
        WHERE username = p_username;
    END IF;
    
    -- Return formatted info
    IF v_full_name IS NOT NULL THEN
        RETURN CONCAT(
            'Name: ', v_full_name,
            ' | Email: ', COALESCE(v_email, 'N/A'),
            ' | Role: ', v_role,
            ' | Source: ', v_source_table
        );
    ELSE
        RETURN 'Uploader not found in system';
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for GetDocumentRelationships
-- ----------------------------
DROP PROCEDURE IF EXISTS `GetDocumentRelationships`;
delimiter ;;
CREATE PROCEDURE `GetDocumentRelationships`(IN doc_id INT, IN doc_type VARCHAR(50))
BEGIN
    -- Get document details based on type
    CASE doc_type
        WHEN 'ordinance' THEN
            SELECT 
                'ordinance' AS document_type,
                o.*,
                u.full_name AS uploaded_by_name,
                u.email AS uploaded_by_email
            FROM ordinances o
            LEFT JOIN users u ON o.uploaded_by = u.username
            WHERE o.id = doc_id;
            
            -- Get related OCR content
            SELECT * FROM document_ocr_content 
            WHERE document_id = doc_id AND document_type = 'ordinance';
            
            -- Get activity logs
            SELECT * FROM activity_logs 
            WHERE document_id = doc_id AND document_type = 'ordinance'
            ORDER BY log_time DESC;
            
        WHEN 'resolution' THEN
            SELECT 
                'resolution' AS document_type,
                r.*,
                u.full_name AS uploaded_by_name,
                u.email AS uploaded_by_email
            FROM resolutions r
            LEFT JOIN users u ON r.uploaded_by = u.username
            WHERE r.id = doc_id;
            
            -- Get related OCR content
            SELECT * FROM document_ocr_content 
            WHERE document_id = doc_id AND document_type = 'resolution';
            
            -- Get activity logs
            SELECT * FROM activity_logs 
            WHERE document_id = doc_id AND document_type = 'resolution'
            ORDER BY log_time DESC;
            
        WHEN 'minute' THEN
            SELECT 
                'minute' AS document_type,
                m.*,
                u.full_name AS uploaded_by_name,
                u.email AS uploaded_by_email
            FROM minutes_of_meeting m
            LEFT JOIN users u ON m.uploaded_by = u.username
            WHERE m.id = doc_id;
            
            -- Get related OCR content
            SELECT * FROM document_ocr_content 
            WHERE document_id = doc_id AND document_type = 'meeting_minutes';
            
            -- Get activity logs
            SELECT * FROM activity_logs 
            WHERE document_id = doc_id AND document_type = 'minute'
            ORDER BY log_time DESC;
            
    END CASE;
    
    -- Get document chunks for RAG
    SELECT * FROM document_chunks 
    WHERE document_id = doc_id AND document_type = doc_type
    ORDER BY chunk_index;
    
    -- Get download history
    SELECT * FROM document_downloads 
    WHERE document_title LIKE CONCAT('%', 
        (SELECT title FROM (
            SELECT title FROM ordinances WHERE id = doc_id AND doc_type = 'ordinance'
            UNION ALL
            SELECT title FROM resolutions WHERE id = doc_id AND doc_type = 'resolution'
            UNION ALL
            SELECT title FROM minutes_of_meeting WHERE id = doc_id AND doc_type = 'minute'
        ) AS doc_titles
    ), '%')
    AND document_type = doc_type;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table activity_logs
-- ----------------------------
DROP TRIGGER IF EXISTS `increment_ordinance_views`;
delimiter ;;
CREATE TRIGGER `increment_ordinance_views` AFTER INSERT ON `activity_logs` FOR EACH ROW BEGIN
    IF NEW.document_type = 'ordinance' AND NEW.action = 'VIEW' THEN
        UPDATE ordinances 
        SET views = views + 1 
        WHERE id = NEW.document_id;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table activity_logs
-- ----------------------------
DROP TRIGGER IF EXISTS `increment_resolution_views`;
delimiter ;;
CREATE TRIGGER `increment_resolution_views` AFTER INSERT ON `activity_logs` FOR EACH ROW BEGIN
    IF NEW.document_type = 'resolution' AND NEW.action = 'VIEW' THEN
        UPDATE resolutions 
        SET views = views + 1 
        WHERE id = NEW.document_id;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table document_downloads
-- ----------------------------
DROP TRIGGER IF EXISTS `increment_ordinance_downloads`;
delimiter ;;
CREATE TRIGGER `increment_ordinance_downloads` AFTER INSERT ON `document_downloads` FOR EACH ROW BEGIN
    IF NEW.document_type = 'ordinance' THEN
        UPDATE ordinances 
        SET downloads = downloads + 1 
        WHERE title LIKE CONCAT('%', NEW.document_title, '%')
        OR id = (SELECT document_id FROM activity_logs 
                 WHERE id = (SELECT MAX(id) FROM activity_logs 
                            WHERE user_id = NEW.user_id 
                            AND action = 'DOWNLOAD' 
                            AND document_type = 'ordinance'));
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
