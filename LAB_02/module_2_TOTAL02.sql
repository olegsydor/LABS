USE O_SYDOR_MODULE_2
GO

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
--CREATE TRIGGER [dbo].[ContaragentsAllOperations]
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
GO

SET IDENTITY_INSERT [dbo].[Agents] on
GO

/*  TABLE Agents. CHECK PRIMARY KEY IN TABLE AGENTS
SET IDENTITY_INSERTED SWITCHED INTO ON 
FOR HAVING POSSIBILITY TO ADD PARTICULAR VALUE INTO THIS FIELD
*/
/* RUN THIS SCRIPT TWICE */
BEGIN TRY
	INSERT INTO [dbo].[Agents]
			   ([EDRPOU]
			   ,[ID_CONTRAGENT]
			   ,[SHORTNAME]
			   ,[FULLNAME]
			   ,[DIRECTOR]
			   ,[CAPITAL]
			   ,[FOUNDED]
			   )
		 VALUES
			   ('2652105555'
			   ,5555
			   ,'SHORTNAME, nvarchar'
			   ,'FULLNAME, nvarchar(100)'
			   ,'DIRECTOR, nvarchar(50)'
			   ,100000
			   ,'19850505'
			   )
END TRY
BEGIN CATCH
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH


/* RUN THIS SCRIPT TWICE */
BEGIN TRY
	INSERT INTO [dbo].[Agents]
			   ([EDRPOU]
			   ,[ID_CONTRAGENT]
			   ,[SHORTNAME]
			   ,[FULLNAME]
			   ,[DIRECTOR]
			   ,[CAPITAL]
			   ,[FOUNDED]
			   )
		 VALUES
			   ('2652105555'
			   ,5555
			   ,'SHORTNAME, nvarchar'
			   ,'FULLNAME, nvarchar(100)'
			   ,'DIRECTOR, nvarchar(50)'
			   ,100000
			   ,'19850505'
			   )
END TRY
BEGIN CATCH
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH


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


/* Check DELETE FROM the second pair of tables */
DELETE FROM [dbo].[Contaragents]
WHERE [ID_CONTRAGENT] = 200
GO

SELECT * FROM [dbo].[Contaragents]
SELECT * FROM [dbo].[Follow_Contragents]

