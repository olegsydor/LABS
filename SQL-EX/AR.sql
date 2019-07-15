/* 47 */

;WITH A_CTE AS
(
SELECT C.[class] AS NA
      ,C.[class] AS CL
      ,C.[country]
  FROM [Classes] AS C
UNION ALL
SELECT S.[name]
      ,S.[class]
	  ,C.[country]
  FROM [Ships] AS S
JOIN [Classes] AS C
ON C.class = S.class
)
SELECT country FROM A_CTE
EXCEPT
SELECT X.country FROM
(
SELECT country, NA FROM A_CTE
--SELECT [country] FROM A_CTE
EXCEPT
SELECT A.country, A.NA FROM A_CTE AS A
JOIN Outcomes AS O
ON A.NA = O.ship
AND O.result = 'sunk'
) AS X


/*Задание: 82 */
/* В наборе записей из таблиці PC, отсортированном по столбцу code по возрастанию найти среднее значение цені для каждой шестерки подряд ижущих пк
вівод: код, первій в наборе, среднее значение в наборе */

SELECT [code]
      ,[price]
      ,AVG([price]) OVER (ORDER BY [code] ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING) AS S
  FROM [dbo].[pc]
GO
