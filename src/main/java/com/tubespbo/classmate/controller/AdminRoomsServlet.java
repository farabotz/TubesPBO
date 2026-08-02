package com.tubespbo.classmate.controller;

import com.tubespbo.classmate.dao.RoomDao;
import com.tubespbo.classmate.model.Role;
import com.tubespbo.classmate.model.Room;
import com.tubespbo.classmate.model.User;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminRoomsServlet", urlPatterns = {"/admin/rooms"})
public class AdminRoomsServlet extends BaseServlet {

    private final RoomDao roomDao = new RoomDao();

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
            String sort = request.getParameter("sort");
            String dir = request.getParameter("dir");
            request.setAttribute("rooms", roomDao.listAllSorted(sort, dir));
            request.setAttribute("sort", sort);
            request.setAttribute("dir", dir);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin_rooms.jsp");
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

        try {
            Room r = new Room();
            r.setNama(request.getParameter("nama"));
            r.setKapasitas(Integer.parseInt(request.getParameter("kapasitas")));
            r.setLokasi(request.getParameter("lokasi"));
            r.setTersedia(true);
            roomDao.insert(r);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/rooms");
    }
}
