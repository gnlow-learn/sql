WITH edited_names AS (
  SELECT
    original.name,
    original.year,
    original.count,
    100 * original.count / yearly_totals.total_count AS occupation
  FROM
    (
      SELECT name, year, count
      FROM "name_year"
      WHERE nameCountEvery > 500
        AND 1900 < year
        AND year < 2010
    ) AS original
  JOIN
    (SELECT year, SUM(count) AS total_count FROM "name_year" GROUP BY year) AS yearly_totals
  ON
    original.year = yearly_totals.year
),
ranked_names AS (
  SELECT
    name,
    MAX(occupation) as max_occupation,
    ROW_NUMBER() OVER (ORDER BY max_occupation DESC) AS rank
  FROM edited_names
  GROUP BY name
)
SELECT
  e.name,
  e.year,
  e.count,
  e.occupation,
  r.max_occupation,
  r.rank
FROM edited_names e
JOIN ranked_names r
ON e.name = r.name
WHERE r.rank <= 10
;