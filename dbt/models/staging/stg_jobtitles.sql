{{
    config(
        materialized='table'
    )
}}

select
    jobcode,
    jobtitle_fr,
    jobtitle_en
from {{ source('staging', 'dim_jobtitles') }}