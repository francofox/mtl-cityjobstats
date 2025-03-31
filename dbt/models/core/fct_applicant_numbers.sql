{{
    config(
        materialized='table'
    )
}}
with num_of_applicants as (
    select
        classif_en as classification,
        unit_lv1_en as lv1unit,
        adminunit_en as adminunit, 
        jobtitle_en as jobtitle,
        sum(num_applying) as total_applicants,
        count(*) as total_jobs,
        avg(num_applying) as avg_appl_per_job
    from {{ ref('fct_jobpostings') }}
    group by 1, 2, 3, 4
)
select * from num_of_applicants