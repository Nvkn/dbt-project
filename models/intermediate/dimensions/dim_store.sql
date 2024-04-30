-- models/dim_store.sql

{{ config(
    materialized='incremental',
    unique_key='ST_STOREKEY'
) }}

WITH source_data AS (
    SELECT
        ST_STOREKEY,
        ST_NAME,
        ST_NATION_NAME
    FROM {{ ref('stg_store') }}
)

SELECT *
FROM source_data