{{
    config(
        materialized='table'
    )
}}
with num_of_applicants as (
    select
        jobtitle_en as jobtitle,
        jobcode as jobcode,
        sum(num_applying) as total_applicants,
        count(*) as total_jobs,
        avg(num_applying) as avg_appl_per_job
    from {{ ref('fct_jobpostings') }}
    where internal_external = "Internal/External"
    group by 1, 2
), 
applicant_info as (
    select
        jobcode as jobcode,
        sum(num_women) as num_women_applicants,
        sum(num_disabled) as num_disabled_applicants,
        sum(num_minority) as num_minority_applicants,
        sum(num_indigenous) as num_indigenous_applicants,
        sum(num_ethnicminority) as num_ethnicminority_applicants
    from {{ ref('fct_jobpostings') }}
    where internal_external = "Internal/External"
    group by 1
)

select
    a.jobtitle as jobtitle,
    a.total_applicants as total_applicants,
    a.avg_appl_per_job as avg_applicants,
    i.num_women_applicants as women_applicants,
    case when a.total_applicants <> 0 then i.num_women_applicants / a.total_applicants else 0 end as percent_women,
    case when a.total_applicants <> 0 then (i.num_women_applicants / a.total_applicants) * a.avg_appl_per_job else 0 end as avg_num_women,
    i.num_disabled_applicants as disabled_applicants,
    case when a.total_applicants <> 0 then i.num_disabled_applicants / a.total_applicants else 0 end as percent_disabled,
    case when a.total_applicants <> 0 then (i.num_disabled_applicants / a.total_applicants) * a.avg_appl_per_job else 0 end as avt_num_disabled,
    i.num_minority_applicants as minority_applicants,
    case when a.total_applicants <> 0 then i.num_minority_applicants / a.total_applicants else 0 end as percent_minority,
    case when a.total_applicants <> 0 then (i.num_minority_applicants / a.total_applicants) * a.avg_appl_per_job else 0 end as avg_num_minority,
    i.num_indigenous_applicants as indigenous_applicants,
    case when a.total_applicants <> 0 then i.num_indigenous_applicants / a.total_applicants else 0 end as percent_indigenous,
    case when a.total_applicants <> 0 then (i.num_indigenous_applicants / a.total_applicants) * a.avg_appl_per_job else 0 end as avg_num_indigenous,
    i.num_ethnicminority_applicants as ethnicminority_applicants,
    case when a.total_applicants <> 0 then i.num_ethnicminority_applicants / a.total_applicants else 0 end as percent_ethnicminority,
    case when a.total_applicants <> 0 then (i.num_ethnicminority_applicants / a.total_applicants) * a.avg_appl_per_job else 0 end as avg_num_ethnicminority
from num_of_applicants a 
left join applicant_info i on i.jobcode = a.jobcode