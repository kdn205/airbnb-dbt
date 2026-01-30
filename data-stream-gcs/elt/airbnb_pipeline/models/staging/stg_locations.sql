{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('raw_data', 'locations') }}
),

cleaned as (
    select
        location_id,
        trim(neighbourhood_group) as neighbourhood_group,
        trim(neighbourhood) as neighbourhood,
        lat,
        long,
        trim(country) as country,
        upper(trim(country_code)) as country_code,
        current_timestamp() as _loaded_at
    from source
    where lat is not null 
      and long is not null
)

select * from cleaned