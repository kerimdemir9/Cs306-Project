-- Goktug Aygun 30608
-- Q1.b 
-- Detecting the set difference
SELECT CHD.iso_code -- has 10 countries
FROM countries_with_high_deaths CHD, countries_with_high_emission CHE
WHERE CHD.iso_code = CHE.iso_code;

DROP VIEW IF EXISTS Left_Outer;
CREATE VIEW Left_Outer AS
SELECT iso_code -- has 10 countries
FROM countries_with_high_deaths
EXCEPT
SELECT iso_code -- has 10 countries
FROM countries_with_high_emission;

SELECT * -- has 19 countries
FROM Left_Outer;

SELECT * -- has 19 countries
FROM countries_with_high_deaths LEFT JOIN countries_with_high_emission
ON countries_with_high_emission.iso_code = countries_with_high_deaths.iso_code 
WHERE countries_with_high_emission.iso_code IS NULL
-- tam olarak nasil calisiyor anlamadim // soru


-- creating smaller views to look for intersection
CREATE VIEW high_air_pollution_deaths AS
	SELECT iso_code -- has 23 countries
    FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
	WHERE APC.Average_Deaths_by_Outdoor_Air_Pollution > APWW.Average_Deaths_by_Outdoor_Air_Pollution_worldwide;
	
CREATE VIEW high_household_air_pollution_deaths AS
	SELECT iso_code -- has 21 countries
	FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
	WHERE APC.Average_Deaths_by_Household_Air_Pollution > APWW.Average_Deaths_by_Household_Air_Pollution_worldwide;
    

    
SELECT COUNT(*)
FROM high_air_pollution_deaths;

SELECT COUNT(*)
FROM high_household_air_pollution_deaths;


-- to check the number of elements in intersection
SELECT APD.iso_code -- has 15 countries 
FROM high_air_pollution_deaths APD, high_household_air_pollution_deaths HHAPD
WHERE APD.iso_code = HHAPD.iso_code

SELECT iso_code -- has 15 countries as well
FROM high_air_pollution_deaths APD
WHERE APD.iso_code IN 
(
		SELECT iso_code -- has 21 countries
		FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
		WHERE APC.Average_Deaths_by_Household_Air_Pollution > APWW.Average_Deaths_by_Household_Air_Pollution_worldwide
	)
    
SELECT iso_code -- also has 15 countries
FROM high_air_pollution_deaths APD
WHERE  EXISTS 
(
		SELECT iso_code -- has 21 countries
		FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
		WHERE APC.Average_Deaths_by_Household_Air_Pollution > APWW.Average_Deaths_by_Household_Air_Pollution_worldwide
        AND APD.iso_code = iso_code
	)
    
SELECT COUNT(*) -- also has 15 countries
FROM high_air_pollution_deaths APD
WHERE  EXISTS 
(
		SELECT iso_code -- has 21 countries
		FROM air_pollution_deaths_of_countries APC , air_pollution_deaths_worldwide APWW
		WHERE APC.Average_Deaths_by_Household_Air_Pollution > APWW.Average_Deaths_by_Household_Air_Pollution_worldwide
        AND APD.iso_code = iso_code
	)
-- showing in and exists is done. Q1.c is done




