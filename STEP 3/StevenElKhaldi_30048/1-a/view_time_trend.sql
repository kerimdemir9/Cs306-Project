# create view to show development of number of deaths by nutritional deficiencies in the world over time
CREATE VIEW nutritional_deficiencies_diet_deaths_period AS
SELECT SUM(deaths_by_nutritional_deficiencies) AS total_deaths_by_nutritional_deficiencies,
AVG(deaths_by_nutritional_deficiencies) AS avg_deaths_by_nutritional_deficiencies_per_country,
COUNT(*) AS num_countries,
year
FROM diet_deaths
GROUP BY year;