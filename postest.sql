/*
 Navicat Premium Data Transfer

 Source Server         : Mysql-langkok
 Source Server Type    : MySQL
 Source Server Version : 80035
 Source Host           : localhost:3304
 Source Schema         : postest

 Target Server Type    : MySQL
 Target Server Version : 80035
 File Encoding         : 65001

 Date: 01/07/2024 08:17:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for carts
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int UNSIGNED NULL DEFAULT NULL,
  `product_id` int UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `qty` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `carts_user_id_foreign`(`user_id`) USING BTREE,
  INDEX `carts_product_id_foreign`(`product_id`) USING BTREE,
  CONSTRAINT `carts_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `carts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carts
-- ----------------------------

-- ----------------------------
-- Table structure for detail_orders
-- ----------------------------
DROP TABLE IF EXISTS `detail_orders`;
CREATE TABLE `detail_orders`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` int UNSIGNED NULL DEFAULT NULL,
  `product_id` int NULL DEFAULT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int NOT NULL,
  `price` int NOT NULL,
  `product_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `per_total_price` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `detail_orders_order_id_foreign`(`order_id`) USING BTREE,
  CONSTRAINT `detail_orders_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of detail_orders
-- ----------------------------

-- ----------------------------
-- Table structure for failed_jobs
-- ----------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `failed_jobs_uuid_unique`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of failed_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of migrations
-- ----------------------------
INSERT INTO `migrations` VALUES (1, '2014_10_12_000000_create_users_table', 1);
INSERT INTO `migrations` VALUES (2, '2014_10_12_100000_create_password_resets_table', 1);
INSERT INTO `migrations` VALUES (3, '2019_08_19_000000_create_failed_jobs_table', 1);
INSERT INTO `migrations` VALUES (4, '2019_12_14_000001_create_personal_access_tokens_table', 1);
INSERT INTO `migrations` VALUES (5, '2024_06_27_155008_create_product_table', 1);
INSERT INTO `migrations` VALUES (6, '2024_06_27_155018_create_orders_table', 1);
INSERT INTO `migrations` VALUES (7, '2024_06_27_155021_create_detail_orders_table', 1);
INSERT INTO `migrations` VALUES (8, '2024_06_28_013412_create_carts_table', 1);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int UNSIGNED NULL DEFAULT NULL,
  `order_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_price` bigint NOT NULL,
  `end_paid` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `orders_user_id_foreign`(`user_id`) USING BTREE,
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------

-- ----------------------------
-- Table structure for password_resets
-- ----------------------------
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets`  (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of password_resets
-- ----------------------------

-- ----------------------------
-- Table structure for personal_access_tokens
-- ----------------------------
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `personal_access_tokens_token_unique`(`token`) USING BTREE,
  INDEX `personal_access_tokens_tokenable_type_tokenable_id_index`(`tokenable_type`, `tokenable_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of personal_access_tokens
-- ----------------------------

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int UNSIGNED NULL DEFAULT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `price` int NOT NULL,
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `products_user_id_foreign`(`user_id`) USING BTREE,
  CONSTRAINT `products_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (8, 1, 'Cold Brew', 'Cold Brew', 2, 'drink', 'img_1719680952.jpg', '2024-06-29 16:56:45', '2024-06-29 17:09:12');
INSERT INTO `products` VALUES (9, 1, 'Kopi Susu', NULL, 1, 'drink', 'img_1719681570.png', '2024-06-29 17:14:43', '2024-06-29 17:19:30');
INSERT INTO `products` VALUES (10, 1, 'Macchiato', NULL, 1, 'drink', 'img_1719681700.webp', '2024-06-29 17:21:40', '2024-06-29 17:21:40');
INSERT INTO `products` VALUES (11, 1, 'Cappucino', NULL, 2, 'drink', 'img_1719717392.webp', '2024-06-29 17:23:24', '2024-06-30 03:16:32');
INSERT INTO `products` VALUES (12, 1, 'Latte', NULL, 2, 'drink', 'img_1719681899.jpg', '2024-06-29 17:24:59', '2024-06-29 17:24:59');
INSERT INTO `products` VALUES (13, 1, 'Expresso', NULL, 2, 'drink', 'img_1719681925.jpg', '2024-06-29 17:25:25', '2024-06-29 17:25:25');
INSERT INTO `products` VALUES (14, 1, 'Americano', NULL, 1, 'drink', 'img_1719681994.webp', '2024-06-29 17:26:34', '2024-06-29 17:26:34');
INSERT INTO `products` VALUES (15, 1, 'Mocha', NULL, 3, 'drink', 'img_1719682055.jpg', '2024-06-29 17:27:35', '2024-06-29 17:27:35');
INSERT INTO `products` VALUES (16, 1, 'Affogato', NULL, 5, 'drink', 'img_1719682094.jpg', '2024-06-29 17:28:14', '2024-06-29 17:28:14');
INSERT INTO `products` VALUES (17, 1, 'Flat White', NULL, 3, 'drink', 'img_1719682165.jpg', '2024-06-29 17:29:25', '2024-06-29 17:29:25');
INSERT INTO `products` VALUES (18, 1, 'Mushroom Enoki', NULL, 2, 'food', 'img_1719682209.webp', '2024-06-29 17:30:09', '2024-06-29 17:30:09');
INSERT INTO `products` VALUES (19, 1, 'Kentang Thailand', NULL, 2, 'food', 'img_1719682232.webp', '2024-06-29 17:30:32', '2024-06-29 17:30:32');
INSERT INTO `products` VALUES (20, 1, 'Martabak Mie', NULL, 2, 'food', 'img_1719682252.webp', '2024-06-29 17:30:52', '2024-06-29 17:30:52');
INSERT INTO `products` VALUES (21, 1, 'Chicken Crispy', NULL, 4, 'food', 'img_1719682278.webp', '2024-06-29 17:31:18', '2024-06-29 17:31:18');
INSERT INTO `products` VALUES (22, 1, 'Chicken Finger', NULL, 3, 'food', 'img_1719682307.webp', '2024-06-29 17:31:47', '2024-06-29 17:31:47');
INSERT INTO `products` VALUES (23, 1, 'Onion Ring', NULL, 2, 'food', 'img_1719682331.webp', '2024-06-29 17:32:11', '2024-06-29 17:32:11');
INSERT INTO `products` VALUES (24, 1, 'Siomay', NULL, 2, 'food', 'img_1719682355.webp', '2024-06-29 17:32:35', '2024-06-29 17:32:35');
INSERT INTO `products` VALUES (25, 1, 'Pisang Bakar', NULL, 2, 'food', 'img_1719682375.webp', '2024-06-29 17:32:55', '2024-06-29 17:32:55');
INSERT INTO `products` VALUES (26, 1, 'Roti Bakar', NULL, 2, 'food', 'img_1719682391.webp', '2024-06-29 17:33:11', '2024-06-29 17:33:11');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `role` int NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_username_unique`(`username`) USING BTREE,
  UNIQUE INDEX `users_email_unique`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'Admin', 'admin', 'admin@mail.com', NULL, 1, NULL, '$2y$10$w1nvIxWqYtZSOpojwOKlAugOi1MUr7oUjVVEFg0U5yndHiMQm9WyO', NULL, '2024-06-28 01:55:38', '2024-07-01 00:45:40');
INSERT INTO `users` VALUES (2, 'Testing', 'testing', 'testing@mail.com', 'img_1719542453.jpg', 2, NULL, '$2y$10$hrJe0W1mlJGwu3M5Upvi8.q3//pwMUuOJqFX3eSMqEXyMpVAXaCGm', NULL, '2024-06-28 02:21:33', '2024-07-01 00:47:19');

SET FOREIGN_KEY_CHECKS = 1;
