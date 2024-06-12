-- 04. Game Over
CREATE OR REPLACE FUNCTION fn_is_game_over(
    is_game_over BOOLEAN
)
    RETURNS TABLE
            (
                name         VARCHAR(50),
                game_type_id INT,
                is_finished  BOOLEAN
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT g.name,
               g.game_type_id,
               g.is_finished
        FROM games AS g
        WHERE g.is_finished = is_game_over;
END;
$$
    LANGUAGE plpgsql;

-- 05. Difficulty Level
CREATE OR REPLACE FUNCTION fn_difficulty_level(
    level INT
) RETURNS VARCHAR(20) AS
$$
DECLARE
    difficulty_level VARCHAR(20);

BEGIN
    IF level <= 40 THEN
        difficulty_level := 'Normal Difficulty';
    ELSIF level BETWEEN 41 AND 60 THEN
        difficulty_level := 'Nightmare Difficulty';
    ELSE
        difficulty_level := 'Hell Difficulty';
    END IF;

    RETURN difficulty_level;
END;
$$
    LANGUAGE plpgsql;

SELECT user_id,
       level,
       cash,
       fn_difficulty_level(level) AS difficulty_level
FROM users_games
ORDER BY user_id;

-- 06. Cash in User Games Odd Rows
CREATE OR REPLACE FUNCTION fn_cash_in_users_games(
    game_name VARCHAR(50)
)
    RETURNS TABLE
            (
                total_cash NUMERIC
            )
AS
$$
BEGIN
    RETURN QUERY
        WITH ranked_games AS (SELECT cash,
                                     ROW_NUMBER() OVER (ORDER BY cash DESC) AS row_num
                              FROM users_games AS ug
                                       JOIN
                                   games AS g
                                   ON
                                       ug.game_id = g.id
                              WHERE g.name = game_name)

        SELECT ROUND(SUM(cash), 2) AS total_cash
        FROM ranked_games AS rg
        WHERE rg.row_num % 2 <> 0;
END;
$$
    LANGUAGE plpgsql;