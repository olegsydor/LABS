IF EXISTS 
   (
    SELECT name FROM master.dbo.sysdatabases 
    WHERE name = N'O_SYDOR_MODULE_5'
    )
BEGIN
    SELECT 'Database Name already Exist' AS Message
END
    ELSE
BEGIN
    CREATE DATABASE [O_SYDOR_MODULE_5]
    SELECT 'New Database is Created'
END
GO

USE O_SYDOR_MODULE_5
GO

/* DELETING TABLE WITH secondary Key */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'supplies' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.supplies;
GO


/* CREATE TABLE suppliers. */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'suppliers' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.suppliers;
GO

CREATE TABLE dbo.suppliers
	(
	supplierid int NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	rating int NOT NULL,
	city varchar(20) NOT NULL
	)  ON [PRIMARY]
GO

/* CREATE TABLE details. */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'details' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.details;
GO

CREATE TABLE dbo.details
	(
	detailid int NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	color varchar(20) NOT NULL,
	weight int NOT NULL,
	city varchar(20) NOT NULL
	)  ON [PRIMARY]
GO

/* CREATE TABLE PRODUCTS */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'products' AND TABLE_SCHEMA = 'dbo')
DROP TABLE dbo.products;
GO

CREATE TABLE dbo.products
	(
	productid int NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	city varchar(20) NOT NULL
	)  ON [PRIMARY]
GO


/* CREATE TABLE supplies. */
CREATE TABLE dbo.supplies
	(
	supplierid int NOT NULL,
	detailid int NOT NULL,
	productid int NOT NULL,
	quantity int NOT NULL
	)  ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_supplier ON dbo.supplies
	(
	supplierid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_detail ON dbo.supplies
	(
	detailid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_product ON dbo.supplies
	(
	productid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/*Relationships */

ALTER TABLE dbo.supplies ADD CONSTRAINT
	FK_supplies_suppliers FOREIGN KEY
	(
	supplierid
	) REFERENCES dbo.suppliers
	(
	supplierid
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.supplies ADD CONSTRAINT
	FK_supplies_products FOREIGN KEY
	(
	productid
	) REFERENCES dbo.products
	(
	productid
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.supplies ADD CONSTRAINT
	FK_supplies_details FOREIGN KEY
	(
	detailid
	) REFERENCES dbo.details
	(
	detailid
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
