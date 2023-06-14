WITH t1 AS (
	SELECT COALESCE(u.name, 'not defined')     AS name,
           COALESCE(u.lastname, 'not defined') As lastname,
           b.type                              AS type,
           SUM(b.money)                        AS volume,
           b.currency_id
    FROM "user" AS u
    FULL JOIN balance b ON u.id = b.user_id
    GROUP BY b.type,
             u.lastname,
             u.name, currency_id
),
ska AS (SELECT t1.name,
                    t1.lastname,
                    t1.type,
                    t1.volume,
                    COALESCE(cur.name, 'not defined') AS currency_name,
                    t1.currency_id
             FROM currency AS cur
             FULL JOIN t1 ON t1.currency_id = cur.id
             GROUP BY t1.name,
                      t1.lastname,
                      t1.type,
                      t1.volume,
                      COALESCE(cur.name, 'not defined'),
                      t1.currency_id
),
t2 AS (
  SELECT cur.id, cur.name, rate_to_usd, max
  FROM currency AS cur
  JOIN (
         SELECT id, MAX(updated) AS max
         FROM currency
         GROUP BY 1
       ) AS last ON cur.id = last.id AND last.max = cur.updated
)

SELECT ska.name,
       lastname,
       type,
       volume,
       currency_name,
       COALESCE(rate_to_usd, 1) AS last_rate_to_usd,
       COALESCE((volume * rate_to_usd), volume)::real AS total_volume_in_usd
FROM ska
    LEFT JOIN t2 ON t2.id = ska.currency_id
ORDER BY 1 DESC, 2 ASC,3 ASC;