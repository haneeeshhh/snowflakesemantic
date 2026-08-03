{{ config(
    materialized='view',
    schema = 'STAGING')}}
WITH RANKED AS(
    SELECT
        ACCOUNT_ID,
        CUSTOMER_ID,
        ACCOUNT_TYPE,
        CAST(OPEND_DATE AS DATE) AS OPEND_DATE,
        BRANCH,
        CURRENCY,
        STATUS,
        SOURCE_SYSTEM,
        BATCH_ID,
        CAST(LOAD_DATE AS DATE) AS LOAD_DATE,
        RECORD_CREATED_TS,
        RECORD_UPDATED_TS
    FROM {{ source('raw', 'RAW_ACCOUNTS')}}
)
SELECT 
    ACCOUNT_ID,
    CUSTOMER_ID,
    ACCOUNT_TYPE,
    OPEND_DATE,
    BRANCH,
    CURRENCY,
    STATUS,
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS
FROM RANKED
