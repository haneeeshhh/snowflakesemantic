{{
    config(materialized='table')
}}
SELECT
    customer_id,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DOB,
    EMAIL,
    PHONE,
    CITY,
    STATE,
    ADVISOR_ID,
    RISK_PROFILE,
    ANNUAL_INCOME,
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS,
    STATUS,
    DBT_VALID_FROM as VALID_FROM,
    DBT_VALID_TO AS VAILD_TO,
    CASE
        WHEN DBT_VALID_TO IS NULL
        THEN 'Y'
        ELSE 'N'
    END AS IS_CURRENT
FROM {{ ref('customer_snapshot') }}