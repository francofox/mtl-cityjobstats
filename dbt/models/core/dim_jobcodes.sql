{{
    config(
        materialized='table'
    )
}}

select 
    {{ dbt.safe_cast("jobcode", api.Column.translate_type("integer")) }} as jobcode,
    {{ dbt.safe_cast("jobtitle_fr", api.Column.translate_type("string")) }} as jobtitle_fr,
    {{ dbt.safe_cast("jobtitle_en", api.Column.translate_type("string")) }} as jobtitle_en
from {{ ref('jobcodes') }}