SELECT
    I_SUPPKEY, 
    I_ITEMKEY,
    COUNT(*) as repetitions
FROM {{ ref('dim_items') }}
GROUP BY (I_SUPPKEY, I_ITEMKEY)
HAVING repetitions > 1