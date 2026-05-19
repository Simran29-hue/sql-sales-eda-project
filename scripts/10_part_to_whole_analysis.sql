/*
================================================
PART-TO-WHOLE (PROPORTIONAL) ANALYSIS
================================================
SCRIPT PURPOSE:
     This script calculates the percentage contribution of each product category
     to overall total sales revenue. A CTE first aggregates total sales per
     category by joining the sales fact table with the product dimension. A window
     function (SUM OVER with no PARTITION BY) then computes the grand total across
     all categories in a single pass, avoiding a separate subquery. Each category's
     share is calculated as a percentage and formatted as a string with two decimal
     places for readability.
 
NOTE:
     Part-to-whole analysis is critical for understanding revenue concentration.
     If one or two categories dominate total sales, that signals both an opportunity
     and a business risk. Results are ordered by total sales descending to surface
     the highest-contributing categories first.
*/

-- ===========================================
-- PART-TO-WHOLE (PROPORTIONAL) ANALYSIS
-- ===========================================

-- WHICH CATEGORIES CONTRIBUTE THE MOST TO OVERALL SALES

WITH category_sales AS (
  SELECT
      category,
      sum(sales_amount) total_sales
  from gold.fact_sales f
  LEFT JOIN gold.dim_product p
  ON p.product_key = f.product_key
  GROUP BY category)

Select 
  category,
  total_sales,
  sum(total_sales) over () overall_sales,
  CONCAT(ROUND((CAST(total_sales AS float)/ sum(total_sales) over ())*100, 2), '%') AS percentage_of_total
From category_sales
ORDER BY total_sales DESC
