{% snapshot fantasy_salesforce_user_snapshot %}
{{ config(
    target_schema='dev',
    unique_key='subscriber_id',
    strategy='timestamp',
    updated_at='updated_at',
    on_schema_change = 'append_new_columns'
) }}

select * from {{ ref('user_data_department') }}

{% endsnapshot %}