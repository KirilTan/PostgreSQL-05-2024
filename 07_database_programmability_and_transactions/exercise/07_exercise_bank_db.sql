-- 07. Retrieving Account Holders
CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(
    searched_balance DECIMAL
) AS
$$
DECLARE
    account_holder_info RECORD;
BEGIN
    FOR account_holder_info IN
        SELECT CONCAT_WS(' ',
                         ah.first_name, ah.last_name) AS full_name,
               SUM(balance)                           AS total_balance
        FROM accounts AS a
                 JOIN
             account_holders AS ah
             ON a.account_holder_id = ah.id
        GROUP BY full_name
        HAVING SUM(balance) > searched_balance
        ORDER BY SUM(balance) DESC
        LOOP
            RAISE NOTICE '% - %', account_holder_info.full_name, account_holder_info.total_balance;
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

-- 08. Deposit Money
CREATE OR REPLACE PROCEDURE sp_deposit_money(
    account_id INT,
    money_amount NUMERIC
) AS
$$
BEGIN
    UPDATE accounts
    SET balance = balance + money_amount
    WHERE id = account_id;
END;
$$
    LANGUAGE plpgsql;

-- 09. Withdraw Money
CREATE OR REPLACE PROCEDURE sp_withdraw_money(
    account_id INTEGER,
    money_amount NUMERIC
) AS
$$
DECLARE
    account_balance NUMERIC;
BEGIN
    SELECT INTO account_balance a.balance
    FROM accounts AS a
    WHERE a.id = account_id;

    IF account_balance < money_amount THEN
        RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
    ELSE
        UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = account_id;
    END IF;
END;
$$
    LANGUAGE plpgsql;

-- 10. Money Transfer
CREATE OR REPLACE PROCEDURE sp_transfer_money(
    sender_id INT,
    receiver_id INT,
    amount NUMERIC(4)
)
AS
$$
DECLARE
    current_balance NUMERIC;
BEGIN
    CALL sp_withdraw_money(sender_id, amount);
    CALL sp_deposit_money(receiver_id, amount);

    SELECT balance INTO current_balance FROM accounts WHERE id = sender_id;

    IF current_balance < 0 THEN
        ROLLBACK;
    END IF;
END;
$$
    LANGUAGE plpgsql;

-- 11. Delete Procedure
DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;

-- 12. Log Accounts Trigger
CREATE TABLE logs
(
    id         SERIAL PRIMARY KEY,
    account_id INT,
    old_sum    NUMERIC,
    new_sum    NUMERIC
);

CREATE FUNCTION trigger_fn_insert_new_entry_into_logs()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO logs(account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_account_balance_change
    AFTER UPDATE OF balance
    ON accounts
    FOR EACH ROW
    WHEN (OLD.balance <> NEW.balance)
EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs()

-- 13. Notification Email on Balance Change
CREATE TABLE IF NOT EXISTS notification_emails
(
    id           SERIAL PRIMARY KEY,
    recipient_id INT,
    subject      VARCHAR(255),
    body         TEXT
);

CREATE OR REPLACE FUNCTION
    trigger_fn_send_email_on_balance_change()
    RETURNS TRIGGER
AS
$$
BEGIN
    INSERT INTO notification_emails(recipient_id, subject, body)
    VALUES (NEW.account_id,
            'Balance change for account: ' || NEW.account_id,
            'On ' || DATE(NOW()) || ' your balance was changed from ' || NEW.old_sum || ' to ' || NEW.new_sum || '.');

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER
    tr_send_email_on_balance_change
    AFTER UPDATE
    ON
        logs
    FOR EACH ROW
    WHEN
        (OLD.new_sum <> NEW.new_sum)
EXECUTE FUNCTION
    trigger_fn_send_email_on_balance_change();
