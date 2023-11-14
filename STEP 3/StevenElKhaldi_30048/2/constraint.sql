# min value of deaths by nutritional deficiencies
SELECT min(deaths_by_nutritional_deficiencies)
FROM diet_deaths;
# returns 0

# max value of deaths by nutritional deficiencies
SELECT max(deaths_by_nutritional_deficiencies)
FROM diet_deaths;
# returns 757152

# add general constraint to diet_deaths
ALTER TABLE diet_deaths ADD CONSTRAINT deaths_by_nutritional_deficiencies_range CHECK (deaths_by_nutritional_deficiencies >= 0 AND deaths_by_nutritional_deficiencies <= 757152);

# test constraint
INSERT INTO diet_deaths (iso_code, deaths_by_nutritional_deficiencies, year) VALUES ("LEB", 757153, 1990);
# violates the range constraint on deaths_by_nutritional_deficiencies

DELIMITER $$
# before insert trigger
CREATE TRIGGER fix_deaths_by_nutritional_deficiencies_before_insert
BEFORE INSERT
ON diet_deaths FOR EACH ROW
BEGIN
  IF NEW.deaths_by_nutritional_deficiencies < 0 THEN
    SET NEW.deaths_by_nutritional_deficiencies = 0;
  ELSEIF NEW.deaths_by_nutritional_deficiencies > 757152 THEN
    SET NEW.deaths_by_nutritional_deficiencies = 757152;
  END IF;
END $$

# before update trigger
CREATE TRIGGER fix_deaths_by_nutritional_deficiencies_before_update
BEFORE UPDATE
ON diet_deaths FOR EACH ROW
BEGIN
  IF NEW.deaths_by_nutritional_deficiencies < 0 THEN
    SET NEW.deaths_by_nutritional_deficiencies = 0;
  ELSEIF NEW.deaths_by_nutritional_deficiencies > 757152 THEN
    SET NEW.deaths_by_nutritional_deficiencies = 757152;
  END IF;
END $$
DELIMITER ;