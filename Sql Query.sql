-- Create and use the database 
CREATE DATABASE sql_project_p1;
USE sql_project_p1;

-- Create table 
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

-- Preview table
SELECT * FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning
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

-- Data Exploration

-- 1. How many Sales do we have?
SELECT COUNT(total_sale) AS total_sales FROM retail_sales;

-- 2. How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS customers FROM retail_sales;

-- 3. How many unique categories do we have?
SELECT COUNT(DISTINCT category) AS category_count FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis and Business Problems

-- 4. What is the total revenue (total_sale) generated per gender?
SELECT gender, SUM(total_sale) AS total_revenue 
FROM retail_sales 
GROUP BY gender;

-- 5. Which product category had the highest average sales per transaction?
SELECT category, ROUND(AVG(total_sale)) AS avg_sales 
FROM retail_sales 
GROUP BY category 
ORDER BY avg_sales DESC 
LIMIT 1;

-- 6. Calculate the cumulative total sale per month (running total) for each year.
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS monthly_sale,
    SUM(SUM(total_sale)) OVER (PARTITION BY YEAR(sale_date) ORDER BY MONTH(sale_date)) AS running_total
FROM retail_sales 
GROUP BY YEAR(sale_date), MONTH(sale_date) 
ORDER BY year, month;

-- 7. Which customer has made the most number of purchases (count of transactions)?
SELECT customer_id, COUNT(transactions_id) AS purchase_count 
FROM retail_sales 
GROUP BY customer_id 
ORDER BY purchase_count DESC 
LIMIT 1;

-- 8. Find the average COGS and total sale per category and rank them based on average profit margin (total_sale - cogs).
SELECT 
    category,
    ROUND(AVG(cogs)) AS avg_cogs,
    ROUND(AVG(total_sale)) AS avg_total_sale,
    ROUND(AVG(total_sale - cogs)) AS avg_profit_margin,
    RANK() OVER (ORDER BY AVG(total_sale - cogs) DESC) AS ranking
FROM retail_sales 
GROUP BY category;

-- 9. Identify the most popular category by gender (most purchases per category by gender).
SELECT category, gender, SUM(total_sale) AS total_sales 
FROM retail_sales 
GROUP BY gender, category 
ORDER BY total_sales DESC 
LIMIT 1;

-- 10. Which age group spends the most on average?
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

-- 11. List transactions that occurred on weekends.
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

-- 12. For each category, find the customer with the highest total purchase amount.
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

-- 13. Calculate the monthly order count trend. Which month had the most orders overall?
SELECT 
    YEAR(sale_date) AS year, 
    MONTH(sale_date) AS month, 
    COUNT(transactions_id) AS order_count
FROM retail_sales 
GROUP BY YEAR(sale_date), MONTH(sale_date) 
ORDER BY order_count DESC 
LIMIT 1;

-- 14. Retrieve all columns for sales made on '2022-11-05'.
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- 15. Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in November 2022.
SELECT * 
FROM retail_sales 
WHERE sale_date BETWEEN '2022-11-01' AND '2022-11-30' 
  AND category = 'Clothing' 
  AND quantiy > 4;

-- 16. Calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS transaction_count 
FROM retail_sales 
GROUP BY category;

-- 17. Find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, ROUND(AVG(age)) AS avg_age 
FROM retail_sales 
WHERE category = 'Beauty';

-- 18. Find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales WHERE total_sale > 1000;

-- 19. Find the total number of transactions made by each gender in each category.
SELECT 
    category, 
    gender, 
    COUNT(transactions_id) AS transaction_count 
FROM retail_sales 
GROUP BY gender, category 
ORDER BY category, gender;

-- 20. Calculate the average sale for each month and find the best-selling month in each year.
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

-- 21. Find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) AS total_sales 
FROM retail_sales 
GROUP BY customer_id 
ORDER BY total_sales DESC 
LIMIT 5;

-- 22. Find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers 
FROM retail_sales 
GROUP BY category 
ORDER BY category;

-- 23. Create shifts (Morning <12, Afternoon 12–17, Evening >17) and find the number of orders in each shift.
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
