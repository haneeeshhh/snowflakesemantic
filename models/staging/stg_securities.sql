{{ config(
    materialized='view',
    schema = 'STAGING')}}
WITH RANKED AS (
    SELECT
        SECURITY_ID,
        TICKER,
        SECURITY_NAME,
        ASSET_CLASS,
        SECTOR,
        CURRENCY,
        EXCHANGE,
        STATUS,
        SOURCE_SYSTEM,
        BATCH_ID,
        CAST(LOAD_DATE AS DATE) AS LOAD_DATE,
        RECORD_CREATED_TS,
        RECORD_UPDATED_TS,
        ROW_NUMBER() OVER(
                PARTITION BY SECURITY_ID
                ORDER BY RECORD_UPDATED_TS DESC
            ) AS RN
    FROM {{ source('raw', 'RAW_SECURITIES')}}
)
SELECT 
    SECURITY_ID,
    TICKER,
    SECURITY_NAME,
    ASSET_CLASS,
    SECTOR,
    CURRENCY,
    EXCHANGE,
    STATUS,
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS,
    RN
FROM RANKED
WHERE RN = 1