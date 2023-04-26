-- Goktug Aygun 30608
-- FOR Q1.a
SELECT * 
FROM nature_deaths;

DROP VIEW IF EXISTS air_pollution_deaths_of_countries;
CREATE VIEW air_pollution_deaths_of_countries AS 
SELECT iso_code,
	AVG(deaths_by_outdoor_air_pollution) AS Average_Deaths_by_Outdoor_Air_Pollution,
	AVG(deaths_by_household_air_pollution_from_solid_fuels) AS Average_Deaths_by_Household_Air_Pollution,
	AVG(deaths_by_air_pollution) AS Average_Deaths_by_Air_Pollution
FROM nature_deaths
GROUP BY iso_code;

SELECT *
FROM air_pollution_deaths_of_countries;

DROP VIEW IF EXISTS air_pollution_deaths_worldwide;
CREATE VIEW air_pollution_deaths_worldwide AS 
SELECT "WORLDWIDE",
	AVG(Average_Deaths_by_Outdoor_Air_Pollution) AS Average_Deaths_by_Outdoor_Air_Pollution_worldwide,
	AVG(Average_Deaths_by_Household_Air_Pollution) AS Average_Deaths_by_Household_Air_Pollution_worldwide,
	AVG(Average_Deaths_by_Air_Pollution) AS Average_Deaths_by_Air_Pollution_worldwide
FROM air_pollution_deaths_of_countries;

SELECT *
FROM air_pollution_deaths_worldwide;

DROP VIEW IF EXISTS countries_with_high_deaths;
CREATE VIEW countries_with_high_deaths AS
	SELECT iso_code -- has 23 countries
    FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
	WHERE APC.Average_Deaths_by_Outdoor_Air_Pollution > APWW.Average_Deaths_by_Outdoor_Air_Pollution_worldwide
	UNION
	SELECT iso_code -- has 21 countries
	FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
	WHERE APC.Average_Deaths_by_Household_Air_Pollution > APWW.Average_Deaths_by_Household_Air_Pollution_worldwide
	UNION
	SELECT iso_code -- has 25 countries
	FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
	WHERE APC.Average_Deaths_by_Air_Pollution > APWW.Average_Deaths_by_Air_Pollution_worldwide;
    
SELECT iso_code -- has 29 countries that have above average death numbers due to air pollution
FROM countries_with_high_deaths;




