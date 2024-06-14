CREATE TABLE IF NOT EXISTS search_results
(
    id            SERIAL PRIMARY KEY,
    address_name  VARCHAR(50),
    full_name     VARCHAR(100),
    level_of_bill VARCHAR(20),
    make          VARCHAR(30),
    condition     CHAR(1),
    category_name VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE sp_courses_by_address(
    address_name VARCHAR(100)
) AS
$$
BEGIN
    TRUNCATE search_results;

    INSERT INTO search_results (address_name, full_name, level_of_bill, make, condition, category_name)
    SELECT addresses.name,
           clients.full_name,
           CASE
               WHEN courses.bill < 20 THEN 'Low'
               WHEN courses.bill <= 30 THEN 'Medium'
               ELSE 'High'
               END AS level_of_bill,
           cars.make,
           cars.condition,
           categories.name
    FROM courses
             JOIN addresses
                  ON courses.from_address_id = addresses.id
             JOIN clients
                  ON courses.client_id = clients.id
             JOIN cars
                  ON courses.car_id = cars.id
             JOIN categories
                  ON cars.category_id = categories.id
    WHERE addresses.name = address_name
    ORDER BY cars.make,
             clients.full_name;
END;
$$
    LANGUAGE plpgsql;

-- Test 1
CALL sp_courses_by_address('700 Monterey Avenue');
SELECT * FROM search_results;

-- Test 2
CALL sp_courses_by_address('66 Thompson Drive');
SELECT * FROM search_results;