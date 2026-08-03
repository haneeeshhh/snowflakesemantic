{{ config(
    materialized='view',
    schema = 'STAGING')}}
WITH RANKED AS(
    SELECT
        CUSTOMER_ID,
        TRIM(FIRST_NAME) AS FIRST_NAME,
        TRIM(LAST_NAME) AS LAST_NAME,
        GENDER,
        CAST(DOB AS DATE) DOB,
        LOWER(EMAIL) AS EMAIL,
        TRIM(PHONE) AS PHONE,
        TRIM(CITY) AS CITY,
        TRIM(STATE) AS STATE,
        ADVISOR_ID,
        RISK_PROFILE,
        ANNUAL_INCOME,
        STATUS,
        SOURCE_SYSTEM,
        BATCH_ID,
        CAST(LOAD_DATE AS DATE) AS LOAD_DATE,
        RECORD_CREATED_TS,
        RECORD_UPDATED_TS
    FROM {{ source('raw', 'RAW_CUSTOMERS')}}
)
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
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS
FROM RANKED