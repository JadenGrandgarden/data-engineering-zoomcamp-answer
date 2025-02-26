{{ config(materialized='table') }}

with trifct_taxi_trips_quarterly_revenueps_data as ( 
    select * from {{ ref('fct_taxi_trips_quarterly_revenue') }}
)
SELECT service_type,
    year_quarter,
    quarter,
    pickup_year, 
    round((lead(revenue_year_quarter_total_amount) OVER ( PARTITION BY service_type, quarter order by pickup_year ) - revenue_year_quarter_total_amount) 
    * 100/revenue_year_quarter_total_amount, 2) as percentage_change  
FROM trifct_taxi_trips_quarterly_revenueps_data 
order by 1,3,4