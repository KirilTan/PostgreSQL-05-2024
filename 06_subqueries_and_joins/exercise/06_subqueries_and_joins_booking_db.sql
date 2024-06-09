-- 01. Booked for Nights
SELECT CONCAT_WS(' ', a.address, a.address_2) AS apartment_address,
       b.booked_for                           AS nights
FROM apartments AS a
         JOIN
     bookings AS b
     USING (booking_id)
ORDER BY a.apartment_id;

-- 02. First 10 Apartments Booked At
SELECT a.name,
       a.country,
       b.booked_at::DATE
FROM apartments AS a
         LEFT JOIN
     bookings AS b
     USING (booking_id)
LIMIT 10;

-- 03. First 10 Customers with Bookings
SELECT b.booking_id,
       b.starts_at::DATE,
       b.apartment_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM bookings AS b
         RIGHT JOIN
     customers AS c
     USING (customer_id)
ORDER BY customer_name
LIMIT 10;

-- 04. Booking Information
SELECT b.booking_id,
       a.name                                    AS apartmnent_owner,
       a.apartment_id,
       CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name
FROM apartments AS a
         FULL JOIN
     bookings AS b
     USING (booking_id)
         FULL JOIN
     customers AS c
     USING (customer_id)
ORDER BY b.booking_id, apartmnent_owner, customer_name;

-- 05. Multiplication of Information
SELECT b.booking_id,
       c.first_name
FROM bookings AS b
         CROSS JOIN
     customers AS c
ORDER BY c.first_name;

-- 06. Unassigned Apartments
SELECT b.booking_id,
       b.apartment_id,
       c.companion_full_name
FROM customers AS c
         JOIN
     bookings AS b
     USING (customer_id)
WHERE b.apartment_id IS NULL;

-- 07. Bookings Made by Lead
SELECT apartment_id,
       booked_for,
       first_name,
       country
FROM bookings
         INNER JOIN
     customers
     USING (customer_id)
WHERE job_type LIKE '%Lead%'

-- 08. Hahn`s Bookings
SELECT COUNT(*)
FROM bookings
         JOIN customers
              USING (customer_id)
WHERE last_name = 'Hahn';

-- 09. Total Sum of Nights
SELECT name,
       SUM(booked_for)
FROM apartments
         JOIN bookings
              USING (apartment_id)
GROUP BY name
ORDER BY name;

-- 10. Popular Vacation Destination
SELECT country,
       COUNT(bookings.booking_id) AS booking_count
FROM bookings
         JOIN apartments
              USING (apartment_id)
WHERE booked_at > '2021-05-18 07:52:09.904+03'
  AND booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY country
ORDER BY booking_count DESC;