--Insertando registros
INSERT INTO autores (nombre, apellido, seudonimo, Fecha_nacimiento, genero, pais_origen)
VALUES ('Stephen Edwin', 'King', 'Richard Bachman', '1947-09-27', 'M', 'USA'),
       ('Johanne', 'Rowling', 'K.K. Rowling', '1947-09-27', 'F', 'Reino unido'),
       ('Daniel', 'Brown', 'Dan Brown', '1964-06-22', 'M', 'USA'),
       ('John', 'Katzenbach', 'JK', '1950-06-23', 'M', 'USA'),
       ('John Ronald', 'Reuel Tolkien', 'J.R.R Tolkien', '1892-01-03', 'M', 'Reino unido'),
       ('Miguel', 'Unamuno', 'Jugo', '1864-09-29', 'M', 'Espana'),
       ('Arturo', 'Perez Reverte', '', '1951-11-25', 'M', 'Espana'),
       ('George Raymond', 'Richard Martin', 'George R. R. Martin', '1948-09-20', 'M', 'USA');

INSERT INTO libros (autor_id, titulo, fecha_publicacion)
VALUES (1, 'Carrie', '1974-01-01'),
       (1, 'El misterio de Salmes Lot', '1975-01-01'),
       (1, 'El resplandor', '1977-01-01'),

       (2, 'Harry Potter y la Piedra filosofal', '1997-06-30'),
       (2, 'Harry Potter y la Camara Secreta', '1998-07-02'),
       (2, 'Harry Potter y El Prisionero de Azkaban', '1999-07-08'),
       (2, 'Harry Potter y el Caliz de Fuego', '2000-03-20'),
       (2, 'Harry Potter y la Orden del Fenix', '2003-06-21'),
       (2, 'Harry Potter y el Misterio del Principe', '2005-05-16'),
       (2, 'Harry Potter y las Reliquias de la Muerte', '2007-07-21'),
       
       (3, 'La Conspiracion', '2001-01-01'),
       (3, 'Angeles y Demonios', '2000-01-01'),
       (3, 'El Simbolo Perdido', '2009-09-15'),
       (3, 'Inferno', '2013-05-14'),
       (3, 'Origen', '2017-10--01'),
       
       (4, 'El club de los psicopatas', '2021-01-01'),
       (4, 'Confianza Ciega', '2020-01-01'),
       (4, 'Jaque al Psicoanalista', '2018-01-01'),
       (4, 'Personas Desconocidas', '2016-01-01'),
       
       (5, 'El Silmarillion', '1977-01-01'), 
       (5, 'El Hobbit', '1937-01-01'),
       (5, 'El Senor de los Anillos', '1954-01-01'),
       (5, 'La Ultima Cancion de Bilbo', '1974-01-01'),
       
       (6, 'Paisajes', '1902-01-01'),
       (6, 'De mi pais', '1903-01-01'),
       (6, 'Paisajes del Alma', '1979-01-01'),
       
       (7, 'El Husar', '1986-01-01'),
       (7, 'El Maestro Esgrima', '1988-01-01'),
       (7, 'Ojos Azules', '2009-01-01'),
       (7, 'El asedio', '2010-01-01'),
       
       (8, 'A game of Thrones', '1996-01-01'),
       (8, 'A Clash of Kings', '1998-01-01'),
       (8, 'A Feast for Crows', '2005-01-01'),
       (8, 'A Dance with Dragons', '2011-01-01'), 
       (8, 'The World of Ice & Fire', '2014-01-01');

INSERT INTO usuarios (nombre, apellidos, username, email)
VALUES ('Diego', 'Naranjo', 'imdiego.dev', 'hi@imdiego.dev'),
       ('Juan', 'Perez', 'pepeperez', 'pepe@perez.com'),
       ('Juana', 'Alpaca', 'JuanaLaAlpaca', 'juana@alpacas.pe'),
       ('Ciudadano', 'Promedio', 'CiudadanoPromedio1', 'promedio1@ciudadano.com'),
       ('Ciudadano2', 'promedio2', 'CiudadanoPromedio2', 'promedio2@ciudadano.com');

INSERT INTO libros_usuarios(libro_id, usuario_id)
VALUES (40, 1), (52, 1), (69, 1), (45, 2), (59, 2)
       (41, 4), (50, 4);
