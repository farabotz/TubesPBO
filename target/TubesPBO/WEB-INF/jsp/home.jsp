<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLASSMATE - Home</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css" />
  </head>
  <body>
    <div class="loginWrapper">
      <div class="loginCard" style="text-align:center;">
        <div class="loginLogo">
          <div class="logoIcon">🎓</div>
          <h1>CLASSMATE</h1>
          <p>Sistem Peminjaman Kelas Digital</p>
        </div>
        
        <p style="color:var(--gray-600); margin-bottom:24px;">
          Selamat datang di CLASSMATE! Platform digital untuk memudahkan 
          proses peminjaman ruangan kelas di kampus.
        </p>
        
        <div class="stack">
          <a href="<%= request.getContextPath() %>/login" class="btn btnPrimary btnLg" style="width:100%;">
            🚀 Login ke Sistem
          </a>
          <a href="<%= request.getContextPath() %>/rooms" class="btn btnOutline" style="width:100%;">
            🏫 Lihat Daftar Ruangan
          </a>
        </div>
      </div>
    </div>
  </body>
</html>
