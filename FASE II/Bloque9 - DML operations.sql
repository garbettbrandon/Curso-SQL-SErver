-- 1 --------------------------------------------------------------------------
CREATE TABLE Empleados(
	Id_empleado INT IDENTITY(1, 1) PRIMARY KEY,
	Empleado VARCHAR(50) NOT NULL
);

-- 2 --------------------------------------------------------------------------
CREATE TABLE Libros (
	ISBN VARCHAR(13) PRIMARY KEY CHECK(LEN(ISBN) = 13),
	Titulo_Libro VARCHAR(100) NOT NULL,
	Autor VARCHAR(50) NOT NULL,
	Genero VARCHAR(50),
	Editorial VARCHAR(50)
);

-- 3 ---------------------------------------------------------------------------
CREATE TABLE Usuarios (
	Id_usuario INT IDENTITY(1, 1) PRIMARY KEY,
	Nombre_usuario VARCHAR(50) NOT NULL,
	Telefono_usuario INT NOT NULL CHECK(LEN(telefono_usuario) = 9)
);


/* 4.Crea una tabla llamada Prestamos, que contenga los campos: 
 ISBN, Id_empleado, Id_usuario, Fecha_Prestamo, Fecha_Fin_Prestamo, Fecha_Devolucion.*/
CREATE TABLE Prestamos (
	isbn VARCHAR(13) CHECK(LEN(isbn) = 13),
	id_empleado INT,
	id_usuario INT,
	fecha_prestamo DATE NOT NULL,
	-- La fecha de pr�stamo debe introducirse siempre.
	fecha_fin_prestamo DATE,
	fecha_devolucion DATE,
	/*Los Id y el ISBN deben ser claves for�neas de las tablas Libro, Empleado y Usuario.*/
	FOREIGN KEY (isbn) REFERENCES libros(isbn),
	FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
	/*Adem�s no debe permitirse que se introduzca una fecha de fin de pr�stamo anterior a la de fecha de pr�stamo.*/
	CONSTRAINT chk_fecha CHECK (fecha_fin_prestamo > fecha_prestamo)
);


/*5. Inserta 3 registros en cada tabla creada rellenando todos los campos.*/
INSERT INTO
	empleados (empleado)
VALUES
	('Bran'),
	('Paco'),
	('Mercedes');

INSERT INTO
	libros (isbn, Titulo_Libro, Autor, Genero, Editorial)
VALUES
	(
		'9783161484100',
		'Cien A�os de Soledad',
		'Gabriel Garc�a M�rquez',
		'Realismo M�gico',
		'Editorial Sudamericana'
	),
	(
		'9780743273565',
		'El Gran Gatsby',
		'F. Scott Fitzgerald',
		'Novela de la Edad de Oro',
		'Scribner'
	),
	(
		'9780452284234',
		'1984',
		'George Orwell',
		'Distop�a',
		'Secker & Warburg'
	);

INSERT INTO
	usuarios(nombre_usuario, telefono_usuario)
VALUES
	('Bran', 666777888),
	('Paco', 675123654),
	('Ramon', 675123654);

INSERT INTO
	prestamos(
		isbn,
		id_empleado,
		id_usuario,
		fecha_prestamo,
		fecha_fin_prestamo,
		fecha_devolucion
	)
VALUES
	(
		'9783161484100',
		2,
		2,
		'2024-11-05',
		'2024-11-25',
		''
	),
	(
		'9780743273565',
		2,
		3,
		'2024-10-10',
		'2024-10-30',
		'2024-10-28'
	),
	(
		'9780452284234',
		3,
		1,
		'2024-11-02',
		'2024-11-22',
		''
	);


-- 6.	Inserta 3 registros en cada tabla (salvo en Empleado) dejando al menos un campo vac�o.
INSERT INTO
	libros (isbn, Titulo_Libro, Autor, Genero, Editorial)
VALUES
	(
		'9788467052376',
		'La Sombra del Viento',
		'Carlos Ruiz Zaf�n',
		'Novela de misterio',
		NULL
	),
	(
		'9788437604947',
		'Don Quijote de la Mancha',
		NULL,
		'Novela cl�sica',
		'Ediciones C�tedra'
	),
	(
		'9788490226968',
		'La Metamorfosis',
		'Franz Kafka',
		NULL,
		'Editorial Alianza'
	);

INSERT INTO
	usuarios(nombre_usuario, telefono_usuario)
VALUES
	('Ana', ''),
	('', 609123456),
	('Carla', 634567890);

INSERT INTO
	prestamos(
		isbn,
		id_empleado,
		id_usuario,
		fecha_prestamo,
		fecha_fin_prestamo,
		fecha_devolucion
	)
VALUES
	(
		'9788490620575',
		2,
		2,
		'2024-11-01',
		'2024-11-21',
		''
	),
	(
		'9788433924217',
		2,
		3,
		'2023-11-03',
		'2023-11-23',
		''
	),
	(
		'9788432226985',
		3,
		2,
		'2024-10-15',
		'2024-11-05',
		'2024-11-02'
	);


-- 7.	Cambia el nombre del empleado con ID 1 a �Jos� Mu�oz Perera�.
UPDATE
	Empleados
SET
	Empleado = 'Jos� Mu�oz Perera'
WHERE
	id_Empleado = 1;


/*8. Cambia los null de todas las tablas por �-�. En el caso de los campos de fecha, sustit�yelos
 por la fecha actual.*/
UPDATE
	libros
SET
	Editorial = CASE
		WHEN Editorial IS NULL THEN '-'
		ELSE Editorial
	END,
	Autor = CASE
		WHEN Autor IS NULL THEN '-'
		ELSE Autor
	END,
	Genero = CASE
		WHEN Genero IS NULL THEN '-'
		ELSE Genero
	END
WHERE
	Editorial IS NULL
	OR Autor IS NULL
	OR Genero IS NULL;

UPDATE
	Prestamos
SET
	fecha_devolucion = GETDATE()
WHERE
	fecha_devolucion IS NULL;

SELECT
	*
FROM
	Prestamos;


-- 9. Cambia todas las fechas de devoluci�n de la tabla Prestamos de 2023 a 12 de Enero de 2004.
UPDATE
	Prestamos
SET
	fecha_devolucion = '2004-01-12'
WHERE
	fecha_devolucion LIKE '2023%';


-- 10. Borra los registros de la tabla Prestamos que tengan Fecha_Fin_Prestamos igual a la fecha actual.
DELETE FROM
	Prestamos
WHERE
	fecha_fin_prestamo = CAST(GETDATE() as DATE);


-- 11.	Borra los registros de la tabla Usuario cuyo nombre empiece por �J�.
DELETE FROM
	usuarios
WHERE
	nombre_usuario LIKE 'J%';

SELECT
	*
FROM
	usuarios