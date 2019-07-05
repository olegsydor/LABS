 
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

 