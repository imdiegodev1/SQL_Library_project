--Inicio comun para una BD
DROP DATABASE IF EXISTS libreria_cf;
CREATE DATABASE libreria_cf;

--Declarando al motor la base que se usara
USE libreria_cf;

--Eliminar las tablas si existen
DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS usuarios;

--Tabla autores
CREATE TABLE autores(
    autor_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR(25) NOT NULL,
    seudonimo VARCHAR (50) UNIQUE,
    genero ENUM('M', 'F'), -- M o F
    Fecha_nacimiento DATE NOT NULL,
    pais_origen VARCHAR(40) NOT NULL,
    fecha_creacion DATETIME DEFAULT current_timestamp
);

--Tabla libros
CREATE TABLE libros(
    libro_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    autor_id INT UNSIGNED NOT NULL,
    titulo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(250),
    paginas INTEGER UNSIGNED,
    fecha_publicacion DATE NOT NULL,
    fecha_creacion DATETIME DEFAULT current_timestamp,
    FOREIGN KEY (autor_id) REFERENCES autores (autor_id)
);

--Tabla usuarios
CREATE TABLE usuarios(
    usuario_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(25) NOT NULL,
    apellidos VARCHAR(25),
    username VARCHAR(25) NOT NULL,
    email VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME DEFAULT current_timestamp
);

--Alterando una tabla
ALTER TABLE libros ADD ventas INT UNSIGNED NOT NULL;
ALTER TABLE libros ADD stock INT UNSIGNED NOT NULL DEFAULT 10;

ALTER TABLE libros DROP COLUMN ventas;

ALTER TABLE libros ADD ventas INT UNSIGNED NOT NULL DEFAULT 0;

--Insertando registros
--Para ingresar registros podemos referirnos al archivo data.sql
--donde se encontraran los datos para este ejercicio.

--Consulta de registros
SELECT * FROM autores;
SELECT * FROM libros;
SELECT * FROM usuarios;

--Consulta de registros a manera de "tarjetas"
SELECT * FROM autores\G;

---Seleccion de ciertas columnas de una tabla
SELECT libro_id, titulo FROM libros;

--Uso sentencia WHERE
SELECT * FROM libros
WHERE titulo = 'Carrie';

--Uso de WHERE y NULL

--Forma 1
SELECT * FROM autores
WHERE seudonimo IS NULL;

SELECT * FROM autores
WHERE pais_origen IS NOT NULL;

--Forma 2
SELECT * FROM autores
WHERE pais_origen <=> NULL;

--Filtrado de informacion con Rangos
SELECT titulo, fecha_publicacion FROM libros
WHERE fecha_publicacion BETWEEN '1995-01-01' AND '2015-01-01';

--Obtener registros a partir de una lista
--mi lista = 'ojo de fuego', 'cujo', 'El hobbit', 'la torre oscura 7'
--Clausula IN nos ayuda con esto y ademas optimisamos la busqueda.
SELECT * FROM libros
WHERE titulo IN 
('ojo de fuego', 'cujo', 'El hobbit', 'la torre oscura 7');

--Obtener valores unicos de una columna
SELECT DISTINCT titulo FROM libros;

--Alias
SELECT autor_id AS ID, titulo AS nombre_libro FROM libros;

--Actualizar registros
UPDATE libros SET descripcion = 'Nueva descripcion';

--Buena practica para actualizar un registro
UPDATE libros SET descripcion = 'Descripcion del libro'
WHERE titulo = 'Carrie';

---eliminando registros
DELETE FROM libros WHERE autor_id = 1;

--Funciones

--Sobre STRINGS
--Concat -> para concatenar campos 
SELECT CONCAT (nombre, " ", apellido) AS nombre_completo
FROM autores;

--LENGTH -> para visualizar cuantos caracteres tiene un string
SELECT LENGTH ("Hola Mundo");

--Con esta funcion tambien podemos filtrar datos
SELECT * FROM autores 
WHERE LENGTH(nombre) > 10;

--UPPER y LOWER permiten volver todos los caracteres en 
--mayusculas o minusculas
SELECT UPPER(nombre), LOWER(nombre)
FROM autores;

--Sobre INT y FLOAT
--RAND -> permite obtener un numero aleatorio entre 0 y 1
SELECT RAND();

--ROUND -> permite redondear un numero decimal
SELECT ROUND( RAND() );

--TRUNCATE -> como funcion permite definir el numero de 
--decimales que requerimos para un numero decimal
SELECT TRUNCATE (1.1233456788, 3);

--POW -> para elevar un numero a alguna potencia
SELECT POW(4, 3);

--sobre FECHAS
--NOW -> obtener la fecha y hora actual
SET @now = NOW();

--obtener datos especificos de un campo DATETIME
SELECT SECOND(@now),
    MINUTE(@now),
    HOUR(@now),
    MONTH(@now),
    YEAR(@nowo);

--Definir dia de la semana, mes o a;o
SELECT DAYOFWEEK(@now),
    DAYOFMONTH(@now),
    DAYOFYEAR(@now);

--DATE -> para cambiar el tipo de dato a DATE
SELECT DATE(@now);


--condicionales
--IF -> recibe 3 argumentos:
--IF(condicion, resultado se cumple condicion, resultado no cumple la condicion)
SELECT IF( 100 > 90, "Mayor", "Menor");

--IFNULL -> para trabajar con campos nulos:
--IFNULL(atributo, "resultado si es nulo", resultado si no es nulo)
SELECT IFNULL(seudonimo, "No seudonimo", seudonimo);


--Creando funciones
DELIMITER // 

CREATE FUNCTION agregar_dias(fecha DATE, dias INT)
RETURNS DATE
BEGIN
    RETURN fecha + INTERVAL dias DAY;
END//

DELIMITER ;

--utilizar una fucion
SELECT agregar_dias(@now, 60);

--Agregando/alterando registros con funciones

--Funcion para agregar un numero aleatorio de paginas
--a la columna paginas en la tabla libros
DELIMITER //

CREATE FUNCTION obtener_paginas()
RETURNS INT
BEGIN
    SET @paginas = (SELECT (ROUND(RAND()*100)*4));
    RETURN @paginas;
END//

DELIMITER ;

--Funcion para agregar un numero aleatoreo de ventas
--a la columna ventas en la tabla libros
DELIMITER //

CREATE FUNCTION obtener_ventas()
RETURNS INT
BEGIN
    SET @ventas = (SELECT (ROUND(RAND()*100)*6));
    RETURN @ventas;
END//

DELIMITER ;

--utilizando funciones para generar datos
UPDATE libros SET paginas = obtener_paginas();
UPDATE libros SET ventas = obtener_ventas();

--Listar funciones
SELECT name FROM mysql.proc WHERE db = database() AND type = 'FUNCTION';

--Eliminar una funcion
DROP FUNCTION agregar_dias;

--sentencia LIKE

--cadena de caracteres al principio del texto:
SELECT * FROM libros
WHERE titulo LIKE 'Harry potter%';

--cadena de caracteres al final del texto:
SELECT * FROM libros
WHERE titulo LIKE '%anillo';

--cadena de caracteres en algun momento del texto
SELECT * FROM libros
WHERE titulo LIKE '%la%';

--un caracter en una posicion en especifico
--En este caso que tenga la letra b en la tercera posicion de
--la primera palabra
SELECT * FROM libros
WHERE titulo LIKE '%__b';

--Podemos utilizar la sentencia LEFT o buscar que se cumpla
--mas de una condicion con el operador OR

--ejemplo con LIKE
SELECT autor_id, titulo FROM libros WHERE titulo LIKE 'H%' or titulo LIKE 'L%';
--ejemplo con LEFT
SELECT autor_id, titulo FROM libros WHERE LEFT(titulo, 1) = 'H' OR LEFT(titulo, 1) = 'L';

--Una alternativa a esto en el caso de necesitar que se cumplan
--varias condiciones es usando expresiones regulares
--utilizando RegEx tnemos entonces
SELECT titulo FROM libros
WHERE titulo REGEXP '^[HL]';


--ORDER BY
SELECT titulo FROM libros
ORDER BY titulo;

--Si queremos que sea en orden descendente
SELECT titulo FROM libros
ORDER BY titulo DESC;


--LIMIT
SELECT titulo FROM libros
LIMIT 10;

--Funciones de agregacion
SELECT COUNT(*) FROM libros;
SELECT SUM(stock) FROM libros;

--GROUP BY
SELECT autor_id, SUM(stock) AS total FROM libros
GROUP BY autor_id
ORDER BY total DESC;


--HAVING
SELECT autor_id, SUM(stock) AS total
FROM libros
GROUP BY autor_id
HAVING SUM(stock) > 50;

--Union
--Si tengo dos qqueries y quiero unir los resultados puedo
--usar el operador union
SELECT CONCAT(nombre, " ", apellido) FROM autores
UNION
SELECT CONCAT(nombre, " ", apellidos) FROM usuarios;


--Sub Queries
--En este caso queremos obtener los autores cuyos
--libros tengan mayores ventas a las del promedio,
--para esto se debe hacer un paso a
--paso para obtener la informacion adecuada.

--primero: obtener el promedio de ventas
SELECT AVG(ventas) FROM libros;

--segundo: una vez tenga este promedio como 
--seria la consulta?
SELECT autor_id FROM libros
GROUP BY autor_id 
HAVING SUM(ventas) > @un_promedio;

--podriamos convertir el promedio generado en el primer paso
--como una variable
SET @un_promedio = (SELECT AVG(ventas) FROM libros);

--Con una subconsulta podemos hacer ambas operaciones
--en un solo proceso
SELECT autor_id FROM libros
GROUP BY autor_id 
HAVING SUM(ventas) > (SELECT AVG(ventas) FROM libros);

--Ahora como funcionaria si no quiero obtener los id 
--de los autores sino el nombre de los mismos?
--Puedo hacer mas de una subconsulta anidada
SELECT CONCAT(nombre, " ", apellido)
FROM autores
WHERE autor_id IN(
    SELECT autor_id FROM libros
    GROUP BY autor_id 
    HAVING SUM(ventas) > (SELECT AVG(ventas) FROM libros)
);


--Exists
SELECT IF(
    EXISTS(SELECT libro_id FROM libros WHERE titulo = 'El Hobbit'),
    'Disponible',
    'No Disponible'
) AS mensaje;