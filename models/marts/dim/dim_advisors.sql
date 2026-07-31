{{ config(
    materialized='table',
    post_hook="{{ audit_log('dim_advisors') }}"
    
    )}}

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
FROM {{ ref('advisors_history') }}
WHERE IS_CURRENT = 'Y'