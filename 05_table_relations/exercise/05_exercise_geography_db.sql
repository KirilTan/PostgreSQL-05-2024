-- 11. Delete Cascade
ALTER TABLE
    countries
ADD CONSTRAINT
    fk_countries_continents
FOREIGN KEY
    (continent_code)
REFERENCES
    continents(continent_code)
ON DELETE CASCADE,

ADD CONSTRAINT
    fk_countries_currencies
FOREIGN KEY
    (currency_code)
REFERENCES
    currencies(currency_code)
ON DELETE CASCADE;

-- 12. Update Cascade
ALTER TABLE
    countries_rivers

ADD CONSTRAINT
    fk_countries_rivers_rivers
FOREIGN KEY
    (river_id)
REFERENCES
    rivers(id)
ON UPDATE CASCADE,

ADD CONSTRAINT
    fk_countries_rivers_countries
FOREIGN KEY
    (country_code)
REFERENCES
    countries(country_code)
ON UPDATE CASCADE;

-- 13. SET NULL
CREATE TABLE IF NOT EXISTS
    customers
(
    id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS
    contacts
(
    id           INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contact_name VARCHAR(50),
    phone        VARCHAR(20),
    email        VARCHAR(50),
    customer_id  INT,

    CONSTRAINT fk_contacts_customers
        FOREIGN KEY (customer_id)
            REFERENCES customers (id)
            ON DELETE SET NULL
            ON UPDATE CASCADE
);

INSERT INTO customers(customer_name)
VALUES ('BlueBird Inc'),
       ('Dolphin LLC');

INSERT INTO contacts(customer_id, contact_name, phone, email)
VALUES (1, 'John Doe', '(408)-111-1234', 'john.doe@bluebird.dev'),
       (1, 'Jane Doe', '(408)-111-1235', 'jane.doe@bluebird.dev'),
       (2, 'David Wright', '(408)-222-1234', 'david.wright@dolphin.dev');

DELETE
FROM customers
WHERE id = 1;

-- 14. Peaks in Rila
SELECT
    mountain_range,
    peak_name,
    elevation
FROM
    peaks
JOIN
    mountains
ON
    peaks.mountain_id = mountains.id
WHERE
    TRIM(mountain_range) = 'Rila'
ORDER BY
    elevation DESC;

-- 15. Countries Without Any Rivers
SELECT
	COUNT(*)
FROM
	countries
LEFT JOIN
	countries_rivers
-- ON
--     countries.country_code = countries_rivers.country_code
USING
	(country_code)
WHERE
    river_id IS NULL;