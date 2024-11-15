/*HAVING debe ser insertado entre las cláusulas GROUP BY y ORDER BY. Además, HAVING es
similar a WHERE pero puede aplicarse al bloque GROUP BY.

1. Ve al ejercicio B3.4.a y modifica la consulta de modo que solo se recuperen las industrias con
n_companies igual al número 202.*/

SELECT TOP 10 industry, COUNT(company) num_cmp
FROM inc_5000_us
WHERE workers >= 10
GROUP BY industry
HAVING COUNT(company) = 202
ORDER BY industry DESC;

/* Proporciona una segunda solución al ejercicio utilizando
solo cláusulas WHERE (recuerda utilizar WITH).*/

WITH t1 AS(	SELECT TOP 10 industry, COUNT(company) AS n_companies 
			FROM inc_5000_us 
			WHERE workers>=10 
			GROUP BY industry 
			ORDER BY industry DESC)

SELECT * FROM t1 WHERE n_companies=202

/* ----------------------------------------------------------------------------------------
2. Ve al ejercicio B3.4.b y modifica la consulta para que solo se obtengan las ciudades que
verifiquen la condición sum_revenue > 100000000.*/

SELECT industry, city, SUM(revenue) sum_revenue
FROM inc_5000_us
GROUP BY industry, city
HAVING SUM(revenue) > 100000000
ORDER BY industry DESC, city DESC;

/* Proporciona una segunda solución al
ejercicio utilizando solo cláusulas WHERE (recuerda utilizar WITH).*/

WITH t1 AS (SELECT industry, city, SUM(revenue) sum_revenue
			FROM inc_5000_us
			GROUP BY industry, city)
SELECT * 
FROM t1 
WHERE sum_revenue > 100000000