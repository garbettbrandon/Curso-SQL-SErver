CREATE PROCEDURE sp_EmpleadosPorDepartamento @Departamento NVARCHAR(50) AS BEGIN
SELECT
    e.BusinessEntityID AS EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    JobTitle
FROM
    [HumanResources].[Employee] e
    INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh ON e.[BusinessEntityID] = edh.[BusinessEntityID]
    INNER JOIN [HumanResources].[Department] d ON edh.[DepartmentID] = d.[DepartmentID]
WHERE
    d.Name = @Departamento
END
GO
    EXEC sp_EmpleadosPorDepartamento 'Engineering';