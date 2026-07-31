{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        post_hook="{{ audit_log('fact_transactions') }}"
    )
}}
SELECT
    TRANSACTION_ID,
    TRANSACTION_DATE,
    ACCOUNT_ID,
    SECURITY_ID,
    ADVISOR_ID,
    TRANSACTION_TYPE,
    QUANTITY,
    PRICE,
    TRADE_VALUE,
    BROKERAGE_FEE,
    TAX_AMOUNT,
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS
FROM {{ ref('stg_transactions') }}

{{ inremental_filter('record_updated_ts') }}