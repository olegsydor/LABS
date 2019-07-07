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


/* Íàéäèòå êëàññû, â êîòîðûå âõîäèò òîëüêî îäèí êîðàáëü èç áàçû äàííûõ (ó÷åñòü òàêæå êîðàáëè â Outcomes).*/
SELECT C.[class]
    FROM [dbo].[classes] AS C
  LEFT JOIN [dbo].[ships] AS S
  ON S.class = C.class
  LEFT JOIN [dbo].[outcomes] AS O
  ON O.ship = S.name
  GROUP BY C.class
  HAVING COUNT(O.ship)+COUNT(S.name)+1 =1

  /*Äëÿ êàæäîé ñòðàíû îïðåäåëèòü ãîä, êîãäà íà âîäó áûëî ñïóùåíî ìàêñèìàëüíîå êîëè÷åñòâî åå êîðàáëåé. 
  Â ñëó÷àå, åñëè îêàæåòñÿ íåñêîëüêî òàêèõ ëåò, âçÿòü ìèíèìàëüíûé èç íèõ. 
  Âûâîä: ñòðàíà, êîëè÷åñòâî êîðàáëåé, ãîä*/


 /* Äëÿ êàæäîãî êîðàáëÿ, ó÷àñòâîâàâøåãî â ñðàæåíèè ïðè Ãâàäàëêàíàëå (Guadalcanal), âûâåñòè íàçâàíèå, âîäîèçìåùåíèå è ÷èñëî îðóäèé. */

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

/*Îïðåäåëèòå ñðåäíåå ÷èñëî îðóäèé äëÿ êëàññîâ ëèíåéíûõ êîðàáëåé.
Ïîëó÷èòü ðåçóëüòàò ñ òî÷íîñòüþ äî 2-õ äåñÿòè÷íûõ çíàêîâ.*/
SELECT round(cast(sum([numGuns])*1.0/count(numGuns) as decimal (4,2)),2)
  FROM [dbo].[classes]
  where [type] ='bb'


  /*Äëÿ êàæäîãî êëàññà îïðåäåëèòå ãîä, êîãäà áûë ñïóùåí íà âîäó ïåðâûé êîðàáëü ýòîãî êëàññà. 
Åñëè ãîä ñïóñêà íà âîäó ãîëîâíîãî êîðàáëÿ íåèçâåñòåí, îïðåäåëèòå ìèíèìàëüíûé ãîä ñïóñêà íà âîäó êîðàáëåé ýòîãî êëàññà. 
Âûâåñòè: êëàññ, ãîä. */

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

/* Äëÿ êàæäîãî ñðàæåíèÿ îïðåäåëèòü ïåðâûé è ïîñëåäíèé äåíü ìåñÿöà, â êîòîðîì îíî ñîñòîÿëîñü. 
Âûâîä: ñðàæåíèå, ïåðâûé äåíü ìåñÿöà, ïîñëåäíèé äåíü ìåñÿöà.

Çàìå÷àíèå: äàòû ïðåäñòàâèòü áåç âðåìåíè â ôîðìàòå "yyyy-mm-dd". */
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

/* Ñðåäè ïàññàæèðîâ, êîòîðûå ïîëüçîâàëèñü óñëóãàìè íå ìåíåå äâóõ àâèàêîìïàíèé, 
íàéòè òåõ, êòî ñîâåðøèë îäèíàêîâîå êîëè÷åñòâî ïîë¸òîâ ñàìîëåòàìè êàæäîé èç ýòèõ àâèàêîìïàíèé. 
Âûâåñòè èìåíà òàêèõ ïàññàæèðîâ. */
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


/* Íàéäèòå ìàêñèìàëüíóþ öåíó ÏÊ, âûïóñêàåìûõ êàæäûì ïðîèçâîäèòåëåì, ó êîòîðîãî åñòü ìîäåëè â òàáëèöå PC. 
Âûâåñòè: maker, ìàêñèìàëüíàÿ öåíà. */


SELECT PR.[maker]
	  ,MAX(PC.price)
  FROM [product] AS PR
  JOIN [pc] AS PC
  ON PC.model = PR.model
  GROUP BY PR.maker
 /* 21460 */


/* Äëÿ êàæäîãî ïðîèçâîäèòåëÿ, èìåþùåãî ìîäåëè â òàáëèöå Laptop, íàéäèòå ñðåäíèé ðàçìåð ýêðàíà âûïóñêàåìûõ èì ÏÊ-áëîêíîòîâ. 
Âûâåñòè: maker, ñðåäíèé ðàçìåð ýêðàíà. */
SELECT P.maker
      ,AVG(L.[screen])
  FROM [laptop] AS L
  JOIN [product] AS P
  ON P.model = L.model
  GROUP BY P.maker

  /* 22902 */

/* Èñïîëüçóÿ òàáëèöó Product, îïðåäåëèòü êîëè÷åñòâî ïðîèçâîäèòåëåé, âûïóñêàþùèõ ïî îäíîé ìîäåëè. */

SELECT COUNT(X.CC)
FROM (
SELECT COUNT([maker]) AS CC
  FROM [dbo].[product]
  GROUP BY maker
  HAVING COUNT([model]) = 1
  ) AS X
  /* 22194 */


  /* Íàéäèòå êëàññ, èìÿ è ñòðàíó äëÿ êîðàáëåé èç òàáëèöû Ships, èìåþùèõ íå ìåíåå 10 îðóäèé. */

SELECT DISTINCT S.[class]
      ,S.[name]
	  ,C.country
  FROM [ships] AS S
  JOIN [classes] AS C
  ON C.class = S.class
  WHERE C.numGuns > 9
/* 20834 */

/* Äëÿ êàæäîãî çíà÷åíèÿ ñêîðîñòè ÏÊ, ïðåâûøàþùåãî 600 ÌÃö, îïðåäåëèòå ñðåäíþþ öåíó ÏÊ ñ òàêîé æå ñêîðîñòüþ. Âûâåñòè: speed, ñðåäíÿÿ öåíà. */

SELECT [speed]
      ,AVG([price])
  FROM [dbo].[pc]
  GROUP BY [speed]
  HAVING [speed] > 600
/* 20192 */

/* Äëÿ êëàññîâ êîðàáëåé, êàëèáð îðóäèé êîòîðûõ íå ìåíåå 16 äþéìîâ, óêàæèòå êëàññ è ñòðàíó. */

SELECT [class]
      ,[country]
  FROM [classes]
  WHERE [bore] >= 16
/* 19403 */


/* Íàéäèòå íàçâàíèÿ êîðàáëåé, ïîòîïëåííûõ â ñðàæåíèÿõ, è íàçâàíèå ñðàæåíèÿ, â êîòîðîì îíè áûëè ïîòîïëåíû. */

SELECT [ship]
      ,[battle]
  FROM [outcomes]
  WHERE [result] = 'sunk'
/* 18887 */

/* Íàéäèòå íàçâàíèÿ âñåõ êîðàáëåé â áàçå äàííûõ, íà÷èíàþùèõñÿ ñ áóêâû R. */

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

/* Íàéäèòå íàçâàíèÿ âñåõ êîðàáëåé â áàçå äàííûõ, ñîñòîÿùèå èç òðåõ è áîëåå ñëîâ (íàïðèìåð, King George V).
Ñ÷èòàòü, ÷òî ñëîâà â íàçâàíèÿõ ðàçäåëÿþòñÿ åäèíè÷íûìè ïðîáåëàìè, è íåò êîíöåâûõ ïðîáåëîâ. */

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

/* Íàéäèòå íàçâàíèÿ êîðàáëåé ñ îðóäèÿìè êàëèáðà 16 äþéìîâ (ó÷åñòü êîðàáëè èç òàáëèöû Outcomes). */
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

/* Íàéäèòå ñðàæåíèÿ, â êîòîðûõ ó÷àñòâîâàëè êîðàáëè êëàññà Kongo èç òàáëèöû Ships. */
SELECT DISTINCT O.battle
FROM [ships] AS S
JOIN outcomes AS O
ON O.ship = S.name
WHERE S.class = 'Kongo'

/* 16886 */

/* Â ïðåäïîëîæåíèè, ÷òî ïðèõîä è ðàñõîä äåíåã íà êàæäîì ïóíêòå ïðèåìà ôèêñèðóåòñÿ íå ÷àùå îäíîãî ðàçà â äåíü 
[ò.å. ïåðâè÷íûé êëþ÷ (ïóíêò, äàòà)], íàïèñàòü çàïðîñ ñ âûõîäíûìè äàííûìè (ïóíêò, äàòà, ïðèõîä, ðàñõîä). 
Èñïîëüçîâàòü òàáëèöû Income_o è Outcome_o. */

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

/* Ïîñ÷èòàòü îñòàòîê äåíåæíûõ ñðåäñòâ íà âñåõ ïóíêòàõ ïðèåìà íà íà÷àëî äíÿ 15/04/01 äëÿ áàçû äàííûõ ñ îò÷åòíîñòüþ íå ÷àùå îäíîãî ðàçà â äåíü. */

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

/* Îïðåäåëèòü èìåíà ðàçíûõ ïàññàæèðîâ, êîãäà-ëèáî ëåòåâøèõ íà îäíîì è òîì æå ìåñòå áîëåå îäíîãî ðàçà. */

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

/* Ïî Âàøèíãòîíñêîìó ìåæäóíàðîäíîìó äîãîâîðó îò íà÷àëà 1922 ã. çàïðåùàëîñü ñòðîèòü ëèíåéíûå êîðàáëè âîäîèçìåùåíèåì áîëåå 35 òûñ.òîíí. 
Óêàæèòå êîðàáëè, íàðóøèâøèå ýòîò äîãîâîð (ó÷èòûâàòü òîëüêî êîðàáëè c èçâåñòíûì ãîäîì ñïóñêà íà âîäó). 
Âûâåñòè íàçâàíèÿ êîðàáëåé. */

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


/* Íàéäèòå íàçâàíèÿ êîðàáëåé, èìåþùèõ íàèáîëüøåå ÷èñëî îðóäèé ñðåäè âñåõ èìåþùèõñÿ êîðàáëåé òàêîãî æå âîäîèçìåùåíèÿ (ó÷åñòü êîðàáëè èç òàáëèöû Outcomes). */
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
Ïî òàáëèöàì Income è Outcome äëÿ êàæäîãî ïóíêòà ïðèåìà íàéòè îñòàòêè äåíåæíûõ ñðåäñòâ íà êîíåö êàæäîãî äíÿ, 
â êîòîðûé âûïîëíÿëèñü îïåðàöèè ïî ïðèõîäó è/èëè ðàñõîäó íà äàííîì ïóíêòå.
Ó÷åñòü ïðè ýòîì, ÷òî äåíüãè íå èçûìàþòñÿ, à îñòàòêè/çàäîëæåííîñòü ïåðåõîäÿò íà ñëåäóþùèé äåíü.
Âûâîä: ïóíêò ïðèåìà, äåíü â ôîðìàòå "dd/mm/yyyy", îñòàòêè/çàäîëæåííîñòü íà êîíåö ýòîãî äíÿ.
*/
USE [labor_sql]
GO


SELECT point, CONVERT(varchar, date, 103) AS DATE,
    SUM(out) OVER (PARTITION BY point
            ORDER BY date -- ñîðòèðîâêà ïî äàòå
            RANGE -- äèàïàçîí 
            UNBOUNDED -- íåîãðàíè÷åííûé 
            PRECEDING -- îò òåêóùåé ñòðîêè è âûøå
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

/* Find the PC makers with all personal computer models produced by them being present in the PC table.*/

SELECT DISTINCT P.maker FROM [Product] AS P
WHERE P.type = 'PC'
AND 
--NOT EXISTS P.model WHERE NOT IN PC
NOT EXISTS (
SELECT P1.model FROM Product AS P1
WHERE P1.maker = P.maker
AND P1.type = 'PC'
AND P1.model NOT IN
(SELECT model FROM PC)
)

/* 4584 */

/* Among the customers using a single airline, find distinct passengers who have flown most frequently. 
Result set: passenger name, number of trips.*/

SELECT TOP 1 WITH TIES 
G.name, X.cnt FROM [Passenger] AS G
JOIN
(
SELECT COUNT(P.[date]) AS CNT
      ,P.[id_psg]
  FROM [pass_in_trip] AS P
  JOIN [trip] AS T
  ON T.trip_no = P.trip_no
  GROUP BY P.ID_psg
  HAVING COUNT(DISTINCT(T.ID_comp)) = 1) AS X
ON X.ID_psg = G.ID_psg
ORDER BY X.CNT DESC
/* 4417 */

/*For each country, determine the battles in which the ships of this country did not participate.
Result set: country, battle.*/


  SELECT DISTINCT C.country, B.name FROM Classes AS C, Battles AS B
  EXCEPT
SELECT CC.country, O.battle FROM 
(
SELECT S.[name]
      ,S.[class]
  FROM [Ships] AS S
UNION ALL
  SELECT C.[class] AS name
        ,C.class  AS class
  FROM [Classes] AS C
) AS X
  JOIN Classes AS CC
  ON CC.class = X.class
  JOIN [Outcomes] AS O
  ON O.ship = X.name

  /* 4260 */
/* Get all ship classes of Russia. If there are no Russian ship classes in the database, display classes of all countries present in the DB.
Result set: country, class.*/
  ;WITH C_CTE (class, country) AS
(
SELECT DISTINCT CC.class, CC.country FROM 
(
SELECT S.[name]
      ,S.[class]
  FROM [Ships] AS S
UNION ALL
  SELECT C.[class] AS name
        ,C.class  AS class
  FROM [Classes] AS C
) AS X
  JOIN Classes AS CC
  ON CC.class = X.class
)
SELECT country, class FROM C_CTE
WHERE C_CTE.country = ALL(
SELECT country FROM C_CTE WHERE C_CTE.country = 'Russia')
/* 4119 */
