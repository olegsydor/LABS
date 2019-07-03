USE [O_SYDOR_MODULE_2]
GO


ALTER TABLE dbo.Moves ADD CONSTRAINT
	PK_Moves PRIMARY KEY CLUSTERED 
	(
	ID_MOVE
	) WITH( STATISTICS_NORECOMPUTE = OFF, 
	        IGNORE_DUP_KEY = OFF, 
			ALLOW_ROW_LOCKS = ON, 
			ALLOW_PAGE_LOCKS = ON) 
		ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX IX_Moves_Sender ON dbo.Moves
	(
	SENDER_CODE
	) WITH( STATISTICS_NORECOMPUTE = OFF, 
	        IGNORE_DUP_KEY = OFF, 
			ALLOW_ROW_LOCKS = ON, 
			ALLOW_PAGE_LOCKS = ON) 
		ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_Moves_Receiver ON dbo.Moves
	(
	RECEIVER_CODE
	) WITH( STATISTICS_NORECOMPUTE = OFF, 
	        IGNORE_DUP_KEY = OFF, 
			ALLOW_ROW_LOCKS = ON, 
			ALLOW_PAGE_LOCKS = ON) 
		ON [PRIMARY]
GO

ALTER TABLE dbo.Moves ADD CONSTRAINT 
    DF_Moves_INSERTED_DATE DEFAULT (getdate()) FOR INSERTED_DATE
GO

ALTER TABLE dbo.Moves ADD CONSTRAINT
	FK_Moves_Agents_Receiver FOREIGN KEY
	(
	RECEIVER_CODE
	) REFERENCES dbo.Agents
	(
	ID_CONTRAGENT
	) 
	 ON UPDATE  NO ACTION
	 ON DELETE  NO ACTION 
	
GO

ALTER TABLE dbo.Moves ADD CONSTRAINT
	FK_Moves_Agents_Sender FOREIGN KEY
	(
	SENDER_CODE
	) REFERENCES dbo.Agents
	(
	ID_CONTRAGENT
	) 
	 ON UPDATE  NO ACTION
	 ON DELETE  NO ACTION 
	
GO


/****** It's impossible to have a transport from particular sender to particular receiver in one day  *******/
CREATE UNIQUE NONCLUSTERED INDEX IX_Moves_Sender_Receiver ON dbo.Moves
	(
	SENDER_CODE,
	RECEIVER_CODE,
    STATUS
	) WITH( STATISTICS_NORECOMPUTE = OFF, 
	        IGNORE_DUP_KEY = OFF, 
			ALLOW_ROW_LOCKS = ON, 
			ALLOW_PAGE_LOCKS = ON) 
		ON [PRIMARY]
GO

ALTER TABLE dbo.Moves SET (LOCK_ESCALATION = TABLE)
GO