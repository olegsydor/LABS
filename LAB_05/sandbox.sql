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
;WITH C_CTE (da, na)
AS
(
SELECT DATEADD(WEEK, -1,EOMONTH(GETDATE(), -1)) AS da,
       DATEPART(dw, DATEADD(WEEK, -1,EOMONTH(GETDATE(), -1))) AS na
UNION ALL
SELECT DATEADD(DAY, 1, da) AS da,
       DATEPART(dw, DATEADD(DAY, 1, da)) AS na
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
SELECT DATEADD(DAY, 1, EOMONTH(@@actDate,-1)) as 'first day of the month', 
       DATEPART(dw, DATEADD(DAY, 1, EOMONTH(@@actDate,-1))) as 'Name of the first day', 
	   @@firstMonday as 'first Monday of the first week'




;WITH C_CAL (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday)
AS
(
SELECT  IIF(@@firstMonday+1>0,@@firstMonday+1, NULL) AS Monday,
		IIF(@@firstMonday+2>0,@@firstMonday+2, NULL) AS Tuesday,
		IIF(@@firstMonday+3>0,@@firstMonday+3, NULL) AS Wednesday,
		IIF(@@firstMonday+4>0,@@firstMonday+4, NULL) AS Thursday,
		IIF(@@firstMonday+5>0,@@firstMonday+5, NULL) AS Friday,
		IIF(@@firstMonday+6>0,@@firstMonday+6, NULL) AS Saturday,
		IIF(@@firstMonday+7>0,@@firstMonday+7, NULL) AS Sunday
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


-----------------------------------

/* 2e. Розрахувати календар поточного місяця за допомогою рекурсивної CTE та вивести дні місяця у форматі таблиці з колонками */


DECLARE @@actDate DATE, @@firstDayOfTheMonth DATE, @@cntDaysBack INT, @@firstMonday DATE
--SET @@actDate = GETDATE()
SET @@actDate = '2019-08-11'
SET @@firstDayOfTheMonth = DATEADD(DAY, 1, EOMONTH(@@actDate,-1)) -- FIRST DAY OF THE MONTH
SET @@cntDaysBack = DATEPART(dw, DATEADD(DAY, 1, EOMONTH(@@actDate,-1))) -- NUMBER OF THE DAY
SET @@firstMonday = DATEADD(DAY, 
               1 - DATEPART(dw, DATEADD(DAY, 1, EOMONTH(@@actDate,-1))), 
			   DATEADD(DAY, 1, EOMONTH(@@actDate,-1))) -- FIRST MONDAY
--SELECT @@firstDayOfTheMonth, @@cntDaysBack, @@firstMonday

;WITH C_CTE (da, na, we)
AS
(
SELECT @@firstMonday AS da,
       DATEPART(dw, @@firstMonday) AS na,
	   0 AS we
UNION ALL
SELECT DATEADD(DAY, 1, da) AS da,
       DATEPART(dw, DATEADD(DAY, 1, da)) AS na,
	   DATEDIFF(WEEK, @@firstMonday, DATEADD(DAY, 0, da)) AS we
FROM C_CTE AS s
WHERE da < '2019-08-31'
)
SELECT da, na, we FROM C_CTE
--GO

SELECT we, 
       [1] AS '1', 
       [2] AS '2', 
	   [3] AS '3', 
	   [4] AS '4', 
	   [5] AS '5', 
	   [6] AS '6', 
	   [7] AS '7'  
FROM 
(SELECT da, na, we FROM TTT) AS p  
PIVOT  
(  
MIN(p.da)
FOR p.na IN ([1], [2], [3], [4], [5], [6], [7] )  
) AS pvt  
GO
----------------------------------------------------------------------



/* 2e. Розрахувати календар поточного місяця за допомогою рекурсивної CTE та вивести дні місяця у форматі таблиці з колонками */

SET DATEFIRST 1
DECLARE @@actDate DATE, @@firstDayOfTheMonth DATE, @@firstMonday DATE
SET @@actDate = GETDATE()
--SET @@actDate = '2019-08-11'
SET @@firstDayOfTheMonth = DATEADD(DAY, 1, EOMONTH(@@actDate,-1)) -- FIRST DAY OF THE MONTH
SET @@firstMonday = DATEADD(DAY, 
               1 - DATEPART(dw, DATEADD(DAY, 1, EOMONTH(@@actDate,-1))), 
			   DATEADD(DAY, 1, EOMONTH(@@actDate,-1))) -- FIRST MONDAY
--SELECT @@firstDayOfTheMonth

;WITH C_CTE (da)
AS
(
SELECT @@firstDayOfTheMonth AS da
UNION ALL
SELECT DATEADD(DAY, 1, da) AS da
FROM C_CTE AS s
WHERE da < EOMONTH(@@actDate)
)
--SELECT da FROM C_CTE
--GO

SELECT --we, 
       [1] AS '1', 
       [2] AS '2', 
	   [3] AS '3', 
	   [4] AS '4', 
	   [5] AS '5', 
	   [6] AS '6', 
	   [7] AS '7'  
FROM 
(
SELECT da,
       DATEPART(dw, da) AS na,
	   DATEDIFF(WEEK, @@firstDayOfTheMonth, DATEADD(DAY, -1, da)) AS we
FROM C_CTE
) AS P
PIVOT  
(  
MIN(p.da)
FOR p.na IN ([1], [2], [3], [4], [5], [6], [7] )  
) AS pvt  

 ------------------------

 
SET DATEFIRST 1
DECLARE @@actDate DATE, @@firstDayOfTheMonth DATE, @@firstMonday DATE
--SET @@actDate = GETDATE()
SET @@actDate = '2019-08-11'
SET @@firstDayOfTheMonth = DATEADD(DAY, 1, EOMONTH(@@actDate,-1)) -- FIRST DAY OF THE MONTH
SET @@firstMonday = DATEADD(DAY, 
               1 - DATEPART(dw, DATEADD(DAY, 1, EOMONTH(@@actDate,-1))), 
			   DATEADD(DAY, 1, EOMONTH(@@actDate,-1))) -- FIRST MONDAY
--SELECT @@firstDayOfTheMonth

;WITH C_CTE (da)
AS
(
SELECT @@firstDayOfTheMonth AS da
UNION ALL
SELECT DATEADD(DAY, 1, da) AS da
FROM C_CTE AS s
WHERE da < EOMONTH(@@actDate)
)
--SELECT da FROM C_CTE
--GO

SELECT --we, 
       [1] AS '1', 
       [2] AS '2', 
	   [3] AS '3', 
	   [4] AS '4', 
	   [5] AS '5', 
	   [6] AS '6', 
	   [7] AS '7'  
FROM 
(
SELECT da,
       DATEPART(dw, da) AS na,
	   DATEDIFF(WEEK, @@firstDayOfTheMonth, DATEADD(DAY, -1, da)) AS we
FROM C_CTE
) AS P
PIVOT  
(  
MIN(p.da)
FOR p.na IN ([1], [2], [3], [4], [5], [6], [7] )  
) AS pvt  

 