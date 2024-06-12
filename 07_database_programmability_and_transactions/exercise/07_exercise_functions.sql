-- 01. User-defined Function Full Name
CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR(50), last_name VARCHAR(50))
    RETURNS VARCHAR(101) AS
$$
BEGIN
    IF first_name IS NULL OR last_name IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN INITCAP(
            CONCAT_WS(' ',
                      first_name, last_name));
END;
$$
    LANGUAGE plpgsql;

-- 02. User-defined Function Future Value
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
    initial_sum DECIMAL,
    yearly_interest_rate DECIMAL,
    number_of_years DECIMAL
) RETURNS DECIMAL AS
$$
DECLARE
    future_value DECIMAL;
BEGIN
    future_value := TRUNC(
            initial_sum * (1 + yearly_interest_rate) ^ number_of_years, 4);

    RETURN future_value;
END;
$$
    LANGUAGE plpgsql;

-- 03. User-defined Function Is Word Comprised
CREATE OR REPLACE FUNCTION fn_is_word_comprised(
    set_of_letters VARCHAR(50),
    word           VARCHAR(50)
) RETURNS BOOLEAN AS
$$
BEGIN
        set_of_letters := LOWER(set_of_letters);
        word           := LOWER(word);

        RETURN TRIM(word, set_of_letters) = '';
END;
$$
    LANGUAGE plpgsql;