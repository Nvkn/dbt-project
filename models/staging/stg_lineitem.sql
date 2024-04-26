-- models/staging/stg_lineitem.sql

{{ config(
    materialized='incremental',
    unique_key=['L_ORDERKEY', 'L_LINENUMBER']
) }}

SELECT
  L_ORDERKEY,
  L_PARTKEY,
  L_SUPPKEY,
  L_LINENUMBER,
  L_QUANTITY,
  L_EXTENDEDPRICE,
  L_DISCOUNT,
  L_TAX,
  L_RETURNFLAG,
  L_LINESTATUS,
  L_SHIPDATE,
  L_COMMITDATE,
  L_RECEIPTDATE,
  L_SHIPINSTRUCT,
  L_SHIPMODE
FROM {{ source('db_source', 'lineitem') }}