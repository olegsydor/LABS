/****** Script for SelectTopNRows command from SSMS  ******/
USE [O_SYDOR_MODULE_2]
GO

/* Check INSERT into the second pair of tables */
INSERT INTO [dbo].[Contaragents]
           ([ID_CONTRAGENT]
           ,[EDRPOU]
           ,[SHORTNAME]
           ,[FULLNAME]
           ,[PHONE_NUMBER]
           ,[ADDRESS]
           ,[DIRECTOR]
           ,[CAPITAL]
           ,[FOUNDED]
           ,[COUNTRY_COD])
     VALUES
           (100
           ,'1234567890'
           ,'<SHORTNAME>'
           ,'<FULLNAME>'
           ,'555-555-55'
           ,'<ADDRESS>'
           ,'<DIRECTOR>'
           ,10000.50
           ,'20011025'
           ,840)
		   ,
		   (200
           ,'2345678900'
           ,'<SHORTNAME-2>'
           ,'<FULLNAME-2>'
           ,'555-555-55'
           ,'<ADDRESS-2>'
           ,'<DIRECTOR-2>'
           ,100000.50
           ,'20010127'
           ,840)
		   ,
		   (201
           ,'3456789000'
           ,'<SHORTNAME-3>'
           ,'<FULLNAME-3>'
           ,'555-555-55'
           ,'<ADDRESS-3>'
           ,'<DIRECTOR-3>'
           ,100001.50
           ,'20010125'
           ,840)
GO

SELECT * FROM [dbo].[Contaragents]
SELECT * FROM [dbo].[Follow_Contragents]