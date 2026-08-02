# TubesPBO (CLASSMATE) - VS Code + Tomcat XAMPP

Project ini adalah webapp Java EE (Maven `war`) yang bisa dibuka dan dikerjakan di VS Code.

## Prasyarat
- Wajib JDK (bukan JRE) karena build butuh `javac` (disarankan JDK 17; JDK 8 juga oke)
- Maven Wrapper sudah disediakan (pakai `mvnw.cmd`), jadi tidak wajib install Maven global
- Tomcat dari XAMPP (umumnya di `C:\\xampp\\tomcat`)

Jika `mvnw.cmd` error "Java tidak ditemukan", set `JAVA_HOME` dulu.

Verifikasi di terminal:
```powershell
java -version
javac -version
```

## Setup Tomcat (XAMPP)
Set environment variable `TOMCAT_HOME` (sekali saja):

PowerShell:
```powershell
setx TOMCAT_HOME "C:\\xampp\\tomcat"
```

Tutup-buka VS Code setelah setx.

## Build & Deploy dari VS Code
- Task: `mvn: package (war)` -> build WAR
- Task: `deploy: copy WAR to Tomcat (XAMPP)` -> build + copy ke `%TOMCAT_HOME%\\webapps\\TubesPBO.war`
- Task: `tomcat: startup (XAMPP)` / `tomcat: shutdown (XAMPP)`

Alternatif via terminal:
```powershell
./mvnw.cmd -q clean package
```

## URL
- Home static: `http://localhost:8080/TubesPBO/`
- Servlet demo: `http://localhost:8080/TubesPBO/home`

Jika port Tomcat XAMPP berbeda, sesuaikan URL-nya.
