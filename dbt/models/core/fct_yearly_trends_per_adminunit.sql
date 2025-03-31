{{
    config(
        materialized='table'
    )
}}

with gen_info as (
    select
        start_date_month as month_of_posting,
        start_date_year as year_of_posting,
        adminunit as adminunit_number,
        adminunit_en as adminunit,
        count(*) as num_postings
    from {{ ref('fct_jobpostings') }}
    group by 1, 2, 3, 4, 5, 6
)

select 
    adminunit,
    adminunit_number,
    month_of_posting,
    avg(num_postings)
from gen_info
group by 1, 2, 3