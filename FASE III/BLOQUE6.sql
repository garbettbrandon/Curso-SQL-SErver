-- Ejercicio 1
/* Calcula la frecuencia absoluta y la frecuencia acumulada sobre los posibles valores de la
columna ListPrice. Primero redondea los valores a 0 decimales. Comprueba que obtienes 94
resultados y los primeros son:*/
select 
	round(ListPrice,0) as ListPrice,
	count(*) as freq,
	sum(count(*)) over(order by round(ListPrice,0)) as cum_freq
from Production.Product
group by round(ListPrice,0);

/*2. Añade a la tabla anterior la columna min_ListPrice y max_ListPrice que debe contener el
valor mínimo y máximo para cada “bucket” de ListPrice. Ordena en orden ascendente. Los
resultados deben estar alineados con:*/
select 
	round(ListPrice,0) as ListPrice,
	count(*) as freq,
	max(ListPrice) max_ListPrice,
	min(ListPrice) min_ListPrice,
	sum(count(*)) over(order by round(ListPrice,0)) as cum_freq
from Production.Product
group by round(ListPrice,0);

/* 3. Calcula la frecuencia absoluta como hiciste en el ejercicio 1 pero obviando todos los casos
en los que el Nombre del producto comience por el string ‘'Road-150 Red’ o por el string
‘Patch Kit/8 Patches’. Guarda el resultado en la columna freq_option2 y muestra las
instancias donde ambas difieren, es decir, donde freq es distinto de freq_option2:*/

select 
	round(ListPrice,0) as ListPrice,
	count(*) as freq
from Production.Product
where name not like 'Road-150 Red%' or name not like 'Patch Kit/8 Patches%'
group by round(ListPrice,0);

-- chatgpt
WITH Cum AS (
    SELECT 
        ROUND(ListPrice, 0) AS ListPrice,
        COUNT(*) AS freq
    FROM 
        Production.Product
    GROUP BY 
        ROUND(ListPrice, 0)
),
CumOption2 AS (
    SELECT 
        ROUND(ListPrice, 0) AS ListPrice,
        COUNT(*) AS freq_option2
    FROM 
        Production.Product
    WHERE 
        Name NOT LIKE 'Road-150 Red%' 
        AND Name NOT LIKE 'Patch Kit/8 Patches%'
    GROUP BY 
        ROUND(ListPrice, 0)
)

SELECT 
    c.ListPrice, 
    c.freq, 
    coalesce(co.freq_option2, 0) AS freq_option2
FROM 
    Cum c
left JOIN 
    CumOption2 co ON c.ListPrice = co.ListPrice
WHERE 
    c.freq <> coalesce(co.freq_option2, 0)
ORDER BY 
    c.ListPrice;

-- sergio
WITH t1 AS (
    SELECT 
        ROUND(ListPrice, 0) AS ListPrice,
        COUNT(*) AS freq,
        COUNT(CASE 
                WHEN Name NOT LIKE 'Road-150 Red%' 
                AND Name NOT LIKE 'Patch Kit/8 Patches%' 
                THEN 1 
             END) AS freq_option2
    FROM 
        Production.Product
    GROUP BY 
        ROUND(ListPrice, 0)
)

SELECT *
FROM t1
WHERE freq != freq_option2
ORDER BY ListPrice;

/* 4. Para cada bucket de precios de la columna ListPrice del ejercicio 1, añade 2 ejemplos de
nombres de producto en las columnas example_Name y example_Name2: */
select TOP 10
	ListPrice,
	COUNT(DISTINCT Name) n_distinct_pname
from Production.Product
GROUP BY ListPrice
ORDER BY n_distinct_pname DESC;

-- No he entendido que hay que hacer exactamente al añadir los ejemplos.

WITH t1 AS (
    SELECT 
        ROUND(ListPrice, 0) AS ListPrice,
        Name,
        ROW_NUMBER() OVER (PARTITION BY ListPrice ORDER BY Name) AS rn
    FROM Production.Product
)

SELECT top 10 
    ListPrice,
    COUNT(DISTINCT Name) AS n_distinc_pname,
    MAX(CASE WHEN rn = 1 THEN Name END) AS example_Name,  --> Uso max para devolver un unico valor
    MAX(CASE WHEN rn = 2 THEN Name END) AS example_Name2    --> Uso max para devolver un unico valor
FROM 
    t1
GROUP BY 
    ListPrice
HAVING
    COUNT(DISTINCT Name) >= 2
ORDER BY 
     n_distinc_pname DESC;