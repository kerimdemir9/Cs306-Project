# create view to show countries with above average deaths due to nutritional deficiencies
CREATE VIEW above_average_diet_deaths_by_nutritional_deficiencies AS
SELECT count(*) as num_years, iso_code from diet_deaths
WHERE deaths_by_nutritional_deficiencies > (select avg(deaths_by_nutritional_deficiencies) from diet_deaths)
GROUP BY iso_code;

# create view to show countries with above average deaths due to diet low in fruits
CREATE VIEW above_average_diet_deaths_by_diet_low_in_fruits AS
SELECT count(*) AS num_years, iso_code from diet_deaths
WHERE deaths_by_diet_low_in_fruits > (select avg(deaths_by_diet_low_in_fruits) from diet_deaths)
GROUP BY iso_code;

# create view to show countries with above average deaths due to diet low in whole grains
CREATE VIEW above_average_diet_deaths_by_diet_low_in_whole_grains AS
SELECT count(*) AS num_years, iso_code from diet_deaths
WHERE deaths_by_diet_low_in_whole_grains > (select avg(deaths_by_diet_low_in_whole_grains) from diet_deaths)
GROUP BY iso_code;