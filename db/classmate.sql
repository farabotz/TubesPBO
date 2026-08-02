-- CLASSMATE (TubesPBO) - MySQL schema for XAMPP
-- Import via phpMyAdmin: http://localhost/phpmyadmin

CREATE DATABASE IF NOT EXISTS classmate
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE classmate;

-- USERS
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  peran ENUM('ADMIN','MAHASISWA') NOT NULL,
  nim VARCHAR(30) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ROOMS
CREATE TABLE IF NOT EXISTS rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  kapasitas INT NOT NULL,
  lokasi VARCHAR(100) NOT NULL,
  tersedia TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- BOOKING REQUESTS / TRANSAKSI PEMINJAMAN
CREATE TABLE IF NOT EXISTS bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  room_id INT NOT NULL,
  waktu_mulai DATETIME NOT NULL,
  waktu_selesai DATETIME NOT NULL,
  keperluan VARCHAR(255) NOT NULL,
  status ENUM('PENDING','APPROVED','REJECTED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  alasan VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_bookings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_bookings_room FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE RESTRICT,
  INDEX idx_bookings_room_time (room_id, waktu_mulai, waktu_selesai),
  INDEX idx_bookings_user (user_id)
) ENGINE=InnoDB;

-- NOTIFICATIONS (in-app / email-queue)
CREATE TABLE IF NOT EXISTS notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  channel ENUM('APP','EMAIL') NOT NULL,
  message VARCHAR(500) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP NULL DEFAULT NULL,
  CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_notifications_user (user_id, created_at)
) ENGINE=InnoDB;

-- Seed: default admin (email: admin@classmate.local, password: admin123)
INSERT INTO users (nama, email, password_hash, peran, nim)
SELECT 'Admin', 'admin@classmate.local', 'pbkdf2$120000$A+4FY4dwyjw/kKQCvAC07g==$hP33Ms3aeYtzJNYS7BZRRt9+nYCEjREsuVrJdWzBA70=', 'ADMIN', NULL
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='admin@classmate.local');

-- Seed: sample room
INSERT INTO rooms (nama, kapasitas, lokasi, tersedia)
SELECT 'Ruang 101', 30, 'Gedung A', 1
WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE nama='Ruang 101');
