-- Ejercicio 1
SELECT OrderDate, ISDATE(OrderDate)
from Sales.SalesOrderHeader

-- Ejercicio 2
/* 2. Devuelve la fecha y hora actuales del sistema de 2 formas distintas. Una debe tener
precisión de 3.33 mientras que la otra tiene mayor precisión, hasta 7 dígitos de segundo. Tus
resultados dependen de la hora de ejecución. Aquí están los míos de ejemplo:*/

select 
	CURRENT_TIMESTAMP as less_precision,
	SYSDATETIME() as more_precision

/*3. Obtén la fecha actual con tipo de datos DATE. Para ello convierte una de las dos columnas
anteriores. Llama a esta nueva columna current_date. Si obtienes un error averigua el
motivo.*/
select CONVERT(DATE, SYSDATETIME()) as 'current_date'

/*4. Calcula la diferencia en días entre fechas de OrderDate del mes ‘2012-05’ y la fecha actual
del sistema. Guarda el resultado en la columna days_diff y muestra los resultados para 10
filas:*/
select top 10
	OrderDate,
	CURRENT_TIMESTAMP as current_datetime,
	datediff(day, OrderDate,CURRENT_TIMESTAMP) as days_diff
from Sales.SalesOrderHeader
where CONVERT(DATE, OrderDate) between '2012-05-01' and '2012-05-31'

/* 5. Los valores de fecha de OrderDate no se almacenan con un desplazamiento (con respecto a
GMT), pero se sabe que son la hora estándar del Pacífico, es decir, GMT-8. Sabiendo esto,
convierte los valores de OrderDate especificando el desplazamiento y guarda el resultado en
OrderDate_TimeZonePST. Comprueba los resultados para las fechas más recientes de tu
tabla:*/

--AT TIME ZONE 'toma horario de verano al ser JUNIO'
SELECT 
  TOP 5 OrderDate, 
  CAST(OrderDate AS DATETIME) AT TIME ZONE 'Pacific Standard Time' AS OrderDate_TimeZonePST 
FROM 
  Sales.SalesOrderHeader 
ORDER BY 
  OrderDate DESC

-- SWITCHOFFSET
SELECT 
  TOP 5 OrderDate, 
  SWITCHOFFSET(
    CAST(OrderDate AS DATETIMEOFFSET), 
    '-07:00'
  ) AS OrderDate_TimeZonePST -- -7 horario verano
FROM 
  Sales.SalesOrderHeader 
ORDER BY 
  OrderDate DESC

/* 6. Ahora que conoces el desplazamiento de la columna OrderDate, convierte la misma a horario
Estándar de Europa Central, GMT+1. Guarda los resultados en OrderDate_TimeZoneCET:*/
SELECT 
  TOP 5 OrderDate, 
  CAST(OrderDate AS DATETIME) AT TIME ZONE 'Pacific Standard Time' AS OrderDate_TimeZonePST,
  CAST(OrderDate AS DATETIME) AT TIME ZONE 'Central Europe Standard Time' AS OrderDate_TimeZoneCET
FROM 
  Sales.SalesOrderHeader 
ORDER BY 
  OrderDate DESC
