-- 1 ----------------------------------------------------------------
CREATE TABLE providers (
	provider_id INT IDENTITY (1, 1) PRIMARY KEY,
    provider_name VARCHAR(255) UNIQUE NOT NULL,
    start_dat DATE NOT NULL,
    end_dat DATE DEFAULT '2099-12-31'
)

INSERT INTO providers (provider_name, start_dat, end_dat) 
VALUES
    ('Correos', '2023-01-01',''),
    ('Seur', '2023-01-01',''),
    ('DHL', '2023-01-01', '2023-12-01');

SELECT * FROM providers;

-- 2 ----------------------------------------------------------------
ALTER TABLE orders
ADD CONSTRAINT cons_order_id
UNIQUE (order_id);

-- 3 ----------------------------------------------------------------
CREATE TABLE shipments (
	order_id INT,
	provider_id INT

	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
)

--Proveedores
INSERT INTO [dbo].[providers]
([provider_name]
,[start_dat])
VALUES
('PRUEBA', '01-01-2020');

--Envíos
INSERT INTO [dbo].[shipments]
([order_id]
,[provider_id])
VALUES
(106, 1);

-- conflicto con la restricción FOREIGN KEY 'FK__shipments__provi__36B12243' ya que tenemos IDENTITY(1,1) NOT NULL
-- no puede hacer referencia a un order_id que no existe.

SELECT * FROM orders

-- 4 ----------------------------------------------------------------

/*BONUS: Con las restricciones añadidas a las tablas hemos conseguido mantener la
integridad de los datos en algunos aspectos. Aún así, para este caso no es suficiente. Piensa
qué restricciones podrían faltar a este modelo y haz una consulta que lo demuestre.*/

-- Para asegurarte de que start_dat no sea posterior a end_dat
ALTER TABLE providers
ADD CONSTRAINT chk_dates CHECK (start_dat <= end_dat);

-- Buscar proveedores con una fecha de finalización antes de la fecha de inicio
SELECT provider_id, provider_name, start_dat, end_dat
FROM providers
WHERE end_dat < start_dat;

-- Podriamos hacer que sea una clave combinada.
CONSTRAINT unique_shipment UNIQUE (order_id, provider_id)
-- Buscar envíos con proveedores inexistentes en la tabla 'providers'
SELECT s.order_id, s.provider_id
FROM shipments s
LEFT JOIN providers p ON s.provider_id = p.provider_id
WHERE p.provider_id IS NULL;
