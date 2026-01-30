{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('raw_data', 'hosts') }}
),

cleaned as (
    select
        host_id,
        trim(host_name) as host_name,
        coalesce(host_identity_verified, false) as host_identity_verified,
        coalesce(calculated_host_listings_count, 0) as calculated_host_listings_count,
        current_timestamp() as _loaded_at
    from source
)

select * from cleaned