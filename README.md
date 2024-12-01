# Median Search Frequency Solution

This repository contains the SQL solution for the "Median Search Frequency" challenge from [DataLemur](https://datalemur.com/questions/median-search-freq).

## Problem Statement

Google's marketing team is preparing a Superbowl commercial and needs a simple statistic for their TV ad: the median number of searches a person made last year. Calculating this statistic directly on 2 trillion searches would be too costly, but we have access to a summarized table that provides the number of searches and the count of users performing those searches.

### Input Example

| searches | num_users |
|----------|-----------|
| 1        | 2         |
| 2        | 2         |
| 3        | 3         |
| 4        | 1         |

### Output Example

| median |
|--------|
| 2.5    |

By expanding the `search_frequency` table, we get the list: `[1, 1, 2, 2, 3, 3, 3, 4]`, which has a median of `2.5` searches per user.

## Solution

The query uses a combination of Common Table Expressions (CTEs), the `GENERATE_SERIES` function, and window functions to calculate the median efficiently.

```sql
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
```

### Explanation

1. **`expanded_searches`:**
   - Expands the table using the `GENERATE_SERIES` function to create individual entries for each user based on the `num_users` column.

2. **`ordered_searches`:**
   - Assigns a row number (`row_num`) to each entry, ordered by the number of searches.
   - Calculates the total count of rows (`total_count`) to identify the median position.

3. **Median Calculation:**
   - Identifies the median based on whether the total count is odd or even.
   - Uses the `AVG()` function to calculate the median value, rounded to one decimal place.

## How to Use

You can copy and paste the SQL query into your PostgreSQL environment to solve the problem. Ensure you have a table named `search_frequency` with the columns `searches` (integer) and `num_users` (integer).

## Notes

This repository was created as part of my learning journey and portfolio in SQL challenges. The problem originates from [DataLemur](https://datalemur.com/questions/median-search-freq).

Feel free to explore, suggest improvements, or use it for your learning purposes.

