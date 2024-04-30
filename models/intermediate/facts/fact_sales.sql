-- models/fact_sales.sql

{{ config(
    materialized='incremental',
    unique_key= ['S_ORDERKEY', 'S_LINENUMBER']
) }}

WITH source_data AS (
    SELECT
        O_ORDERKEY AS S_ORDERKEY,
        L_LINENUMBER AS S_LINENUMBER,
        O_CUSTKEY AS S_CUSTKEY,
        O_ORDERSTATUS AS S_ORDERSTATUS,
        O_TOTALPRICE AS S_TOTALPRICE_USD,
        O_TOTALPRICE*N_USD_TO_LOCAL AS S_TOTALPRICE_CUSTOMER
    FROM {{ ref('stg_orders') }}
    JOIN {{ ref('stg_lineitem') }} ON O_ORDERKEY = L_ORDERKEY
    JOIN {{ ref('stg_customer') }} ON O_CUSTKEY = C_CUSTKEY
    JOIN {{ ref('stg_nation') }} ON C_NATIONKEY = N_NATIONKEY
)

SELECT *
FROM source_data