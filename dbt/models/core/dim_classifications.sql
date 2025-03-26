{{
    config(
        materialized='table'
    )
}}

select
    *
FROM {{ ref('dim_classif') }}