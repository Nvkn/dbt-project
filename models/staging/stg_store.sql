-- models/staging/stg_store.sql

{{ config(
    materialized='incremental',
    unique_key='st_storekey'
) }}

WITH source_data AS (
    SELECT
        st_storekey,
        st_name,
        st_nationkey
    FROM {{ ref('src_store') }}
)

SELECT
    st_storekey,
    st_name,
    st_nationkey
FROM source_data
