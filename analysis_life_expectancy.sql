/*
 * Coutries whose life expectancy grows monotonically over time among the countries with the highest annual birth number in 2020
 * 
 */
SELECT
	'Nonmonotonic' as 'Trend',
	count(country) as 'Number of Countries',
	count(country)*100.0 / (
		SELECT
			count(country)
		FROM
			demographic
	) as 'Percentage'
FROM
	demographic
WHERE
	NOT(
		life_expectancy_at_births_2020 >= life_expectancy_at_births_2000
	AND
		life_expectancy_at_births_2000 >= life_expectancy_at_births_1970
	)
UNION 
SELECT
	'Monotonic' as 'Trend',
	count(country),
	count(country)*100.0/ (
		SELECT
			count(country)
		FROM
			demographic d 		
	) as 'Percentage'
FROM
	demographic d 
WHERE
	(life_expectancy_at_births_2020 >= life_expectancy_at_births_2000
	AND
	life_expectancy_at_births_2000 >= life_expectancy_at_births_1970
	)
;

/* Average life expectancy on 1970, 2000, 2020, respectively */
SELECT
	AVG(life_expectancy_at_births_1970) as '1970',
	AVG(life_expectancy_at_births_2000) as '2000',
	AVG(life_expectancy_at_births_2020) as '2020'
FROM
	demographic d 
;

SELECT 
	country,
	life_expectancy_at_births_1970,
	life_expectancy_at_births_2000,
	life_expectancy_at_births_2020
FROM
	demographic d 
WHERE 
	NOT(
		life_expectancy_at_births_2000 >= life_expectancy_at_births_1970
		AND
		life_expectancy_at_births_2020  >= life_expectancy_at_births_2000 
	)
	AND
	(life_expectancy_at_births_1970 > 
		(
			SELECT
				AVG(life_expectancy_at_births_1970) 
			FROM
				demographic
		)
	)
	AND
	(life_expectancy_at_births_2000 <
		(
			SELECT
				AVG(life_expectancy_at_births_2000)
			FROM 
				demographic
		)
	)
	AND
	(
		life_expectancy_at_births_2020 >
		(
			SELECT
				AVG(life_expectancy_at_births_2020)
			FROM 
				demographic
		)
	)
;

/* try to find the cause of the drop of life expectancy in Russia from other tables */
/* Trend of Overall Mortality of Russia */
SELECT
	table_rank_1970.country,
	table_rank_1970.rank_1970 'Life Expectancy Rank 1970',
	table_rank_2000.rank_2000 'Life Expectancy Rank 2000',
	table_rank_2020.rank_2020 'Life Expectancy Rank 2020'
FROM
(
	SELECT
		country,
		RANK() OVER(ORDER BY life_expectancy_at_births_1970 DESC) 'rank_1970' 
	FROM 
		demographic
) table_rank_1970
JOIN
(
	SELECT
		country,
		RANK() OVER(ORDER BY life_expectancy_at_births_2000 DESC) 'rank_2000'
	FROM
		demographic d2 
) table_rank_2000
ON table_rank_1970.country = table_rank_2000.country
JOIN
(
	SELECT
		country,
		RANK() OVER(ORDER BY life_expectancy_at_births_2020 DESC) 'rank_2020'
	FROM 
		demographic
) table_rank_2020
ON table_rank_1970.country = table_rank_2020.country
WHERE 
	table_rank_1970.country LIKE 'Russian%'
;


/* Trend of Child Mortality of Russia */
SELECT
	rank_1990_table.country,
	rank_1990_table.rank_1990 'Under 5 Mortality rate 1990',
	rank_2000_table.rank_2000 'Under 5 Mortality rate 2000',
	rank_2019_table.rank_2019 'Under 5 Mortality rate 2019'
FROM
	(
		SELECT
			country,
			under_five_mortality_rate_1990,
			RANK() OVER(ORDER BY under_five_mortality_rate_1990 DESC) rank_1990
		FROM
			child_mortality
	) rank_1990_table
	JOIN
	(
		SELECT
			country,
			under_five_mortality_rate_2000,
			RANK() OVER(ORDER BY under_five_mortality_rate_2000 DESC) rank_2000
		FROM 
			child_mortality
	) rank_2000_table
	ON rank_1990_table.country = rank_2000_table.country
	JOIN 
	(
		SELECT
			country,
			under_five_mortality_rate_2019,
			RANK() OVER(ORDER BY under_five_mortality_rate_2019 DESC) rank_2019
		FROM
			child_mortality
	) rank_2019_table
	ON rank_1990_table.country = rank_2019_table.country 
WHERE rank_1990_table.country = 'Russian Federation'
;

/* Neonatal Mortality  for Russia */
SELECT 
	rank_table_1990.country,
	rank_table_1990.rank_1990 'Neonatal Mortality rate 1990',
	rank_table_2000.rank_2000 'Neonatal Mortality rate 2000',
	rank_table_2019.rank_2019 'Neonatal Mortality rate 2019'
FROM
	(
		SELECT
			country,
			neonatal_mortality_rate_1990,
			RANK() OVER(ORDER BY neonatal_mortality_rate_1990 DESC) rank_1990
		FROM
			child_mortality
	) rank_table_1990
	JOIN
	(
		SELECT
			country,
			neonatal_mortality_rate_2000,
			RANK() OVER(ORDER BY neonatal_mortality_rate_2000 DESC) rank_2000
		FROM
			child_mortality
	) rank_table_2000
	ON rank_table_1990.country = rank_table_2000.country
	JOIN
	(
		SELECT
			country,
			neonatal_mortality_rate_2019,
			RANK() OVER(ORDER BY neonatal_mortality_rate_2019 DESC) rank_2019
		FROM
			child_mortality
	) rank_table_2019
	ON rank_table_1990.country = rank_table_2019.country
WHERE rank_table_1990.country = 'Russian Federation'
;

SELECT
	country,
	infant_under1_mortality_rate_1960,
	infant_under1_mortality_rate_1998
FROM
	basic_2000 b
CROSS JOIN (
	SELECT
		country,
		under5_mortality_rate_1960,
		under5_mortality_rate_1998
	FROM
		basic_2000 b2 
)
;
/* Health Indicators */
SELECT
	country,
	immunization_vaccine_bcg_percent_2020*100 '%BCG',
	immunization_vaccine_dtp1_percent_2020*100 '%DTP1',
	immunization_vaccine_dtp3_percent_2020*100 '%DTP3',
	immunization_vaccine_polio3_percent_2020*100 '%Polio3',
	immunization_vaccine_mcv1_percent_2020*100 '%MCV1',
	immunization_vaccine_mcv2f_percent_2020*100 '%MCV2F',
	immunization_vaccine_hepb3_percent_2020*100 '%Hepb3',
	immunization_vaccine_hib3_percent_2020*100 '%Hib3',
	immunization_vaccine_rota_percent_2020*100 '%ROTA',
	immunization_vaccine_pcv3_percent_2020*100 '%PCV3',
	immunization_vaccine_pab_tetanus_percent_2020*100 '%PAB Tentanus'
FROM 
	child_health
WHERE
	country LIKE 'Russia%'
;

SELECT 
	country,
	percent_fully_immunized_1995_98_1yr_old_children_tb '%TB',
	percent_fully_immunized_1995_98_1yr_old_children_dpt '%DPT',
	percent_fully_immunized_1995_98_1yr_old_children_polio '%Polio',
	percent_fully_immunized_1995_98_1yr_old_children_measles '%Measles'
FROM
	health_2000 h 
WHERE 
	country LIKE 'Russia%'
;

/* Economic indicators */
SELECT
	rank_table_1965_80.country,
	rank_table_1965_80.gnp_per_capita_average_annual_growth_rate_percent_1965_80,
	rank_table_1965_80.rank_1965_80,
	rank_table_1990_97.gnp_per_capita_average_annual_growth_rate_percent_1990_97,
	rank_table_1990_97.rank_1990_97
FROM
	(
		SELECT 
			country,
			gnp_per_capita_average_annual_growth_rate_percent_1965_80,
			RANK() OVER(ORDER BY gnp_per_capita_average_annual_growth_rate_percent_1965_80 DESC) rank_1965_80
		FROM
			economics_2000 e
	) rank_table_1965_80
JOIN
	(
		SELECT
			country,
			gnp_per_capita_average_annual_growth_rate_percent_1990_97,
			RANK() OVER(ORDER BY gnp_per_capita_average_annual_growth_rate_percent_1990_97 DESC) rank_1990_97
		FROM
			economics_2000 e2 
	) rank_table_1990_97
ON rank_table_1965_80.country = rank_table_1990_97.country
WHERE 
	rank_table_1965_80.country LIKE 'Russia%' 
;

SELECT
	country,
	gnp_per_capita_average_annual_growth_rate_percent_1965_80 'GNP 1965-80',
	gnp_per_capita_average_annual_growth_rate_percent_1990_97 'GNP 1990-97'
FROM 
	rate_progress_2000 rp
WHERE
	country LIKE 'Russia%'
;

SELECT 
	country,
	gnp_per_capita_average_annual_growth_rate_percent_1990_97,
	RANK() OVER(ORDER BY gnp_per_capita_average_annual_growth_rate_percent_1990_97 DESC) 'GNP Rank 1990-97'
FROM
	rate_progress_2000 rp 
;