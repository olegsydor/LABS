USE O_SYDOR_MODULE_2
GO

/*  TABLE Agents. CHECK Default value for INSERTED_DATE as actual date */
INSERT INTO [dbo].[Agents]
           ([EDRPOU]
           ,[SHORTNAME]
           ,[FULLNAME]
           ,[DIRECTOR]
           ,[CAPITAL]
           ,[FOUNDED]
           )
     VALUES
           ('2652105555'
           ,'SHORTNAME, nvarchar'
           ,'FULLNAME, nvarchar(100)'
           ,'DIRECTOR, nvarchar(50)'
           ,100000
           ,'19850505'
           )
GO

BEGIN
	DECLARE @datToday DATE
	SET @datToday = (SELECT [INSERTED_DATE] FROM [dbo].[Agents] WHERE ID_CONTRAGENT = SCOPE_IDENTITY())
	SELECT IIF(@datToday = cast(getdate() as date), 'EVERYTHING IS OK', 'SOMETHING WENT WRONG') AS RESULT
END
GO