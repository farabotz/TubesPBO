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
    <title>CLASSMATE - Riwayat Peminjaman</title>
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
            <a href="<%= request.getContextPath() %>/rooms" class="navLink">🏫 Ruangan</a>
            <a href="<%= request.getContextPath() %>/book" class="navLink">📝 Ajukan Pinjam</a>
            <a href="<%= request.getContextPath() %>/my-bookings" class="navLink navLinkActive">📋 Riwayat</a>
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
              <span class="pageTitleIcon">📋</span>
              Riwayat Peminjaman Saya
            </h1>
            <p class="pageSubtitle">Pantau status semua pengajuan peminjaman kelas Anda</p>
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

          <% List<Booking> list = (List<Booking>) request.getAttribute("bookings"); %>
          <div class="card">
            <% if (list == null || list.isEmpty()) { %>
              <div class="emptyState">
                <div class="emptyStateIcon">📋</div>
                <p class="emptyStateText">Belum ada pengajuan peminjaman</p>
                <p class="muted">Mulai dengan mengajukan peminjaman kelas</p>
                <a href="<%= request.getContextPath() %>/book" class="btn btnPrimary mt2">
                  📝 Ajukan Peminjaman
                </a>
              </div>
            <% } else { %>
              <div class="tableWrap">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Ruangan</th>
                      <th>Waktu</th>
                      <th>Keperluan</th>
                      <th>Status</th>
                      <th>Keterangan</th>
                      <th>Aksi</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (Booking b : list) { %>
                      <tr>
                        <td><strong>#<%= b.getId() %></strong></td>
                        <td>
                          <strong><%= b.getRoomNama() %></strong>
                          <div class="muted">📍 <%= b.getRoomLokasi() != null ? b.getRoomLokasi() : "" %></div>
                        </td>
                        <td>
                          <div>🕐 <%= b.getWaktuMulai() == null ? "-" : b.getWaktuMulai().format(dtFmt) %></div>
                          <div class="muted">s/d <%= b.getWaktuSelesai() == null ? "-" : b.getWaktuSelesai().format(dtFmt) %></div>
                        </td>
                        <td><%= b.getKeperluan() %></td>
                        <td>
                          <span class="badge badgeStatus-<%= b.getStatus().name() %>">
                            <% String statusIcon = "";
                               switch(b.getStatus().name()) {
                                 case "PENDING": statusIcon = "⏳"; break;
                                 case "APPROVED": statusIcon = "✅"; break;
                                 case "REJECTED": statusIcon = "❌"; break;
                                 case "CANCELLED": statusIcon = "🚫"; break;
                               }
                            %>
                            <%= statusIcon %> <%= b.getStatus() %>
                          </span>
                        </td>
                        <td>
                          <% if (b.getAlasan() != null && !b.getAlasan().isEmpty()) { %>
                            <span class="muted">💬 <%= b.getAlasan() %></span>
                          <% } else { %>
                            <span class="muted">-</span>
                          <% } %>
                        </td>
                        <td>
                          <%-- HANYA PENDING yang bisa dibatalkan --%>
                          <% boolean canCancel = b.getStatus().name().equals("PENDING"); %>
                          <% if (canCancel) { %>
                            <form method="post" action="<%= request.getContextPath() %>/my-bookings" style="margin:0;">
                              <input type="hidden" name="action" value="cancel" />
                              <input type="hidden" name="id" value="<%= b.getId() %>" />
                              <div class="stack" style="gap:8px;">
                                <input class="input" style="max-width:200px; padding:8px 12px; font-size:13px;" 
                                       type="text" name="alasan" placeholder="Alasan pembatalan" />
                                <button class="btn btnDanger btnSm" type="submit">
                                  🚫 Batalkan
                                </button>
                              </div>
                            </form>
                          <% } else if (b.getStatus().name().equals("APPROVED")) { %>
                            <span class="badge badgeAvailable">🔒 Terkonfirmasi</span>
                          <% } else { %>
                            <span class="muted">-</span>
                          <% } %>
                        </td>
                      </tr>
                    <% } %>
                  </tbody>
                </table>
              </div>
              
              <div class="mt2">
                <p class="muted">
                  💡 <strong>Info:</strong> Anda hanya dapat membatalkan pengajuan yang masih berstatus <strong>PENDING</strong>. 
                  Pengajuan yang sudah disetujui (APPROVED) tidak dapat dibatalkan.
                </p>
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
