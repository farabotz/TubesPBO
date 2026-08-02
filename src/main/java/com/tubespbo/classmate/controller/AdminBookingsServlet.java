package com.tubespbo.classmate.controller;

import com.tubespbo.classmate.dao.BookingDao;
import com.tubespbo.classmate.model.Role;
import com.tubespbo.classmate.model.User;
import com.tubespbo.classmate.service.ApprovalService;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminBookingsServlet", urlPatterns = {"/admin/bookings"})
public class AdminBookingsServlet extends BaseServlet {

    private final BookingDao bookingDao = new BookingDao();
    private final ApprovalService approvalService = new ApprovalService();

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
            request.setAttribute("pending", bookingDao.listPending());
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin_bookings.jsp");
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
            int bookingId = Integer.parseInt(request.getParameter("id"));
            String alasan = request.getParameter("alasan");
            if ("approve".equals(action)) {
                approvalService.approve(bookingId, alasan);
            } else if ("reject".equals(action)) {
                approvalService.reject(bookingId, alasan);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings");
    }
}
