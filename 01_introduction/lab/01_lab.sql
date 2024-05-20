-- 01.Create Tables
-- Create the employees table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY NOT NULL,
    first_name VARCHAR(30),
    last_name VARCHAR(50),
    hiring_date DATE DEFAULT '2023-01-01',
    salary NUMERIC(10, 2),
    devices_number INTEGER
);

-- Create the departments table
CREATE TABLE departments (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(50),
    code CHAR(3),
    description TEXT
);

-- Create the issues table
CREATE TABLE issues (
    id SERIAL PRIMARY KEY UNIQUE,
    description VARCHAR(150),
    date DATE,
    start TIMESTAMP WITHOUT TIME ZONE
);

-- 02.Insert Data in Tables
INSERT INTO employees (first_name, last_name, hiring_date, salary, devices_number)
VALUES
('John', 'Doe', '2023-02-15', 60000.00, 3),
('Jane', 'Smith', '2023-03-10', 75000.00, 2),
('Michael', 'Johnson', '2023-04-01', 80000.00, 5);

-- 03.Alter Tables
ALTER TABLE employees ADD COLUMN middle_name VARCHAR(50);

-- 04.Add Constraints
ALTER TABLE employees ALTER COLUMN salary SET NOT NULL;
ALTER TABLE employees ALTER COLUMN salary SET DEFAULT 0;
ALTER TABLE employees ALTER COLUMN hiring_date SET NOT NULL;

-- 05.Modify Columns
ALTER TABLE employees ALTER COLUMN middle_name TYPE VARCHAR(100);

-- 06.Truncate Tables
TRUNCATE TABLE issues;

-- 07.Drop Tables
DROP TABLE departments;
