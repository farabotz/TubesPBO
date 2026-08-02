package com.tubespbo.classmate.controller;

import com.tubespbo.classmate.dao.RoomDao;
import com.tubespbo.classmate.model.User;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RoomsServlet", urlPatterns = {"/rooms"})
public class RoomsServlet extends BaseServlet {

    private final RoomDao roomDao = new RoomDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User u = currentUser(request);
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            request.setAttribute("rooms", roomDao.listAll());
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/rooms.jsp");
        dispatcher.forward(request, response);
    }
}
