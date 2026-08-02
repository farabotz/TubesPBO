<%@page import="java.util.List"%>
<%@page import="com.tubespbo.classmate.model.Booking"%>
<%@page import="com.tubespbo.classmate.model.User"%>
<%@page import="com.tubespbo.classmate.model.Role"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Approval Peminjaman</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <% User u = (User) session.getAttribute("user"); %>
    <% DateTimeFormatter dtFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"); %>
    
    <div class="pageWrapper">
      <!-- Navbar -->
      <nav class="navbar">
        <div class="navbarInner">
          <a href="<%= request.getContextPath() %>/dashboard" class="logo">
            <div class="logoIcon">🎓</div>
            CLASSMATE
          </a>
          <div class="navLinks">
            <a href="<%= request.getContextPath() %>/admin/rooms" class="navLink">🏫 Ruangan</a>
            <a href="<%= request.getContextPath() %>/admin/users" class="navLink">👥 User</a>
            <a href="<%= request.getContextPath() %>/admin/bookings" class="navLink navLinkActive">✅ Approval</a>
            <a href="<%= request.getContextPath() %>/admin/report" class="navLink">📊 Laporan</a>
            <a href="<%= request.getContextPath() %>/dashboard" class="navLink">🏠 Dashboard</a>
            <div class="userBadge">
              👤 <%= u.getNama() %>
              <span class="badge badgeAdmin">ADMIN</span>
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
              <span class="pageTitleIcon">✅</span>
              Approval Peminjaman Kelas
            </h1>
            <p class="pageSubtitle">Review dan proses pengajuan peminjaman dari mahasiswa</p>
          </div>

          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alertError">
              ⚠️ <%= request.getAttribute("error") %>
            </div>
          <% } %>

          <% if (request.getAttribute("success") != null) { %>
            <div class="alert alertSuccess">
              ✅ <%= request.getAttribute("success") %>
            </div>
          <% } %>

          <% List<Booking> list = (List<Booking>) request.getAttribute("pending"); %>
          <div class="card">
            <h2 class="sectionTitle">⏳ Pengajuan Pending</h2>
            <% if (list == null || list.isEmpty()) { %>
              <div class="emptyState">
                <div class="emptyStateIcon">✨</div>
                <p class="emptyStateText">Tidak ada pengajuan yang perlu diproses</p>
                <p class="muted">Semua pengajuan sudah ditangani</p>
              </div>
            <% } else { %>
              <div class="tableWrap">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Mahasiswa</th>
                      <th>Ruangan</th>
                      <th>Waktu</th>
                      <th>Keperluan</th>
                      <th>Aksi</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (Booking b : list) { %>
                      <tr>
                        <td><strong>#<%= b.getId() %></strong></td>
                        <td>
                          <strong><%= b.getUserNama() %></strong>
                          <div class="muted">📧 <%= b.getUserEmail() %></div>
                        </td>
                        <td>
                          <strong><%= b.getRoomNama() %></strong>
                          <div class="muted">📍 <%= b.getRoomLokasi() %></div>
                        </td>
                        <td>
                          <div>🕐 <%= b.getWaktuMulai() == null ? "-" : b.getWaktuMulai().format(dtFmt) %></div>
                          <div class="muted">s/d <%= b.getWaktuSelesai() == null ? "-" : b.getWaktuSelesai().format(dtFmt) %></div>
                        </td>
                        <td><%= b.getKeperluan() %></td>
                        <td>
                          <form method="post" action="<%= request.getContextPath() %>/admin/bookings" style="margin:0;">
                            <input type="hidden" name="id" value="<%= b.getId() %>" />
                            <div class="stack" style="gap:10px;">
                              <input class="input" style="padding:10px 12px; font-size:13px;" 
                                     type="text" name="alasan" placeholder="Catatan/alasan (opsional)" />
                              <div class="row">
                                <button class="btn btnSuccess btnSm" type="submit" name="action" value="approve">
                                  ✅ Approve
                                </button>
                                <button class="btn btnDanger btnSm" type="submit" name="action" value="reject">
                                  ❌ Reject
                                </button>
                              </div>
                            </div>
                          </form>
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
