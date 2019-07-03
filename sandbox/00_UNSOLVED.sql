/****** Why can't I catch this error by TRY-CATCH  ******/
BEGIN TRY
	UPDATE [DBO].[Agents]
		SET [ID_CONTRAGENT] = 45
		WHERE [ID_CONTRAGENT] = 2
END TRY
BEGIN CATCH
	SELECT   
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorLevel,
		ERROR_MESSAGE() AS ErrorMessage;  
END CATCH