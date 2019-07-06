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


/* ������� ������, � ������� ������ ������ ���� ������� �� ���� ������ (������ ����� ������� � Outcomes).*/
SELECT C.[class]
    FROM [dbo].[classes] AS C
  LEFT JOIN [dbo].[ships] AS S
  ON S.class = C.class
  LEFT JOIN [dbo].[outcomes] AS O
  ON O.ship = S.name
  GROUP BY C.class
  HAVING COUNT(O.ship)+COUNT(S.name)+1 =1

  /*��� ������ ������ ���������� ���, ����� �� ���� ���� ������� ������������ ���������� �� ��������. 
  � ������, ���� �������� ��������� ����� ���, ����� ����������� �� ���. 
  �����: ������, ���������� ��������, ���*/


/* ��� ������� �������, �������������� � �������� ��� ������������ (Guadalcanal), ������� ��������, ������������� � ����� ������. */

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

/*���������� ������� ����� ������ ��� ������� �������� ��������.
�������� ��������� � ��������� �� 2-� ���������� ������.*/
SELECT round(cast(sum([numGuns])*1.0/count(numGuns) as decimal (4,2)),2)
  FROM [dbo].[classes]
  where [type] ='bb'


  /*��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. 
���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������. 
�������: �����, ���. */

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

/* ��� ������� �������� ���������� ������ � ��������� ���� ������, � ������� ��� ����������. 
�����: ��������, ������ ���� ������, ��������� ���� ������.

���������: ���� ����������� ��� ������� � ������� "yyyy-mm-dd". */
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

/* ����� ����������, ������� ������������ �������� �� ����� ���� ������������, 
����� ���, ��� �������� ���������� ���������� ������ ���������� ������ �� ���� ������������. 
������� ����� ����� ����������. */
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


/* ������� ������������ ���� ��, ����������� ������ ��������������, � �������� ���� ������ � ������� PC. 
�������: maker, ������������ ����. */


SELECT PR.[maker]
	  ,MAX(PC.price)
  FROM [product] AS PR
  JOIN [pc] AS PC
  ON PC.model = PR.model
  GROUP BY PR.maker
 /* 21460 */


/* ��� ������� �������������, �������� ������ � ������� Laptop, ������� ������� ������ ������ ����������� �� ��-���������. 
�������: maker, ������� ������ ������. */
SELECT P.maker
      ,AVG(L.[screen])
  FROM [laptop] AS L
  JOIN [product] AS P
  ON P.model = L.model
  GROUP BY P.maker

  /* 22902 */

/* ��������� ������� Product, ���������� ���������� ��������������, ����������� �� ����� ������. */

SELECT COUNT(X.CC)
FROM (
SELECT COUNT([maker]) AS CC
  FROM [dbo].[product]
  GROUP BY maker
  HAVING COUNT([model]) = 1
  ) AS X
  /* 22194 */


  /* ������� �����, ��� � ������ ��� �������� �� ������� Ships, ������� �� ����� 10 ������. */

SELECT DISTINCT S.[class]
      ,S.[name]
	  ,C.country
  FROM [ships] AS S
  JOIN [classes] AS C
  ON C.class = S.class
  WHERE C.numGuns > 9
/* 20834 */

/* ��� ������� �������� �������� ��, ������������ 600 ���, ���������� ������� ���� �� � ����� �� ���������. �������: speed, ������� ����. */

SELECT [speed]
      ,AVG([price])
  FROM [dbo].[pc]
  GROUP BY [speed]
  HAVING [speed] > 600
/* 20192 */

/* ��� ������� ��������, ������ ������ ������� �� ����� 16 ������, ������� ����� � ������. */

SELECT [class]
      ,[country]
  FROM [classes]
  WHERE [bore] >= 16
/* 19403 */


/* ������� �������� ��������, ����������� � ���������, � �������� ��������, � ������� ��� ���� ���������. */

SELECT [ship]
      ,[battle]
  FROM [outcomes]
  WHERE [result] = 'sunk'
/* 18887 */

/* ������� �������� ���� �������� � ���� ������, ������������ � ����� R. */

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

/* ������� �������� ���� �������� � ���� ������, ��������� �� ���� � ����� ���� (��������, King George V).
�������, ��� ����� � ��������� ����������� ���������� ���������, � ��� �������� ��������. */

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

/* ������� �������� �������� � �������� ������� 16 ������ (������ ������� �� ������� Outcomes). */
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

/* ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships. */
SELECT DISTINCT O.battle
FROM [ships] AS S
JOIN outcomes AS O
ON O.ship = S.name
WHERE S.class = 'Kongo'

/* 16886 */

/* � �������������, ��� ������ � ������ ����� �� ������ ������ ������ ����������� �� ���� ������ ���� � ���� 
[�.�. ��������� ���� (�����, ����)], �������� ������ � ��������� ������� (�����, ����, ������, ������). 
������������ ������� Income_o � Outcome_o. */

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

/* ��������� ������� �������� ������� �� ���� ������� ������ �� ������ ��� 15/04/01 ��� ���� ������ � ����������� �� ���� ������ ���� � ����. */

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

/* ���������� ����� ������ ����������, �����-���� �������� �� ����� � ��� �� ����� ����� ������ ����. */

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

/* �� �������������� �������������� �������� �� ������ 1922 �. ����������� ������� �������� ������� �������������� ����� 35 ���.����. 
������� �������, ���������� ���� ������� (��������� ������ ������� c ��������� ����� ������ �� ����). 
������� �������� ��������. */

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


/* ������� �������� ��������, ������� ���������� ����� ������ ����� ���� ��������� �������� ������ �� ������������� (������ ������� �� ������� Outcomes). */
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
�� �������� Income � Outcome ��� ������� ������ ������ ����� ������� �������� ������� �� ����� ������� ���, 
� ������� ����������� �������� �� ������� �/��� ������� �� ������ ������.
������ ��� ����, ��� ������ �� ���������, � �������/������������� ��������� �� ��������� ����.
�����: ����� ������, ���� � ������� "dd/mm/yyyy", �������/������������� �� ����� ����� ���.
*/
USE [labor_sql]
GO


SELECT point, CONVERT(varchar, date, 103) AS DATE,
    SUM(out) OVER (PARTITION BY point
            ORDER BY date -- ���������� �� ����
            RANGE -- �������� 
            UNBOUNDED -- �������������� 
            PRECEDING -- �� ������� ������ � ����
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