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

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends BaseServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User current = currentUser(request);
        if (current != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User current = currentUser(request);
        if (current != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String nim = request.getParameter("nim");

        try {
            if (nama == null || nama.trim().isEmpty()) {
                throw new IllegalArgumentException("Nama wajib diisi");
            }
            if (email == null || email.trim().isEmpty()) {
                throw new IllegalArgumentException("Email wajib diisi");
            }
            if (password == null || password.length() < 6) {
                throw new IllegalArgumentException("Password minimal 6 karakter");
            }

            String emailTrim = email.trim().toLowerCase();
            if (userDao.findByEmail(emailTrim) != null) {
                throw new IllegalArgumentException("Email sudah terdaftar, silakan login");
            }

            User u = new User();
            u.setNama(nama.trim());
            u.setEmail(emailTrim);
            u.setPeran(Role.MAHASISWA);
            u.setNim(nim == null ? null : nim.trim());
            u.setPasswordHash(PasswordUtil.hashPbkdf2(password));

            userDao.insert(u);

            response.sendRedirect(request.getContextPath() + "/login?registered=1");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
}
