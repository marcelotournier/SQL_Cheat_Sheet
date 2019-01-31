-- SQL QUERIES USING GOOGLE BIG QUERY
-- Dataset citibikes new_york

-- Options for FROM (depending of old or new Google Big Query UI)
-- Old UI: FROM [bigquery-public-data:new_york.citibike_stations]
-- New UI: FROM `bigquery-public-data.new_york.citibike_stations` 

--Query: look for installed stations:

SELECT is_installed,count(*) 
FROM [bigquery-public-data:new_york.citibike_stations] 
GROUP BY is_installed 
LIMIT 1000;



--Query: select only installed stations:

SELECT * 
FROM [bigquery-public-data:new_york.citibike_stations] 
WHERE is_installed = TRUE
LIMIT 1000;

-- identify only renting stationss:

SELECT * 
FROM [bigquery-public-data:new_york.citibike_stations] 
WHERE is_renting = TRUE
LIMIT 1000; 

-- identify only renting stationss:

SELECT * 
FROM [bigquery-public-data:new_york.citibike_stations] 
WHERE is_renting = TRUE 
LIMIT 1000; 

-- narrowing results
SELECT name,region_id,capacity, num_bikes_available
FROM `bigquery-public-data.new_york.citibike_stations` 
WHERE is_renting = TRUE 
AND is_installed = TRUE
ORDER BY num_bikes_available DESC
LIMIT 1000;



