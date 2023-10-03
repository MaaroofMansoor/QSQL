# SQL Code Challenges README

This README provides an overview of the SQL code challenges and their respective solutions.

## Challenge 1: Create Dummy Variables for Special Features

**Objective:** Create dummy variables for each type of special feature in the film table.

**Solution:**
In this challenge, we use the SQL `CASE` statement to create dummy variables for different special features such as Trailers, Commentaries, Deleted Scenes, and Behind the Scenes. Each special feature is checked, and if it exists in the `special_features` column of the `FILM` table, a corresponding column is created with a value of 1; otherwise, it is set to 0.

```sql
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
```

## Challenge 2: Most Rented Film Category

**Objective:** Determine the film category that has been rented the most.

**Solution:**
In this challenge, we calculate the rental count for each film category by joining multiple tables (category, film_category, film, inventory, and rental). We group the results by category name and order them in descending order of rental count.

```sql
SELECT c.name AS Category, COUNT(rental.rental_id) AS RentalCount
FROM category c
JOIN film_category ON c.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY c.name
ORDER BY RentalCount DESC;
```

## Challenge 3: Unpaid Rentals Count

**Objective:** Calculate the number of rentals that have not been paid for.

**Solution:**
In this challenge, we count the number of rentals that do not have corresponding payment records by using a `WHERE NOT EXISTS` subquery.

```sql
SELECT COUNT(*) AS UNPAID
FROM rental
WHERE NOT EXISTS (
    SELECT 1
    FROM payment
    WHERE payment.rental_id = rental.rental_id
);
```

## Challenge 4: City with Highest Revenue

**Objective:** Determine the city or cities that have brought in the most revenue to the DVD store.

**Solution:**
To find the city with the highest revenue, we join multiple tables (payment, rental, customer, address, and city) and group the results by city. We calculate the total revenue for each city and order the results in descending order of revenue.

```sql
SELECT city.city AS City, SUM(payment.amount) AS TotalRevenue
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY city.city
ORDER BY TotalRevenue DESC
LIMIT 1;
```

To retrieve multiple cities with the highest revenue, you can remove the `LIMIT 1` clause.

## Challenge 5: Number of Actors Frequency

**Objective:** Determine the frequency of the number of actors in films.

**Solution:**
In this challenge, there are two provided solutions to achieve the same result.

### Subquery Approach:

1. A subquery is used to count the number of actors for each film.
2. The outer query then counts the frequency of each unique number of actors.
3. Results are ordered by the number of actors in ascending order.

```sql
SELECT number_of_actors, COUNT(*) AS frequency
FROM (
    SELECT film_id, COUNT(*) AS number_of_actors
    FROM film_actor
    GROUP BY film_id
) AS actor_counts
GROUP BY number_of_actors
ORDER BY number_of_actors ASC;
```

### Common Table Expression (CTE) Approach:

1. A Common Table Expression (CTE) is used to calculate the number of actors for each film.
2. The main query counts the frequency of each unique number of actors from the CTE.
3. Results are ordered by the number of actors in ascending order.

```sql
WITH actor_count AS (
    SELECT f.film_id, COUNT(fa.actor_id) AS number_of_actors
    FROM film f
    FULL JOIN film_actor fa ON fa.film_id = f.film_id
    GROUP BY f.film_id
    ORDER BY COUNT(fa.film_id)
)
SELECT number_of_actors, COUNT(number_of_actors) AS frequency
FROM actor_count
GROUP BY number_of_actors
ORDER BY number_of_actors ASC;
```

These SQL code challenges cover a range of tasks, from creating dummy variables to analyzing rental data, calculating revenue, and summarizing actor counts in films. Each challenge is accompanied by its SQL solution and a brief description of the objective.
The challenge is part of cantek academy data analtics training course 
