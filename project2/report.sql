SELECT r.review_date, b.name, AVG(r.stars) AS avg_stars, te.min, te.max, p.precipitation, p.precipitation_normal, b.city, b.state
FROM fact_review             AS r
LEFT JOIN dim_business       AS b  ON r.business_id = b.business_id
LEFT JOIN dim_temperature    AS te ON r.review_date = te.date
LEFT JOIN dim_precipitation  AS p ON r.review_date = p.date
GROUP BY r.review_date, b.name, te.min, te.max, p.precipitation, p.precipitation_normal, b.city, b.state
ORDER BY r.review_date DESC;