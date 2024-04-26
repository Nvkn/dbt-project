-- models/staging/stg_orders.sql

{{ config(
    materialized='incremental',
    unique_key='O_ORDERKEY',
    
) }}

WITH new_orders AS (
    SELECT
        O_ORDERKEY,
        O_CUSTKEY,
        O_ORDERSTATUS,
        O_TOTALPRICE,
        O_ORDERDATE,
        O_ORDERPRIORITY,
        O_CLERK
    FROM {{ source('tpch_sf1', 'orders') }}
    {% if is_incremental() %}
    WHERE O_ORDERKEY > (SELECT COALESCE(MAX(O_ORDERKEY), 0) FROM {{ this }})
    {% endif %}
)

SELECT *
FROM new_orders
ORDER BY O_ORDERKEY
LIMIT 10