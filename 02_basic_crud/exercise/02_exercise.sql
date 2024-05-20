-- 01.Select Cities
SELECT
    *
FROM cities
;

-- 02.Concatenate
SELECT
    CONCAT_WS(' ',name, state) as cities_information,
    area as area_km2
FROM cities
;
-- 03.Remove Duplicate Rows
SELECT DISTINCT ON (name)
    name,
    area as area_km2
FROM cities
ORDER BY name DESC
;

-- 04.Limit Records
SELECT
    id,
    CONCAT_WS(' ',
              first_name,
              last_name)
        AS full_name,
    job_title
FROM
    employees
ORDER BY
    first_name
LIMIT
    50
;

-- 05.Skip Rows
SELECT
    id as "id",
    CONCAT_WS(' ',
        first_name,
        middle_name,
        last_name)
    AS full_name,
    hire_date
FROM
    employees
ORDER BY
    hire_date
OFFSET
    10 - 1
;

-- 06.Find the Addresses
SELECT
    id,
    CONCAT_WS(' ',
        number,
        street)
    AS address,
    city_id
FROM addresses
WHERE
    id >= 20
;

-- 07.Positive Even Numbers
SELECT
    concat_WS(' ',
    number,
    street)
    AS address,
    city_id
FROM
    addresses
WHERE
    city_id > 0
        AND
    city_id % 2 = 0
ORDER BY
    city_id
;

-- 08.Projects within a Date Range
SELECT
    name,
    start_date,
    end_date
FROM
    projects
WHERE
    start_date >= '2016-06-01 07:00:00'
        AND
    end_date < '2023-06-04 00:00:00'
ORDER BY
    start_date
;

-- 09. Multiple Conditions
SELECT
    number,
    street
FROM
    addresses
WHERE
    id BETWEEN 50 AND 100
        OR
    number < 1000
;

-- 10.Set of Values
SELECT
    employee_id,
    project_id
FROM
    employees_projects
WHERE
    employee_id IN(200,250)
        AND
    project_id NOT IN(50,100)
;

-- 11.Compare Character Values
SELECT
    name,
    start_date
FROM
    projects
WHERE
    name IN('Mountain', 'Road', 'Touring')
LIMIT
    20
;

-- 12.Salary
SELECT
    CONCAT_WS(' ',
        first_name,
        last_name)
    AS
    full_name,
    job_title,
    salary
FROM
    employees
WHERE
    salary IN(12500, 14000, 23600, 25000)
ORDER BY
    salary DESC
;

-- 13.Missing Value
SELECT
    id,
    first_name,
    last_name
FROM
    employees
WHERE
    middle_name IS NULL
LIMIT
    3
;

-- 14.INSERT Departments
INSERT INTO
    departments(department, manager_id)
VALUES
    ('Finance', 3),
    ('Information Services', 42),
    ('Document Control', 90),
    ('Quality Assurance', 274),
    ('Facilities and Maintenance', 218),
    ('Shipping and Receiving', 85),
    ('Executive', 109)
RETURNING *
;

-- 15.New Table
CREATE TABLE IF NOT EXISTS
    company_chart
AS SELECT
       CONCAT_WS(' ',
           first_name,
           last_name)
       AS full_name,
       job_title,
       department_id,
       manager_id
FROM
    employees
;
SELECT * FROM company_chart
;

-- 16.Update the Project End Date
UPDATE
    projects
SET
    end_date = start_date + INTERVAL '5 months'
WHERE
    end_date IS NULL

RETURNING *
;

-- 17.Award Employees with Experience
UPDATE
    employees
SET
    salary = salary + 1500,
    job_title = 'Senior' || ' ' || job_title
WHERE
    hire_date BETWEEN '1998-01-01' AND '2000-01-05'

RETURNING *
;

-- 18.Delete Addresses
DELETE FROM
    addresses
WHERE
    city_id IN (5, 17, 20, 30)
RETURNING *
;

-- 19.Create a View
CREATE VIEW
    view_company_chart
AS
SELECT
    full_name,
    job_title
FROM
    company_chart
WHERE manager_id = 184
;
SELECT * FROM view_company_chart
;

-- 20.Create a View with Multiple Tables
CREATE VIEW
    view_addresses
AS
SELECT
    CONCAT_WS(' ',
        e.first_name,
        e.last_name)
    AS full_name,
    e.department_id,
    CONCAT_WS(' ',
        a.number,
        a.street)
    AS address
FROM
    employees as e, addresses as a
WHERE
    a.id = e.address_id
ORDER BY
    address
;
SELECT * FROM view_addresses
;

-- 21.ALTER VIEW
ALTER VIEW
    view_addresses
RENAME TO
    view_employee_addresses_info
;

-- 22.DROP VIEW
DROP VIEW
    view_company_chart
;

-- 23.UPPER
UPDATE
    projects
SET
    name = UPPER(name)

RETURNING *
;

-- 24.SUBSTRING
CREATE VIEW
    view_initials
AS
SELECT
    SUBSTRING(first_name, 1, 2)
    AS initial,
    last_name
FROM
    employees
ORDER BY
    last_name
;
SELECT * FROM view_initials
;

-- 25.LIKE
SELECT
    name,
    start_date
FROM
    projects
WHERE
    name LIKE 'MOUNT%'
;
