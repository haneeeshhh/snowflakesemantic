{% test positive_brokerage(model) %}

SELECT *
FROM {{ model }}
WHERE BROKERAGE_FEE < 0

{% endtest %}