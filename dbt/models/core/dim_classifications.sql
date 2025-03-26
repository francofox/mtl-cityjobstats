{{
    config(
        materialized='table'
    )
}}

select
    classif,
    classif_desc as classif_fr,
    classif_desc_en as classif_en
FROM {{ ref('classifications') }}