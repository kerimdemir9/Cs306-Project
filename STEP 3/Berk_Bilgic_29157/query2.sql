CREATE VIEW average_deaths_by_year AS
SELECT year,
       AVG(deaths_by_outdoor_air_pollution) AS avg_outdoor_pollution, 
       AVG(deaths_by_unsafe_water_source) AS avg_unsafe_water,
       AVG(deaths_by_household_air_pollution_from_solid_fuels ) AS avg_household_air_pollution,
       AVG(deaths_by_air_pollution) AS avg_air_pollution,
       AVG(deaths_by_unsafe_sanitation) AS avg_unsafe_sanitation
FROM nature_deaths
GROUP BY year;
SELECT * FROM average_deaths_by_year;

CREATE VIEW average_comparision AS
SELECT nature_deaths.iso_code, nature_deaths.year
FROM nature_deaths
INNER JOIN average_deaths_by_year ON nature_deaths.year = average_deaths_by_year.year
WHERE nature_deaths.deaths_by_outdoor_air_pollution > average_deaths_by_year.avg_outdoor_pollution 
AND nature_deaths.deaths_by_unsafe_water_source > average_deaths_by_year.avg_unsafe_water;

SELECT * FROM average_comparision;

SELECT countries.name
FROM countries
WHERE countries.iso_code IN (SELECT iso_code FROM average_comparision);

SELECT countries.name
FROM countries
WHERE EXISTS (SELECT iso_code FROM average_comparision WHERE average_comparision.iso_code=countries.iso_code);



