USE [O_SYDOR_MODULE_2]
GO


/***** When we get some modification of table old data is copying into new record before modifying applies ******/ 
CREATE OR ALTER TRIGGER dbo.Agents_Update   
ON dbo.Agents
FOR UPDATE   
AS

INSERT INTO [dbo].[Agents]
           ([EDRPOU]
           ,[SHORTNAME]
           ,[FULLNAME]
           ,[DIRECTOR]
           ,[CAPITAL]
           ,[FOUNDED]
           ,[COUNTRY_COD]
		   ,[PREV_REC]
		   ,[UPDATED_DATE]
)
SELECT [EDRPOU]
      ,[SHORTNAME]
      ,[FULLNAME]
      ,[DIRECTOR]
      ,[CAPITAL]
      ,[FOUNDED]
      ,[COUNTRY_COD]
	  ,[ID_CONTRAGENT]
	  ,getdate()
  FROM deleted

  GO