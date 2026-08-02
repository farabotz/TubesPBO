<%@page import="java.util.List"%>
<%@page import="com.tubespbo.classmate.model.Room"%>
<%@page import="com.tubespbo.classmate.model.User"%>
<%@page import="com.tubespbo.classmate.model.Role"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
  private String nextDir(String col, String currentSort, String currentDir) {
    if (col == null) return "asc";
    if (currentSort != null && currentSort.equalsIgnoreCase(col)) {
      return "asc".equalsIgnoreCase(currentDir) ? "desc" : "asc";
    }
    return "asc";
  }

  private String sortMark(String col, String currentSort, String currentDir) {
    if (currentSort != null && currentSort.equalsIgnoreCase(col)) {
      return "asc".equalsIgnoreCase(currentDir) ? " ▲" : " ▼";
    }
    return "";
  }
%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Kelola Ruangan</title>
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
            <a href="<%= request.getContextPath() %>/admin/rooms" class="navLink navLinkActive">🏫 Ruangan</a>
            <a href="<%= request.getContextPath() %>/admin/users" class="navLink">👥 User</a>
            <a href="<%= request.getContextPath() %>/admin/bookings" class="navLink">✅ Approval</a>
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
              <span class="pageTitleIcon">🏫</span>
              Kelola Kelas/Ruangan
            </h1>
            <p class="pageSubtitle">Tambah dan kelola data ruangan kelas</p>
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

          <div class="grid2">
            <!-- Form Tambah Ruangan -->
            <div class="card">
              <h2 class="sectionTitle">➕ Tambah Ruangan Baru</h2>
              <form method="post" action="<%= request.getContextPath() %>/admin/rooms" class="stack">
                <div>
                  <label class="label">🏷️ Nama Ruangan</label>
                  <input class="input" type="text" name="nama" placeholder="Contoh: Lab Komputer 1" required />
                </div>
                <div>
                  <label class="label">👥 Kapasitas</label>
                  <input class="input" type="number" name="kapasitas" min="1" placeholder="Jumlah orang" required />
                </div>
                <div>
                  <label class="label">📍 Lokasi</label>
                  <input class="input" type="text" name="lokasi" placeholder="Contoh: Gedung A Lantai 2" required />
                </div>
                <button class="btn btnPrimary" type="submit">
                  💾 Simpan Ruangan
                </button>
              </form>
            </div>

            <!-- Daftar Ruangan -->
            <div class="card">
              <h2 class="sectionTitle">📋 Daftar Ruangan</h2>
              <% List<Room> rooms = (List<Room>) request.getAttribute("rooms"); %>
              <% if (rooms == null || rooms.isEmpty()) { %>
                <div class="emptyState">
                  <div class="emptyStateIcon">🏫</div>
                  <p class="emptyStateText">Belum ada ruangan terdaftar</p>
                  <p class="muted">Tambahkan ruangan menggunakan form di sebelah kiri</p>
                </div>
              <% } else { %>
                <div class="tableWrap">
                  <table class="table">
                    <thead>
                      <% 
                        String currentSort = (String) request.getAttribute("sort");
                        String currentDir = (String) request.getAttribute("dir");
                        if (currentDir == null || currentDir.trim().isEmpty()) currentDir = "asc";
                      %>
                      <tr>
                        <th>
                          <a href="<%= request.getContextPath() %>/admin/rooms?sort=id&dir=<%= nextDir("id", currentSort, currentDir) %>" style="color:inherit; text-decoration:none;">
                            ID<%= sortMark("id", currentSort, currentDir) %>
                          </a>
                        </th>
                        <th>
                          <a href="<%= request.getContextPath() %>/admin/rooms?sort=nama&dir=<%= nextDir("nama", currentSort, currentDir) %>" style="color:inherit; text-decoration:none;">
                            Nama<%= sortMark("nama", currentSort, currentDir) %>
                          </a>
                        </th>
                        <th>
                          <a href="<%= request.getContextPath() %>/admin/rooms?sort=kapasitas&dir=<%= nextDir("kapasitas", currentSort, currentDir) %>" style="color:inherit; text-decoration:none;">
                            Kapasitas<%= sortMark("kapasitas", currentSort, currentDir) %>
                          </a>
                        </th>
                        <th>
                          <a href="<%= request.getContextPath() %>/admin/rooms?sort=lokasi&dir=<%= nextDir("lokasi", currentSort, currentDir) %>" style="color:inherit; text-decoration:none;">
                            Lokasi<%= sortMark("lokasi", currentSort, currentDir) %>
                          </a>
                        </th>
                        <th>
                          <a href="<%= request.getContextPath() %>/admin/rooms?sort=status&dir=<%= nextDir("status", currentSort, currentDir) %>" style="color:inherit; text-decoration:none;">
                            Status<%= sortMark("status", currentSort, currentDir) %>
                          </a>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <% for (Room r : rooms) { %>
                        <tr>
                          <td><strong>#<%= r.getId() %></strong></td>
                          <td><strong><%= r.getNama() %></strong></td>
                          <td>👥 <%= r.getKapasitas() %></td>
                          <td>📍 <%= r.getLokasi() %></td>
                          <td>
                            <% if (r.isTersedia()) { %>
                              <span class="badge badgeAvailable">✓ Tersedia</span>
                            <% } else { %>
                              <span class="badge badgeUnavailable">✗ Tidak Tersedia</span>
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
