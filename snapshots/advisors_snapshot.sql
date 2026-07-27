{% snapshot advisors_snapshot %}
{{
    config(
        unique_key = 'ADVISOR_ID',
        strategy='check',
        check_cols=[
            'ADVISOR_NAME',
            'BRANCH',
            'EMAIL',
            'PHONE',
            'STATUS'
        ]
    )
}}
SELECT
    ADVISOR_ID,
    ADVISOR_NAME,
    BRANCH,
    EMAIL,
    PHONE,
    HIRE_DATE,
    STATUS,
    SOURCE_SYSTEM,
    BATCH_ID,
    LOAD_DATE,
    RECORD_CREATED_TS,
    RECORD_UPDATED_TS
FROM {{ ref('stg_advisors') }}
{% endsnapshot %}