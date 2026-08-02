package com.tubespbo.classmate.dao;

import com.tubespbo.classmate.model.Booking;
import com.tubespbo.classmate.model.BookingStatus;
import com.tubespbo.classmate.util.Db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDao {

    public boolean hasConflict(int roomId, LocalDateTime mulai, LocalDateTime selesai) throws Exception {
        String sql = "SELECT COUNT(*) FROM bookings "
                + "WHERE room_id=? AND status IN ('PENDING','APPROVED') "
                + "AND NOT (waktu_selesai <= ? OR waktu_mulai >= ?)";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setTimestamp(2, Timestamp.valueOf(mulai));
            ps.setTimestamp(3, Timestamp.valueOf(selesai));
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    public int insertPending(Booking b) throws Exception {
        String sql = "INSERT INTO bookings (user_id,room_id,waktu_mulai,waktu_selesai,keperluan,status) VALUES (?,?,?,?,?,'PENDING')";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, b.getUserId());
            ps.setInt(2, b.getRoomId());
            ps.setTimestamp(3, Timestamp.valueOf(b.getWaktuMulai()));
            ps.setTimestamp(4, Timestamp.valueOf(b.getWaktuSelesai()));
            ps.setString(5, b.getKeperluan());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
                return 0;
            }
        }
    }

    public List<Booking> listByUser(int userId) throws Exception {
        String sql = "SELECT b.id,b.user_id,b.room_id,b.waktu_mulai,b.waktu_selesai,b.keperluan,b.status,b.alasan, "
                + "u.nama AS user_nama,u.email AS user_email, r.nama AS room_nama,r.lokasi AS room_lokasi "
                + "FROM bookings b JOIN users u ON u.id=b.user_id JOIN rooms r ON r.id=b.room_id "
                + "WHERE b.user_id=? ORDER BY b.id DESC";
        List<Booking> out = new ArrayList<>();
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(map(rs));
                }
            }
        }
        return out;
    }

    public List<Booking> listPending() throws Exception {
        String sql = "SELECT b.id,b.user_id,b.room_id,b.waktu_mulai,b.waktu_selesai,b.keperluan,b.status,b.alasan, "
                + "u.nama AS user_nama,u.email AS user_email, r.nama AS room_nama,r.lokasi AS room_lokasi "
                + "FROM bookings b JOIN users u ON u.id=b.user_id JOIN rooms r ON r.id=b.room_id "
                + "WHERE b.status='PENDING' ORDER BY b.id ASC";
        List<Booking> out = new ArrayList<>();
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(map(rs));
            }
        }
        return out;
    }

    public Booking findById(int id) throws Exception {
        String sql = "SELECT b.id,b.user_id,b.room_id,b.waktu_mulai,b.waktu_selesai,b.keperluan,b.status,b.alasan, "
                + "u.nama AS user_nama,u.email AS user_email, r.nama AS room_nama,r.lokasi AS room_lokasi "
                + "FROM bookings b JOIN users u ON u.id=b.user_id JOIN rooms r ON r.id=b.room_id WHERE b.id=?";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return map(rs);
            }
        }
    }

    public void updateStatus(int bookingId, BookingStatus status, String alasan) throws Exception {
        String sql = "UPDATE bookings SET status=?, alasan=? WHERE id=?";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setString(2, alasan);
            ps.setInt(3, bookingId);
            ps.executeUpdate();
        }
    }

    public List<Booking> listBetween(LocalDateTime from, LocalDateTime to) throws Exception {
        String sql = "SELECT b.id,b.user_id,b.room_id,b.waktu_mulai,b.waktu_selesai,b.keperluan,b.status,b.alasan, "
                + "u.nama AS user_nama,u.email AS user_email, r.nama AS room_nama,r.lokasi AS room_lokasi "
                + "FROM bookings b JOIN users u ON u.id=b.user_id JOIN rooms r ON r.id=b.room_id "
                + "WHERE b.waktu_mulai >= ? AND b.waktu_mulai <= ? ORDER BY b.waktu_mulai ASC";
        List<Booking> out = new ArrayList<>();
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(from));
            ps.setTimestamp(2, Timestamp.valueOf(to));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(map(rs));
                }
            }
        }
        return out;
    }

    private static Booking map(ResultSet rs) throws Exception {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setWaktuMulai(rs.getTimestamp("waktu_mulai").toLocalDateTime());
        b.setWaktuSelesai(rs.getTimestamp("waktu_selesai").toLocalDateTime());
        b.setKeperluan(rs.getString("keperluan"));
        b.setStatus(BookingStatus.valueOf(rs.getString("status")));
        b.setAlasan(rs.getString("alasan"));

        b.setUserNama(rs.getString("user_nama"));
        b.setUserEmail(rs.getString("user_email"));
        b.setRoomNama(rs.getString("room_nama"));
        b.setRoomLokasi(rs.getString("room_lokasi"));
        return b;
    }
}
