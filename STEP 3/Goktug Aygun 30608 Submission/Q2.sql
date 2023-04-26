SELECT * FROM `cs306-project`.nature_deaths;


-- // soru q2
set @bottom = (SELECT MIN(deaths_by_unsafe_water_source) FROM nature_deaths);
set @top = (SELECT MAX(deaths_by_unsafe_water_source) FROM nature_deaths);
ALTER TABLE nature_deaths 
DROP CONSTRAINT check_interval;

ALTER TABLE nature_deaths 
ADD CONSTRAINT check_interval 
CHECK (deaths_by_unsafe_water_source >= 0 AND deaths_by_unsafe_water_source <= 2450944);

/*
CREATE TRIGGER control BEFORE INSERT ON nature_deaths

CREATE TRIGGER control BEFORE UPDATE ON nature_deaths
*/
select  MIN(deaths_by_unsafe_water_source), MAX(deaths_by_unsafe_water_source) 
from nature_deaths;

DROP Procedure IF EXISTS get_death_numbers;
DELIMITER //
CREATE PROCEDURE get_death_numbers (IN iso_code1 VARCHAR(5))  
BEGIN  
    SELECT iso_code as "Country Code", year, 
    deaths_by_unsafe_water_source as "Deaths by Unsafe Water Source", 
    deaths_by_unsafe_sanitation as "Deaths by Unsafe Sanitation"
    FROM nature_deaths nd
    WHERE nd.iso_code = iso_code1;     
END//  
DELIMITER ;  


CALL get_death_numbers("AFG");
CALL get_death_numbers("GBR");

DROP TRIGGER IF EXISTS control;
INSERT INTO nature_deaths VALUES ("AFG", 2020, 10, -1, 10, 10, 10); -- expecting to get error 
-- Got "Error Code: 3819. Check constraint 'check_interval' is violated." as a result 
-- because constraint called "check_interval" prevents negative values to be entered

INSERT INTO nature_deaths VALUES ("AFG", 2020, 10, 2450945, 10, 10, 10); -- expecting to get error 
-- Got "Error Code: 3819. Check constraint 'check_interval' is violated." again as a result 
-- because constraint called "check_interval" prevents values greater than 2450944 to be entered



DROP TRIGGER IF EXISTS control_insert;
delimiter //
CREATE TRIGGER control_insert BEFORE INSERT ON `nature_deaths`
FOR EACH ROW
BEGIN
	SET @bottom = CAST((SELECT MIN(CAST(deaths_by_unsafe_water_source AS SIGNED)) FROM nature_deaths) AS UNSIGNED);
	SET @top = CAST((SELECT MAX(CAST(deaths_by_unsafe_water_source AS SIGNED)) FROM nature_deaths) AS UNSIGNED);
    IF new.deaths_by_unsafe_water_source > @top THEN SET new.deaths_by_unsafe_water_source = @top; END IF;
    IF new.deaths_by_unsafe_water_source < @bottom THEN SET new.deaths_by_unsafe_water_source = @bottom; END IF;
END;//
delimiter ;;



DROP TRIGGER IF EXISTS control_update;
delimiter // 
CREATE TRIGGER control_update BEFORE UPDATE ON `nature_deaths`
FOR EACH ROW
BEGIN
	SET @bottom = CAST((SELECT MIN(CAST(deaths_by_unsafe_water_source AS SIGNED)) FROM nature_deaths) AS UNSIGNED);
	SET @top = CAST((SELECT MAX(CAST(deaths_by_unsafe_water_source AS SIGNED)) FROM nature_deaths) AS UNSIGNED);
    IF new.deaths_by_unsafe_water_source > @top THEN SET new.deaths_by_unsafe_water_source = @top; END IF;
    IF new.deaths_by_unsafe_water_source < @bottom THEN SET new.deaths_by_unsafe_water_source = @bottom; END IF;
END;//
delimiter ;;


CALL get_death_numbers("TUR");

INSERT INTO nature_deaths VALUES("TUR", 2020, 10, -1, 10, 10, 10);
-- we can see that the value is rounded up to 0, instead of being 
-- treated as an unsigned integer being rounded down to '2450944'
INSERT INTO nature_deaths VALUES("TUR", 2021, 10, 2450945, 10, 10, 10);
-- we can see that the value is rounded down to '2450944', because 
-- we are using the "control_insert" trigger which prevents inserting
-- values outside of a given interval which is min-max or 0-2450944


/*
these lines are used to treat the values as signed instead of unsigned
SET @bottom = CAST((SELECT MIN(CAST(deaths_by_unsafe_water_source AS SIGNED)) FROM nature_deaths) AS UNSIGNED);
SET @top = CAST((SELECT MAX(CAST(deaths_by_unsafe_water_source AS SIGNED)) FROM nature_deaths) AS UNSIGNED);
*/

SET SQL_SAFE_UPDATES = 0; 
-- I used this line to be able to execute the below statement
-- This time I fixed my trigger and tried again.
DELETE FROM nature_deaths WHERE year = 2020 or year = 2021;
SET SQL_SAFE_UPDATES = 1;

-- inserting dummy values to be used for testing the trigger 'control_update'
INSERT INTO nature_deaths VALUES("TUR", 2022, 10, 10, 10, 10, 10);
INSERT INTO nature_deaths VALUES("TUR", 2023, 10, 10, 10, 10, 10);

UPDATE nature_deaths
SET 
    `deaths_by_unsafe_water_source` = -10 -- which will be rounded up to 0
WHERE
    year = 2022;



UPDATE nature_deaths
SET 
    `deaths_by_unsafe_water_source` = 2450945 -- which will be rounded down to 2450944
WHERE
    year = 2023;
    
CALL get_death_numbers("TUR"); -- we can verify our results










