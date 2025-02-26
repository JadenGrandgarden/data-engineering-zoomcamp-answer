{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
)
-- , with fct_taxi_trips_year_quarterly_revenue as (
select service_type,
year_quarter,
quarter,
pickup_year,
sum(total_amount) as revenue_year_quarter_total_amount
from trips_data
where pickup_year = 2019 OR pickup_year=2020
group by 1,2,3,4
order by 1,3,4
-- )
-- SELECT service_type,
--     year_quarter,
--     quarter,
--     pickup_year, 
--     round((revenue_year_quarter_total_amount - lag(revenue_year_quarter_total_amount) * 100/lag(revenue_year_quarter_total_amount)
--              OVER ( PARTITION BY service_type, quarter order by pickup_year ), 2) as percentage_change  
-- FROM fct_taxi_trips_year_quarterly_revenue 
-- order by 1,3,4