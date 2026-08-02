package com.tubespbo.classmate.dao;

import com.tubespbo.classmate.model.Role;
import com.tubespbo.classmate.model.User;
import com.tubespbo.classmate.util.Db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class UserDao {

    public User findByEmail(String email) throws Exception {
        String sql = "SELECT id,nama,email,password_hash,peran,nim FROM users WHERE email=?";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return map(rs);
            }
        }
    }

    public User findById(int id) throws Exception {
        String sql = "SELECT id,nama,email,password_hash,peran,nim FROM users WHERE id=?";
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

    public List<User> listAll() throws Exception {
        String sql = "SELECT id,nama,email,password_hash,peran,nim FROM users ORDER BY id DESC";
        List<User> out = new ArrayList<>();
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(map(rs));
            }
        }
        return out;
    }

    public int insert(User u) throws Exception {
        String sql = "INSERT INTO users (nama,email,password_hash,peran,nim) VALUES (?,?,?,?,?)";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getNama());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPasswordHash());
            ps.setString(4, u.getPeran().name());
            ps.setString(5, u.getNim());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
                return 0;
            }
        }
    }

    public List<Integer> listAdminIds() throws Exception {
        String sql = "SELECT id FROM users WHERE peran='ADMIN' ORDER BY id ASC";
        List<Integer> out = new ArrayList<>();
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(rs.getInt("id"));
            }
        }
        return Collections.unmodifiableList(out);
    }

    public void deleteById(int id) throws Exception {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private static User map(ResultSet rs) throws Exception {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setNama(rs.getString("nama"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setPeran(Role.valueOf(rs.getString("peran")));
        u.setNim(rs.getString("nim"));
        return u;
    }
}
