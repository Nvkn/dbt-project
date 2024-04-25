{{ config(materialized='table') }}

-- Create the empty table
CREATE TABLE RAW_DATA.RAW_DATA_SCHEMA.emptytable (
  column1 VARCHAR(50),
  column2 INT,
  column3 DATE
);
