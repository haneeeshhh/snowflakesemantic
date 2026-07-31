{% macro inremental_filter(column_name) %}

{% if is_incremental() %}
WHERE {{ column_name }} > 
(
    SELECT coalesce(MAX({{ column_name }}), '1900-01-01')
    FROM {{ this }}
)
{% endif %}

{% endmacro %}