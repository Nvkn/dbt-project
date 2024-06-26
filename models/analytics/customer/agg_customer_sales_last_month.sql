{{ config(
    materialized='dynamic_table',
    unique_key= ['C_CUSTKEY'],
    pre_hook = "use schema dbt_project.dbt_analytics",
    post_hook = "drop table if exists DBT_PROJECT.DBT_ANALYTICS.AGG_STORE_SALES_BY_MONTH__dbt_backup cascade"
) }}

WITH CUSTOMER_ORDER_SALES AS (
    SELECT 
        C_CUSTKEY, 
        MAX(C_NAME) AS C_NAME,
        S_ORDERKEY,
        MAX(S_TOTALPRICE_STORE) AS TOTALPRICE_ORDER,
        COUNT(S_ITEMKEY) AS DISTINCT_ITEMS_IN_ORDER,
        SUM(S_QUANTITY) AS AMOUNT_ITEMS_IN_ORDER,
        AVG(S_DISCOUNT) AS AVERAGE_DISCOUNT,
        COUNT_IF(S_OPERATIONTYPE LIKE 'SALE') AS NUM_SALES,
        COUNT_IF(S_OPERATIONTYPE LIKE 'RETURN') AS NUM_RETURN,
        COUNT_IF(S_EVENTKEY IS NOT NULL) AS IN_EVENT
    FROM {{ ref('fact_sales') }}
    JOIN {{ ref('dim_customer') }} ON S_CUSTKEY = C_CUSTKEY
    JOIN {{ ref('dim_time') }} ON T_TIMEKEY = S_ORDERDATEKEY
    WHERE T_Date <= DATEADD(year, -30, CURRENT_DATE())
    AND T_Date >= DATEADD(day, -30, DATEADD(year, -30, CURRENT_DATE()))
    GROUP BY C_CUSTKEY, S_ORDERKEY
), CUSTOMER_SALES AS (
    SELECT
        C_CUSTKEY,
        MAX(C_NAME) AS C_NAME,
        ROUND(SUM(TOTALPRICE_ORDER), 2) AS TOTAL_PRICE_ORDERS,
        ROUND(AVG(TOTALPRICE_ORDER), 2) AS AVG_PRICE_ORDER,
        ROUND(AVG(DISTINCT_ITEMS_IN_ORDER), 2) AS AVG_DISTINCT_ITEMS_IN_ORDER,
        SUM(IN_EVENT) AS DISTINCT_ITEMS_IN_ORDER_DURING_EVENT,
        ROUND(AVG(AMOUNT_ITEMS_IN_ORDER), 2) AS AVG_AMOUNT_ITEMS_IN_ORDER,
        SUM(AMOUNT_ITEMS_IN_ORDER) AS TOTAL_AMOUNT_ITEMS_SOLD,
        ROUND(AVG(AVERAGE_DISCOUNT), 2) AS AVERAGE_DISCOUNT,
        SUM(NUM_SALES) AS NUM_SALES,
        SUM(NUM_RETURN) AS NUM_RETURN
    FROM CUSTOMER_ORDER_SALES
    GROUP BY C_CUSTKEY
)

SELECT *
FROM CUSTOMER_SALES
