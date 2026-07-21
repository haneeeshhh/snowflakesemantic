{% snapshot customer_snapshot %}
{{
    config(
        unique_key = 'customer_id',
        strategy='timestamp',
        updated_at='record_updated_ts'
    )
}}
SELECT
    * 
FROM {{ ref('stg_customers') }}

{% endsnapshot %}