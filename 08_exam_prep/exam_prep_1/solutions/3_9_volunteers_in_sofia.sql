SELECT v.name                                               AS volunteers,
       v.phone_number,
       TRIM(BOTH ', ' FROM REPLACE(v.address, 'Sofia', '')) AS address
FROM volunteers AS v
         JOIN
     volunteers_departments AS vd ON v.department_id = vd.id
WHERE v.address LIKE '%Sofia%'
            AND
      vd.department_name = 'Education program assistant'
ORDER BY v.name;
