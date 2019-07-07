/* Написати запит який повертає під-дерево для конкретного регіону  (наприклад, Івано-Франківськ). 
Результат має виглядати наступним чином (колонки можуть називатися інакше) 

regionID    place_ID    name                 PlaceLevel
----------- ----------- -------------------- -----------
4           21          Galych               0
4           22          Kalush               0
4           23          Dolyna               0
21          32          Svobody st           1
*/

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

/* Написати запит котрий вертає повне дерево  від root ('Ukraine') і додаткову колонку, яка вказує на рівень в ієрархії */
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

/* Написати запит який повертає дерево для регіону Lviv . Результат має виглядати наступним чином (назви колонок можуть не співпадати) */

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


/*
-	Написати запит  який повертає регіони першого рівня (результат нижче)

regionID    place_ID    name                 PlaceLevel
----------- ----------- -------------------- -----------
1           2           Lviv                 1
1           3           Rivne                1
1           4           Ivano-Frankivsk      1
1           5           Kiyv                 1
1           6           Sumy                 1
1           7           Crimea               1

(6 row(s) affected)

*/


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


/* Написати запит який повертає дерево зі шляхами для регіону Lviv. 
Результат має виглядати наступним чином (назви колонок можуть не співпадати): 
Name          id      path 
Lviv		1	/Lviv
Brody		2	/Lviv/Brody
Gayi		3	/Lviv/Brody/Gayi
Sambir		2	/Lviv/Sambir
St.Sambir	3	/Lviv/Sambir/St.Sambir
Striy		2	/Lviv/Striy
Drogobych	2	/Lviv/Drogobych
Shidnytsja	3	/Lviv/Drogobych/Shidnytsja
Truskavets	3	/Lviv/Drogobych/Truskavets
Busk		2	/Lviv/Busk
Olesko		3	/Lviv/Busk/Olesko
Lvivska st	4	/Lviv/Busk/Olesko/Lvivska st
Verbljany	3	/Lviv/Busk/Verbljany


*/

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