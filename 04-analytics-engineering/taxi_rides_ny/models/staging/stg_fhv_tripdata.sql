{{ config(materialized="view") }}

with
    tripdata as (
        select *
        from {{ source("staging", "fhv_tripdata") }}
        where dispatching_base_num is not null
    )
select
    -- identifiers
    dispatching_base_num,
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }}
    as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }}
    as dropoff_locationid,
    SR_Flag as store_and_fwd_flag,
    Affiliated_base_number
from tripdata

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
-- stg_green_tripdata
{% if var("is_test_run", default=true) %} limit 100 {% endif %}
