--Example SQL Queries from Last Class

/* 
Unfortunately, we didn't get to go as deep as I would have liked in our last session. 
I thought class was going to end at 4 so there would be ample time to get back to the 
exploratory data analysis. I'll share a series of SQL queries to help you look at the 
data some more on your own. I'll also share queries on a another data set 
(citibike trips) for you to see how we could gather additional insights from event 
data. I highly recommend running these queries and examining the results when you 
have an opportunity. You'll find some interesting trends in the most popular rides 
in New York, which likely correlates with the capacity issues we were discussing. 

Please note that there are subtle differences in the syntax (because of Google 
BigQuery) and that there are some more advanced methods in here that aren’t covered 
in the class. */

-- all installed bike stations

SELECT

  *

FROM

  `bigquery-public-data.new_york_citibike.citibike_stations`

WHERE

  is_installed = TRUE;

 

-- the distribution of stations by bike capacity

SELECT

  capacity,

  COUNT(*) AS num_stations

FROM

  `bigquery-public-data.new_york_citibike.citibike_stations`

WHERE

  is_installed = TRUE

GROUP BY

  capacity

ORDER BY

  capacity desc;

 

-- The percentage of empty stations by region

SELECT

  region_id,

  SUM(CASE

      WHEN num_bikes_available = 0 THEN 1

      ELSE 0 END) AS station_empty_count,

  COUNT(*) AS station_count,

  ROUND(SUM(CASE

        WHEN num_bikes_available = 0 THEN 1

        ELSE 0 END)/COUNT(*) * 100,1) AS empty_station_percentage

FROM

  `bigquery-public-data.new_york_citibike.citibike_stations`

WHERE

  is_installed = TRUE

GROUP BY

  region_id;

 

-- The percentage of full stations by region

SELECT

  region_id,

  SUM(CASE

      WHEN num_bikes_available = capacity THEN 1

      ELSE 0 END) AS station_full_count,

  COUNT(*) AS station_count,

  ROUND(SUM(CASE

        WHEN num_bikes_available = capacity THEN 1

        ELSE 0 END)/COUNT(*) * 100,1) AS full_station_percentage

FROM

  `bigquery-public-data.new_york_citibike.citibike_stations`

WHERE

  is_installed = TRUE

GROUP BY

  region_id;

 

  -- avg and median trip duration by start station

SELECT

  start_station_id,

  start_station_name,

  AVG(tripduration)/60/60 AS avg_trip_duration,

  COUNT(*) AS num_trips--,

  --median(tripduration)/60  as med_trip_duration

FROM

  `bigquery-public-data.new_york_citibike.citibike_trips`

GROUP BY

  start_station_id,

  start_station_name

ORDER BY

  avg_trip_duration DESC

LIMIT

  25;

 

  -- avg and median trip duration by start station

SELECT

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name,

  AVG(tripduration)/60/60 AS avg_trip_duration,

  COUNT(*) AS num_trips--,

  --median(tripduration)/60  as med_trip_duration

FROM

  `bigquery-public-data.new_york_citibike.citibike_trips`

GROUP BY

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name

HAVING

  num_trips >= 100

ORDER BY

  avg_trip_duration DESC

LIMIT

  25;

 

  -- avg and median trip duration by start station

SELECT

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name,

  AVG(tripduration)/60 AS avg_trip_duration,

  COUNT(*) AS num_trips--,

  --median(tripduration)/60  as med_trip_duration

FROM

  `bigquery-public-data.new_york_citibike.citibike_trips`

GROUP BY

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name

HAVING

  num_trips >= 100

ORDER BY

  avg_trip_duration ASC

LIMIT

  25;

  -- avg and median trip duration by start station

SELECT

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name,

  AVG(duration_sec)/60 AS avg_trip_duration,

  COUNT(*) AS num_trips--,

  --median(tripduration)/60  as med_trip_duration

FROM

  `bigquery-public-data.san_francisco.bikeshare_trips`

GROUP BY

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name

HAVING

  num_trips >= 100

ORDER BY

  avg_trip_duration ASC

LIMIT

  25;

 

  -- avg and median trip duration by start station

SELECT

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name,

  AVG(duration_sec)/60 AS avg_trip_duration,

  COUNT(*) AS num_trips--,

  --median(tripduration)/60  as med_trip_duration

FROM

  `bigquery-public-data.san_francisco.bikeshare_trips`

GROUP BY

  start_station_id,

  start_station_name,

  end_station_id,

  end_station_name

HAVING

  num_trips >= 100

ORDER BY

  num_trips desc

LIMIT

  25;