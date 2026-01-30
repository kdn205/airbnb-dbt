{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}

with locations as (
    select * from {{ ref('stg_locations') }}
),

final as (
    select
        location_id,
        neighbourhood_group,
        neighbourhood,
        lat,
        long,
        country,
        country_code,
        _loaded_at
    from locations
)

select * from final