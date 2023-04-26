use 306_project;

#the view where the alcohol deaths in that year is greater than the average
Create view smoking_deaths_gt_avg as
SELECT C.name, S.year, S.deaths_by_smoking, AVG(S2.deaths_by_smoking) AS avg_smoking_deaths_per_year, S.total_deaths 
FROM substance_deaths S 
JOIN countries C ON S.iso_code = C.iso_code
JOIN substance_deaths S2 ON S.iso_code = S2.iso_code 
GROUP BY S.iso_code, S.year 
HAVING S.deaths_by_smoking > AVG(S2.deaths_by_smoking);

select * from smoking_deaths_gt_avg;

select iso_code, year, deaths_by_cardiovascular_diseases from health_deaths;

# creating a view (cardiovascular diseases above average)
Create view cardiovascular_diseases_gt_avg as
SELECT C.name, H.year, H.deaths_by_cardiovascular_diseases, AVG(H2.deaths_by_cardiovascular_diseases) AS avg_cardiovascular_deaths_per_year
FROM health_deaths H 
JOIN countries C ON H.iso_code = C.iso_code
JOIN health_deaths H2 ON H.iso_code = H2.iso_code 
GROUP BY H.iso_code, H.year 
HAVING H.deaths_by_cardiovascular_diseases > AVG(H2.deaths_by_cardiovascular_diseases);

use 306_project;
select * from cardiovascular_diseases_gt_avg;
select * from smoking_deaths_gt_avg;
# smoking_deaths_gt_avg

use 306_project;
# in statement
SELECT name, year 
FROM smoking_deaths_gt_avg
WHERE year and name IN (
    SELECT year and name
    FROM cardiovascular_diseases_gt_avg
);

# with exists
SELECT name, year
FROM smoking_deaths_gt_avg S
WHERE EXISTS (
    SELECT *
    FROM cardiovascular_diseases_gt_avg C
    WHERE C.year = S.year and C.name = S.name
);

# gives the list of countries and years where the deaths from smoking and number of cardiovascular diseases are above average
select S.name, S.year, S.deaths_by_smoking, C.deaths_by_cardiovascular_diseases, S.total_deaths as substance_total_deaths 
from smoking_deaths_gt_avg S INNER JOIN cardiovascular_diseases_gt_avg C on C.year = S.year and C.name = S.name;

# with set operator(intersect)
select S.name, S.year from smoking_deaths_gt_avg S intersect select C.name, C.year from cardiovascular_diseases_gt_avg C;

# getting the row with the max smoking death
select C.name, S.* from substance_deaths S, countries C 
where C.iso_code = S.iso_code and deaths_by_smoking = (select max(deaths_by_smoking) from substance_deaths);

# same for min value
select C.name, S.* from substance_deaths S, countries C 
where C.iso_code = S.iso_code and deaths_by_smoking = (select min(deaths_by_smoking) from substance_deaths);

# setting variables
set @max_smoking_deaths = (select max(deaths_by_smoking) from substance_deaths);
set @min_smoking_deaths = (select min(deaths_by_smoking) from substance_deaths);
select @min_smoking_deaths ;
select @max_smoking_deaths ;
select * from substance_deaths;
# adding constraint
ALTER TABLE substance_deaths ADD CONSTRAINT in_range_smoking_deaths 
check (deaths_by_smoking >= 1 and deaths_by_smoking <= 7693368);

select * from substance_deaths;

 # trying to insert a row that doesnt meet the the constraint format
INSERT INTO substance_deaths (iso_code, year, deaths_by_tobacco, deaths_by_drug_use, 
deaths_by_alcohol_use, deaths_by_smoking, deaths_by_secondhand_smoke, total_deaths) 
VALUES ("AFG", 2020, 16000, 750, 5, 0, 6100, 33.849);

# insert trigger
delimiter //
CREATE TRIGGER ins_check
BEFORE INSERT ON substance_deaths 
for each row 
Begin
	IF NEW.deaths_by_smoking < @min_smoking_deaths then
		set NEW.deaths_by_smoking = @min_smoking_deaths;
	ELSEIF NEW.deaths_by_smoking > @max_smoking_deaths then
		set NEW.deaths_by_smoking = @max_smoking_deaths;
	END IF;
END; //
delimiter ;


# update trigger
delimiter //
CREATE TRIGGER upd_check BEFORE UPDATE ON substance_deaths
FOR EACH ROW
BEGIN
	IF NEW.deaths_by_smoking < @min_smoking_deaths then
		set NEW.deaths_by_smoking = @min_smoking_deaths;
	ELSEIF NEW.deaths_by_smoking > @max_smoking_deaths then
		set NEW.deaths_by_smoking = @max_smoking_deaths;
	END IF;
END;//
delimiter ;

delimiter //

# procedure that returns the total death number from substance usage
CREATE PROCEDURE substance_total_death(code VARCHAR(5))
BEGIN
    (select iso_code, sum(total_deaths) as total_deaths_by_substance_use from substance_deaths where iso_code = code group by iso_code);
END //

delimiter ;

# DROP PROCEDURE IF EXISTS substance_total_death;

use 306_project;

call substance_total_death('AFG'); 
call substance_total_death('ITA'); 
call substance_total_death('USA'); 

select * from countries;