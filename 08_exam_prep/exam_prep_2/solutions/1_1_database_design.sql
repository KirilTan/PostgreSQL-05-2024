-- CREATE DATABASE taxi_db;

CREATE TABLE IF NOT EXISTS addresses
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS categories
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS clients
(
    id           SERIAL PRIMARY KEY,
    full_name    VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS drivers
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(30)         NOT NULL,
    last_name  VARCHAR(30)         NOT NULL,
    age        INT CHECK (age > 0) NOT NULL, -- Must be a positive number
    rating     NUMERIC(2) DEFAULT 5.5
);

CREATE TABLE IF NOT EXISTS cars
(
    id          SERIAL PRIMARY KEY,
    make        VARCHAR(20)                    NOT NULL,
    model       VARCHAR(20),
    year        INT DEFAULT 0 CHECK (year > 0) NOT NULL, -- The DEFAULT value is 0, the column must always have a value greater than
    mileage     INT DEFAULT 0 CHECK (mileage > 0),       -- The DEFAULT value is 0, the column must always have a value greater than
    condition   CHAR(1)                        NOT NULL,
    category_id INT                            NOT NULL, -- Relationship with table categories, Cascade Operations

    CONSTRAINT fk_cars_categories
        FOREIGN KEY (category_id)
            REFERENCES categories (id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS courses
(
    id              SERIAL PRIMARY KEY,
    from_address_id INT       NOT NULL,                         -- Relationship with table addresses, Cascade Operations
    start           TIMESTAMP NOT NULL,
    bill            NUMERIC(10, 2) DEFAULT 10 CHECK (bill > 0), -- The DEFAULT value is 10, the column must always have a value greater than NULL
    car_id          INT       NOT NULL,                         -- Relationship with table cars, Cascade Operations
    client_id       INT       NOT NULL,                         -- Relationship with table clients, Cascade Operations

    CONSTRAINT fk_courses_addresses
        FOREIGN KEY (from_address_id)
            REFERENCES addresses (id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_courses_cars
        FOREIGN KEY (car_id)
            REFERENCES cars (id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_courses_clients
        FOREIGN KEY (client_id)
            REFERENCES clients (id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cars_drivers
(
    car_id    INT NOT NULL, -- Relationship with table cars, Cascade Operations
    driver_id INT NOT NULL, -- Relationship with table drivers, Cascade Operations

    CONSTRAINT fk_cars_drivers_cars
        FOREIGN KEY (car_id)
            REFERENCES cars (id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_cars_drivers_drivers
        FOREIGN KEY (driver_id)
            REFERENCES drivers (id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);
