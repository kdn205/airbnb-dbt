{{
    config(
        materialized='table',
        tags=['dimension']
    )
}}



with date_spine as (
    select 
        date_add('2015-01-01', interval row_number() over (order by 1) - 1 day) as date
    from 
        unnest(generate_array(1, 5844)) as num -- 16 years * 365.25 days
),

dates as (
    select
        date,
        -- Date ID as integer YYYYMMDD
        cast(format_date('%Y%m%d', date) as int64) as date_id,
        
        -- Date components
        extract(year from date) as year,
        extract(quarter from date) as quarter,
        extract(month from date) as month,
        extract(week from date) as week_of_year,
        extract(day from date) as day,
        extract(dayofweek from date) as day_of_week,
        extract(dayofyear from date) as day_of_year,
        
        -- Date labels
        format_date('%B', date) as month_name,
        format_date('%b', date) as month_name_short,
        format_date('%A', date) as day_name,
        format_date('%a', date) as day_name_short,
        
        -- Flags
        case when extract(dayofweek from date) in (1, 7) then true else false end as is_weekend,
        case when extract(month from date) in (12, 1, 2) then 'Winter'
             when extract(month from date) in (3, 4, 5) then 'Spring'
             when extract(month from date) in (6, 7, 8) then 'Summer'
             else 'Fall' end as season,
        
        -- First and last day flags
        case when extract(day from date) = 1 then true else false end as is_first_day_of_month,
        case when date = last_day(date) then true else false end as is_last_day_of_month,
        
        current_timestamp() as _loaded_at
    from date_spine
)

select * from dates
order by date