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
	JOIN rental r ON (r.rental_id = p.rental_id)
	

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

SELECT count(p.payment_id) from payment p
	JOIN rental r ON(r.rental_id = p.rental_id)
	ORDER BY p.payment_id DESC
	
	

SELECT f.title, c.name FROM film f
	JOIN film_category fc ON (f.film_id = fc.film_id)
	JOIN category c on (fc.category_id = c.category_id)
	GROUP BY c.name;

