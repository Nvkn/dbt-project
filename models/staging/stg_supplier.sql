-- models/staging/stg_supplier.sql

{{ config(
    materialized='incremental',
    unique_key='S_SUPPKEY'
) }}

SELECT
  S_SUPPKEY,
  S_NAME,
  S_ADDRESS,
  S_NATIONKEY,
  S_PHONE,
  S_ACCTBAL,
FROM {{ source('db_source', 'supplier') }}