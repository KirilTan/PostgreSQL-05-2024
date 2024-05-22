-- 01. River Info
CREATE OR REPLACE VIEW
    view_river_info
AS
SELECT
    CONCAT_WS(' ',
        'The river',
        river_name,
        'flows into the',
        outflow,
        'and is',
        "length",
        'kilometers long.')
    AS
        "River Information"
FROM
    rivers
ORDER BY
    river_name
;

-- 02. Concatenate Geography Data
CREATE or REPLACE VIEW
    view_continents_countries_currencies_details
AS
SELECT
    CONCAT_WS(': ',
        continents.continent_name,
        continents.continent_code)
    AS
        continent_details,

    CONCAT_WS(' - ',
        countries.country_name,
        countries.capital,
        countries.area_in_sq_km,
        'km2')
    AS
        country_information,

    CONCAT(
        currencies.description,
        ' (',
        countries.currency_code,
        ')')
    AS
        currencies
FROM
    continents,
    countries,
    currencies
WHERE
    continents.continent_code = countries.continent_code
        AND
    countries.currency_code = currencies.currency_code
ORDER BY
    country_information,
    currencies
;

-- 03. Capital Code
ALTER TABLE
    countries
ADD COLUMN
    capital_code CHAR(2)
;

UPDATE
    countries
SET
    capital_code = LEFT(capital, 2)

RETURNING *
;

-- 04. (Descr)iption
SELECT
    RIGHT(description, -4)
FROM
    currencies;

-- 05. Substring River Length
SELECT
    SUBSTRING("River Information", '[0-9]{1,4}') AS river_length
FROM
    view_river_info
;

-- 06. Replace A
SELECT
    REPLACE(mountain_range, 'a', '@') AS "replace_a",
    REPLACE(mountain_range, 'A', '$') AS "replace_A"
FROM
    mountains
;

-- 07. Translate
SELECT
    capital,
    TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS "translated_name"
FROM
    countries
;

-- 08. LEADING
SELECT
    continent_name,
    LTRIM(continent_name) AS "trim"
FROM
    continents
;

-- 09. TRAILING
SELECT
    continent_name,
    RTRIM(continent_name) AS "trim"
FROM
    continents
;

-- 10. LTRIM & RTRIM
SELECT
    LTRIM(peak_name, 'M') AS "left_trim",
    RTRIM(peak_name, 'm') AS "right_trim"
FROM
    peaks
;

-- 11. Character Length and Bits
SELECT
    CONCAT_WS(' ',
        m.mountain_range,
        p.peak_name)
    AS
        "mountain_information",

    CHAR_LENGTH(CONCAT_WS(' ', m.mountain_range, p.peak_name))
    AS
        "characters_length",

    BIT_LENGTH(CONCAT_WS(' ', m.mountain_range, p.peak_name))
    AS
        "bits_of_a_tring"

FROM
    mountains AS m,
    peaks AS p
WHERE
    m.id = p.mountain_id
;

-- 12. Length of a Number
SELECT
    population,

    LENGTH(population::TEXT) AS "lenght"
FROM
    countries
;

-- 13. Positive and Negative LEFT
SELECT
    peak_name,

    LEFT(peak_name, 4) AS "positive_left",
    LEFT(peak_name, -4) AS "negative_left"
FROM
    peaks
;

-- 14. Positive and Negative RIGHT
SELECT
    peak_name,

    RIGHT(peak_name, 4) AS "positive_right",
    RIGHT(peak_name, -4) AS "negative_right"
FROM
    peaks
;

-- 15. Update iso_code
UPDATE
    countries
SET
    iso_code = UPPER(LEFT(country_name, 3))
WHERE
    iso_code IS NULL
RETURNING
    *
;

-- 16. REVERSE country_code
UPDATE
    countries
SET
   country_code = LOWER(REVERSE(country_code))
;

-- 17. Elevation --->> Peak Name
SELECT
    CONCAT_WS(' ',
        p.elevation,
        REPEAT('-', 3) || REPEAT('>', 2),
        p.peak_name)
FROM
    peaks AS p
WHERE
    p.elevation >= 4884
;


