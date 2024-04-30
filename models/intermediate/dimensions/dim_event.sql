-- models/dim_event.sql

{{ config(
    materialized='incremental',
    unique_key='E_EVENTKEY'
) }}

WITH source_data AS (
    SELECT
        E_EVENTKEY,
        E_NAME,
        E_NATION_NAME,
        E_START_DATE,
        E_END_DATE
    FROM {{ ref('stg_event') }}
)

SELECT *
FROM source_data