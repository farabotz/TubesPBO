package com.tubespbo.classmate.dao;

import com.tubespbo.classmate.model.Room;
import com.tubespbo.classmate.util.Db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RoomDao {

    public List<Room> listAll() throws Exception {
        return listAllSorted(null, null);
    }

    public List<Room> listAllSorted(String sort, String dir) throws Exception {
        String orderBy = orderBy(sort);
        String direction = ("desc".equalsIgnoreCase(dir)) ? "DESC" : "ASC";
        String sql = "SELECT id,nama,kapasitas,lokasi,tersedia FROM rooms ORDER BY " + orderBy + " " + direction;
        List<Room> out = new ArrayList<>();
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(map(rs));
            }
        }
        return out;
    }

    private static String orderBy(String sort) {
        if (sort == null) {
            return "nama";
        }
        switch (sort.toLowerCase()) {
            case "id":
                return "id";
            case "nama":
                return "nama";
            case "kapasitas":
                return "kapasitas";
            case "lokasi":
                return "lokasi";
            case "status":
            case "tersedia":
                return "tersedia";
            default:
                return "nama";
        }
    }

    public Room findById(int id) throws Exception {
        String sql = "SELECT id,nama,kapasitas,lokasi,tersedia FROM rooms WHERE id=?";
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

    public int insert(Room r) throws Exception {
        String sql = "INSERT INTO rooms (nama,kapasitas,lokasi,tersedia) VALUES (?,?,?,?)";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getNama());
            ps.setInt(2, r.getKapasitas());
            ps.setString(3, r.getLokasi());
            ps.setBoolean(4, r.isTersedia());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
                return 0;
            }
        }
    }

    private static Room map(ResultSet rs) throws Exception {
        Room r = new Room();
        r.setId(rs.getInt("id"));
        r.setNama(rs.getString("nama"));
        r.setKapasitas(rs.getInt("kapasitas"));
        r.setLokasi(rs.getString("lokasi"));
        r.setTersedia(rs.getBoolean("tersedia"));
        return r;
    }
}
