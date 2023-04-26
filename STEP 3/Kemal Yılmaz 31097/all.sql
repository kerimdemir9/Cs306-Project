ALTER TABLE health_deaths ADD COLUMN stunting_wasting_total INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE health_deaths SET stunting_wasting_total = (deaths_by_child_stunting + deaths_by_child_wasting);


CREATE VIEW high_death_countries AS
SELECT h.iso_code, h.stunting_wasting_total, cn.continent_code
FROM health_deaths h
JOIN locatedin cn ON h.iso_code = cn.iso_code
WHERE h.stunting_wasting_total > (
	SELECT AVG(c2.stunting_wasting_total)
    FROM health_deaths c2
    JOIN locatedin cn2 ON c2.iso_code = cn2.iso_code
    WHERE cn2.continent_code != 'REG'
  )
AND cn.continent_code != 'REG';


ALTER VIEW high_death_countries AS
SELECT h.iso_code, h.stunting_wasting_total, cn.continent_code, h.year
FROM health_deaths h
JOIN locatedin cn ON h.iso_code = cn.iso_code
WHERE h.stunting_wasting_total > (
	SELECT AVG(c2.stunting_wasting_total)
    FROM health_deaths c2
    JOIN locatedin cn2 ON c2.iso_code = cn2.iso_code
    WHERE cn2.continent_code != 'REG'
  )
AND cn.continent_code != 'REG';

CREATE VIEW high_death_countries_from_breastfeeding AS
SELECT h.iso_code, h.deaths_by_discontinued_breastfeeding, cn.continent_code, h.year
FROM diet_deaths h
JOIN locatedin cn ON h.iso_code = cn.iso_code
WHERE h.deaths_by_discontinued_breastfeeding > (
	SELECT AVG(c2.deaths_by_discontinued_breastfeeding)
    FROM diet_deaths c2
    JOIN locatedin cn2 ON c2.iso_code = cn2.iso_code
    WHERE cn2.continent_code != 'REG'
  )
AND cn.continent_code != 'REG';


SELECT iso_code, year
FROM high_death_countries
WHERE (iso_code,year) IN (
    SELECT iso_code,year
    FROM high_death_countries_from_breastfeeding
);

SELECT iso_code, year
FROM high_death_countries hdc
WHERE EXISTS (
    SELECT *
    FROM high_death_countries_from_breastfeeding hdb
    WHERE hdb.iso_code = hdc.iso_code AND hdb.year = hdc.year
);

SELECT cd.iso_code,cd.year,cd.stunting_wasting_total,bf.iso_code,bf.year,bf.deaths_by_discontinued_breastfeeding
FROM high_death_countries cd 
JOIN high_death_countries_from_breastfeeding bf
ON cd.iso_code = bf.iso_code and cd.year = bf.year;


SELECT MAX(deaths_by_discontinued_breastfeeding) FROM diet_deaths;
SELECT MIN(deaths_by_discontinued_breastfeeding) FROM diet_deaths;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE diet_deaths
ADD CONSTRAINT value_constraint 
CHECK (33106 >= deaths_by_discontinued_breastfeeding and 0 <= deaths_by_discontinued_breastfeeding );

INSERT INTO diet_deaths
VALUES ('USA',2023,-1,-1,-1,-1,-1,-1,-1,-1,-1);

DROP TRIGGER IF EXISTS my_insert_trigger;
DELIMITER //
CREATE TRIGGER my_insert_trigger
BEFORE INSERT ON diet_deaths
FOR EACH ROW
BEGIN
    IF NEW.deaths_by_discontinued_breastfeeding < (SELECT MIN(deaths_by_discontinued_breastfeeding) FROM diet_deaths) THEN
        SET NEW.deaths_by_discontinued_breastfeeding = (SELECT MIN(deaths_by_discontinued_breastfeeding) FROM diet_deaths);
    ELSEIF NEW.deaths_by_discontinued_breastfeeding > (SELECT MAX(deaths_by_discontinued_breastfeeding) FROM diet_deaths) THEN
        SET NEW.deaths_by_discontinued_breastfeeding = (SELECT MAX(deaths_by_discontinued_breastfeeding) FROM diet_deaths);
    END IF;
END;
DELIMITER ;
DROP TRIGGER IF EXISTS my_update_trigger;
DELIMITER //

CREATE TRIGGER my_update_trigger
BEFORE UPDATE ON diet_deaths
FOR EACH ROW
BEGIN
    IF NEW.deaths_by_discontinued_breastfeeding < (SELECT MIN(deaths_by_discontinued_breastfeeding) FROM diet_deaths) THEN
        SET NEW.deaths_by_discontinued_breastfeeding = (SELECT MIN(deaths_by_discontinued_breastfeeding) FROM diet_deaths);
    ELSEIF NEW.deaths_by_discontinued_breastfeeding > (SELECT MAX(deaths_by_discontinued_breastfeeding) FROM diet_deaths) THEN
        SET NEW.deaths_by_discontinued_breastfeeding = (SELECT MAX(deaths_by_discontinued_breastfeeding) FROM diet_deaths);
    END IF;
END;

DELIMITER ;

DROP Procedure IF EXISTS breast_feeding_deaths_every_year;
DELIMITER //

CREATE PROCEDURE breast_feeding_deaths_every_year(IN param VARCHAR(3))
BEGIN
	SELECT year,iso_code,deaths_by_discontinued_breastfeeding
    FROM diet_deaths 
    WHERE iso_code = param;

END//
DELIMITER ;

CALL breast_feeding_deaths_every_year("AFG");
CALL breast_feeding_deaths_every_year("USA");
CALL breast_feeding_deaths_every_year("TUR");

