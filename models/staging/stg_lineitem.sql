-- models/staging/stg_lineitem.sql

{{ config(
    materialized='incremental',
    unique_key=['L_ORDERKEY'
) }}

SELECT
  N_NATIONKEY,
  N_NAME,
  N_REGIONKEY
FROM {{ source('db_source', 'nation') }}