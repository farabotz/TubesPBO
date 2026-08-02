<%@page import="com.tubespbo.classmate.model.User"%>
<%@page import="com.tubespbo.classmate.model.Role"%>
<%@page import="com.tubespbo.classmate.model.Notification"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <% User u = (User) session.getAttribute("user"); %>
    <% boolean isAdmin = (u.getPeran() == Role.ADMIN); %>
    
    <div class="pageWrapper">
      <!-- Navbar -->
      <nav class="navbar">
        <div class="navbarInner">
          <a href="<%= request.getContextPath() %>/dashboard" class="logo">
            <div class="logoIcon">🎓</div>
            CLASSMATE
          </a>
          <div class="navLinks">
            <% if (!isAdmin) { %>
              <a href="<%= request.getContextPath() %>/rooms" class="navLink">🏫 Ruangan</a>
              <a href="<%= request.getContextPath() %>/book" class="navLink">📝 Ajukan Pinjam</a>
              <a href="<%= request.getContextPath() %>/my-bookings" class="navLink">📋 Riwayat</a>
            <% } else { %>
              <a href="<%= request.getContextPath() %>/admin/rooms" class="navLink">🏫 Ruangan</a>
              <a href="<%= request.getContextPath() %>/admin/users" class="navLink">👥 User</a>
              <a href="<%= request.getContextPath() %>/admin/bookings" class="navLink">✅ Approval</a>
              <a href="<%= request.getContextPath() %>/admin/report" class="navLink">📊 Laporan</a>
            <% } %>
            <div class="userBadge">
              👤 <%= u.getNama() %>
              <span class="badge <%= isAdmin ? "badgeAdmin" : "badgeMahasiswa" %>" style="margin-left:8px;">
                <%= u.getPeran() %>
              </span>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="navLink">🚪 Logout</a>
          </div>
        </div>
      </nav>

      <!-- Main Content -->
      <main class="mainContent">
        <div class="container">
          <div class="pageHeader">
            <h1 class="pageTitle">
              <span class="pageTitleIcon"><%= isAdmin ? "⚙️" : "🏠" %></span>
              Dashboard <%= isAdmin ? "Administrator" : "Mahasiswa" %>
            </h1>
            <p class="pageSubtitle">Selamat datang kembali, <strong><%= u.getNama() %></strong>! 👋</p>
          </div>

          <div class="grid2">
            <!-- Menu Cards -->
            <div class="card">
              <h2 class="sectionTitle">📌 Menu Utama</h2>
              <div class="stack">
                <% if (!isAdmin) { %>
                  <a href="<%= request.getContextPath() %>/rooms" class="menuCard">
                    <div class="menuCardIcon blue">🏫</div>
                    <div class="menuCardContent">
                      <h3>Lihat Kelas/Ruangan</h3>
                      <p>Cek ketersediaan ruangan kelas</p>
                    </div>
                  </a>
                  <a href="<%= request.getContextPath() %>/book" class="menuCard">
                    <div class="menuCardIcon purple">📝</div>
                    <div class="menuCardContent">
                      <h3>Ajukan Peminjaman</h3>
                      <p>Buat pengajuan pinjam ruangan</p>
                    </div>
                  </a>
                  <a href="<%= request.getContextPath() %>/my-bookings" class="menuCard">
                    <div class="menuCardIcon green">📋</div>
                    <div class="menuCardContent">
                      <h3>Riwayat Peminjaman</h3>
                      <p>Lihat status pengajuan Anda</p>
                    </div>
                  </a>
                <% } else { %>
                  <a href="<%= request.getContextPath() %>/admin/rooms" class="menuCard">
                    <div class="menuCardIcon blue">🏫</div>
                    <div class="menuCardContent">
                      <h3>Kelola Ruangan</h3>
                      <p>Tambah & atur ketersediaan kelas</p>
                    </div>
                  </a>
                  <a href="<%= request.getContextPath() %>/admin/users" class="menuCard">
                    <div class="menuCardIcon purple">👥</div>
                    <div class="menuCardContent">
                      <h3>Kelola User</h3>
                      <p>Manajemen akun mahasiswa & admin</p>
                    </div>
                  </a>
                  <a href="<%= request.getContextPath() %>/admin/bookings" class="menuCard">
                    <div class="menuCardIcon orange">✅</div>
                    <div class="menuCardContent">
                      <h3>Approval Peminjaman</h3>
                      <p>Setujui/tolak pengajuan masuk</p>
                    </div>
                  </a>
                  <a href="<%= request.getContextPath() %>/admin/report" class="menuCard">
                    <div class="menuCardIcon cyan">📊</div>
                    <div class="menuCardContent">
                      <h3>Laporan</h3>
                      <p>Download laporan CSV/PDF</p>
                    </div>
                  </a>
                <% } %>
              </div>
            </div>

            <!-- Notifications -->
            <div class="card">
              <h2 class="sectionTitle">🔔 Notifikasi</h2>
              <% if (request.getAttribute("notifError") != null) { %>
                <div class="alert alertError">
                  <%= request.getAttribute("notifError") %>
                </div>
              <% } %>

              <% List notifs = (List) request.getAttribute("notifications"); %>
              <% if (notifs == null || notifs.isEmpty()) { %>
                <div class="emptyState">
                  <div class="emptyStateIcon">📭</div>
                  <p class="emptyStateText">Belum ada notifikasi</p>
                  <p class="muted">Notifikasi akan muncul di sini saat ada update</p>
                </div>
              <% } else { %>
                <div class="stack">
                  <% for (Object o : notifs) { 
                       Notification n = (Notification) o; %>
                    <div class="notifItem">
                      <div class="notifIcon">📬</div>
                      <div class="notifContent">
                        <div class="notifChannel"><%= n.getChannel() %></div>
                        <div class="notifMessage"><%= n.getMessage() %></div>
                      </div>
                    </div>
                  <% } %>
                </div>
              <% } %>
            </div>
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
