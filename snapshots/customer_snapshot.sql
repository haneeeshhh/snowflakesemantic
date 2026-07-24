{% snapshot customer_snapshot %}
{{
    config(
        unique_key = 'customer_id',
        strategy='timestamp',
        updated_at='record_updated_ts'
    )
}}
SELECT
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DOB,
    EMAIL,
    PHONE,
    CITY,
    STATE,
    ADVISOR_ID,
    RISK_PROFILE,
    ANNUAL_INCOME,
    STATUS,
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS
FROM {{ ref('stg_customers') }}

{% endsnapshot %}