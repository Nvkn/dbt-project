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
WHERE O.O_ORDERKEY NOT IN (
    SELECT
        O_ORDERKEY
    FROM {{ source('tpch_sf1', 'orders') }}
    {% if is_incremental() %}
    WHERE O_ORDERKEY > (SELECT COALESCE(MAX(O_ORDERKEY), 0) FROM {{ ref('stg_orders') }})
    {% endif %}
)