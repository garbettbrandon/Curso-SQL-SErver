-- 1 ----------------------------------------------------
SELECT
  *
FROM
  [SQL_Training].[dbo].[inc_5000_us]
WHERE
  company = 'Nordic'
  
  
 -- 2 ----------------------------------------------------
SELECT
  TOP (10) company,
  growth,
  revenue,
  industry,
  NEWID()
FROM
  inc_5000_us
ORDER BY
  NEWID();

-- 3 ----------------------------------------------------
/*Recupera todos los registros para los cuales la empresa se encuentra en el estado de 'California' o 'Nevada'.*/
SELECT
  *
FROM
  inc_5000_us
WHERE
  state_l = 'California'
  OR state_l = 'Nevada';

-- 4 ----------------------------------------------------
/*Muestra las abreviaturas de dos letras distintas de los estados involucrados en empresas
 cuyos rangos se encuentran entre 1 y 5.*/
SELECT
  state_s
FROM
  inc_5000_us
WHERE
  rank BETWEEN 1
  AND 5;

-- 5 ----------------------------------------------------
-- Creamos la tabla
SELECT
  TOP 20 * INTO [2022test_inc_5000_us]
FROM
  [inc_5000_us];

-- Comparamos las tablas.
SELECT
  a.*
FROM
  inc_5000_us AS a
  JOIN [2022test_inc_5000_us] AS b ON a.company = b.company;

-- 6 ----------------------------------------------------
SELECT
  *
FROM
  inc_5000_us
WHERE
  company IN (
    SELECT
      company
    FROM
      [2022test_inc_5000_us]
  ) 
  
-- 7 ----------------------------------------------------
  with t1 as (
    select
      top (5) url,
      company
    from
      inc_5000_us
  )
select
  *,
  extra_columna = 1
from
  t1;