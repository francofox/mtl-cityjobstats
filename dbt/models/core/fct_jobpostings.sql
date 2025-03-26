{{
    config(
        materialized='table'
    )
}}

with jobdata as (
    select * from {{ ref('stg_jobdata') }}
),

jobcodes as (
    select * from {{ ref('dim_jobcodes') }}
),

classifications as (
    select * from {{ ref('dim_classifications') }}
),

lv1units as (
    select * from {{ ref('dim_lv1units') }}
)

compiled as (
    select 
        jobid,
        unit_lv1,
        unit_lv1_desc as unit_lv1_fr,
        lv1units.unit_lv1_en as unit_lv1_en,
        
        adminunit,
        adminunit_desc,

        classif,
        classif_desc as classif_fr,
        classifications.classif_en,

        case when internal_external = "Interne/Externe" then "Internal/External" else "Internal" as internal_external,
        
        jobtitle as jobtitle_fr,
        jobcodes.jobtitle_en as jobtitle_en,
        jobcode,
        
        posting_num,
        start_date,
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
)

select * from compiled