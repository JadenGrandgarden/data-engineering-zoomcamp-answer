{{
    config(
        materialized='table'
    )
}}

with trips_data as (
    SELECT * FROM {{ ref('fact_trips') }}
    where fare_amount > 0 and trip_distance > 0 and lower(payment_type_description) in ('cash', 'credit card')
),
fct_taxi_trips_monthly_fare_p90 as (
    select service_type, pickup_year, pickup_month,
    PERCENTILE_CONT(fare_amount,0.9) OVER (PARTITION BY service_type, pickup_year, pickup_month) as p90,
    PERCENTILE_CONT(fare_amount,0.95) OVER (PARTITION BY service_type, pickup_year, pickup_month) as p95,
    PERCENTILE_CONT(fare_amount,0.97) OVER (PARTITION BY service_type, pickup_year, pickup_month) as p97
    from trips_data
)
select *
from fct_taxi_trips_monthly_fare_p90
    where pickup_year = 2020 and pickup_month = 4