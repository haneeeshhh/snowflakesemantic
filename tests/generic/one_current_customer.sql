{% test one_current_customer(model) %}

SELECT
    CUSTOMER_ID
FROM {{model}}
WHERE IS_CURRENT='Y'
GROUP BY CUSTOMER_ID
HAVING COUNT(*) > 1

{% endtest %}