-- models/staging/stg_customer.sql

{{ config(
    materialized='incremental',
    unique_key='C_CUSTKEY'
) }}

SELECT
  C_CUSTKEY,
  C_NAME,
  C_NATIONKEY,
  CAST (C_ACCTBAL AS REAL) C_ACCTBAL,
  C_MKTSEGMENT
FROM {{ source('db_source', 'customer') }}