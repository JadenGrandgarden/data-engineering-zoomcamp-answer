Select "Zone" From zone_table where "LocationID" in 
(select "PULocationID"
from green_taxi_trips
where lpep_pickup_datetime::date = '2019-10-18'
group by "PULocationID"
having SUM("total_amount") > 13000);