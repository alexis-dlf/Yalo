WITH revenue_by_customer AS (
  SELECT 
      customer_id,
      SUM(CASE 
              WHEN item_status = 'sold' THEN number_items * purchase_price 
              ELSE 0 
          END) AS original_spent,
      SUM(CASE 
              WHEN item_status = 'returned' THEN number_items * purchase_price 
              ELSE 0 
          END) AS additional_potential_revenue
  FROM test_order_details
GROUP BY customer_id
)
SELECT customer_id,
       COALESCE(original_spent,0) AS original_spent,
       COALESCE(additional_potential_revenue, 0) AS additional_potential_revenue,
       COALESCE(additional_potential_revenue, 0) + COALESCE(original_spent,0) AS total_potential_revenue,
       CASE 
           WHEN original_spent = 0 THEN 100
           ELSE (COALESCE(additional_potential_revenue, 0) / original_spent) * 100 
       END AS percentage_increase
FROM revenue_by_customer
