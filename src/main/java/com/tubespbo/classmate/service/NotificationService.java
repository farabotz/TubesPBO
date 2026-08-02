package com.tubespbo.classmate.service;

import com.tubespbo.classmate.dao.NotificationDao;
import com.tubespbo.classmate.dao.UserDao;
import com.tubespbo.classmate.model.Notification;
import com.tubespbo.classmate.model.NotificationChannel;

import java.util.List;

public class NotificationService {

    private final NotificationDao dao = new NotificationDao();
    private final UserDao userDao = new UserDao();

    public void notifyApp(int userId, String message) throws Exception {
        Notification n = new Notification();
        n.setUserId(userId);
        n.setChannel(NotificationChannel.APP);
        n.setMessage(message);
        dao.insert(n);
    }

    public void notifyAdminsApp(String message) throws Exception {
        List<Integer> adminIds = userDao.listAdminIds();
        for (int adminId : adminIds) {
            notifyApp(adminId, message);
        }
    }

    // For this local-only project, EMAIL is stored as a notification record.
    // You can later extend this method to actually send SMTP email.
    public void notifyEmail(int userId, String message) throws Exception {
        Notification n = new Notification();
        n.setUserId(userId);
        n.setChannel(NotificationChannel.EMAIL);
        n.setMessage(message);
        dao.insert(n);
    }
}
