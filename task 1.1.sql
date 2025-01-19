-- Calculate total products and revenue by quarter
WITH revenue_by_quarter AS (
    SELECT 
        DATE_TRUNC(date, QUARTER) AS quarter,
        COUNT(1) AS total_products,
        SUM(sale_dollars) AS total_revenue
    FROM bigquery-public-data.iowa_liquor_sales.sales
    GROUP BY 1
),
-- Calculate the average monthly revenue
monthly_revenue AS (
    SELECT 
        DATE_TRUNC(date, MONTH) AS month,
        SUM(sale_dollars) AS monthly_revenue_usd
    FROM `bigquery-public-data.iowa_liquor_sales.sales`
    GROUP BY 1
),

-- Calculate the average revenue across all months
average_monthly_revenue AS (
    SELECT 
        AVG(monthly_revenue_usd) AS avg_revenue
    FROM monthly_revenue
),

-- Identify months where revenue is 10% above average
months_above_avg AS (
    SELECT 
        m.month,
        m.monthly_revenue_usd,
        avg_revenue,
        m.monthly_revenue_usd > avg_revenue * 1.10 AS is_above_avg
    FROM monthly_revenue m
    CROSS JOIN average_monthly_revenue
)
-- Final output
SELECT 
    r.quarter,
    r.total_products,
    r.total_revenue,
    ARRAY_AGG(ma.month ORDER BY ma.month) AS above_avg_months
FROM revenue_by_quarter r
LEFT JOIN months_above_avg ma ON DATE_TRUNC(ma.month, QUARTER) = r.quarter AND ma.is_above_avg IS TRUE
WHERE ma.month IS NOT NULL
GROUP BY 1,2,3
ORDER BY r.quarter
