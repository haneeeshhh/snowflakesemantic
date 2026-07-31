{% test trade_value_check(model) %}
SELECT *
FROM {{ model }}
WHERE TRADE_VALUE != (QUANTITY * PRICE)

{% endtest %}