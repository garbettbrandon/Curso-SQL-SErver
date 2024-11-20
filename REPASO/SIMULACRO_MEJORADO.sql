use AdventureWorks;

--Ejercicio 1

--Obtén una lista de los primeros 10 productos, mostrando su ProductID, Name y ListPrice.

select top 10 
	ProductID, Name, ListPrice
from Production.Product;

--Obtén una lista de todos los empleados que trabajan en el departamento 'Sales', mostrando su BusinessEntityID, JobTitle y HireDate.

select he.BusinessEntityID, JobTitle, HireDate
from HumanResources.Employee he
join HumanResources.EmployeeDepartmentHistory hed on he.BusinessEntityID = hed.BusinessEntityID
join HumanResources.Department hd on hd.DepartmentID = hed.DepartmentID
where hd.Name = 'Sales';

--Calcula el precio medio de lista (ListPrice) de todos los productos.

select avg(ListPrice) as avg_listprice
from Production.Product;

--Obtén una lista de los productos cuyo ListPrice es superior al precio medio de todos los productos.

select *
from Production.Product
where ListPrice > (select avg(ListPrice) as avg_listprice from Production.Product);

--De todos los productos, muestra su ProductID, Name, ListPrice y un nuevo campo que indique si está por encima “ENCIMA” o por debajo de la media “DEBAJO”

select p.ProductID, p.Name, p.ListPrice,
	case
		when ListPrice > (select avg(ListPrice) as avg_listprice from Production.Product) then 'ENCIMA'
		else 'DEBAJO'
		end as posicion
from Production.Product p;


--De todos los productos, muestra su ProductID, Name, ListPrice y su talla estandarizada. Algunas tallas vienen con letra (‘S’,’L’,...) y otras con número (‘40’,’48’). Por lo que vamos a estandarizar los números a las letras.
--Las tallas válidas serán ‘S’,’M’,’L’,’XL’
--Como hay 4 tallas, dividiremos los números en cuatro cuartiles, y asignaremos la pertenencia a cada cuartil con una de las cuatro letras
--Las tallas nulas o no válidas se mostrarán como ‘Sin talla’

with Cuartiles as (
	select 
		ProductID, size, Name, ListPrice,
		NTILE(4) over( order by cast(size as int) ) as cuartil
	from Production.Product
	where isnumeric(Size) = 1
	),

StandardSizes as (
	select 
		ProductID, size, Name, ListPrice,
		case 
			when cuartil = 1 then 'S'
			when cuartil = 2 then 'M'
			when cuartil = 3 then 'L'
			when cuartil = 4 then 'XL'
		end as talla_estandarizada
	from Cuartiles
)

select 
	pp.ProductID, 
	pp.Name, 
	pp.ListPrice, 
	coalesce(talla_estandarizada, 'Sin talla') as talla_standarizada
from Production.Product pp 
left join StandardSizes ss 
on ss.ProductID = pp.ProductID;

--Muestra todas las tallas estandarizadas del anterior ejecicio para las que al menos hay un producto por debajo y por encima de la media.

with Cuartiles as (
	select 
		ProductID, size, Name, ListPrice,
		NTILE(4) over( order by cast(size as int) ) as cuartil
	from Production.Product
	where isnumeric(Size) = 1 AND Size IS NOT NULL
	),

StandardSizes as (
	select 
		ProductID, size, Name, ListPrice,
		case 
			when cuartil = 1 then 'S'
			when cuartil = 2 then 'M'
			when cuartil = 3 then 'L'
			when cuartil = 4 then 'XL'
		end as talla_estandarizada
	from Cuartiles
),

ProductosPorMedia AS (
    SELECT 
        talla_estandarizada,
        CASE 
            WHEN ss.ListPrice > (SELECT AVG(ListPrice) FROM Production.Product) THEN 'ENCIMA'
            WHEN ss.ListPrice < (SELECT AVG(ListPrice) FROM Production.Product) THEN 'DEBAJO'
        END AS Posicion
    FROM Production.Product pp
    JOIN StandardSizes ss ON pp.ProductID = ss.ProductID
)
SELECT talla_estandarizada
FROM ProductosPorMedia
WHERE Posicion = 'ENCIMA'
INTERSECT
SELECT talla_estandarizada
FROM ProductosPorMedia
WHERE Posicion = 'DEBAJO'

--Ejercicio 2
--Saca un listado de personas que no sean empleados y su número de teléfono (siempre que sea posible).

select pp.PhoneNumber, FirstName, LastName
from Person.Person p 
LEFT JOIN HumanResources.Employee e
ON e.BusinessEntityID = p.BusinessEntityID 
LEFT JOIN Person.PersonPhone pp
ON pp.BusinessEntityID = p.BusinessEntityID
WHERE e.BusinessEntityID IS NULL

--De la tabla de personas, queremos saber el porcentaje que tiene cada letra de ser la inicial del nombre. 
--(P.E. Si hay 100 personas y 2 comienzan con la A, el porcentaje de A es 2%) 

select 
	left(FirstName,1) letter,
	count(*) * 100.0 / (select count(*) from Person.person) as porcentaje
from Person.Person
group by left(FirstName,1)
order by letter;

--De la tabla de Empleados, para cada año, queremos saber el top de edades contratadas. 
--En caso de empate entrará en el top la edad más alta. Es decir, imaginemos que en 2007 se contrataron 5 personas: 26,25,26,50,30,30. El Top sería
--2007 - 1º -> 30 (2 personas)
--2007- 2º -> 26 (2 personas)
--2007- 3º -> 50 (1 persona)

with edad as (
	select 
		year(HireDate) año,
		DATEDIFF(year,BirthDate,HireDate) as edad_contratacion
	from HumanResources.Employee
),
edad_rank as (
	select 
		año,
		edad_contratacion,
		count(*) cantidad,
		RANK() over(partition by año ORDER BY COUNT(*) DESC, edad_contratacion DESC) as rango 
	from edad
	group by año, edad_contratacion
)

select año, edad_contratacion, cantidad, rango
from edad_rank
where rango <= 3
order by año, rango;