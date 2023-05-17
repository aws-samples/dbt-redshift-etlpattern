{% macro generate_snapshot_data(target, source, key_col) -%}
    {%- set run_date = "CURRENT_DATE" -%}

    {# Snapshot logic prepared based on the source and target data #}
    
    {% set query %}

        update {{source}} set run_date={{run_date}};

        delete from  {{ target }} where  ({{key_col}})  in  (select {{key_col}} from {{source}}); 
 
    {% endset %}

    {% do run_query(query) %} 
    
    select * from  {{source}} union all  select * from {{ target }}                         
    
{% endmacro %}
