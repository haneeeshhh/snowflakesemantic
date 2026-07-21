{% snapshot advisors_snapshot %}
{{
    config(
        unique_key = 'ADVISOR_ID',
        strategy='timestamp',
        updated_at='record_updated_ts'
    )
}}
SELECT * FROM {{ ref('stg_advisors') }}
{% endsnapshot %}