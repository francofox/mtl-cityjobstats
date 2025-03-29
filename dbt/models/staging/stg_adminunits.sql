{{
    config(
        materialized='table'
    )
}}

select 
    adminunit_id,
    adminunit_fr,
    adminunit_en
from {{ source('staging', 'dim_adminunits') }}