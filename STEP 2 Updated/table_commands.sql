CREATE TABLE continents(
	continent_code VARCHAR(5),
	name VARCHAR(50),
	PRIMARY KEY (continent_code)
);

CREATE TABLE countries(
	iso_code VARCHAR(5),
	name VARCHAR(50),
	PRIMARY KEY (iso_code)
);

CREATE TABLE locatedin(
	iso_code VARCHAR(5),
    continent_code VARCHAR(5) NOT NULL,
	PRIMARY KEY (iso_code),
    FOREIGN KEY (iso_code) REFERENCES countries (iso_code) ON DELETE CASCADE,
    FOREIGN KEY (continent_code) REFERENCES continents (continent_code) ON DELETE CASCADE
);

CREATE TABLE health_deaths (
	iso_code VARCHAR(5) NOT NULL,
	year INT,
	deaths_by_child_stunting INT,
    deaths_by_meningitis INT,
    deaths_by_cardiovascular_diseases INT,
    deaths_by_chronic_respiratory_diseases INT,
    deaths_by_hiv_aids INT,
    deaths_by_high_systolic_blood_pressure INT,
    deaths_by_low_birth_weight INT,
    deaths_by_child_wasting INT,
    deaths_by_unsafe_sex INT,
    deaths_by_low_physical_activity INT,
    deaths_by_high_fasting_plasma_glucose INT,
    deaths_by_high_body_mass_index INT,
    deaths_by_no_access_to_handwashing_facility INT,
    deaths_by_low_bone_mineral_density INT,
	PRIMARY KEY (iso_code, year),
	FOREIGN KEY (iso_code) REFERENCES countries(iso_code) ON DELETE CASCADE
);

CREATE TABLE diet_deaths (
	iso_code VARCHAR(5) NOT NULL,
	year INT,
    deaths_by_nutritional_deficiencies INT,
    deaths_by_protein_energy_malnutrition INT,
    deaths_by_vitamin_A_deficiency INT,
    deaths_by_discontinued_breastfeeding INT,
    deaths_by_non_exclusive_breastfeeding INT,
    deaths_by_iron_deficiency INT,
    deaths_by_diet_high_in_sodium INT,
    deaths_by_diet_low_in_whole_grains INT,
    deaths_by_diet_low_in_fruits INT,
	PRIMARY KEY (iso_code, year),
	FOREIGN KEY (iso_code) REFERENCES countries(iso_code) ON DELETE CASCADE
);

CREATE TABLE nature_deaths (
	iso_code VARCHAR(5) NOT NULL,
	year INT,
    deaths_by_outdoor_air_pollution INT,
    deaths_by_unsafe_water_source INT,
    deaths_by_household_air_pollution_from_solid_fuels INT,
    deaths_by_air_pollution INT,
    deaths_by_unsafe_sanitation INT,
	PRIMARY KEY (iso_code, year),
	FOREIGN KEY (iso_code) REFERENCES countries(iso_code) ON DELETE CASCADE
);

CREATE TABLE substance_deaths (
	iso_code VARCHAR(5) NOT NULL,
	year INT,
	deaths_by_tobacco INT,
    deaths_by_drug_use INT,
    deaths_by_alcohol_use INT,
    deaths_by_smoking INT,
    deaths_by_secondhand_smoke INT,
	PRIMARY KEY (iso_code, year),
	FOREIGN KEY (iso_code) REFERENCES countries(iso_code) ON DELETE CASCADE
);

CREATE TABLE emissions (
	iso_code VARCHAR(5) NOT NULL,
	year INT,
    nitrogen_oxide_in_tonnes_NOx REAL,
    sulphur_dioxide_in_tonnes_SO2 REAL,
    carbon_monoxide_in_tonnes_CO REAL,
    ammonia_in_tonnes_NH3 REAL,
	PRIMARY KEY (iso_code, year),
	FOREIGN KEY (iso_code) REFERENCES countries(iso_code) ON DELETE CASCADE
);