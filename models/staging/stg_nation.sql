-- models/staging/stg_nation.sql

{{ config(
    materialized='incremental',
    unique_key='N_NATIONKEY'
) }}

WITH source_data AS (
    SELECT
        N_NATIONKEY,
        N_NAME,
        N_REGIONKEY,
        cast(CONV_USD_TO_LOCAL AS FLOAT) AS N_USD_TO_LOCAL
    FROM {{ source('db_source', 'nation') }}
    JOIN {{ source('db_source', 'currency_conversion') }} ON N_NATIONKEY = CONV_NATIONKEY
)

SELECT *
FROM source_data