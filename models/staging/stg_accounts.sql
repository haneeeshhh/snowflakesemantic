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
        RECORD_UPDATED_TS,
        ROW_NUMBER() OVER(
                PARTITION BY ACCOUNT_ID
                ORDER BY RECORD_UPDATED_TS DESC
            ) AS RN
    FROM {{ source('raw', 'RAW_ACCOUNTS')}}
)
SELECT *
FROM RANKED
WHERE RN = 1