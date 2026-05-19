/*
================================================
RANKING ANALYSIS
================================================
SCRIPT PURPOSE:
     This script ranks dimension values based on their associated measure values
     to identify top and bottom performers. It finds the top 5 highest-revenue
     products and subcategories using both TOP N and window functions (ROW_NUMBER).
     It also identifies the 5 worst-performing products and subcategories by sales,
     the top 10 customers by total revenue generated, and the 3 customers who have
     placed the fewest orders.

NOTE:
     Ranking analysis is useful for prioritizing high-value segments and identifying
     underperforming areas that may need attention. The window function approach
     (ROW_NUMBER) is included as an alternative to TOP N, offering more flexibility
     for use inside subqueries or CTEs.
*/

-- ============================================
-- RANKING ANALYSIS: ORDER THE VALUES OF DIMENSIONS BY MEASURE.
-- ============================================

-- WHICH 5 PRODUCTS GENERATE THE HIGHEST REVENUE?

SELECT TOP 5
  p.product_name,
  SUM(f.sales_amount) total_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT TOP 5
  p.subcategory,
  SUM(f.sales_amount) total_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;

-- USING WINDOW FUNCTION

SELECT *
FROM (
  SELECT 
    p.product_name,
    SUM(f.sales_amount) total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS RANK_PRODUCTS
  From gold.fact_sales f
  Left Join gold.dim_product p
  On p.product_key = f.product_key
  Group By p.product_name)t
  WHERE RANK_PRODUCTS <=5


-- WHAT ARE THE 5 WORST-PERFORMING PRODUCTS I TERMS OF SALES?

SELECT TOP 5
  p.product_name,
  SUM(f.sales_amount) total_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue; 

SELECT TOP 5
  p.subcategory,
  SUM(f.sales_amount) total_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue; 

-- FIND THE TOP 10 CUSTOMERS WHO HAVE GENERATED THE HIGHEST REVENUE

SELECT TOP 10
  c.customer_key,
  c.first_name,
  c.last_name,
  SUM(f.sales_amount) as total_revenue
From gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
  c.customer_key,
  c.first_name,
  c.last_name
ORDER BY total_revenue DESC;

-- THE 3 CUSTOMERS WITH THE FEWEST ORDERS PLACED

SELECT TOP 3
  c.customer_key,
  c.first_name,
  c.last_name,
  COUNT (DISTINCT order_number) as total_orders
From gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
  c.customer_key,
  c.first_name,
  c.last_name
ORDER BY total_orders
