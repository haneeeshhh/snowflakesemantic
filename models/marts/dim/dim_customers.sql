{{ config(materialized='table')}}

SELECT
    CUSTOMER_ID,
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
    STATUS,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS
FROM {{ ref('customer_history') }}
WHERE IS_CURRENT = 'Y'