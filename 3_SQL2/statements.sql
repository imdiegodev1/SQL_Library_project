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