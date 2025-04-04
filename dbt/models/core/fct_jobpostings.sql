{{
    config(
        materialized='table',
        partition_by={
            "field": "start_date",
            "data_type": "date",
            "granularity": "month"
        }
    )
}}

with jobdata as (
    select * from {{ ref('stg_jobdata') }}
),

jobcodes as (
    select * from {{ ref('dim_jobtitles') }}
),

classifications as (
    select * from {{ ref('dim_classifications') }}
),

lv1units as (
    select * from {{ ref('dim_lv1units') }}
),

au as (
    select * from {{ ref('dim_adminunits') }}
),

compiled as (
    select 
        jobid,
        jobdata.unit_lv1 as unit_lv1,
        jobdata.unit_lv1_desc as unit_lv1_fr,
        lv1units.unit_lv1_en as unit_lv1_en,
        
        jobdata.adminunit_id as adminunit_id,
        jobdata.adminunit as adminunit,
        jobdata.adminunit_desc as adminunit_fr,
        au.adminunit_en as adminunit_en,

        jobdata.classif,
        jobdata.classif_desc as classif_fr,
        classifications.classif_en as classif_en,

        case when internal_external = "Interne/Externe" then "Internal/External" else "Internal" end as internal_external,
        
        jobdata.jobcode,        
        jobdata.jobtitle as jobtitle_fr,
        jobcodes.jobtitle_en as jobtitle_en,

        posting_num,
        start_date,
        extract(month from start_date) as start_date_month,
        extract(year from start_date) as start_date_year,
        end_date,

        num_applying,
        num_women,
        num_disabled,
        num_minority,
        num_indigenous,
        num_ethnicminority
    from jobdata
    left join jobcodes on jobdata.jobcode = jobcodes.jobcode
    left join lv1units on jobdata.unit_lv1 = lv1units.unit_lv1
    left join classifications on jobdata.classif = classifications.classif
    left join au on jobdata.adminunit_id = au.adminunit_id
)

select * from compiled