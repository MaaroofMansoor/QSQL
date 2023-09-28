--Challenge 1: Create a dummy variable for each kind of special feature in the film table
--the dummy variable for each kind of special feature should be a column with the same name 
--as that kind of special feature. In this sense, there will be a column for each type of special feature.


SELECT *,
       CASE WHEN 'Trailers' = ANY(special_features) THEN 1 ELSE 0 
	   END AS "Trailers",
       CASE WHEN 'Commentaries' = ANY(special_features) THEN 1 ELSE 0 
	   END AS "Commentaries",
       CASE WHEN 'Deleted Scenes' = ANY(special_features) THEN 1 ELSE 0 
	   END AS "Deleted Scenes",
       CASE WHEN 'Behind the Scenes' = ANY(special_features) THEN 1 ELSE 0 
	   END AS "Behind the Scenes"
FROM FILM;



--challenge 2: Which film category is rented the most often
--The code must return all categories in the column on the left, and their rental count on the right,
--ranked from high rental count to low rental count desc.
 
SELECT c.name AS Category, COUNT(rental.rental_id) AS RentalCount
FROM category c
JOIN film_category ON c.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY c.name
ORDER BY RentalCount DESC;



--challenge 3: how many rentals have not been paid for?
--Just return the number


SELECT COUNT(*) AS UNPAID
FROM rental
WHERE NOT EXISTS (
    SELECT 1
    FROM payment
    WHERE payment.rental_id = rental.rental_id

);


--challenge 4: which city has brought in the most revenue to the dvd store 
--(both stores, assume this is a fun virtual store) thinking about where the customers are from
--Simply return the name of the city or cities


SELECT city.city AS City, SUM(payment.amount) AS TotalRevenue
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city.city
ORDER BY TotalRevenue DESC
LIMIT 1;

OR --cities


SELECT city.city AS City, SUM(payment.amount) AS TotalRevenue
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city.city
ORDER BY TotalRevenue DESC


-- challenge 5: Considering every film in the film table return a result set 
-- that gives the number of actors in one column and the frequency of that number of actors in the next column. 
-- Order the result by the number of actors.


-- Subquery Approach:
SELECT number_of_actors, COUNT(*) AS frequency
FROM (
    SELECT film_id, COUNT(*) AS number_of_actors
    FROM film_actor
    GROUP BY film_id
) AS actor_counts
GROUP BY number_of_actors
ORDER BY number_of_actors asc;


-- Common Table Expression Approach:

with actor_count as (
	select f.film_id, count(fa.actor_id) as number_of_actors
from film f
full join film_actor fa on fa.film_id = f.film_id
group by f.film_id
order by count(fa.film_id))
select number_of_actors, count (number_of_actors) as frequency
from actor_count
group by number_of_actors
order by number_of_actors asc
