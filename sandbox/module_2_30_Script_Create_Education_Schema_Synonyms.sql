USE O_SYDOR_MODULE_2
GO

IF EXISTS 
   (
    SELECT name FROM master.dbo.sysdatabases 
    WHERE name = N'EDUCATION'
    )
BEGIN
    SELECT 'Database Name already Exist' AS Message
END
    ELSE
BEGIN
    CREATE DATABASE [EDUCATION]
    SELECT 'New Database is Created' as Message
END
GO

USE EDUCATION
GO

IF EXISTS 
    (
	 SELECT name FROM sys.schemas 
	 WHERE name = N'osydor')
BEGIN
    SELECT 'Schema osydor has been created before' AS Message
END
   ELSE
BEGIN
   EXEC('CREATE SCHEMA [osydor]')
   SELECT 'Schema osydor has been just created' AS Message

END
GO


/* Creating synonims A1, A2, A3, A4 */
IF EXISTS
   (
   SELECT name FROM sys.synonyms
   WHERE name = 'A1')
BEGIN
   SELECT 'Synonym A1 has been created before' AS Message
END
ELSE
BEGIN
   CREATE SYNONYM A1 FOR [O_SYDOR_MODULE_2].[dbo].[Agents]
   SELECT 'Synonym A1 has been just created' AS Message
END   
GO

IF EXISTS
   (
   SELECT name FROM sys.synonyms
   WHERE name = 'A2')
BEGIN
   SELECT 'Synonym A2 has been created before' AS Message
END
ELSE
BEGIN
   CREATE SYNONYM A2 FOR [O_SYDOR_MODULE_2].[dbo].[Contaragents]
   SELECT 'Synonym A2 has been just created' AS Message
END   
GO

IF EXISTS
   (
   SELECT name FROM sys.synonyms
   WHERE name = 'A3')
BEGIN
   SELECT 'Synonym A3 has been created before' AS Message
END
ELSE
BEGIN
   CREATE SYNONYM A3 FOR [O_SYDOR_MODULE_2].[dbo].[Follow_Contragents]
   SELECT 'Synonym A3 has been just created' AS Message
END   
GO

IF EXISTS
   (
   SELECT name FROM sys.synonyms
   WHERE name = 'A4')
BEGIN
   SELECT 'Synonym A4 has been created before' AS Message
END
ELSE
BEGIN
   CREATE SYNONYM A4 FOR [O_SYDOR_MODULE_2].[dbo].[Moves]
   SELECT 'Synonym A4 has been just created' AS Message
END
GO