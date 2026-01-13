CREATE DATABASE QuanLyDatBan;
GO
--- TAO BANG ---
CREATE TABLE BAN (
    MABAN int PRIMARY KEY,
    LOAIBAN nvarchar(20),
    SOKHACH_TOIDA int,
    GIABAN int,
    MOTA nvarchar(255)
);

CREATE TABLE KHACH_HANG (
    MAKH int PRIMARY KEY,
    TENKH nvarchar(30),
    DIACHI nvarchar(50),
    SDT char(11)
);

CREATE TABLE DICH_VU_DI_KEM (
    MADV int PRIMARY KEY,
    TENDV nvarchar(255),
    DONVITINH nvarchar(30),
    DONGIA int
);

CREATE TABLE DAT_BAN (
    MADATBAN int PRIMARY KEY,
    MABAN int,
    MAKH int,
    NGAYDAT date,
    GIOBATDAU time,
    GIOKETTHUC time,
    TIENDATCOC int,
    GHICHU nvarchar(255),
    TRANGTHAIDAT int,
    FOREIGN KEY (MABAN) REFERENCES BAN(MABAN),
    FOREIGN KEY (MAKH) REFERENCES KHACH_HANG(MAKH)
);

CREATE TABLE CHI_TIET_SU_DUNG_DV (
    MADATBAN int,
    MADV int,
    SOLUONG int,
    PRIMARY KEY (MADATBAN, MADV), -- Khóa chính hỗn hợp
    FOREIGN KEY (MADATBAN) REFERENCES DAT_BAN(MADATBAN),
    FOREIGN KEY (MADV) REFERENCES DICH_VU_DI_KEM(MADV)
);
--- DU LIEU NGUOI DUNG ---

-- BANG BAN--
INSERT INTO BAN (MABAN, LOAIBAN, SOKHACH_TOIDA, GIABAN, MOTA) VALUES
(1, N'Thường', 4, 100000, N'Bàn gần cửa sổ'),
(2, N'VIP', 6, 200000, N'Phòng riêng có điều hòa'),
(3, N'VIP 2', 10, 300000, N'Phòng lớn, karaoke');
-- BANG KHACH HANG-
INSERT INTO KHACH_HANG (MAKH, TENKH, DIACHI, SDT) VALUES
(1, N'Bùi Văn A', N'Thái Bình', '0912345678'),
(2, N'Trần Thị B', N'Đồng Nai', '0988888888'),
(3, N'Lê Văn C', N'TP.HCM', '0909999999');
-- BANG DICHH VU DI KEM --
INSERT INTO DICH_VU_DI_KEM (MADV, TENDV, DONVITINH, DONGIA) VALUES
(1, N'Nước suối', N'Chai', 15000),
(2, N'Nước cam', N'Lon', 25000),
(3, N'Trái cây', N'Dĩa', 100000),
(4, N'Khăn lạnh', N'Cái', 5000);
-- BANG DAT BAN --
INSERT INTO DAT_BAN (MADATBAN, MABAN, MAKH, NGAYDAT, GIOBATDAU, GIOKETTHUC, TIENDATCOC, GHICHU, TRANGTHAIDAT) VALUES
(101, 1, 1, '2024-05-10', '18:00', '20:00', 50000, N'Đã xác nhận', 1),
(102, 2, 2, '2024-05-10', '19:00', '22:00', 100000, N'Đã xác nhận', 1),
(103, 3, 1, '2024-05-11', '17:00', '21:00', 150000, N'Đã đặt', 1),
(104, 2, 3, '2024-06-15', '20:00', '23:00', 100000, N'Đã hủy', 0);
-- BANG CHI TIET SU DUNG DICH VU --
INSERT INTO CHI_TIET_SU_DUNG_DV (MADATBAN, MADV, SOLUONG) VALUES
(101, 1, 4), -- Đơn 101 dùng 4 nước suối
(101, 4, 4), -- Đơn 101 dùng 4 khăn lạnh
(102, 2, 10), -- Đơn 102 dùng 10 nước cam
(102, 3, 2),  -- Đơn 102 dùng 2 dĩa trái cây
(103, 1, 10); -- Đơn 103 dùng 10 nước suối 
--- CAU LENH TRUY VAN ---
-- 1: Thống kê số lượng bàn đã đặt theo ngày
    SELECT NGAYDAT, COUNT(MADATBAN) AS SoLuongBanDat
    FROM DAT_BAN
    GROUP BY NGAYDAT;
-- 2: Tính tổng tiền cọc đã thu theo từng khách hàng
    SELECT kh.TENKH, SUM(db.TIENDATCOC) AS TongTienCoc
    FROM KHACH_HANG kh
    JOIN DAT_BAN db ON kh.MAKH = db.MAKH
    GROUP BY kh.MAKH, kh.TENKH;
-- 3: Liệt kê 3 dịch vụ được sử dụng kèm theo đặt bàn
    SELECT DISTINCT TOP 3 dv.TENDV
    FROM DICH_VU_DI_KEM dv
    JOIN CHI_TIET_SU_DUNG_DV ct ON dv.MADV = ct.MADV;
-- 4: Tìm 3 khách hàng đặt nhiều bàn nhất
    SELECT TOP 3 kh.TENKH, COUNT(db.MADATBAN) AS SoLanDat
    FROM KHACH_HANG kh
    JOIN DAT_BAN db ON kh.MAKH = db.MAKH
    GROUP BY kh.MAKH, kh.TENKH
    ORDER BY SoLanDat DESC;
-- 5: Tính doanh thu từ các dịch vụ đi kèm 
    SELECT SUM(ct.SOLUONG * dv.DONGIA) AS TongDoanhThuDV
    FROM CHI_TIET_SU_DUNG_DV ct
    JOIN DICH_VU_DI_KEM dv ON ct.MADV = dv.MADV;
-- 6: Hiển thị chi tiết các đơn đặt bàn có năm đặt là 2024 và giá bàn lớn hơn 150/ giờ
    SELECT SUM(b.GIABAN * DATEDIFF(hour, db.GIOBATDAU, db.GIOKETTHUC)) AS DoanhThuBanVIP
    FROM DAT_BAN db
    JOIN BAN b ON db.MABAN = b.MABAN
    WHERE YEAR(db.NGAYDAT) = 2024 AND b.GIABAN > 150000;
-- 7: Hiển thị thông tin chi tiết của mỗi đơn đặt bàn 
    SELECT 
        db.MADATBAN, db.MABAN, b.LOAIBAN, b.GIABAN, kh.TENKH, db.NGAYDAT,
        -- 1. Tiền bàn
        (b.GIABAN * DATEDIFF(hour, db.GIOBATDAU, db.GIOKETTHUC)) AS TongTienBan,
        -- 2. Tiền dịch vụ (Tính trực tiếp)
        ISNULL((SELECT SUM(SOLUONG * DONGIA) FROM CHI_TIET_SU_DUNG_DV ct 
                JOIN DICH_VU_DI_KEM dv ON ct.MADV = dv.MADV 
                WHERE ct.MADATBAN = db.MADATBAN), 0) AS TongTienDichVu,
        -- 3. Tổng cộng
        (b.GIABAN * DATEDIFF(hour, db.GIOBATDAU, db.GIOKETTHUC)) + 
        ISNULL((SELECT SUM(SOLUONG * DONGIA) FROM CHI_TIET_SU_DUNG_DV ct 
                JOIN DICH_VU_DI_KEM dv ON ct.MADV = dv.MADV 
                WHERE ct.MADATBAN = db.MADATBAN), 0) AS TongTienThanhToan
    FROM DAT_BAN db
    JOIN BAN b ON db.MABAN = b.MABAN
    JOIN KHACH_HANG kh ON db.MAKH = kh.MAKH;
    --
     SELECT * FROM DAT_BAN
     --
     SELECT NGAYDAT, COUNT(MADATBAN) AS SOLUONGDATBAN
     FROM DAT_BAN
     GROUP BY NGAYDAT;
     --
     SELECT MONTH(NGAYDAT) AS THANG,
        COUNT(MADATBAN) AS SOLUONGDATBAN
     FROM DAT_BAN
     WHERE YEAR(NGAYDAT)=2024
     AND MONTH(NGAYDAT) BETWEEN 4 AND 6
     GROUP BY MONTH(NGAYDAT)
     ORDER BY THANG;

     --  
     SELECT 
            b.MABAN,
            b.LOAIBAN,
     SUM(ct.SOLUONG * dv.DONGIA) AS TONGDICHVU
     FROM DAT_BAN db
     JOIN BAN b ON db.MABAN=b.MABAN
     JOIN CHI_TIET_SU_DUNG_DV ct ON db.MADATBAN=ct.MADATBAN
     JOIN DICH_VU_DI_KEM dv ON ct.MADV= dv.MADV
     GROUP BY b.MABAN,b.LOAIBAN;
