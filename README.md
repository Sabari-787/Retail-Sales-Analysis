# 🛒 Retail Sales Analysis SQL Project

## 📌 Project Overview

**Title:** Retail Sales Analysis  
**Level:** Beginner  
**Database:** `sql_project_p1`

This project showcases beginner-level SQL skills used by data analysts to explore and analyze retail sales data. You'll create a database, clean messy data, explore sales trends, and answer real-world business questions using SQL.

---

## 🎯 Objectives

- Set up the database and structure for retail sales records.  
- Clean the data to handle missing values.  
- Explore the dataset to uncover customer and sales insights.  
- Solve business questions with SQL queries to drive decision-making.

---

## 🗂️ Database Setup

**Create and use the database:**

```sql
CREATE DATABASE sql_project_p1;
USE sql_project_p1;
```

**Create the main table:**

```sql
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

---

## 🧹 Data Cleaning

**Check for null or missing values:**

```sql
SELECT * 
FROM retail_sales 
WHERE transactions_id IS NULL  
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantiy IS NULL  
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;
```

**Delete records with missing values:**

```sql
DELETE FROM retail_sales 
WHERE transactions_id IS NULL  
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantiy IS NULL  
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;
```

---

## 🔎 Data Exploration

**1. Total Sales:**

```sql
SELECT COUNT(total_sale) AS total_sales FROM retail_sales;
```

**2. Unique Customers:**

```sql
SELECT COUNT(DISTINCT customer_id) AS customers FROM retail_sales;
```

**3. Product Categories:**

```sql
SELECT COUNT(DISTINCT category) AS category_count FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
```

---

## 📊 Data Analysis & Business Queries

**4. Revenue by Gender:**

```sql
SELECT gender, SUM(total_sale) AS total_revenue 
FROM retail_sales 
GROUP BY gender;
```

**5. Highest Average Sales Category:**

```sql
SELECT category, ROUND(AVG(total_sale)) AS avg_sales 
FROM retail_sales 
GROUP BY category 
ORDER BY avg_sales DESC 
LIMIT 1;
```

**6. Monthly Cumulative Sales:**

```sql
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS monthly_sale,
    SUM(SUM(total_sale)) OVER (PARTITION BY YEAR(sale_date) ORDER BY MONTH(sale_date)) AS running_total
FROM retail_sales 
GROUP BY YEAR(sale_date), MONTH(sale_date) 
ORDER BY year, month;
```

**7. Most Frequent Customer:**

```sql
SELECT customer_id, COUNT(transactions_id) AS purchase_count 
FROM retail_sales 
GROUP BY customer_id 
ORDER BY purchase_count DESC 
LIMIT 1;
```

**8. Average Profit Margin by Category:**

```sql
SELECT 
    category,
    ROUND(AVG(cogs)) AS avg_cogs,
    ROUND(AVG(total_sale)) AS avg_total_sale,
    ROUND(AVG(total_sale - cogs)) AS avg_profit_margin,
    RANK() OVER (ORDER BY AVG(total_sale - cogs) DESC) AS ranking
FROM retail_sales 
GROUP BY category;
```

**9. Most Popular Category by Gender:**

```sql
SELECT category, gender, SUM(total_sale) AS total_sales 
FROM retail_sales 
GROUP BY gender, category 
ORDER BY total_sales DESC 
LIMIT 1;
```

**10. Spending by Age Group:**

```sql
SELECT 
    CASE
        WHEN age < 25 THEN 'Below 25'
        WHEN age BETWEEN 25 AND 35 THEN '25-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Above 50'
    END AS age_group,
    ROUND(AVG(total_sale)) AS avg_spend
FROM retail_sales 
GROUP BY age_group;
```

**11. Weekend Transactions:**

```sql
WITH days AS (
    SELECT 
        transactions_id,
        CASE 
            WHEN DAYOFWEEK(sale_date) = 1 THEN 'Sunday'
            ELSE 'Saturday'
        END AS weekend
    FROM retail_sales 
    WHERE DAYOFWEEK(sale_date) IN (1,7)
)
SELECT weekend, COUNT(transactions_id) AS total_transactions 
FROM days 
GROUP BY weekend;
```

**12. Top Customer per Category:**

```sql
WITH category_sales AS ( 
    SELECT 
        category, 
        customer_id, 
        SUM(total_sale) AS total_purchase,
        RANK() OVER (PARTITION BY category ORDER BY SUM(total_sale) DESC) AS ranking 
    FROM retail_sales 
    GROUP BY category, customer_id
)
SELECT category, customer_id, total_purchase 
FROM category_sales 
WHERE ranking = 1;
```

**13. Peak Month for Orders:**

```sql
SELECT 
    YEAR(sale_date) AS year, 
    MONTH(sale_date) AS month, 
    COUNT(transactions_id) AS order_count
FROM retail_sales 
GROUP BY YEAR(sale_date), MONTH(sale_date) 
ORDER BY order_count DESC 
LIMIT 1;
```

**14. Sales on a Specific Date (`2022-11-05`):**

```sql
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
```

**15. Clothing Sales > 4 in Nov-2022:**

```sql
SELECT * 
FROM retail_sales 
WHERE sale_date BETWEEN '2022-11-01' AND '2022-11-30' 
  AND category = 'Clothing' 
  AND quantiy > 4;
```

**16. Total Sales by Category:**

```sql
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS transaction_count 
FROM retail_sales 
GROUP BY category;
```

**17. Average Age of Beauty Buyers:**

```sql
SELECT category, ROUND(AVG(age)) AS avg_age 
FROM retail_sales 
WHERE category = 'Beauty';
```

**18. High Value Transactions (>1000):**

```sql
SELECT * FROM retail_sales WHERE total_sale > 1000;
```

**19. Transactions by Gender per Category:**

```sql
SELECT 
    category, 
    gender, 
    COUNT(transactions_id) AS transaction_count 
FROM retail_sales 
GROUP BY gender, category 
ORDER BY category, gender;
```

**20. Best-Selling Month Per Year:**

```sql
WITH monthly_avg AS (
    SELECT 
        YEAR(sale_date) AS year, 
        MONTH(sale_date) AS month, 
        ROUND(AVG(total_sale)) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
    FROM retail_sales 
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year, month, avg_sale 
FROM monthly_avg 
WHERE ranking = 1;
```

**21. Top 5 Customers by Total Sales:**

```sql
SELECT customer_id, SUM(total_sale) AS total_sales 
FROM retail_sales 
GROUP BY customer_id 
ORDER BY total_sales DESC 
LIMIT 5;
```

**22. Unique Customers per Category:**

```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers 
FROM retail_sales 
GROUP BY category 
ORDER BY category;
```

**23. Order Count by Shift:**

```sql
WITH shifts_table AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(transactions_id) AS orders 
FROM shifts_table 
GROUP BY shift;
```

---

## 📈 Summary & Learnings

This project allowed me to:

- Practice real-world SQL queries for data cleaning and analysis  
- Explore sales trends across time, demographics, and product categories  
- Gain hands-on experience in business data analytics  

---

## 🤝 Let's Connect

📧 Have feedback, suggestions, or just want to connect? Reach out!

- **LinkedIn**: https://www.linkedin.com/in/sabariswaran-a-b4ab55329/ 
- **GitHub**: https://github.com/Sabari-787


---

