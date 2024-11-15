-- EJERCICIO 1
/* 1. Crea una columna categ�rica EmployeeCategory que toma valores �Designer�, �Engineer�,
�Clerk� cuando el t�tulo de trabajo, JobTitle, contenga el string correspondiente:
�Designer�/�Engineer�/�Clerk�. Si JobTitle espec�fica �Manager�, el valor de EmployeeCategory
debe ser �Manager� siempre. Cuando no se cumpla ninguna de las condiciones anteriores, el
valor de EmployeeCategory debe ser �Other�. Comprueba tu soluci�n haciendo un coteo para
cada valor de la columna:*/

with categories as (
	select 
		case 
			when JobTitle like '%Manager' then 'Manager'
			when JobTitle like '%Designer' then 'Designer'
			when JobTitle like '%Engineer' then 'Engineer'
			when JobTitle like '%Clerk' then 'Clerk'
			else 'Other'
		end as EmployeeCategory
	from HumanResources.Employee
)

select 
	EmployeeCategory,
	count(*) as n_records
from categories
group by EmployeeCategory
order by n_records desc;


/* 2. Haz una consulta que compruebe si el d�a de �hoy� est� en la lista ('Jueves','Viernes',
'Lunes'). En caso de que sea verdad, muestra 10 filas cualesquiera de
HumanResources.Employee. En caso contrario no mostrar nada.*/

IF DATEPART(WEEKDAY, GETDATE()) IN (1, 4, 5)
BEGIN
    SELECT TOP 10 * FROM HumanResources.Employee;
END
ELSE
BEGIN
    -- No hacer nada, o puedes retornar un mensaje si lo deseas
    SELECT 'No te ralles E-Berendomm' AS Resultado;
END


IF DATENAME(WEEKDAY, GETDATE()) IN ('Lunes', 'Jueves', 'Viernes')
BEGIN
    SELECT TOP 10 * FROM HumanResources.Employee;
END
ELSE
BEGIN
    SELECT 'No te ralles E-Berendomm' AS Resultado;
END


/* 3. Resuelve la �nullabilidad� de la columna OrganizationLevel rellenando los espacios de NULLs
con el string �NoOrganizationLevel�. Llama a la nueva columna OrganizationLevel.
Comprueba la soluci�n */
select 
	coalesce(cast(OrganizationLevel as varchar), 'NoOrganizationLevel') as OrganizationLevelFilled,
	count(*) as freq
from HumanResources.Employee
group by OrganizationLevel 
order by freq desc;