IF EXISTS 
   (
    SELECT name FROM master.dbo.sysdatabases 
    WHERE name = N'O_SYDOR_MODULE_2'
    )
BEGIN
    SELECT 'Database Name already Exist' AS Message
END
    ELSE
BEGIN
    CREATE DATABASE [O_SYDOR_MODULE_2]
    SELECT 'New Database is Created'
END