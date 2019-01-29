-- SQL ADVANCED QUERIES:

/* This code was built to learn the basics of SQL queries in databases.
   To train the codes, please enter the films database in DataCamp Intro to SQL Course:
   https://www.datacamp.com/courses/intro-to-sql-for-data-science
  */

-- HOW TO GET THE NUMBER OF FILMS BY DECADE, STEP BY STEP



-- 1) We already learned that SELECT works as "print". Ex:
SELECT '1920s' AS decade; -- would print the column "decade" with only one value: "1920s"

/* Let's try to create a subquery to COUNT all movies  
(putting a SELECT statement inside parenthesis) to get all movies from the 1920s.
Let's call this column "number of films":
*/
SELECT '1920s' AS decade,
(SELECT DISTINCT COUNT(*) 
FROM films 
WHERE release_year IS NOT NULL AND release_year > '1920' AND release_year <= '1930') AS number_of_films;

/* good!  We are on our way...  BUT - if we create all subqueries separated by a comma,
we would get an error, because of the same names on the column aliases ("decade" and "number_of_films"),
because SQL doesn't understand that you want to get the query result as rows and two columns...

So, you can remove the aliases.  

PROBLEM SOLVED!!!! 
...but the results wouldn't be so beautiful to visualize (and not a good practice in data cleaning):
*/
SELECT 
(SELECT '1920s'),
(SELECT DISTINCT COUNT(*) 
FROM films 
WHERE release_year IS NOT NULL AND release_year > '1920' AND release_year <= '1930'),
(SELECT '1930s'),
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1930' AND release_year <= '1940'),
(SELECT '1940s'),
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1940' AND release_year <= '1950')
;

-- I did some research on the web and found the UNION ALL statement.  What do UNION ALL do?
SELECT '1920s' AS decade
UNION ALL
SELECT '1930s' AS decade
UNION ALL
SELECT '1940s' AS decade
;

-- COOL! it joins all SELECT queries into one row!  Let's test on two rows of our original decade query:

--same code of line 11:
SELECT '1920s' AS decade,
(SELECT DISTINCT COUNT(*) 
FROM films 
WHERE release_year IS NOT NULL AND release_year > '1920' AND release_year <= '1930') AS number_of_films

UNION ALL

--code of decade of 1930s:
SELECT '1930s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1930' AND release_year <= '1940') AS number_of_films

/* You need to add UNION ALL to each new row of data that you want do add to the query.
   IMPORTANT: The column aliases in all rows 
   ("decade" and "number_of_films") need to be exacltly the same. */
UNION ALL

SELECT '1940s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1940' AND release_year <= '1950') AS number_of_films
;

-- YAY!!!! It worked!  Now, let's just finish the code, with more decades.

-- FINAL QUERY:

SELECT '1920s' AS decade,
(SELECT DISTINCT COUNT(*) 
FROM films 
WHERE release_year IS NOT NULL AND release_year > '1920' AND release_year <= '1930') AS number_of_films

UNION ALL

SELECT '1930s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1930' AND release_year <= '1940') AS number_of_films
UNION ALL

SELECT '1940s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1940' AND release_year <= '1950') AS number_of_films
UNION ALL

SELECT '1950s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1950' AND release_year <= '1960') AS number_of_films
UNION ALL

SELECT '1960s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1960' AND release_year <= '1970') AS number_of_films
UNION ALL

SELECT '1970s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1970' AND release_year <= '1980') AS number_of_films
UNION ALL

SELECT '1980s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1980' AND release_year <= '1990') AS number_of_films
UNION ALL

SELECT '1990s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '1990' AND release_year <= '2000') AS number_of_films
UNION ALL

SELECT '2000s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '2000' AND release_year <= '2010') AS number_of_films
UNION ALL

SELECT '2010s' AS decade,
(SELECT DISTINCT COUNT(*)
FROM films
WHERE release_year IS NOT NULL AND release_year > '2010' AND release_year <= '2020') AS number_of_films

-- You don't need an UNION ALL here, as this is the last row of your query.
;

-- Lots of movies in the 2000's (although the 1980's were the best of the breed IMO...)


