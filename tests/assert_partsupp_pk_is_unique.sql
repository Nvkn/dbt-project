SELECT
    PS_PARTKEY,
    PS_SUPPKEY,
    COUNT(*) as repetitions
FROM {{ ref('stg_partsupp') }}
GROUP BY (PS_PARTKEY, PS_SUPPKEY)
HAVING repetitions > 1