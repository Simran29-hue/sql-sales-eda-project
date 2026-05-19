/*
 DATABASE EXPLORATION
================================================
SCRIPT PURPOSE:
     This script explores the structure of the database by retrieving metadata
     from the INFORMATION_SCHEMA. The first query retrieves a full list of all
     tables available in the database, providing an overview of the data landscape.
     The second query drills into the 'dim_customers' table specifically, returning
     all column names, data types, and properties to understand its structure
     before performing any analysis.

NOTE:
     These queries do not modify any data. They are read-only and safe to run
     at any time. Use this script at the start of any EDA workflow to familiarize
     yourself with the database schema before writing analytical queries.
*/

-- ===========================
-- DATABASE EXPLORATION
-- ===========================

-- EPLORE ALL COLUMNS IN THE DATABAASE

SELECT * FROM INFORMATION_SCHEMA.TABLES


-- EXPLORE ALL COLUMNS IN THE DATABASE
  
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
