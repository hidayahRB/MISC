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
