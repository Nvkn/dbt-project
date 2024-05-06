-- models/staging/stg_partsupp.sql

{{ config(
    materialized='incremental',
    unique_key= ['PS_PARTKEY', 'PS_SUPPKEY']
) }}

SELECT
  PS_PARTKEY,
  PS_SUPPKEY,
  PS_AVAILQTY,
  CAST (PS_SUPPLYCOST AS REAL) AS PS_SUPPLYCOST
FROM {{ source('db_source', 'partsupp') }}