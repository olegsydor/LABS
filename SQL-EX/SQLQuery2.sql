/*Find out the number of routes with the greatest number of flights (trips).
Notes. 
1) A - B and B - A are to be considered the SAME route.
2) Use the Trip table only.*/

USE [sql-ex]
GO

SELECT COUNT(*)/2 FROM
(
SELECT COUNT(T.[trip_no]) AS T
      ,T.[town_from]+T.[town_to] AS C
  FROM [Trip] AS T
  GROUP BY T.[town_from]+T.[town_to]
  HAVING COUNT(T.[trip_no]) = (
  SELECT TOP 1 COUNT(trip_no) FROM [Trip] AS T1 GROUP BY T1.town_from+T1.town_to ORDER BY COUNT(trip_no) DESC
  ) 
) AS X