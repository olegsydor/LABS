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


--DROP TABLE IF EXISTS Agents
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Agents' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.Agents;
GO


CREATE TABLE dbo.Agents
	(
	INSERTED_DATE date NOT NULL,
	ID_CONTRAGENT int NOT NULL IDENTITY (1, 1),
	EDRPOU nvarchar(10) NOT NULL,
	SHORTNAME nvarchar(20) NOT NULL,
	FULLNAME nvarchar(100) NOT NULL,
	DIRECTOR nvarchar(50) NULL,
	CAPITAL decimal(18, 0) NULL,
	FOUNDED date NULL,
	COUNTRY_COD int NOT NULL,
	PREV_REC int NULL,
	UPDATED_DATE date NULL
	)  ON [PRIMARY]
GO