-- 01. Mountains and Peaks
CREATE TABLE IF NOT EXISTS mountains(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS peaks
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50),
    mountain_id INT,
    CONSTRAINT fk_peaks_mountains
        FOREIGN KEY (mountain_id)
            REFERENCES mountains (id)
);

-- 02. Trip Organization
SELECT
    v.driver_id,
    v.vehicle_type,
    CONCAT_WS(' ',
              c.first_name,
              c.last_name)
    AS
        driver_name
FROM
    vehicles as v
    JOIN
        campers AS c
        ON
            c.id = v.driver_id;

-- 03. SoftUni Hiking
SELECT
    r.start_point,
    r.end_point,
    r.leader_id,
    CONCAT_WS(' ',
            c.first_name,
            c.last_name)
    AS
        leader_name
FROM
    campers AS c
JOIN
    routes AS r
ON
    r.leader_id = c.id;

-- 04. Delete Mountains
CREATE TABLE IF NOT EXISTS mountains(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS peaks(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50),
    mountain_id INT,
    CONSTRAINT fk_mountain_id FOREIGN KEY(mountain_id)
        REFERENCES mountains(id)
            ON DELETE CASCADE
);
