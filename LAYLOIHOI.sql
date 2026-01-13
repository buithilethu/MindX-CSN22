CREATE DATABASE LAYLOIHOI;
GO
USE LAYLOIHOI;
GO
-- KHÁCH HÀNG
CREATE TABLE KHACH_HANG (
    MAKH INT PRIMARY KEY,
    TENKH NVARCHAR(50),
    DIACHI NVARCHAR(100),
    SDT CHAR(11)
);
-- PHÒNG
CREATE TABLE PHONG (
    MAPHONG INT PRIMARY KEY,
    LOAIPHONG NVARCHAR(20),
    SOKHACHTOIDA INT,
    GIAPHONG DECIMAL(18,0),
    MOTA NVARCHAR(255)
);
-- ĐẶT PHÒNG
CREATE TABLE DAT_PHONG (
    MADATPHONG INT PRIMARY KEY,
    MAPHONG INT,
    MAKH INT,
    NGAYDAT DATE,
    GIOBATDAU TIME,
    GIOKETTHUC TIME,
    TIENDATCOC DECIMAL(18,0),
    GHICHU NVARCHAR(255),
    TRANGTHAIDAT NVARCHAR(30),

    CONSTRAINT FK_DP_PHONG FOREIGN KEY (MAPHONG) REFERENCES PHONG(MAPHONG),
    CONSTRAINT FK_DP_KH FOREIGN KEY (MAKH) REFERENCES KHACH_HANG(MAKH)
);
-- DỊCH VỤ ĐI KÈM
CREATE TABLE DICH_VU_DI_KEM (
    MADV INT PRIMARY KEY,
    TENDV NVARCHAR(100),
    DONVITINH NVARCHAR(20),
    DONGIA DECIMAL(18,0)
);
-- CHI TIẾT SỬ DỤNG DỊCH VỤ
CREATE TABLE CHI_TIET_SU_DUNG_DV (
    MADATPHONG INT,
    MADV INT,
    SOLUONG INT,

    PRIMARY KEY (MADATPHONG, MADV),
    CONSTRAINT FK_CT_DP FOREIGN KEY (MADATPHONG) REFERENCES DAT_PHONG(MADATPHONG),
    CONSTRAINT FK_CT_DV FOREIGN KEY (MADV) REFERENCES DICH_VU_DI_KEM(MADV)
);
-- THÊM DỮ LIỆU 
-- PHÒNG
INSERT INTO PHONG VALUES
(1, N'Loại 1', 20, 60000, ''),
(2, N'Loại 1', 25, 80000, ''),
(3, N'Loại 2', 15, 50000, ''),
(4, N'Loại 3', 20, 50000, '');
-- KHÁCH HÀNG
INSERT INTO KHACH_HANG VALUES
(1, N'Nguyễn Văn A', N'Hoa Xuân', '11111111111'),
(2, N'Nguyễn Văn B', N'Hoa Haỉ', '11111111112'),
(3, N'Phan Văn A', N'Cẩm Lê', '11111111113'),
(4, N'Phan Văn B', N'Hoa Xuân', '11111111114'),
(5, N'Hà Minh', N'Đà Nẵng', '11111111115'),
(6, N'NM Hùng', N'Huế', '11111111116');

-- dịch vụ đi kèm
INSERT INTO DICH_VU_DI_KEM VALUES
(1, N'Beer', N'Lon', 10000),
(2, N'Nước ngọt', N'Lon', 8000),
(3, N'Trái cây', N'Đĩa', 35000),
(4, N'Khăn ướt', N'Cái', 2000),
(5, N'Bia lớn', N'Lon', 15000),
(6, N'Khăn giấy', N'Cái', 3000);
-- đặt phòng
INSERT INTO DAT_PHONG VALUES
(1, 1, 2, '2018-03-26', '11:00', '13:30', 100000, '', N'Đã đặt'),
(2, 1, 3, '2018-03-27', '17:15', '19:15', 50000, '', N'Đã huỷ'),
(3, 2, 2, '2018-03-26', '20:30', '22:15', 100000, '', N'Đã đặt'),
(4, 3, 1, '2018-04-01', '19:30', '21:15', 200000, '', N'Đã đặt'),
(5, 2, 1, '2016-05-20', '18:00', '20:00', 50000, '', N'Đã đặt'),
(6, 1, 4, '2017-08-15', '19:00', '22:00', 80000, '', N'Đã đặt');

-- chi tiết sử dụng dịch vụ 
INSERT INTO CHI_TIET_SU_DUNG_DV VALUES
(1, 1, 20),
(1, 2, 10),
(1, 3, 3),
(2, 2, 10),
(2, 3, 1),
(3, 3, 2),
(3, 4, 10),
(4, 1, 6),
(4, 2, 7);
--Phần I:
--Câu 1: Liệt kê MaDatPhong, MaDV, SoLuong của tất cả các dịch vụ có số lượng lớn hơn 3 và nhỏ hơn 10. (1 điểm)
SELECT MADATPHONG, MADV, SOLUONG
FROM CHI_TIET_SU_DUNG_DV
WHERE SOLUONG > 3 AND SOLUONG < 10;

--Câu 2: Cập nhật dữ liệu trên trường Gia Phong thuộc bảng PHONG tăng lên 10,000 VND so với giá phòng hiện tại,chỉ cập nhật giá phòng của những phòng có số khách tối đa lớn hơn 10. (1 điểm)
UPDATE PHONG
SET GIAPHONG = GIAPHONG + 10000
WHERE SOKHACHTOIDA > 10;

--Câu 3: Xóa tất cả những đơn đặt phòng (từ bảng DAT_PHONG) có trạng thái đặt (Trang TraiDat) là “Da huy”. (1 điểm)
DELETE FROM DAT_PHONG
WHERE TRANGTHAIDAT = N'Đã hủy';

--Phần II:
--Câu 4: Hiển thị Tên KH của những khách hàng có tên bắt đầu là một trong các ký tự “H”, “NM” và có độ dài tối đa là 20 ký tự. (1 điểm)
SELECT TENKH FROM KHACH_HANG
WHERE (TENKH LIKE 'H%' OR TENKH LIKE 'NM%') AND LEN(TENKH) <= 20;

--Câu 5: Hiển thị Tên KH của tất cả các khách hàng có trong hệ thống, TenKH nào trùng nhau thì chỉ hiển thị một lần. Sinh viên sử dụng hai cách khác nhau để thực hiện yêu cầu trên, mỗi cách sẽ được 0,5 điểm. (1 điểm)
--c1
SELECT DISTINCT TENKH
FROM KHACH_HANG;
--c2
SELECT TENKH
FROM KHACH_HANG
GROUP BY TENKH;

--Câu 6: Hiển thị MaDV, TenDV, DonViTinh, DonGia của những dịch vụ đi kèm có DonViTinh là “lớn” và có DonGia lớn hơn 10,000 VNĐ hoặc những dịch vụ đi kèm có DonViTinh là “Cai” và có DonGia nhỏ hơn 5,000 VNĐ. (2 điểm)
SELECT MADV, TENDV, DONVITINH, DONGIA
FROM DICH_VU_DI_KEM
WHERE (DONVITINH = N'Lon' AND DONGIA > 10000)
   OR (DONVITINH = N'Cái' AND DONGIA < 5000);


--Câu 7: Hiển thị MaDatPhong, MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, MaKH, TenKH, SoDT, NgayDat, GioBatDau, Gio Ket Thuc, MaDichVu, SoLuong, DonGia của những đơn đặt phòng có năm đặt phòng là “2016”, “2017” và đặt những phòng có giá phòng > 50,000 VNĐ/ 1 giờ. (2 điểm)
SELECT
    dp.MADATPHONG,
    p.MAPHONG,
    p.LOAIPHONG,
    p.SOKHACHTOIDA,
    p.GIAPHONG,
    kh.MAKH,
    kh.TENKH,
    kh.SDT,
    dp.NGAYDAT,
    dp.GIOBATDAU,
    dp.GIOKETTHUC,
    dv.MADV,
    ct.SOLUONG,
    dv.DONGIA
FROM DAT_PHONG dp
JOIN PHONG p ON dp.MAPHONG = p.MAPHONG
JOIN KHACH_HANG kh ON dp.MAKH = kh.MAKH
LEFT JOIN CHI_TIET_SU_DUNG_DV ct ON dp.MADATPHONG = ct.MADATPHONG
LEFT JOIN DICH_VU_DI_KEM dv ON ct.MADV = dv.MADV
WHERE YEAR(dp.NGAYDAT) IN (2016, 2017)
AND p.GIAPHONG > 50000;

--Phần III:
--Câu 8: Hiển thị MaDass Phong, MaPhong, LoaiPhong, Gia Phong, TenKH, Ngay Dat, Tong Tien Hat, Tong Tien Su Dung DichVu, ThongTinThanhToan tương ứng với từng mã đặt phòng có trong bảng DAT_PHONG. Những đơn đặt phòng nào không sử dụng dịch vụ đi kèm thì cũng liệt kê thông tin của đơn đặt phòng đó ra. (1 điểm)

--TongTien Hat = Giai Phong * (Gio Ket Thuc – Gio Bat Dau)
--Tong Tien Su Dung DichVu = So Luong * Don Gia
--ThongTinThanhToan = TongTien Hat + sum (TongTien Su Dung DichVu)

SELECT
    dp.MADATPHONG,
    p.MAPHONG,
    p.LOAIPHONG,
    p.GIAPHONG,
    kh.TENKH,
    dp.NGAYDAT,

    p.GIAPHONG * DATEDIFF(HOUR, dp.GIOBATDAU, dp.GIOKETTHUC) AS TongTienHat,

    ISNULL(SUM(ct.SOLUONG * dv.DONGIA), 0) AS TongTienDichVu,

    p.GIAPHONG * DATEDIFF(HOUR, dp.GIOBATDAU, dp.GIOKETTHUC)
    + ISNULL(SUM(ct.SOLUONG * dv.DONGIA), 0) AS ThongTinThanhToan

FROM DAT_PHONG dp
JOIN PHONG p ON dp.MAPHONG = p.MAPHONG
JOIN KHACH_HANG kh ON dp.MAKH = kh.MAKH
LEFT JOIN CHI_TIET_SU_DUNG_DV ct ON dp.MADATPHONG = ct.MADATPHONG
LEFT JOIN DICH_VU_DI_KEM dv ON ct.MADV = dv.MADV
GROUP BY
    dp.MADATPHONG, p.MAPHONG, p.LOAIPHONG,
    p.GIAPHONG, kh.TENKH,
    dp.NGAYDAT, dp.GIOBATDAU, dp.GIOKETTHUC;
