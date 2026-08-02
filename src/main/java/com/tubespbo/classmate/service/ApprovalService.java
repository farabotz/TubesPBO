package com.tubespbo.classmate.service;

import com.tubespbo.classmate.dao.BookingDao;
import com.tubespbo.classmate.model.Booking;
import com.tubespbo.classmate.model.BookingStatus;

import java.time.format.DateTimeFormatter;

public class ApprovalService {

    private final BookingDao bookingDao = new BookingDao();
    private final NotificationService notificationService = new NotificationService();

    private static final DateTimeFormatter DT_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public void approve(int bookingId, String alasan) throws Exception {
        Booking b = bookingDao.findById(bookingId);
        if (b == null) {
            throw new IllegalArgumentException("Booking tidak ditemukan");
        }
        bookingDao.updateStatus(bookingId, BookingStatus.APPROVED, alasan);
        notificationService.notifyApp(b.getUserId(), "Booking disetujui untuk ruang " + b.getRoomNama() + ". " + safe(alasan));

        String waktu = "";
        if (b.getWaktuMulai() != null && b.getWaktuSelesai() != null) {
            waktu = b.getWaktuMulai().format(DT_FMT) + " - " + b.getWaktuSelesai().format(DT_FMT);
        }
        notificationService.notifyAdminsApp(
                "Mahasiswa " + safe(b.getUserNama()) + " meminjam ruang " + safe(b.getRoomNama())
                        + (waktu.isEmpty() ? "" : " (" + waktu + ")")
                        + "."
        );
    }

    public void reject(int bookingId, String alasan) throws Exception {
        Booking b = bookingDao.findById(bookingId);
        if (b == null) {
            throw new IllegalArgumentException("Booking tidak ditemukan");
        }
        bookingDao.updateStatus(bookingId, BookingStatus.REJECTED, alasan);
        notificationService.notifyApp(b.getUserId(), "Booking ditolak untuk ruang " + b.getRoomNama() + ". " + safe(alasan));
    }

    public void cancelByUser(int bookingId, int userId, String alasan) throws Exception {
        Booking b = bookingDao.findById(bookingId);
        if (b == null) {
            throw new IllegalArgumentException("Booking tidak ditemukan");
        }
        if (b.getUserId() != userId) {
            throw new IllegalArgumentException("Tidak punya akses untuk membatalkan booking ini");
        }
        bookingDao.updateStatus(bookingId, BookingStatus.CANCELLED, alasan);
        notificationService.notifyApp(userId, "Booking dibatalkan. " + safe(alasan));
    }

    private static String safe(String s) {
        if (s == null) {
            return "";
        }
        return s.trim();
    }
}
