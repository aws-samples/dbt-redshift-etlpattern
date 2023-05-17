{{ config(materialized='table', full_refresh = true) }}
{%- set run_date = "CURRENT_DATE" -%}

select *,{{run_date}} as run_date from {{ ref('input_user_data') }} as user_df left outer join {{ ref('department') }} as dal_df
on user_df.id = dal_df.id

