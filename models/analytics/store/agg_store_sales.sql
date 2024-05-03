{{ config(
    materialized='incremental',
    unique_key='store_key'
) }}

WITH store_sales AS (
    SELECT
        ST_NAME AS STORE_NAME,
        SUM(S_TOTALPRICE_STORE) AS TOTAL_SALES_LOCAL,
        COUNT(DISTINCT S_ORDERKEY) AS transactions_count,
        AVG(f.S_TOTALPRICE_STORE) AS average_sale_amount_local,
        MAX(f.S_TOTALPRICE_STORE) AS max_sale_amount_local
    FROM {{ ref('fact_sales') }} f
    JOIN {{ ref('dim_store') }} d ON f.S_STOREKEY = d.ST_STOREKEY
    GROUP BY ST_NAME
), store_sales AS (
    SELECT
        f.S_STOREKEY AS store_key,
        SUM(f.S_TOTALPRICE_STORE) AS total_sales_local,
        COUNT(DISTINCT f.S_ORDERKEY) AS transactions_count,
        AVG(f.S_TOTALPRICE_STORE) AS average_sale_amount_local,
        MAX(f.S_TOTALPRICE_STORE) AS max_sale_amount_local
    FROM {{ ref('fact_sales') }} f
    JOIN {{ ref('dim_store') }} d ON f.S_STOREKEY = d.ST_STOREKEY
    GROUP BY store_key
)

SELECT
    store_key,
    total_sales_local,
    transactions_count,
    average_sale_amount_local,
    max_sale_amount_local,
FROM store_sales
