WITH
t1 AS (
  SELECT
    name,
    year,
    count
  FROM
    (
      SELECT name, year, count
      FROM "name_year"
      WHERE nameCountEvery > 500
        AND 1900 < year
        AND year < 2010
    )
),
group_by_year AS (
  SELECT
    year,
    SUM(count) AS total_count
  FROM t1
  GROUP BY year
),
t2 AS (
  SELECT
    name,
    src.year,
    count,
    100 * count / y.total_count AS occupation
  FROM t1 src
  JOIN group_by_year y
    ON src.year = y.year
),
group_by_name AS (
  SELECT
    name,
    MAX(occupation) AS max_occupation,
    ROW_NUMBER() OVER (ORDER BY max_occupation DESC) AS rank
  FROM t2
  GROUP BY name
)
SELECT
  src.name,
  year,
  count,
  occupation,
  max_occupation,
  rank
FROM t2 src
JOIN group_by_name n
  ON src.name = n.name
WHERE n.rank <= 10
;