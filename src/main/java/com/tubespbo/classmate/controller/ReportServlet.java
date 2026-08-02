package com.tubespbo.classmate.controller;

import com.tubespbo.classmate.model.Role;
import com.tubespbo.classmate.model.User;
import com.tubespbo.classmate.service.ReportService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ReportServlet", urlPatterns = {"/admin/report"})
public class ReportServlet extends BaseServlet {

    private final ReportService reportService = new ReportService();
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FILE_DATE_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

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

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/report.jsp");
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

        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");
        String type = request.getParameter("type");

        try {
            LocalDate from = LocalDate.parse(fromStr);
            LocalDate to = LocalDate.parse(toStr);
            List<com.tubespbo.classmate.model.Booking> list = reportService.getBookings(from, to);

            String fileBase = "report_" + from.format(FILE_DATE_FMT) + "_" + to.format(FILE_DATE_FMT);

            if ("csv".equals(type)) {
                response.setContentType("text/csv; charset=utf-8");
                response.setHeader("Content-Disposition", "attachment; filename=" + fileBase + ".csv");
                reportService.writeCsv(list, response.getOutputStream());
            } else if ("pdf".equals(type)) {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=" + fileBase + ".pdf");
                reportService.writePdf(
                        list,
                        response.getOutputStream(),
                        "Laporan Peminjaman (" + from.format(DATE_FMT) + " s/d " + to.format(DATE_FMT) + ")"
                );
            } else {
                request.setAttribute("error", "Tipe report tidak valid");
                doGet(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
}
