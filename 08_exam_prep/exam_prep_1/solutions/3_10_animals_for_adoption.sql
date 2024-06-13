SELECT a.name                       AS animal,
       TO_CHAR(a.birthdate, 'YYYY') AS birth_year,
       at.animal_type
FROM animals AS a
         JOIN
     animal_types AS at
     ON
         a.animal_type_id = at.id
WHERE a.owner_id IS NULL
            AND
      a.animal_type_id <> 3
            AND
      EXTRACT(YEAR FROM AGE('2022-01-01'::DATE, a.birthdate)) < 5
ORDER BY a.name;
