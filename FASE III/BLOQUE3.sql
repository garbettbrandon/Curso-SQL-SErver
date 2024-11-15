/* 1. Calcula una columna “custom_dim” customizada teniendo en cuenta los valores de Size y
Weight. Cuando el valor de cualquiera de ellas sea NULL, rellena por el valor string ‘Null’ de
manera que obtengas resultados como los siguientes:*/

select 
	size, 
	weight,
	('Size:'+COALESCE(size, 'NULL')+'-Weight:'+COALESCE(CAST(weight AS VARCHAR),'NULL')) as custom_dim
from Production.Product;


--EJERCICIO 2
SELECT
    p.ProductID,
    p.ProductNumber,
    s_prod.value AS Elemento,
    ROW_NUMBER() OVER (PARTITION BY p.ProductID ORDER BY  p.ProductID) AS Ordinal
FROM
    Production.Product p
CROSS APPLY
    STRING_SPLIT(p.ProductNumber, '-') s_prod;

-- a. ¿Ha sido esto posible siempre, es decir, para todos los ProductNumber?
-- Si, ha sido posible en todos los casos ya que no hay ProductNumber que no contengan por lo menos un guion.

/*3. Comprueba que todos los valores de ProductNumber comienzan por dos Letras de A a Z
seguidos de guión.*/

select COUNT(ProductNumber) AS 'Comparison of Rows'
from Production.Product
where ProductNumber like '[A-Z][A-Z]-%'

UNION ALL

select COUNT(ProductNumber)
from Production.Product

-- De esta forma podemos comprobar que dan el mismo resultado.

/* 4. Muestra en pantalla ejemplos de ProductNumber para los cuales la segunda letra va de E a Z
en lugar de A a Z. Ejemplos:*/

select ProductNumber
from Production.Product
where ProductNumber like '[A-Z][E-Z]-%'

/* 5. Filtra las instancias del ejercicio 2 que verifiquen Ordinal igual a 1. Después comprueba que
la columna Elemento siempre coincide con el substring de ProductNumber que comienza en
posición 1 y tiene una longitud de 2 caracteres. Llama a esta nueva columna first_element.
Aquí ejemplos de ambas:*/

WITH SplitString AS (
    SELECT ProductId, ProductNumber,
        value AS 'Elemento',
        ROW_NUMBER() OVER (PARTITION BY ProductId ORDER BY(ProductId)) AS 'Ordinal'
     FROM Production.Product
    CROSS APPLY
        STRING_SPLIT(ProductNumber, '-')
)
SELECT 
	ProductNumber,
	Elemento as elemento_ordinal_uno,
	SUBSTRING(ProductNumber, 1, 2) as first_element
FROM SplitString
where ordinal = 1

