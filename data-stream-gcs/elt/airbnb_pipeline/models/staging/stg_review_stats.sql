{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('raw_data', 'review_stats') }}
),

cleaned as (
    select
        room_id,
        coalesce(number_of_reviews, 0) as number_of_reviews,
        cast(last_review as date) as last_review,
        coalesce(cast(reviews_per_month as numeric), 0) as reviews_per_month,
        coalesce(cast(review_rate_number as numeric), 0) as review_rate_number,
        current_timestamp() as _loaded_at
    from source
)

select * from cleaned