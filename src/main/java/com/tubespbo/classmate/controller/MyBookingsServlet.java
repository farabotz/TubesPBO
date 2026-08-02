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

@WebServlet(name = "MyBookingsServlet", urlPatterns = {"/my-bookings"})
public class MyBookingsServlet extends BaseServlet {

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
        if (u.getPeran() != Role.MAHASISWA) {
            response.sendError(403);
            return;
        }

        try {
            request.setAttribute("bookings", bookingDao.listByUser(u.getId()));
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/my_bookings.jsp");
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
        if (u.getPeran() != Role.MAHASISWA) {
            response.sendError(403);
            return;
        }

        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("id"));
                String alasan = request.getParameter("alasan");
                approvalService.cancelByUser(bookingId, u.getId(), alasan);
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/my-bookings");
    }
}
