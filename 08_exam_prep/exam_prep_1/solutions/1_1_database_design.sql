CREATE DATABASE zoo_db; -- Do not submit to Judge

    CREATE TABLE IF NOT EXISTS owners
(
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address      VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS animal_types
(
    id          SERIAL PRIMARY KEY,
    animal_type VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS cages
(
    id             SERIAL PRIMARY KEY,
    animal_type_id INT NOT NULL, -- Relationship with table animal_types, Cascade Operations,

    CONSTRAINT fk_cages_animal_types
        FOREIGN KEY (animal_type_id)
            REFERENCES animal_types (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS animals
(
    id             SERIAL PRIMARY KEY,
    name           VARCHAR(30) NOT NULL,
    birthdate      DATE        NOT NULL,
    owner_id       INT, -- Relationship with table owners, Cascade Operations
    animal_type_id INT NOT NULL, -- Relationship with table animal_types, Cascade Operations

    CONSTRAINT fk_animals_owners
        FOREIGN KEY (owner_id)
            REFERENCES owners (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,

    CONSTRAINT fk_animals_animal_types
        FOREIGN KEY (animal_type_id)
            REFERENCES animal_types (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS volunteers_departments
(
    id              SERIAL PRIMARY KEY,
    department_name VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS volunteers
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    phone_number  VARCHAR(15) NOT NULL,
    address       VARCHAR(15),
    animal_id     INT,                  -- Relationship with table animals, Cascade Operations
    department_id INT         NOT NULL, -- Relationship with table volunteers_departments, Cascade Operations

    CONSTRAINT fk_volunteers_animals
        FOREIGN KEY (animal_id)
            REFERENCES animals (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,

    CONSTRAINT fk_volunteers_volunteers_departments
        FOREIGN KEY (department_id)
            REFERENCES volunteers_departments (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS animals_cages
(
    cage_id   INT NOT NULL, -- Relationship with table cages, Cascade Operations
    animal_id INT NOT NULL, -- Relationship with table animals, Cascade Operations

    CONSTRAINT fk_animals_cages_cages
        FOREIGN KEY (cage_id)
            REFERENCES cages (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,

    CONSTRAINT fk_animals_cages_animals
        FOREIGN KEY (animal_id)
            REFERENCES animals (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);