-- 1 ----------------------------------------------------
SELECT *
  FROM [SQL_Training].[dbo].[inc_5000_us]
  WHERE company = 'Nordic'

-- 2 ----------------------------------------------------
SELECT TOP (10) company, growth, revenue, industry, NEWID()
FROM inc_5000_us
ORDER BY NEWID();

-- 3 ----------------------------------------------------
/*Recupera todos los registros para los cuales la empresa se encuentra en el estado de 'California' o 'Nevada'.*/
SELECT * 
FROM inc_5000_us
WHERE state_l = 'California' OR state_l = 'Nevada';

-- 4 ----------------------------------------------------
/*Muestra las abreviaturas de dos letras distintas de los estados involucrados en empresas
cuyos rangos se encuentran entre 1 y 5.*/
SELECT state_s
FROM inc_5000_us
WHERE rank BETWEEN 1 AND 5;

-- 5 ----------------------------------------------------
-- Creamos la tabla
CREATE TABLE [dbo].[2022test_inc_5000_us](
	[input] [nvarchar](1) NULL,
	[num] [nvarchar](50) NOT NULL,
	[widgetName] [nvarchar](50) NOT NULL,
	[source] [nvarchar](50) NOT NULL,
	[resultNumber] [int] NOT NULL,
	[pageUrl] [nvarchar](100) NOT NULL,
	[id] [int] NOT NULL,
	[rank] [int] NOT NULL,
	[workers] [float] NOT NULL,
	[company] [nvarchar](100) NOT NULL,
	[url] [nvarchar](100) NOT NULL,
	[state_l] [nvarchar](50) NOT NULL,
	[state_s] [nvarchar](50) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[metro] [nvarchar](50) NULL,
	[growth] [float] NOT NULL,
	[revenue] [float] NOT NULL,
	[industry] [nvarchar](50) NOT NULL,
	[yrs_on_list] [int] NOT NULL
)

-- Insertamos los 20 primeros de la otra tabla
INSERT INTO [dbo].[2022test_inc_5000_us]
           ([input]
           ,[num]
           ,[widgetName]
           ,[source]
           ,[resultNumber]
           ,[pageUrl]
           ,[id]
           ,[rank]
           ,[workers]
           ,[company]
           ,[url]
           ,[state_l]
           ,[state_s]
           ,[city]
           ,[metro]
           ,[growth]
           ,[revenue]
           ,[industry]
           ,[yrs_on_list])
  
          (SELECT TOP 20 * FROM inc_5000_us);

-- Comparamos las tablas.
SELECT a.*
FROM inc_5000_us AS a
JOIN [2022test_inc_5000_us] AS b
ON a.company = b.company;



-- 6 ----------------------------------------------------
SELECT *
FROM inc_5000_us
WHERE company IN (SELECT company FROM [2022test_inc_5000_us])

-- 7 ----------------------------------------------------
with t1 as (select top (5) url, company 
from inc_5000_us)

select *, extra_columna = 1
from t1;