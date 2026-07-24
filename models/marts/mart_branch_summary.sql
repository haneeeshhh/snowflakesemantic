{{ config(
    materialized='table'
) }}

WITH BRANCH_CUSTOMERS AS (

    SELECT

        A.BRANCH,
        A.ADVISOR_ID,
        A.ADVISOR_NAME,

        C.CUSTOMER_ID,

        ACC.ACCOUNT_ID

    FROM {{ ref('dim_advisors') }} A

    LEFT JOIN {{ ref('dim_customers') }} C
        ON A.ADVISOR_ID = C.ADVISOR_ID

    LEFT JOIN {{ ref('dim_accounts') }} ACC
        ON C.CUSTOMER_ID = ACC.CUSTOMER_ID

),

BRANCH_TRANSACTIONS AS (

    SELECT

        BC.BRANCH,
        BC.ADVISOR_ID,
        BC.ADVISOR_NAME,
        BC.CUSTOMER_ID,
        BC.ACCOUNT_ID,

        T.TRANSACTION_ID,
        T.TRANSACTION_DATE,
        T.TRANSACTION_TYPE,
        T.TRADE_VALUE,
        T.BROKERAGE_FEE,
        T.TAX_AMOUNT

    FROM BRANCH_CUSTOMERS BC

    LEFT JOIN {{ ref('fact_transactions') }} T
        ON BC.ACCOUNT_ID = T.ACCOUNT_ID

)

SELECT

    BRANCH,

    COUNT(DISTINCT ADVISOR_ID) AS TOTAL_ADVISORS,

    COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS,

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
                WHEN UPPER(TRANSACTION_TYPE) = 'BUY'
                THEN TRADE_VALUE
                ELSE 0
            END
        ),0
    ) AS TOTAL_BUY_VALUE,

    COALESCE(
        SUM(
            CASE
                WHEN UPPER(TRANSACTION_TYPE) = 'SELL'
                THEN TRADE_VALUE
                ELSE 0
            END
        ),0
    ) AS TOTAL_SELL_VALUE,

    COALESCE(SUM(TRADE_VALUE),0) AS TOTAL_TRADE_VALUE,

    COALESCE(SUM(BROKERAGE_FEE),0) AS TOTAL_BROKERAGE,

    COALESCE(SUM(TAX_AMOUNT),0) AS TOTAL_TAX,

    COALESCE(AVG(TRADE_VALUE),0) AS AVG_TRADE_VALUE,

    MAX(TRADE_VALUE) AS LARGEST_TRADE,

    MIN(TRADE_VALUE) AS SMALLEST_TRADE,

    MAX(TRANSACTION_DATE) AS LAST_TRANSACTION_DATE

FROM BRANCH_TRANSACTIONS

GROUP BY

    BRANCH

ORDER BY

    TOTAL_TRADE_VALUE DESC