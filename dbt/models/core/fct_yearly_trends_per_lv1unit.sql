{{
    config(
        materialized='table'
    )
}}

with gen_info as (
    select
        start_date_month as month_of_posting,
        start_date_year as year_of_posting,
        unit_lv1 as lv1unit_number,
        unit_lv1_en as lv1unit,
        count(*) as num_postings
    from {{ ref('fct_jobpostings') }}
    group by 1, 2, 3, 4
)

select 
    lv1unit,
    lv1unit_number,
    month_of_posting,
    avg(num_postings) as average_postings
from gen_info
group by 1, 2, 3