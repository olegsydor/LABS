/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [id]
      ,[name]
      ,[region_id]
  FROM [geography]
GO
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
		-1 as place_level
        
    FROM       
        [geography]
    --WHERE region_id IS NULL
	WHERE id = 4
    UNION ALL
    SELECT 
        e.id, 
        e.name,
        e.region_id,
		place_level = place_level + 1
    FROM 
        [geography] e
        INNER JOIN cte_org o 
            ON o.id = e.region_id
)
SELECT region_id, id, name, place_level
FROM 
    cte_org
	where place_level >= 0


;WITH C_CTE (id, name, region_id)
AS
(
SELECT 4 AS id, 'Ivano-Frankivsk' AS name, -1 AS region_id
UNION ALL
SELECT id AS id, name AS name, region_id AS region_id
FROM [geography]
--WHERE X.id = region_id
) AS X
SELECT * FROM C_CTE


---

USE [O_SYDOR_MODULE_5]
GO

SELECT [id]
      ,[name]
      ,[region_id]
  FROM [dbo].[geography]
GO



WITH cte_numbers(n, weekday) 
AS (
    SELECT 
        0, 
        DATENAME(DW, 0)
    UNION ALL
    SELECT    
        n + 1, 
        DATENAME(DW, n + 1)
    FROM    
        cte_numbers
    WHERE n < 6
)
SELECT 
    weekday
FROM 
    cte_numbers;

/* staff */
;WITH cte_org AS (
    SELECT       
        id, 
        name,
        region_id,
		-1 AS place_level
        
    FROM       
        [geography]
    --WHERE region_id IS NULL
	WHERE id = 4
    UNION ALL
    SELECT 
        e.id, 
        e.name,
        e.region_id,
		place_level = place_level + 1
    FROM 
        [geography] e
        INNER JOIN cte_org o 
            ON o.id = e.region_id
)
SELECT region_id, id, name, place_level
FROM 
    cte_org
	WHERE place_level >= 0