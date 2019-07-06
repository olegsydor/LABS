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



/* Найти тех производителей ПК, все модели ПК которых имеются в таблице PC. */
USE [labor_sql]
GO

SELECT [maker]
      ,[model]
      ,[type]
  FROM [product] ORDER BY type, maker
GO

SELECT [code]
      ,[model]
      ,[speed]
      ,[ram]
      ,[hd]
      ,[cd]
      ,[price]
  FROM [pc]
GO
DECLARE @@mak nvarchar
SET @@mak = 'A'

SELECT DISTINCT P.maker FROM Product AS P
WHERE P.model = ALL
(
SELECT PC.model FROM pc AS PC
JOIN product AS P1
ON P1.model = PC.model
AND P1.maker = P.maker
INTERSECT 
SELECT model FROM Product AS P1 
WHERE P1.maker = P.maker
AND P1.type = 'PC'
EXCEPT
SELECT model FROM Product AS P1 
WHERE P1.maker = P.maker
AND P1.type = 'PC'
)
AND P.type = 'PC'
-------
SELECT DISTINCT P.maker FROM Product AS P
GROUP BY P.maker


SELECT P1.maker, P1.model FROM Product AS P1 
WHERE P1.maker = @@mak
AND P1.type = 'PC'
INTERSECT
SELECT P1.maker, PC.model FROM pc AS PC
JOIN product AS P1
ON P1.model = PC.model
AND P1.maker = @@mak


-------


DECLARE @@mak nvarchar
SET @@mak = 'A'

SELECT P1.maker, P1.model FROM Product AS P1 
WHERE P1.maker = @@mak
AND P1.type = 'PC'

SELECT P1.maker, PC.model FROM pc AS PC
JOIN product AS P1
ON P1.model = PC.model
AND P1.maker = @@mak


SELECT P1.maker, P1.model FROM Product AS P1 
WHERE P1.maker = @@mak
AND P1.type = 'PC'
EXCEPT
SELECT P1.maker, PC.model FROM pc AS PC
JOIN product AS P1
ON P1.model = PC.model
AND P1.maker = @@mak

SELECT P1.maker, PC.model FROM pc AS PC
JOIN product AS P1
ON P1.model = PC.model
AND P1.maker = @@mak
EXCEPT
SELECT P1.maker, P1.model FROM Product AS P1 
WHERE P1.maker = @@mak
AND P1.type = 'PC'

SELECT P1.maker, P1.model FROM Product AS P1 
WHERE P1.maker = @@mak
AND P1.type = 'PC'
INTERSECT
SELECT P1.maker, PC.model FROM pc AS PC
JOIN product AS P1
ON P1.model = PC.model
AND P1.maker = @@mak

---

SELECT DISTINCT P.maker FROM Product AS P
WHERE P.type = 'PC'
AND
P.model = ALL
(
SELECT PC.model FROM pc AS PC
JOIN product AS P1
ON P1.model = PC.model
AND P1.maker = P.maker
INTERSECT 
SELECT model FROM Product AS P1 
WHERE P1.maker = P.maker
AND P1.type = 'PC'
EXCEPT
SELECT model FROM Product AS P1 
WHERE P1.maker = P.maker
AND P1.type = 'PC'

)

---



SELECT [maker]
      ,[model]
      ,[type]
  FROM [product] ORDER BY type, maker
GO

SELECT [code]
      ,[model]
      ,[speed]
      ,[ram]
      ,[hd]
      ,[cd]
      ,[price]
  FROM [pc]
GO