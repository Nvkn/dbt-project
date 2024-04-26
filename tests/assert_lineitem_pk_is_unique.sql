SELECT
    L_ORDERKEY, 
    L_LINENUMBER,
    COUNT(*) as repetitions
FROM {{ ref('stg_lineitem') }}
GROUP BY (L_ORDERKEY, L_LINENUMBER)
HAVING repetitions > 1