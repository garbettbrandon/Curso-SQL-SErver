-- Ejercicio 1

with industry_avg as (
	select industry, avg(yrs_on_list) as avg_yers_on_list_by_ind
	from inc_5000_us
	group by industry
	)

select 
	resultNumber,
	company,
	yrs_on_list,
	t1.industry, 
	avg_yers_on_list_by_ind
from inc_5000_us t1
join industry_avg t2
on t1.industry = t2.industry
group by resultNumber,
	company,
	yrs_on_list,
	t1.industry, 
	avg_yers_on_list_by_ind;

-- Respuesta con partition by 
select 
	distinct resultNumber,
	company,
	yrs_on_list,
	industry,
	avg(yrs_on_list) over(partition by industry) as avg_yers_on_list_by_ind
from inc_5000_us;

/* 2. También queremos ver para cada empresa el porcentaje de cuánta competencia tiene. Esta
competencia la calcularemos como la suma de las empresas en la misma ciudad y
pertenecientes a la misma industria, sin contarse a sí misma.*/
select 
	distinct resultNumber, company, city, industry,
	(count(company) over(partition by city, industry)-1) as competence
from inc_5000_us;

/*3. Para cada identificador SalesOrderID calcula los 3 cuartiles en candidad de pedidos, es decir
es OrderQty. Comprueba los resultados para los primeros SalesOrderID:*/
WITH Cuartiles AS (
    SELECT 
        SalesOrderID,
        OrderQty,
        PERCENTILE_disc(0.25) WITHIN GROUP (ORDER BY OrderQty) OVER (PARTITION BY SalesOrderID) AS Q1_SalesOrderId,
        PERCENTILE_disc(0.50) WITHIN GROUP (ORDER BY OrderQty) OVER (PARTITION BY SalesOrderID) AS Median_SalesOrderId,
		PERCENTILE_disc(0.75) WITHIN GROUP (ORDER BY OrderQty) OVER (PARTITION BY SalesOrderID) AS Q3_SalesOrderId,
		AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS avg_SalesOrderId
    FROM Sales.SalesOrderDetail
)

SELECT top 10
    SalesOrderID,
    Q1_SalesOrderId,
    Median_SalesOrderId,
    Q3_SalesOrderId
FROM Cuartiles
GROUP BY SalesOrderID, Q1_SalesOrderId, Median_SalesOrderId, Q3_SalesOrderId
ORDER BY SalesOrderID;

/* 4. Añade además la media para cada grupo de SalesOrderID. Después muestra en pantalla las
instancias para las cuales la media y la mediana difieren.*/

WITH Cuartiles AS (
    SELECT 
        SalesOrderID,
        OrderQty,
        PERCENTILE_disc(0.25) WITHIN GROUP (ORDER BY OrderQty) OVER (PARTITION BY SalesOrderID) AS Q1_SalesOrderId,
        PERCENTILE_disc(0.50) WITHIN GROUP (ORDER BY OrderQty) OVER (PARTITION BY SalesOrderID) AS Median_SalesOrderId,
		PERCENTILE_disc(0.75) WITHIN GROUP (ORDER BY OrderQty) OVER (PARTITION BY SalesOrderID) AS Q3_SalesOrderId,
		AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS avg_SalesOrderId
    FROM Sales.SalesOrderDetail
)
SELECT top 10 
    SalesOrderID,
    avg_SalesOrderId, 
    Median_SalesOrderId
FROM Cuartiles
WHERE avg_SalesOrderId != Median_SalesOrderId
GROUP BY SalesOrderID, avg_SalesOrderId, Median_SalesOrderId
ORDER BY SalesOrderID;

-- Lore
WITH AvgMedian AS (
    SELECT SalesOrderID,
           AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS avg_SalesOrderId,
           PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY OrderQty) OVER (PARTITION BY SalesOrderID) AS median_SalesOrderId
    FROM Sales.SalesOrderDetail
)
SELECT DISTINCT TOP 10 SalesOrderID, avg_SalesOrderId, median_SalesOrderId
FROM AvgMedian
WHERE avg_SalesOrderId != median_SalesOrderId
ORDER BY SalesOrderID;


/*5. Cada región identificada por TerritoryID tiene asociada su CountryRegionCode. Determina el
orden de cada territorio según el valor de SalesYTD para el país donde se encuentra. El
territorio con mayor SalesYTD se llevará el orden 1, el segundo territorio con mayor
SalesYTD el orden 2 (si lo hay), y así sucesivamente. Guarda este valor en la columna
“rank_sales_byCountry”*/

select TerritoryID, CountryRegionCode, SalesYTD,
	RANK() OVER (PARTITION BY CountryRegionCode ORDER BY SalesYTD DESC) AS rank_sales_byCountry
from Sales.SalesTerritory;


/*6. Para cada día (de la columna OrderDate) que pertenece al año 2012, calcula el número de
ventas distintas que se han realizado y guarda el resultado en la columna n_sales_orders.*/

with table2012 as (
	select OrderDate, SalesOrderID
	from sales.SalesOrderHeader
	where convert(date,OrderDate) between '2012-01-01' and '2012-12-31'
)

select top 10 
	OrderDate, 
	count(SalesOrderID) as n_sales_orders
from 
	table2012
group by OrderDate
order by OrderDate;

/* 7. Para cada día (de la columna OrderDate) que pertenece al año 2012, calcula también la
columna previous_n_sales_orders que corresponde al valor de n_sales_order para el día
inmediatamente anterior. Ordena los resultados por OrderDate y muestra los primeros 10.
Comprueba que para el primer día del año también obtienes el resultado esperado.*/

/*8. Calcula la diferencia entre el valor del día actual y el anterior. Guarda el resultado en una
columna llamada diff_sales.*/

with table2012 as (
	select OrderDate, SalesOrderID
	from sales.SalesOrderHeader
	where convert(date,OrderDate) between '2012-01-01' and '2012-12-31'
)

select top 10
	OrderDate, 
	count(SalesOrderID) as n_sales_orders,
	lag(count(SalesOrderID),1,7) over(order by OrderDate) as previus_n_sales_orders,
	(count(SalesOrderID)) - (lag(count(SalesOrderID),1,7) over(order by OrderDate)) as diff_sales
from 
	table2012
group by OrderDate
order by OrderDate;


/* 9. ¿Cuánto aumento o decrecimiento supone la diferencia entre ventas con respecto al día
anterior? Calcula el porcentaje de aumento en la columna boost_pct (de tipo numérico). Si el
valor de n_sales_orders es hoy 4 y ayer fue 2 entonces el porcentaje de aumento que
buscamos será 100% y el valor de boost_pct será 100.*/

WITH t1 AS (
    SELECT
        TOP 10
        OrderDate,
        COUNT(*) AS n_sales_orders,
        LAG(COUNT(*), 1, 7) OVER (ORDER BY OrderDate) AS previous_n_sales_orders
    FROM
        Sales.SalesOrderHeader
    WHERE
        CAST(OrderDate AS DATE) BETWEEN '2012-01-01' AND '2012-12-31'
    GROUP BY
        OrderDate
    ORDER BY
        OrderDate
)

SELECT
    OrderDate,
    n_sales_orders,
    previous_n_sales_orders,
    n_sales_orders - previous_n_sales_orders AS diff_sales,
	CAST(((n_sales_orders - previous_n_sales_orders) * 100.0) / previous_n_sales_orders AS INT) AS boost_pct
FROM
    t1;