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
VALUES('Abas�yanki', 'Sait Faik', 2012, 'Roman', 85.75);

INSERT INTO books(title, author, published_year, genre, price) 
Values('Su� ve Ceza', 'Fyodor Dostoyevsk', 1875, 'Roman', 125.85), 
('Sefiller', 'Viktor Hugo', 1860, 'Sosyoloji', 49.50), 
('Karamazov Karde�ler', 'Fyodor Dostoyevski', null, null, 85.47);

INSERT INTO books(title, author, price) VALUES('Cin Ali 1', 'Cin Ali Yazar�', 7);

INSERT INTO books(title, author, published_year, genre, price) 
Values('Su� ve Ceza', 'Fyodor Dostoyevsk', 1875, 'Roman', 125.85), 
('Sefiller', 'Viktor Hugo', 1860, 'Sosyoloji', 49.50), 
('Karamazov Karde�ler', 'Fyodor Dostoyevski', null, null, 85.47);
('Cin Ali 2', 'Cin Ali Yazar�', null, 'Hikaye', 250);
*/





('Masal 1', 'Masal Yazar�', 'Masal', 250);

select * from books;

-- Filtreleme i�lemleri
-- select kolonlar from tablo_adi where kolon_adi filtre
-- Kar��la�t�rma operat�rleri.
-- <, >, <=, >=, = !=, <>

-- Yazar� Fyodor Dostoyevski olan kitaplar� listeleyiniz.
select * from books where author = 'Fyodor Dostoyevski'


-- Kitab�n fiyat aral��� 65 tl den b�y�k olan kitaplar� listeleyiniz.
select title, author, price from books where price > 65;

-- t�r� roman olmayan kitaplar
select * from books where genre != 'Roman';

select * from books where genre <> 'Roman';

-- Mant�ksal operat�rler
-- And, Or, NOT

-- Fiyat aral��� 55 ile 150 aras�ndaki kitaplar� listeleyiniz.

select * from books where price>55 and price<150;

-- kitap t�r� Roman olan ve yazar� Dostoyevski olan kitaplar� listeleyiniz.
select * from books where genre = 'Roman' AND author = 'Dostoyevski';

-- yay�n y�l� 1972 den b�y�k olan veya T�r� Sosyoloji olan kitaplar� listeleyiniz.
select * from books where published_year > 1972 or genre = 'Sosyoloji';

--Di�er Operat�rler
-- BETWEEN, LIKE, IN

-- Fiyat aral��� 55 ile 150 aras�ndaki kitaplar� listeleyiniz.

select * from books where price BETWEEN 55 AND 150;

-- IN Komutu
select * from books where genre IN ('Sosyoloji', 'Hikaye', 'Masal');

-- Yazar� Dos ile ba�layan b�t�n kitaplar� listeleyiniz.
select * from books where author LIKE 'Dos%';


-- Yazar alan� ar� ile biten b�t�n kitaplar� listeleyiniz.
select * from books where author LIKE '%ar�';

-- Yazarlar� i�erisinde Dostoyevski Ge�en b�t�n kitaplar� listeleyiniz.
select * from books where author LIKE '%Dostoyevski%';


-- DELETE FROM TABLO_ADI where kolon �art
DELETE FROM books where id = 1006;

-- Update tablo_adi set kolon1 = deger2, kolon2 = deger2
UPDATE books SET price = 350 where id =1006;

-- ANNA Karenina ile ba�layan kitaplar�n yazar�n� Tolstoy yap�n�z.
UPDATE books set author = 'Tolstoy' where title LIKE 'Anna Karenina';
select * from books; 


-- Price kolonunda %20 lik kdv oran� uygulay�n�z.
UPDATE books set price = price * 1.20;


-- Books tablosunda kitaplar�n fiyatlar�n�n ortalamas�n� g�steriniz.
-- AVG, SUM, MIN, MAX, COUNT

-- AVG Ortalama al�r.


select AVG(price) AS Ortalama,
SUM(price) AS Toplam,
MIN(price) AS [Minimum Fiyat],
MAX(price) AS [Maksimum Fiyat],
COUNT(*) AS [Eleman Say�s�]
FROM books;

-- GENRE,  COUNT()
-- SELECT KOLON, AGGREGATE_FONS�YON FROM Tablo_ad� GROUP BY kolon;

-- T�re g�re kitap say�s�, �oktan aza do�ru
Select genre, COUNT(*) as [Kitap Say�s�]

from books  GROUP BY genre ORDER BY [Kitap Say�s�] DESC;

-- T�re g�re ORT / M�N/MAX fiyatlar

select genre,
AVG(price) as Ortalama,
MAX(price) as En_buyuk,
MIN(price) as En_kucuk,
COUNT(*) as Eleman
FROM books GROUP BY genre;

-- Y�l ve T�r kolonlar�na g�re da��l�m.
Select
published_year, genre, COUNT(*)
from books
GROUP BY published_year, genre;


-- t�r�ne g�re kitap fiyatlar�n�n ortalamas�n� alan ortalamas� 60 dan b�y�kleri al
--Gruplama i�lemlerinde filtrelenmesi gereken bir yer var ise where keywordu de�il HAVING kullan�lmal�
select 
genre, AVG(price) as Ortalama
from books
GROUP BY genre
HAVING AVG(price) > 60;


-- fiyat aral���na g�re gruplama.

SELECT
CASE
	WHEN price < 50 THEN '0-49'
	WHEN price < 100 THEN '50-99'
	WHEN price < 200 THEN '100-199'
	ELSE '200+'
END
AS [Fiyat Aral���],
COUNT(*) AS Adet
FROM books
GROUP BY
CASE
	WHEN price < 50 THEN '0-49'
	WHEN price < 100 THEN '50-99'
	WHEN price < 200 THEN '100-199'
	ELSE '200+'
END