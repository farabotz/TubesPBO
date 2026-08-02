<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <div class="loginWrapper">
      <div class="loginCard">
        <div class="loginLogo">
          <div class="logoIcon">🎓</div>
          <h1>CLASSMATE</h1>
          <p>Sistem Peminjaman Kelas Digital</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
          <div class="alert alertError">
            ⚠️ <%= request.getAttribute("error") %>
          </div>
        <% } %>

        <% if ("1".equals(request.getParameter("registered"))) { %>
          <div class="alert alertSuccess">
            ✅ Registrasi berhasil. Silakan login.
          </div>
        <% } %>

        <form method="post" action="<%= request.getContextPath() %>/login" class="stack">
          <div>
            <label class="label">📧 Email</label>
            <input class="input" type="email" name="email" placeholder="Masukkan email Anda" required />
          </div>
          <div>
            <label class="label">🔒 Password</label>
            <input class="input" type="password" name="password" placeholder="Masukkan password" required />
          </div>
          <button class="btn btnPrimary btnLg" type="submit" style="width:100%; margin-top:8px;">
            🚀 Masuk ke Sistem
          </button>
        </form>

        <div class="authLinks">
          <span class="muted">Belum punya akun?</span>
          <a class="link" href="<%= request.getContextPath() %>/register">Register</a>
        </div>

        </div>
      </div>
    </div>
  </body>
</html>
