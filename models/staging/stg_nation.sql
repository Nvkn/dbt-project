-- models/staging/stg_nation.sql

{{ config(
    materialized='incremental',
    unique_key='N_NATIONKEY'
) }}

SELECT
  N_NATIONKEY,
  N_NAME,
  N_REGIONKEY
FROM {{ source('db_source', 'nation') }}