# 🔍 Exploratory Data Analysis (EDA) — Sales Data Warehouse

## 📖 Project Overview

This project focuses on performing a complete **Exploratory Data Analysis (EDA)** on a Sales Data Warehouse using SQL Server.

The goal of this project is to explore, understand, and analyze the business data before building dashboards or advanced analytics solutions. The analysis covers customer behavior, product performance, revenue trends, segmentation, ranking analysis, cumulative metrics, and time-based sales patterns.

The project is entirely SQL-based and demonstrates how SQL can be used not only for querying data but also for generating meaningful business insights.

---

## 🗂️ Database Schema

The EDA is performed on the `gold` schema of the warehouse.

| Table | Type | Description |
|---|---|---|
| `gold.fact_sales` | Fact Table | Stores transactional sales records including orders, quantities, prices, and revenue |
| `gold.dim_customers` | Dimension Table | Stores customer information such as names, gender, country, and birthdate |
| `gold.dim_product` | Dimension Table | Stores product details including categories, subcategories, products, and costs |

---

# EDA Structure

The analysis is divided into multiple sections:
---
## 1.  Database Exploration
> *Understand the structure of the database before analysis.*

### Analysis Includes
- Exploring all available tables in the database
- Exploring table columns and metadata
- Understanding schema structure
- Identifying available dimensions and measures
---

## 2.  Dimension Exploration
> *Explore the categorical structure of the data.*

### Analysis Includes
- Distinct customer countries
- Product categories
- Product subcategories
- Product names

### Purpose
Understand the business dimensions and available categorical values.

---

## 3.  Date Exploration
> *Identify the date boundaries of the dataset.*

### Analysis Includes
- Earliest order date
- Latest order date
- Sales data range in months
- Oldest customer
- Youngest customer

### SQL Concepts Used
- `MIN()`
- `MAX()`
- `DATEDIFF()`
- `GETDATE()`

---

## 4.  Measure Exploration (Big Numbers)
> *Calculate the major business KPIs.*

### Metrics Calculated
- Total sales revenue
- Total quantity sold
- Average selling price
- Total orders
- Total products
- Total customers
- Customers who placed orders

### Additional Analysis
- Consolidated KPI report using `UNION ALL`

---

## 5.  Magnitude Analysis
> *Compare business measures across categories.*

### Analysis Includes
- Customers by country
- Customers by gender
- Products by category
- Average product cost by category
- Revenue by category
- Revenue by customer
- Quantity sold across countries

### Purpose
Identify high-performing segments and business distribution patterns.

---

## 6.  Ranking Analysis
> *Identify top and bottom performers.*

### Analysis Includes
- Top 5 products by revenue
- Bottom 5 products by revenue
- Top subcategories
- Top customers by revenue
- Customers with the fewest orders

### SQL Concepts Used
- `TOP`
- `ROW_NUMBER()`
- Window Functions

---

## 7.  Change-Over-Time Analysis
> *Analyze business trends over time.*

### Metrics Tracked
- Monthly sales revenue
- Monthly active customers
- Monthly quantity sold

### SQL Concepts Used
- `YEAR()`
- `MONTH()`
- `DATETRUNC()`
- `FORMAT()`

### Purpose
Understand growth trends, seasonality, and sales fluctuations.

---

## 8. Cumulative Analysis
> *Track progressive growth over time.*

### Metrics Calculated
- Running total sales
- Moving average price

### SQL Concepts Used
- `SUM() OVER()`
- `AVG() OVER()`

### Purpose
Analyze long-term business growth and pricing trends.

---

## 9. Performance Analysis
> *Compare current performance with benchmarks.*

### Analysis Includes
- Current sales vs historical average
- Year-over-year product performance
- Product growth classification

### SQL Concepts Used
- `LAG()`
- Window Functions
- CTEs
- CASE Statements

### Output Labels
- Above AVG
- Below AVG
- Increase
- Decrease
- No Change

---

## 10. Part-to-Whole Analysis
> *Measure contribution to total sales.*

### Analysis Includes
- Revenue contribution by category
- Percentage share of total sales

### SQL Concepts Used
- Window Aggregation
- Percentage Calculations

### Purpose
Identify dominant revenue-generating categories.

---

## 11. Data Segmentation
> *Group products and customers into segments.*

### Product Segmentation
Products grouped into:
- Below 100
- 100–500
- 500–1000
- Above 1000

### Customer Segmentation
Customers classified as:
- VIP
- Regular
- New

### Segmentation Based On
- Customer lifespan
- Total spending

---

## 🧾 Customer Report View

The project also creates a reusable analytical SQL View:

```sql
- 'gold.report_customers'
