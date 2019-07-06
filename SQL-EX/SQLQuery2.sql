/*Для каждого корабля из таблицы Ships указать название первого по времени сражения из таблицы Battles,
в котором корабль мог бы участвовать после спуска на воду. Если год спуска на воду неизвестен, взять последнее по времени сражение.
Если нет сражения, произошедшего после спуска на воду корабля, вывести NULL вместо названия сражения.
Считать, что корабль может участвовать во всех сражениях, которые произошли в год спуска на воду корабля.
Вывод: имя корабля, год спуска на воду, название сражения

Замечание: считать, что не существует двух битв, произошедших в один и тот же день.*/
USE [sql-ex]
GO
SELECT ZZ.name, ZZ.launched, BB.name FROM
(
SELECT S.[name]
      ,S.[launched]
	  ,NULL AS Date
  FROM [Ships] AS S, [Battles] AS B
  WHERE S.launched > ALL(SELECT DATEPART(YEAR, [date]) FROM [Battles])
UNION
SELECT * FROM
(
SELECT S.[name], S.launched, MIN(B.date) AS Date
  FROM [Ships] AS S, [Battles] AS B
  WHERE S.launched <= DATEPART(YEAR,B.[date])
  GROUP BY S.name, S.launched
  HAVING S.launched IS NOT NULL
) AS Z
UNION
SELECT * FROM
(
SELECT TOP 1 WITH TIES S1.[name], S1.launched, B1.date
  FROM [Ships] AS S1, [Battles] AS B1
  WHERE S1.launched IS NULL
  ORDER BY date DESC) AS X
) AS ZZ
JOIN [Battles] AS BB
ON BB.date = ZZ.Date
