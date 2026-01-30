{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}

with rooms as (
    select * from {{ ref('stg_rooms') }}
),

final as (
    select
        room_id,
        room_name,
        room_type,
        construction_year,
        minimum_nights,
        cancellation_policy,
        instant_bookable,
        _loaded_at
    from rooms
)

select * from final