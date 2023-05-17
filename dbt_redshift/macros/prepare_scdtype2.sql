{% macro prepare_scdtype2(target, source, key_cols) -%}
    {%- set run_date = 'CURRENT_DATE' -%}
    {%- set curr_time = 'CURRENT_TIMESTAMP' -%}
    {% set dest_columns = adapter.get_columns_in_relation({{source}}) %}
    {% set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') %}



    {%- set source_relation = adapter.get_relation(database=this_database, schema=this_dataset, identifier=this_table) -%} 
    {%- set columns = adapter.get_columns_in_relation(source_relation) -%}

    {% set query %}

    
    
    update {{source}} set run_date = {{ run_date }};
    
    update {{target}} set dbt_valid_to = {{curr_time}} where {{key_col}} in (select {{key_col}} from {{source}});

    insert into {{source}} 

    select 
    {%- for col in all_columns if col.name not in except_col_names %}  
    {% if col.data_type == 'BOOLEAN' %}  
    max({{ col.name|lower }}) as {{ col.name|lower }}{%- if not loop.last %},{{ '\n  ' }}{% endif %}
    {% endif %}
    {%- endfor %}

    
     
    {% endset %}

    {% do run_query(query) %}

    
    with old_data as (
    select * from {{ target }} where run_date = run_date - 1 
                                and  {{key_col}} not in (select {{key_col}} from {{source}}))

    select * from  {{source}} union all  old_data;                         
    update source set run_date =  run_date

    update {{ target }}
    set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to
    from {{ source }} as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_scd_id::text = {{ target }}.dbt_scd_id::text
      and DBT_INTERNAL_SOURCE.dbt_change_type::text in ('update'::text, 'delete'::text)
      and {{ target }}.dbt_valid_to is null;

    insert into {{ target }} ({{ insert_cols_csv }})
    select {% for column in insert_cols -%}
        DBT_INTERNAL_SOURCE.{{ column }} {%- if not loop.last %}, {%- endif %}
    {%- endfor %}
    from {{ source }} as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_change_type::text = 'insert'::text;
{% endmacro %}

select from <target-table> into <current_snapshot_temp_table> where  run_date=<run-date> -1;
update  <current_snapshot_temp_table> set run_date=<run-date> ;
delete from <current_snapshot_temp_table> where <keys> in (select <keys> from <load-ready-table>);
insert into <target-table>  from <current_snapshot_temp_table>