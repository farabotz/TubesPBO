<%@page import="java.util.List"%>
<%@page import="com.tubespbo.classmate.model.User"%>
<%@page import="com.tubespbo.classmate.model.Role"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Kelola User</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <% User currentUser = (User) session.getAttribute("user"); %>
    
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
            <a href="<%= request.getContextPath() %>/admin/users" class="navLink navLinkActive">👥 User</a>
            <a href="<%= request.getContextPath() %>/admin/bookings" class="navLink">✅ Approval</a>
            <a href="<%= request.getContextPath() %>/admin/report" class="navLink">📊 Laporan</a>
            <a href="<%= request.getContextPath() %>/dashboard" class="navLink">🏠 Dashboard</a>
            <div class="userBadge">
              👤 <%= currentUser.getNama() %>
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
              <span class="pageTitleIcon">👥</span>
              Kelola User/Mahasiswa
            </h1>
            <p class="pageSubtitle">Daftar akun pengguna yang terdaftar di sistem</p>
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

          <div class="card" style="margin-bottom:16px;">
            <div class="stack">
              <div class="notifItem">
                <div class="notifIcon">➕</div>
                <div class="notifContent">
                  <div class="notifChannel">Tambah Admin Baru</div>
                  <div class="notifMessage">Buat akun admin baru langsung dari halaman ini.</div>
                </div>
              </div>

              <button id="toggleCreateAdmin" class="btn btnPrimary btnSm" type="button">
                ➕ Tambah Admin
              </button>

              <div id="createAdminForm" style="display:none;">
                <form method="post" action="<%= request.getContextPath() %>/admin/users" class="stack" style="margin-top:12px;">
                  <input type="hidden" name="action" value="createAdmin" />
                  <div class="grid2">
                    <div>
                      <label class="label">Nama</label>
                      <input class="input" type="text" name="nama" required />
                    </div>
                    <div>
                      <label class="label">Email</label>
                      <input class="input" type="email" name="email" required />
                    </div>
                  </div>
                  <div>
                    <label class="label">Password</label>
                    <input class="input" type="password" name="password" required />
                  </div>
                  <button class="btn btnPrimary" type="submit">💾 Simpan Admin</button>
                </form>
              </div>
            </div>
          </div>

          <div class="card">
            <h2 class="sectionTitle">📋 Daftar User</h2>
            <p class="muted mb2">Pendaftaran akun dilakukan melalui halaman Register (bukan dari menu admin).</p>
            <% List<User> users = (List<User>) request.getAttribute("users"); %>
            <% if (users == null || users.isEmpty()) { %>
              <div class="emptyState">
                <div class="emptyStateIcon">👥</div>
                <p class="emptyStateText">Belum ada user terdaftar</p>
                <p class="muted">Minta pengguna melakukan Register dari halaman Login</p>
              </div>
            <% } else { %>
              <div class="tableWrap">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Nama</th>
                      <th>Email</th>
                      <th>Peran</th>
                      <th>NIM</th>
                      <th>Aksi</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (User u : users) { %>
                      <tr>
                        <td><strong>#<%= u.getId() %></strong></td>
                        <td><strong><%= u.getNama() %></strong></td>
                        <td>📧 <%= u.getEmail() %></td>
                        <td>
                          <span class="badge <%= u.getPeran() == Role.ADMIN ? "badgeAdmin" : "badgeMahasiswa" %>">
                            <%= u.getPeran() == Role.ADMIN ? "⚙️" : "👨‍🎓" %> <%= u.getPeran() %>
                          </span>
                        </td>
                        <td><%= u.getNim() == null || u.getNim().isEmpty() ? "-" : u.getNim() %></td>
                        <td>
                          <% if (u.getId() == currentUser.getId()) { %>
                            <span class="muted">-</span>
                          <% } else { %>
                            <form method="post" action="<%= request.getContextPath() %>/admin/users" style="margin:0;">
                              <input type="hidden" name="action" value="delete" />
                              <input type="hidden" name="id" value="<%= u.getId() %>" />
                              <button class="btn btnDanger btnSm" type="submit"
                                      onclick="return confirm('Hapus user ini? Semua booking & notifikasi user akan ikut terhapus.');">
                                🗑️ Hapus
                              </button>
                            </form>
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

      <script>
        (function () {
          var toggleBtn = document.getElementById('toggleCreateAdmin');
          var formWrap = document.getElementById('createAdminForm');
          if (!toggleBtn || !formWrap) return;

          toggleBtn.addEventListener('click', function () {
            var isHidden = formWrap.style.display === 'none' || formWrap.style.display === '';
            formWrap.style.display = isHidden ? 'block' : 'none';
          });
        })();
      </script>
    </div>
  </body>
</html>
