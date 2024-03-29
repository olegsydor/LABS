USE O_SYDOR_MODULE_2
GO

/* Trying to update a field with foreign key and NO ACTION */
BEGIN TRY
	UPDATE [dbo].[Moves]
		SET [SENDER_CODE] = 45
		WHERE [SENDER_CODE] = 1
END TRY
BEGIN CATCH
	SELECT   
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorLevel,
		ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO

/* Trying to delete a record from Moves */
BEGIN TRY
	DELETE FROM [dbo].[Moves]
		WHERE [SENDER_CODE] = 1 AND [RECEIVER_CODE] = 2
END TRY
BEGIN CATCH
	SELECT   
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorLevel,
		ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO

/* Trying to delete a record from Agents */
BEGIN TRY
	DELETE FROM [dbo].[Agents]
		WHERE [ID_CONTRAGENT] = 1
END TRY
BEGIN CATCH
	SELECT   
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorLevel,
		ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO

/* Trying to insert a record into Moves with forbidden set of values SENDER_CODE+RECEIVER_CODE+STATUS */
BEGIN TRY
	INSERT INTO [dbo].[Moves]
			   ([SENDER_CODE]
			   ,[RECEIVER_CODE]
			   ,[GOOD_CODE]
			   ,[GOOD_DESCR]
			   ,[NETTO]
			   ,[PRICE]
			   ,[TAX]
			   ,[STATUS]
			   ,[VEHICLE]
			   )
	VALUES
	(2, 1, '8430410000', N'ТЕСТОВЕ ДОДАВАННЯ №1', 6.00, 5044248, 0, 'V2', 'ТЕСТ')
END TRY
BEGIN CATCH
	SELECT   
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorLevel,
		ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO

/* Trying to insert a record into Moves with ALLOWING set of values SENDER_CODE+RECEIVER_CODE+STATUS */
BEGIN TRY
	INSERT INTO [dbo].[Moves]
			   ([SENDER_CODE]
			   ,[RECEIVER_CODE]
			   ,[GOOD_CODE]
			   ,[GOOD_DESCR]
			   ,[NETTO]
			   ,[PRICE]
			   ,[TAX]
			   ,[STATUS]
			   ,[VEHICLE]
			   )
	VALUES
	(3, 1, '8511100098', N'ТЕСТОВЕ ДОДАВАННЯ №2', 15.00, 74793.6448, 0, 'V5', 'ТЕСТ')
END TRY
BEGIN CATCH
	SELECT   
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorLevel,
		ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO

/* Trying to insert a record into Moves with ABBSENT RECORD IN Agents */
BEGIN TRY
	INSERT INTO [dbo].[Moves]
			   ([SENDER_CODE]
			   ,[RECEIVER_CODE]
			   ,[GOOD_CODE]
			   ,[GOOD_DESCR]
			   ,[NETTO]
			   ,[PRICE]
			   ,[TAX]
			   ,[STATUS]
			   ,[VEHICLE]
			   )
	VALUES
	(33, 1, '8511100098', N'ТЕСТОВЕ ДОДАВАННЯ №3', 150.00, 74.48, 0, 'V5', 'ТЕСТ')
END TRY
BEGIN CATCH
	SELECT   
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorLevel,
		ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO
