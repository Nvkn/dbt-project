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
        O_TOTALPRICE*N_C.N_USD_TO_LOCAL AS S_TOTALPRICE_CUSTOMER,
        O_TOTALPRICE*N_ST.N_USD_TO_LOCAL AS S_TOTALPRICE_STORE,
        O_ITEMKEY AS L_PARTKEY,
        O_SUPPKEY AS L_SUPPKEY,
        O_STOREKEY
    FROM {{ ref('stg_orders') }}
    JOIN {{ ref('stg_lineitem') }} ON O_ORDERKEY = L_ORDERKEY
    JOIN {{ ref('stg_customer') }} ON O_CUSTKEY = C_CUSTKEY
    JOIN {{ ref('stg_nation') }} N_C ON C_NATIONKEY = N_C.N_NATIONKEY
    JOIN {{ ref('stg_store') }} ON O_STOREKEY = ST_STOREKEY
    JOIN {{ ref('stg_nation') }} N_ST ON ST_NATIONKEY = N_ST.N_NATIONKEY
)

SELECT *
FROM source_data