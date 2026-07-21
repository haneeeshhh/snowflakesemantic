{% snapshot securities_snapshot %}
{{
    config(
        unique_key = 'SECURITY_ID',
        strategy = 'timestamp',
        updated_at = 'record_updated_ts'
    )
}}
SELECT * FROM {{ ref('stg_securities') }}
{% endsnapshot %}