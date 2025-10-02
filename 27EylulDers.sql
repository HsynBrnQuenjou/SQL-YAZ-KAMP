-- One to one
-- One to Many
-- Many to many

Select * from Products;

Select * from Categories;


--INNER JOIN

--ProductName, CategoryName, UnitsInStock, UnitPrice

SELECT
Products.ProductID,
Products.ProductName, 
Products.UnitsInStock, 
Products.UnitPrice, 
Categories.CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID;

--Same
SELECT
P.ProductID,
P.ProductName, 
P.UnitsInStock, 
P.UnitPrice, 
C.CategoryName
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID;

SELECT
P.ProductID,
P.ProductName AS Urun_Adi, 
P.UnitsInStock AS Stok_Adedi, 
P.UnitPrice AS Birim_Fiyati, 
C.CategoryName AS Kategori_Adi
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID;

SELECT
P.ProductID,
P.ProductName AS [Ürün Adý], 
P.UnitsInStock AS [Stok Adeti], 
P.UnitPrice AS [Birim Fiyatý], 
C.CategoryName AS [Kategori Adý]
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID;

SELECT * FROM Suppliers;

-- ProductName, UnitPrice, UnitsInStock, CompanyName, ContactName
SELECT
P.ProductName AS [Ürün Adý], 
P.UnitsInStock AS [Stok Adeti], 
P.UnitPrice AS [Birim Fiyatý], 
S.CompanyName AS [Þirket Adý],
S.ContactName AS [Ýletiþim Adý]
FROM Products P
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID;

-- ProductName, UnitPrice, UnitsInStock, CompanyName, ContactName, CategoryName
SELECT
P.ProductID,
P.ProductName,
P.UnitPrice,
P.UnitsInStock,
S.CompanyName,
S.ContactName,
C.CategoryName
FROM Products P
INNER JOIN Categories C On C.CategoryID = P.CategoryID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID

-- ProductName, UnitPrice, UnitsInStock, CompanyName, ContactName, CategoryName
-- UnitInPrice alaný 25 ile 75 arasýnda olan ürünlerin 
--ProductName alanýna göre artan bir þekilde sýralayan sorguyu yazýn
SELECT
P.ProductID,
P.ProductName,
P.UnitPrice,
P.UnitsInStock,
S.CompanyName,
S.ContactName,
C.CategoryName
FROM Products P
INNER JOIN Categories C On C.CategoryID = P.CategoryID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE P.UnitPrice BETWEEN 25 AND 75
ORDER BY P.ProductName ASC


SELECT * FROM Customers;
SELECT * FROM Orders;

-- Müþteri Ülkelerine göre Sipariþ adetleri

SELECT
C.Country,
COUNT(O.OrderID) AS [Müþteri Sayýsý]
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.Country

SELECT * FROM Products;
SELECT * FROM Suppliers;

-- Tedarikçi baþýna ürün sayýsý

SELECT
S.CompanyName,
COUNT(P.ProductID) AS [Ürün Sayýsý]
FROM Suppliers S
INNER JOIN Products P ON S.SupplierID = P.ProductID
GROUP BY S.CompanyName
ORDER BY S.CompanyName ASC

--Ýlgili Kategorilerdeki tüm ürünlerin fiyat toplamý
SELECT * FROM Categories;
SELECT * FROM Products;

SELECT 
Categories.CategoryName, 
SUM(Products.UnitPrice) AS Fiyat
FROM Products

INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
HAVING SUM(Products.UnitPrice) > 200
ORDER BY Fiyat ASC;