{{ config(materialized='table')}}

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
FROM {{ ref('securities_history') }}
WHERE IS_CURRENT = 'Y'