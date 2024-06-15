SELECT CONCAT(LEFT(p.description, 10), '...')   AS summary,
       TO_CHAR(p.capture_date, 'DD.MM HH24:MI') AS date
FROM photos AS p
WHERE EXTRACT(DAY FROM p.capture_date) = 10
ORDER BY p.capture_date DESC;
