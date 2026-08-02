<%@page import="java.util.List"%>
<%@page import="com.tubespbo.classmate.model.Room"%>
<%@page import="com.tubespbo.classmate.model.User"%>
<%@page import="com.tubespbo.classmate.model.Role"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Daftar Ruangan</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <% User u = (User) session.getAttribute("user"); %>
    <% boolean isAdmin = (u != null && u.getPeran() == Role.ADMIN); %>
    
    <div class="pageWrapper">
      <!-- Navbar -->
      <nav class="navbar">
        <div class="navbarInner">
          <a href="<%= request.getContextPath() %>/dashboard" class="logo">
            <div class="logoIcon">🎓</div>
            CLASSMATE
          </a>
          <div class="navLinks">
            <a href="<%= request.getContextPath() %>/rooms" class="navLink navLinkActive">🏫 Ruangan</a>
            <a href="<%= request.getContextPath() %>/book" class="navLink">📝 Ajukan Pinjam</a>
            <a href="<%= request.getContextPath() %>/my-bookings" class="navLink">📋 Riwayat</a>
            <a href="<%= request.getContextPath() %>/dashboard" class="navLink">🏠 Dashboard</a>
            <a href="<%= request.getContextPath() %>/logout" class="navLink">🚪 Logout</a>
          </div>
        </div>
      </nav>

      <!-- Main Content -->
      <main class="mainContent">
        <div class="container">
          <div class="pageHeader">
            <h1 class="pageTitle">
              <span class="pageTitleIcon">🏫</span>
              Daftar Kelas/Ruangan
            </h1>
            <p class="pageSubtitle">Pilih ruangan yang tersedia untuk mengajukan peminjaman</p>
          </div>

          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alertError">
              ⚠️ <%= request.getAttribute("error") %>
            </div>
          <% } %>

          <% List<Room> rooms = (List<Room>) request.getAttribute("rooms"); %>
          <div class="card">
            <% if (rooms == null || rooms.isEmpty()) { %>
              <div class="emptyState">
                <div class="emptyStateIcon">🏫</div>
                <p class="emptyStateText">Belum ada ruangan terdaftar</p>
                <p class="muted">Hubungi admin untuk menambahkan ruangan</p>
              </div>
            <% } else { %>
              <div class="tableWrap">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Nama Ruangan</th>
                      <th>Kapasitas</th>
                      <th>Lokasi</th>
                      <th>Status</th>
                      <th>Aksi</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (Room r : rooms) { %>
                      <tr>
                        <td><strong>#<%= r.getId() %></strong></td>
                        <td>
                          <strong><%= r.getNama() %></strong>
                        </td>
                        <td>👥 <%= r.getKapasitas() %> orang</td>
                        <td>📍 <%= r.getLokasi() %></td>
                        <td>
                          <% if (r.isTersedia()) { %>
                            <span class="badge badgeAvailable">✓ Tersedia</span>
                          <% } else { %>
                            <span class="badge badgeUnavailable">✗ Tidak Tersedia</span>
                          <% } %>
                        </td>
                        <td>
                          <% if (r.isTersedia()) { %>
                            <a class="btn btnPrimary btnSm" href="<%= request.getContextPath() %>/book?roomId=<%= r.getId() %>">
                              📝 Pinjam
                            </a>
                          <% } else { %>
                            <span class="btn btnDisabled btnSm">🚫 Tidak Tersedia</span>
                          <% } %>
                        </td>
                      </tr>
                    <% } %>
                  </tbody>
                </table>
              </div>
            <% } %>
          </div>
        </div>
      </main>

      <!-- Footer -->
      <footer class="footer">
        <div class="footerInner">
          <div class="footerLogo">🎓 CLASSMATE</div>
          <p class="footerText">Sistem Peminjaman Kelas Digital - Tugas Besar PBO</p>
          <p class="footerText">&copy; 2025 CLASSMATE. All rights reserved.</p>
        </div>
      </footer>
    </div>
  </body>
</html>
