/*
    A. VERI TABANI TASARIM - DB OLUSTURMA
*/
-- TechMarket_DB Veritabani 
CREATE DATABASE TechMarket_DB;
GO

USE TechMarket_DB;
GO

-- 1. Musteri
CREATE TABLE Musteri (
    id INT PRIMARY KEY IDENTITY(1,1),
    ad NVARCHAR(50) NOT NULL,
    soyad NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    telefon NVARCHAR(20),
    sehir NVARCHAR(50),
    adres NVARCHAR(MAX),
    dogum_tarihi DATE,
    loyalite_puani INT DEFAULT 0,
    aktif_durum BIT DEFAULT 1,
    kayit_tarihi DATETIME DEFAULT GETDATE()
);
GO

-- 2. Marka
CREATE TABLE Marka (
    id INT PRIMARY KEY IDENTITY(1,1),
    ad NVARCHAR(100) NOT NULL,
    aciklama NVARCHAR(MAX)
);
GO

-- 3. Kategori
CREATE TABLE Kategori (
    id INT PRIMARY KEY IDENTITY(1,1),
    ad NVARCHAR(100) NOT NULL,
    ust_kategori_id INT,
    FOREIGN KEY (ust_kategori_id) REFERENCES Kategori(id)
);
GO

-- 4. Satici
CREATE TABLE Satici (
    id INT PRIMARY KEY IDENTITY(1,1),
    ad NVARCHAR(100) NOT NULL,
    adres NVARCHAR(MAX),
    telefon NVARCHAR(20),
    email NVARCHAR(100)
);
GO

-- 5. Urun
CREATE TABLE Urun (
    id INT PRIMARY KEY IDENTITY(1,1),
    ad NVARCHAR(200) NOT NULL,
    satis_fiyati DECIMAL(10,2) NOT NULL,
    alis_fiyati DECIMAL(10,2) NOT NULL,
    stok INT DEFAULT 0,
    kategori_id INT NOT NULL,
    satici_id INT NOT NULL,
    marka_id INT,
    model NVARCHAR(100),
    barkod NVARCHAR(50) UNIQUE,
    garanti_suresi INT, -- Ay cinsinden
    urun_resim_url NVARCHAR(255),
    aktif_durum BIT DEFAULT 1,
    eklenme_tarihi DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (kategori_id) REFERENCES Kategori(id),
    FOREIGN KEY (satici_id) REFERENCES Satici(id),
    FOREIGN KEY (marka_id) REFERENCES Marka(id)
);
GO

-- 6. Urun Ozellik
CREATE TABLE Urun_Ozellik (
    id INT PRIMARY KEY IDENTITY(1,1),
    urun_id INT NOT NULL,
    ozellik_adi NVARCHAR(100) NOT NULL,
    ozellik_degeri NVARCHAR(255) NOT NULL,
    FOREIGN KEY (urun_id) REFERENCES Urun(id) ON DELETE CASCADE
);
GO

-- 7. Kampanya
CREATE TABLE Kampanya (
    id INT PRIMARY KEY IDENTITY(1,1),
    ad NVARCHAR(100) NOT NULL,
    aciklama NVARCHAR(MAX),
    indirim_yuzdesi DECIMAL(5,2),
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL,
    aktif BIT DEFAULT 1
);
GO

-- 8. Urun Kampanya
CREATE TABLE Urun_Kampanya (
    id INT PRIMARY KEY IDENTITY(1,1),
    urun_id INT NOT NULL,
    kampanya_id INT NOT NULL,
    FOREIGN KEY (urun_id) REFERENCES Urun(id) ON DELETE CASCADE,
    FOREIGN KEY (kampanya_id) REFERENCES Kampanya(id) ON DELETE CASCADE
);
GO

-- 9. Siparis
CREATE TABLE Siparis (
    id INT PRIMARY KEY IDENTITY(1,1),
    musteri_id INT NOT NULL,
    tarih DATETIME DEFAULT GETDATE(),
    toplam_tutar DECIMAL(10,2) NOT NULL,
    odeme_turu NVARCHAR(20) CHECK (odeme_turu IN ('Kredi Kart�', 'Banka Kart�', 'Havale', 'Kap�da �deme')) NOT NULL,
    siparis_durumu NVARCHAR(20) CHECK (siparis_durumu IN ('Beklemede', 'Onayland�', 'Haz�rlan�yor', 'Kargoland�', 'Teslim Edildi', '�ptal')) DEFAULT 'Beklemede',
    kargo_ucreti DECIMAL(10,2) DEFAULT 0,
    teslimat_adresi NVARCHAR(MAX),
    FOREIGN KEY (musteri_id) REFERENCES Musteri(id)
);
GO

-- 10. Siparis Detay
CREATE TABLE Siparis_Detay (
    id INT PRIMARY KEY IDENTITY(1,1),
    siparis_id INT NOT NULL,
    urun_id INT NOT NULL,
    adet INT NOT NULL,
    satis_fiyati DECIMAL(10,2) NOT NULL,
    alis_fiyati DECIMAL(10,2) NOT NULL,
    indirim_tutari DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (siparis_id) REFERENCES Siparis(id) ON DELETE CASCADE,
    FOREIGN KEY (urun_id) REFERENCES Urun(id)
);
GO

-- 11. Kargo
CREATE TABLE Kargo (
    id INT PRIMARY KEY IDENTITY(1,1),
    siparis_id INT NOT NULL,
    kargo_firmasi NVARCHAR(100) NOT NULL,
    takip_no NVARCHAR(50),
    gonderim_tarihi DATE,
    teslim_tarihi DATE,
    durum NVARCHAR(20) CHECK (durum IN ('Haz�rlan�yor', 'Kargoya Verildi', 'Da��t�mda', 'Teslim Edildi')) DEFAULT 'Haz�rlan�yor',
    FOREIGN KEY (siparis_id) REFERENCES Siparis(id)
);
GO

-- 12. Iade
CREATE TABLE Iade (
    id INT PRIMARY KEY IDENTITY(1,1),
    siparis_id INT NOT NULL,
    urun_id INT NOT NULL,
    iade_nedeni NVARCHAR(MAX) NOT NULL,
    iade_tarihi DATE NOT NULL,
    durum NVARCHAR(20) CHECK (durum IN ('Talep Edildi', 'Onayland�', 'Reddedildi', 'Tamamland�')) DEFAULT 'Talep Edildi',
    iade_tutari DECIMAL(10,2),
    FOREIGN KEY (siparis_id) REFERENCES Siparis(id),
    FOREIGN KEY (urun_id) REFERENCES Urun(id)
);
GO

-- 13. Urun Degerlendirme
CREATE TABLE Urun_Degerlendirme (
    id INT PRIMARY KEY IDENTITY(1,1),
    urun_id INT NOT NULL,
    musteri_id INT NOT NULL,
    puan INT CHECK (puan BETWEEN 1 AND 5),
    yorum NVARCHAR(MAX),
    degerlendirme_tarihi DATETIME DEFAULT GETDATE(),
    onay_durumu BIT DEFAULT 0,
    FOREIGN KEY (urun_id) REFERENCES Urun(id),
    FOREIGN KEY (musteri_id) REFERENCES Musteri(id)
);
GO

-- 14. Sepet
CREATE TABLE Sepet (
    id INT PRIMARY KEY IDENTITY(1,1),
    musteri_id INT NOT NULL,
    urun_id INT NOT NULL,
    adet INT NOT NULL DEFAULT 1,
    eklenme_tarihi DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (musteri_id) REFERENCES Musteri(id) ON DELETE CASCADE,
    FOREIGN KEY (urun_id) REFERENCES Urun(id)
);
GO

-- 15. Personel
CREATE TABLE Personel (
    id INT PRIMARY KEY IDENTITY(1,1),
    ad NVARCHAR(50) NOT NULL,
    soyad NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    rol NVARCHAR(30) CHECK (rol IN ('Admin', 'Y�netici', 'Sat��', 'Depo', 'M��teri Hizmetleri')),
    sifre_hash NVARCHAR(255) NOT NULL,
    aktif BIT DEFAULT 1,
    ise_giris_tarihi DATE
);
GO

/*
    A. VERI TABANI TASARIM - TABLO ICI VERI
*/

-- TechMarket_DB Ornek Veriler (Microsoft SQL Server)

USE TechMarket_DB;
GO

-- 1. Musteriler
INSERT INTO Musteri (ad, soyad, email, telefon, sehir, adres, dogum_tarihi, loyalite_puani) VALUES
(N'Ahmet', N'Y�lmaz', N'ahmet.yilmaz@email.com', N'05321234567', N'�stanbul', N'Kad�k�y, Moda Cad. No:15', '1985-03-15', 250),
(N'Ay�e', N'Demir', N'ayse.demir@email.com', N'05339876543', N'Ankara', N'�ankaya, K�z�lay Mah. No:42', '1990-07-22', 180),
(N'Mehmet', N'Kaya', N'mehmet.kaya@email.com', N'05445556677', N'�zmir', N'Kar��yaka, Bostanl� Sok. No:8', '1988-11-30', 420),
(N'Zeynep', N'�ahin', N'zeynep.sahin@email.com', N'05367778899', N'Bursa', N'Nil�fer, Atat�rk Cad. No:23', '1995-01-18', 95),
(N'Ali', N'�zt�rk', N'ali.ozturk@email.com', N'05551112233', N'Antalya', N'Muratpa�a, Lara Yolu No:67', '1982-09-05', 560),
(N'Fatma', N'�elik', N'fatma.celik@email.com', N'05423334455', N'Adana', N'Seyhan, �n�n� Cad. No:12', '1992-04-12', 140),
(N'Can', N'Arslan', N'can.arslan@email.com', N'05398887766', N'Kocaeli', N'�zmit, �ehit Pamir Cad. No:34', '1987-06-28', 310),
(N'Elif', N'Y�ld�z', N'elif.yildiz@email.com', N'05334445566', N'Konya', N'Sel�uklu, Mevlana Cad. No:56', '1993-12-03', 75);
GO

-- 2. Markalar
INSERT INTO Marka (ad, aciklama) VALUES
(N'Apple', N'Teknoloji ve elektronik �r�nleri'),
(N'Samsung', N'Ak�ll� telefon ve elektronik cihazlar'),
(N'LG', N'Ev elektroni�i ve beyaz e�ya'),
(N'Sony', N'Oyun konsolu ve elektronik e�lence sistemleri'),
(N'Dell', N'Bilgisayar ve i� istasyonlar�'),
(N'HP', N'Yaz�c� ve bilgisayar ekipmanlar�'),
(N'Lenovo', N'Diz�st� bilgisayar ve tablet'),
(N'Asus', N'Bilgisayar bile�enleri ve oyun ekipmanlar�'),
(N'Xiaomi', N'Ak�ll� telefon ve ak�ll� ev cihazlar�'),
(N'Bose', N'Ses sistemleri ve kulakl�klar'),
(N'JBL', N'Ta��nabilir hoparl�rler'),
(N'Logitech', N'Bilgisayar �evre birimleri'),
(N'Dyson', N'Elektrikli s�p�rge ve ev aletleri'),
(N'Philips', N'K���k ev aletleri');
GO

-- 3. Kategoriler
SET IDENTITY_INSERT Kategori ON;

INSERT INTO Kategori (id, ad, ust_kategori_id) VALUES
(1, N'Bilgisayar & Tablet', NULL),
(2, N'Telefon & Aksesuar', NULL),
(3, N'TV & Ses Sistemleri', NULL),
(4, N'Beyaz E�ya', NULL),
(5, N'K���k Ev Aletleri', NULL),
(6, N'Gaming', NULL),
(7, N'Diz�st� Bilgisayar', 1),
(8, N'Masa�st� Bilgisayar', 1),
(9, N'Tablet', 1),
(10, N'Ak�ll� Telefon', 2),
(11, N'Kulakl�k', 2),
(12, N'�arj Cihaz�', 2),
(13, N'Televizyon', 3),
(14, N'Hoparl�r', 3),
(15, N'Buzdolab�', 4),
(16, N'�ama��r Makinesi', 4),
(17, N'Elektrikli S�p�rge', 5),
(18, N'Blender', 5),
(19, N'Oyun Konsolu', 6),
(20, N'Oyun Kulakl���', 6);

SET IDENTITY_INSERT Kategori OFF;
GO

-- 4. Saticilar
INSERT INTO Satici (ad, adres, telefon, email) VALUES
(N'TechPlus Da��t�m A.�.', N'�stanbul, �mraniye Organize Sanayi', N'02161234567', N'info@techplus.com'),
(N'Elektronik Toptan Ltd.', N'Ankara, Siteler Toptan Sat��', N'03124567890', N'satis@elektroniktoptan.com'),
(N'Global Tech Import', N'�zmir, Bornova Sanayi', N'02325556677', N'destek@globaltech.com'),
(N'MegaTek Da��t�m', N'Bursa, Organize Sanayi B�lgesi', N'02243334455', N'siparis@megatek.com');
GO

-- 5. Urunler
INSERT INTO Urun (ad, satis_fiyati, alis_fiyati, stok, kategori_id, satici_id, marka_id, model, barkod, garanti_suresi, aktif_durum) VALUES
(N'iPhone 15 Pro 256GB', 54999.00, 48000.00, 25, 10, 1, 1, N'A2848', N'8697421234567', 24, 1),
(N'MacBook Air M2 13"', 42999.00, 37500.00, 15, 7, 1, 1, N'MLY33', N'8697421234568', 24, 1),
(N'Samsung Galaxy S24 Ultra', 47999.00, 42000.00, 30, 10, 2, 2, N'SM-S928', N'8697421234569', 24, 1),
(N'Samsung 65" QLED TV', 32999.00, 28000.00, 12, 13, 2, 2, N'QE65Q80C', N'8697421234570', 24, 1),
(N'Dell XPS 15 Laptop', 38999.00, 34000.00, 18, 7, 3, 5, N'XPS9530', N'8697421234571', 24, 1),
(N'Sony PlayStation 5', 21999.00, 19000.00, 40, 19, 1, 4, N'CFI-1216A', N'8697421234572', 24, 1),
(N'iPad Air 5 256GB', 24999.00, 21500.00, 20, 9, 1, 1, N'MM9E3', N'8697421234573', 24, 1),
(N'LG Buzdolab� 600L', 28999.00, 24000.00, 8, 15, 4, 3, N'GC-B247SLUV', N'8697421234574', 24, 1),
(N'Bose QuietComfort 45', 8999.00, 7200.00, 35, 11, 2, 10, N'QC45', N'8697421234575', 12, 1),
(N'Dyson V15 Detect', 15999.00, 13500.00, 22, 17, 3, 13, N'V15', N'8697421234576', 24, 1),
(N'Asus ROG Strix G16', 45999.00, 40000.00, 14, 7, 3, 8, N'G614JV', N'8697421234577', 24, 1),
(N'Samsung �ama��r Makinesi 9KG', 12999.00, 10500.00, 10, 16, 4, 2, N'WW90', N'8697421234578', 24, 1),
(N'JBL Charge 5 Hoparl�r', 3999.00, 3200.00, 50, 14, 2, 11, N'CHARGE5', N'8697421234579', 12, 1),
(N'Xiaomi Redmi Note 13', 8999.00, 7500.00, 45, 10, 2, 9, N'M2101K6G', N'8697421234580', 24, 1),
(N'HP LaserJet Yaz�c�', 4999.00, 4000.00, 28, 8, 3, 6, N'M140w', N'8697421234581', 12, 1),
(N'Logitech MX Master 3S', 2499.00, 2000.00, 60, 8, 3, 12, N'MXM3S', N'8697421234582', 12, 1),
(N'Apple AirPods Pro 2', 9999.00, 8500.00, 55, 11, 1, 1, N'MQD83', N'8697421234583', 12, 1),
(N'Lenovo IdeaPad Gaming', 28999.00, 25000.00, 16, 7, 3, 7, N'IdeaPad-Gaming3', N'8697421234584', 24, 1),
(N'Philips Airfryer XXL', 6999.00, 5800.00, 32, 5, 4, 14, N'HD9650', N'8697421234585', 24, 1),
(N'Sony WH-1000XM5', 11999.00, 10000.00, 26, 11, 2, 4, N'WH1000XM5', N'8697421234586', 12, 1);
GO

-- 6. Urun Ozellikler
INSERT INTO Urun_Ozellik (urun_id, ozellik_adi, ozellik_degeri) VALUES
(1, N'RAM', N'8 GB'),
(1, N'Depolama', N'256 GB'),
(1, N'Ekran Boyutu', N'6.1 inch'),
(1, N'Renk', N'Titanyum Mavi'),
(2, N'��lemci', N'Apple M2'),
(2, N'RAM', N'8 GB'),
(2, N'SSD', N'256 GB'),
(2, N'Ekran', N'13.6 inch Retina'),
(3, N'RAM', N'12 GB'),
(3, N'Depolama', N'512 GB'),
(3, N'Kamera', N'200 MP'),
(3, N'Renk', N'Titanyum Gri'),
(4, N'Ekran Boyutu', N'65 inch'),
(4, N'��z�n�rl�k', N'4K QLED'),
(4, N'HDR', N'Evet'),
(5, N'��lemci', N'Intel Core i7-13700H'),
(5, N'RAM', N'16 GB'),
(5, N'SSD', N'512 GB'),
(5, N'Ekran Kart�', N'NVIDIA RTX 4050'),
(6, N'Depolama', N'825 GB SSD'),
(6, N'Renk', N'Beyaz');
GO

-- 7. Kampanyalar
INSERT INTO Kampanya (ad, aciklama, indirim_yuzdesi, baslangic_tarihi, bitis_tarihi, aktif) VALUES
(N'Y�lba�� Kampanyas�', N'T�m elektronik �r�nlerde %15 indirim', 15.00, '2024-12-20', '2025-01-05', 1),
(N'Telefon Festivali', N'Ak�ll� telefonlarda �zel fiyatlar', 10.00, '2025-01-10', '2025-01-31', 1),
(N'Gaming Haftas�', N'Oyun ekipmanlar�nda %20 indirim', 20.00, '2025-02-01', '2025-02-15', 0),
(N'Bahar Kampanyas�', N'Beyaz e�yada b�y�k f�rsatlar', 12.00, '2025-03-01', '2025-03-31', 0);
GO

-- 8. Urun Kampanya
INSERT INTO Urun_Kampanya (urun_id, kampanya_id) VALUES
(1, 1), (2, 1), (3, 2), (14, 2),
(6, 3), (11, 3),
(8, 4), (12, 4);
GO

-- 9. Siparisler
INSERT INTO Siparis (musteri_id, tarih, toplam_tutar, odeme_turu, siparis_durumu, kargo_ucreti, teslimat_adresi) VALUES
(1, '2024-12-20 10:30:00', 55999.00, N'Kredi Kart�', N'Teslim Edildi', 0.00, N'Kad�k�y, Moda Cad. No:15, �stanbul'),
(2, '2024-12-22 14:20:00', 43999.00, N'Kredi Kart�', N'Teslim Edildi', 0.00, N'�ankaya, K�z�lay Mah. No:42, Ankara'),
(3, '2024-12-25 16:45:00', 25999.00, N'Banka Kart�', N'Kargoland�', 0.00, N'Kar��yaka, Bostanl� Sok. No:8, �zmir'),
(4, '2024-12-28 11:15:00', 12999.00, N'Havale', N'Onayland�', 29.90, N'Nil�fer, Atat�rk Cad. No:23, Bursa'),
(5, '2025-01-02 09:30:00', 70998.00, N'Kredi Kart�', N'Haz�rlan�yor', 0.00, N'Muratpa�a, Lara Yolu No:67, Antalya'),
(1, '2025-01-05 13:40:00', 14498.00, N'Kredi Kart�', N'Beklemede', 0.00, N'Kad�k�y, Moda Cad. No:15, �stanbul'),
(6, '2025-01-08 15:20:00', 8999.00, N'Kap�da �deme', N'Beklemede', 29.90, N'Seyhan, �n�n� Cad. No:12, Adana'),
(7, '2025-01-10 10:00:00', 48999.00, N'Kredi Kart�', N'Beklemede', 0.00, N'�zmit, �ehit Pamir Cad. No:34, Kocaeli');
GO

-- 10. Siparis Detaylari
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, satis_fiyati, alis_fiyati, indirim_tutari, ara_toplam) VALUES
(1, 1, 1, 54999.00, 48000.00, 0.00, 54999.00),
(1, 13, 1, 3999.00, 3200.00, 0.00, 3999.00),
(2, 2, 1, 42999.00, 37500.00, 0.00, 42999.00),
(3, 7, 1, 24999.00, 21500.00, 0.00, 24999.00),
(4, 12, 1, 12999.00, 10500.00, 0.00, 12999.00),
(5, 6, 2, 21999.00, 19000.00, 0.00, 43998.00),
(5, 20, 2, 11999.00, 10000.00, 0.00, 23998.00),
(6, 9, 1, 8999.00, 7200.00, 0.00, 8999.00),
(6, 16, 2, 2499.00, 2000.00, 0.00, 4998.00),
(7, 14, 1, 8999.00, 7500.00, 0.00, 8999.00),
(8, 3, 1, 47999.00, 42000.00, 0.00, 47999.00);
GO

-- 11. Kargo Bilgileri
INSERT INTO Kargo (siparis_id, kargo_firmasi, takip_no, gonderim_tarihi, teslim_tarihi, durum) VALUES
(1, N'Aras Kargo', N'AR123456789TR', '2024-12-21', '2024-12-23', N'Teslim Edildi'),
(2, N'Yurti�i Kargo', N'YI987654321TR', '2024-12-23', '2024-12-25', N'Teslim Edildi'),
(3, N'MNG Kargo', N'MN456789123TR', '2024-12-26', NULL, N'Da��t�mda'),
(4, N'S�rat Kargo', N'SR789456123TR', '2024-12-29', NULL, N'Kargoya Verildi'),
(5, N'Aras Kargo', N'AR321654987TR', '2025-01-03', NULL, N'Haz�rlan�yor');
GO

-- 12. Iade Kayitlari
INSERT INTO Iade (siparis_id, urun_id, iade_nedeni, iade_tarihi, durum, iade_tutari) VALUES
(2, 2, N'�r�n hasarl� geldi, klavyede sorun var', '2024-12-27', N'Tamamland�', 42999.00),
(1, 13, N'Beklentimi kar��lamad�, ses kalitesi d���k', '2024-12-24', N'Onayland�', 3999.00);
GO

-- 13. Urun Degerlendirmeleri
INSERT INTO Urun_Degerlendirme (urun_id, musteri_id, puan, yorum, onay_durumu) VALUES
(1, 1, 5, N'Harika bir telefon! Kamera kalitesi m�kemmel, pil �mr� �ok iyi.', 1),
(6, 5, 5, N'PlayStation 5 beklentilerimin �zerinde, oyunlar ak�c� �al���yor.', 1),
(7, 3, 4, N'iPad g�zel ama fiyat� biraz y�ksek. Performans olarak memnunum.', 1),
(9, 1, 5, N'Bose kulakl�k harika! G�r�lt� engelleme �zelli�i �ok ba�ar�l�.', 1),
(14, 6, 4, N'Xiaomi telefon fiyat/performans a��s�ndan �ok iyi. Tavsiye ederim.', 1),
(3, 8, 5, N'Samsung Galaxy S24 Ultra kamera �zellikleri inan�lmaz!', 0),
(12, 4, 3, N'�ama��r makinesi iyi �al���yor ama biraz g�r�lt�l�.', 1);
GO

-- 14. Sepet
INSERT INTO Sepet (musteri_id, urun_id, adet) VALUES
(2, 4, 1),
(2, 13, 2),
(4, 10, 1),
(8, 18, 1),
(8, 19, 1),
(5, 11, 1);
GO

-- 15. Personel
INSERT INTO Personel (ad, soyad, email, rol, sifre_hash, aktif, ise_giris_tarihi) VALUES
(N'Kemal', N'Ayd�n', N'kemal.aydin@techmarket.com', N'Admin', N'$2y$10$abcdefgh...', 1, '2020-01-15'),
(N'Selin', N'Korkmaz', N'selin.korkmaz@techmarket.com', N'Y�netici', N'$2y$10$ijklmnop...', 1, '2021-03-20'),
(N'Burak', N'Tekin', N'burak.tekin@techmarket.com', N'Sat��', N'$2y$10$qrstuvwx...', 1, '2022-06-10'),
(N'Merve', N'�zkan', N'merve.ozkan@techmarket.com', N'M��teri Hizmetleri', N'$2y$10$yzabcdef...', 1, '2023-02-14'),
(N'Emre', N'G�ne�', N'emre.gunes@techmarket.com', N'Depo', N'$2y$10$ghijklmn...', 1, '2023-08-05');
GO

/*
    B. VERI EKLEME VE GUNCELLEME
*/

-- 1. INSERT ISLEMLERI - (Veri Ekleme)

-- Yeni Musteri Ekleme
--KONTROL ET:
SELECT * FROM Musteri;

INSERT INTO Musteri (ad, soyad, email, telefon, sehir, adres, dogum_tarihi) 
VALUES 
(N'Deniz', N'Y�lmaz', N'deniz.yilmaz@email.com', N'05551234567', N'�stanbul', N'Be�ikta�, Barbaros Bulvar� No:45', '1991-05-20'),
(N'Cem', N'Akar', N'cem.akar@email.com', N'05449876543', N'Ankara', N'Ke�i�ren, Etlik Cad. No:78', '1989-08-12'),
(N'Seda', N'K�l��', N'seda.kilic@email.com', N'05338887766', N'�zmir', N'Alsancak, K�br�s �ehitleri Cad. No:23', '1994-03-07');
GO

-- Yeni Urun Ekleme
--KONTROL ET:
SELECT * FROM Urun;

INSERT INTO Urun (ad, satis_fiyati, alis_fiyati, stok, kategori_id, satici_id, marka_id, model, barkod, garanti_suresi, aktif_durum) 
VALUES (N'iPhone 16 Pro Max', 79999.00, 72000.00, 15, 10, 1, 1, N'A3089', N'8697421234590', 24, 1 );
GO

-- Yeni Siparis Ekleme
--KONTROL ET:
SELECT * FROM Siparis;

INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu, siparis_durumu, kargo_ucreti, teslimat_adresi) 
VALUES (9, 55999.00, N'Kredi Kart�', N'Beklemede', 0.00, N'Be�ikta�, Barbaros Bulvar� No:45, �stanbul');
GO

-- Yeni Kampanya Ekleme
--KONTROL ET:
SELECT * FROM Kampanya;

INSERT INTO Kampanya (ad, aciklama, indirim_yuzdesi, baslangic_tarihi, bitis_tarihi, aktif) 
VALUES (N'�ubat �ndirimleri', N'T�m laptop modellerinde %10 indirim', 10.00, '2025-02-01', '2025-02-28', 1);
GO


-- 2. UPDATE ISLEMLERI (Veri G�ncelleme)


-- Musteri Bilgilerini Guncelleme
--KONTROL ET:
SELECT * FROM Musteri;

UPDATE Musteri 
SET telefon = N'05321111111', sehir = N'�anakkale' 
WHERE id = 1;
GO

-- Musteri Loyalite Puani Artirma (Al��veri� yapt���nda)
--KONTROL ET:
SELECT * FROM Musteri;

UPDATE Musteri 
SET loyalite_puani = loyalite_puani + 100 
WHERE id = 5;
GO

-- Urun Fiyati Guncelleme
--KONTROL ET:
SELECT * FROM Urun;

UPDATE Urun 
SET satis_fiyati = 52999.00, alis_fiyati = 46000.00 
WHERE id = 1;
GO

-- Urun Stok Guncelleme
--KONTROL ET:
SELECT * FROM Urun;

UPDATE Urun 
SET stok = stok + 50 
WHERE id = 6;
GO

-- Urun Satildiginda Stok Azaltma
--KONTROL ET:
SELECT * FROM Urun;

UPDATE Urun 
SET stok = stok - 1 
WHERE id = 1;
GO

-- Siparis Durumu Guncelleme
--KONTROL ET:
SELECT * FROM Siparis;

UPDATE Siparis 
SET siparis_durumu = N'Onayland�' 
WHERE id = 6;
GO

UPDATE Siparis 
SET siparis_durumu = N'Kargoland�' 
WHERE id = 4;
GO

-- Kargo Durumu Guncelleme
--KONTROL ET:
SELECT * FROM Kargo;

UPDATE Kargo 
SET durum = N'Teslim Edildi', teslim_tarihi = '2025-01-15' 
WHERE siparis_id = 3;
GO

-- Kampanya Durumu Guncelleme 
--KONTROL ET:
SELECT * FROM Kampanya;

UPDATE Kampanya 
SET aktif = 0 
WHERE id = 2;
GO

-- Urun Degerlendirmesi Onaylama
--KONTROL ET:
SELECT * FROM Urun_Degerlendirme;

UPDATE Urun_Degerlendirme 
SET onay_durumu = 1 
WHERE id = 6;
GO

-- Iade Durumu Guncelleme
--KONTROL ET:
SELECT * FROM Iade;

UPDATE Iade 
SET durum = N'Tamamland�' 
WHERE id = 2;
GO

-- Personel Bilgisi Guncelleme
--KONTROL ET:
SELECT * FROM Personel;

UPDATE Personel 
SET rol = N'Y�netici', aktif = 1 
WHERE id = 3;
GO

-- Sepetteki Urun Adedi Guncelleme
--KONTROL ET:
SELECT * FROM Sepet;

UPDATE Sepet 
SET adet = 3 
WHERE musteri_id = 2 AND urun_id = 4;
GO

-- Urunu Pasif Yapma
--KONTROL ET:
SELECT * FROM Urun;

UPDATE Urun 
SET aktif_durum = 0 
WHERE id = 15;
GO

-- Toplu Fiyat Guncellemesi 
--KONTROL ET:
SELECT * FROM Urun WHERE kategori_id = 10;

UPDATE Urun 
SET satis_fiyati = satis_fiyati * 1.10 
WHERE kategori_id = 10; -- Ak�ll� telefonlarda %10 zam
GO


-- 3. DELETE ISLEMLERI (Veri Silme)

-- Sepetten Urun Silme
--KONTROL ET:
SELECT * FROM Sepet;

DELETE FROM Sepet 
WHERE musteri_id = 2 AND urun_id = 13;
GO

-- Kampanya Silme
--KONTROL ET:
SELECT * FROM Kampanya;

DELETE FROM Kampanya 
WHERE id = 4 AND aktif = 0; -- Sadece pasif kampanyalar silinsin
GO

-- Yorum Silme
--KONTROL ET:
SELECT * FROM Urun_Degerlendirme;

UPDATE Urun_Degerlendirme
SET onay_durumu = 0
WHERE id = 4;
GO

DELETE FROM Urun_Degerlendirme 
WHERE onay_durumu = 0; -- Onaylanmamis yorumlar
GO

-- Urun �zelligi Silme
--KONTROL ET:
SELECT * FROM Urun_Ozellik;

INSERT INTO Urun_Ozellik (urun_id, ozellik_adi, ozellik_degeri) 
VALUES (7, N'Renk', N'Beyaz');

DELETE FROM Urun_Ozellik 
WHERE urun_id = 7 AND ozellik_adi = N'Renk';
GO

-- Urun Kampanya Iliskisi Silme
--KONTROL ET:
SELECT * FROM Urun_Kampanya;

DELETE FROM Urun_Kampanya 
WHERE kampanya_id = 3; 
GO


-- 4. TRUNCATE ISLEMLERI (Tablo Verilerini Tamamen Temizleme)


-- Sepet tablosunu tamamen temizle (Tum musterilerin sepetini sifirla)
--KONTROL ET:
SELECT * FROM Sepet;

TRUNCATE TABLE Sepet;
GO

-- Not: TRUNCATE islemi tum verileri siler ve identity degerini sifirlar
-- DELETE'den daha hizlidir cunku log tutmaz
-- Ancak FOREIGN KEY kisitlamasi olan tablolarda kullanilamaz


-- 5. STOK YONETIMI - KAPSAMLI ORNEKLER

--Iade Durumunda Stok Artirma
--KONTROL ET:
SELECT * FROM Urun;

UPDATE Urun 
SET stok = stok + 1 
WHERE id = 2; 
GO

-- Stok Uyarisi - Dusuk Stoklu Urunler
--KONTROL ET:
SELECT * FROM Urun;

SELECT 
    U.id,
    U.ad,
    U.stok,
    M.ad AS marka,
    K.ad AS kategori
FROM Urun U
INNER JOIN Marka M ON U.marka_id = M.id
INNER JOIN Kategori K ON U.kategori_id = K.id
WHERE U.stok < 15 AND U.aktif_durum = 1 --satista olup stok 15den az olan
ORDER BY U.stok ASC;
GO

-- Toplu Stok Guncelleme
--KONTROL ET:
SELECT * FROM Urun
WHERE kategori_id = 10 AND marka_id = 1;

UPDATE Urun 
SET stok = stok + 100 
WHERE kategori_id = 10 AND marka_id = 1; -- Apple telefonlar i�in toplu stok giri�i
GO

-- Stok Sifir Olan Urunleri Pasif Yap
--KONTROL ET:
SELECT * FROM Urun
WHERE stok = 0;

--Stok 0 olan olmadigi icin 0 yaptik
UPDATE URUN
SET stok = 0
WHERE id = 8; 

UPDATE Urun 
SET aktif_durum = 0 
WHERE stok = 0;
GO


/*
    B. VERI SORGULAMA VE RAPORLAMA
*/

-- 1. TEMEL SORGULAR

--En cok siparis veren 5 musteri
--KONTROL:
SELECT * FROM Siparis;

SELECT TOP 5
    M.id,
    M.ad + N' ' + M.soyad AS [M��teri Ad�],
    COUNT(S.id) AS [Toplam Sipari�],
    SUM(S.toplam_tutar) AS [Toplam Harcama]
FROM Musteri M
INNER JOIN Siparis S ON M.id = S.musteri_id
GROUP BY M.id, M.ad, M.soyad
ORDER BY [Toplam Sipari�] DESC, [Toplam Harcama] DESC; --Toplam siparise gore s�ralan�yor fakat say� ayn� olursa da toplamharcamaya g�re de s�ralan�yor
GO

--En cok satilan urunler
--KONTROL:
SELECT * FROM Siparis_Detay;
SELECT * FROM Urun;

SELECT
    U.id,
    U.ad AS [�r�n Ad�],
    M.ad AS Marka,
    K.ad AS Kategori,
    SUM(SD.adet) AS [Toplam Sat�lan Adet],
    SUM(SD.satis_fiyati) AS [Toplam Sat�� Cirosu]
FROM Urun U
INNER JOIN Siparis_Detay SD ON U.id = SD.urun_id
INNER JOIN Marka M ON U.marka_id = M.id
INNER JOIN Kategori K ON U.kategori_id = K.id
GROUP BY U.id, U.ad, M.ad, K.ad, U.stok
ORDER BY [Toplam Sat�lan Adet] DESC, [Toplam Sat�� Cirosu] DESC;
GO

--En yuksek cirosu olan sat�c�lar
--KONTROL:
SELECT * FROM Siparis_Detay;
SELECT * FROM Satici;

SELECT 
    ST.id,
    ST.ad AS[Sat�c� Ad�],
    ST.telefon,
    ST.email,
    COUNT(DISTINCT U.id) AS [Toplam �r�n Say�s�],
    SUM(SD.adet) AS [Toplam Sat�lan Adet],
    SUM(SD.satis_fiyati) AS [Toplam Ciro],
    SUM( (SD.satis_fiyati - SD.alis_fiyati) * SD.adet) AS [Toplam Kar]
FROM Satici ST
INNER JOIN Urun U ON ST.id = U.satici_id
INNER JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY ST.id, ST.ad, ST.telefon, ST.email
ORDER BY [Toplam Ciro] DESC;
GO


-- 2. AGGREGATE & GROUP BY

--Sehirlere gore musteri sayisi
--KONTROL:
SELECT * FROM Musteri;

SELECT 
    sehir AS �ehir,
    COUNT(*) AS MusteriSayisi
FROM Musteri
GROUP BY sehir
ORDER BY MusteriSayisi DESC;
GO

--Kategori bazli toplam satislar
SELECT 
    K.ad AS Kategori,
    COUNT(DISTINCT U.id) AS [�r�n Say�s�],
    SUM(SD.adet) AS [Toplam Sat�lan Adet],
    SUM(SD.satis_fiyati) AS [Toplam Sat�� Tutar�],
    AVG(SD.satis_fiyati) AS [Ortalama Sat�� Fiyat�],
    SUM( (SD.satis_fiyati - SD.alis_fiyati) * SD.adet) AS ToplamKar
FROM Kategori K
INNER JOIN Urun U ON K.id = U.kategori_id
INNER JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY K.id, K.ad
ORDER BY [Toplam Sat�� Tutar�] DESC;
GO

--Aylara gore siparis sayisi

SELECT 
    YEAR(tarih) AS Yil,
    MONTH(tarih) AS Ay,
    COUNT(*) AS [Sipari� Sayisi],
    SUM(toplam_tutar) AS [Toplam Ciro],
    AVG(toplam_tutar) AS [Ortalama Sepet Tutar�],
    MAX(toplam_tutar) AS [En Y�ksek Sipari�],
    MIN(toplam_tutar) AS [En D���k Sipari�]
FROM Siparis
GROUP BY YEAR(tarih), MONTH(tarih), DATENAME(MONTH, tarih)
ORDER BY Yil DESC, Ay DESC;
GO

-- 3. JOINLER

--Siparislerde musteri bilgisi + urun bilgisi + satici bilgisi
SELECT 
    S.id AS [Sipari� ID],
    S.tarih AS [Sipari� Tarihi],
    M.ad + N' ' + M.soyad AS [M��teri Ad�],
    M.sehir AS [M��teri �ehri],
    M.telefon AS [M��teri Telefon],
    U.ad AS [�r�n Ad�],
    MR.ad AS Marka,
    SD.adet,
    SD.satis_fiyati,
    ST.ad AS [Sat�c� Ad�],
    S.siparis_durumu,
    S.odeme_turu
FROM Siparis S
INNER JOIN Musteri M ON S.musteri_id = M.id
INNER JOIN Siparis_Detay SD ON S.id = SD.siparis_id
INNER JOIN Urun U ON SD.urun_id = U.id
INNER JOIN Satici ST ON U.satici_id = ST.id
INNER JOIN Marka MR ON U.marka_id = MR.id
ORDER BY S.id ASC;
GO

--Hic satilmamis urunler
SELECT 
    U.id,
    U.ad AS [�r�n Ad�],
    M.ad AS Marka,
    K.ad AS Kategori,
    U.satis_fiyati,
    U.stok,
    SD.adet,
    U.eklenme_tarihi
FROM Urun U
INNER JOIN Marka M ON U.marka_id = M.id
INNER JOIN Kategori K ON U.kategori_id = K.id
LEFT JOIN Siparis_Detay SD ON U.id = SD.urun_id
WHERE SD.id IS NULL AND U.aktif_durum = 1
ORDER BY U.id;
GO
--Hic siparis vermemis musteriler
SELECT 
    M.id,
    M.ad + N' ' + M.soyad AS [M��teri Ad�],
    M.email,
    M.telefon,
    M.sehir,
    M.kayit_tarihi,
    DATEDIFF(DAY, M.kayit_tarihi, GETDATE()) AS [Kay�t S�resi G�n]
FROM Musteri M
LEFT JOIN Siparis S ON M.id = S.musteri_id
WHERE S.id IS NULL AND M.aktif_durum = 1
ORDER BY M.kayit_tarihi;
GO

/*
   D. ILERI SEVIYE GOREVLER (OPSIYONEL)
*/

--En cok kazanc saglayan ilk 3 kategori
SELECT  TOP 3
    K.id,
    K.ad AS Kategori,
    SUM(SD.satis_fiyati) AS [Toplam Sat��],
    SUM(SD.alis_fiyati * SD.adet) AS [Toplam Maliyet],
    SUM( (SD.satis_fiyati - SD.alis_fiyati) * SD.adet ) AS [Net K�r]
FROM Kategori K
LEFT JOIN Urun U ON K.id = U.kategori_id
LEFT JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY K.id, K.ad
ORDER BY [Net K�r] DESC;
GO

--Ortalama siparis tutarini gecen siparisleri bul
SELECT 
    S.id AS [Sipari� No],
    S.tarih AS [Sipari� Tarihi],
    M.ad + N' ' + M.soyad AS [M��teri Ad�],
    M.email,
    S.toplam_tutar,
    (SELECT AVG(toplam_tutar) FROM Siparis) AS [Ortalama Sipari� Tutar�],
    S.toplam_tutar - (SELECT AVG(toplam_tutar) FROM Siparis) AS [Ortalaman�n �st�nde],
    (SELECT COUNT(*) FROM Siparis WHERE musteri_id = M.id) AS [Toplam Sat�� Say�s�]
FROM Siparis S
INNER JOIN Musteri M ON S.musteri_id = M.id
WHERE S.toplam_tutar > (SELECT AVG(toplam_tutar) FROM Siparis)
ORDER BY S.toplam_tutar DESC;
GO

--En az bir kez elektronik urun alan musteriler
SELECT DISTINCT
    M.id,
    M.ad + N' ' + M.soyad AS [M��teri Ad�],
    M.email,
    M.telefon,
    M.sehir,
    M.loyalite_puani,
    M.kayit_tarihi
FROM Musteri M
INNER JOIN Siparis S ON M.id = S.musteri_id
INNER JOIN Siparis_Detay SD ON S.id = SD.siparis_id
INNER JOIN Urun U ON SD.urun_id = U.id
INNER JOIN Kategori K ON U.kategori_id = K.id
WHERE K.id IN (1, 2, 3, 6) -- Elektronik kategorileri
    OR K.ust_kategori_id IN (1, 2, 3, 6) -- Alt kategoriler
ORDER BY M.kayit_tarihi DESC;
GO
