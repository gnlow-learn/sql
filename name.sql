WITH edited_names AS (
  SELECT
    name,
    original.year,
    count,
    100 * count / yearly_totals.total_count AS occupation
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
group_by_name AS (
  SELECT
    name,
    MAX(occupation) AS max_occupation,
    ROW_NUMBER() OVER (ORDER BY max_occupation DESC) AS rank
  FROM edited_names
  GROUP BY name
)
SELECT
  e.name,
  year,
  count,
  occupation,
  max_occupation,
  rank
FROM edited_names e
JOIN group_by_name n
  ON e.name = n.name

WHERE n.rank <= 10
;