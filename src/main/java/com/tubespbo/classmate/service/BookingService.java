package com.tubespbo.classmate.service;

import com.tubespbo.classmate.dao.BookingDao;
import com.tubespbo.classmate.dao.RoomDao;
import com.tubespbo.classmate.model.Booking;
import com.tubespbo.classmate.model.Room;

import java.time.Duration;
import java.time.LocalTime;

public class BookingService {

    private final BookingDao dao = new BookingDao();
    private final RoomDao roomDao = new RoomDao();

    private static final LocalTime OPERASIONAL_BUKA = LocalTime.of(7, 0);
    private static final LocalTime OPERASIONAL_TUTUP = LocalTime.of(21, 0);

    public int createPending(Booking b) throws Exception {
        if (b.getWaktuMulai() == null || b.getWaktuSelesai() == null) {
            throw new IllegalArgumentException("Waktu mulai/selesai wajib diisi");
        }
        if (!b.getWaktuMulai().isBefore(b.getWaktuSelesai())) {
            throw new IllegalArgumentException("Waktu mulai harus sebelum waktu selesai");
        }

        if (Duration.between(b.getWaktuMulai(), b.getWaktuSelesai()).toMinutes() < 15) {
            throw new IllegalArgumentException("Minimal durasi peminjaman adalah 15 menit");
        }

        // Batasi jam peminjaman (bukan 24 jam)
        if (!b.getWaktuMulai().toLocalDate().equals(b.getWaktuSelesai().toLocalDate())) {
            throw new IllegalArgumentException("Peminjaman harus di hari yang sama");
        }
        LocalTime mulai = b.getWaktuMulai().toLocalTime();
        LocalTime selesai = b.getWaktuSelesai().toLocalTime();
        if (mulai.isBefore(OPERASIONAL_BUKA) || selesai.isAfter(OPERASIONAL_TUTUP)) {
            throw new IllegalArgumentException("Waktu peminjaman hanya boleh antara 07:00 sampai 21:00");
        }

        Room room = roomDao.findById(b.getRoomId());
        if (room == null) {
            throw new IllegalArgumentException("Ruangan tidak ditemukan");
        }
        if (!room.isTersedia()) {
            throw new IllegalArgumentException("Ruangan tidak tersedia untuk dipinjam");
        }

        if (dao.hasConflict(b.getRoomId(), b.getWaktuMulai(), b.getWaktuSelesai())) {
            throw new IllegalArgumentException("Jadwal bentrok: Ruangan sudah dibooking pada rentang waktu tersebut");
        }
        return dao.insertPending(b);
    }
}
