--Traer el FirstName y LastName de Person.Person cuando el FirstName sea Mark.
select FirstName, LastName
from Person.Person
where UPPER(FirstName) like '%MARK%'

-- ¿Cuántas filas hay dentro de Person.Person?
SELECT COUNT(*) FILAS
FROM Person.Person

-- Traer las 100 primeras filas de Production.Product donde el ListPrice no es 0
SELECT TOP 100 *
FROM Production.Product
WHERE ListPrice <> 0;

-- Traer todas las filas de de HumanResources.vEmployee donde los apellidos de los empleados empiecen con una letra inferior a “D”
SELECT * 
FROM HumanResources.vEmployee 
WHERE LastName LIKE '[A-Da-d]%'

-- ¿Cuál es el promedio de StandardCost para cada producto donde StandardCost es mayor a $0.00? (Production.Product)
SELECT Name,AVG(StandardCost) PROMEDIO
FROM Production.Product
WHERE StandardCost > 0
GROUP BY Name;