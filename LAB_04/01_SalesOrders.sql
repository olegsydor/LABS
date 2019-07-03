USE [SalesOrders]
GO


/* 1. В яких містах живуть наші клієнти? */
SELECT DISTINCT [CustCity]
  FROM [dbo].[Customers]
GO


/* 2. Показати поточний список наших працівників і номери їхніх телефонів. */
SELECT [EmpFirstName]+' '+[EmpLastName]
      ,[EmpPhoneNumber]
  FROM [dbo].[Employees]
GO


/* 3. Продукти яких категорій ми пропонуємо в даний момент часу? */
SELECT DISTINCT P.[CategoryID] ,C.[CategoryDescription]
  FROM [dbo].[Products] AS P
  JOIN
  [dbo].[Categories] AS C
  ON C.CategoryID = P.CategoryID
WHERE P.QuantityOnHand > 0 -- It is need for cases when some good isn't present now
GO


  /* 4. Як називаються і скільки коштують продукти котрі ми перевозимо і до якої категорії вони відносяться. */
/* Закоментив цю кверю, бо Statisticкаже, що вона набагато важча, ніж наступна
SELECT DISTINCT P.[ProductName]
      ,P.[RetailPrice]
      ,C.[CategoryDescription]
  FROM [dbo].[Products] AS P
  JOIN
  [dbo].[Categories] AS C
  ON C.CategoryID = P.CategoryID
  JOIN [dbo].[Product_Vendors] AS V
  ON V.ProductNumber = P.ProductNumber
GO
*/

  /* 4. Як називаються і скільки коштують продукти котрі ми перевозимо і до якої категорії вони відносяться. */
/*
SELECT P.[ProductName]
      ,P.[RetailPrice]
      ,C.[CategoryDescription]
  FROM [dbo].[Products] AS P
  JOIN
  [dbo].[Categories] AS C
  ON C.CategoryID = P.CategoryID
  WHERE EXISTS (SELECT ProductNumber FROM [dbo].[Product_Vendors] AS V WHERE V.ProductNumber = P.ProductNumber)
GO
*/
SELECT P.[ProductName]
      ,P.[RetailPrice]
      ,C.[CategoryDescription]
  FROM [dbo].[Products] AS P
  JOIN
  [dbo].[Categories] AS C
  ON C.CategoryID = P.CategoryID
  WHERE P.ProductNumber IN (SELECT ProductNumber FROM [dbo].[Product_Vendors])
GO


/* 5. Показати список імен поставщиків в порядку поштових індексів. */
SELECT [VendName]
  FROM [SalesOrders].[dbo].[Vendors]
  ORDER BY [VendZipCode]
GO

/* 6. Показати список працівників разом з їхніми телефонами і ідентифікаційними номерами і відсортувати його по прізвищах і іменах. */
SELECT [EmpFirstName]
      ,[EmpLastName]
      ,[EmpPhoneNumber]
      ,[EmployeeID]
  FROM [SalesOrders].[dbo].[Employees]
  ORDER BY [EmpLastName], [EmpFirstName]
GO

/* 7. Показати імена всіх поставщиків. */
SELECT DISTINCT [VendName]
FROM [SalesOrders].[dbo].[Vendors]
GO

/* 8. В яких штатах знаходяться наші клієнти? */
SELECT DISTINCT [CustState]
  FROM [SalesOrders].[dbo].[Customers]
GO

/* 9. Як називаються і скільки коштують товари, котрими ми торгуємо? */
SELECT DISTINCT PR.[ProductName]
      ,PR.[RetailPrice]
  FROM [dbo].[Order_Details] AS OD
  JOIN [dbo].[Products] AS PR
  ON PR.ProductNumber = OD.ProductNumber

GO

/* 10. Показати всю інформацію про наших співробітниках. */
SELECT [EmployeeID]
      ,[EmpFirstName]
      ,[EmpLastName]
      ,[EmpStreetAddress]
      ,[EmpCity]
      ,[EmpState]
      ,[EmpZipCode]
      ,[EmpAreaCode]
      ,[EmpPhoneNumber]
  FROM [SalesOrders].[dbo].[Employees]
GO

/* 11. Показати в алфавітному порядку список міст в котрих є наші поставщики 
і включити в нього імена всіх поставщиків, з якими ми працюємо в кожному місті. */
SELECT V.[VendCity]
      ,V.[VendName]
  FROM [SalesOrders].[dbo].[Vendors] AS V
WHERE V.VendorID IN (
	SELECT PV.[VendorID] FROM [dbo].Product_Vendors AS PV
	JOIN [dbo].Products AS P
	ON P.ProductNumber = PV.ProductNumber
	JOIN [dbo].Order_Details AS OD
	ON OD.ProductNumber = PV.ProductNumber
)  
ORDER BY V.VendCity
GO

/* 12. Скільки днів потрібно для доставки кожного замовлення? */
/*
SELECT X.ORDN AS 'Order Number'
      ,MAX(X.DD) AS 'Time of Delivery'-- The "slowest" good defines the time delivering of the order  
FROM 
(
SELECT 
     OD.[OrderNumber] AS 'ORDN'
   	,PV.[ProductNumber] AS 'PRDN'
	,MIN(PV.DaysToDeliver) AS 'DD' --if we can deliver some good from two or more vendors we choose the fastest one
FROM [SalesOrders].[dbo].[Product_Vendors] AS PV
LEFT JOIN
	[SalesOrders].[dbo].[Order_Details] AS OD
ON OD.[ProductNumber] = PV.[ProductNumber]
GROUP BY OD.OrderNumber, PV.ProductNumber
) AS X
GROUP BY X.ORDN
ORDER BY X.ORDN
GO
*/
/* 12. Скільки днів потрібно для доставки кожного замовлення? */
SELECT	X.ONUM AS 'Order Number', 
		X.COMPL+DATEDIFF(day, [OrderDate], [ShipDate]) AS 'Days between ordering and delivering'
FROM
	(SELECT 
		 OD.[OrderNumber] AS 'ONUM'
		,MAX(PV.DaysToDeliver) AS 'COMPL'
	FROM [SalesOrders].[dbo].[Product_Vendors] AS PV
	LEFT JOIN
		[SalesOrders].[dbo].[Order_Details] AS OD
	ON OD.[ProductNumber] = PV.[ProductNumber]
	GROUP BY OD.OrderNumber
	) X
JOIN [dbo].[Orders] AS ORD
ON ORD.OrderNumber = X.ONUM
--ORDER BY X.ONUM



/* 13. Яка вартість запасів кожного товару */
SELECT [ProductName]
      ,[QuantityOnHand]*[RetailPrice] AS 'Total Balance'
  FROM [SalesOrders].[dbo].[Products]
GO

/* 14. Скільки днів пройшло від дати замовлення до дати поставки кожного замовлення? */
SELECT [OrderNumber] AS 'Order Number'
      ,DATEDIFF(day, [OrderDate], [ShipDate]) AS 'Days between ordering and delivering'
  FROM [SalesOrders].[dbo].[Orders]
GO


/* Виведіть одним запитом список натуральних чисел від 1 до 10 000. */

;WITH Numbs AS 
(
SELECT n FROM (VALUES ('0'),('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9')) AS Something([N])
)
SELECT CAST((A1.n + A2.n + A3.n + A4.n) AS int)+1 AS 'Numbers'
FROM Numbs AS A1, Numbs AS A2, Numbs AS A3, Numbs AS A4
ORDER BY 1
GO


/* Порахуйте запитом скільки субот і неділь в поточному році */
SET DATEFIRST 1; -- SET Monday as the first day of week
;WITH Numbs AS -- Using CTE similar to previous query
(
SELECT n FROM (VALUES ('0'),('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9')) AS M(N)
)
SELECT COUNT(D) AS 'Saturdays and Sundays in 2019'
FROM -- Wrapping SELECT to have possibiity creating ALIASES in WHERE
	(
		SELECT CAST('20190101' AS DATETIME) + CAST((A1.n + A2.n + A3.n + A4.n) AS int) AS D
		FROM Numbs AS A1, Numbs AS A2, Numbs AS A3, Numbs AS A4
	) AS X
WHERE X.D < '20200101' AND DATEPART(WEEKDAY,(X.D)) IN (6,7) -- Day must be less then 2020 Jan, 1 and must be Saturday or Sunday
GO
