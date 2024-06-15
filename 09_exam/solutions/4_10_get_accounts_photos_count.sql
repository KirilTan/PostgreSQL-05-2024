CREATE OR REPLACE FUNCTION udf_accounts_photos_count(account_username VARCHAR(30))
    RETURNS INT AS
$$
BEGIN
    RETURN (SELECT COUNT(*)
            FROM accounts AS a
                     JOIN accounts_photos AS ap
                          ON ap.account_id = a.id
            WHERE a.username = account_username);
END;
$$
    LANGUAGE plpgsql;
