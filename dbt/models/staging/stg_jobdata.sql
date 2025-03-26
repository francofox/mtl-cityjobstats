{{
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{ source('staging', 'jobdata') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['No_Affichage', 'Debut']) }} as jobid,

        -- Job unit and classification data
        {{ dbt.safe_cast("Unite_Niveau1", api.Column.translate_type("integer")) }} as unit_lv1,
        {{ dbt.safe_cast("Description_Unite_Niveau1", api.Column.translate_type("string")) }} as unit_lv1_desc,
        {{ dbt.safe_cast("Unite", api.Column.translate_type("integer")) }} as adminunit,
        {{ dbt.safe_cast("Description_Unite", api.Column.translate_type("string")) }} as adminunit_desc,
        {{ dbt.safe_cast("Accreditation", api.Column.translate_type("integer")) }} as classif,
        {{ dbt.safe_cast("Description_Accreditation", api.Column.translate_type("string")) }} as classif_desc,
        {{ dbt.safe_cast("Interne_Externe", api.Column.translate_type("string")) }} as internal_external,
        {{ dbt.safe_cast("Titre", api.Column.translate_type("string")) }} jobtitle,
        {{ dbt.safe_cast("Emploi", api.Column.translate_type("integer")) }} as jobcode,
        
        -- Job posting data
        {{ dbt.safe_cast("No_Affichage", api.Column.translate_type("string")) }} as posting_num,
        cast(Debut as date) as start_date,
        cast(Fin as date) as end_date,

        
        -- Applicant stats
        {{ dbt.safe_cast("Nombre_Postulant", api.Column.translate_type("integer")) }} as num_applying,
        {{ dbt.safe_cast("Nombre_Femme", api.Column.translate_type("integer")) }} as num_women,
        {{ dbt.safe_cast("Nombre_Handicape", api.Column.translate_type("integer")) }} as num_disabled,
        {{ dbt.safe_cast("Nombre_Minorite_Visible", api.Column.translate_type("integer")) }} as num_minority,
        {{ dbt.safe_cast("Nombre_Autochtone", api.Column.translate_type("integer")) }} as num_indigenous,
        {{ dbt.safe_cast("Nombre_Minorite_Ethnique", api.Column.translate_type("integer")) }} as num_ethnicminority
    
    from source
)

select * from renamed

