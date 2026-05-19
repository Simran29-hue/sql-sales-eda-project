/*
================================================
DATA SEGMENTATION
================================================
SCRIPT PURPOSE:
     This script groups both products and customers into meaningful segments to
     reveal behavioural and structural patterns in the data.
 
     Products are segmented into four cost ranges (Below 100, 100-500, 500-1000,
     Above 1000) using a CASE statement, and the count of products in each range
     is reported. This helps identify how the product catalogue is distributed
     across price tiers.
 
     Customers are segmented into three groups based on their purchasing lifespan
     and total spending:
       - VIP      : At least 12 months of purchase history AND total spending above 5000.
       - Regular  : At least 12 months of purchase history but spending 5000 or less.
       - New      : Less than 12 months of purchase history regardless of spend.
     The total number of customers in each segment is reported to support targeted
     marketing and retention strategies.
 
NOTE:
     Both segmentations use CTEs to first compute the raw values, then apply the
     CASE-based classification in an outer query. This two-step pattern keeps the
     logic clean and easy to modify if segment thresholds need to be adjusted.
*/

-- =======================================
-- DATA SEGMENTATION
-- =======================================

/* SEGMENT PRODUCTS INTO COST RANGE AND 
   COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT*/

WITH product_segment AS (
SELECT
  product_key,
  product_name,
  cost,
  CASE 
       WHEN cost <100 then 'below 100'
       when cost BETWEEN 100 AND 500 THEN '100-500'
       WHEN cost BETWEEN 500 AND 1000 THEN '500-1000' 
       ELSE 'ABOVE 1000'
  END cost_range
FROM gold.dim_product
)

Select 
  cost_range,
  count(product_key) AS total_products
From product_segment
GROUP BY cost_range
ORDER BY total_products DESC;

/* GROUP CUSTOMERS INTO THREE SEGMENTS BASED ON THEIR SPENDING BEHAVIOUR:
   - VIP CUSTOMERS WITH AT LEAST 12 MONTHS OF HISTORY AND SPENDING MORE THAN 5000.
   - REGULAR: CUSTOMERS WITH AT LEAST 12 MONTHS OF HISTORY BUT SPENDING 500 OR LESS.
   - NEW: CUSTOMERS WITH A LIFESPAN LESS THAN 12 MONTHS.
AND FIND THE TOTAL NUMBER OF CUSTOMERS BY EACH GROUP
*/

WITH customer_spending AS (
SELECT
c.customer_key,
sum (f.sales_amount) AS total_spending,
MIN (order_date) AS first_order,
MAX (order_date) AS last_order,
datediff (month, MIN (order_date), MAX (order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
Select 
  customer_segment,
  Count(customer_key) AS total_customers
From (
    Select
      customer_key,
      CASE 
           WHEN lifespan >= 12 and total_spending > 5000 THEN 'VIP'
           WHEN lifespan >= 12 and total_spending <= 5000 THEN 'REGULAR'
           ELSE 'NEW'
      END customer_segment
    From customer_spending
)t 
GROUP BY customer_segment
ORDER BY total_customers DESC;
