-- models/staging/stg_event.sql

{{ config(
    materialized='incremental',
    unique_key='e_eventkey'
) }}

WITH source_data AS (
    SELECT
        e_eventkey,
        e_name,
        e_start_date,
        e_end_date,
        e_nationkey
    FROM {{ ref('src_event') }}
)

SELECT
    e_eventkey,
    e_name,
    e_start_date,
    e_end_date,
    e_nationkey
FROM source_data
