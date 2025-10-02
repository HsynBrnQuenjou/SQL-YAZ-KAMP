/*
CREATE TABLE books (
  id INT PRIMARY KEY IDENTITY,
  title VARCHAR(100) NOT NULL,
  author VARCHAR(100) NOT NULL,
  published_year INT,
  genre VARCHAR(100),
  price DECIMAL(10.2),  => Float()
);


INSERT INTO books (title, author, published_year, genre, price) 
VALUES('Kumarbaz', 'Fyodor Dostoyevski', 1975, 'Roman', 85.50);

INSERT INTO books (title, author, published_year, genre, price) 
VALUES('Abasýyanki', 'Sait Faik', 2012, 'Roman', 85.75);

INSERT INTO books(title, author, published_year, genre, price) 
Values('Suç ve Ceza', 'Fyodor Dostoyevsk', 1875, 'Roman', 125.85), 
('Sefiller', 'Viktor Hugo', 1860, 'Sosyoloji', 49.50), 
('Karamazov Kardeþler', 'Fyodor Dostoyevski', null, null, 85.47);

INSERT INTO books(title, author, price) VALUES('Cin Ali 1', 'Cin Ali Yazarý', 7);

INSERT INTO books(title, author, published_year, genre, price) 
Values('Suç ve Ceza', 'Fyodor Dostoyevsk', 1875, 'Roman', 125.85), 
('Sefiller', 'Viktor Hugo', 1860, 'Sosyoloji', 49.50), 
('Karamazov Kardeþler', 'Fyodor Dostoyevski', null, null, 85.47);
('Cin Ali 2', 'Cin Ali Yazarý', null, 'Hikaye', 250);
*/





('Masal 1', 'Masal Yazarý', 'Masal', 250);

select * from books;

-- Filtreleme iþlemleri
-- select kolonlar from tablo_adi where kolon_adi filtre
-- Karþýlaþtýrma operatörleri.
-- <, >, <=, >=, = !=, <>

-- Yazarý Fyodor Dostoyevski olan kitaplarý listeleyiniz.
select * from books where author = 'Fyodor Dostoyevski'


-- Kitabýn fiyat aralýðý 65 tl den büyük olan kitaplarý listeleyiniz.
select title, author, price from books where price > 65;

-- türü roman olmayan kitaplar
select * from books where genre != 'Roman';

select * from books where genre <> 'Roman';

-- Mantýksal operatörler
-- And, Or, NOT

-- Fiyat aralýðý 55 ile 150 arasýndaki kitaplarý listeleyiniz.

select * from books where price>55 and price<150;

-- kitap türü Roman olan ve yazarý Dostoyevski olan kitaplarý listeleyiniz.
select * from books where genre = 'Roman' AND author = 'Dostoyevski';

-- yayýn yýlý 1972 den büyük olan veya Türü Sosyoloji olan kitaplarý listeleyiniz.
select * from books where published_year > 1972 or genre = 'Sosyoloji';

--Diðer Operatörler
-- BETWEEN, LIKE, IN

-- Fiyat aralýðý 55 ile 150 arasýndaki kitaplarý listeleyiniz.

select * from books where price BETWEEN 55 AND 150;

-- IN Komutu
select * from books where genre IN ('Sosyoloji', 'Hikaye', 'Masal');

-- Yazarý Dos ile baþlayan bütün kitaplarý listeleyiniz.
select * from books where author LIKE 'Dos%';


-- Yazar alaný arý ile biten bütün kitaplarý listeleyiniz.
select * from books where author LIKE '%arý';

-- Yazarlarý içerisinde Dostoyevski Geçen bütün kitaplarý listeleyiniz.
select * from books where author LIKE '%Dostoyevski%';


-- DELETE FROM TABLO_ADI where kolon þart
DELETE FROM books where id = 1006;

-- Update tablo_adi set kolon1 = deger2, kolon2 = deger2
UPDATE books SET price = 350 where id =1006;

-- ANNA Karenina ile baþlayan kitaplarýn yazarýný Tolstoy yapýnýz.
UPDATE books set author = 'Tolstoy' where title LIKE 'Anna Karenina';
select * from books; 


-- Price kolonunda %20 lik kdv oraný uygulayýnýz.
UPDATE books set price = price * 1.20;


-- Books tablosunda kitaplarýn fiyatlarýnýn ortalamasýný gösteriniz.
-- AVG, SUM, MIN, MAX, COUNT

-- AVG Ortalama alýr.


select AVG(price) AS Ortalama,
SUM(price) AS Toplam,
MIN(price) AS [Minimum Fiyat],
MAX(price) AS [Maksimum Fiyat],
COUNT(*) AS [Eleman Sayýsý]
FROM books;

-- GENRE,  COUNT()
-- SELECT KOLON, AGGREGATE_FONSÝYON FROM Tablo_adý GROUP BY kolon;

-- Türe göre kitap sayýsý, çoktan aza doðru
Select genre, COUNT(*) as [Kitap Sayýsý]

from books  GROUP BY genre ORDER BY [Kitap Sayýsý] DESC;

-- Türe göre ORT / MÝN/MAX fiyatlar

select genre,
AVG(price) as Ortalama,
MAX(price) as En_buyuk,
MIN(price) as En_kucuk,
COUNT(*) as Eleman
FROM books GROUP BY genre;

-- Yýl ve Tür kolonlarýna göre daðýlým.
Select
published_year, genre, COUNT(*)
from books
GROUP BY published_year, genre;


-- türüne göre kitap fiyatlarýnýn ortalamasýný alan ortalamasý 60 dan büyükleri al
--Gruplama iþlemlerinde filtrelenmesi gereken bir yer var ise where keywordu deðil HAVING kullanýlmalý
select 
genre, AVG(price) as Ortalama
from books
GROUP BY genre
HAVING AVG(price) > 60;


-- fiyat aralýðýna göre gruplama.

SELECT
CASE
	WHEN price < 50 THEN '0-49'
	WHEN price < 100 THEN '50-99'
	WHEN price < 200 THEN '100-199'
	ELSE '200+'
END
AS [Fiyat Aralýðý],
COUNT(*) AS Adet
FROM books
GROUP BY
CASE
	WHEN price < 50 THEN '0-49'
	WHEN price < 100 THEN '50-99'
	WHEN price < 200 THEN '100-199'
	ELSE '200+'
END