USE [O_SYDOR_MODULE_2]

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

--DROP TABLE IF EXISTS Contragents
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Contaragents' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.Contaragents;
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Follow_Contragents' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.Follow_Contragents;
GO

CREATE TABLE dbo.Contaragents
	(
	INSERTED_DATE date NOT NULL,
	ID_CONTRAGENT int NOT NULL,
	EDRPOU nvarchar(10) NOT NULL,
	SHORTNAME nvarchar(20) NOT NULL,
	FULLNAME nvarchar(100) NOT NULL,
	PHONE_NUMBER nvarchar(20) NULL,
	ADDRESS nvarchar(50) NULL,
	DIRECTOR nvarchar(50) NULL,
	CAPITAL decimal(18, 0) NULL,
	FOUNDED date NULL,
	COUNTRY_COD int NOT NULL
	)  ON [PRIMARY]
GO

/****** COPYING THE STRUCTURE OF CONTRAGENTS INTO NEW TABLE *******/
SELECT TOP 0 * INTO dbo.Follow_Contragents 
from dbo.Contaragents
GO

/****** ADDING TWO FIELDS INTO NEW TABLE *******/
ALTER TABLE dbo.Follow_Contragents
ADD [TYPE_OF_OPERATION] VARCHAR(8) null, -- deleted, inserted, updated
    [DATE_OF_OPERATION] DATE null
GO

ALTER TABLE [dbo].[Contaragents] ADD CONSTRAINT 
    DF_Contragents_INSERTED_DATE DEFAULT (getdate()) FOR INSERTED_DATE
GO


/****** ALL trigger ******/
CREATE OR ALTER TRIGGER [dbo].[ContaragentsAllOperations]
    ON [dbo].[Contaragents]
    AFTER INSERT, UPDATE, DELETE
AS

BEGIN
	DECLARE @cntInsert AS INT
	DECLARE @cntDelete AS INT
	SET @cntInsert = (SELECT COUNT(*) FROM INSERTED)
	SET @cntDelete = (SELECT COUNT(*) FROM DELETED)

	IF @cntInsert = 0 AND @cntDelete > 0
		BEGIN
		-- DELETE
		INSERT INTO [dbo].[Follow_Contragents]
						   ([INSERTED_DATE]
						   ,[ID_CONTRAGENT]
						   ,[EDRPOU]
						   ,[SHORTNAME]
						   ,[FULLNAME]
						   ,[PHONE_NUMBER]
						   ,[ADDRESS]
						   ,[DIRECTOR]
						   ,[CAPITAL]
						   ,[FOUNDED]
						   ,[COUNTRY_COD]
						   ,[TYPE_OF_OPERATION]
						   ,[DATE_OF_OPERATION])
					SELECT [INSERTED_DATE]
						  ,[ID_CONTRAGENT]
						  ,[EDRPOU]
						  ,[SHORTNAME]
						  ,[FULLNAME]
						  ,[PHONE_NUMBER]
						  ,[ADDRESS]
						  ,[DIRECTOR]
						  ,[CAPITAL]
						  ,[FOUNDED]
						  ,[COUNTRY_COD]
						  ,'DELETED'
						  ,getdate()
					  FROM DELETED
		END

	IF @cntInsert > 0 AND @cntDelete = 0
		BEGIN
		-- INSERT
		INSERT INTO [dbo].[Follow_Contragents]
						   ([INSERTED_DATE]
						   ,[ID_CONTRAGENT]
						   ,[EDRPOU]
						   ,[SHORTNAME]
						   ,[FULLNAME]
						   ,[PHONE_NUMBER]
						   ,[ADDRESS]
						   ,[DIRECTOR]
						   ,[CAPITAL]
						   ,[FOUNDED]
						   ,[COUNTRY_COD]
						   ,[TYPE_OF_OPERATION]
						   ,[DATE_OF_OPERATION])
					SELECT [INSERTED_DATE]
						  ,[ID_CONTRAGENT]
						  ,[EDRPOU]
						  ,[SHORTNAME]
						  ,[FULLNAME]
						  ,[PHONE_NUMBER]
						  ,[ADDRESS]
						  ,[DIRECTOR]
						  ,[CAPITAL]
						  ,[FOUNDED]
						  ,[COUNTRY_COD]
						  ,'INSERTED'
						  ,getdate()
					  FROM INSERTED
		END

	IF @cntInsert > 0 AND @cntDelete > 0
		BEGIN
		-- UPDATE
		INSERT INTO [dbo].[Follow_Contragents]
						   ([INSERTED_DATE]
						   ,[ID_CONTRAGENT]
						   ,[EDRPOU]
						   ,[SHORTNAME]
						   ,[FULLNAME]
						   ,[PHONE_NUMBER]
						   ,[ADDRESS]
						   ,[DIRECTOR]
						   ,[CAPITAL]
						   ,[FOUNDED]
						   ,[COUNTRY_COD]
						   ,[TYPE_OF_OPERATION]
						   ,[DATE_OF_OPERATION])
					SELECT [INSERTED_DATE]
						  ,[ID_CONTRAGENT]
						  ,[EDRPOU]
						  ,[SHORTNAME]
						  ,[FULLNAME]
						  ,[PHONE_NUMBER]
						  ,[ADDRESS]
						  ,[DIRECTOR]
						  ,[CAPITAL]
						  ,[FOUNDED]
						  ,[COUNTRY_COD]
						  ,'UPDATED'
						  ,getdate()
					  FROM DELETED
		END

	END

