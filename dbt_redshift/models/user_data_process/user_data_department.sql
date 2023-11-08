{{ config(materialized='table', full_refresh = true) }}


select user_df.*,dal_df.department,CURRENT_DATE as run_date from {{ ref('user_data') }} as user_df left outer join {{ ref('department') }} as dal_df
on user_df.department_id = dal_df.id

