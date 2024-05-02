-- models/dim_time.sql

{{ config(
    materialized='incremental',
    unique_key='T_Timekey'
) }}

WITH date_elements AS (
    SELECT DISTINCT
        TO_CHAR(O_ORDERDATE, 'YYYYMMDDHH24MISS')::INT AS T_Timekey,
        O_ORDERDATE AS T_SQL_Date_Stamp,
        DATE(O_ORDERDATE) AS T_Date,
        EXTRACT(dayofweek FROM O_ORDERDATE) AS T_Day_Number_of_Week,
        EXTRACT(day FROM O_ORDERDATE) AS T_Day_Number_of_Month,
        EXTRACT(dayofyear FROM O_ORDERDATE) AS T_Day_Number_of_Year,
        EXTRACT(weekofyear FROM O_ORDERDATE) AS T_Calendar_Week_Number_in_Year,
        MONTHNAME(O_ORDERDATE) AS T_Calendar_Month_Name,
        MONTH(O_ORDERDATE) AS T_Calendar_Month_Number_In_Year,
        TO_CHAR(O_ORDERDATE, 'YYYY-MM') AS T_Calendar_Year_Month,
        DATE_PART(quarter, O_ORDERDATE) AS T_Calendar_Quarter,
        CASE
            WHEN  T_Calendar_Quarter IN (1, 2) THEN 'First Half'
            ELSE 'Second Half'
        END AS T_Calendar_Half_Year,
        TO_CHAR(O_ORDERDATE, 'YYYY') AS T_Calendar_Year,
        CASE 
            WHEN T_Day_Number_of_Week IN (1, 5) THEN 'Weekday'
            ELSE 'Weekend'
        END AS T_Weekday_Indicator
    FROM {{ ref('stg_orders') }}
)

SELECT *
FROM date_elements