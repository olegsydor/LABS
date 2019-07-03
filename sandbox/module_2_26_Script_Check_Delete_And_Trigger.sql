/****** Script for SelectTopNRows command from SSMS  ******/
USE [O_SYDOR_MODULE_2]
GO

/* Check DELETE FROM the second pair of tables */
DELETE FROM [dbo].[Contaragents]
WHERE [ID_CONTRAGENT] = 200
GO

SELECT * FROM [dbo].[Contaragents]
SELECT * FROM [dbo].[Follow_Contragents]
