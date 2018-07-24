-- Ejercicio 4 Contar y consultar todos los actores existen en la BD.
SELECT count(actor_id) from actor;
SELECT * from actor;

-- Ejercicio 5  Consultar cuales actores participan en las pelÃ­culas ACADEMY DINOSAUR, BERETS AGENT.

SELECT * from film where title LIKE '%ACADEMY%DINOSAUR%' or title LIKE '%BERETS%AGENT%';

SELECT a.first_name, a.last_name, f.title FROM actor a 
		 JOIN film_actor fa ON (a.actor_id = fa.actor_id)
		 JOIN film f ON (f.film_id = fa.film_id)
		 where f.title LIKE '%ACADEMY%DINOSAUR%' or title LIKE '%BERETS%AGENT%';

		
-- Ejercicio 6 Consultar en cuales pelÃ­culas ha participado KARL BERRY y cual es la categorÃ­a de dichas pelÃ­culas.
SELECT * FROM actor where first_name like '%KARL%';

SELECT f.title, c.name FROM film f 
	JOIN film_actor fa ON (fa.film_id = f.film_id)
	JOIN actor ac ON (fa.actor_id = ac.actor_id)
	JOIN film_category fc ON (f.film_id = fc.film_id)
	JOIN category c on (fc.category_id = c.category_id)
	WHERE ac.first_name = 'KARL' and ac.last_name="BERRY"
	ORDER BY f.title DESC;


-- 7.	Consultar el costo promedio de (replacement_cost) para las películas cuya categoría sea Drama .
SELECT AVG(replacement_cost) AS COSTO_PROMEDIO FROM film f
	JOIN film_category fc on(f.film_id = fc.film_id)
	JOIN category c ON (fc.category_id = c.category_id)
	WHERE c.name = 'Drama';
	
-- 8.	Consultar el total de ventas de cada store por categoría de película
SELECT * FROM payment;

SELECT * FROM payment p
	INNER JOIN rental  r ON p.rental_id = r.rental_id

SELECT c.name AS CATEGORIA, SUM(p.amount) AS VENTAS
	FROM payment p
	INNER JOIN rental  r ON p.rental_id = r.rental_id
	INNER JOIN inventory  i ON r.inventory_id = i.inventory_id
	INNER JOIN film  f ON i.film_id = f.film_id
	INNER JOIN film_category  fc ON f.film_id = fc.film_id
	INNER JOIN category  c ON fc.category_id = c.category_id
	GROUP BY c.name
	ORDER BY VENTAS DESC
	
SELECT * FROM sales_by_film_category;

-- 9.	Contar todos los clientes existentes por País.

select cu.first_name, cu.last_name, ci.city, co.country from customer cu
	JOIN address a ON cu.address_id = a.address_id
	JOIN city ci ON a.city_id = ci.city_id
	JOIN country co ON ci.country_id = co.country_id
	where co.country = 'Algeria'
	;
	
	
SELECT co.country as Pais, COUNT(cu.first_name)  FROM customer cu
	JOIN address a ON cu.address_id = a.address_id
	JOIN city ci ON a.city_id = ci.city_id
	JOIN country co ON ci.country_id = co.country_id
	GROUP BY co.country;
	
-- 10.	Crear una tabla temporal que contenga las películas que cada cliente ha alquilado

SELECT cu.customer_id, cu.first_name, f.title FROM customer cu
	JOIN rental re ON re.customer_id = cu.customer_id
	JOIN inventory i on i.inventory_id = re.inventory_id
	JOIN film f ON f.film_id = i.film_id;
	
CREATE TEMPORARY TABLE IF NOT EXISTS Peliculas_cliente AS (
	SELECT cu.customer_id, cu.first_name, cu.last_name, f.title FROM customer cu
	JOIN rental re ON re.customer_id = cu.customer_id
	JOIN inventory i on i.inventory_id = re.inventory_id
	JOIN film f ON f.film_id = i.film_id
);

SELECT * from Peliculas_cliente;


-- 11.	Consulte el tiempo máximo en días que cada cliente ha tenido una película.
select cu.customer_id, cu.first_name, cu.last_name, r.rental_date, r.return_date, f.title from customer cu
	JOIN rental r on r.customer_id = cu.customer_id
	JOIN inventory i on i.inventory_id = r.inventory_id
	JOIN film f on i.film_id = f.film_id
	order by cu.customer_id desc;
	
select cu.customer_id, cu.first_name, cu.last_name,  DATEDIFF(r.return_date, r.rental_date) AS DAYS, f.title from customer cu
	JOIN rental r on r.customer_id = cu.customer_id
	JOIN inventory i on i.inventory_id = r.inventory_id
	JOIN film f on i.film_id = f.film_id
	order by cu.customer_id desc;
	
	
select   cu.first_name, cu.last_name,  MAX(DATEDIFF(r.return_date, r.rental_date)) AS DAYS, f.title from customer cu
	JOIN rental r on r.customer_id = cu.customer_id
	JOIN inventory i on i.inventory_id = r.inventory_id
	JOIN film f on i.film_id = f.film_id
	GROUP by cu.customer_id, f.title;
	

DROP DATABASE BDCamilo;	
	
CREATE DATABASE BDCamilo;

use BDCamilo;

--
-- Table structure for table `tipo_documento`
--

CREATE TABLE tipo_documento (
  id_tipo_documento  INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  tipo_documento VARCHAR(25),
  PRIMARY KEY  (id_tipo_documento)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `pais`
--
CREATE TABLE pais (
  pais_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  pais VARCHAR(50) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (pais_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `cuidad`
--
CREATE TABLE ciudad (
  ciudad_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  ciudad VARCHAR(50) NOT NULL,
  pais_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (ciudad_id),
  KEY idx_fk_pais_id (pais_id),
  CONSTRAINT `fk_pais_id ` FOREIGN KEY (pais_id) REFERENCES pais (pais_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `direccion`
--
CREATE TABLE direccion (
  direccion_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  direccion VARCHAR(50) NOT NULL,
  ciudad_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  telefono VARCHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (direccion_id),
  KEY idx_fk_ciudad_id (ciudad_id),
  CONSTRAINT `fk_ciudad_id` FOREIGN KEY (ciudad_id) REFERENCES ciudad (ciudad_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Table structure for table `datos_persona`
--
CREATE TABLE datos_persona (
  id_datos_persona SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50),
  apellido_1 VARCHAR(50),
  apellido_2 VARCHAR(50),
  dni VARCHAR(50),
  email VARCHAR(50) DEFAULT NULL,
  direccion_id SMALLINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  fecha_nacimiento DATETIME NOT NULL,
  id_tipo_doc INTEGER UNSIGNED NOT NULL,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (id_datos_persona),
  KEY idx_fk_direccion_id (direccion_id),
  KEY idx_fk_id_tipo_doc (id_tipo_doc),
  CONSTRAINT fk_datos_persona_direccion_id FOREIGN KEY (direccion_id) REFERENCES direccion (direccion_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_datos_persona_tipo_doc FOREIGN KEY (id_tipo_doc) REFERENCES tipo_documento (id_tipo_documento) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `cliente`
--
CREATE TABLE cliente (
  id_cliente SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_datos_persona SMALLINT UNSIGNED NOT NULL,
  nombre_usuario VARCHAR(50),
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (id_cliente),
  KEY idx_fk_id_datos_persona (id_datos_persona),
  CONSTRAINT fk_id_datos_persona FOREIGN KEY (id_datos_persona) REFERENCES datos_persona (id_datos_persona) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `responsable`
--
CREATE TABLE responsable (
  id_responsable SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre_usuario VARCHAR(50),
  id_datos_persona SMALLINT UNSIGNED NOT NULL,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (id_responsable),
  KEY idx_fk_id_datos_persona_responsable (id_datos_persona),
  CONSTRAINT fk_id_datos_persona_responsable FOREIGN KEY (id_datos_persona) REFERENCES datos_persona (id_datos_persona) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `artista`
--

CREATE TABLE artista (
  id_artista SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre_usuario VARCHAR(50),
  nombre_artistico VARCHAR(50),
  id_datos_persona SMALLINT UNSIGNED NOT NULL,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (id_artista),
  KEY idx_fk_id_datos_persona_artista (id_datos_persona),
  CONSTRAINT fk_id_datos_persona_artista FOREIGN KEY (id_datos_persona) REFERENCES datos_persona (id_datos_persona) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `canal`
--

CREATE TABLE canal (
  id_canal  INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  tipo_canal VARCHAR(50),
  PRIMARY KEY  (id_canal)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `medio_pago`
--

CREATE TABLE medio_pago (
  id_medio_pago  INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  medio_pago VARCHAR(50),
  PRIMARY KEY  (id_medio_pago)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `escenario`
--

CREATE TABLE escenario (
  id_escenario  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  capacidad SMALLINT UNSIGNED NOT NULL,
  nombre varchar(50) NOT NULL,
  direccion_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY  (id_escenario),
  KEY idx_fk_id_direccion_escenario (direccion_id),
  CONSTRAINT fk_id_direccion_escenario FOREIGN KEY (direccion_id) REFERENCES direccion (direccion_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `zona`
--

CREATE TABLE zona (
  id_zona  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  capacidad_zona SMALLINT UNSIGNED NOT NULL,
  nombre varchar(50) NOT NULL,
  id_escenario SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY  (id_zona),
  KEY idx_fk_id_escenario (id_escenario),
  CONSTRAINT fk_id_escenario FOREIGN KEY (id_escenario) REFERENCES escenario (id_escenario) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
--
-- Table structure for table `tipo_boleteria`
--

CREATE TABLE tipo_boleteria (
  id_tipo_boleteria  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  porcentaje_aumento SMALLINT UNSIGNED NOT NULL,
  nombre varchar(50) NOT NULL,
  PRIMARY KEY  (id_tipo_boleteria)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Table structure for table `evento`
--

CREATE TABLE evento (
  id_evento  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_escenario SMALLINT UNSIGNED NOT NULL,
  id_artista SMALLINT UNSIGNED NOT NULL,
  id_responsable SMALLINT UNSIGNED NOT NULL,
  nombre varchar(50) NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME NOT NULL,
  patrocinador VARCHAR(50) NOT NULL,
  id_escenario SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY  (id_evento),
  KEY idx_fk_id_escenario_evento (id_escenario),
  KEY idx_fk_id_artista_evento (id_artista),
  KEY idx_fk_id_responsable_evento (id_responsable),
  CONSTRAINT fk_id_escenario_evento FOREIGN KEY (id_escenario) REFERENCES escenario (id_escenario) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_id_artista_evento FOREIGN KEY (id_artista) REFERENCES artista (id_artista) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_id_responsable_evento FOREIGN KEY (id_responsable) REFERENCES responsable (id_responsable) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Table structure for table `compra`

CREATE TABLE compra (
  id_compra SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_boleta  SMALLINT UNSIGNED NOT NULL,
  id_zona SMALLINT UNSIGNED NOT NULL,
  id_tipo_boleta SMALLINT UNSIGNED NOT NULL,
  id_evento SMALLINT UNSIGNED NOT NULL,
  costo DECIMAL(15 , 5),
  PRIMARY KEY  (id_boleta),
  KEY idx_fk_id_zona (id_zona),
  KEY idx_fk_id_tipo_boleta (id_tipo_boleta),
  KEY idx_fk_id_evento (id_evento),
  CONSTRAINT fk_id_zona_boleta FOREIGN KEY (id_escenario) REFERENCES escenario (id_escenario) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_id_tipo_boleta FOREIGN KEY (id_artista) REFERENCES artista (id_artista) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_id_evento_boleta FOREIGN KEY (id_responsable) REFERENCES responsable (id_responsable) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `boleta`
--

CREATE TABLE boleta (
  id_boleta  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_zona SMALLINT UNSIGNED NOT NULL,
  id_tipo_boleta SMALLINT UNSIGNED NOT NULL,
  id_evento SMALLINT UNSIGNED NOT NULL,
  id_compra SMALLINT UNSIGNED,
  costo DECIMAL(15 , 5),
  PRIMARY KEY  (id_boleta),
  KEY idx_fk_id_zona (id_zona),
  KEY idx_fk_id_tipo_boleta (id_tipo_boleta),
  KEY idx_fk_id_evento (id_evento),
  CONSTRAINT fk_id_zona_boleta FOREIGN KEY (id_escenario) REFERENCES escenario (id_escenario) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_id_tipo_boleta FOREIGN KEY (id_artista) REFERENCES artista (id_artista) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_id_evento_boleta FOREIGN KEY (id_responsable) REFERENCES responsable (id_responsable) ON DELETE RESTRICT ON UPDATE CASCADE
  CONSTRAINT fk_id_compra FOREIGN KEY (id_compra) REFERENCES compra (id_compra) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;






