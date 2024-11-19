-- 1
SELECT
    state_l,
    state_s
FROM
    inc_5000_us
WHERE
    rank BETWEEN 1
    AND 5
GROUP BY
    state_l,
    state_s;

-- 2
SELECT
    company
FROM
    inc_5000_us
ORDER BY
    company DESC;

-- 3 
/*Recupera la columna de la empresa (company) y la columna de trabajadores (workers) para
 las principales 100 empresas basadas en el n�mero de trabajadores. Si dos empresas tienen
 el mismo n�mero de trabajadores, queremos resolver la ambig�edad ordenando por el
 nombre de la empresa en orden ascendente.*/
SELECT
    TOP(100) company,
    workers
FROM
    inc_5000_us
ORDER BY
    workers,
    company;

-- 4
SELECT
    TOP 10 industry,
    COUNT(company) num_cmp
FROM
    inc_5000_us
WHERE
    workers >= 10
GROUP BY
    industry
ORDER BY
    industry DESC;

SELECT
    industry,
    city,
    SUM(revenue) sum_revenue
FROM
    inc_5000_us
GROUP BY
    industry,
    city
ORDER BY
    industry DESC,
    city DESC;