-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 29, 2025 at 02:17 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `classmate`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `waktu_mulai` datetime NOT NULL,
  `waktu_selesai` datetime NOT NULL,
  `keperluan` varchar(255) NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `alasan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `user_id`, `room_id`, `waktu_mulai`, `waktu_selesai`, `keperluan`, `status`, `alasan`, `created_at`, `updated_at`) VALUES
(1, 2, 1, '2025-12-14 09:00:00', '2025-12-14 13:00:00', 'Kuliah Pengganti', 'APPROVED', 'Patuhi Peraturan didalam Lab', '2025-12-14 16:55:10', '2025-12-14 17:03:23'),
(2, 2, 2, '2025-12-14 09:00:00', '2025-12-14 10:00:00', 'Rapat Organisasi Seni Budaya', 'CANCELLED', 'Ingin Mengganti Hari', '2025-12-14 16:58:28', '2025-12-14 17:01:41'),
(3, 2, 2, '2025-12-15 09:00:00', '2025-12-15 10:00:00', 'Kelas Pengganti Perkuliahan', 'APPROVED', 'Jangan Melewati Batas Jam', '2025-12-14 17:02:09', '2025-12-14 17:06:26'),
(4, 2, 2, '2025-12-24 10:45:00', '2025-12-24 13:15:00', 'Rapat UKM', 'REJECTED', 'Tidak Boleh ', '2025-12-14 17:05:25', '2025-12-15 03:52:27'),
(5, 2, 3, '2025-12-15 11:00:00', '2025-12-15 14:45:00', 'Pengerjaan Tugas Besar', 'APPROVED', '', '2025-12-15 03:44:01', '2025-12-15 03:44:22'),
(6, 2, 3, '2025-12-16 07:45:00', '2025-12-16 20:45:00', 'Nonton Film Bareng', 'APPROVED', '', '2025-12-15 03:54:06', '2025-12-15 03:54:40'),
(7, 4, 3, '2025-12-14 10:00:00', '2025-12-14 13:00:00', 'Rapat Organisasi', 'CANCELLED', 'Pergantian Hari', '2025-12-15 04:57:38', '2025-12-15 04:58:06'),
(8, 4, 3, '2025-12-17 14:00:00', '2025-12-17 16:00:00', 'Kuliah Pengganti', 'APPROVED', 'Siap Gas', '2025-12-15 05:00:02', '2025-12-15 05:03:10'),
(9, 4, 1, '2025-12-17 09:00:00', '2025-12-17 10:00:00', 'Rapat Penting', 'APPROVED', 'Widih', '2025-12-15 05:22:40', '2025-12-15 05:23:04'),
(10, 5, 4, '2026-01-01 09:15:00', '2026-01-01 10:00:00', 'Rapat Organisasi', 'PENDING', NULL, '2025-12-28 14:30:28', NULL),
(11, 6, 2, '2025-12-28 09:00:00', '2025-12-28 10:00:00', 'Rapat Organisasi', 'CANCELLED', 'Ingin mengganti hari', '2025-12-28 14:47:53', '2025-12-28 14:48:48'),
(12, 6, 4, '2025-12-28 09:00:00', '2025-12-28 10:00:00', 'Kuliah Pengganti', 'APPROVED', '', '2025-12-28 14:49:52', '2025-12-28 14:55:38');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `channel` enum('APP','EMAIL') NOT NULL,
  `message` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `read_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `channel`, `message`, `created_at`, `read_at`) VALUES
(1, 1, 'APP', '🆕 Pengajuan peminjaman baru (#11) dari M. Afriza Hidayat untuk Kelas 3.002 (Gedung B Lantai 3) pada 28/12/2025 09:00 - 28/12/2025 10:00.', '2025-12-28 14:47:53', NULL),
(2, 6, 'APP', 'Booking dibatalkan. Ingin mengganti hari', '2025-12-28 14:48:48', NULL),
(3, 1, 'APP', '🆕 Pengajuan peminjaman baru (#12) dari M. Afriza Hidayat untuk Kelas 4.03 (Gedung B Lantai 4) pada 28/12/2025 09:00 - 28/12/2025 10:00.', '2025-12-28 14:49:52', NULL),
(4, 6, 'APP', 'Booking disetujui untuk ruang Kelas 4.03. ', '2025-12-28 14:55:38', NULL),
(5, 1, 'APP', 'Mahasiswa M. Afriza Hidayat meminjam ruang Kelas 4.03 (28/12/2025 09:00 - 28/12/2025 10:00).', '2025-12-28 14:55:38', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `kapasitas` int(11) NOT NULL,
  `lokasi` varchar(100) NOT NULL,
  `tersedia` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `nama`, `kapasitas`, `lokasi`, `tersedia`) VALUES
(1, 'Lab Komputer 401', 35, 'Gedung B Lantai 4', 1),
(2, 'Kelas 3.002', 35, 'Gedung B Lantai 3', 1),
(3, 'RKB.101', 30, 'Gedung B Lantai 1', 1),
(4, 'Kelas 4.03', 100, 'Gedung B Lantai 4', 1),
(5, 'Kelas 3.001', 40, 'Gedung B Lantai 3', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `peran` enum('ADMIN','MAHASISWA') NOT NULL,
  `nim` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password_hash`, `peran`, `nim`, `created_at`) VALUES
(1, 'Admin', 'admin@classmate.local', 'pbkdf2$120000$A+4FY4dwyjw/kKQCvAC07g==$hP33Ms3aeYtzJNYS7BZRRt9+nYCEjREsuVrJdWzBA70=', 'ADMIN', NULL, '2025-12-13 06:04:33'),
(2, 'FAZLI', 'fazli@gmail.com', 'pbkdf2$120000$o281+8LJOhJU2JQcuAAnOA==$goaLLnyRlnbr61mH/xC6Xy9RHCKBTacMlfT1MwcjCiw=', 'MAHASISWA', '103062300092', '2025-12-14 16:45:38'),
(3, 'Nomensen', 'nomen@gmail.com', 'pbkdf2$120000$F4A2ggVzsDuYGZxxE3+vfA==$CNwcHKrGRnYEdnZDc9+boUJh+LvZ7wrcvDhLhdWUHf4=', 'MAHASISWA', '103062330101', '2025-12-15 03:46:26'),
(4, 'Afriza Hidayat', 'afriza@hidayat.com', 'pbkdf2$120000$kSBMSyI8wqmwzLM/vkaqdw==$5Kbr4xdxzrDIpoBQxGfFuzS0JjjL2S2JcBtENReac+w=', 'MAHASISWA', '103062300093', '2025-12-15 04:55:27'),
(5, 'Fazli Radika', 'radika@gmail.com', 'pbkdf2$120000$6QwqEPYYBJqAxnhCuut4vg==$NLWOHAgiRNyf4HUlAv48dlIbFhs+3lI5A1zOyzCDJU8=', 'MAHASISWA', '103062300092', '2025-12-28 14:27:55'),
(6, 'M. Afriza Hidayat', 'afriza@gmail.com', 'pbkdf2$120000$SUqOxAvG+YeHYOGk69My7A==$bWl6JsRhvc3nzdURzu3+FaM3O97fdExsUspXgrjqThE=', 'MAHASISWA', '103062300093', '2025-12-28 14:44:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bookings_room_time` (`room_id`,`waktu_mulai`,`waktu_selesai`),
  ADD KEY `idx_bookings_user` (`user_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user` (`user_id`,`created_at`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_bookings_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `fk_bookings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
