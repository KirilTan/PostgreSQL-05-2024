-- 01. Count Employees by Town
CREATE OR REPLACE FUNCTION fn_count_employees_by_town(town_name VARCHAR(20))
    RETURNS INT AS
$$
DECLARE
    count INT;
BEGIN
    SELECT COUNT(*)
    INTO count
    FROM towns AS t
             JOIN addresses AS a
                  USING (town_id)
             JOIN employees AS e
                  USING (address_id)
    WHERE t.name = town_name;
    RETURN count;
END;
$$
    LANGUAGE plpgsql;

-- 02. Employees Promotion
CREATE OR REPLACE PROCEDURE
    sp_increase_salaries(department_name VARCHAR(20))
AS
$$
BEGIN
    UPDATE employees
    SET salary = salary * 1.05
    WHERE department_id =
          (SELECT department_id FROM departments WHERE name = department_name);
END;
$$
LANGUAGE plpgsql;

-- 03. Employees Promotion By ID
CREATE OR REPLACE PROCEDURE sp_increase_salary_by_id(id INT)
AS
$$
BEGIN
    -- Check if the employee with the given ID exists
    IF (SELECT salary FROM employees WHERE employee_id = id) IS NULL THEN
        RETURN;
    END IF;

    -- Update the salary by 5%
    UPDATE employees
    SET salary = salary * 1.05
    WHERE employee_id = id;

    -- Commit the transaction
    COMMIT;
END;
$$
LANGUAGE plpgsql;


-- 04. Triggered
-- Create the table to store deleted employees' data
CREATE TABLE deleted_employees (
    employee_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(20),
    last_name     VARCHAR(20),
    middle_name   VARCHAR(20),
    job_title     VARCHAR(50),
    department_id INT,
    salary        NUMERIC(19, 4)
);

-- Define the function that backs up fired employees' data
CREATE OR REPLACE FUNCTION backup_fired_employees()
RETURNS TRIGGER
AS
$$
BEGIN
    INSERT INTO deleted_employees (
        first_name,
        last_name,
        middle_name,
        job_title,
        department_id,
        salary
    )
    VALUES (
        OLD.first_name,
        OLD.last_name,
        OLD.middle_name,
        OLD.job_title,
        OLD.department_id,
        OLD.salary
    );
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Create a trigger that invokes the backup function after an employee is deleted
CREATE OR REPLACE TRIGGER backup_employees
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE PROCEDURE backup_fired_employees();
