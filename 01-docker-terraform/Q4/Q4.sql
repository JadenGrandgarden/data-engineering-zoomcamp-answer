SELECT TO_CHAR(lpep_pickup_datetime::timestamp, 'YYYY-MM-DD') AS longest_pickup_datelpep_pickup_datetime
FROM green_taxi_trips
WHERE trip_distance = (SELECT MAX(trip_distance) FROM green_taxi_trips)