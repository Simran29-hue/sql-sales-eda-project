/*
================================================
DATE EXPLORATION
================================================
SCRIPT PURPOSE:
     This script explores the date boundaries within the data. It identifies
     the earliest and latest order dates from the sales fact table and calculates
     the total range of sales data available in months. It also retrieves the
     oldest and youngest customers from the customer dimension by analyzing
     birthdates and computing their current ages using today's date.

NOTE:
     This section helps establish the time boundaries of the dataset, which is
     critical for scoping any time-based analysis or trend reporting.
*/

-- ==================================
-- DATE EXPLORATION : IDENTIFY THE EARLIEST AND LATEST DATES (BOUNDARIES).
-- ==================================
 
 -- Find the date of the first and last order
 -- HOW MANY YEARS OF SALES ARE AVAILABLE
 Select 
   min(order_date) as first_order_date ,
   max(order_date) as last_order_date,
   DATEDIFF ( month, MIN (ORDER_DATE), MAX (ORDER_DATE)) AS order_range_months
 From gold.fact_sales;

 -- Find the youngest and the oldest customer
 Select
   MIN(birthdate) AS oldest_birthdate,
   DATEDIFF (YEAR, MIN (birthdate), GETDATE()) AS oldest_age,
   MAX(birthdate) as youngest_birthdate,
   DATEDIFF (YEAR, MAX (birthdate), GETDATE()) as youngest_age
 From gold.dim_customers;
