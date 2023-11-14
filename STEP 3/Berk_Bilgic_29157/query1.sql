SELECT * FROM nature_deaths;
SELECT COUNT(*) FROM nature_deaths;
SELECT * FROM countries;

CREATE TABLE nature_deaths (
    iso_code VARCHAR(35) NOT NULL,
	year INT,
    deaths_by_outdoor_air_pollution INT,
    deaths_by_unsafe_water_source INT,
    deaths_by_household_air_pollution_from_solid_fuels INT,
    deaths_by_air_pollution INT,
    deaths_by_unsafe_sanitation INT,
	PRIMARY KEY (iso_code, year),
	FOREIGN KEY (iso_code) REFERENCES countries(iso_code) ON DELETE CASCADE
);
ALTER TABLE nature_deaths ADD COLUMN total_nature_deaths INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE nature_deaths SET total_nature_deaths = (deaths_by_outdoor_air_pollution+
deaths_by_unsafe_water_source+deaths_by_household_air_pollution_from_solid_fuels+
deaths_by_air_pollution+deaths_by_unsafe_sanitation);

SELECT * FROM nature_deaths N WHERE N.deaths_by_unsafe_water_source=(SELECT MAX(deaths_by_unsafe_water_source) FROM nature_deaths);

SET @max_deaths_by_unsafe_water_source= (SELECT MAX(deaths_by_unsafe_water_source) FROM nature_deaths);
SET @min_deaths_by_unsafe_water_source= (SELECT MIN(deaths_by_unsafe_water_source) FROM nature_deaths);
SELECT @min_deaths_by_unsafe_water_source;

ALTER TABLE nature_deaths ADD CONSTRAINT range_death
CHECK (0 <= deaths_by_unsafe_water_source AND 2450944 >= deaths_by_unsafe_water_source);

ALTER TABLE nature_deaths DROP CONSTRAINT range_death;

INSERT INTO nature_deaths
VALUES('AFG', 2020 , 12000, 2450945, 34000, 37000, 3000, 80000);

DELETE FROM nature_deaths WHERE iso_code='AFG' AND year=2020;

DELIMITER //
CREATE TRIGGER range_checker
BEFORE INSERT ON nature_deaths
FOR EACH ROW
BEGIN
	IF NEW.deaths_by_unsafe_water_source < @min_deaths_by_unsafe_water_source THEN
		SET NEW.deaths_by_unsafe_water_source = @min_deaths_by_unsafe_water_source;
	ELSEIF NEW.deaths_by_unsafe_water_source > @max_deaths_by_unsafe_water_source THEN
		SET NEW.deaths_by_unsafe_water_source = @max_deaths_by_unsafe_water_source;
    END IF;
END//
DELIMITER ;
DROP TRIGGER range_checker;

DELIMITER //
CREATE TRIGGER range_checker_update
BEFORE UPDATE ON nature_deaths
FOR EACH ROW
BEGIN
	IF NEW.deaths_by_unsafe_water_source < @min_deaths_by_unsafe_water_source THEN
		SET NEW.deaths_by_unsafe_water_source = @min_deaths_by_unsafe_water_source;
	ELSEIF NEW.deaths_by_unsafe_water_source > @max_deaths_by_unsafe_water_source THEN
		SET NEW.deaths_by_unsafe_water_source = @max_deaths_by_unsafe_water_source;
    END IF;
END//
DELIMITER ;
DROP TRIGGER range_checker_update;

DELIMITER //
CREATE PROCEDURE iso_unsafe_sanitation_and_air_pollution(IN param VARCHAR(35))
BEGIN
	SELECT year, deaths_by_air_pollution + deaths_by_unsafe_sanitation AS air_and_sanitation 
    FROM nature_deaths 
    WHERE iso_code=param;
END//
DELIMITER ;
DROP PROCEDURE iso_unsafe_sanitation_and_air_pollution;

CALL iso_unsafe_sanitation_and_air_pollution ('AFG');
    