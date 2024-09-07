-- Create a view of top rented films of the year
CREATE VIEW top_rented_films AS
WITH YearlyRentals AS (
    SELECT EXTRACT(YEAR FROM r.rental_date) AS rental_year,
           f.title,
           COUNT(r.rental_id) AS rental_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY rental_year, f.title
),
RankedRentals AS (
    SELECT rental_year,
           title,
           rental_count,
           ROW_NUMBER() OVER (PARTITION BY rental_year ORDER BY rental_count DESC) AS rank
    FROM YearlyRentals
)
SELECT rental_year, title, rental_count
FROM RankedRentals
WHERE rank <= 10
ORDER BY rental_year, rank;


-- Create a view of monthly revenue for each country
CREATE VIEW monthly_revenue_country AS
SELECT country,
       EXTRACT(YEAR FROM payment_date) AS year,
       EXTRACT(MONTH FROM payment_date) AS month,
       SUM(amount) AS monthly_revenue
FROM payment p
JOIN customer cust ON p.customer_id = cust.customer_id
JOIN address a ON cust.address_id = a.address_id
JOIN city ON a.city_id = city.city_id
JOIN country C ON city.country_id = C.country_id
GROUP BY year, month, country
ORDER BY country ASC;


-- Create a DVD return status view
CREATE VIEW dvd_return_status AS
SELECT CASE
           WHEN r.return_date IS NULL THEN 'Not Yet Returned'
           WHEN r.return_date <= r.rental_date + INTERVAL '1 day' * f.rental_duration THEN 'Returned Early'
           WHEN r.return_date > r.rental_date + INTERVAL '1 day' * f.rental_duration THEN 'Returned Late'
       END AS return_status,
	   COUNT(*) AS Total_film
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY return_status;
