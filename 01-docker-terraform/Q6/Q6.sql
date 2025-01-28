SELECT "Zone"
FROM zone_table
WHERE "LocationID" = (
    SELECT "DOLocationID"
    FROM (
        SELECT "DOLocationID", tip_amount
        FROM green_taxi_trips
        WHERE "PULocationID" = (
            SELECT "LocationID" 
            FROM zone_table 
            WHERE "Zone" = 'East Harlem North'
        )
        ORDER BY tip_amount DESC
        LIMIT 1
    ) AS filtered_trips
);
