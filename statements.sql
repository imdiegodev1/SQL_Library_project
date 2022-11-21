--Common startup for a BD
DROP DATABASE IF EXISTS libreria_cf;
CREATE DATABASE libreria_cf;

--Declaring to the motor the base to be used
USE libreria_cf;

--Delete tables if they exist
DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS usuarios;

--Table authors
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

--Table books
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

--Table of users
CREATE TABLE usuarios(
    usuario_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(25) NOT NULL,
    apellidos VARCHAR(25),
    username VARCHAR(25) NOT NULL,
    email VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME DEFAULT current_timestamp
);

--Table users and books
CREATE TABLE libros_usuarios(
    libro_id INT UNSIGNED NOT NULL,
    usuario_id INT UNSIGNED NOT NULL,

    FOREIGN KEY (libro_id) REFERENCES libros(libro_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    fecha_creacion DATETIME DEFAULT current_timestamp
);

--Altering a table
ALTER TABLE libros ADD ventas INT UNSIGNED NOT NULL;
ALTER TABLE libros ADD stock INT UNSIGNED NOT NULL DEFAULT 10;

ALTER TABLE libros DROP COLUMN ventas;

ALTER TABLE libros ADD ventas INT UNSIGNED NOT NULL DEFAULT 0;

--Inserting records
--To enter records we can refer to the file data.sql
--where the data for this exercise will be found.

--Record queries
SELECT * FROM autores;
SELECT * FROM libros;
SELECT * FROM usuarios;

--Consultation of records in the form of "cards"
SELECT * FROM autores\G;

--Selecting certain columns of a table
SELECT libro_id, titulo FROM libros;

--WHERE 
SELECT * FROM libros
WHERE titulo = 'Carrie';

--Use WHERE and NULL

--Form 1
SELECT * FROM autores
WHERE seudonimo IS NULL;

SELECT * FROM autores
WHERE pais_origen IS NOT NULL;

--Form 2
SELECT * FROM autores
WHERE pais_origen <=> NULL;

--BETWEEN
--Filtering information with ranges
SELECT titulo, fecha_publicacion FROM libros
WHERE fecha_publicacion BETWEEN '1995-01-01' AND '2015-01-01';

--IN
--Get records from a list
--my list = 'eye of fire', 'cujo', 'the hobbit', 'the dark tower 7'.
--Clausula IN helps us with this and also optimizes the search.
SELECT * FROM libros
WHERE titulo IN 
('ojo de fuego', 'cujo', 'El hobbit', 'la torre oscura 7');

--DISTINCT
--Get unique values from a column
SELECT DISTINCT titulo FROM libros;

--AS
--Alias
SELECT autor_id AS ID, titulo AS nombre_libro FROM libros;

--UPDATE
--Update registers
UPDATE libros SET descripcion = 'Nueva descripcion';

--UPDATE and WHERE
--Good practice for updating a registry
UPDATE libros SET descripcion = 'Descripcion del libro'
WHERE titulo = 'Carrie';

--DELETE
--Delete registers
DELETE FROM libros WHERE autor_id = 1;

--FUNCTIONS

--About STRINGS
--CONCAT -> to concatenate strings 
SELECT CONCAT (nombre, " ", apellido) AS nombre_completo
FROM autores;

--LENGTH -> to display how many characters a string has
SELECT LENGTH ("Hola Mundo");

--With LENGTH we can filter registers
SELECT * FROM autores 
WHERE LENGTH(nombre) > 10;

--UPPER and LOWER allows us to return string with
--upper or lower case format
SELECT UPPER(nombre), LOWER(nombre)
FROM autores;

--About INT and FLOAT
--RAND -> get a random value between 0 - 1
SELECT RAND();

--ROUND -> allows rounding of a decimal number
SELECT ROUND( RAND() );

--TRUNCATE -> as a function allows us to define the number of 
--decimals we require for a decimal number
SELECT TRUNCATE (1.1233456788, 3);

--POW -> returns the value of a number raised to the power
--of another number
SELECT POW(4, 3);

--About DATES
--NOW -> Gate current date time
SET @now = NOW();

--get specific values of a date time field DATETIME
SELECT SECOND(@now),
    MINUTE(@now),
    HOUR(@now),
    MONTH(@now),
    YEAR(@nowo);

--define current day of week, month or year
SELECT DAYOFWEEK(@now),
    DAYOFMONTH(@now),
    DAYOFYEAR(@now);

--DATE -> To transfor data type to date
SELECT DATE(@now);


--conditionals
--IF -> needs 3 arguments:
--IF(condition, result if conditon is met, result if condition is not met)
SELECT IF( 100 > 90, "Mayor", "Menor");

--IFNULL -> pto work with null values:
--IFNULL(attribute, result if is null, result if is not null)
SELECT IFNULL(seudonimo, "No seudonimo", seudonimo);


--Creating FUNCTIONS
DELIMITER // 

CREATE FUNCTION agregar_dias(fecha DATE, dias INT)
RETURNS DATE
BEGIN
    RETURN fecha + INTERVAL dias DAY;
END//

DELIMITER ;

--Use a function
SELECT agregar_dias(@now, 60);

--Adding/alter registers with a function

--Funtion to add a random number of pages in column paginas from
--libros table
DELIMITER //

CREATE FUNCTION obtener_paginas()
RETURNS INT
BEGIN
    SET @paginas = (SELECT (ROUND(RAND()*100)*4));
    RETURN @paginas;
END//

DELIMITER ;

--Funtion to add a random number of sells in ventas column from
--libros table
DELIMITER //

CREATE FUNCTION obtener_ventas()
RETURNS INT
BEGIN
    SET @ventas = (SELECT (ROUND(RAND()*100)*6));
    RETURN @ventas;
END//

DELIMITER ;

--Using functions to add data
UPDATE libros SET paginas = obtener_paginas();
UPDATE libros SET ventas = obtener_ventas();

--List functions
SELECT name FROM mysql.proc WHERE db = database() AND type = 'FUNCTION';

--Delete functions
DROP FUNCTION agregar_dias;

--LIKE
--It is commonly use with WHERE and helps you to filter/get data
--from strings columns

--Chain of characters at the beggining of a string:
SELECT * FROM libros
WHERE titulo LIKE 'Harry potter%';

--Chain of characters at the beginning of a string:
SELECT * FROM libros
WHERE titulo LIKE '%anillo';

--Chain of characters located anywhere of a string
SELECT * FROM libros
WHERE titulo LIKE '%la%';

--Get a text field with a character located in a certain position
--b letter in third position
SELECT * FROM libros
WHERE titulo LIKE '%__b';

--LEFT and LIKE
--we can use LEFT and LIKE to find a chain starting with certain letter

--LIKE example
SELECT autor_id, titulo FROM libros WHERE titulo LIKE 'H%' or titulo LIKE 'L%';
--LEFT example
SELECT autor_id, titulo FROM libros WHERE LEFT(titulo, 1) = 'H' OR LEFT(titulo, 1) = 'L';

--An alternative to this in the case of needing to be complied with
--several conditions is by using regular expressions
--So using ReGex:
SELECT titulo FROM libros
WHERE titulo REGEXP '^[HL]';


--ORDER BY
SELECT titulo FROM libros
ORDER BY titulo;

--If we want it to be in descending order
SELECT titulo FROM libros
ORDER BY titulo DESC;


--LIMIT
SELECT titulo FROM libros
LIMIT 10;

--Aggregation functions
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

--UNION
--You can concat the results of two queries
--It is important to have the same column distribution in both results
SELECT CONCAT(nombre, " ", apellido) FROM autores
UNION
SELECT CONCAT(nombre, " ", apellidos) FROM usuarios;


--Sub Queries
--In this case, we want to obtain the authors whose books have
--higher sales than the average, for this we must make a step by
--step to get the right information.

--First: get average sales
SELECT AVG(ventas) FROM libros;

--Second: once you have average sales you can set it to a constant in SQL
--so de Query wold be like
SELECT autor_id FROM libros
GROUP BY autor_id 
HAVING SUM(ventas) > @un_promedio;

--Here is how you can define the value of a constant with a query
SET @un_promedio = (SELECT AVG(ventas) FROM libros);

--With subqueres we can define this value without using a constant
SELECT autor_id FROM libros
GROUP BY autor_id 
HAVING SUM(ventas) > (SELECT AVG(ventas) FROM libros);

--Now how would it work if I don't want to get the ids of 
--the authors but their names? of the authors but the name of the
--authors? Can I do more than one nested subquery?
SELECT CONCAT(nombre, " ", apellido)
FROM autores
WHERE autor_id IN(
    SELECT autor_id FROM libros
    GROUP BY autor_id 
    HAVING SUM(ventas) > (SELECT AVG(ventas) FROM libros)
);


--EXIST
SELECT IF(
    EXISTS(SELECT libro_id FROM libros WHERE titulo = 'El Hobbit'),
    'Disponible',
    'No Disponible'
) AS mensaje;


--JOIN

--INNER JOIN
SELECT 
    libros.titulo,
    CONCAT(autores.nombre, " ", autores.apellido) AS nombre_autor,
    libros.fecha_creacion
FROM libros
INNER JOIN autores
ON libros.autor_id = autores.autor_id;

--USING
--If a join between two tables is made with a fields that have the same
--name we can use USING
SELECT 
    libros.titulo,
    CONCAT(autores.nombre, " ", autores.apellido) AS nombre_autor,
    libros.fecha_creacion
FROM libros
INNER JOIN autores
ON USING(autor_id);

--LEFT JOIN == LEFT OUTER JOIN
SELECT
    CONCAT(nombre, " ", apellidos),
    libros_usuarios.libro_id
FROM usuarios
LEFT JOIN libros_usuarios
ON usuarios.usuario_id = libros_usuarios.usuario_id
WHERE libros_usuarios.libro_id IS NOT NULL;

--RIGHT JOIN == RIGHT OUTER JOIN
SELECT
    CONCAT(nombre, " ", apellidos),
    libros_usuarios.libro_id
FROM libros_usuarios
RIGHT JOIN usuarios
ON usuarios.usuario_id = libros_usuarios.usuario_id
WHERE libros_usuarios.libro_id IS NULL;

--Multiple JOINS
--In this example I want to get the full name of the users that 
--have lent a book, the book was written by a writer with a pseudonym
--and the loan was made today.
SELECT DISTINCT
    CONCAT(usuarios.nombre, " ", usuarios.apellidos) AS nombre_usuario
FROM usuarios
INNER JOIN libros_usuarios ON usuarios.usuario_id = libros_usuarios.usuario_id
    AND DATE(libros_usuarios.fecha_creacion) = CURDATE()
INNER JOIN libros ON libros_usuarios.libro_id = libros.libro_id
INNER JOIN autores ON libros.autor_id = autores.autor_id
    AND autores.seudonimo IS NOT NULL;


--CROSS JOIN
--Cartesian product
--With this we can get that each user is entitled to
--one copy of each book
SELECT usuarios.username, libros.titulo
FROM usuarios CROSS JOIN libros
ORDER BY username DESC;


--VIEWS
--I want to see information about all the users who have borrowed books
--books in the last week and the quantity of books
CREATE VIEW prestamos_usuarios_vw AS 
SELECT usuarios.usuario_id,
       usuarios.nombre,
       usuarios.email,
       usuarios.username,
       COUNT(usuarios.usuario_id) AS n_libros
FROM usuarios
INNER JOIN libros_usuarios
ON usuarios.usuario_id = libros_usuarios.usuario_id
GROUP BY usuarios.usuario_id;

--to see the views we can just list the tables
SHOW TABLES;

--DELETE a VIEW
DROP VIEW prestamos_usuarios_vw

--EDIT a view
--In this case, it was not specified that the loans should be
--the same week
CREATE OR REPLACE VIEW prestamos_usuarios_vw AS 
SELECT usuarios.usuario_id,
       usuarios.nombre,
       usuarios.email,
       usuarios.username,
       COUNT(usuarios.usuario_id) AS n_libros
FROM usuarios
INNER JOIN libros_usuarios
ON usuarios.usuario_id = libros_usuarios.usuario_id
    AND libros_usuarios.fecha_creacion >= CURDATE() - INTERVAL 7 DAY
GROUP BY usuarios.usuario_id;


--CREATE PROCEDURES
--Store procedures
--a procedure to generate the loan of a book that is seen
--reflected in the user_books table and subtract 1 unit from stock
--in the books table
DELIMITER //

CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT)
BEGIN
    INSERT INTO libros_usuarios(libro_id, usuario_id)
        VALUES(libro_id, usuario_id);
    UPDATE libros SET stock = stock -1
        WHERE libros.libro_id = libro_id;

END//

DELIMITER ;

--Display store procedures created in a database
SELECT name FROM mysql.proc WHERE db = database() AND type = 'PROCEDURE';

--Using a store procedure
CALL prestamo(4, 60);

--Delete a store procedure
DROP PROCEDURE prestamo;

--return a value after using a store procedure
--It is necessary to define a constant before
SET @cantidad = -1;

DELIMITER //

CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT, OUT cantidad INT)
BEGIN
    INSERT INTO libros_usuarios(libro_id, usuario_id)
        VALUES(libro_id, usuario_id);
    UPDATE libros SET stock = stock -1
        WHERE libros.libro_id = libro_id;

    SET cantidad = (SELECT stock FROM libros 
        WHERE libros.libro_id = libro_id);

END//

DELIMITER ;

--Use conditionals in Stock Procedures I want to do the same operation,
--but only if there are books available for loan
DELIMITER //

CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT, OUT cantidad INT)
BEGIN
    SET cantidad = (SELECT stock FROM libros 
        WHERE libros.libro_id = libro_id);
    
    IF cantidad > 0 THEN 
        INSERT INTO libros_usuarios(libro_id, usuario_id)
            VALUES(libro_id, usuario_id);
        UPDATE libros SET stock = stock -1
            WHERE libros.libro_id = libro_id;

        SET cantidad = cantidad - 1;
    ELSE
        SELECT "No es posible realizar el prestamo" AS mesaje_error;
    END IF;

END//

DELIMITER ;


--CASES
DELIMITER //

CREATE PROCEDURE tipo_lector(usuario_id INT)
BEGIN
    SET @cantidad = (SELECT COUNT(*) FROM libros_usuarios
                        WHERE libros_usuarios.usuario_id = usuario_id);

    CASE
        WHEN @cantidad > 20 THEN
            SELECT "Fanatico" AS mensaje;
        WHEN @cantidad > 10 AND @cantidad < 20 THEN
            SELECT "Aficionado" AS mensaje;
        WHEN @cantidad > 5 AND @cantidaad < 10 THEN 
            SELECT "Promedio" AS mensaje;
        ELSE
            SELECT "Nuevo" AS mensaje;
    END CASE;
    
END//

DELIMITER ;


--WHILE and REPEAT loops

--I want a store procedure that returns 5 random books
--WHILE
DELIMITER //

CREATE PROCEDURE libros_azar()
BEGIN
    SET @iteracion = 0;

    WHILE @iteracion < 5 DO

        SELECT libro_id, titulo FROM libros
        ORDER BY RAND()
        LIMIT 1;
        SET @iteracion = @iteracion +1;

    END WHILE;
END//

DELIMITER ;

--REPEAT
DELIMITER //

CREATE PROCEDURE libros_azar()
BEGIN
    SET @iteracion = 0;

    REPEAT

        SELECT libro_id, titulo FROM libros
        ORDER BY RAND()
        LIMIT 1;
        SET @iteracion = @iteracion +1;

    UNTIL @interacion >= 5
    END REPEAT;
END//

DELIMITER ;


--TRANSACTIONS

--I want to define the following steps in a transaction
SET @libro_id = 60, @usuario_id = 3;

--1) update the book stock
--2) Display the selected book
--3) Add a lending record to the libros_usuarios table
--4) View changes in the libros_usuarios table

--Creating our transaction, for this we execute:
START TRANSACTION;

--update the book store
UPDATE libros SET stock = stock - 1 WHERE libro_id = @libro_id;

--Display the selected book
SELECT stock FROM libros WHERE libro_id = @libro_id;

--Add a lending record to the libros_usuarios table
INSERT INTO libros_usuarios(libro_id, usuario_id)
VALUES (@libro_id, @usuario_id);

--View changes in the libros_usuarios table
SELECT * FROM libros_usuarios;

--If there has not been any error to persist these changes os 
COMMIT;

--If the transaction fails, we can execute
ROLLBACK;
--And no change remains persistent in the DB.

--It is possible to execute a transaction in a more optimal way by means of
--store procedures, for example:

DELIMITER //

CREATE PROCEDURE prestamo(usuario_id INT, libro_id INT)
BEGIN

    
    --With this we define that when an error occurs inside the 
    --procedure to stop and execute something (when an error is generated)
    --In this case it executes ROLLBACK;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO libros_usuarios(libro_id, usuario_id)
    VALUES (libro_id, usuario_id);

    UPDATE libros SET stock = stock - 1
    WHERE libros.libro_id = libro_id;

    COMMIT;

END //

DELIMITER ;