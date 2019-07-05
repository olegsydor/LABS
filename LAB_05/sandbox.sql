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

SELECT S.[supplierid]
      ,S.[name]
      ,S.[rating]
      ,S.[city]
  FROM [suppliers] AS S
GO

SELECT P.[productid]
      ,P.[name]
      ,P.[city]
  FROM [products] AS P
GO

SELECT A.[supplierid]
      ,A.[detailid]
      ,A.[productid]
      ,A.[quantity]
  FROM [supplies] AS A
GO
*/
-------------------------------------------
/* 4e.	Вибрати поставки, що зробив постачальник з Лондона, 
а також поставки зелених деталей за виключенням поставлених виробів з Парижу (код постачальника, код деталі, код виробу) */

SELECT A.[supplierid]
      ,A.[detailid]
      ,A.[productid]
  FROM [supplies] AS A
  JOIN [suppliers] AS S
  ON S.supplierid = A.supplierid
  AND S.city = 'London'
  UNION ALL
 SELECT A.[supplierid]
      ,A.[detailid]
      ,A.[productid]
  FROM [supplies] AS A
  JOIN [details] AS D
  ON D.detailid = A.detailid
  AND D.color = 'Green'