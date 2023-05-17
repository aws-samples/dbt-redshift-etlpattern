{% snapshot fantasy_salesforce_user_snapshot_allcols %}
{{ config(
    target_schema='dev',
    unique_key='subscriber_id',
    strategy='check',
    check_cols='all'
) }}

select * from {{ ref('user_data_dal') }} 

{% endsnapshot %}