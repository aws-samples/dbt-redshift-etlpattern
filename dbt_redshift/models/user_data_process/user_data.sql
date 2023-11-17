{{ config(materialized='table', full_refresh = true) }}

select * from {{ ref('input_user_data') }}