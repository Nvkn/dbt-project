-- models/staging/stg_region.sql

{{ config(
    materialized='incremental',
    unique_key='R_REGIONKEY'
) }}

SELECT
  R_REGIONKEY,
  R_NAME
FROM {{ source('db_source', 'region') }}