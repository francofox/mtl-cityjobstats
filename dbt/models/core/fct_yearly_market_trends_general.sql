{{
    config(
        materialized='table'
    )
}}

with gen_info as (
    select
        start_date_month as month_of_posting,
        start_date_year as year_of_posting,
        classif_en as classification,
        unit_lv1_en as lv1_unit,
        adminunit_en as adminunit,
        jobtitle_en as jobtitle,
        count(*) as num_postings
    from {{ ref('fct_jobpostings') }}
    where internal_external = "Internal/External"
    group by 1, 2, 3, 4, 5, 6
)
select
    month_of_posting,
    avg(num_postings) as average_postings
from gen_info
group by 1