#IN (returns 21 rows)
SELECT A.iso_code
FROM above_average_diet_deaths_by_nutritional_deficiencies A
WHERE A.iso_code in (
SELECT B.iso_code
FROM above_average_diet_deaths_by_diet_low_in_fruits B
);

# EXISTS (also returns 21 rows)
SELECT A.iso_code
FROM above_average_diet_deaths_by_nutritional_deficiencies A
WHERE EXISTS (
SELECT B.iso_code
FROM above_average_diet_deaths_by_diet_low_in_fruits B
WHERE A.iso_code = B.iso_code
);