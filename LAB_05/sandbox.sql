USE [O_SYDOR_MODULE_5]
GO
/*
SELECT D.[detailid]
      ,D.[name]
      ,D.[color]
      ,D.[weight]
      ,D.[city]
  FROM [details] AS D
GO

SELECT P.[productid]
      ,P.[name]
      ,P.[city]
  FROM [products] AS P
GO

SELECT S.[supplierid]
      ,S.[name]
      ,S.[rating]
      ,S.[city]
  FROM [suppliers] AS S
GO

SELECT A.[supplierid]
      ,A.[detailid]
      ,A.[productid]
      ,A.[quantity]
  FROM [supplies] AS A
GO
*/
-------------------------------------------

SELECT A.*, S.*, P.*, D.*
FROM [supplies] AS A
JOIN [suppliers] AS S
ON S.supplierid = A.supplierid
JOIN [products] AS P
ON P.productid = A.productid
JOIN [details] AS D
ON D.detailid = A.detailid


---
/* 1b.	Отримати номера і прізвища постачальників, які постачають деталі для якого-небудь виробу з деталлю 1 
в кількості більшій, ніж середній об’єм поставок деталі 1 для цього виробу */

SELECT S.supplierid, S.name, S1.* 
FROM suppliers AS S
JOIN supplies AS S1
ON S1.supplierid = S.supplierid
AND S1.detailid = 1
--ORDER BY S1.productid
AND S1.quantity =
(
SELECT AVG(S2.quantity) FROM supplies AS S2 
GROUP BY S2.productid, S2.detailid 
HAVING S2.detailid = S1.detailid
AND S2.productid = S1.productid)

SELECT S2.productid, AVG(S2.quantity) FROM supplies AS S2
GROUP BY S2.productid, S2.detailid
HAVING S2.detailid = 1


SELECT DISTINCT SID, SNANE FROM
(
--SELECT S.supplierid AS SID, S.name AS N, S1.detailid AS D, S1.productid AS P, S1.quantity AS Q 
SELECT S.supplierid AS SID, S.name AS SNANE, S1.productid AS P, S1.quantity AS Q 
FROM suppliers AS S
JOIN supplies AS S1
ON S1.supplierid = S.supplierid
AND S1.detailid = 1
) AS X
WHERE X.Q > (
SELECT AVG(X1.quantity) FROM supplies AS X1 
WHERE X1.detailid = 1 AND X1.productid = X.P)
