<%@page import="com.tubespbo.classmate.model.User"%>
<%@page import="com.tubespbo.classmate.model.Role"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Laporan Peminjaman</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <% User u = (User) session.getAttribute("user"); %>
    
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
            <a href="<%= request.getContextPath() %>/admin/bookings" class="navLink">✅ Approval</a>
            <a href="<%= request.getContextPath() %>/admin/report" class="navLink navLinkActive">📊 Laporan</a>
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
              <span class="pageTitleIcon">📊</span>
              Laporan Peminjaman Kelas
            </h1>
            <p class="pageSubtitle">Download laporan peminjaman dalam format CSV atau PDF</p>
          </div>

          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alertError">
              ⚠️ <%= request.getAttribute("error") %>
            </div>
          <% } %>

          <div class="grid2">
            <div class="card">
              <h2 class="sectionTitle">📥 Generate Laporan</h2>
              <form method="post" action="<%= request.getContextPath() %>/admin/report" class="stack">
                <div class="grid2">
                  <div>
                    <label class="label">📅 Dari Tanggal</label>
                    <input class="input" type="date" name="from" required />
                  </div>
                  <div>
                    <label class="label">📅 Sampai Tanggal</label>
                    <input class="input" type="date" name="to" required />
                  </div>
                </div>
                <div>
                  <label class="label">📄 Format File</label>
                  <select class="input" name="type" required>
                    <option value="csv">📊 CSV (Excel/Spreadsheet)</option>
                    <option value="pdf">📑 PDF (Document)</option>
                  </select>
                </div>
                <button class="btn btnPrimary btnLg" type="submit">
                  📥 Download Laporan
                </button>
              </form>
            </div>

            <div class="card">
              <h2 class="sectionTitle">ℹ️ Informasi Format</h2>
              <div class="stack">
                <div class="notifItem">
                  <div class="notifIcon">📊</div>
                  <div class="notifContent">
                    <div class="notifChannel">Format CSV</div>
                    <div class="notifMessage">
                      Cocok untuk analisis data di Excel, Google Sheets, atau aplikasi spreadsheet lainnya. 
                      Data dapat diedit dan diolah lebih lanjut.
                    </div>
                  </div>
                </div>
                <div class="notifItem">
                  <div class="notifIcon">📑</div>
                  <div class="notifContent">
                    <div class="notifChannel">Format PDF</div>
                    <div class="notifMessage">
                      Cocok untuk arsip dan dokumentasi resmi. Format yang rapi dan siap cetak 
                      untuk keperluan administrasi.
                    </div>
                  </div>
                </div>
                <div class="notifItem">
                  <div class="notifIcon">💡</div>
                  <div class="notifContent">
                    <div class="notifChannel">Tips</div>
                    <div class="notifMessage">
                      Laporan akan mencakup semua booking (PENDING/APPROVED/REJECTED/CANCELLED)
                      dalam rentang tanggal yang dipilih.
                    </div>
                  </div>
                </div>
              </div>
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
