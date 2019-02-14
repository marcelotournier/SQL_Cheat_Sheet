--SQL JOINS

-- INNER JOIN (INTERSECTION BETWEEN TABLE A AND TABLE B)

-- SQL code for testing on the DataCamp Course: 
-- Joining data in PostgreSQL
-- https://campus.datacamp.com/courses/joining-data-in-postgresql/

-- EXAMPLE:

SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;


--joining cities and countries tables:
SELECT *
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

--getting only specifical columns from "cities" and "countries" tables:
SELECT cities.name AS city ,countries.name AS country,region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

-- aliases:
SELECT c1.name AS city, c2.name AS country
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code;


SELECT c.code AS country_code, name, year, inflation_rate
FROM countries AS c
INNER JOIN economies AS e
ON c.code = e.code;

-- multiple joins:
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id
INNER JOIN another_table
ON left_table.id = another_table.id;

-- joining with specific conditions using AND
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code AND p.year = e.year;

/* 
Inner join countries on the left and languages on the right with USING(code). 
Select the fields corresponding to:

- country name AS country,
- continent name,
- language name AS language, and
- whether or not the language is official.

Remember to alias your tables using the first letter of their names.
*/
SELECT c.name AS country, continent, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
USING(code);

-- you can do SELF JOINS - inner joins with the same table!
-- useful to do multiple calculations...
SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON  p1.country_code = p2.country_code;

--correcting the code:
SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON  p1.country_code = p2.country_code
AND p1.year = p2.year - 5;

-- and adding a calculated field for perc.growth
SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
    AND p1.year = p2.year - 5;


-- using CASE WHEN to define new categorical variables!

SELECT name, continent, code, surface_area,
        -- first case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- second case
        WHEN surface_area > 350000 THEN 'medium'
        -- else clause + end
        ELSE 'small' END
        AS geosize_group
FROM countries;


SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' END
        AS popsize_group
FROM populations
WHERE year = 2015;

-- we can use INTO to put a query as a new table (like pop_plus)
SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' END
        AS popsize_group
INTO pop_plus
FROM populations
WHERE year = 2015;
SELECT * FROM pop_plus;

-- final example: use INTO and INNER JOIN:
SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' END
        AS popsize_group
INTO pop_plus
FROM populations
WHERE year = 2015;
SELECT *
FROM countries_plus AS c
INNER JOIN pop_plus AS p
ON c.code = p.country_code
ORDER BY geosize_group;



-- UNION
/* 
Near query result to the right, you will see two new tables with names economies2010 and economies2015.

Instructions:

    Combine these two tables into one table containing all of the fields in economies2010. 
    The economies table is also included for reference.
    
    Sort this resulting single table by country code and then by year, both in ascending order.

*/
-- pick specified columns from 2010 table
SELECT *
-- 2010 table will be on top
FROM economies2010
-- which set theory clause?
UNION
-- pick specified columns from 2015 table
SELECT *
-- 2015 table on the bottom
FROM economies2015
-- order accordingly
ORDER BY code, year ASC;


/* 
    Determine all (non-duplicated) country codes in either the cities or the currencies table. 
    The result should be a table with only one field called country_code.
    Sort by country_code in alphabetical order.
*/

SELECT  country_code
FROM cities
UNION
SELECT  code
FROM currencies
ORDER BY country_code ASC;

-- using INTERSECT to take coincident data
SELECT  code,year
FROM economies
INTERSECT
SELECT  country_code,year
FROM populations
ORDER BY code,year ASC;

-- Which cities has the same name of their country?
SELECT  name
FROM cities
INTERSECT
SELECT  name
FROM countries
ORDER BY name ASC;


/*
Get the names of cities in cities which are not noted as capital cities in countries as a single field result. 
Order the resulting field in ascending order. 
*/
SELECT name
FROM cities
EXCEPT
SELECT capital
FROM countries
ORDER BY name ASC;

-- now look for the names that aren't in the previous query:
SELECT capital
FROM countries
EXCEPT
SELECT name
FROM cities
ORDER BY capital ASC;


-- SEMI JOINS
-- Presidents of countries which independence year was before 1800:
SELECT president, country, continent FROM presidents
WHERE country IN
(SELECT name
FROM states
WHERE indep_year < 1800);

--ANTI JOINS
-- Info from presidents of American continents, which its independence year is not < 1800:
SELECT president, country, continent FROM presidents
WHERE continent LIKE '%America'
AND country NOT IN (SELECT name FROM states
WHERE indep_year < 1800);


-- select all languages spoken in middle east:
SELECT DISTINCT name
FROM languages
WHERE code IN (
  SELECT code
  FROM countries
  WHERE region = 'Middle East')
ORDER BY name ASC;

--Sometimes you can use INNER JOIN to do the same:
SELECT DISTINCT languages.name AS language
FROM languages
INNER JOIN countries
ON languages.code = countries.code
WHERE region = 'Middle East'
ORDER BY language;

/* 
Your goal is to identify the currencies used in Oceanian countries!

*/
SELECT DISTINCT c1.code,c1.name,c2.basic_unit AS currency
FROM countries AS c1
INNER JOIN currencies AS c2
ON c1.code = c2.code
WHERE c1.continent = 'Oceania'
;

/*
Note that not all countries in Oceania were listed in the resulting inner join with currencies. 
Use an anti-join to determine which countries were not included!

Use NOT IN and (SELECT code FROM currencies) as a subquery to get the country code and 
country name for the Oceanian countries that are not included in the currencies table.
*/
SELECT code,name FROM countries
WHERE continent = 'Oceania'
AND code NOT IN (SELECT code FROM currencies);


-- CHALLENGE
/*
Identify the country codes that are included in either economies or currencies but not in populations.
Use that result to determine the names of cities in the countries that match the specification 
in the previous instruction.
*/

-- select the city name
SELECT name
-- alias the table where city name resides
FROM cities AS c1
-- choose only records matching the result of multiple set theory clauses
WHERE country_code IN
(
    -- select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- get all additional (unique) values of the field from currencies AS c2  
    UNION
    SELECT c2.code
    FROM currencies AS c2
    -- exclude those appearing in populations AS p
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);


-- SUB QUERIES



SELECT name, fert_rate FROM states
WHERE continent = 'Asia'
AND fert_rate <
(SELECT AVG(fert_rate)
FROM states);
/*
+---------+-------------+
| name    |   fert_rate |
|---------+-------------|
| Brunei  | 1.96        |
| Vietnam | 1.7         |
+---------+-------------+
*/

SELECT DISTINCT continent, 
(SELECT COUNT(*) FROM states
WHERE prime_ministers.continent = states.continent) 
AS countries_num FROM prime_ministers; -- YOU NEED TO PUT THE ALIAS WHEN YOU CALL FUNCTIONS AS COUNT(), OR AVG()
/*
+---------------+-----------------+ 
| continent | countries_num | 
|---------------+-----------------| 
| Africa        | 2               | 
| Asia          | 4               | 
| Europe        | 3               | 
| North America | 1               | 
| Oceania       | 1               | 
+---------------+-----------------+
*/

/*
Recall that you can use SQL to do calculations for you. 
Suppose we wanted only records that were above 1.15 * 100 in terms of life expectancy for 2015:

SELECT *
FROM populations
WHERE life_expectancy > 1.15 * 100
  AND year = 2015;

Select all fields from populations with records corresponding to larger than 1.15 times the average 
you calculated in the first task for 2015. In other words, change the 100 in the example above with a subquery.
*/

SELECT * 
FROM populations
WHERE life_expectancy > 1.15 * (
SELECT AVG(life_expectancy) FROM populations
WHERE year = 2015) 
AND year = 2015;

/*
Make use of the capital field in the countries table in your subquery.
Select the city name, country code, and urban area population fields.
*/
-- select the appropriate fields
SELECT name, country_code, urbanarea_pop
-- from the cities table
FROM cities
-- with city name in the field of capital cities
WHERE name IN
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;



/*
The code given in query.sql selects the top nine countries in terms of number of cities 
appearing in the cities table. Recall that this corresponds to the most populous cities 
in the world. Your task will be to convert the commented out code to get the same result as the code shown.
*/
/*
SELECT countries.name AS country, COUNT(*) AS cities_num
FROM cities
INNER JOIN countries
ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;
*/

 
SELECT name AS country,
  (SELECT COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;


-- SUBQUERIES INSIDE FROM -- Creating temporary tables to query inside!

SELECT DISTINCT monarchs.continent, subquery.max_perc FROM monarchs,
(SELECT continent, MAX(women_parli_perc) AS max_perc FROM states
GROUP BY continent) AS subquery
WHERE monarchs.continent = subquery.continent ORDER BY continent;
/*
+-------------+------------+ 
| continent   | max_perc   | 
|-------------+------------| 
|Asia         | 24         | 
| Europe      | 39.6       | 
+-------------+------------+
*/


--


/*
Begin by determining for each country code how many languages are listed in the 
languages table using SELECT, FROM, and GROUP BY.

Alias the aggregated field as lang_num.
*/

SELECT code,COUNT(*) as lang_num
FROM languages
GROUP BY code;

/*
Begin by determining for each country code how many languages are listed in the languages table using SELECT, FROM, and GROUP BY.
Alias the aggregated field as lang_num.
*/

/*
Include the previous query (aliased as subquery) as a subquery in the FROM clause of a new query.
Select the local name of the country from countries.
Also, select lang_num from subquery.
Make sure to use WHERE appropriately to match code in countries and in subquery.
Sort by lang_num in descending order.
*/

SELECT countries.local_name , subquery.lang_num
FROM countries,(
SELECT code,COUNT(*) AS lang_num FROM languages GROUP BY code
) AS subquery
WHERE countries.code = subquery.code 
ORDER BY lang_num DESC;


/*
Create an inner join with countries on the left and economies on the right with USING. 
Do not alias your tables or columns.
Retrieve the country name, continent, and inflation rate for 2015.
*/
/*
Determine the maximum inflation rate for each continent in 2015 using the previous 
query as a subquery called subquery in the FROM clause.

Select the maximum inflation rate AS max_inf grouped by continent.

This will result in the six maximum inflation rates in 2015 for the six continents 
as one field table. (Don't include continent in the outer SELECT statement.)
*/

/* subquery
SELECT c.name , c.continent, inflation_rate
FROM countries AS c
INNER JOIN economies AS e
USING(code)
WHERE year = 2015
;*/

SELECT MAX(inflation_rate) AS max_inf
FROM (SELECT name , continent, inflation_rate
FROM countries
INNER JOIN economies
USING(code)
WHERE year = 2015) AS subquery
GROUP BY continent;

/*
Create an inner join with countries on the left and economies on the right with USING. Do not alias your tables or columns.
Retrieve the country name, continent, and inflation rate for 2015.
*/
/*
Determine the maximum inflation rate for each continent in 2015 using the previous query as a subquery called subquery in the FROM clause.
Select the maximum inflation rate AS max_inf grouped by continent.
This will result in the six maximum inflation rates in 2015 for the six continents as one field table. (Don't include continent in the outer SELECT statement.)
*/

/*
SELECT c.name , c.continent
FROM countries AS c
INNER JOIN economies AS e
ON c.code = e.code
WHERE year = 2015 
;
*/

SELECT c.name , c.continent,inflation_rate
FROM countries AS c
INNER JOIN economies AS e 
ON c.code = e.code
WHERE year = 2015 
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT name , continent, inflation_rate
             FROM countries
             INNER JOIN economies
             ON countries.code = economies.code
             WHERE year = 2015) AS subquery
        GROUP BY continent);





/*
Use a subquery to get 2015 economic data for countries that do not have

gov_form of 'Constitutional Monarchy' or
'Republic' in their gov_form.
Here, gov_form stands for the form of the government for each country. 
Review the different entries for gov_form in the countries table.

Select the country code, inflation rate, and unemployment rate.
Order by inflation rate ascending.
Do not use table aliasing in this exercise.

*/

SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 AND code NOT IN 
(SELECT code
   FROM countries
   WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
ORDER BY inflation_rate ASC;


/*
In this exercise, you'll need to get the country names and other 2015 data in the economies table and the countries table for Central American countries with an official language.

Select unique country names. Also select the total investment and imports fields.
Use a left join with countries on the left. (An inner join would also work, but please use a left join here.)
Match on code in the two tables AND use a subquery inside of ON to choose the appropriate languages records.
Order by country name ascending.
Use table aliasing but not field aliasing in this exercise.
*/

SELECT DISTINCT c.name, total_investment, imports
FROM countries AS c
LEFT JOIN economies AS e
ON (c.code = e.code
  AND c.code IN (
    SELECT l.code
    FROM languages AS l
    WHERE official = 'true'
  ) )
WHERE year = 2015 AND region = 'Central America'
ORDER BY c.name ASC;



/*
Calculate the average fertility rate for each region in 2015.
Include the name of region, its continent, and average fertility rate aliased as avg_fert_rate.
Sort based on avg_fert_rate ascending.
Remember that you'll need to GROUP BY all fields that aren't included in the aggregate function of SELECT.
*/

-- choose fields
SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
-- left table
FROM countries AS c
-- right table
INNER JOIN populations AS p
-- join conditions
ON c.code = p.country_code
-- specific records matching a condition
WHERE year = 2015
-- aggregated for each what?
GROUP BY region, continent
-- how should we sort?
ORDER BY avg_fert_rate ASC;




/*
You are now tasked with determining the top 10 capital cities in Europe and the Americas in terms of a calculated percentage using city_proper_pop and metroarea_pop in cities.

Select the city name, country code, city proper population, and metro area population.
Calculate the percentage of metro area population composed of city proper population for each city in cities, aliased as city_perc.
Focus only on capital cities in Europe and the Americas in a subquery.
Make sure to exclude records with missing data on metro area population.
Order the result by city_perc descending.
Then determine the top 10 capital cities in Europe and the Americas in terms of this city_perc percentage.
*/

SELECT cities.name, cities.country_code, city_proper_pop, metroarea_pop,  
--city name, country code, city proper population, and metro area population
      city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities
WHERE cities.name IN
  (SELECT capital
   FROM countries
   WHERE (continent = 'Europe'
      OR continent LIKE '%America%'))
     AND metroarea_pop IS NOT NULL
ORDER BY city_perc DESC
LIMIT 10;




