-- Ejercicio 1
with t1 as (
  select 
    try_cast(Size as float) as float_size, 
    try_cast(Size as int) as int_size, 
    case when try_cast(Size as float) = try_cast(Size as int) then 'Same Result' else 'Different Result' end as tag 
  from 
    Production.Product
) 
select 
  tag, 
  count(*) 
from 
  t1 
group by 
  tag;


--Ejercicio 2
/* Comprueba cuáles son las instancias para las cuales tag=’Different Result’. Razona el motivo
por el cual la comparación no devuelve “True” en esos casos..*/

--Son las instancias que están en null. No devuelve true porque el case when los numeros son iguales no se cumple.

-- Ejercicio 3 
/* 3. Encuentra una manera de obtener el tipo de dato para cada columna de la tabla a través de
una consulta SQL.*/

SELECT 
  COLUMN_NAME, 
  DATA_TYPE 
FROM 
  INFORMATION_SCHEMA.COLUMNS 
WHERE 
  TABLE_NAME = 'Product'


-- Ejercicio 4
/* 4. Crea una columna binaria StandardCost_test que toma el valor 1 cuando el valor de
StandardCost coincide con su valor redondeado a 2 cifras decimales y 0 en caso
contrario.Calcula la frecuencia de cada posibilidad en n_records. Calcula el número de
valores distintos de StandardCost involucrados en cada salida del test y guárdalo en la
columna n_distint_sc_values. Comprueba tus resultados:*/

with tablaBinaria as (
  select 
    case when StandardCost = round(StandardCost, 2) then 1 else 0 end as StandardCost_test, 
    StandardCost 
  from 
    Production.Product
) 
select 
  StandardCost_test, 
  count(*) n_records, 
  count(distinct StandardCost) as n_distint_sc_values 
from 
  tablaBinaria 
group by 
  StandardCost_test;

-- Ejercicio 5 
with binary_table as(
  select 
    case when StandardCost = round(StandardCost, 2) then 1 else 0 end as StandardCost_test, 
    StandardCost 
  from 
    Production.Product
) 

select StandardCost_test, StandardCost
from binary_table
where StandardCost_test = 1
group by StandardCost, StandardCost_test;

-- Ejercicio 6
WITH t1 AS (
    SELECT
        StandardCost,
        StandardCost - 100  as StandardCost_modified
    FROM 
        Production.Product
), t2 AS (
    SELECT 
        CASE
            WHEN StandardCost < 0 THEN -1
            WHEN StandardCost = 0 THEN 0
            ELSE 1
        END AS sign_sc,
        CASE
            WHEN StandardCost_modified < 0 THEN -1
            WHEN StandardCost_modified = 0 THEN 0
            ELSE 1
        END AS sign_scm
    FROM 
        t1    
)

SELECT sign_sc, sign_scm, COUNT(*) 
FROM t2
GROUP BY sign_sc, sign_scm;

-- Respuesta alternativa
WITH StandardCost_modified AS (
    SELECT StandardCost,
        SIGN(StandardCost - 100) AS 'sign_scm',
        SIGN(StandardCost) AS 'sign_sc'
    FROM Production.Product
)
SELECT sign_sc,    sign_scm,
    COUNT(*) AS 'n_records'
FROM StandardCost_modified
GROUP BY sign_sc, sign_scm