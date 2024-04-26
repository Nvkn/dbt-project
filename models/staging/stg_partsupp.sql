-- models/staging/stg_partsupp.sql

{{ config(
    materialized='incremental',
    unique_key= ['PS_PARTKEY', 'PS_SUPPKEY']
) }}

SELECT
  PS_PARTKEY,
  PS_SUPPKEY,
  PS_AVAILQTY,
  PS_SUPPLYCOST,
  PS_COMMENT
FROM {{ source('db_source', 'partsupp') }}