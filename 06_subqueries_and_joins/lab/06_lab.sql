-- 01. Towns Addresses
SELECT t.town_id      AS town_id,
       t.name         AS town_name,
       a.address_text AS address_text
FROM towns AS t
         JOIN addresses AS a
              USING (town_id)
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY t.town_id,
         a.address_id;

-- 02. Managers
SELECT e.employee_id   AS employee_id,
       CONCAT_WS(' ',
                 e.first_name, e.last_name)
                       AS full_name,
       d.department_id AS department_id,
       d.name          AS department_name
FROM employees AS e
         JOIN
     departments AS d
     ON
         e.employee_id = d.manager_id
ORDER BY e.employee_id
LIMIT 5;

-- 03. Employees Projects
SELECT e.employee_id,
       CONCAT_WS(' ',
                 e.first_name,
                 e.last_name) AS full_name,
       p.project_id,
       p.name                 AS project_name
FROM employees AS e
         JOIN employees_projects AS ep
              USING (employee_id)
         JOIN projects AS p
              USING (project_id)
WHERE p.project_id = 1;

-- 04. Higher Salary
SELECT COUNT(*)
FROM employees
WHERE salary >
      (SELECT AVG(salary)
       FROM employees);
