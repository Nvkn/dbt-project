-- models/dim_items.sql

{{ config(
    materialized='incremental',
    unique_key= ['I_ITEMKEY', 'I_SUPPKEY']
) }}

WITH source_data AS (
    SELECT
        P_PARTKEY AS I_ITEMKEY,
        P_NAME AS I_NAME,
        P_MFGR AS I_MFGR,
        P_BRAND AS I_BRAND,
        P_TYPE AS I_TYPE,
        P_SIZE AS I_SIZE,
        P_CONTAINER AS I_CONTAINER,
        P_RETAILPRICE AS I_RETAILPRICE,
        S_SUPPKEY AS I_SUPPKEY,
        S_NAME AS I_SUPPLIER,
        N_NAME as I_SUPPLIERNATION,
        R_NAME AS I_SUPPLIERREGION,
        PS_AVAILQTY AS I_AVAILQTY,
        PS_SUPPLYCOST AS I_SUPPLYCOST
    FROM {{ ref('stg_part') }}
    JOIN {{ ref('stg_partsupp') }} ON P_PARTKEY = PS_PARTKEY
    JOIN {{ ref('stg_supplier') }} ON PS_SUPPKEY = S_SUPPKEY
    JOIN {{ ref('stg_nation') }} ON S_NATIONKEY = N_NATIONKEY
    JOIN {{ ref('stg_region') }} ON N_REGIONKEY = R_REGIONKEY
)

SELECT *
FROM source_data