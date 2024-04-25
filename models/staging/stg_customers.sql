-- models/staging/stg_customers.sql

{{ config(
    materialized='incremental',
    unique_key='C_CUSTKEY'
) }}

SELECT
  C.C_CUSTKEY,
  C.C_NAME,
  C.C_ADDRESS,
  C.C_PHONE,
  N.N_NAME AS C_NATION_NAME,
  R.R_NAME AS C_REGION_NAME,
  C.C_ACCTBAL,
  C.C_MKTSEGMENT
FROM {{ source('tpch_sf1', 'customer') }} AS C
JOIN {{ ref('stg_orders') }} AS O ON C.C_CUSTKEY = O.O_CUSTKEY
JOIN {{ source('tpch_sf1', 'nation') }} AS N ON C.C_NATIONKEY = N.N_NATIONKEY
JOIN {{ source('tpch_sf1', 'region') }} AS R ON N.N_REGIONKEY = R.R_REGIONKEY
{% if is_incremental() %}
WHERE C.C_CUSTKEY NOT IN (
    SELECT C_CUSTKEY
    FROM {{ this }}
{% endif %}
)