# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is a hands-on demonstration of how SQL can be used to analyze retail sales data. It simulates a real-world workflow—from setting up a database to answering key business questions using structured queries. If you're just stepping into the world of data, this is a great place to start building practical SQL experience.

## Objectives

1. **Create and populate a retail database** from raw sales data.
2. **Clean the dataset** by handling null or missing values.
3. **Explore the data** using basic SQL to understand patterns.
4. **Answer business-driven questions** to derive insights.

---

## Project Structure

### 1. Database Setup

We begin by creating the database and defining the schema for the `retail_sales` table.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
