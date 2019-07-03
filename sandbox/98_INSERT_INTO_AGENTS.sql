/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [INSERTED_DATE]
      ,[ID_CONTRAGENT]
      ,[EDRPOU]
      ,[SHORTNAME]
      ,[FULLNAME]
      ,[DIRECTOR]
      ,[CAPITAL]
      ,[FOUNDED]
      ,[COUNTRY_COD]
      ,[PREV_REC]
      ,[UPDATED_DATE]
  FROM [TRAINING_01].[dbo].[Agents]


  INSERT INTO [dbo].[Agents]
           ([EDRPOU]
           , [SHORTNAME]
           , [FULLNAME]
           , [DIRECTOR]
           , [CAPITAL]
           , [FOUNDED]
           , [COUNTRY_COD])
     VALUES
	 
('13307734', N'Панда', N'ПМП ВФ ПАНДА 21022 м Вінниця вул Сергія Зулінського буд 46 Б Україна', N'Іванов', 150000	, '20150110', '840'), 
('13315604', N'Темп', N'ТОВ ВЕВП ТЕМП Україна Вінницька обл м Вінниця вул Тімірязєва 38', N'Петров', 653330	, '20190101', '840'), 
('13317508', N'ВТН', N'ТОВ ВТН 21027 м Вінниця вул 600 річчя 25 Україна', N'Сидоров', 9845313	, '20180505', '840'), 
('13322797', N'Аля', N'ТОВ АЛЯ 21021 м Вінниця вул 600 річчя 15 Україна', N'Новіков', 9658741	, '20110110', '840'), 
('13324388', N'Бліц', N'ТОВ КМП БЛІЦ 21022 м Вінниця вул Тарногродського 20', N'Голосєєв', 15421	, '20150110', '840'), 
('13331299', N'Регіна', N'ТОВ РЕГІНА ЛТД 21021 Вінницька обл м Вінниця вул Космонавтів 23', N'Король', 100000	, '20180505', '840'), 
('13331678', N'Мак', N'Товариство з обмеженою відповідальністю МАК м Вінниця вул Максимовича 12 Україна', N'Мальтус', 5000000	, '20190101', '840'), 
('13331945', N'Зодчий', N'ТОВ ЗОДЧИЙ 23700 ВІННИЦЬКА ОБЛ М ГАЙСИН ВУЛ СІЧОВИХ СТРІЛЬЦІВ БУД 9', N'Головін', 635000	, '20110110', '840'), 
('13337853', N'Руслана', N'Мале приватне підприємство РУСЛАНА 21021 м Вінниця вул Липовецька буд 1', N'Гарань', 785000	, '20190101', '840'), 
('13339958', N'Бершадь', N'ПП Фірма Бершадь Агроплюс 21037 м Вінниця вул Академіка Ющенка буд 10 приміщення 134 Украї', N'Ярко', 452000	, '20180505', '840'), 
('13345031', N'Співдружність', N'Мале підприємство Співдружність Волинська обл Луцький р н с Тарасове вул Набережна 5 Україна', N'Капа', 986541000	, '20190101', '840'), 
('13349098', N'Шлях', N'Мале підприємство Шлях 44400 Волинська обл Старовижівський р н смт Стара Вижівка вул Володими', N'Неколов', 542000	, '20150110', '840'), 
('13349767', N'Луцькавтодор', N'Приватне акціонерне товариство ЛУЦЬКАВТОДОР 43010 Волинська обл м Луцьк вул Дубнівська буд 66 Украї', N'Шапошников', 123456000	, '20110110', '840'), 
('13350167', N'Оазис', N'ПРИВАТНЕ ВИРОБНИЧЕ ПІДПРИЄМСТВО ОАЗИС 45632 Волинська обл Луцький р н село Зміїнець вул Сонячна буд', N'Олександров', 548000	, '20110110', '840'), 
('13351936', N'Корунд', N'Науково виробнича фірма КОРУНД у формі ТзОВ43017 м Луцьк вул Боженка 34Україна', N'Боженова', 877000	, '20150110', '840'), 
('13356951', N'ВФК', N'ПрАТ ВОЛИНСЬКА ФОНДОВА КОМПАНІЯ м Луцьк вул Вахтангова 16 Україна', N'Свиридова', 999000	, '20190101', '840'), 
('13357360', N'Імпект', N'Мале підприємство ІМПЕКТ 43023 Україна Волинська обл м Луцьк вул Конякіна буд 24', N'Олексієнко', 1000000	, '20180505', '840'), 
('13361024', N'Пролісок', N'Мале приватне підприємство Пролісок 45000 Волинська обл м Ковель вул Володимирська 61 Україна', N'Височан', 123555000	, '20011212', '840'), 
('13385409', N'Мікрохім', N'ТОВ НВФ МІКРОХІМ Україна93000 м Рубіжне вул Леніна 33 Луганська обл', N'Унтян', 123000	, '20150110', '840'), 
('13428292', N'Контакт', N'ПрАТ Дніпропетровський Інженерно Технічний Центр КОНТАКТ 49006м Дніпропетровськ вул Кабардинська бу', N'Цапфіров', 365000	, '20000111', '840'), 
('13429414', N'Козацький Хутір', N'ТОВ МП КОЗАЦЬКИЙ ХУТІР 53560 Дніпропетровська обл Токмаківський р н Промзона', N'Східняков', 444000	, '20190101', '840'), 
('13429839', N'Спецтехоснастка', N'ТОВ Спецтехоснастка 51921 м Кам янське вул Васильєвська 122 UA', N'Йосифов', 777000	, '20110110', '840'), 
('13430357', N'Ротор', N'ПП Ротор Україна 49064 м Дніпропетровськ пр т Калініна 61 12', N'Ранітенко', 444000	, '20150110', '840'), 
('13436070', N'Кварц', N'ТОВ ЦТО КВАРЦ 50065 Дніпроп ка обл м Кривий Ріг вул РЕВОЛЮЦІЙНА будинок 43 кв 17', N'Отренін', 9990001	, '20150110', '840'), 
('13453815', N'Отіс', N'ТОВ Отіс Тарда 49089 м Дніпро вул Автотранспортна 12 А', N'Шмитько', 4523000	, '20110110', '840'), 
('13455469', N'Супутник', N'ТОВ ЗПВ СУПУТНИК 52400 Дніпропетровська обл Солонянський р смт Солоне вул СТРОМ', N'Хілинський', 123456000	, '20190101', '840'), 
('13471936', N'Астра', N'ТОВ АСТРА 51600 Україна м Верхньодніпровськ пр Шевченка 19', N'Пастухов', 888000	, '20110110', '840'), 
('13476327', N'Кемікел Елементс', N'ТОВ КЕМІКАЛ ЕЛЕМЕНТС ЮКРЕЙН 18028 М ЧЕРКАСИ ПР Т ХІМІКІВ 74', N'Гнідко', 9988000	, '20150110', '840'), 
('13481886', N'Милосердя', N'ДОНЕЦЬКИЙ ФОНД СОЦІАЛЬНОГО ЗАХИСТУТА МИЛОСЕРДЯ ЄР39102068 м Київ вул Драгоманова 44 а кв 204 Україн', N'Макаров', 555000	, '20190101', '840'), 
('13490613', N'Біокон', N'ТОВ МНВО БІОКОН 49054 М ДНІПРО ПР Т ОЛЕКСАНДРА ПОЛЯ БУД 101 КВ ОФІС 114', N'Богданов', 555000	, '20150110', '840')

