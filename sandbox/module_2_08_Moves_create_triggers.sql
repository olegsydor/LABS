USE [O_SYDOR_MODULE_2]
GO


/***** We set a [UPDATED_DATE] field into the last date of modification ******/  
CREATE OR ALTER TRIGGER dbo.Moves_Update   
ON dbo.Moves
FOR UPDATE   
AS

DECLARE @OldVal int
SELECT @OldVal = ID_MOVE from inserted

UPDATE [dbo].[Moves]
SET [UPDATED_DATE] = getdate()
WHERE [ID_MOVE] = @OldVal
GO