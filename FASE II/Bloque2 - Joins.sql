-- 1 ----------------------------------------------------
SELECT t.*, o.order_date
  FROM transactions t
  JOIN orders o
  ON t.order_id = o.order_id;

-- 2 ----------------------------------------------------
SELECT c.customer_name, count(o.order_id) num_pedidos
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING count(o.order_id) = 0;

SELECT c.customer_name, count(o.order_id) num_pedidos
FROM orders o 
RIGHT JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING count(o.order_id) = 0;

-- 3 ----------------------------------------------------
INSERT INTO [dbo].[orders]
           ([customer_id]
           ,[order_date])
     VALUES
           (100, '2024-01-05')

/* Una vez que insertes la nueva fila en la tabla orders, devuelve el ID del cliente, el nombre del
cliente, el ID del pedido y la fecha del pedido de todos los clientes y pedidos existentes. Si un
valor no está disponible, puedes dejarlo en blanco (NULL). Ordena la salida por customer_id
y order_id en modo ascendente.*/

SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = O.customer_id
ORDER BY c.customer_id, o.order_id;

-- 4 ----------------------------------------------------
-- CTE para generar las fechas
WITH DateRange AS (
    SELECT CAST('2024-01-01' AS DATE) AS order_date
    UNION ALL
    SELECT DATEADD(DAY, 1, order_date)
    FROM DateRange
    WHERE order_date <= '2024-01-18'
)
-- Consulta principal
SELECT c.customer_id, dr.order_date
FROM customers c
CROSS JOIN DateRange dr
LEFT JOIN orders o 
ON c.customer_id = o.customer_id AND dr.order_date = o.order_date
WHERE o.order_id IS NULL  -- Solo queremos los pares sin pedidos
ORDER BY c.customer_id, dr.order_date;