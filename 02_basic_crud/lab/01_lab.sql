 -- 01.Select Employee Information
SELECT
    e.id,
    concat(e.first_name, ' ', e.last_name) as "Full Name",
    e.job_title as "Job Title"
FROM employees as e;

-- 02. Select Employees by Filtering
SELECT
    id,
    concat(first_name, ' ', last_name) as full_name,
    job_title,
    salary
from employees
WHERE salary > 1000.00
ORDER BY id;

-- 03. Select Employees by Multiple Filters
SELECT
    *
from employees
WHERE department_id = 4 AND salary >= 1000;

-- 04. Insert Data into Employees Table
INSERT INTO employees
    (first_name, last_name, job_title, department_id, salary)
VALUES
    ('Samantha', 'Young', 'Housekeeping', 4, 900),
    ('Roger', 'Palmer', 'Waiter', 3, 928.33)
;
SELECT
    *
FROM employees
;

-- 05. Update Salary and Select
UPDATE employees
set salary = salary + 100
WHERE job_title = 'Manager'
;
SELECT
    *
FROM employees
WHERE job_title = 'Manager'
;

-- 06. Delete from Table
DELETE FROM employees
WHERE department_id = 2 OR department_id = 1
;

SELECT
    *
FROM employees
;

-- 07. Top Paid Employee View
CREATE VIEW top_paid_employee_view AS
SELECT * FROM employees
ORDER BY SALARY DESC
LIMIT 1
;

SELECT * FROM top_paid_employee_view
;
