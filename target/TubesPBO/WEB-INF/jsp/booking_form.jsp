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
    <title>CLASSMATE - Ajukan Peminjaman</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <% User u = (User) session.getAttribute("user"); %>
    <% Room selected = (Room) request.getAttribute("room"); %>
    <% List<Room> rooms = (List<Room>) request.getAttribute("rooms"); %>
    <% boolean selectedUnavailable = (selected != null && !selected.isTersedia()); %>
    
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
            <a href="<%= request.getContextPath() %>/book" class="navLink navLinkActive">📝 Ajukan Pinjam</a>
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
              <span class="pageTitleIcon">📝</span>
              Ajukan Peminjaman Kelas
            </h1>
            <p class="pageSubtitle">Isi formulir di bawah untuk mengajukan peminjaman ruangan</p>
          </div>

          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alertError">
              ⚠️ <%= request.getAttribute("error") %>
            </div>
          <% } %>

          <div class="grid2">
            <div class="card">
              <h2 class="sectionTitle">📋 Formulir Peminjaman</h2>
              <form method="post" action="<%= request.getContextPath() %>/book" class="stack">
                <div>
                  <label class="label">🏫 Pilih Ruangan</label>
                  <select class="input" name="roomId" required>
                    <option value="">-- Pilih Ruangan --</option>
                    <% if (rooms != null) { %>
                      <% for (Room r : rooms) { %>
                        <option value="<%= r.getId() %>"
                                <%= (selected != null && selected.getId() == r.getId()) ? "selected" : "" %>
                                <%= (!r.isTersedia()) ? "disabled" : "" %>>
                          <%= r.getNama() %> - <%= r.getLokasi() %> (👥 <%= r.getKapasitas() %>)<%= r.isTersedia() ? "" : " - ❌ Tidak Tersedia" %>
                        </option>
                      <% } %>
                    <% } %>
                  </select>
                  <p class="muted mt1">💡 Ruangan yang tidak tersedia tidak dapat dipilih</p>
                </div>

                <div>
                  <label class="label">📅 Tanggal Peminjaman</label>
                  <input class="input" type="date" name="tanggal" required />
                  <p class="muted mt1">💡 Pilih tanggal, lalu atur jam sesuai jam operasional.</p>
                </div>

                <div class="grid2">
                  <div>
                    <label class="label">🕐 Jam Mulai</label>
                    <select class="input" name="mulaiJam" required></select>
                    <p class="muted mt1">Jam operasional: 07.00 - 21.00 (pilihan per 15 menit)</p>
                  </div>
                  <div>
                    <label class="label">🕐 Jam Selesai</label>
                    <select class="input" name="selesaiJam" required></select>
                    <p class="muted mt1">Minimal durasi 15 menit</p>
                  </div>
                </div>

                <div>
                  <label class="label">📝 Keperluan</label>
                  <input class="input" type="text" name="keperluan" maxlength="255" 
                         placeholder="Contoh: Rapat organisasi, kuliah pengganti, dll" required />
                </div>

                <div class="row">
                  <button class="btn btnPrimary btnLg" type="submit" <%= selectedUnavailable ? "disabled" : "" %>>
                    🚀 Kirim Pengajuan
                  </button>
                </div>
              </form>
            </div>

            <div class="card">
              <h2 class="sectionTitle">ℹ️ Informasi</h2>
              <div class="stack">
                <div class="notifItem">
                  <div class="notifIcon">📋</div>
                  <div class="notifContent">
                    <div class="notifChannel">Proses Pengajuan</div>
                    <div class="notifMessage">Pengajuan Anda akan direview oleh admin secepatnya</div>
                  </div>
                </div>
                <div class="notifItem">
                  <div class="notifIcon">⚠️</div>
                  <div class="notifContent">
                    <div class="notifChannel">Perhatian</div>
                    <div class="notifMessage">Pengajuan akan ditolak otomatis jika jadwal bentrok dengan booking lain yang sudah disetujui</div>
                  </div>
                </div>
                <div class="notifItem">
                  <div class="notifIcon">🔔</div>
                  <div class="notifContent">
                    <div class="notifChannel">Notifikasi</div>
                    <div class="notifMessage">Anda akan menerima notifikasi saat pengajuan disetujui atau ditolak</div>
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

    <script>
      (function () {
        const form = document.querySelector('form[action$="/book"]');
        if (!form) return;

        const mulaiSelect = form.querySelector('select[name="mulaiJam"]');
        const selesaiSelect = form.querySelector('select[name="selesaiJam"]');

        const step = 15;
        const min = 420; // 07:00
        const max = 1260; // 21:00

        function pad2(n) { return String(n).padStart(2, '0'); }

        function toHHMM(totalMinutes) {
          const h = Math.floor(totalMinutes / 60);
          const m = totalMinutes % 60;
          return pad2(h) + ':' + pad2(m);
        }

        function toHHdotMM(totalMinutes) {
          const h = Math.floor(totalMinutes / 60);
          const m = totalMinutes % 60;
          return pad2(h) + '.' + pad2(m);
        }

        function fromHHMM(value) {
          if (!value) return NaN;
          const parts = value.split(':');
          if (parts.length !== 2) return NaN;
          const h = parseInt(parts[0], 10);
          const m = parseInt(parts[1], 10);
          return (h * 60) + m;
        }

        function fill(selectEl) {
          selectEl.innerHTML = '';
          for (let t = min; t <= max; t += step) {
            const opt = document.createElement('option');
            opt.value = toHHMM(t);
            opt.textContent = toHHdotMM(t);
            selectEl.appendChild(opt);
          }
        }

        function ensureValid() {
          const mulai = fromHHMM(mulaiSelect.value);
          const selesai = fromHHMM(selesaiSelect.value);
          if (!Number.isFinite(mulai) || !Number.isFinite(selesai)) return;

          if (selesai - mulai < step) {
            const target = mulai + step;
            const clamped = Math.max(min, Math.min(max, target));
            selesaiSelect.value = toHHMM(clamped);
          }
        }

        fill(mulaiSelect);
        fill(selesaiSelect);

        // default values: 09.00 - 10.00
        mulaiSelect.value = '09:00';
        selesaiSelect.value = '10:00';

        mulaiSelect.addEventListener('change', ensureValid);
        selesaiSelect.addEventListener('change', ensureValid);
        ensureValid();
      })();
    </script>
  </body>
</html>
