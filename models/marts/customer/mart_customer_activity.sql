{{ config(
    materialized='table'
) }}

WITH CUSTOMER_ACCOUNTS AS (

    SELECT

        C.CUSTOMER_ID,
        C.FIRST_NAME,
        C.LAST_NAME,
        C.ADVISOR_ID,
        C.RISK_PROFILE,
        C.ANNUAL_INCOME,

        A.ACCOUNT_ID

    FROM {{ ref('dim_customers') }} C

    LEFT JOIN {{ ref('dim_accounts') }} A
        ON C.CUSTOMER_ID = A.CUSTOMER_ID

),

CUSTOMER_ACTIVITY AS (

    SELECT

        CA.CUSTOMER_ID,
        CA.FIRST_NAME,
        CA.LAST_NAME,
        CA.ADVISOR_ID,
        CA.RISK_PROFILE,
        CA.ANNUAL_INCOME,
        CA.ACCOUNT_ID,

        T.TRANSACTION_ID,
        T.TRANSACTION_DATE,
        T.TRANSACTION_TYPE,
        T.QUANTITY,
        T.TRADE_VALUE,
        T.BROKERAGE_FEE,
        T.TAX_AMOUNT

    FROM CUSTOMER_ACCOUNTS CA

    LEFT JOIN {{ ref('fact_transactions') }} T
        ON CA.ACCOUNT_ID = T.ACCOUNT_ID

)

SELECT

    CUSTOMER_ID,

    FIRST_NAME || ' ' || LAST_NAME AS CUSTOMER_NAME,

    ADVISOR_ID,

    RISK_PROFILE,

    ANNUAL_INCOME,

    COUNT(DISTINCT ACCOUNT_ID) AS TOTAL_ACCOUNTS,

    COUNT(TRANSACTION_ID) AS TOTAL_TRANSACTIONS,

    SUM(
        CASE
            WHEN UPPER(TRANSACTION_TYPE) = 'BUY'
            THEN 1
            ELSE 0
        END
    ) AS BUY_TRANSACTIONS,

    SUM(
        CASE
            WHEN UPPER(TRANSACTION_TYPE) = 'SELL'
            THEN 1
            ELSE 0
        END
    ) AS SELL_TRANSACTIONS,

    COALESCE(
        SUM(
            CASE
                WHEN UPPER(TRANSACTION_TYPE)='BUY'
                THEN TRADE_VALUE
                ELSE 0
            END
        ),0
    ) AS TOTAL_BUY_VALUE,

    COALESCE(
        SUM(
            CASE
                WHEN UPPER(TRANSACTION_TYPE)='SELL'
                THEN TRADE_VALUE
                ELSE 0
            END
        ),0
    ) AS TOTAL_SELL_VALUE,

    COALESCE(SUM(TRADE_VALUE),0) AS TOTAL_TRADE_VALUE,

    COALESCE(SUM(QUANTITY),0) AS TOTAL_QUANTITY_TRADED,

    COALESCE(SUM(BROKERAGE_FEE),0) AS TOTAL_BROKERAGE,

    COALESCE(SUM(TAX_AMOUNT),0) AS TOTAL_TAX,

    COALESCE(AVG(TRADE_VALUE),0) AS AVG_TRADE_VALUE,

    MAX(TRADE_VALUE) AS LARGEST_TRADE,

    MIN(TRADE_VALUE) AS SMALLEST_TRADE,

    MAX(TRANSACTION_DATE) AS LAST_TRANSACTION_DATE,

    DATEDIFF(
        DAY,
        MAX(TRANSACTION_DATE),
        CURRENT_DATE()
    ) AS DAYS_SINCE_LAST_TRANSACTION,

    CASE
        WHEN DATEDIFF(
                DAY,
                MAX(TRANSACTION_DATE),
                CURRENT_DATE()
             ) <= 30
        THEN 'ACTIVE'

        WHEN DATEDIFF(
                DAY,
                MAX(TRANSACTION_DATE),
                CURRENT_DATE()
             ) <= 90
        THEN 'INACTIVE'

        ELSE 'DORMANT'

    END AS CUSTOMER_STATUS

FROM CUSTOMER_ACTIVITY

GROUP BY

    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    ADVISOR_ID,
    RISK_PROFILE,
    ANNUAL_INCOME

ORDER BY

    TOTAL_TRADE_VALUE DESC