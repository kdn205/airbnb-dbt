{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('raw_data', 'pricing') }}
),

cleaned as (
    select
        pricing_id,
        room_id,
        cast(price as numeric) as price,
        cast(service_fee as numeric) as service_fee,
        cast(effective_from as date) as effective_from,
        current_timestamp() as _loaded_at
    from source
    where price is not null
      and price > 0
)

select * from cleaned