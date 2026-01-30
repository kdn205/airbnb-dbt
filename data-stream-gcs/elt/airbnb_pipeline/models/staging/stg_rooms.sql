{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('raw_data', 'rooms') }}
),

cleaned as (
    select
        room_id,
        trim(name) as room_name,
        host_id,
        location_id,
        trim(room_type) as room_type,
        construction_year,
        coalesce(minimum_nights, 1) as minimum_nights,
        coalesce(availability_365, 0) as availability_365,
        trim(house_rules) as house_rules,
        trim(cancellation_policy) as cancellation_policy,
        coalesce(instant_bookable, false) as instant_bookable,
        current_timestamp() as _loaded_at
    from source
)

select * from cleaned