package com.tubespbo.classmate.service;

import com.tubespbo.classmate.dao.BookingDao;
import com.tubespbo.classmate.model.Booking;

import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

public class ReportService {

    private final BookingDao bookingDao = new BookingDao();

    private static final DateTimeFormatter REPORT_DT_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public List<Booking> getBookings(LocalDate from, LocalDate to) throws Exception {
        LocalDateTime start = LocalDateTime.of(from, LocalTime.MIN);
        LocalDateTime end = LocalDateTime.of(to, LocalTime.MAX);
        return bookingDao.listBetween(start, end);
    }

    public void writeCsv(List<Booking> list, OutputStream out) throws Exception {
        String header = "id,user_nama,user_email,room,waktu_mulai,waktu_selesai,status,keperluan,alasan\n";
        out.write(header.getBytes(StandardCharsets.UTF_8));
        for (Booking b : list) {
            String line = b.getId() + "," +
                    csv(b.getUserNama()) + "," +
                    csv(b.getUserEmail()) + "," +
                    csv(b.getRoomNama()) + "," +
                    csv(b.getWaktuMulai().format(REPORT_DT_FMT)) + "," +
                    csv(b.getWaktuSelesai().format(REPORT_DT_FMT)) + "," +
                    csv(b.getStatus().name()) + "," +
                    csv(b.getKeperluan()) + "," +
                    csv(b.getAlasan()) +
                    "\n";
            out.write(line.getBytes(StandardCharsets.UTF_8));
        }
    }

    public void writePdf(List<Booking> list, OutputStream out, String title) throws Exception {
        try (PDDocument doc = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A4);
            doc.addPage(page);

            try (PDPageContentStream cs = new PDPageContentStream(doc, page)) {
                cs.beginText();
                cs.setFont(PDType1Font.HELVETICA_BOLD, 14);
                cs.newLineAtOffset(40, 800);
                cs.showText(title);
                cs.endText();

                float y = 770;
                cs.setFont(PDType1Font.HELVETICA, 10);

                for (Booking b : list) {
                    if (y < 60) {
                        cs.close();
                        page = new PDPage(PDRectangle.A4);
                        doc.addPage(page);
                        y = 800;
                    }

                    String row = String.format(
                            "#%d | %s (%s) | %s | %s - %s | %s",
                            b.getId(),
                            safe(b.getUserNama()),
                            safe(b.getUserEmail()),
                            safe(b.getRoomNama()),
                            b.getWaktuMulai().format(REPORT_DT_FMT),
                            b.getWaktuSelesai().format(REPORT_DT_FMT),
                            b.getStatus().name()
                    );

                    try (PDPageContentStream csRow = new PDPageContentStream(doc, page, PDPageContentStream.AppendMode.APPEND, true)) {
                        csRow.beginText();
                        csRow.setFont(PDType1Font.HELVETICA, 10);
                        csRow.newLineAtOffset(40, y);
                        csRow.showText(row);
                        csRow.endText();
                    }

                    y -= 14;
                }
            }

            doc.save(out);
        }
    }

    private static String csv(String s) {
        if (s == null) {
            return "";
        }
        String v = s.replace("\"", "\"\"");
        if (v.contains(",") || v.contains("\n") || v.contains("\r")) {
            return "\"" + v + "\"";
        }
        return v;
    }

    private static String safe(String s) {
        return s == null ? "" : s;
    }
}
