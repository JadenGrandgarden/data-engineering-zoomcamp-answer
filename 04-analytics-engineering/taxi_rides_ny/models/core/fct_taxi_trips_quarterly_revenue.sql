{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
)
select service_type,
year_quarter,
quarter,
pickup_year,
sum(total_amount) as revenue_year_quarter_total_amount
from trips_data
where pickup_year = 2019 OR pickup_year=2020
group by 1,2,3,4
order by 1,3,4