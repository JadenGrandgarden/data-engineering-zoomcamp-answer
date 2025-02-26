{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata as (
    select *, 'FHV' as service_type
    from {{ref('stg_fhv_tripdata')}}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
    fhv_tripdata.dispatching_base_num,
    fhv_tripdata.pickup_datetime,
    fhv_tripdata.dropoff_datetime,
    EXTRACT(YEAR FROM fhv_tripdata.pickup_datetime) as pickup_year,
    EXTRACT(MONTH FROM fhv_tripdata.pickup_datetime) as pickup_month,
    EXTRACT(QUARTER FROM fhv_tripdata.pickup_datetime) as quarter,
    {{get_year_quarter("fhv_tripdata.pickup_datetime")}} as year_quarter,
    fhv_tripdata.pickup_locationid,
    fhv_tripdata.dropoff_locationid,
    fhv_tripdata.store_and_fwd_flag,
    Affiliated_base_number,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone,
    dropoff_zone.zone as dropoff_zone
from fhv_tripdata inner join dim_zones as pickup_zone
on fhv_tripdata.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_tripdata.dropoff_locationid = dropoff_zone.locationid