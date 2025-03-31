{{
    config(
        materialized='table'
    )
}}

with gen_info as (
    select
        start_date_month as month_of_posting,
        start_date_year as year_of_posting,
        jobtitle_en as jobtitle,
        jobcode as jobcode,
        count(*) as num_postings
    from {{ ref('fct_jobpostings') }}
    group by 1, 2, 3, 4
)

select 
    jobtitle,
    jobcode,
    month_of_posting,
    avg(num_postings) as average_postings
from gen_info
group by 1, 2, 3