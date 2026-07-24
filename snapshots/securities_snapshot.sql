{% snapshot securities_snapshot %}
{{
    config(
        unique_key = 'SECURITY_ID',
        strategy = 'timestamp',
        updated_at = 'record_updated_ts'
    )
}}
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
FROM {{ ref('stg_securities') }}
{% endsnapshot %}