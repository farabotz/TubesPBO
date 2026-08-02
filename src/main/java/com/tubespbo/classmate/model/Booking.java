package com.tubespbo.classmate.model;

import java.time.LocalDateTime;

public class Booking {

    private int id;
    private int userId;
    private int roomId;
    private LocalDateTime waktuMulai;
    private LocalDateTime waktuSelesai;
    private String keperluan;
    private BookingStatus status;
    private String alasan;

    // convenience fields for display
    private String userNama;
    private String userEmail;
    private String roomNama;
    private String roomLokasi;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public LocalDateTime getWaktuMulai() {
        return waktuMulai;
    }

    public void setWaktuMulai(LocalDateTime waktuMulai) {
        this.waktuMulai = waktuMulai;
    }

    public LocalDateTime getWaktuSelesai() {
        return waktuSelesai;
    }

    public void setWaktuSelesai(LocalDateTime waktuSelesai) {
        this.waktuSelesai = waktuSelesai;
    }

    public String getKeperluan() {
        return keperluan;
    }

    public void setKeperluan(String keperluan) {
        this.keperluan = keperluan;
    }

    public BookingStatus getStatus() {
        return status;
    }

    public void setStatus(BookingStatus status) {
        this.status = status;
    }

    public String getAlasan() {
        return alasan;
    }

    public void setAlasan(String alasan) {
        this.alasan = alasan;
    }

    public String getUserNama() {
        return userNama;
    }

    public void setUserNama(String userNama) {
        this.userNama = userNama;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getRoomNama() {
        return roomNama;
    }

    public void setRoomNama(String roomNama) {
        this.roomNama = roomNama;
    }

    public String getRoomLokasi() {
        return roomLokasi;
    }

    public void setRoomLokasi(String roomLokasi) {
        this.roomLokasi = roomLokasi;
    }
}
