--BLOQUE 1 
-- EJERCICIO 1

SELECT Weight
FROM Production.Product
WHERE Weight BETWEEN 400 AND 450;

--EJERCICIO 2
with t1 as (
	SELECT 
		CASE
			WHEN Weight IS NULL THEN 'NULL'
			WHEN Weight IS NOT NULL THEN 'NOT NULL'
		END AS type_data
	FROM Production.Product
)

SELECT 
	type_data, COUNT(*) AS n_records
FROM t1
GROUP BY type_data;

--EJERCICIO 3
SELECT Weight
FROM Production.Product
WHERE Weight BETWEEN 400 AND 450 AND Weight <> 435.00;

--EJERCICIO 4
SELECT 
	DISTINCT Weight,
	CASE
		WHEN Weight < 10 THEN 10.00
		ELSE Weight
	END	AS new_minimum
FROM 
	Production.Product;

--EJERCICIO 5
SELECT 
	DISTINCT Weight,
	CASE
		WHEN Weight > 10 AND Weight < 900 THEN Weight
		WHEN Weight < 10 THEN 10.00
		WHEN Weight > 900 THEN 900.00
	END	AS new_min_max
FROM 
	Production.Product;

--EJERCICIO 6
WITH t1 AS (
	SELECT 
	CASE 
		WHEN ProductNumber LIKE '%-%' THEN 1
		ELSE 0 
	END AS tag_format
	FROM Production.Product
	WHERE Class LIKE '%L%' OR Class LIKE '%M%'
)

SELECT 
	tag_format,
	COUNT(*) AS n_records
FROM t1
GROUP BY tag_format;

-- BLOQUE II
--EJERCICIO 1
WITH cast_table AS (
	SELECT 
		TRY_CAST(Size AS FLOAT) AS float_size,
		TRY_CAST(Size AS INT) AS int_size
	FROM 
		Production.Product
)

SELECT 
	CASE
		WHEN float_size = int_size THEN 'Same Result'
		ELSE 'Different Result'
	END AS 'tag',
	COUNT(*) AS 'n_records'
FROM 
	cast_table
GROUP BY 
	CASE
		WHEN float_size = int_size THEN 'Same Result'
		ELSE 'Different Result'
	END;

--EJERCICIO 2
-- ES PORQUE ES NULL.

--EJERCICIO 3
SELECT 
  COLUMN_NAME, 
  DATA_TYPE 
FROM 
  INFORMATION_SCHEMA.COLUMNS 
WHERE 
  TABLE_NAME = 'Product'

-- EJERCICIO 4
SELECT 
	CASE 
		WHEN ROUND(StandardCost,2) =  StandardCost THEN 1 
		ELSE 0
	END AS 'StandardCost_test',
	COUNT(*) AS 'n_records',
	COUNT(DISTINCT StandardCost) AS 'n_distinct_values'
FROM Production.Product
GROUP BY CASE 
		WHEN ROUND(StandardCost,2) =  StandardCost THEN 1 
		ELSE 0
	END;

--EJERCICIO 5
WITH t1 as (
	SELECT 
		CASE
			WHEN ROUND(StandardCost,2) =  StandardCost THEN 1 
			ELSE 0
		END AS 'StandardCost_test',
		StandardCost
	FROM Production.Product
)

SELECT
	StandardCost_test,
	StandardCost
FROM t1
WHERE StandardCost_test = 1
GROUP BY 
	StandardCost_test,
	StandardCost;

--EJERCICIO 6
SELECT 
	SIGN(StandardCost) SIGN_SC,
	SIGN(StandardCost -100) SIGN_SCM,
	COUNT(SIGN(StandardCost)) N_RECORDS
FROM 
	Production.Product
GROUP BY SIGN(StandardCost),
	SIGN(StandardCost -100);

--BLOQUE 3
--EJERCICIO 1
SELECT 
	Size,
	Weight,
	('SIZE: '+ COALESCE(Size,'NULL') + '-WEIGHT: ' + COALESCE(CAST(Weight AS NVARCHAR),'NULL')) AS CUSTOM_DIM 
FROM 
	Production.Product;

--EJERCICIO 2
SELECT 
	ProductID,
	ProductNumber,
	VALUE AS 'ELEMENTO',
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY ProductID) AS 'Ordinal'
FROM 
	Production.Product
	CROSS APPLY STRING_SPLIT(ProductNumber, '-');