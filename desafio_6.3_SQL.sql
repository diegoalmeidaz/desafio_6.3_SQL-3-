-- Author: Diego Almeida
-- Desafio 6.3 SQL: Consultas Multiples


-- Begin sesion with the following command on the terminal (en mac: psql -U postgres -W)



-- PREGUNTA 1: CREACION DE TABLAS Y CARGA DE CONTENIDO SEGUN ESPECIFICACIONES


-- Create Database:

CREATE DATABASE desafio_63_diego_almeida_987;


--selection of the database

\c desafio_63_diego_almeida_987;

-- Create User Table:

CREATE TABLE usuarios (
    id SERIAL,
    email VARCHAR NOT NULL,
    nombre VARCHAR (50) NOT NULL,
    apellido VARCHAR (50) NOT NULL,
    rol VARCHAR
);

-- Insert of data on users table

INSERT INTO usuarios (nombre, apellido, email, rol) VALUES
('Diego', 'Almeida', 'diego@mail.com', 'Administrador'),
('Pedro', 'Perez', 'pedro@mail.com', 'Usuario'),
('Juan', 'Juaneles', 'juan@mail.com', 'Usuario'),
('Fernando', 'Fernandez', 'fernando@mail.com', 'Usuario'),
('Tomas', 'Tomassen', 'tomas@mail.com', 'Usuario');



-- TABLE LOAD RESULT (USUARIOS):

desafio_63_diego_almeida_987=# TABLE usuarios;
 id |       email       |  nombre  | apellido  |      rol      
----+-------------------+----------+-----------+---------------
  1 | diego@mail.com    | Diego    | Almeida   | Administrador
  2 | pedro@mail.com    | Pedro    | Perez     | Usuario
  3 | juan@mail.com     | Juan     | Juaneles  | Usuario
  4 | fernando@mail.com | Fernando | Fernandez | Usuario
  5 | tomas@mail.com    | Tomas    | Tomassen  | Usuario
(5 rows)




-- Create posts table:

CREATE TABLE posts (
    id SERIAL,
    titulo VARCHAR, 
    contenido TEXT, 
    fecha_creacion TIMESTAMP NOT NULL, 
    fecha_actualizacion TIMESTAMP NOT NULL,
    destacado BOOLEAN,
    usuario_id BIGINT
);



-- Insert data onto posts table:

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES 
('Tema 1', 'Paris by nights', '01/01/2022', '01/02/2022', true, 1),
('Tema 2', 'Samba de verano', '01/03/2022', '01/04/2022', true, 1),
('Tema 3', 'Corcovado', '02/04/2022', '03/06/2022', true, 2),
('Tema 4', 'Varias Quejas', '03/05/2022', '04/06/2022', false, 2),
('Tema 5', 'Samba de Invierno', '04/07/2022', '04/08/2022', false, NULL);


-- TABLE LOAD RESULT (POSTS): 

desafio_63_diego_almeida_987=# TABLE posts;
 id | titulo |     contenido     |   fecha_creacion    | fecha_actualizacion | destacado | usuario_id 
----+--------+-------------------+---------------------+---------------------+-----------+------------
  1 | Tema 1 | Paris by nights   | 2022-01-01 00:00:00 | 2022-01-02 00:00:00 | t         |          1
  2 | Tema 2 | Samba de verano   | 2022-01-03 00:00:00 | 2022-01-04 00:00:00 | t         |          1
  3 | Tema 3 | Corcovado         | 2022-02-04 00:00:00 | 2022-03-06 00:00:00 | t         |          2
  4 | Tema 4 | Varias Quejas     | 2022-03-05 00:00:00 | 2022-04-06 00:00:00 | f         |          2
  5 | Tema 5 | Samba de Invierno | 2022-04-07 00:00:00 | 2022-04-08 00:00:00 | f         |           
(5 rows)


-- Create comments table:

CREATE TABLE comentarios (
    id SERIAL,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);


-- Insert data onto comments table: 

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('comentario 1', '01/02/2021', 1, 1),
('comentario 2', '02/02/2021', 2, 1),
('comentario 3', '03/04/2021', 3, 1),
('comentario 4', '04/06/2021', 1, 2),
('comentario 5', '04/07/2021', 2, 2);


-- TABLE LOAD RESULT (COMENTARIOS).

desafio_63_diego_almeida_987=# table comentarios;
 id |  contenido   |   fecha_creacion    | usuario_id | post_id 
----+--------------+---------------------+------------+---------
  1 | comentario 1 | 2021-01-02 00:00:00 |          1 |       1
  2 | comentario 2 | 2021-02-02 00:00:00 |          2 |       1
  3 | comentario 3 | 2021-03-04 00:00:00 |          3 |       1
  4 | comentario 4 | 2021-04-06 00:00:00 |          1 |       2
  6 | comentario 5 | 2021-04-07 00:00:00 |          2 |       2
(5 rows)




-- PREGUNTA 2: Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas: nombre e email del usuario junto al titulo y contenido del post: 

SELECT u.nombre, u.email, p.titulo, p.contenido FROM usuarios AS u JOIN posts AS p ON u.id = p.usuario_id;

--Respuesta pregunta 2:

 nombre |     email      | titulo |    contenido    
--------+----------------+--------+-----------------
 Diego  | diego@mail.com | Tema 1 | Paris by nights
 Diego  | diego@mail.com | Tema 2 | Samba de verano
 Pedro  | pedro@mail.com | Tema 3 | Corcovado
 Pedro  | pedro@mail.com | Tema 4 | Varias Quejas
(4 rows)


-- PREGUNTA 3: Muestra el id, titulo y contenido de los posts de los administradores. El administrador puede ser cualquier id y deber ser seleccionado dinamicamente.

SELECT p.id, p.titulo, p.contenido FROM posts AS p JOIN usuarios AS u ON p.usuario_id = u.id WHERE u.rol = 'Administrador';


--* Alternativa para no usuario el import AS 
SELECT posts.id, posts.titulo, posts.contenido FROM posts JOIN usuarios ON posts.usuario_id = usuarios.id WHERE usuarios.rol = 'Administrador';

-- Respuesta pregunta 3: 

 id | titulo |    contenido    
----+--------+-----------------
  1 | Tema 1 | Paris by nights
  2 | Tema 2 | Samba de verano
(2 rows)


-- PREGUNTA 4: Cuenta la cantidad de posts de cada usuario. La tabla resultante deber mostrar el id e email del usuario junto con la cantidad de posts de cada usuario

SELECT u.id, u.email, COUNT(p.usuario_id) FROM usuarios AS u LEFT JOIN posts AS p ON u.id = p.usuario_id GROUP BY p.usuario_id, u.id, u.email ORDER BY p.usuario_id ASC;

-- Respuesta Pregunta 4: 

 id |       email       | count 
----+-------------------+-------
  1 | diego@mail.com    |     2
  2 | pedro@mail.com    |     2
  3 | juan@mail.com     |     0
  4 | fernando@mail.com |     0
  5 | tomas@mail.com    |     0
(5 rows)

-- PREGUNTA 5: Muestra el email del usuario que ha creado mas posts. Aqui la tabla resultante tiene un unico registro y muestra solo el email

SELECT u.email FROM usuarios AS u JOIN posts AS p ON u.id = p.usuario_id GROUP BY u.email ORDER BY COUNT (p.usuario_id) LIMIT 1;


-- Respuesta pregunta 5: 

----------------
 diego@mail.com
(1 row)


-- PREGUNTA 6: Muestra la fecha del ultimo post de cada usuario

SELECT nombre, MAX(fecha_creacion) AS Ultimo_Post from (SELECT p.contenido, p.fecha_creacion, u.nombre FROM usuarios u JOIN posts p on u.id = p.usuario_id) AS result GROUP BY nombre;

 nombre |     ultimo_post     
--------+---------------------
 Pedro  | 2022-03-05 00:00:00
 Diego  | 2022-01-03 00:00:00


-- PREGUNTA 7: Muestre el titulo y contenido del post (articulo) con mas comentarios

SELECT p.titulo, p.contenido FROM posts p JOIN (SELECT post_id, COUNT(post_id) FROM comentarios GROUP BY post_id ORDER BY COUNT (post_id) DESC LIMIT 1) AS result ON p.id = result.post_id;

-- Respuesta pregunta 7: 

 titulo |    contenido    
--------+-----------------
 Tema 1 | Paris by nights
(1 row)



-- PREGUNTA 8: Muestra en una tabla el titulo de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribio

SELECT posts.titulo, posts.contenido, comentarios.contenido AS comentarios_contenido, usuarios.email FROM posts JOIN comentarios ON posts.id = comentarios.post_id JOIN usuarios ON comentarios.id = usuarios.id;


-- Respuesta pregunta 8:

 titulo |    contenido    | comentarios_contenido |       email       
--------+-----------------+-----------------------+-------------------
 Tema 1 | Paris by nights | comentario 1          | diego@mail.com
 Tema 1 | Paris by nights | comentario 2          | pedro@mail.com
 Tema 1 | Paris by nights | comentario 3          | juan@mail.com
 Tema 2 | Samba de verano | comentario 4          | fernando@mail.com
 Tema 2 | Samba de verano | comentario 5          | tomas@mail.com
(5 rows)




-- PREGUNTA 9: Muestra el contenido del ultimo comentario de cada usuario:

SELECT * FROM comentarios AS c JOIN usuarios AS u ON c.usuario_id = u.id;

SELECT fecha_creacion, contenido, usuario_id FROM comentarios JOIN (SELECT MAX(comentarios.id) AS id_max FROM comentarios GROUP BY usuario_id) AS max_result ON comentarios.id = max_result.id_max ORDER BY comentarios.usuario_id;

-- Respuesta pregunta 9: 

   fecha_creacion    |  contenido   | usuario_id 
---------------------+--------------+------------
 2021-04-06 00:00:00 | comentario 4 |          1
 2021-04-07 00:00:00 | comentario 5 |          2
 2021-03-04 00:00:00 | comentario 3 |          3
(3 rows)


-- PREGUNTA 10: Muestra los emails de los usuarios que no han escrito ningún comentario. 

SELECT u.email from usuarios AS u LEFT JOIN comentarios AS c on u.id = c.usuario_id GROUP BY u.email, c.contenido HAVING c.contenido IS NULL;


-- Respuesta pregunta 10: 

       email       
-------------------
 fernando@mail.com
 tomas@mail.com
(2 rows)