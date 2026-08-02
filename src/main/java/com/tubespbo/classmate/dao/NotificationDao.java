package com.tubespbo.classmate.dao;

import com.tubespbo.classmate.model.Notification;
import com.tubespbo.classmate.model.NotificationChannel;
import com.tubespbo.classmate.util.Db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class NotificationDao {

    public int insert(Notification n) throws Exception {
        String sql = "INSERT INTO notifications (user_id, channel, message) VALUES (?,?,?)";
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, n.getUserId());
            ps.setString(2, n.getChannel().name());
            ps.setString(3, n.getMessage());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
                return 0;
            }
        }
    }

    public List<Notification> listByUser(int userId) throws Exception {
        String sql = "SELECT id,user_id,channel,message,created_at FROM notifications WHERE user_id=? ORDER BY id DESC";
        List<Notification> out = new ArrayList<>();
        try (Connection c = Db.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setChannel(NotificationChannel.valueOf(rs.getString("channel")));
                    n.setMessage(rs.getString("message"));
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        n.setCreatedAt(ts.toLocalDateTime());
                    }
                    out.add(n);
                }
            }
        }
        return out;
    }
}
