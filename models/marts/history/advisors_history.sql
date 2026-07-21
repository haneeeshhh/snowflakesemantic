{{ config(materialized='table')}}

SELECT
    ADVISOR_ID,
    ADVISOR_NAME,
    BRANCH,
    EMAIL,
    PHONE,
    HIRE_DATE,
    STATUS,
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS,
    DBT_VALID_FROM as VALID_FROM,
    DBT_VALID_TO AS VAILD_TO,
    CASE
        WHEN DBT_VALID_TO IS NULL
        THEN 'Y'
        ELSE 'N'
    END AS IS_CURRENT
FROM {{ ref('advisors_snapshot') }}