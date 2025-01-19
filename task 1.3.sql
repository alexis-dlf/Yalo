-- Rank stores by total revenue
WITH store_revenue AS (
    SELECT 
        store_name,
        SUM(sale_dollars) AS total_revenue_usd,
        RANK() OVER (ORDER BY SUM(sale_dollars) DESC) AS revenue_rank,
        RANK() OVER (ORDER BY SUM(sale_dollars) ASC) AS reverse_rank
    FROM bigquery-public-data.iowa_liquor_sales.sales
    GROUP BY store_name
)
-- Combine top and bottom stores
SELECT 
    store_name,
    total_revenue_usd,
    revenue_rank AS rank,
    'Top 10' AS category
FROM store_revenue
WHERE revenue_rank <= 10
UNION ALL
SELECT 
    store_name,
    total_revenue_usd,
    revenue_rank AS rank,
    'Bottom 10' AS category
FROM store_revenue
WHERE reverse_rank <= 10
ORDER BY total_revenue_usd DESC
