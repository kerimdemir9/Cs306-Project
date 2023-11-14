# except (returns 13 rows)
SELECT A.iso_code
FROM above_average_diet_deaths_by_nutritional_deficiencies A
EXCEPT
SELECT B.iso_code
FROM above_average_diet_deaths_by_diet_low_in_whole_grains B;

# outer join (also returns 13 rows)
SELECT A.iso_code
FROM above_average_diet_deaths_by_nutritional_deficiencies A
LEFT OUTER JOIN above_average_diet_deaths_by_diet_low_in_whole_grains B
ON A.iso_code = B.iso_code
WHERE B.iso_code IS NULL;