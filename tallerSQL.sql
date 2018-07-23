-- Ejercicio 4 Contar y consultar todos los actores existen en la BD.
SELECT count(actor_id) from actor;
SELECT * from actor;

-- Ejercicio 5  Consultar cuales actores participan en las películas ACADEMY DINOSAUR, BERETS AGENT.

SELECT * from film where title LIKE '%ACADEMY%DINOSAUR%' or title LIKE '%BERETS%AGENT%';

SELECT a.first_name, a.last_name, f.title FROM actor a 
		 JOIN film_actor fa ON (a.actor_id = fa.actor_id)
		 JOIN film f ON (f.film_id = fa.film_id)
		 where f.title LIKE '%ACADEMY%DINOSAUR%' or title LIKE '%BERETS%AGENT%';

		
-- Ejercicio 6 Consultar en cuales películas ha participado KARL BERRY y cual es la categoría de dichas películas.
SELECT * FROM actor where first_name like '%KARL%';

SELECT f.title, c.name FROM film f 
	JOIN film_category fc ON (f.film_id = fc.film_id)
	JOIN category c on (fc.category_id = c.category_id)
	ORDER BY f.title DESC;


SELECT f.title, f. FROM actor a 
		 JOIN film_actor fa ON (a.actor_id = fa.actor_id)
		 JOIN film f ON (f.film_id = fa.film_id)
		 where a.first_name = 'KARL' and a.last_name = 'BERRY';