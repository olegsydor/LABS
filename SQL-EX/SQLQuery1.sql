USE [sql-ex]
GO

SELECT T.[trip_no]
      ,T.[ID_comp]
      ,T.[plane]
      ,T.[town_from]
      ,T.[town_to]
      ,T.[time_out]
      ,T.[time_in]
  FROM [Trip] AS T
GO

USE [sql-ex]

SELECT P.[trip_no]
      ,P.[date]
      ,P.[ID_psg]
      ,P.[place]
  FROM [Pass_in_trip] AS P

/*For all days between 2003-04-01 and 2003-04-07 find the number of trips from Rostov. 
Result set: date, number of trips.*/
;WITH D_CTE (dt)
AS
(
SELECT CAST('2003-04-01' AS datetime) dt
UNION ALL
SELECT DATEADD(DAY, 1, dt) AS dt
FROM D_CTE
WHERE dt < '2003-04-07'
)
SELECT D_CTE.dt, IIF(Y.CNT IS NULL, 0, Y.CNT) 
FROM D_CTE

LEFT JOIN
(
SELECT X.date, COUNT(X.trip_no) AS CNT
FROM
(
SELECT DISTINCT P.[trip_no]
      ,P.[date]
  FROM [Pass_in_trip] AS P, [Trip] AS T
  WHERE T.trip_no = P.trip_no
  AND T.town_from = 'Rostov'
) AS X
GROUP BY X.date) AS Y
ON Y.date = D_CTE.dt
/* 5021 */