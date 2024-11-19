-- Ejercicio 1

--a. Obtén una lista de los primeros 10 productos, mostrando su ProductID, Name y ListPrice.

SELECT TOP 10 
	ProductID, Name, ListPrice
FROM Production.Product

--b. Obtén una lista de todos los empleados que trabajan en el departamento 'Sales', mostrando su BusinessEntityID, JobTitle y HireDate.

SELECT HE.BusinessEntityID, JobTitle, HireDate
FROM HumanResources.Employee HE
JOIN HumanResources.EmployeeDepartmentHistory HED
ON HE.BusinessEntityID = HED.BusinessEntityID
JOIN HumanResources.Department HD
ON HED.DepartmentID = HD.DepartmentID
WHERE HD.Name = 'Sales'

--c. Calcula el precio medio de lista (ListPrice) de todos los productos.

SELECT
	ProductID,
	AVG(ListPrice) AS AVG_LISTPRICE
FROM Production.Product
GROUP BY ProductID;

--d. Obtén una lista de los productos cuyo ListPrice es superior al precio medio de todos los productos.
WITH AVG_TABLE AS (
	SELECT
		AVG(ListPrice) AS AVG_LISTPRICE
	FROM Production.Product
)

SELECT * 
FROM Production.Product, AVG_TABLE
WHERE ListPrice > AVG_LISTPRICE;


--e. De todos los productos, muestra su ProductID, Name, ListPrice 
-- y un nuevo campo que indique si está por encima “ENCIMA” o por debajo de la media “DEBAJO”

SELECT 
	ProductID, 
	Name, 
	ListPrice,
	CASE	
		WHEN ListPrice > (SELECT AVG(ListPrice) FROM Production.Product) THEN 'ENCIMA' 
		ELSE 'DEBAJO'
	END AS NUEVO_CAMPO
FROM Production.Product;

--f. De todos los productos, muestra su ProductID, Name, ListPrice y su talla estandarizada. 
--	Algunas tallas vienen con letra (‘S’,’L’,...) y otras con número (‘40’,’48’). Por lo que vamos a estandarizar los números a las letras.
--	Las tallas válidas serán ‘S’,’M’,’L’,’XL’
--	Como hay 4 tallas, dividiremos los números en cuatro cuartiles, y asignaremos la pertenencia a cada cuartil con una de las cuatro letras
--	Las tallas nulas o no válidas se mostrarán como ‘Sin talla’

WITH Quartiles AS (
    SELECT 
        NTILE(4) OVER (ORDER BY CAST(Size AS INT)) AS Cuartil,
        ProductID,
        Name,
        ListPrice,
        Size
    FROM Production.Product
    WHERE ISNUMERIC(Size) = 1
),
StandardizedSizes AS (
    SELECT 
        ProductID, 
        Name, 
        ListPrice,
        Size,
        CASE
            WHEN Size IS NULL THEN 'SIN TALLA'
            WHEN ISNUMERIC(Size) = 0 THEN 'SIN TALLA'
            WHEN Cuartil = 1 THEN 'S'
            WHEN Cuartil = 2 THEN 'M'
            WHEN Cuartil = 3 THEN 'L'
            WHEN Cuartil = 4 THEN 'XL'
        END AS Standard_Size
    FROM Quartiles
    UNION ALL
    SELECT 
        ProductID,
        Name,
        ListPrice,
        Size,
        'SIN TALLA' AS Standard_Size
    FROM Production.Product
    WHERE Size IS NULL OR ISNUMERIC(Size) = 0
)
SELECT ProductID, Name, ListPrice, Standard_Size
FROM StandardizedSizes;


--g. Muestra todas las tallas estandarizadas del anterior ejercicio para las que al menos hay un producto por debajo y por encima de la media.

WITH AvgPrice AS (
    SELECT AVG(ListPrice) AS Avg_ListPrice
    FROM Production.Product
),
StandardizedSizes AS (
    SELECT 
        ProductID, 
        Name, 
        ListPrice,
        CASE
            WHEN Size IS NULL THEN 'SIN TALLA'
            WHEN ISNUMERIC(Size) = 0 THEN 'SIN TALLA'
            WHEN NTILE(4) OVER (ORDER BY CAST(Size AS INT)) = 1 THEN 'S'
            WHEN NTILE(4) OVER (ORDER BY CAST(Size AS INT)) = 2 THEN 'M'
            WHEN NTILE(4) OVER (ORDER BY CAST(Size AS INT)) = 3 THEN 'L'
            WHEN NTILE(4) OVER (ORDER BY CAST(Size AS INT)) = 4 THEN 'XL'
        END AS Standard_Size
    FROM Production.Product
    WHERE ISNUMERIC(Size) = 1
    UNION ALL
    SELECT 
        ProductID,
        Name,
        ListPrice,
        'SIN TALLA' AS Standard_Size
    FROM Production.Product
    WHERE Size IS NULL OR ISNUMERIC(Size) = 0
),
ProductStats AS (
    SELECT 
        Standard_Size,
        CASE
            WHEN ListPrice > (SELECT Avg_ListPrice FROM AvgPrice) THEN 'ENCIMA'
            ELSE 'DEBAJO'
        END AS Precio_Relativo
    FROM StandardizedSizes
)
SELECT DISTINCT Standard_Size
FROM ProductStats
WHERE Precio_Relativo = 'ENCIMA'
  AND Standard_Size IN (
      SELECT Standard_Size
      FROM ProductStats
      WHERE Precio_Relativo = 'DEBAJO'
  );

--Ejercicio 2
--a. Saca un listado de personas que no sean empleados y su número de teléfono (siempre que sea posible).

SELECT FirstName, LastName, PPH.PhoneNumber
FROM Person.Person PP
JOIN Person.PersonPhone PPH ON PP.BusinessEntityID = PPH.BusinessEntityID
WHERE PersonType NOT LIKE '%EM%'


--b. De la tabla de personas, queremos saber el porcentaje que tiene cada letra de ser la inicial del nombre. 
-- (P.E. Si hay 100 personas y 2 comienzan con la A, el porcentaje de A es 2%) 

SELECT 
	SUBSTRING(FirstName,1,1) AS 'LETRA',
	COUNT(SUBSTRING(FirstName,1,1)) * 100.0 / (SELECT COUNT(*) FROM Person.Person) AS 'PORCENTAJE'
FROM Person.Person
GROUP BY SUBSTRING(FirstName,1,1)
ORDER BY SUBSTRING(FirstName,1,1);

SELECT 
    LEFT(FirstName, 1) AS Inicial,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Person.Person) AS Porcentaje
FROM Person.Person
GROUP BY LEFT(FirstName, 1)
ORDER BY Inicial;


--c. De la tabla de Empleados, para cada año, queremos saber el top de edades contratadas. En caso de empate entrará en el top la edad más alta.
-- Es decir, imaginemos que en 2007 se contrataron 5 personas: 26,25,26,50,30,30. El Top sería
--	2007 - 1º -> 30 (2 personas)
--	2007- 2º -> 26 (2 personas)
--	2007- 3º -> 50 (1 persona)

with edad as (
	SELECT 
		YEAR(HireDate) año_contratacion,
		DATEDIFF(YEAR,BirthDate, HireDate) AS edad_en_contratacion
	FROM HumanResources.Employee
),
EdadesPorAñoRankeadas AS(
	SELECT 
		ed.año_contratacion,
		ed.edad_en_contratacion,
		COUNT(*) num,
		RANK() OVER(PARTITION BY ed.año_contratacion ORDER BY COUNT(*) DESC, ed.edad_en_contratacion DESC) ranking
	FROM edad ed
	GROUP BY ed.año_contratacion, ed.edad_en_contratacion
)

SELECT epar.año_contratacion,
	epar.ranking,
	MAX(epar.edad_en_contratacion) Edad
FROM EdadesPorAñoRankeadas epar
WHERE epar.ranking <= 3
GROUP BY epar.año_contratacion, epar.ranking
ORDER BY epar.año_contratacion, epar.ranking;


WITH EmpleadosConEdad AS (
    SELECT 
        YEAR(HireDate) AS Anio_Contratacion,
        YEAR(HireDate) - YEAR(BirthDate) AS Edad
    FROM HumanResources.Employee
),
EdadRanking AS (
    SELECT 
        Anio_Contratacion,
        Edad,
        COUNT(*) AS Cantidad,
        RANK() OVER (
            PARTITION BY Anio_Contratacion
            ORDER BY COUNT(*) DESC, Edad DESC
        ) AS Rango
    FROM EmpleadosConEdad
    GROUP BY Anio_Contratacion, Edad
)
SELECT Anio_Contratacion, Edad, Cantidad
FROM EdadRanking
WHERE Rango <= 3
ORDER BY Anio_Contratacion, Rango;



