{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}

with hosts as (
    select * from {{ ref('stg_hosts') }}
),

final as (
    select
        host_id,
        host_name,
        host_identity_verified,
        calculated_host_listings_count,
        _loaded_at
    from hosts
)

select * from final