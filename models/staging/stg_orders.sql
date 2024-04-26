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
    O_CLERK
FROM {{ source('db_source', 'orders') }}
