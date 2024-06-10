-- 11. Bulgaria's Peaks Higher than 2835 Meters
SELECT mc.country_code,
       m.mountain_range,
       p.peak_name,
       p.elevation
FROM peaks AS p
         JOIN mountains AS m
              ON p.mountain_id = m.id
         JOIN mountains_countries AS mc
              ON m.id = mc.mountain_id
WHERE p.elevation > 2835
  AND mc.country_code = 'BG'
ORDER BY p.elevation DESC;

-- 12. Count Mountain Ranges
SELECT mc.country_code,
       COUNT(mountain_range) AS mountain_range_count
FROM mountains AS m
         INNER JOIN
     mountains_countries AS mc
     ON m.id = mc.mountain_id
WHERE mc.country_code IN ('US', 'RU', 'BG')
GROUP BY mc.country_code
ORDER BY mountain_range_count DESC

-- 13. Rivers in Africa
SELECT c.country_name,
       r.river_name
FROM countries AS c
         LEFT JOIN
     countries_rivers AS cr
     USING (country_code)
         LEFT JOIN
     rivers AS r
     ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- 14. Minimum Average Area Across Continents
SELECT MIN(average_area) AS min_average_area
FROM (SELECT continent_code,
             AVG(area_in_sq_km) AS average_area
      FROM countries
      GROUP BY continent_code) AS avg

-- 15. Countries Without Any Mountains
SELECT COUNT(*) AS countries_without_mountains
FROM countries AS c
    LEFT JOIN
    mountains_countries AS mc
    USING(country_code)
WHERE mc.mountain_id IS NULL;

-- 16. Monasteries by Country
CREATE TABLE IF NOT EXISTS monasteries
(
    id             SERIAL PRIMARY KEY,
    monastery_name VARCHAR(255),
    country_code   CHAR(2)
);

INSERT INTO monasteries (monastery_name, country_code)
VALUES ('Rila Monastery "St. Ivan of Rila"', 'BG'),
       ('Bachkovo Monastery "Virgin Mary"', 'BG'),
       ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
       ('Kopan Monastery', 'NP'),
       ('Thrangu Tashi Yangtse Monastery', 'NP'),
       ('Shechen Tennyi Dargyeling Monastery', 'NP'),
       ('Benchen Monastery', 'NP'),
       ('Southern Shaolin Monastery', 'CN'),
       ('Dabei Monastery', 'CN'),
       ('Wa Sau Toi', 'CN'),
       ('Lhunshigyia Monastery', 'CN'),
       ('Rakya Monastery', 'CN'),
       ('Monasteries of Meteora', 'GR'),
       ('The Holy Monastery of Stavronikita', 'GR'),
       ('Taung Kalat Monastery', 'MM'),
       ('Pa-Auk Forest Monastery', 'MM'),
       ('Taktsang Palphug Monastery', 'BT'),
       ('Sümela Monastery', 'TR');

ALTER TABLE
    countries
    ADD COLUMN
        three_rivers BOOLEAN DEFAULT FALSE;


UPDATE
    countries
SET three_rivers = (SELECT COUNT(*) >= 3
                    FROM countries_rivers AS cr
                    WHERE cr.country_code = countries.country_code);

SELECT m.monastery_name,
       c.country_name
FROM monasteries AS m
         JOIN
     countries AS c
     USING
         (country_code)
WHERE NOT three_rivers
ORDER BY monastery_name;

-- 17. Monasteries by Continents and Countries
UPDATE countries
SET country_name = 'Burma'
WHERE country_name = 'Myanmar';

INSERT INTO monasteries(monastery_name, country_code)
VALUES ('Hanga Abbey',
        (SELECT country_code
         FROM countries
         WHERE country_name = 'Tanzania'));

SELECT c.continent_name,
       cs.country_name,
       COUNT(m.country_code) AS monasteries_count
FROM continents AS c
         JOIN
     countries AS cs
     USING
         (continent_code)
         LEFT JOIN
     monasteries AS m -- left cause there can be countries with no monasteries
     USING
         (country_code)
WHERE cs.three_rivers IS NOT TRUE
GROUP BY cs.country_name,
         c.continent_name
ORDER BY monasteries_count DESC,
         country_name;

-- 18. Retrieving Information about Indexes
SELECT tablename,
       indexname,
       indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename,
         indexname;

-- 19. Continents and Currencies
CREATE VIEW continent_currency_usage
AS
SELECT ru.continent_code,
       ru.currency_code,
       ru.currency_usage
FROM (SELECT ct.continent_code,
             ct.currency_code,
             ct.currency_usage,
             DENSE_RANK() OVER (PARTITION BY ct.continent_code ORDER BY ct.currency_usage DESC) AS ranked_usage
      FROM (SELECT continent_code,
                   currency_code,
                   COUNT(currency_code) AS currency_usage
            FROM countries
            GROUP BY continent_code,
                     currency_code
            HAVING COUNT(*) > 1
            ORDER BY continent_code) AS ct) AS ru
WHERE ru.ranked_usage = 1
ORDER BY ru.currency_usage DESC,
         ru.continent_code ASC,
         ru.currency_code ASC;

-- 20. The Highest Peak in Each Country
WITH "row_number"
         AS
         (SELECT c.country_name,
                 COALESCE(p.peak_name, '(no highest peak)')                                AS highest_peak_name,
                 COALESCE(p.elevation, 0)                                                  AS highest_peak_elevation,
                 COALESCE(m.mountain_range, '(no mountain)')                               AS mountain,
                 ROW_NUMBER() OVER (PARTITION BY c.country_name ORDER BY p.elevation DESC) AS row_num
          FROM countries AS c
                   LEFT JOIN
               mountains_countries AS mc
               USING
                   (country_code)
                   LEFT JOIN
               peaks AS p
               USING
                   (mountain_id)
                   LEFT JOIN
               mountains AS m
               ON
                   m.id = p.mountain_id)

SELECT country_name,
       highest_peak_name,
       highest_peak_elevation,
       mountain
FROM "row_number"
WHERE row_num = 1
ORDER BY country_name,
         highest_peak_elevation DESC;