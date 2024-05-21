-- 01. Find Book Titles
SELECT
    title
FROM
    books
WHERE
    substring(title, 1, 3) = 'The'
;

-- 02. Replace Titles
SELECT
    replace(title, 'The', '***')
FROM
    books
WHERE
    left(title, 3) = 'The'
;

-- 03. Triangles on Bookshelves
SELECT
    id,
    side * height / 2 AS area
FROM
    triangles
;

-- 04. Format Costs
SELECT
    title,
    ROUND(cost, 3) AS modified_price
FROM books
;

-- 05. Year of Birth
SELECT
    first_name,
    last_name,
    EXTRACT(year FROM born) AS year
FROM
    authors
;

-- 06. Format Date of Birth
SELECT
    last_name AS "Last Name",
    TO_CHAR(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM authors
;

-- 07. Harry Potter Books
SELECT
    title
FROM books
WHERE title LIKE '%Harry Potter%'
;