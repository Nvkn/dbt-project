-- models/dim_customer.sql

{{ config(
    materialized='incremental',
    unique_key='C_CUSTKEY'
) }}

WITH source_data AS (
    SELECT
        C_CUSTKEY,
        C_NAME,
        N_NAME AS C_NATION_NAME,
        R_NAME AS C_REGION_NAME,
        C_ACCTBAL,
        C_MKTSEGMENT
    FROM {{ ref('stg_customer') }}
    JOIN {{ ref('stg_nation') }} ON C_NATIONKEY = N_NATIONKEY
    JOIN {{ ref('stg_region') }} ON N_REGIONKEY = R_REGIONKEY
)

SELECT *
FROM source_data