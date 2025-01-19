SELECT 
    county,
    SUM(sale_dollars) AS total_amount
FROM bigquery-public-data.iowa_liquor_sales.sales
GROUP BY county
HAVING SUM(sale_dollars) > 100000
ORDER BY 2 DESC
