/*1. Devuelve los distintos valores de la columna Weight que se encuentren comprendidos entre 400 y 450*/
SELECT Weight
FROM Production.Product
where Weight between 400 and 450;

/*2. Comprueba si la columna Weight puede contener NULLs. En caso afirmativo, haz un
recuento de valores no NULL y NULL. Guarda el valor en la columna “n_records” y calcula
también el porcentaje que representa respecto al total de filas de la tabla en “pct_records”*/
SELECT 
    COUNT(weight) AS n_records,
	CONCAT(FORMAT((COUNT(Weight) * 100.0) / COUNT(*), 'N2'), '%') AS pct_records
FROM 
    Production.Product
union
SELECT 
    COUNT(CASE WHEN Weight IS NULL THEN 1 END) AS n_records,
    CONCAT(FORMAT((COUNT(CASE WHEN Weight IS NULL THEN 1 END) * 100.0) / COUNT(*), 'N2'), '%') AS pct_records
FROM 
    Production.Product


/* 3. Devuelve los distintos valores de la columna Weight que se encuentren comprendidos entre
400 y 450 excepto el valor 435.00 */
SELECT Weight
FROM Production.Product
where Weight between 400 and 450 and Weight <> 435.00;


/* 4. Inserta una columna “new_minimum” que tome el valor Weight siempre que su valor sea
mayor a 10. En caso contrario, que tome el valor 10. Comprueba que “new_minimum” toma
el valor esperado para los 10 valores más pequeños de Weight devolviendo ambas
columnas. Evita duplicados: */
SELECT 
  DISTINCT TOP 10 weight, 
  CASE WHEN weight > 10 THEN weight else 10 END AS new_minimun 
FROM 
  production.product 
where 
  weight is not null 
order by 
  weight

/* 5. De forma similar, ahora calcula una columna “new_min_max” que tome el valor Weight
siempre que su valor esté comprendido entre 10 y 900. En caso contrario, que tome el valor
más cercano a los extremos {10, 900}. Comprueba tu solución: */
SELECT 
  DISTINCT Weight, 
  CASE WHEN Weight <= 10 
  OR Weight IS NULL THEN 10.00 WHEN Weight >= 900 THEN 900.00 ELSE Weight END AS new_min_max 
FROM 
  Production.Product 
ORDER BY 
  Weight

/* Crea una columna tag_format que tome el valor 1 cuando el string de ProductNumber
contenga un guión y 0 en caso contrario. Filtra instancias que sólo tengan valores de Class
‘L’ o ‘M’ y haz un conteo de filas. Comprueba tu solución: */
SELECT 
  CASE WHEN productnumber LIKE '%-%' THEN 1 ELSE 0 END AS tag_format, 
  Count(*) n_records 
FROM 
  production.product 
where 
  class = 'L' 
  or class = 'M' 
GROUP BY 
  CASE WHEN productnumber LIKE '%-%' THEN 1 ELSE 0 END