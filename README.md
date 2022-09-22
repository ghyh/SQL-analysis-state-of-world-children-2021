# SQL-analysis-state-of-world-children-2021
Using data &amp; stats from UNICEF to study trend of population health in countries

## Purpose
This study is trying to learn the overall health of each country in the world using "Life Expectancy" as the indicator. Life expectancy is used by WHO as the indicator for the overall health of a country[3]. I am using the data from the two reports from UNICEF, The State of the World’s Children 2021 [1] and The State of the World's Children 2000 [2], to understand what factor among social, health, education indicator, etc, could be associated with life expectancy.

## Data and Result
As expected, human being's life expectancy is getting longer and longer as the medical science develops over the years and more and more diseases become curable and managable. The table below suggested that from 1970 to 2020, human's average life expectancy increased by 15 years.
#### Averaged Life Expectancy
|1970             |2000             |2020             |
|-----------------|-----------------|-----------------|
|57.71730434782609|66.27752173913042|72.61491847826085|

#### Stats Trend of Life Expectancy in the World
However, there are still 16 countries whose life exppectancy doesn't grow monotonically over the past 50 year (1970-2020), which composed of roughly 8% of the countries, as shown below.
|Trend       |Number of Countries|Percentage       |
|------------|-------------------|-----------------|
|Monotonic   |                168|83.16831683168317|
|Nonmonotonic|                 16|7.920792079207921|

#### Countries whose Life Expectancy Slumped below World Average in 2000
Among the countries whose life expectancy doesn't grow monotonically, I noticed that there is only one country whose life expectancy is higher than world average in 1970 and 2020, but it plunged and became lower than average in 2000, as shown in the table below. That country is Russian Federation, which makes me wonder what could cause the dramatic decrease in life expectancy.

|country           |life_expectancy_at_births_1970|life_expectancy_at_births_2000|life_expectancy_at_births_2020|
|------------------|------------------------------|------------------------------|------------------------------|
|Russian Federation|                          68.5|                        65.082|                        72.742|

### Aanlysis
To understand the trend of life expectancy in Russian Federation, I try to explore more historical data, expecially that around year 2000 [2], to see why there is a dip in life expectancy. 
#### Trend of Life Expectancy in Russia 
|country           |Life Expectancy Rank 1970|Life Expectancy Rank 2000|Life Expectancy Rank 2020|
|------------------|-------------------------|-------------------------|-------------------------|
|Russian Federation|                       42|                      119|                      103|

#### Trend of Child Mortality (under 5) in Russia
First I noticed that the mortality rate of children under 5 and infant (children under 1) also show a similar trend where mortality rate shows a local maximum around year 2000, as shown in the two tables below.
|country           |Under 5 Mortality rate 1990|Under 5 Mortality rate 2000|Under 5 Mortality rate 2019|
|------------------|---------------------------|---------------------------|---------------------------|
|Russian Federation|                        137|                        126|                        153|
* Higher rank means higher mortality rate

#### Trend of Child Mortality (Under 1) in Russia
|country           |Neonatal Mortality rate 1990|Neonatal Mortality rate 2000|Neonatal Mortality rate 2019|
|------------------|----------------------------|----------------------------|----------------------------|
|Russian Federation|                         143|                         134|                         163|
* Higher rank means higher mortality rate   

The similarity between children's mortality and the decrease in life expectancy arouses my interest to look into other metrics, such as economic and nutrition.. 

#### Trend of GNP per capita in Russia
|Year                                           |   1965-80|    1980-91|     1990-97|
|-----------------------------------------------|----------|-----------|------------|
|GNP per cpita growth rate (%)                  |   N/A [4]|    -1.0[4]|        -7.9|
|World Average on GNP per cpita growth rate (%) |    N/A[5]|     N/A[5]|      2.6[5]|
|Rank on GNP per cpita growth rate              |    N/A[5]|     N/A[5]|     164/175|      

### Reference
[1]. The State of the World’s Children 2021: Statistical tables https://data.unicef.org/resources/dataset/the-state-of-the-worlds-children-2021-statistical-tables/   
[2]. The State of the World's Children 2000 https://www.unicef.org/reports/state-worlds-children-2000  
[3]. Healthy Life Expectancy and How It's Calculated https://www.verywellhealth.com/understanding-healthy-life-expectancy-2223919  
[4]. The State of the World's Children 1995 https://www.unicef.org/media/84756/file/SOWC-1996.pdf   
[5]. GNI per capita growth (annual %) https://data.worldbank.org/indicator/NY.GNP.PCAP.KD.ZG?most_recent_year_desc=false

