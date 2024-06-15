SELECT CONCAT_WS(' ',
                 acc.id,
                 acc.username) AS id_username,
       acc.email
FROM accounts AS acc
         JOIN accounts_photos AS ap
              ON acc.id = ap.account_id
         JOIN photos AS p
              ON ap.photo_id = p.id
WHERE acc.id = p.id
ORDER BY acc.id;