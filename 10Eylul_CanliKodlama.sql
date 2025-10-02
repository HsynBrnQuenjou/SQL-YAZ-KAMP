CREATE DATABASE Odev_db;
USE Odev_db

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title NVARCHAR(255) NOT NULL, /* VARCHAR T�RK�E KARAKTER DESTEKLEMEZ */
    author NVARCHAR(255) NOT NULL, /* NVARCHAR VER� T�P� KULLANILIR */
    genre NVARCHAR(50), /* SADECE NVARCHAR YETMEZ STR�NG TIRNA�INDAN �NCE N KONUR */
    price DECIMAL(10, 2) NOT NULL CHECK(price >= 0),
    stock INT CHECK(stock >= 0), --UNSIGNED MANTIKLI AMA GENELDE ESKI CIHAZLARDA
    published_year INT CHECK(published_year BETWEEN 1900 AND 2025), --INT CHECK (published_year BETWEEN 1900 AND 2025)
    added_at DATE
);
--drop table books; --!!!Tablo d�zenleme i�in

INSERT INTO books (book_id, title, author, genre, price, stock, published_year, added_at)
VALUES
(1, 'Kay�p Zaman�n �zinde', 'M. Proust', 'Roman', 129.9, 25, 1913, GETDATE()),
(2, 'Simyac�', 'P. Coelho', 'Roman', 89.5, 40, 1988, '2025-08-21'),
(3, 'Sapiens', 'Y. N. Harari', 'Tarih', 159, 18, 2011, '2025-08-25');
/*(4, N'�nce Memed', N'Y. Kemal', N'Toman', 99.9, 12, 1955, '2025-08-22'),
(5, N'K�rl�k', N'J. Saramago', N'Roman', 119, 7, 1995, '2025-08-28'),
(6, N'Dune', N'F. Herbert', N'Bilim', 149, 30, 1965, '2025-09-01'),
(7, N'Hayvan �iftli�i', N'G. Orwell', N'Roman', 79.9, 55, 1945, '2025-08-23'),
(8, N'1984', N'G. Orwell', N'Roman', 99, 35, 1949, '2025-08-24'),
(9, N'Nutuk', N'Mustafa Kemal ATAT�RK', N'Tarih', 139, 20, 1927, '2025-08-27'),
(10, N'K���k Prens', N'A. de Saint-Exup�ry', N'�ocuk', 69.9, 80, 1943, '2025-08-26'),
(11, N'Ba�lang��', N'D. Brown', N'Roman', 109, 22, 2017, '2025-09-02'),
(12, N'Atomik Al��kanl�klar', N'J. Clear', N'Ki�isel Geli�im', 129, 28, 2018, '2025-09-03'),
(13, N'Zaman�n K�sa Tarihi', N'S. Hawking', N'Bilim', 119.5, 16, 1988, '2025-08-29'),
(14, N'�eker Portakal�', N'J. M. de Vasconcelos', N'Roman', 84.9, 45, 1968, '2025-08-30'),
(15, N'Bir �dam Mahkumunun Son G�n�', N'V. Hugo', N'Roman', 74.9, 26, 1829, '2025-08-31'); */

--SORGU1
SELECT title, price, author FROM books ORDER BY price ASC;

--SORGU2
SELECT * FROM books WHERE genre = N'roman' ORDER BY title ASC;

--SORGU8
SELECT * FROM books WHERE added_at >= DATEADD(DAY, -10, '2025-09-10')
--SORGU8 ALTERNAT�VE
SELECT * FROM books WHERE added_at >= DATEADD(DAY, -10, GETDATE())

