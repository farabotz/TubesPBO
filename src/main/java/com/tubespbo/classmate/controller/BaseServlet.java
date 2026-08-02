package com.tubespbo.classmate.controller;

import com.tubespbo.classmate.model.Role;
import com.tubespbo.classmate.model.User;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public abstract class BaseServlet extends HttpServlet {

    protected User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object u = session.getAttribute("user");
        if (u instanceof User) {
            return (User) u;
        }
        return null;
    }

    protected boolean requireLogin(HttpServletRequest request) {
        return currentUser(request) != null;
    }

    protected boolean isAdmin(HttpServletRequest request) {
        User u = currentUser(request);
        return u != null && u.getPeran() == Role.ADMIN;
    }
}
