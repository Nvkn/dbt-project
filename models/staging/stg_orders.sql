-- models/staging/stg_orders.sql

{{ config(
    materialized='incremental',
    unique_key='O_ORDERKEY'
) }}

SELECT
    O_ORDERKEY,
    O_CUSTKEY,
    O_ORDERSTATUS,
    O_TOTALPRICE,
    O_ORDERDATE,
    O_ORDERPRIORITY,
    O_CLERK,
    FLOOR(UNIFORM(1,75,random())) AS O_STOREKEY
FROM {{ source('db_source', 'orders') }}
