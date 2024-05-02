-- models/dim_store.sql

{{ config(
    materialized='incremental',
    unique_key='ST_STOREKEY'
) }}

WITH source_data AS (
    SELECT
        ST_STOREKEY,
        ST_NAME,
        N_NAME AS ST_NATION_NAME,
        R_NAME AS ST_REGION_NAME
    FROM {{ ref('stg_store') }}
    JOIN {{ ref('stg_nation') }} ON ST_NATIONKEY = N_NATIONKEY
    JOIN {{ ref('stg_region') }} ON N_REGIONKEY = R_REGIONKEY
)

SELECT *
FROM source_data