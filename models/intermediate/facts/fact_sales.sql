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
        TO_CHAR(O_ORDERDATE, 'YYYYMMDDHH24MISS')::INT AS S_ORDERDATEKEY,
        TO_CHAR(CONVERT_TIMEZONE('UTC', N_C.N_TIMEZONE, O_ORDERDATE), 'YYYYMMDDHH24MISS')::INT AS S_Orderdatekey_CUSTOMER,
        -- Orderdatekey_customer
        -- Orderdatekey_store
        -- O_ORDERPRIORITY AS S_ORDERPRIORITY,
        TO_NUMBER(REGEXP_SUBSTR(O_CLERK, '\\d+')) AS S_CLERK,
        L_PARTKEY AS S_ITEMKEY,
        L_SUPPKEY AS S_SUPPKEY,
        L_QUANTITY AS S_QUANTITY,
        L_EXTENDEDPRICE AS S_EXTENDEDPRICE,
        L_DISCOUNT AS S_DISCOUNT,
        L_TAX AS S_TAX,
        -- Operationtype
        L_LINESTATUS AS S_LINESTATUS,
        CASE L_RETURNFLAG
            WHEN 'N' THEN 'SALE'
            WHEN 'R' THEN 'RETURN'
        END AS S_DELIVERYCOMPLIANCE,
        -- Eventkey
        O_STOREKEY AS S_STOREKEY,
        L_SHIPMODE AS S_SHIPMODE
    FROM {{ ref('stg_orders') }}
    JOIN {{ ref('stg_lineitem') }} ON O_ORDERKEY = L_ORDERKEY
    JOIN {{ ref('stg_customer') }} ON O_CUSTKEY = C_CUSTKEY
    JOIN {{ ref('stg_nation') }} N_C ON C_NATIONKEY = N_C.N_NATIONKEY
    JOIN {{ ref('stg_store') }} ON O_STOREKEY = ST_STOREKEY
    JOIN {{ ref('stg_nation') }} N_ST ON ST_NATIONKEY = N_ST.N_NATIONKEY
    WHERE L_RETURNFLAG IN ('N', 'R')
)

SELECT *
FROM source_data