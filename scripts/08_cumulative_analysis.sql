/*
================================================
CUMULATIVE ANALYSIS
================================================
SCRIPT PURPOSE:
     This script progressively aggregates sales data over time to reveal growth
     trends that individual period snapshots cannot show. It first summarizes
     total sales and average price per year using DATETRUNC, then applies two
     window functions on top of that aggregation: a running total of sales
     accumulated year over year, and a moving average of the selling price across
     all years up to the current row. These metrics together give a clear picture
     of both revenue momentum and pricing trends over time.
 
NOTE:
     The running total uses SUM() OVER with ORDER BY to accumulate values
     chronologically. The moving average uses AVG() OVER with ORDER BY (no
     PARTITION BY), so it expands across the entire date range. This section
     is particularly useful for identifying compounding growth or decline
     in business performance.
*/

-- CALCULATE THE TOTAL SALES PER MONTH
-- AND THE RUNNING TOTAL OF SALES OVER TIME

SELECT
    order_date,
    total_sales,
    sum(total_sales) over (partition by order_date order by order_date desc) as running_total_sales,
    avg(avg_price) over (order by order_date) AS moving_average_price
-- window function
from
(
SELECT
  DATETRUNC(year, order_date) AS order_date,
  SUM(sales_amount) AS total_sales,
  avg(pricce) as avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
group by DATETRUNC(year, order_date)
)t;
