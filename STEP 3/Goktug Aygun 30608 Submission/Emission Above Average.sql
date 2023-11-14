-- Goktug Aygun 30608
-- FOR Q1.a
-- Creating View for Emission Values of Each Country
DROP VIEW IF EXISTS Average_Emission;
CREATE VIEW Average_Emission AS
SELECT iso_code,
AVG(nitrogen_oxide_in_tonnes_NOx) as "Emission_of_NOx_in_Tonnes",
AVG(sulphur_dioxide_in_tonnes_SO2) as "Emission_of_SO2_in_Tonnes",
AVG(carbon_monoxide_in_tonnes_CO) as "Emission_of_CO_in_Tonnes",
AVG(ammonia_in_tonnes_NH3) as "Emission_of_NH3_in_Tonnes"
FROM emissions
-- WHERE AVG(AVG(nitrogen_oxide_in_tonnes_NOx),AVG(sulphur_dioxide_in_tonnes_SO2),AVG(carbon_monoxide_in_tonnes_CO),AVG(ammonia_in_tonnes_NH3))
GROUP BY iso_Code;


-- Control Querries Start
SELECT *
FROM Average_Emission;

SELECT *
FROM Worldwide_Emissions;
-- Control Querries End

RENAME TABLE Average_Emission
TO Average_Emission_by_Countries;

-- Control Querries Start (with updated names)
SELECT *
FROM Average_Emission_by_Countries;

SELECT *
FROM Worldwide_Emissions;
-- Control Querries End (with updated names)

SELECT * 
FROM Average_Emission_by_Countries;

-- Creating View for Worldwide Average Emission Values
DROP VIEW IF EXISTS Worldwide_Emissions;
CREATE VIEW Worldwide_Emissions AS 
SELECT 
		"Worldwide",
		AVG(Emission_of_NOx_in_Tonnes) as "Average_emission_NOx_in_Tonnes", 
		AVG(Emission_of_SO2_in_Tonnes) as "Emission_of_SO2_in_Tonnes", 
		AVG(Emission_of_CO_in_Tonnes) as "Average_emission_CO_in_Tonnes", 
		AVG(Emission_of_NH3_in_Tonnes) as "Average_emission_NH3_in_Tonnes" 
		FROM Average_Emission_by_Countries;

	


DROP VIEW IF EXISTS countries_with_high_emission;
CREATE VIEW countries_with_high_emission AS
	SELECT iso_code -- has 21 countries
				FROM Average_Emission_by_Countries AC , Worldwide_Emissions WW
				WHERE AC.Emission_of_NOx_in_Tonnes > WW.Average_emission_NOx_in_Tonnes
				UNION
				SELECT iso_code -- has 24 countries
				FROM Average_Emission_by_Countries AC , Worldwide_Emissions WW
				WHERE AC.Emission_of_SO2_in_Tonnes > WW.Emission_of_SO2_in_Tonnes
				UNION
				SELECT iso_code -- has 17 countries
				FROM Average_Emission_by_Countries AC , Worldwide_Emissions WW
				WHERE AC.Emission_of_CO_in_Tonnes > WW.Average_emission_CO_in_Tonnes
				UNION
				SELECT iso_code -- has 17 countries
				FROM Average_Emission_by_Countries AC , Worldwide_Emissions WW
				WHERE AC.Emission_of_NH3_in_Tonnes > WW.Average_emission_NH3_in_Tonnes;
            
SELECT COUNT(*) -- has 32 countries that have above average emission numbers
FROM countries_with_high_emission;
