{{
    config(
        materialized='table'
    )
}}

select 
    {{ dbt.safe_cast("unit_lv1", api.Column.translate_type("integer")) }} as unit_lv1,
    {{ dbt.safe_cast("unit_lv1_desc", api.Column.translate_type("string")) }} as unit_lv1_fr,
    {{ dbt.safe_cast("unit_lv1_desc_en", api.Column.translate_type("string")) }} as unit_lv1_en
from {{ ref('dim_lv1unit') }}