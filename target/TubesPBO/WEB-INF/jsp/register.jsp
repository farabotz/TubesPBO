<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Register</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <div class="loginWrapper">
      <div class="loginCard">
        <div class="loginLogo">
          <div class="logoIcon">🧾</div>
          <h1>Register</h1>
          <p>Buat akun Mahasiswa untuk mengajukan peminjaman</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
          <div class="alert alertError">
            ⚠️ <%= request.getAttribute("error") %>
          </div>
        <% } %>

        <form method="post" action="<%= request.getContextPath() %>/register" class="stack">
          <div>
            <label class="label">👤 Nama Lengkap</label>
            <input class="input" type="text" name="nama" placeholder="Masukkan nama lengkap" required />
          </div>
          <div>
            <label class="label">📧 Email</label>
            <input class="input" type="email" name="email" placeholder="email@example.com" required />
          </div>
          <div>
            <label class="label">🔒 Password</label>
            <input class="input" type="password" name="password" placeholder="Minimal 6 karakter" required />
          </div>
          <div>
            <label class="label">🆔 NIM</label>
            <input class="input" type="text" name="nim" placeholder="Contoh: 23123456" />
            <p class="muted mt1">NIM dipakai untuk identitas mahasiswa.</p>
          </div>
          <button class="btn btnPrimary btnLg" type="submit" style="width:100%; margin-top:8px;">
            ✅ Buat Akun
          </button>
        </form>

        <div class="authLinks">
          <span class="muted">Sudah punya akun?</span>
          <a class="link" href="<%= request.getContextPath() %>/login">Login</a>
        </div>
      </div>
    </div>
  </body>
</html>
