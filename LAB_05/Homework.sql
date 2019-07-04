﻿USE [O_SYDOR_MODULE_5]
/* 1. Написати запити з використанням під-запитів: */

/* 1a.	Отримати номери виробів, для яких всі деталі постачає постачальник 3 */
SELECT DISTINCT S1.productid FROM supplies AS S1
WHERE S1.supplierid = 3
AND NOT EXISTS (
SELECT S2.detailid FROM supplies AS S2 
WHERE S2.productid = S1.productid 
AND S2.supplierid <> S1.supplierid
)
GO
/* 1b.	Отримати номера і прізвища постачальників, які постачають деталі для якого-небудь виробу з деталлю 1 
в кількості більшій, ніж середній об’єм поставок деталі 1 для цього виробу */

SELECT DISTINCT SID, SNANE FROM
(
	SELECT	S.supplierid AS SID, 
			S.name AS SNANE, 
			S1.productid AS P, 
			S1.quantity AS Q 
	FROM suppliers AS S
	JOIN supplies AS S1
	ON S1.supplierid = S.supplierid
	AND S1.detailid = 1
) AS X
WHERE X.Q > (
	SELECT AVG(X1.quantity) 
	FROM supplies AS X1 
	WHERE X1.detailid = 1 
	AND X1.productid = X.P
)
GO

/* 1c.	Отримати повний список деталей для всіх виробів, які виготовляються в Лондоні */
SELECT DISTINCT A.detailid, D.name
FROM [supplies] AS A
JOIN [products] AS P
ON P.productid = A.productid
AND P.productid = ANY (
SELECT P1.[productid]
  FROM [products] AS P1
  WHERE P1.productid = P.productid
  AND P1.city = 'London')
JOIN [details] AS D
ON D.detailid = A.detailid
GO

/* 1d.	Показати номери і назви постачальників, що постачають принаймні одну червону деталь */
SELECT DISTINCT S.supplierid, S.name
FROM [supplies] AS A
JOIN [suppliers] AS S
ON S.supplierid = A.supplierid
JOIN [details] AS D
ON D.detailid = A.detailid
AND A.detailid IN
(
SELECT D1.detailid FROM [details] AS D1
WHERE D1.color = 'Red')
GO
-- OR --
SELECT DISTINCT S.supplierid, S.name
FROM [suppliers] AS S
WHERE S.supplierid IN 
(SELECT A1.supplierid FROM [supplies] AS A1
JOIN [details] AS D1
ON D1.detailid = A1.detailid
AND D1.color = 'Red')
GO

/* 1e.	Показати номери деталей, які використовуються принаймні в одному виробі, який поставляється постачальником 2 */
SELECT DISTINCT A.detailid
FROM [supplies] AS A
WHERE A.productid IN (
SELECT A1.productid FROM [supplies] AS A1
WHERE A1.supplierid = 2)

/* 1f.	Отримати номери виробів, для яких середній об’єм поставки деталей
більший за найбільший об’єм поставки будь-якої деталі для виробу 1 */
SELECT A.detailid 
FROM [supplies] AS A
GROUP BY A.detailid
HAVING AVG(A.quantity) > (SELECT MAX(A1.quantity) FROM [supplies] AS A1
WHERE A1.productid = 1)

/* 1g.	Вибрати вироби, що ніколи не постачались (під-запит) */
SELECT P.* FROM [products] AS P
WHERE P.productid NOT IN
(
SELECT A.productid FROM [supplies] AS A
)

/* 2. Написати запити використовуючи CTE  або Hierarchical queries */
/* 2a. Написати довільний запит з двома СТЕ  (в одному є звертання до іншого) */
/* 2b.	Обчислити за допомогою рекурсивної CTE факторіал від 10  та вивести у форматі таблиці з колонками Position та Value : */
;WITH F_CTE (rowOrder, nFaktorial) AS
(SELECT 1 AS rowOrder, 1 AS nFaktorial
UNION ALL
SELECT rowOrder+1 AS rowOrder, nFaktorial*(rowOrder+1) AS nFaktorial
from F_CTE AS S_CTE
where S_CTE.rowOrder < 10
)
SELECT TOP 1 rowOrder, nFaktorial FROM F_CTE
ORDER BY rowOrder DESC
GO

/* 2c.	Обчислити за допомогою рекурсивної CTE перші 20 елементів ряду Фібоначчі та вивести у форматі таблиці з колонками Position та Value */
;WITH F_CTE (rowOrder, nFibo, n0Fibo) AS
(SELECT 1 as rowOrder, 1 as nFibo, 0 as n0Fibo
UNION ALL
SELECT rowOrder+1, nFibo+n0Fibo, nFibo
from F_CTE AS S_CTE
where S_CTE.rowOrder < 20
)
SELECT rowOrder, nFibo FROM F_CTE
GO

/* 2d. Розділити вхідний період 2013-11-25 до 2014-03-05 на періоди по календарним місяцям за допомогою рекурсивної CTE 
та вивести у форматі таблиці з колонками StartDate та EndDate  */
DECLARE @@startDate DATE, @@endDate DATE
SET @@startDate = '20131125'
SET @@endDate = '20140305'
;WITH D_CTE (startDate, endDate)
AS
(
--SELECT CAST('2013-11-25' AS date) AS startDate, EOMONTH('2013-11-25') AS endDate
SELECT @@startDate AS startDate, EOMONTH(@@startDate) AS endDate
UNION ALL
SELECT DATEADD(DAY, 1, endDate ) AS startDate, 
		IIF(EOMONTH(DATEADD(MONTH, 1, startDate )) > @@endDate, 
		@@endDate, 
		EOMONTH(DATEADD(MONTH, 1, startDate )))   AS endDate
FROM D_CTE AS S_CTE
WHERE endDate < @@endDate
)
SELECT * FROM D_CTE
GO

/* 2e. Розрахувати календар поточного місяця за допомогою рекурсивної CTE та вивести дні місяця у форматі таблиці з колонками */



/* 3. Geography	 */
/* 3a. Створити таблицю  geography  та занести в неї дані */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'geography' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.geography
GO

CREATE TABLE [geography]
(
id int not null primary key, 
name varchar(20), 
region_id int
)
GO

ALTER TABLE [geography] ADD CONSTRAINT 
R_GB FOREIGN KEY (region_id) REFERENCES [geography] (id)
GO


insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);
GO


/* 3b. Написати запит  який повертає регіони першого рівня (результат нижче) */
;WITH cte_org AS (
    SELECT       
        id, 
        name,
        region_id,
		0 as place_level
        
    FROM       
        [geography]
	WHERE region_id IS NULL
    UNION ALL
    SELECT 
        e.id, 
        e.name,
        e.region_id,
		place_level = place_level + 1
    FROM 
        [geography] AS e
        INNER JOIN cte_org AS o 
            ON o.id = e.region_id
)
SELECT region_id AS regionID, id AS place_ID, name, place_level AS PlaceLevel
FROM 
    cte_org
	WHERE region_id = 1
	ORDER BY id
GO
/* 3c. Написати запит який повертає під-дерево для конкретного регіону  (наприклад, Івано-Франківськ). 
Результат має виглядати наступним чином (колонки можуть називатися інакше) */
;WITH cte_org AS (
    SELECT
        id,
		name,
        region_id,
		-1 AS place_level
    FROM       
        [geography]
	WHERE id = 4 -- here we set the Region (Івано-Франківськ has id=4)
    UNION ALL
    SELECT
        e.id, 
        e.name,
        e.region_id,
		place_level = place_level + 1
    FROM 
        [geography] AS e
        INNER JOIN cte_org AS o
            ON o.id = e.region_id
)
SELECT region_id, id, name, place_level
FROM 
    cte_org
	where place_level >= 0
GO

/* 3d. Написати запит котрий вертає повне дерево  від root ('Ukraine') і додаткову колонку, яка вказує на рівень в ієрархії */
;WITH cte_org AS (
    SELECT       
        id, 
        name,
        region_id,
		-1 AS place_level
    FROM       
        [geography]
    WHERE region_id IS NULL
    UNION ALL
    SELECT 
        e.id, 
        e.name,
        e.region_id,
		place_level = place_level + 1
    FROM 
        [geography] AS e
        INNER JOIN cte_org AS o
            ON o.id = e.region_id
)
SELECT region_id, id, name, place_level
FROM 
    cte_org
	where place_level >= 0
GO

/* 3e. Написати запит який повертає дерево для регіону Lviv. 
Результат має виглядати наступним чином (назви колонок можуть не співпадати): */
;WITH cte_org AS (
    SELECT       
        id, 
        name,
        region_id,
		-1 AS place_level
    FROM       
        [geography]
	WHERE id = 2
    UNION ALL
    SELECT 
        e.id, 
        e.name,
        e.region_id,
		place_level = place_level + 1
    FROM 
        [geography] AS e
        INNER JOIN cte_org AS o
            ON o.id = e.region_id
)
SELECT region_id, id, name, place_level
FROM 
    cte_org
	WHERE place_level >= 0
	ORDER BY id
GO

/* 3f. Написати запит який повертає дерево зі шляхами для регіону Lviv. 
Результат має виглядати наступним чином (назви колонок можуть не співпадати): */

;WITH cte_org AS (
    SELECT       
        id, 
        name,
        region_id,
		1 AS place_level
    FROM       
        [geography]
	WHERE id = 2
    UNION ALL
    SELECT 
        e.id, 
        e.name,
        e.region_id,
		place_level = place_level + 1
    FROM 
        [geography] AS e
        INNER JOIN cte_org AS o
            ON o.id = e.region_id
)
SELECT name, id, region_id, place_level
FROM 
    cte_org
GO

/* 3g. Написати запит, який повертає дерево  зі шляхами і довжиною шляхів для регіону Lviv. 
Результат має виглядати наступним чином (назви колонок можуть не співпадати): */

;WITH cte_org (id, name, region_id, path_len, pathh)
AS (
    SELECT
        id AS 'id',
		name AS 'name',
        region_id AS 'region_id',
		1 AS path_len,
		CAST('/' + name AS varchar) AS pathh
    FROM       
        geography
	WHERE id = 2
UNION ALL
    SELECT 
	    e.id,
        e.name,
        e.region_id,
		path_len = path_len + 1,
		CAST(o.pathh + '/'+ e.name AS varchar) AS 'pathh'
    FROM 
        [geography] AS e
        INNER JOIN cte_org AS o 
        ON o.id = e.region_id
)
SELECT name, path_len, pathh
FROM 
    cte_org
GO

/* 4. Написати запити використовуючи UNION, UNION ALL , EXCEPT, INTERSECT */

/* 4a.	Вибрати постачальників з Лондона або Парижу */
/* 4b.	Вибрати всі міста, де є постачальники  і/або деталі (два запити – перший повертає міста з дублікатами, другий без дублікатів) . Міста у кожному запиті  відсортувати в алфавітному порядку */
/* 4c.	Вибрати всіх постачальників за вийнятком тих, що постачають деталі з Лондона */
/* 4d.	Знайти різницю між множиною продуктів, які знаходяться в Лондоні та Парижі  і множиною продуктів, які знаходяться в Парижі та Римі */
/* 4e.	Вибрати поставки, що зробив постачальник з Лондона, а також поставки зелених деталей за виключенням поставлених виробів з Парижу (код постачальника, код деталі, код виробу) */
