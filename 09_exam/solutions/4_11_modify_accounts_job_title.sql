CREATE OR REPLACE PROCEDURE udp_modify_account(
    address_street VARCHAR(30),
    address_town VARCHAR(30)
) AS
$$
BEGIN
    UPDATE accounts AS acc
    SET job_title = '(Remote) ' || job_title
    FROM addresses AS addr
    WHERE acc.id = addr.account_id
      AND addr.street = address_street
      AND addr.town = address_town;
END;
$$
    LANGUAGE plpgsql;
