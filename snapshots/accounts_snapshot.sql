{% snapshot accounts_snapshot %}
{{
    config(
        unique_key = 'ACCOUNT_ID',
        strategy='timestamp',
        updated_at='record_updated_ts'
    )
}}
SELECT * FROM {{ ref('stg_accounts') }}
{% endsnapshot %}