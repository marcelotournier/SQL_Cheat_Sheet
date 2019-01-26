-- SQL Cookbook Codes

/* This code was built to learn the basics of SQL queries in databases.
   To train the codes, please enter the films database in DataCamp Intro to SQL Course:
   https://www.datacamp.com/courses/intro-to-sql-for-data-science
  */

-- SQL Basics:


-- SELECT is for Printing results of your query:

SELECT 'hello world!';

-- Writing comments:

--SELECT 'commenting only 1 line';

--Commenting multiple lines:

/* SELECT *
FROM films
WHERE duration IS NOT null
ORDER BY duration DESC
LIMIT 10; */

--Assigning variables in SQL:

SELECT 3.0/9 as hit_rate, 6 as revenue, 10 as costs;

-- * is called splat, or star (all items):

SELECT *
FROM films;

-- We can subset different columns:

SELECT title,country
FROM films;

-- Readability counts:

SELECT [columns]
FROM [table name];

-- Selecting DISTINCT(unique) values:

SELECT DISTINCT language
FROM films;

-- LIMIT end of lines queried (similar to "head" function):

SELECT title,release_year
FROM films
LIMIT 3;

-- OFFSET pass and ignore some rows to display view:

SELECT id
FROM films
OFFSET 55;

-- OFFSET and LIMIT can be combined to display specific 
-- positions in data tables:

SELECT id
FROM films
OFFSET 665
LIMIT 1;

-- WHERE helps to subset the table with filters

SELECT *
FROM films
WHERE release_year = '1990'
LIMIT 1;

-- Careful with semicolon positions 
-- (in this case, LIMIT can be ignored in some SQL environments):

SELECT *
FROM films
WHERE release_year = '1990';
LIMIT 1

-- ORDER BY ASC(or DESC) can be useful to sort values in 
-- ASCendent/DESCendent order

SELECT id,title
FROM films
ORDER BY title ASC;

-- We can order multiple columns at once:

SELECT title,release_year,country
FROM films
ORDER BY release_year DESC,release_year DESC;

-- What are the 10 top movies in duration?

SELECT *
FROM films
ORDER BY duration DESC
LIMIT 10;
--it will show nulls....

-- How to remove rows with null values:

SELECT *
FROM films
WHERE duration IS NOT null
ORDER BY duration DESC
LIMIT 10;

-- Get 5 random rows, using the RANDOM() function:

SELECT *
FROM films
ORDER BY RANDOM()
LIMIT 5;

-- Multiple operations for data cleaning:
/* - filter null values
   - input update missing values
   - extract subsets income groups, continents */


--
-- CLASS 2: HOW TO FILTER CONDITIONS:
--


-- let's find an anomaly in the 'films' database:
SELECT *
FROM films
WHERE title = 'Halloween'
LIMIT 10;
-- there will be 3 films, with different id's

-- Titles and duration where duration is less than 1 hour:
SELECT title,duration
FROM films
WHERE duration < 60;

-- Aliases: AS
SELECT title duration -- this is the same of SELECT title AS duration
FROM films
LIMIT 10;

SELECT title duration, duration -- now we have 2 duration columns!
FROM films
LIMIT 10;

SELECT title duration, duration AS dur -- now we got 2 duration columns!
FROM films
WHERE dur < 60; -- in some SQL flavors it works, but not always...

-- all title and release_year from the 1960s:
SELECT title,release_year 
FROM films
WHERE release_year BETWEEN 1960 AND 1969;

-- Alternative:
SELECT title,release_year
FROM films
WHERE release_year >= 1960 AND release_year <= 1969;


-- titles and certification where certification is not R:
SELECT title,certification,release_year
FROM films
WHERE certification != 'R';

-- get movies in different years
SELECT title,certification,release_year
FROM films
WHERE certification = 'R' AND release_year = '2001';

-- How the number of R Movies evolved over time? 
SELECT COUNT(certification) AS number_of_R_films , release_year
FROM films
WHERE certification = 'R' 
GROUP BY release_year
ORDER BY release_year;

-- Seeing title, certification, release_year for films not R rated,
-- sorting certification on a descending order:
SELECT title, certification, release_year
FROM films
WHERE certification != 'R' 
ORDER BY certification DESC;

-- Select titles and countries of German, Spanish or French language:
SELECT title, country
FROM films
WHERE language = 'German' OR language = 'Spanish' OR language = 'French';

-- Other alternative for doing this, using IN and a tuple:
SELECT title, country
FROM films
WHERE language IN ('German','Spanish','French');

-- Find multiple conditionals: 
SELECT title, country,release_year
FROM films
WHERE (country = 'USA' OR country = 'UK') 
AND (release_year > 2001 OR release_year < 1979) --one option 
--WHERE country IN ('USA','UK') 
AND release_year NOT BETWEEN 1979 AND 2001 --other option
;

-- Good queries for recommendation algorithm:
SELECT *
FROM films
WHERE country IN ('USA','UK') 
AND (release_year > 2000 OR release_year < 1980) 
AND title LIKE '%Dog%' AND duration BETWEEN 90 AND 120
AND gross IS NOT NULL;


--Advanced string queries:
--
SELECT title, certification, release_year
FROM films
WHERE title LIKE '%Elm Street%'; --contains item
WHERE title LIKE 'Elm Street%'; --starts with item
WHERE title LIKE '%Elm Street'; --ends with item
WHERE title LIKE '%_r%'; -- have r in the second position
WHERE title LIKE '%a_%_%'; -- starts with a and have at least 3 characters
WHERE title LIKE '%a%o%'; -- contains anything containing a and o

--Selecting film containing Alexander, and Horrible, and Bad Day:
SELECT *
FROM films
WHERE title LIKE 'Alexander%Horrible%Bad%Day';


-- Working with dates:

--Find all name,birthdate in january
SELECT name,birthdate
FROM people
WHERE birthdate BETWEEN '1975-01-01' AND '1975-01-31';

--AGGREGATE FUNCTIONS

--Get min max values for all numeric columns of movies
--rename as max_column or as_min_column
SELECT 
MIN(release_year) AS min_release_year,
MAX(release_year) AS max_release_year,
MIN(duration) AS min_duration,
MAX(duration) AS max_duration,
MIN(gross) AS min_duration,
MAX(gross) AS max_duration,
MIN(budget) AS min_budget,
MAX(budget) as max_budget
FROM films
;

-- average, sum and std for budget col:
SELECT 
AVG(budget) AS avg_budget,
SUM(budget) AS total_budget,
STDDEV(budget) AS stdev_budget
FROM films
;

-- How many null values are in the certification column:
SELECT
COUNT(*) -- count all rows! if COUNT(certification), it will count non-null values
FROM films
WHERE certification IS NULL
;

-- Querying using CAST to change variable type VARCHAR = String
SELECT release_year
FROM films
WHERE CAST(release_year AS VARCHAR) LIKE '199%'
;


-- How to see all unique values from a column:
SELECT COUNT(DISTINCT certification)
FROM films
;


-- count number of certifications per certification:
SELECT certification,COUNT(*)
FROM films
GROUP BY certification
ORDER BY COUNT(certification) DESC
;

-- How movie certifications are evolving over time
SELECT release_year,certification,COUNT(*)
FROM films
GROUP BY certification,release_year
ORDER BY certification,release_year
;

-- How to pull data from the database:  click "lightning" and pull data from server

-- How to put special operations, like standardization - USE SUBQUERIES (inside ())
SELECT title,duration,
(duration-(SELECT AVG(duration) from films))/(SELECT STDDEV(duration) FROM films) AS std_duration 

FROM films

;

--
--GROUP BY
--

-- How many languages are in movies?
SELECT country,COUNT(DISTINCT(language))
FROM films
GROUP BY country
ORDER BY count DESC
;


-- total budget per certification per year. sort year asc and certif asc
SELECT release_year,certification,SUM(budget) AS sum_budget
FROM films
GROUP BY release_year,certification
ORDER BY release_year ASC,certification ASC
;


--HAVING - filter further results
-- which countries have more than 50 films
SELECT country,COUNT(title)
FROM films
GROUP BY country
HAVING COUNT(title) > 50 -- countries which have more than 50 films
;

-- films countries > 4 languages

SELECT country,COUNT(DISTINCT language)
FROM films
GROUP BY country
HAVING COUNT(DISTINCT language) > 4 -- countries which have more than 50 films
;



