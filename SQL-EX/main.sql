;WITH ships_CTE (ship, class, country, battle)
AS
(
SELECT X.ship
      ,X.class
	  ,C.country
	  ,O.battle
FROM
(
SELECT [class] AS 'ship'
      ,[class] AS 'class'
  FROM [dbo].[classes]
UNION
SELECT [name] AS 'ship'
      ,[class] AS 'class'
  FROM [dbo].[ships]
) AS X
LEFT JOIN
[dbo].[classes] AS C
ON C.class = X.class
JOIN
[dbo].[outcomes] AS O
ON O.ship = X.ship
)

SELECT DISTINCT S.battle
      --,S.country
	  --,COUNT(S.ship)
FROM ships_CTE AS S
GROUP BY S.country, S.battle
HAVING COUNT(S.ship) > 2
/* 48419 */


/* Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).*/
SELECT C.[class]
    FROM [dbo].[classes] AS C
  LEFT JOIN [dbo].[ships] AS S
  ON S.class = C.class
  LEFT JOIN [dbo].[outcomes] AS O
  ON O.ship = S.name
  GROUP BY C.class
  HAVING COUNT(O.ship)+COUNT(S.name)+1 =1

  /*Для каждой страны определить год, когда на воду было спущено максимальное количество ее кораблей. 
  В случае, если окажется несколько таких лет, взять минимальный из них. 
  Вывод: страна, количество кораблей, год*/


/* Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий. */

  ;WITH s_CTE (ship)
AS 
(
SELECT [name]
FROM [dbo].[ships]
UNION
SELECT [class]
  FROM [dbo].[classes]
UNION
SELECT [ship]
  FROM [dbo].[outcomes]
)
,
sc_CTE (ship, class)
AS
(
SELECT ship,
      COALESCE(CIN.class, CL.[class])
FROM s_CTE
LEFT JOIN [ships] AS CIN
ON CIN.name = s_CTE.ship
LEFT JOIN [classes] AS CL
ON CL.class = s_CTE.ship
)

SELECT sc_CTE.ship
	  ,C.displacement
	  ,C.numGuns
FROM sc_CTE
LEFT JOIN [classes] AS C
ON C.class = sc_CTE.class
JOIN [outcomes] AS O
ON O.ship = sc_CTE.ship
WHERE O.battle = 'Guadalcanal'

/*Определите среднее число орудий для классов линейных кораблей.
Получить результат с точностью до 2-х десятичных знаков.*/
SELECT round(cast(sum([numGuns])*1.0/count(numGuns) as decimal (4,2)),2)
  FROM [dbo].[classes]
  where [type] ='bb'


  /*Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. 
Вывести: класс, год. */

SELECT C.class, MIN(S.launched)
FROM classes AS C
LEFT JOIN ships AS S
ON S.class = C.class
GROUP BY C.class
/*32864 */




SELECT TOP 1 WITH TIES COUNT(X.TN), X.DT
FROM
(
SELECT DISTINCT P.[trip_no] AS TN
      ,P.[date] AS DT
	  ,T.town_from AS TW
  FROM [pass_in_trip] AS P
  JOIN [trip] AS T
  ON T.trip_no = P.trip_no
  AND T.town_from = 'Rostov'
) AS X
GROUP BY X.DT
ORDER BY COUNT(X.TN) DESC

/* 29024	*/

/* Для каждого сражения определить первый и последний день месяца, в котором оно состоялось. 
Вывод: сражение, первый день месяца, последний день месяца.

Замечание: даты представить без времени в формате "yyyy-mm-dd". */
SELECT [name]
      ,dateadd(day, 1, eomonth([date], -1))
	  ,eomonth([date])
  FROM [dbo].[battles]
/* 30884 */


SELECT X.Name, SUM(X.DIF) FROM
(
SELECT DISTINCT C.name AS 'Name'
      ,P.[trip_no]
	  ,P.[date]
      ,T.[time_out]
      ,T.[time_in]
	  ,CASE WHEN DATEDIFF(MINUTE, T.time_out, T.time_in) > 0 THEN DATEDIFF(MINUTE, T.time_out, T.[time_in]) ELSE DATEDIFF(MINUTE, T.time_out, T.[time_in])+1440 END AS 'DIF'
  FROM [pass_in_trip] AS P
  JOIN [trip] AS T
  ON T.trip_no = P.trip_no
  JOIN [company] AS C
  ON C.id_comp = T.id_comp
) AS X
GROUP BY X.Name
/* 27210 */

/* Среди пассажиров, которые пользовались услугами не менее двух авиакомпаний, 
найти тех, кто совершил одинаковое количество полётов самолетами каждой из этих авиакомпаний. 
Вывести имена таких пассажиров. */
;WITH G_CTE (psg, cmp, cnt)
AS
(
SELECT P.[id_psg] AS 'PSG'
      ,T.id_comp AS 'CMP'
      ,COUNT(T.id_comp) AS 'CNT_CMP'
  FROM [pass_in_trip] AS P
  JOIN [trip] AS T
  ON T.trip_no = P.trip_no
  GROUP BY P.id_psg, T.id_comp
  --ORDER BY PSG
)
,
PSG_CTE (id)
AS
(
SELECT A1.psg FROM G_CTE AS A1
CROSS APPLY G_CTE AS A2
WHERE A1.psg=A2.psg
AND A1.cnt = A2.cnt
AND A1.cmp<A2.cmp
AND A1.psg NOT IN (SELECT psg FROM G_CTE AS G WHERE G.cnt <> A1.cnt)
)
SELECT F.name FROM 
(
SELECT DISTINCT PSG_CTE.id, P.name
FROM PSG_CTE
LEFT JOIN [passenger] AS P
ON P.id_psg = PSG_CTE.id
) AS F
/* 25483 */


/* Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC. 
Вывести: maker, максимальная цена. */


SELECT PR.[maker]
	  ,MAX(PC.price)
  FROM [product] AS PR
  JOIN [pc] AS PC
  ON PC.model = PR.model
  GROUP BY PR.maker
 /* 21460 */


/* Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов. 
Вывести: maker, средний размер экрана. */
SELECT P.maker
      ,AVG(L.[screen])
  FROM [laptop] AS L
  JOIN [product] AS P
  ON P.model = L.model
  GROUP BY P.maker

  /* 22902 */

/* Используя таблицу Product, определить количество производителей, выпускающих по одной модели. */

SELECT COUNT(X.CC)
FROM (
SELECT COUNT([maker]) AS CC
  FROM [dbo].[product]
  GROUP BY maker
  HAVING COUNT([model]) = 1
  ) AS X
  /* 22194 */


  /* Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий. */

SELECT DISTINCT S.[class]
      ,S.[name]
	  ,C.country
  FROM [ships] AS S
  JOIN [classes] AS C
  ON C.class = S.class
  WHERE C.numGuns > 9
/* 20834 */

/* Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена. */

SELECT [speed]
      ,AVG([price])
  FROM [dbo].[pc]
  GROUP BY [speed]
  HAVING [speed] > 600
/* 20192 */

/* Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну. */

SELECT [class]
      ,[country]
  FROM [classes]
  WHERE [bore] >= 16
/* 19403 */


/* Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены. */

SELECT [ship]
      ,[battle]
  FROM [outcomes]
  WHERE [result] = 'sunk'
/* 18887 */

/* Найдите названия всех кораблей в базе данных, начинающихся с буквы R. */

SELECT X.ship FROM (
SELECT [ship]
  FROM [outcomes]
UNION
SELECT [name]
FROM [ships]
)
AS X
WHERE X.ship LIKE 'R%'
/* 18336 */

/* Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов. */

SELECT X.ship FROM (
SELECT [ship]
  FROM [outcomes]
UNION
SELECT [name]
FROM [ships]
)
AS X
WHERE X.ship LIKE '% % %'
/* 17811 */

/* Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes). */
SELECT O.ship
  FROM [outcomes] AS O
JOIN [classes] AS C
ON C.class = O.ship
WHERE C.bore = 16
UNION
SELECT S.[name]
FROM [ships] AS S
JOIN [classes] AS C
ON C.class = S.class
WHERE C.bore = 16
/* 17325 */

/* Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships. */
SELECT DISTINCT O.battle
FROM [ships] AS S
JOIN outcomes AS O
ON O.ship = S.name
WHERE S.class = 'Kongo'

/* 16886 */

/* В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день 
[т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). 
Использовать таблицы Income_o и Outcome_o. */

SELECT X.[P]
      ,X.[D]
	  ,SUM(X.[IN])
	  ,SUM(X.[OUT]) 
FROM
(
SELECT [point] AS 'P'
      ,[date] AS 'D'
      ,[inc] AS 'IN'
	  ,NULL AS 'OUT'
  FROM [dbo].[income_o]
UNION ALL
SELECT [point] AS 'P'
      ,[date] AS 'D'
	  ,NULL AS 'IN'
      ,[out] AS 'OUT'
  FROM [dbo].[outcome_o]) AS X
  GROUP BY X.[D], X.[P]

  /* 16401 */

/* Посчитать остаток денежных средств на всех пунктах приема на начало дня 15/04/01 для базы данных с отчетностью не чаще одного раза в день. */

SELECT SUM(X.[inc]) - SUM(X.[out])
FROM
(
SELECT [point]
      ,[date]
      ,[inc]
	  ,0 AS 'out'
  FROM [dbo].[Income_o]
  WHERE [date] < '2001-04-15'
UNION ALL
SELECT [point]
      ,[date]
      ,0
	  ,[out] AS 'out'
  FROM [dbo].[Outcome_o]
  WHERE [date] < '2001-04-15'
) AS X
/* 7903 */

/* Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза. */

SELECT P.name FROM 
(
SELECT DISTINCT X.pas
FROM
(
SELECT [id_psg] AS 'pas'
      ,[place]
      ,COUNT([place]) AS 'C'
  FROM [pass_in_trip]
  GROUP BY [id_psg], [place]
  HAVING COUNT([place]) > 1
) AS X
) AS Y
JOIN [passenger] AS P
ON P.id_psg = Y.pas
/* 7590*/

SELECT Y.point, Y.date, IIF(Y.inc = 0, 'out', 'inc'), IIF(Y.inc = 0, Y.out, Y.inc)
FROM
(
SELECT X.point, X.date, SUM(X.inc) AS 'inc', SUM(X.out) AS 'out' FROM 
(
SELECT [point]
      ,[date]
      ,SUM([inc]) AS 'inc'
	  ,0 as 'out'
  FROM [income]
  GROUP BY [point], [date]
UNION
SELECT [point]
      ,[date]
	  ,0 as 'inc'
      ,SUM([out]) AS 'out'
  FROM [outcome]
  GROUP BY [point], [date]
) AS X
GROUP BY X.date, X.point
HAVING SUM(X.inc) = 0 OR SUM(X.out) = 0
) as Y

/* 7300 */

SELECT row_number() over(ORDER BY X.[maker], CASE WHEN X.[type] = 'PC' THEN 1 WHEN X.[type] = 'Laptop' THEN 2 ELSE 3 END) AS 'num'
      ,IIF((row_number() over(partition BY MAKER ORDER BY X.[maker], CASE WHEN X.[type] = 'PC' THEN 1 WHEN X.[type] = 'Laptop' THEN 2 ELSE 3 END))=1,X.maker,'')
	  ,X.type 
FROM
(
SELECT DISTINCT [maker], [type] 
FROM [product] AS P1
) AS X
ORDER BY X.[maker], CASE WHEN X.[type] = 'PC' THEN 1 WHEN X.[type] = 'Laptop' THEN 2 ELSE 3 END
/* 7007	*/

/* По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. 
Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). 
Вывести названия кораблей. */

---
SELECT DISTINCT X.S FROM
--SELECT X.*, C.* FROM
(
--SELECT O.[ship] AS 'S'
--      ,C.[class] AS 'C'
--	  ,DATEPART(YEAR,B.date) AS 'Y'
--  FROM [outcomes] AS O, [classes] AS C, [battles] AS B
--  WHERE C.class = O.ship AND B.name = O.battle
--UNION ALL
SELECT [name] AS 'S'
      ,[class] AS 'C'
      ,[launched] AS 'Y'
  FROM [dbo].[ships]
) AS X
JOIN [classes] AS C
ON C.class = X.C
AND C.type = 'bb'
AND C.displacement > 35000
AND X.Y > 1921
/* 6576 */


/* Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes). */
;WITH X_CTE (ship, class, guns, disp)
AS
(
SELECT X.S, X.C, C.numGuns, C.displacement 
FROM
(
SELECT O.[ship] AS 'S'
      ,C.[class] AS 'C'
  FROM [outcomes] AS O, [classes] AS C
  WHERE C.class = O.ship
UNION
SELECT [name] AS 'S'
      ,[class] AS 'C'
FROM [Ships]
) AS X
JOIN [classes] AS C
ON C.class = X.C
)
SELECT X_CTE.ship
FROM X_CTE
WHERE guns = (SELECT MAX(guns) FROM X_CTE AS Z WHERE Z.disp = X_CTE.disp)
/* 5727 */


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

/*
По таблицам Income и Outcome для каждого пункта приема найти остатки денежных средств на конец каждого дня, 
в который выполнялись операции по приходу и/или расходу на данном пункте.
Учесть при этом, что деньги не изымаются, а остатки/задолженность переходят на следующий день.
Вывод: пункт приема, день в формате "dd/mm/yyyy", остатки/задолженность на конец этого дня.
*/
USE [labor_sql]
GO


SELECT point, CONVERT(varchar, date, 103) AS DATE,
    SUM(out) OVER (PARTITION BY point
            ORDER BY date -- сортировка по дате
            RANGE -- диапазон 
            UNBOUNDED -- неограниченный 
            PRECEDING -- от текущей строки и выше
            ) 
    FROM
	(
	SELECT X.date, X.point, SUM(X.INC-X.OUC) AS OUT
FROM 
(
SELECT I.point, I.date, I.inc AS INC, 0 AS OUC
FROM [income] AS I
UNION ALL
SELECT O.point, O.date, 0 AS INC, O.out AS OUC
FROM [outcome] AS O
) AS X
GROUP BY X.date, X.point
	) AS O
/* 5023 */