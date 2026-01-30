{{
    config(
        materialized='table',
        tags=['fact']
    )
}}

with rooms as (
    select * from {{ ref('stg_rooms') }}
),

pricing as (
    select * from {{ ref('stg_pricing') }}
),

review_stats as (
    select * from {{ ref('stg_review_stats') }}
),

-- Get the most recent price for each room
latest_pricing as (
    select 
        room_id,
        price,
        service_fee,
        effective_from,
        row_number() over (partition by room_id order by effective_from desc) as rn
    from pricing
),

current_pricing as (
    select 
        room_id,
        price,
        service_fee,
        effective_from
    from latest_pricing
    where rn = 1
),

-- Calculate estimated revenue and occupancy metrics
room_metrics as (
    select
        r.room_id,
        r.host_id,
        r.location_id,
        p.price,
        p.service_fee,
        r.availability_365,
        
        -- Calculate occupancy days (assuming rooms not available are booked)
        365 - r.availability_365 as occupancy_days,
        
        -- Estimated annual revenue (price * occupied days)
        p.price * (365 - r.availability_365) as estimated_revenue,
        
        -- Review metrics
        coalesce(rs.number_of_reviews, 0) as number_of_reviews,
        coalesce(rs.reviews_per_month, 0) as reviews_per_month,
        coalesce(rs.review_rate_number, 0) as review_rate_number,
        
        -- Date reference (use effective_from or current date)
        coalesce(
            cast(format_date('%Y%m%d', p.effective_from) as int64),
            cast(format_date('%Y%m%d', current_date()) as int64)
        ) as date_id,
        
        current_timestamp() as _loaded_at
        
    from rooms r
    left join current_pricing p on r.room_id = p.room_id
    left join review_stats rs on r.room_id = rs.room_id
),

final as (
    select
        -- Fact ID (unique identifier for each row)
        generate_uuid() as fact_id,
        
        -- Foreign keys to dimensions
        room_id,
        host_id,
        location_id,
        date_id,
        
        -- Measures (numerical metrics)
        price,
        service_fee,
        availability_365,
        occupancy_days,
        estimated_revenue,
        number_of_reviews,
        reviews_per_month,
        review_rate_number,
        
        -- Metadata
        _loaded_at
        
    from room_metrics
    where price is not null  -- Only include rooms with pricing
)

select * from final