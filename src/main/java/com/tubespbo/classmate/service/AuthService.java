package com.tubespbo.classmate.service;

import com.tubespbo.classmate.dao.UserDao;
import com.tubespbo.classmate.model.User;
import com.tubespbo.classmate.util.PasswordUtil;

public class AuthService {

    private final UserDao userDao = new UserDao();

    public User login(String email, String password) throws Exception {
        if (email == null || email.trim().isEmpty() || password == null) {
            return null;
        }
        User u = userDao.findByEmail(email.trim());
        if (u == null) {
            return null;
        }
        if (!PasswordUtil.verify(password, u.getPasswordHash())) {
            return null;
        }
        return u;
    }
}
