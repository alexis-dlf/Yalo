SELECT 
    t1.customer_id,
    t1.purchase_date,
    t1.purchase_revenue,
    COALESCE(t2.calculated_revenue,0) AS calculated_revenue,
    t1.purchase_revenue - COALESCE(t2.calculated_revenue,0) AS revenue_difference
FROM 
    test_orders t1
LEFT JOIN (
            SELECT  customer_id,
                    purchase_timestamp AS purchase_date,
                    SUM(number_items * purchase_price) AS calculated_revenue
            FROM test_order_details
            WHERE item_status = 'sold'
          ) AS t2 ON t1.customer_id = t2.customer_id AND t1.purchase_date = t2.purchase_date
WHERE (t1.purchase_revenue - COALESCE(t2.calculated_revenue,0)) <> 0
