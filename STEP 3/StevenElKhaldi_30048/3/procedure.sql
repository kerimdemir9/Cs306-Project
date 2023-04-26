# procedure
DELIMITER $$
CREATE PROCEDURE get_deaths_by_nutritional_deficiencies (IN iso_code VARCHAR(5))
BEGIN
  DECLARE count_iso_code INT;
  SELECT COUNT(*) INTO count_iso_code FROM diet_deaths A WHERE A.iso_code = iso_code;
  IF count_iso_code > 0 THEN
    SELECT AVG(deaths_by_nutritional_deficiencies) AS avg_deaths,
    MAX(deaths_by_nutritional_deficiencies) AS max_deaths
    FROM diet_deaths A WHERE A.iso_code = iso_code;
  ELSE
    SELECT 'Such an ISO code does not exist in the table' AS error_message;
  END IF;
END$$
DELIMITER ;

# two different calls with two different inputs
CALL get_deaths_by_nutritional_deficiencies('AGO'); # avg_deaths: 7839.3667, max_deaths: 12232
CALL get_deaths_by_nutritional_deficiencies('AWH'); # avg_deaths: 164695.3333, max_deaths: 217480