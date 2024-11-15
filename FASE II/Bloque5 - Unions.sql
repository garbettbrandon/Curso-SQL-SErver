/*Usaremos nuevamente las tablas de Bloque 1. La tabla inc_5000_us se basa en el año 2014
mientras que 2022test_inc_5000_us se basa en 2022 (no es real).


1. Recupera las columnas rank, workers, company, state_l para las 5 empresas mejor
clasificadas (rango entre 1 y 5) de ambas tablas. Para distinguir los resultados entre una
tabla y otra, agrega una columna adicional que tome el valor 'inc_5000_us' o
2022test_inc_5000_us dependiendo de si el registro proviene de la tabla inc_5000_us o
2022test_inc_5000_us. El nombre de esta columna es source_table. Ordena los resultados
por source_table y rank.*/

SELECT rank, workers, company, state_l, 'inc_5000_us' as source_table
FROM inc_5000_us
WHERE rank BETWEEN 1 AND 5
UNION ALL 
SELECT rank, workers, company, state_l, '2022test_inc_5000_us' as source_table
FROM [2022test_inc_5000_us]
WHERE rank BETWEEN 1 AND 5
ORDER BY source_table, ranK

-- 2 --------------------------------------------------------------------------------
/*Muestra el nombre de la empresa y la URL de las empresas de inc_5000_us que también
aparecen en el conjunto de datos de 2022test_inc_5000_us y para las cuales tanto el
nombre de la empresa como la URL se han mantenido iguales.*/

SELECT company, url
FROM inc_5000_us
INTERSECT
SELECT company, url
FROM [2022test_inc_5000_us];


-- 3 -----------------------------------------------------------------------------------
/* Devuelve el nombre de la empresa y la URL de las empresas de inc_5000_us con un rango
entre 18 y 23 que no aparecieron en el conjunto de datos de 2022test_inc_5000_us con el
mismo nombre de empresa y URL (con ningún rango) .*/

SELECT company, url
FROM inc_5000_us
WHERE rank BETWEEN 18 AND 23
INTERSECT
SELECT company, url
FROM inc_5000_us;
