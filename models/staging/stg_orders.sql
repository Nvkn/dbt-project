-- models/staging/stg_orders.sql

{{ config(
    materialized='incremental',
<<<<<<< HEAD
    unique_key='O_ORDERKEY',
    
=======
    unique_key='O_ORDERKEY'
>>>>>>> 75a8ff44a388bc04dd3bd15a2c1a3d64a83b7ea9
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
