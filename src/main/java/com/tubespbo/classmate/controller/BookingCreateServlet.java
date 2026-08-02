package com.tubespbo.classmate.controller;

import com.tubespbo.classmate.dao.RoomDao;
import com.tubespbo.classmate.model.Booking;
import com.tubespbo.classmate.model.Role;
import com.tubespbo.classmate.model.Room;
import com.tubespbo.classmate.model.User;
import com.tubespbo.classmate.service.BookingService;
import com.tubespbo.classmate.service.NotificationService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "BookingCreateServlet", urlPatterns = {"/book"})
public class BookingCreateServlet extends BaseServlet {

    private final RoomDao roomDao = new RoomDao();
    private final BookingService bookingService = new BookingService();
    private final NotificationService notificationService = new NotificationService();

    private static LocalDateTime parseDateTimeLocal(String input) {
        if (input == null) {
            throw new IllegalArgumentException("Waktu tidak boleh kosong");
        }
        String s = input.trim();
        if (s.contains(" ")) {
            s = s.replace(' ', 'T');
        }
        s = s.replace('.', ':');

        try {
            return LocalDateTime.parse(s);
        } catch (DateTimeParseException ignored) {
            // Fallback: be explicit about allowed forms
            try {
                return LocalDateTime.parse(s, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            } catch (DateTimeParseException ex2) {
                throw ex2;
            }
        }
    }

    private static LocalDateTime parseDateAndTime(String tanggal, String jam) {
        if (tanggal == null || tanggal.trim().isEmpty()) {
            throw new IllegalArgumentException("Tanggal tidak boleh kosong");
        }
        if (jam == null || jam.trim().isEmpty()) {
            throw new IllegalArgumentException("Jam tidak boleh kosong");
        }
        LocalDate d = LocalDate.parse(tanggal.trim());
        String j = jam.trim().replace('.', ':');
        LocalTime t = LocalTime.parse(j);
        return LocalDateTime.of(d, t);
    }

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

        String roomIdStr = request.getParameter("roomId");
        try {
            if (roomIdStr != null) {
                int roomId = Integer.parseInt(roomIdStr);
                Room room = roomDao.findById(roomId);
                if (room == null) {
                    request.setAttribute("error", "Ruangan tidak ditemukan");
                } else if (!room.isTersedia()) {
                    request.setAttribute("error", "Ruangan tidak tersedia untuk dipinjam");
                }
                request.setAttribute("room", room);
            }
            request.setAttribute("rooms", roomDao.listAll());
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/booking_form.jsp");
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

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            // New form fields (recommended): tanggal + mulaiJam/selesaiJam
            String tanggal = request.getParameter("tanggal");
            String mulaiJam = request.getParameter("mulaiJam");
            String selesaiJam = request.getParameter("selesaiJam");

            // Backward compatibility: old form fields (datetime-local): mulai/selesai
            String mulaiStr = request.getParameter("mulai");
            String selesaiStr = request.getParameter("selesai");

            String keperluan = request.getParameter("keperluan");

            Booking b = new Booking();
            b.setUserId(u.getId());
            b.setRoomId(roomId);

            if (tanggal != null && mulaiJam != null && selesaiJam != null
                    && !tanggal.trim().isEmpty() && !mulaiJam.trim().isEmpty() && !selesaiJam.trim().isEmpty()) {
                b.setWaktuMulai(parseDateAndTime(tanggal, mulaiJam));
                b.setWaktuSelesai(parseDateAndTime(tanggal, selesaiJam));
            } else {
                b.setWaktuMulai(parseDateTimeLocal(mulaiStr));
                b.setWaktuSelesai(parseDateTimeLocal(selesaiStr));
            }
            b.setKeperluan(keperluan);

            int bookingId = bookingService.createPending(b);

            // Notify admins so it appears on admin dashboard.
            try {
                Room room = roomDao.findById(roomId);
                DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                String roomLabel = room == null ? ("ruangan #" + roomId) : (room.getNama() + " (" + room.getLokasi() + ")");
                String timeLabel = fmt.format(b.getWaktuMulai()) + " - " + fmt.format(b.getWaktuSelesai());
                String msg = "🆕 Pengajuan peminjaman baru (#" + bookingId + ") dari " + u.getNama()
                        + " untuk " + roomLabel + " pada " + timeLabel + ".";
                notificationService.notifyAdminsApp(msg);
            } catch (Exception ignored) {
                // Do not block booking creation if notifications fail.
            }

            response.sendRedirect(request.getContextPath() + "/my-bookings");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
}
