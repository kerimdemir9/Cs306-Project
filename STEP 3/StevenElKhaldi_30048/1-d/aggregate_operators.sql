# avg (returns 25 rows)
SELECT C.name as country, D.iso_code as iso_code, AVG(D.deaths_by_diet_low_in_fruits) as yearly_avg_deaths_by_diet_low_in_fruits
FROM diet_deaths D
JOIN countries C ON D.iso_code = C.iso_code
GROUP BY C.name, D.iso_code
HAVING AVG(D.deaths_by_diet_low_in_fruits) > (SELECT AVG(deaths_by_diet_low_in_fruits) FROM diet_deaths);

# min (returns 283 rows)
SELECT C.name as country, D.iso_code as iso_code, MIN(D.deaths_by_nutritional_deficiencies) as min_deaths_by_nutritional_deficiencies, D.year as year
FROM diet_deaths D
JOIN countries C ON D.iso_code = C.iso_code
GROUP BY C.name, D.iso_code, D.year
HAVING MIN(D.deaths_by_nutritional_deficiencies) = (SELECT MIN(deaths_by_nutritional_deficiencies) FROM diet_deaths);

# max (returns 1 row)
SELECT C.name as country, D.iso_code as iso_code, MAX(D.deaths_by_nutritional_deficiencies) as max_deaths_by_nutritional_deficiencies, D.year as year
FROM diet_deaths D
JOIN countries C ON D.iso_code = C.iso_code
GROUP BY C.name, D.iso_code, D.year
HAVING MAX(D.deaths_by_nutritional_deficiencies) = (SELECT MAX(deaths_by_nutritional_deficiencies) FROM diet_deaths);

# count (returns 211 rows)
SELECT count(*) AS times_below_avg_deaths_by_iron_deficiency, C.name as country, D.iso_code as iso_code
FROM diet_deaths D
JOIN countries C on D.iso_code = C.iso_code
WHERE D.deaths_by_iron_deficiency < (SELECT AVG(deaths_by_iron_deficiency) from diet_deaths)
GROUP BY C.name, D.iso_code;

# sum (returns 30 rows)
SELECT D.year as year, SUM(D.deaths_by_nutritional_deficiencies) AS total_deaths_by_nutritional_deficiencies, 
       (SELECT C.name FROM countries C
        JOIN diet_deaths D1 ON C.iso_code = D1.iso_code
        WHERE D1.year = D.year AND D1.iso_code != "WWW"
        ORDER BY D1.deaths_by_nutritional_deficiencies DESC 
        LIMIT 1) AS max_deaths_country
FROM diet_deaths D
JOIN countries C ON D.iso_code = C.iso_code
GROUP BY D.year;