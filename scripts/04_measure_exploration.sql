/*
================================================
MEASURE EXPLORATION (BIG NUMBERS)
================================================
SCRIPT PURPOSE:
     This script calculates the key headline metrics of the business. It computes
     total sales revenue, total quantity of items sold, average selling price,
     and total number of orders from the sales fact table. It also counts the
     total number of products in the product dimension and the total number of
     customers in the customer dimension — including a separate count of only
     those customers who have actually placed an order. Finally, it consolidates
     all key metrics into a single summary report using UNION ALL for a quick
     business overview.

NOTE:
     These are the "big number" KPIs that give a birds-eye view of business
     performance. The final UNION ALL report is suitable for an executive
     summary or dashboard header.
*/

 --=======================================
 -- MEASURE EXPLORATION (BIG NUMBERS): CALCULATE THE KEY METRIC OF THE BUSINESS (BIG NUMBERS)
 -- ======================================

 -- FIND THE TOTAL SALES

 SELECT SUM(sales_amount) as total_sales 
 From gold.fact_sales

 -- Find how many items are sold
   
 SELECT SUM(quantity) as total_quantity 
 From gold.fact_sales

 -- FIND THE AVERAGE SELLING PRICE
   
 SELECT AVG(pricce) as avg_price 
 From gold.fact_sales

 -- FIND THE TOTAL NUMBERS OF ORDERS
   
  SELECT COUNT(order_number) as total_orders 
 From gold.fact_sales;

 SELECT COUNT(distinct order_number) as total_orders 
 From gold.fact_sales;

 -- FIND THE TOTAL NUMBERS OF PRODUCTS

SELECT COUNT(product_key) as total_orders 
 From gold.dim_product;

 SELECT COUNT(distinct product_name) as total_orders 
 From gold.dim_product;

 -- FIND THE TOTAL NUMBERS OF CUSTOMMERS

 SELECT COUNT(customer_key) as total_orders 
 From gold.dim_customers;

 -- FIND THE TOTAL NUMBER OF CUSTOMERS THAT HAS PLACCED AN ORDER

SELECT COUNT(distinct customer_key) as total_orders 
 From gold.fact_sales;

 -- GENERATE REPORT THAT SHOWS ALL KEY METRICS OF THE BUSINESS

 SELECT 'TOTAL SALES' AS measure_name, SUM(sales_amount) as measure_value 
 From gold.fact_sales
 UNION ALL
 SELECT 'TOTAL QUANTITY' AS measure_name, SUM(quantity) as measure_value 
 From gold.fact_sales
 UNION ALL
 SELECT 'TOTAL PRICE' AS measure_name, AVG(pricce) as measure_value 
 From gold.fact_sales
 UNION ALL
 SELECT 'TOTAL Nr. ORDERS' AS measure_name, COUNT(order_number) as measure_value 
 From gold.fact_sales
 UNION ALL
 SELECT 'TOTAL Nr. PRODUCTS' AS measure_name, COUNT(product_name) as measure_value 
 From gold.dim_product
 UNION ALL
  SELECT 'TOTAL Nr. CUSTOMERS' AS measure_name, COUNT(customer_key) as  measure_value
 From gold.dim_customers;
