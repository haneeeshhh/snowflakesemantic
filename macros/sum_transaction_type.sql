{% macro sum_transaction_type(transaction_type, column_name) %}

coalesce(
    SUM(
        CASE
            WHEN UPPER(TRANSACTION_TYPE) = UPPER('{{ transaction_type }}')
            THEN {{ column_name }}
            ELSE 0
        END
    ),
0)
{% endmacro %}