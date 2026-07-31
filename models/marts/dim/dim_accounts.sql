{{ config(
    materialized='table',
    post_hook="{{ audit_log('dim_accounts') }}"
    
    )}}

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
FROM {{ ref('account_history') }}
WHERE IS_CURRENT = 'Y'