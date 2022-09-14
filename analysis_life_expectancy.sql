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

/* Child Mortality  for Russia */
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
			RANK() OVER(ORDER BY under_five_mortality_rate_1990) rank_1990
		FROM
			child_mortality
	) rank_1990_table
	JOIN
	(
		SELECT
			country,
			under_five_mortality_rate_2000,
			RANK() OVER(ORDER BY under_five_mortality_rate_2000) rank_2000
		FROM 
			child_mortality
	) rank_2000_table
	ON rank_1990_table.country = rank_2000_table.country
	JOIN 
	(
		SELECT
			country,
			under_five_mortality_rate_2019,
			RANK() OVER(ORDER BY under_five_mortality_rate_2019) rank_2019
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
			RANK() OVER(ORDER BY neonatal_mortality_rate_1990) rank_1990
		FROM
			child_mortality
	) rank_table_1990
	JOIN
	(
		SELECT
			country,
			neonatal_mortality_rate_2000,
			RANK() OVER(ORDER BY neonatal_mortality_rate_2000) rank_2000
		FROM
			child_mortality
	) rank_table_2000
	ON rank_table_1990.country = rank_table_2000.country
	JOIN
	(
		SELECT
			country,
			neonatal_mortality_rate_2019,
			RANK() OVER(ORDER BY neonatal_mortality_rate_2019) rank_2019
		FROM
			child_mortality
	) rank_table_2019
	ON rank_table_1990.country = rank_table_2019.country
WHERE rank_table_1990.country = 'Russian Federation'
;

SELECT
	infant_under1_mortality_rate_1960,
	under5_mortality_rate_1960,
	infant_under1_mortality_rate_1998,
	under5_mortality_rate_1998
FROM
	basic_2000 b 
WHERE
	country LIKE 'Russia%'
;

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
;

SELECT
	*
FROM 
	rate_progress_2000 rp
;