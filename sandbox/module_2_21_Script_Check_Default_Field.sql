USE O_SYDOR_MODULE_2
GO

/*  TABLE Agents. CHECK Default value for COUNTRY_COD = 840 */
INSERT INTO [dbo].[Agents]
           ([INSERTED_DATE]
           ,[EDRPOU]
           ,[SHORTNAME]
           ,[FULLNAME]
           ,[DIRECTOR]
           ,[CAPITAL]
           ,[FOUNDED]
           )
     VALUES
           ('20010101'
           ,'2652105555'
           ,'SHORTNAME, nvarchar'
           ,'FULLNAME, nvarchar(100)'
           ,'DIRECTOR, nvarchar(50)'
           ,100000
           ,'19850505'
           )
GO

BEGIN
	DECLARE @intCoutry INT
	SET @intCoutry = (SELECT [COUNTRY_COD] FROM [dbo].[Agents] WHERE ID_CONTRAGENT = SCOPE_IDENTITY())
	SELECT IIF(@intCoutry=840, 'EVERYTHING IS OK', 'SOMETHING WENT WRONG') AS RESULT
END
GO
