/*
================================================
PERFORMANCE ANALYSIS
================================================
SCRIPT PURPOSE:
     This script evaluates the yearly performance of each product by comparing
     its current year sales against two benchmarks: its own historical average
     sales across all years, and its sales from the previous year. A CTE first
     aggregates total sales per product per year. Window functions then calculate
     the per-product average across all years (AVG with PARTITION BY product_name)
     and retrieve the prior year's sales using the LAG function. The difference
     between current and benchmark values is computed, and each product-year
     combination is labelled as Above AVG / Below AVG and Increase / Decrease /
     No Change accordingly.
 
NOTE:
     This dual-benchmark approach allows you to distinguish between short-term
     year-over-year fluctuations and longer-term underperformance relative to
     a product's own historical baseline. Both comparisons are essential for
     a complete performance review.
*/

-- ==========================================
-- Performance Analysis: COMPARING THE CURRENT VALUE TO A TARGET VALUE
-- ==========================================

/* ANALYZE THE YAERLY PERFORMANCE OF PRODUCTS COMPARING EACH PRODUCT'S SALES TO BOTH
 ITS AVERAGE SALES PERFORMANCE AND THE PREVIOUS YEAR'S SALLES */

 WITH yearly_product_sales AS (
 Select
   year(f.order_date) AS order_year,
   p.product_name,
   sum(f.sales_amount) AS current_sales
 From gold.fact_sales f
 LEFT JOIN gold.dim_product p
 ON f.product_key = p.product_key
 WHERE f.order_date IS NOT NULL
 GROUP BY 
 year(f.order_date),
 p.product_name
)

Select 
  order_year,
  product_name,
  current_sales, 
  avg(current_sales) over (partition by product_name) avg_sales,
  current_sales - avg(current_sales) over (partition by product_name) AS diff_avg,
case 
     When current_sales - avg(current_sales) over (partition by product_name) > 0 THEN 'Above AVG'
     When current_sales - avg(current_sales) over (partition by product_name) < 0 THEN 'BELOW AVG'
     ELSE 'AVG'
END avg_change,
-- YEAR-OVER-YEAR ANALYSIS (YOY ANALYSIS)
LAG(current_sales) over (partition by product_name order by order_year) py_sales,
current_sales - LAG(current_sales) over (partition by product_name order by order_year) as diff_py,
Case 
     WHEN current_sales - LAG(current_sales) over (partition by product_name order by order_year) > 0 THEN 'increase'
     WHEN current_sales - LAG(current_sales) over (partition by product_name order by order_year) < 0 THEN 'decrease'
     ELSE 'no change'
END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
