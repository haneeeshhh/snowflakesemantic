{{
    config(materialized='table')
}}
WITH CUSTOMER_ACCOUNTS AS(
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
CUSTOMER_TRANSACTIONS AS (
    SELECT
        CA.CUSTOMER_ID,
        CA.FIRST_NAME,
        CA.LAST_NAME,
        CA.ADVISOR_ID,
        CA.RISK_PROFILE,
        CA.ANNUAL_INCOME,
        CA.ACCOUNT_ID,
        
        F.TRANSACTION_ID,
        F.TRANSACTION_DATE,
        F.TRANSACTION_TYPE,
        F.TRADE_VALUE,
        F.BROKERAGE_FEE,
        F.TAX_AMOUNT

    FROM CUSTOMER_ACCOUNTS CA

    LEFT JOIN {{ ref('fact_transactions') }} F
        ON CA.ACCOUNT_ID = F.ACCOUNT_ID
)
SELECT 
    CUSTOMER_ID,
    FIRST_NAME || ' ' || last_name AS CUSTOMER_NAME,
    ADVISOR_ID,
    RISK_PROFILE,
    ANNUAL_INCOME,
    COUNT(DISTINCT ACCOUNT_ID) AS TOTAL_ACCOUNTS,

    COUNT(TRANSACTION_ID) AS TOTAL_TRANSACTIONS,

    {{ sum_transaction_type('BUY', 'TRADE_VALUE') }} AS MACRO_BUY_VALUE,

    {{ sum_transaction_type('SELL', 'TRADE_VALUE') }} AS MACRO_SELL_VALUE,

    coalesce(
        SUM(
            CASE
                WHEN UPPER(TRANSACTION_TYPE) = 'BUY'
                THEN TRADE_VALUE
                WHEN UPPER(TRANSACTION_TYPE) = 'SELL'
                THEN -TRADE_VALUE
                ELSE 0
            END
        ), 0
    )AS NET_INVESTMENT,

    coalesce(SUM(BROKERAGE_FEE),0) AS TOTAL_BROKERAGE,

    coalesce(SUM(TAX_AMOUNT),0) AS TOTAL_TAX,

    MAX(TRANSACTION_DATE) AS LAST_TRANSACTION_DATE
FROM CUSTOMER_TRANSACTIONS
GROUP BY
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    ADVISOR_ID,
    RISK_PROFILE,
    ANNUAL_INCOME
