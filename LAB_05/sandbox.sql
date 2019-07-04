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
SELECT DATEADD(WEEK, -1,EOMONTH(GETDATE(), -1)) AS da
UNION ALL
SELECT DATEADD(DAY, 1, da) AS da 
FROM C_CTE AS s
WHERE da < DATEADD(WEEK, 1, EOMONTH(GETDATE()))
)
SELECT * FROM C_CTE
GO

SET DATEFIRST 1
SELECT 29%7


SELECT DATEPART(dw,DATEADD(DAY,1,EOMONTH(GETDATE(),0))) -- CHANGE 0 TO -1 THEN
GO
DECLARE @@minus INT
SET @@minus = -3
SELECT IIF(@@minus > 0, @@minus, NULL)

DECLARE @@firstDay DATE
SET @@firstDay = DATEADD(DAY,1,EOMONTH(GETDATE(),-0))

--SELECT DATEDIFF(DAY, -1*DATEPART(dw, @@firstDay)+1, @@firstDay) AS Monday
--SELECT DATEADD(DAY,  -1*DATEPART(dw, @@firstDay)+1, @@firstDay) AS Monday
;WITH C_CAL (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday)
AS
(
SELECT  DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+1, @@firstDay) AS Monday,
		DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+2, @@firstDay) AS Tuesday,
		DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+3, @@firstDay) AS Wednesday,
		DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+4, @@firstDay) AS Thursday,
		DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+5, @@firstDay) AS Friday,
		DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+6, @@firstDay) AS Saturday,
		DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+7, @@firstDay) AS Sunday
UNION ALL
SELECT DATEADD(WEEK, 1, Monday),
       DATEADD(WEEK, 1, Tuesday),
	   DATEADD(WEEK, 1, Wednesday),
	   DATEADD(WEEK, 1, Thursday),
	   DATEADD(WEEK, 1, Friday),
	   DATEADD(WEEK, 1, Saturday),
	   DATEADD(WEEK, 1, Sunday)
	   FROM C_CAL AS S_CAL
WHERE Sunday < '2019-08-31'
)
SELECT * FROM C_CAL
GO 
-------------------

DECLARE @@firstDay DATE, @@lastDay DATE
DECLARE @@firstMonday INT
SET @@firstDay = DATEADD(DAY,1,EOMONTH(GETDATE(),0))
SET @@lastDay  = EOMONTH(GETDATE(),1)
SET @@firstMonday = DATEDIFF(DAY, @@firstDay, DATEADD(DAY, -1*DATEPART(dw, @@firstDay)+1, @@firstDay))

SELECT @@firstDay, @@lastDay, @@firstMonday

;WITH C_CAL (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday)
AS
(
SELECT  @@firstMonday+1 AS Monday,
		@@firstMonday+2 AS Tuesday,
		@@firstMonday+3  AS Wednesday,
		@@firstMonday+4  AS Thursday,
		@@firstMonday+5  AS Friday,
		@@firstMonday+6  AS Saturday,
		@@firstMonday+7  AS Sunday
UNION ALL
SELECT Monday + 7,
       Tuesday + 7,
	   Wednesday + 7,
	   Thursday + 7,
	   Friday + 7,
	   Saturday + 7,
	   Sunday + 7
	   FROM C_CAL AS S_CAL
WHERE Sunday < 31
)
SELECT  FROM C_CAL
GO 
---------------------------------------

-------------------
DECLARE @@actDate DATE
--SET @@actDate = GETDATE()
SET @@actDate = '2019-08-11'

DECLARE @@firstMonday INT
SET @@firstMonday = 1 - DATEPART(dw, DATEADD(DAY, 1, EOMONTH(@@actDate,-1)))
SELECT DATEADD(DAY, 1, EOMONTH(@@actDate,-1)), DATEPART(dw, DATEADD(DAY, 1, EOMONTH(@@actDate,-1))), @@firstMonday





;WITH C_CAL (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday)
AS
(
SELECT  @@firstMonday+1 AS Monday,
		@@firstMonday+2 AS Tuesday,
		@@firstMonday+3  AS Wednesday,
		@@firstMonday+4  AS Thursday,
		@@firstMonday+5  AS Friday,
		@@firstMonday+6  AS Saturday,
		@@firstMonday+7  AS Sunday
UNION ALL
SELECT Monday + 7,
       Tuesday + 7,
	   Wednesday + 7,
	   Thursday + 7,
	   Friday + 7,
	   Saturday + 7,
	   Sunday + 7
	   FROM C_CAL AS S_CAL
WHERE Sunday < 31
)
SELECT * FROM C_CAL
GO 


