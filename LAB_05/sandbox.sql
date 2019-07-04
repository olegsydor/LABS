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
  where a.productid in (5,7,8,9)
GO
*/
-------------------------------------------
/* 2e. Розрахувати календар поточного місяця за допомогою рекурсивної CTE та вивести дні місяця у форматі таблиці з колонками */
;WITH C_CTE (da)
AS
(
SELECT EOMONTH(GETDATE(), -1) AS da
UNION ALL
SELECT DATEADD(DAY, 1, da) AS da 
FROM C_CTE AS s
WHERE da < EOMONTH(GETDATE())
)
SELECT * FROM C_CTE
GO