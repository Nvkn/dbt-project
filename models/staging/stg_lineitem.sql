-- models/staging/stg_lineitem.sql

{{ config(
    materialized='incremental',
    unique_key=['L_ORDERKEY', 'L_LINENUMBER']
) }}

SELECT
  L_ORDERKEY,
  L_LINENUMBER,
  L_SUPPKEY,
  L_PARTKEY,
  L_QUANTITY,
  CAST(L_EXTENDEDPRICE AS REAL) AS L_EXTENDEDPRICE,
  CAST(L_DISCOUNT AS REAL) AS L_DISCOUNT ,
  CAST(L_TAX AS REAL) AS L_TAX,
  L_RETURNFLAG,
  L_LINESTATUS,
  L_SHIPDATE,
  L_COMMITDATE,
  L_RECEIPTDATE,
  L_SHIPINSTRUCT,
  L_SHIPMODE
FROM {{ source('db_source', 'lineitem') }}