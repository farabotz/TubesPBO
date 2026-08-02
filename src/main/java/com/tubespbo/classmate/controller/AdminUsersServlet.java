package com.tubespbo.classmate.controller;

import com.tubespbo.classmate.dao.UserDao;
import com.tubespbo.classmate.model.Role;
import com.tubespbo.classmate.model.User;
import com.tubespbo.classmate.util.PasswordUtil;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminUsersServlet", urlPatterns = {"/admin/users"})
public class AdminUsersServlet extends BaseServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User u = currentUser(request);
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (u.getPeran() != Role.ADMIN) {
            response.sendError(403);
            return;
        }

        try {
            request.setAttribute("users", userDao.listAll());
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin_users.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User u = currentUser(request);
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (u.getPeran() != Role.ADMIN) {
            response.sendError(403);
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("id"));
                if (userId == u.getId()) {
                    throw new IllegalArgumentException("Tidak bisa menghapus akun sendiri");
                }

                userDao.deleteById(userId);
                request.setAttribute("success", "User berhasil dihapus");
            } else if ("createAdmin".equals(action)) {
                String nama = request.getParameter("nama");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (nama == null || nama.trim().isEmpty()) {
                    throw new IllegalArgumentException("Nama wajib diisi");
                }
                if (email == null || email.trim().isEmpty()) {
                    throw new IllegalArgumentException("Email wajib diisi");
                }
                if (password == null || password.trim().isEmpty()) {
                    throw new IllegalArgumentException("Password wajib diisi");
                }

                User nu = new User();
                nu.setNama(nama.trim());
                nu.setEmail(email.trim());
                nu.setPasswordHash(PasswordUtil.hashPbkdf2(password));
                nu.setPeran(Role.ADMIN);
                nu.setNim(null);
                userDao.insert(nu);
                request.setAttribute("success", "Admin berhasil ditambahkan");
            } else {
                response.sendError(400);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        doGet(request, response);
    }
}
