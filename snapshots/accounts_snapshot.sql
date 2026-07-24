{% snapshot accounts_snapshot %}
{{
    config(
        unique_key = 'ACCOUNT_ID',
        strategy='timestamp',
        updated_at='record_updated_ts'
    )
}}
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
FROM {{ ref('stg_accounts') }}
{% endsnapshot %}