{{
    config(
        materialized='table'
    )
}}
with fct_fhv_monthly_zone_traveltime as (
    select * , TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime,SECOND) as trip_duration
    from {{ref('dim_fhv_trips')}}
),
fct_fhv_monthly_zone_traveltime_p90 as (
select pickup_year, pickup_month, pickup_zone, dropoff_zone,
        PERCENTILE_CONT(trip_duration,0.9) OVER (PARTITION BY pickup_year, pickup_month, pickup_locationid, dropoff_locationid) as p90,
        row_number() over(partition by pickup_year, pickup_month, pickup_locationid, dropoff_locationid) as rn
from fct_fhv_monthly_zone_traveltime
where pickup_year=2019 and pickup_month=11 and lower(pickup_zone) in ('newark airport', 'soho', 'yorkville east')
)
SELECT pickup_year, pickup_month, pickup_zone, dropoff_zone, p90
FROM fct_fhv_monthly_zone_traveltime_p90
where p90 in (select max(p90) from fct_fhv_monthly_zone_traveltime_p90 where p90 not in (select max(p90) from fct_fhv_monthly_zone_traveltime_p90 group by pickup_zone) group by pickup_zone)
and rn = 1