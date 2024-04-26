-- models/staging/stg_partsupp.sql

{{ config(
    materialized='incremental',
    unique_key= ['PS_PARTKEY', 'PS_SUPPKEY']
) }}

SELECT
  P_PARTKEY,
  P_NAME,
  P_MFGR,
  P_BRAND,
  P_TYPE,
  P_SIZE,
  P_CONTAINER,
  P_RETAILPRICE
FROM {{ source('db_source', 'partsupp') }}