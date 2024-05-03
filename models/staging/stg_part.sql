-- models/staging/stg_part.sql

{{ config(
    materialized='incremental',
    unique_key='P_PARTKEY'
) }}

SELECT
  P_PARTKEY,
  P_NAME,
  P_MFGR,
  P_BRAND,
  P_TYPE,
  P_SIZE,
  P_CONTAINER,
  CAST (P_RETAILPRICE AS REAL) AS P_RETAILPRICE
FROM {{ source('db_source', 'part') }}