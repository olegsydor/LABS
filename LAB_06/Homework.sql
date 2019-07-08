USE [O_SYDOR_MODULE_5]
/*
1. Написати команду, яка повертає список продуктів, 
складений в алфавітному порядку міст де вони знаходяться + порядковий номер деталі в списку 
(наскрізна нумерація для порядкового номера). Результат має виглядати наступним чином:
*/

SELECT [productid]
      ,[name]
      ,[city]
	  ,ROW_NUMBER() OVER(ORDER BY [City]) AS 'порядковий номер'
  FROM [products]

/*
2.	Написати команду, яка повертає список продуктів, складений в алфавітному порядку міст де вони знаходяться 
+ порядковий номер в межах одного міста (відсортований за іменем продукту).
*/
SELECT [productid]
      ,[name]
      ,[city]
	  ,ROW_NUMBER() OVER(PARTITION BY [City] ORDER BY [name]) AS 'порядковий номер в межах міста'
  FROM [products]

/* 3.	Використовуючи за основу попередній запит написати запит, який повертає міста з порядковим номером 1. Результат має виглядати так:*/
SELECT *
FROM (
SELECT [productid]
      ,[name]
      ,[city]
	  ,ROW_NUMBER() OVER(PARTITION BY [City] ORDER BY [name]) AS 'порядковий номер в межах міста'
  FROM [products]) AS X
  WHERE X.[порядковий номер в межах міста] = 1
 
/* 4.	Написати запит, який повертає список продуктів, деталей, їхні поставки,  загальну кількість поставок для кожного продукту 
і загальну кількість поставок для кожної деталі.
*/
SELECT [productid]
      ,[detailid]
      ,[quantity]
	  ,SUM([quantity]) OVER (PARTITION BY [productid]) AS 'all_quantity_per_prod'
	  ,SUM([quantity]) OVER (PARTITION BY [detailid]) AS 'all_quantity_per_det'
  FROM [dbo].[supplies]

/*
5.	Організувати посторінковий вивід інформації з таблиці поставок, 
відсортований за  постачальниками, вивести записи з 10 по 15 запис, 
додатково вивести порядковий номер стрічки і загальну кількість записів у таблиці поставок. 
*/
 
SELECT [supplierid]
      ,[detailid]
      ,[productid]
      ,[quantity]
	  ,ROW_NUMBER() OVER (ORDER BY [supplierid]) AS rn
	  ,COUNT(*) OVER () AS tot
  FROM [dbo].[supplies]
  ORDER BY [supplierid]
  OFFSET 9 ROWS 
  FETCH NEXT 6 ROWS ONLY
/*
6.	Написати запит, що розраховує середню кількість елементів в поставці 
і виводить ті поставки, де кількість елементів менше середньої.
*/
SELECT * FROM
(
SELECT [supplierid]
      ,[detailid]
      ,[productid]
	  ,[quantity]
	  ,AVG([quantity]) OVER () AS 'avg_qty'
  FROM [dbo].[supplies]
) AS X
WHERE X.quantity < X.avg_qty
GO
