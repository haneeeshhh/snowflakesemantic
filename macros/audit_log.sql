{% macro audit_log(model_name) %}

INSERT INTO FINANCIAL_DWH.RAW.ELT_AUDIT_LOG(
    MODEL_NAME,
    SCHEMA_NAME,
    ROW_COUNT,
    LOAD_STATUS,
    LOAD_TIMESTAMP,
    EXECUTED_BY
)
SELECT
    '{{ model_name }}',
    '{{ this.schema }}',
    count(*),
    'SUCCESS',
    CURRENT_TIMESTAMP(),
    CURRENT_USER()
FROM {{ this }}

{% endmacro %}