SELECT P.[productid]
      ,P.[name]
      ,P.[city]
  FROM [dbo].[products] AS P

SELECT S.[supplierid]
      ,S.[name]
      ,S.[rating]
      ,S.[city]
  FROM [dbo].[suppliers] AS S

SELECT D.[detailid]
      ,D.[name]
      ,D.[color]
      ,D.[weight]
      ,D.[city]
  FROM [dbo].[details] AS D

SELECT F.[supplierid]
      ,F.[detailid]
      ,F.[productid]
      ,F.[quantity]
  FROM [dbo].[supplies] AS F
GO
-----------------
SELECT F.[supplierid] AS 'supplierid'
      ,S.[name] AS 'supplier name'
      ,S.[rating] AS 'supplier rating'
      ,S.[city] AS 'supplier city'
	  ,F.[detailid] AS 'detail id'
      ,D.[name] AS 'detail name'
      ,D.[color] AS 'detail color'
      ,D.[weight] AS 'detail weight'
      ,D.[city] AS 'detail city'
	  ,F.[productid] AS 'product id'
      ,P.[name] AS 'product name'
      ,P.[city] AS 'product city'
	  ,F.[quantity] AS 'quantity'
	FROM [dbo].[supplies] AS F
	JOIN [dbo].[suppliers] AS S
	ON S.supplierid = F.supplierid
	JOIN [dbo].[details] AS D
	ON D.detailid = F.detailid
	JOIN [dbo].[products] AS P
	ON P.productid = F.productid
	--ORDER BY P.productid
	--ORDER BY S.supplierid
	WHERE P.city = 'London'
	OR
	S.city = 'London'


SELECT DISTINCT F.[productid]
      ,P.[name]
	FROM [dbo].[supplies] AS F
	JOIN [dbo].[suppliers] AS S
	ON S.supplierid = F.supplierid
--	JOIN [dbo].[details] AS D
--	ON D.detailid = F.detailid
	JOIN [dbo].[products] AS P
	ON P.productid = F.productid
	WHERE P.city = 'London'
	OR
	S.city = 'London'
