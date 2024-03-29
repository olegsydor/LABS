/****** Script for SelectTopNRows command from SSMS  ******/
USE [O_SYDOR_MODULE_2]
GO


/* Check UPDATE ONE field in the second pair of tables */
UPDATE [dbo].[Contaragents]
    SET [EDRPOU] = '9876543210',
	    [CAPITAL] = 1000000.01
	WHERE [ID_CONTRAGENT] = 100
GO

SELECT * FROM [dbo].[Contaragents]
SELECT * FROM [dbo].[Follow_Contragents]

/* Check UPDATE A FEW fields in the second pair of tables */
UPDATE [dbo].[Contaragents]
    SET [EDRPOU] = '9876543210',
	    [CAPITAL] = 0
	WHERE [ID_CONTRAGENT] >= 200
GO

SELECT * FROM [dbo].[Contaragents]
SELECT * FROM [dbo].[Follow_Contragents]