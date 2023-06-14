CREATE OR REPLACE FUNCTION dates(c_date TIMESTAMP, cur_name VARCHAR)
RETURNS TABLE (name VARCHAR, rate_to_usd NUMERIC, updated TIMESTAMP) AS $$
	(SELECT name, rate_to_usd, updated
	FROM currency
	WHERE updated < c_date AND name = cur_name
	ORDER BY updated DESC
	LIMIT 1)
		UNION
	(SELECT name, rate_to_usd, updated
	FROM currency 
	WHERE updated > c_date AND name = cur_name
	ORDER BY updated ASC
	LIMIT 1)
$$ LANGUAGE SQL;

WITH spisok AS (
(SELECT 
		   COALESCE(u.name, 'not defined') AS name,
           COALESCE(u.lastname, 'not defined') As lastname,
           b.currency_id AS currency_id,
 		   b.money,
 		   b.updated
FROM "user" AS u
FULL JOIN balance AS b ON u.id = b.user_id
INNER JOIN currency AS c ON c.id = b.currency_id)
    INTERSECT all
(SELECT 
		   COALESCE(u.name, 'not defined') AS name,
           COALESCE(u.lastname, 'not defined') As lastname,
           b.currency_id AS currency_id,
 		   b.money,
 		   b.updated
FROM "user" AS u
FULL JOIN balance AS b ON u.id = b.user_id)
),
s_names AS (
  SELECT s.name, s.lastname, c.name as currency_name, s.money ,s.updated
	FROM spisok as s
	full JOIN currency as C ON s.currency_id = c.id
	GROUP BY s.name, s.lastname, c.name, s.updated, s.money
),
rt AS (
  	SELECT 
	name, lastname, currency_name, 
    (SELECT rate_to_usd FROM dates(updated, currency_name) LIMIT 1), 
  	money, updated
from s_names
)

SELECT name, lastname, currency_name, 
	(rate_to_usd*money)::real AS total, updated
FROM rt
ORDER BY 1 desc, 2, 3;