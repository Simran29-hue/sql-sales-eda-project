/*
================================================
CUSTOMER REPORT (VIEW)
================================================
SCRIPT PURPOSE:
     This script creates a reusable SQL view (gold.report_customers) that
     consolidates all key customer metrics and behavioural attributes into a
     single queryable object. It is structured in three layers:
 
     1. BASE QUERY: Joins the sales fact table with the customer dimension to
        retrieve all transactional records alongside customer attributes,
        including a calculated age field derived from the customer's birthdate.
 
     2. CUSTOMER AGGREGATION: Groups the base query by customer to compute
        lifetime metrics including total orders, total sales revenue, total
        quantity purchased, total distinct products bought, last order date,
        and customer lifespan in months.
 
     3. FINAL SELECT: Applies business logic on top of the aggregated data
        to produce two classification columns (age group and customer segment),
        and two KPI columns:
          - Recency         : Number of months since the customer's last order.
          - Avg Order Value : Total sales divided by total orders.
          - Avg Monthly Spend: Total sales divided by lifespan in months
                               (uses total sales directly if lifespan is zero
                               to avoid division by zero).
 
NOTE:
     This view is designed to serve as the foundation for customer-level
     dashboards, segmentation reports, and retention analyses. Because it is
     a view, it always reflects the latest data in the underlying tables
     without requiring manual refresh.
*/

/* 
==============================================================
CUSTOMER REPORT
==============================================================
HIGHLIGHT:
    1. GATHERS ESSENTIAL FIELDS SUCH AS NAMES, AGES, AND TRANSACTIONS DETAILS.
    2. SEGMENTS CUSTOMERS INTO CATEGORIES (VIP, REGULAR, NEW) AND AGE GROUP
    3. AGGREGATES CUSTOMER-LEVEL METRICS:
       - TOTAL ORDERS
       - TOTAL SALES
       - TOTAL QUANTITY PURCHASED
       - TOTAL PRODUCTS
       - LIFESPAN (IN MONTHS)
    4. CALCULATES VALUABLE KPIs:
      - RECENCY(MONTHS SINCE LAST ORDER)
      - AVERAGE ORDER VALUE
      - AVERAGE MONTHLY SPEND
================================================================
*/

Create View gold.report_customers AS 

WITH base_query AS (
/*---------------------------------------------------------------
1) BASE QUERY: RETRIEVES CORE COLUMN FROM TABLES
-----------------------------------------------------------------*/
SELECT
  f.order_number,
  f.product_key,
  f.order_date,
  f.sales_amount,
  f.quantity,
  c.customer_key,
  c.customer_number,
  concat(c.first_name, ' ', c.last_name) AS customer_name,
  Datediff(year, c.birthdate, getdate()) age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
)
, customer_aggregation AS (
/*---------------------------------------------------------------
2) customer aggregation: RETRIEVES CORE COLUMN FROM TABLES
-----------------------------------------------------------------*/
  Select 
    customer_key,
    customer_number,
    customer_name,
    age,
    Count (Distinct order_number) AS total_orders,
    Sum(sales_amount) AS total_sales,
    Sum (quantity) AS total_quantity,
    Count(Distinct product_key) AS total_products,
    Max(order_date) AS last_order_date,
    Datediff(month, Min(order_date), Max(order_date)) AS lifespan
  From base_query
  GROUP BY
    customer_key,
    customer_number,
    customer_name,
    age)

Select
  customer_key,
  customer_number,
  customer_name,
  age,
  Case 
       When age < 20 Then 'under 20'
       When age between 20 and 29 Then '20-29'
       When age between 30 and 39 Then '30-39'
       When age between 40 and 49 Then '40-49'
       ELSE '50 AND ABOVE'
  END AS age_group,
  CASE 
       WHEN lifespan >= 12 and total_sales > 5000 Then 'VIP'
       WHEN lifespan >= 12 and total_sales <= 5000 Then 'REGULAR'
       ELSE 'NEW'
  END AS customer_segment,
  last_order_date,
  Datediff(month, last_order_date, getdate()) AS recency,
  total_orders,
  total_sales,
  total_quantity,
  total_products,
  lifespan,
-- compute average order value (aov)
  Case 
       WHEN total_orders = 0 THEN 0
       ELSE total_sales / total_orders
  END AS avg_order_value, 
-- COMPUTE AVERAGE MONTHLY SPEND
  CASE 
       WHEN lifespan = 0 THEN total_sales
       ELSE total_sales / lifespan
  END AS avg_monthly_spend
FROM customer_aggregation;
