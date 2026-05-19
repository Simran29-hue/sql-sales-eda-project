/*
================================================
CHANGE-OVER-TIME ANALYSIS
================================================
SCRIPT PURPOSE:
     This script analyzes how key sales measures evolve over time. It tracks
     monthly total sales revenue, the number of distinct customers, and total
     quantity sold from the sales fact table. Three approaches are demonstrated:
     extracting year and month as separate numeric columns, truncating the date
     to the first day of each month using DATETRUNC, and formatting the date as
     a readable 'yyyy-MMM' string using FORMAT. All three approaches produce the
     same result but offer different formatting options depending on the reporting
     tool being used.
 
NOTE:
     Rows where order_date is NULL are excluded in all three queries to avoid
     misrepresenting the time series. Use this section to identify seasonal
     patterns, growth trends, or sudden drops in sales activity.
*/

-- ======================================
-- CHANGE-OVER-TIME: ANALYZE HOW A MEASURE EVOLVES OVER TIME
-- ======================================

-- ANALYZE SALES PERFORMANCE OVER TIME

SELECT 
    year(order_date) as order_year,
    month(order_date) as order_month,
    sum(sales_amount) as total_sales,
    count(distinct customer_key) as total_customers,
    sum(quantity) as total_quantity
FROM gold.fact_sales
where order_date is not null
group by year (order_date), month(order_date)
order by year (order_date), month(order_date);

SELECT 
    DATETRUNC(MONTH, order_date) as order_date,
    sum(sales_amount) as total_sales,
    count(distinct customer_key) as total_customers,
    sum(quantity) as total_quantity
FROM gold.fact_sales
where order_date is not null
group by DATETRUNC(MONTH, order_date)
order by DATETRUNC(MONTH, order_date);

SELECT 
    FORMAT(order_date, 'yyyy-MMM') as order_date,
    sum(sales_amount) as total_sales,
    count(distinct customer_key) as total_customers,
    sum(quantity) as total_quantity
FROM gold.fact_sales
where order_date is not null
group by FORMAT(order_date, 'yyyy-MMM')
order by FORMAT(order_date, 'yyyy-MMM');
