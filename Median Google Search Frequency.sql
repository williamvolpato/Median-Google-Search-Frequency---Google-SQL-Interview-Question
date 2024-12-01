WITH expanded_searches AS (
    SELECT 
        searches
    FROM 
        search_frequency, 
        GENERATE_SERIES(1, num_users)
),
ordered_searches AS (
    SELECT 
        searches,
        ROW_NUMBER() OVER (ORDER BY searches) AS row_num,
        COUNT(*) OVER () AS total_count
    FROM 
        expanded_searches
)
SELECT 
    ROUND(AVG(searches)::NUMERIC, 1) AS median
FROM 
    ordered_searches
WHERE 
    row_num IN ((total_count + 1) / 2, (total_count + 2) / 2);