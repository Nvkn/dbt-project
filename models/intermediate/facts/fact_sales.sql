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
        -- Orderdatekey
        -- Orderdatekey_customer
        -- Orderdatekey_store
        O_ORDERPRIORITY,
        TO_NUMBER(REGEXP_SUBSTR(O_CLERK, '\\d+')) AS O_CLERK,
        L_PARTKEY AS O_ITEMKEY,
        L_SUPPKEY AS O_SUPPKEY,
        L_QUANTITY,
        L_EXTENDEDPRICE,
        L_DISCOUNT,
        L_TAX,
        -- Operationtype
        L_LINESTATUS,
        -- Deliverycompliance
        -- Eventkey
        O_STOREKEY,
        L_SHIPMODE
    FROM {{ ref('stg_orders') }}
    JOIN {{ ref('stg_lineitem') }} ON O_ORDERKEY = L_ORDERKEY
    JOIN {{ ref('stg_customer') }} ON O_CUSTKEY = C_CUSTKEY
    JOIN {{ ref('stg_nation') }} N_C ON C_NATIONKEY = N_C.N_NATIONKEY
    JOIN {{ ref('stg_store') }} ON O_STOREKEY = ST_STOREKEY
    JOIN {{ ref('stg_nation') }} N_ST ON ST_NATIONKEY = N_ST.N_NATIONKEY
)

SELECT *
FROM source_data