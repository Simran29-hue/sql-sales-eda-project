/*
===============================================
DIMENSION EXPLORATION
================================================
SCRIPT PURPOSE:
     This script explores the dimension tables to identify the unique values
     and categories available in the data. It retrieves all distinct countries
     from the customer dimension to understand the geographic spread of customers.
     It also retrieves all distinct product categories, subcategories, and product
     names from the product dimension to map out the full product hierarchy.

NOTE:
     These queries are read-only and do not modify any data. Use this section
     to get a high-level understanding of the categorical breakdowns before
     performing deeper analysis.
*/

-- ==================================================
-- DIMENSION EXPLORATION : IDENTIFY THE UNIQUE VALUES (OR CATEGORIES) IN EACH DIMENSION
-- ==================================================

-- EXPLORE ALL  COUNTRIES OUR CUSTOMERS COME FROM.

SELECT DISTINCT 
  country 
FROM gold.dim_customers

-- EXPLORE ALL CATEGORIES "THE MAJOR DIVISIONS"

SELECT DISTINCT 
  category, 
  subcategory, 
  product_name 
FROM gold.dim_product
ORDER BY 1,2,3;
