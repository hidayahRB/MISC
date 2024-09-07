-- Delete duplicate entries of customer data
DELETE FROM customer
WHERE customer_id IN (
	SELECT * FROM (
		SELECT 
			customer_id, 
			email, 
			ROW_NUMBER() OVER (PARTITION BY email ORDER BY create_date) AS row_num
		FROM customer
	) WHERE row_num > 1
);


-- View if there is any films with missing rental rates 
SELECT * FROM film
WHERE rental_rate IS NULL;


-- Create additional calculated column of rental duration per rental transaction
ALTER TABLE rental ADD COLUMN rental_duration INTERVAL;

UPDATE rental
SET rental_duration = return_date - rental_date
WHERE return_date IS NOT NULL;


-- Create additional calculated column of rental duration per rental transaction
ALTER TABLE rental ADD COLUMN rental_due_date timestamp;

UPDATE rental r
SET rental_due_date = r.rental_date + INTERVAL '1 day' * f.rental_duration
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE r.inventory_id = i.inventory_id
  AND r.return_date IS NOT NULL;
