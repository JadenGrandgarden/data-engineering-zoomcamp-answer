{{ config(materialized="table") }}
with trips_data as (select * from {{ ref("fact_trips") }})
select
    trips_data.tripid,
    trips_data.vendorid,
    trips_data.service_type,
    trips_data.ratecodeid,
    trips_data.pickup_locationid,
    trips_data.dropoff_locationid,
    trips_data.pickup_datetime,
    trips_data.dropoff_datetime,
    trips_data.store_and_fwd_flag
from trips_data
where
    pickup_datetime >= cast(
        current_date
        - interval '{{ env_var("DAYS_BACK", var("days_back", "30")) }}' day as timestamp
    )
