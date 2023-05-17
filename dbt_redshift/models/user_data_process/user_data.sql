{{ config(materialized='table', full_refresh = true) }}

select * from {{ ref('fantasy_user_data') }}