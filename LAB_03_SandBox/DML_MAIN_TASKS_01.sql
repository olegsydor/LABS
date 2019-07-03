USE O_SYDOR_MODULE_3

/* 1. Збільшити на 10 рейтинг всіх постачальників, рейтинг яких в даний момент менший ніж рейтинг постачальника 4 */

BEGIN
	DECLARE @intRating INT
	SET @intRating = (SELECT [rating] FROM [dbo].[suppliers] WHERE [supplierid] = 4)

	UPDATE [dbo].[suppliers]
	  SET [rating] += 10
	  WHERE [rating] < @intRating
END
GO



/* 2. Побудувати таблицю, в якій занесено список номерів виробів, що або знаходяться в Лондоні, 
      або для них поставляються деталі яким-небудь постачальником з Лондона */

SELECT DISTINCT P.[productid]
      ,P.[name]
	INTO [dbo].[tmp_02]
	FROM [dbo].[supplies] AS F
	JOIN [dbo].[suppliers] AS S
	ON S.supplierid = F.supplierid
--	JOIN [dbo].[details] AS D
--	ON D.detailid = F.detailid
	JOIN [dbo].[products] AS P
	ON P.productid = F.productid
	WHERE P.city = 'London'
	OR
	S.city = 'London'

/* 3. Видалити всі вироби, для яких немає поставок деталей */
/*USE [O_SYDOR_MODULE_3]
GO

INSERT INTO [dbo].[products]
           ([productid]
           ,[name]
           ,[city])
     VALUES
           (100
           ,'Useless detail'
           ,'London'),
		   (101
           ,'Useless detail again'
           ,'Paris')
GO
*/

DELETE FROM products
WHERE [productid] NOT IN (
	SELECT DISTINCT productid FROM [dbo].[supplies]
)

/* 4. Створити таблицю з номерами постачальників і парами номерів деталей, таких, що кожен з постачальників поставляє обидві вказані деталі */

/* 5. Збільшити розмір поставки на 10 відсотків для всіх поставок тих постачальників, які поставляють яку-небудь Червону деталь */

UPDATE [dbo].[supplies]
  SET [quantity] *= 1.1
  WHERE [supplierid] IN
  (
  SELECT DISTINCT F.[supplierid]
	FROM [dbo].[supplies] AS F
	JOIN [dbo].[suppliers] AS S
	ON S.supplierid = F.supplierid
	JOIN [dbo].[details] AS D
	ON D.detailid = F.detailid
	WHERE D.color = 'Red'
  )
	

/* 6. Створити таблицю  з комбінаціями «колір деталі -- місто де зберігається деталь» з видаленням дублікатів */
SELECT DISTINCT 
       [color] AS 'detail color'
      ,[city] AS 'detail city'
	  INTO [dbo].[tmp_06]
	  FROM [dbo].[details]


/* 7. Занести в новостворену таблицю список номерів деталей, які поставляються 
      будь-яким постачальником з Лондона чи для будь-якого виробу з Лондона */
SELECT DISTINCT F.[detailid] AS 'detail id'
	INTO [dbo].[tmp_07]
	FROM [dbo].[supplies] AS F
	JOIN [dbo].[suppliers] AS S
	ON S.supplierid = F.supplierid
	JOIN [dbo].[details] AS D
	ON D.detailid = F.detailid
	JOIN [dbo].[products] AS P
	ON P.productid = F.productid
	WHERE P.city = 'London'
	OR
	S.city = 'London'

/* 8.	Вставити в таблицю постачальників постачальника з кодом 10, прізвищем Уайт, з міста Нью-Йорк з невідомим рейтингом   */
INSERT INTO [dbo].[suppliers]
           ([supplierid]
           ,[name]
           ,[city])
     VALUES
           (10
           ,'White'
           ,'New York')
GO



/* 9.	Видалити всі вироби з Риму і всі відповідні поставки */



/*
BEGIN TRANSACTION
GO
ALTER TABLE dbo.supplies ADD CONSTRAINT
	FK_supplies_products FOREIGN KEY
	(
	productid
	) REFERENCES dbo.products
	(
	productid
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
*/
/* 10. Ñòâîðèòè òàáëèöþ ç âïîðÿäêîâàíèì ñïèñêîì âñ³õ ì³ñò â ÿêèõ º ïî êðàéí³é ì³ð³ îäèí ïîñòà÷àëüíèê, îäíà äåòàëü ÷è âèð³á */

/* 11. Çì³íèòè êîë³ð ÷åðâîíèõ äåòàëåé ç âàãîþ ìåíøå 15 ôóíò³â íà æîâòèé. */

/* 12. Ñòâîðèòè òàáëèöþ ç íîìåðàìè âèðîá³â ³ íàçâàìè ì³ñò, äå âîíè âèãîòîâëÿþòüñÿ. Äîäàòêîâà óìîâà – äðóãà ë³òåðà íàçâà ì³ñòà ïîâèííà áóòè ‘î’ */

/* 13. Çá³ëüøèòè íà 10 ðåéòèíã òèõ ïîñòà÷àëüíèê³â, îá’ºì ïîñòàâîê ÿêèõ âèùå ñåðåäíüîãî */

/* 14. Ñòâîðèòè òàáëèöþ ç âïîðÿäêîâàíèìè ñïèñêàìè íîìåð³â ³ ïð³çâèùàìè ïîñòà÷àëüíèê³â, ÿê³ ïîñòà÷àþòü äåòàë³ äëÿ âèðîáó 1. */

/* 15. Âñòàâèòè â òàáëèöþ äâîõ ð³çíèõ ïîñòà÷àëüíèê³â îäíîþ êîìàíäîþ */