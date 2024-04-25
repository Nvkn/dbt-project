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
JOIN {{ source('tpch_sf1', 'orders') }} AS O ON C.C_CUSTKEY = O.O_CUSTKEY
JOIN {{ source('tpch_sf1', 'nation') }} AS N ON C.C_NATIONKEY = N.N_NATIONKEY
JOIN {{ source('tpch_sf1', 'region') }} AS R ON N.N_REGIONKEY = R.R_REGIONKEY
WHERE O.O_ORDERKEY IN (
    SELECT O_ORDERKEY
    FROM {{ source('tpch_sf1', 'orders') }}
    WHERE o_orderkey > coalesce((
        SELECT MAX(o_orderkey)
        FROM {{ ref('stg_orders') }}
        ORDER BY o_orderkey
    ),0)
    ORDER BY O_ORDERKEY
    LIMIT 10
)
{% if is_incremental() %}
-- Evita re-procesar los mismos C_CUSTKEY si ya existen en la tabla
AND C.C_CUSTKEY NOT IN (
    SELECT C_CUSTKEY
    FROM {{ this }}
    LIMIT 10
)
{% endif %}
