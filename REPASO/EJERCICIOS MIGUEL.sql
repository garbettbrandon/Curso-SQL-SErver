--EJERCICIO 1.1
SELECT 
	COUNT(*) AS n_rows, 
	COUNT(DISTINCT jobTitle) AS n_distinct_job_titles
FROM
	HumanResources.Employee;

--EJERCICIO 1.2
SELECT 
	COUNT(DISTINCT jobTitle) AS n_distinct_job_titles
FROM 
	HumanResources.Employee;

--EJERCICIO 1.3
SELECT 
	DISTINCT Gender, 
	COUNT(jobTitle) AS n_distinct_jobTitles 
FROM 
	HumanResources.Employee 
GROUP BY 
	Gender;

-- EJERCICIO 1.4

-- Es debido al GROUP BY, con esto te separa los datos en dos grupos y no se repiten

-- EJERCICIO 1.5
SELECT 
	DISTINCT JobTitle
FROM 
	HumanResources.Employee
WHERE 
	Gender IN ('M', 'F')
GROUP BY 
	JobTitle
HAVING 
	COUNT(DISTINCT Gender) = 2
ORDER BY 
	JobTitle ASC;


-- EJERCICIO 3.1
-- Saca el total de empleados de cada a�o en el que ha sido contratado.
SELECT 
	YEAR(HireDate) AS year_HireDate, 
	COUNT(*) AS n_employee 
FROM 
	HumanResources.Employee
GROUP BY 
	YEAR(HireDate)
ORDER BY 
	YEAR(HireDate) ASC;

-- EJERCICIO 3.2
-- Saca el numero de empleados contratados por a�o y una columna con el dato del a�o anterior.
SELECT 
	YEAR(HireDate) AS year_HireDate,
	COUNT(*) AS n_employee,
	LAG(COUNT(*)) OVER (ORDER BY YEAR(HireDate)) AS previous_n_employees --**FUNCION LAG()**
FROM 
	HumanResources.Employee
GROUP BY 
	YEAR(HireDate)
ORDER BY 
	YEAR(HireDate) ASC;

-- EJERCICIO 3.3
SELECT 
	YEAR(HireDate) AS year_HireDate,
	COUNT(*) AS n_employee,
	LAG(COUNT(*)) OVER (ORDER BY YEAR(HireDate)) AS previous_n_employees,
	(COUNT(*) + LAG(COUNT(*)) OVER (ORDER BY YEAR(HireDate))) / 2 AS custom_avg --SACA EL AVG PERO CUSTOMIZADO.
FROM 
	HumanResources.Employee
GROUP BY 
	YEAR(HireDate)
ORDER BY 
	YEAR(HireDate) ASC;

-- EJERCICIO 3.4
SELECT 
	YEAR(HireDate) AS year_HireDate,
	COUNT(*) AS n_employee,
	LAG(COUNT(*)) OVER (ORDER BY YEAR(HireDate)) AS previous_n_employees,
	AVG(COUNT(*)) OVER (ORDER BY YEAR(HireDate)) AS custom_avg -- SACA EL AVG PERO CON LA FUNCION.
FROM 
	HumanResources.Employee
GROUP BY 
	YEAR(HireDate)
ORDER BY 
	YEAR(HireDate) ASC;

-- EJERCICIO 3.5
SELECT 
	YEAR(HireDate) AS year_HireDate,
	COUNT(*) AS n_employee,
	LAG(COUNT(*)) OVER (ORDER BY YEAR(HireDate)) AS previous_n_employees,
	MIN(COUNT(*)) OVER (PARTITION BY YEAR(HireDate) ORDER BY YEAR(HireDate) ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as min_employees
FROM 
	HumanResources.Employee
GROUP BY 
	YEAR(HireDate)
ORDER BY 
	YEAR(HireDate) ASC;


--EJERCICIO 4.1
SELECT 
	p.FirstName, 
	p.LastName, 
	e.EmailAddress, 
	ph.PhoneNumber 
FROM 
	Person.Person p
INNER JOIN Person.EmailAddress e 
on p.BusinessEntityID = e.BusinessEntityID
INNER JOIN Person.PersonPhone ph 
on p.BusinessEntityID = ph.BusinessEntityID;

--EJERCICIO 4.2
SELECT 
	DISTINCT p.FirstName, p.LastName, e.EmailAddress, ph.PhoneNumber 
FROM 
	Person.Person p
INNER JOIN 
	Person.EmailAddress e 
on 
	p.BusinessEntityID = e.BusinessEntityID
INNER JOIN 
	Person.PersonPhone ph 
on 
	p.BusinessEntityID = ph.BusinessEntityID
INNER JOIN 
	Sales.SalesOrderHeader s 
on 
	p.BusinessEntityID != s.SalesPersonID;

-- 4.3
SELECT 
	p.FirstName, 
	p.LastName, 
	YEAR(S.OrderDate) AS year, 
	COUNT(DISTINCT S.SalesOrderID) AS num_sales
FROM 
	Person.Person p
INNER JOIN 
	Sales.SalesOrderHeader S 
ON 
	p.BusinessEntityID = s.SalesPersonID
GROUP BY 
	p.BusinessEntityID, YEAR(OrderDate), p.FirstName, p.LastName
ORDER BY 
	p.FirstName ASC, YEAR(OrderDate) DESC;