CREATE DATABASE LibraryManagementDb;

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title NVARCHAR(255) NOT NULL, 
    author NVARCHAR(255) NOT NULL, 
    genre NVARCHAR(50), 
    price DECIMAL(10, 2) NOT NULL CHECK(price > 0),
    stock INT CHECK(stock >= 0),
    published_year INT CHECK (published_year BETWEEN 1900 AND 2025)
    added_at DATE
);

INSERT INTO books (book_id, title, author, genre, price, stock, published_year, added_at)
VALUES
(1, N'Kayıp Zamanın İzinde', N'M. Proust', N'Roman', 129.9, 25, 1913, '2025-08-20'),
(2, N'Simyacı', N'P. Coelho', N'Roman', 89.5, 40, 1988, '2025-08-21'),
(3, N'Sapiens', N'Y. N. Harari', N'Tarih', 159, 18, 2011, '2025-08-25'),
(4, N'İnce Memed', N'Y. Kemal', N'Toman', 99.9, 12, 1955, '2025-08-22'),
(5, N'Körlük', N'J. Saramago', N'Roman', 119, 7, 1995, '2025-08-28'),
(6, N'Dune', N'F. Herbert', N'Bilim', 149, 30, 1965, '2025-09-01'),
(7, N'Hayvan Çiftliği', N'G. Orwell', N'Roman', 79.9, 55, 1945, '2025-08-23'),
(8, N'1984', N'G. Orwell', N'Roman', 99, 35, 1949, '2025-08-24'),
(9, N'Nutuk', N'Mustafa Kemal ATATÜRK', N'Tarih', 139, 20, 1927, '2025-08-27'),
(10, N'Küçük Prens', N'A. de Saint-Exupéry', N'Çocuk', 69.9, 80, 1943, '2025-08-26'),
(11, N'Başlangıç', N'D. Brown', N'Roman', 109, 22, 2017, '2025-09-02'),
(12, N'Atomik Alışkanlıklar', N'J. Clear', N'Kişisel Gelişim', 129, 28, 2018, '2025-09-03'),
(13, N'Zamanın Kısa Tarihi', N'S. Hawking', N'Bilim', 119.5, 16, 1988, '2025-08-29'),
(14, N'Şeker Portakalı', N'J. M. de Vasconcelos', N'Roman', 84.9, 45, 1968, '2025-08-30'),
(15, N'Bir İdam Mahkumunun Son Günü', N'V. Hugo', N'Roman', 74.9, 26, 1829, '2025-08-31'); 

--1. Tüm kitapların title, author, price alanlarını fiyatı artan şekilde sıralayarak listeleyin.
SELECT title, author, price
FROM books
ORDER BY price ASC;

--2. Türü 'roman' olan kitapları A→Z title sırasıyla gösterin
SELECT * FROM books
WHERE genre='Roman'
ORDER BY title ASC;

--3. Fiyatı 80 ile 120 (dahil) arasındaki kitapları listeleyin (BETWEEN).
SELECT * FROM books
WHERE price BETWEEN 80 and 120
ORDER BY price ASC;

--4. Stok adedi 20’den az olan kitapları bulun (title, stock_qty).
SELECT title, stock
FROM books
WHERE stock<=20
ORDER BY stock DESC;

--5. title içinde 'zaman' geçen kitapları LIKE ile filtreleyin (büyük/küçük harf durumunu not edin).
SELECT title FROM books
WHERE title LIKE '%zaman%';

--6. genre değeri 'roman' veya 'bilim' olanları IN ile listeleyin.
SELECT title, genre FROM books
WHERE genre IN ('roman', 'bilim');

--7. published_year değeri 2000 ve sonrası olan kitapları, en yeni yıldan eskiye doğru sıralayın.
SELECT title, published_year
FROM books
WHERE published_year>=2000
ORDER BY published_year DESC

--8. Son 10 gün içinde eklenen kitapları bulun (added_at tarihine göre).
SELECT * FROM books
WHERE added_at >= DATEADD(day, -10, GETDATE());

--9. En pahalı 5 kitabı price azalan sırada listeleyin (LIMIT 5).
SELECT TOP 5 title, price
FROM books
ORDER BY price DESC;

/* LIMIT HATA VERİYOR
SELECT title, price
FROM books
--ORDER BY price DESC
LIMIT 5;
*/

--10. Stok adedi 30 ile 60 arasında olan kitapları price artan şekilde sıralayın.
SELECT title, price, stock
FROM books
WHERE stock BETWEEN 30 AND 60
ORDER BY price DESC;



