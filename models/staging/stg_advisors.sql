{{ config(
    materialized='view',
    schema = 'STAGING')}}
WITH RANKED AS(
    SELECT
        ADVISOR_ID,
        TRIM(ADVISOR_NAME) AS ADVISOR_NAME,
        TRIM(BRANCH) AS BRANCH,
        LOWER(EMAIL) AS EMAIL,
        PHONE,
        CAST(HIRE_DATE AS DATE) AS HIRE_DATE,
        STATUS,
        SOURCE_SYSTEM,
        BATCH_ID,
        CAST(LOAD_DATE AS DATE) AS LOAD_DATE,
        RECORD_CREATED_TS,
        RECORD_UPDATED_TS,
        ROW_NUMBER() OVER(
                    PARTITION BY ADVISOR_ID
                    ORDER BY RECORD_UPDATED_TS DESC
                ) AS RN
    FROM {{ source('raw', 'RAW_ADVISORS')}}
)
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
    RECORD_UPDATED_TS,
    RN
FROM RANKED
WHERE RN = 1