-- models/staging/stg_customer.sql

{{ config(
    materialized='incremental',
    unique_key='C_CUSTKEY'
) }}

SELECT
  C_CUSTKEY,
  C_NAME,
  C_ADDRESS,
  C_PHONE,
  C_NATIONKEY,
  C_ACCTBAL,
  C_MKTSEGMENT
FROM {{ source('db_source', 'customer') }}