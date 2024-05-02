-- models/dim_event.sql

{{ config(
    materialized='incremental',
    unique_key='E_EVENTKEY'
) }}

WITH source_data AS (
    SELECT
        E_EVENTKEY,
        E_NAME,
        N_NAME AS E_NATION_NAME,
        R_NAME AS E_REGION_NAME
        E_START_DATE,
        E_END_DATE
    FROM {{ ref('stg_event') }}
    JOIN {{ ref('stg_nation') }} ON E_NATIONKEY = N_NATIONKEY
    JOIN {{ ref('stg_region') }} ON N_REGIONKEY = R_REGIONKEY
)

SELECT *
FROM source_data