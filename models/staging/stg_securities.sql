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
        RECORD_UPDATED_TS
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
    RECORD_UPDATED_TS
FROM RANKED