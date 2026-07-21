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
    RECORD_UPDATED_TS,
    DBT_VALID_FROM as VALID_FROM,
    DBT_VALID_TO AS VAILD_TO,
    CASE
        WHEN DBT_VALID_TO IS NULL
        THEN 'Y'
        ELSE 'N'
    END AS IS_CURRENT
FROM {{ ref('securities_snapshot') }}