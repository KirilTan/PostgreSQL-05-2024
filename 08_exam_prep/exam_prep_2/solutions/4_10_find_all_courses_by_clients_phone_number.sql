CREATE OR REPLACE FUNCTION fn_courses_by_client(
    phone_num VARCHAR(20)
) RETURNS INT AS
$$
BEGIN
    RETURN (SELECT COUNT(c.id)
            FROM courses AS c
                     JOIN clients AS cl
                          ON c.client_id = cl.id
            WHERE cl.phone_number = phone_num);
END;
$$
    LANGUAGE plpgsql;