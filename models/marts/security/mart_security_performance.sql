{{ config(materialized='table')}}

WITH SECURITY_TRANSACTIONS AS(
SELECT
    S.SECURITY_ID,
    S.TICKER,
    S.SECURITY_NAME,
    S.ASSET_CLASS,
    S.SECTOR,
    S.CURRENCY,
    S.EXCHANGE,

    T.TRANSACTION_ID,
    T.TRANSACTION_TYPE,
    T.ACCOUNT_ID,
    T.QUANTITY,
    T.TRADE_VALUE,
    T.TRANSACTION_DATE,
    T.BROKERAGE_FEE,
    T.TAX_AMOUNT
FROM {{ ref('dim_securities') }} S
LEFT JOIN {{ ref('fact_transactions') }} T
    ON S.SECURITY_ID = T.SECURITY_ID
),
CUSTOMER_SECURITIES AS(
    SELECT
        A.CUSTOMER_ID,
        ST.SECURITY_ID,
        ST.TICKER,
        ST.SECURITY_NAME,
        ST.ASSET_CLASS,
        ST.SECTOR,
        ST.CURRENCY,
        ST.EXCHANGE,

        ST.TRANSACTION_ID,
        ST.TRANSACTION_TYPE,
        ST.ACCOUNT_ID,
        ST.QUANTITY,
        ST.TRADE_VALUE,
        ST.BROKERAGE_FEE,
        ST.TRANSACTION_DATE,
        ST.TAX_AMOUNT
    FROM SECURITY_TRANSACTIONS AS ST
    LEFT JOIN {{ ref('dim_accounts') }} A
        ON ST.ACCOUNT_ID = A.ACCOUNT_ID
)
SELECT 
    SECURITY_ID,
    TICKER,
    SECURITY_NAME,
    ASSET_CLASS,
    SECTOR,
    CURRENCY,
    EXCHANGE,
    COUNT(DISTINCT CUSTOMER_ID) AS NUMBER_OF_INVESTORS,
    COUNT(DISTINCT TRANSACTION_ID) AS TOTAL_TRANSACTIONS,
    coalesce(SUM(
        CASE
            WHEN UPPER(TRANSACTION_TYPE) = 'BUY'
            THEN 1
            ELSE 0
        END),0
    ) AS BUY_TRANSACTION,
    coalesce(SUM(
        CASE
            WHEN UPPER(TRANSACTION_TYPE) = 'SELL'
            THEN 1
            ELSE 0
        END),0
    ) AS SELL_TRANSACTION,

    coalesce(SUM(QUANTITY), 0) AS TOTAL_QUANTITY,
    coalesce(SUM(
        CASE
            WHEN UPPER(TRANSACTION_TYPE) = 'BUY'
            THEN TRADE_VALUE
            ELSE 0
        END),0
    ) AS TOTAL_BUY_VALUE,
        
    coalesce(SUM(
        CASE
            WHEN UPPER(TRANSACTION_TYPE) = 'SELL'
            THEN TRADE_VALUE
            ELSE 0
        END),0
    ) AS TOTAL_SELL_VALUE,

    coalesce(SUM(BROKERAGE_FEE), 0) AS TOTAL_BROKERAGE,
    COALESCE(SUM(TAX_AMOUNT), 0) AS TOTAL_TAX,
    COALESCE(AVG(TRADE_VALUE), 0) AS AVG_TRADE_VALUE,
    MAX(TRANSACTION_DATE) AS last_transaction
FROM CUSTOMER_SECURITIES
GROUP BY
    SECURITY_ID,
    TICKER,
    SECURITY_NAME,
    ASSET_CLASS,
    SECTOR,
    CURRENCY,
    EXCHANGE