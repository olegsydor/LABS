/* Задание: 97 (qwrqwr: 2013-02-15)
Отобрать из таблицы Laptop те строки, для которых выполняется следующее условие:
значения из столбцов speed, ram, price, screen возможно расположить таким образом, что каждое последующее значение будет превосходить предыдущее в 2 раза или более.
Замечание: все известные характеристики ноутбуков больше нуля.
Вывод: code, speed, ram, price, screen.
*/

USE [sql-ex]
GO

SELECT L1.[code]
      ,L1.[speed]
      ,L1.[ram]
      ,L1.[price]
      ,L1.[screen]
  FROM [Laptop] AS L1
CROSS APPLY
(SELECT *
FROM [Laptop] L2
WHERE L2.ram/L1.speed>=2 OR L1.speed/L2.ram>=2) AS L2

CROSS APPLY
[Laptop] AS L3
CROSS APPLY
[Laptop] AS L4