# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_proj_p2`

This project showcases essential SQL skills and methods commonly applied by data analysts to examine, clean, and interpret retail sales data. It includes creating a retail sales database, conducting exploratory data analysis (EDA), and using SQL queries to answer targeted business questions. 


## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_proj_p2`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
-- SQL RETAIL ANALYSIS - P1
CREATE DATABASE sql_proj_p2;

-- create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
               transactions_id	INT PRIMARY KEY,
               sale_date	DATE,
               sale_time	TIME,
               customer_id	INT,
               gender	VARCHAR(15),
               age	INT,
               category	VARCHAR(15),
               quantiy	INT,
               price_per_unit	FLOAT,
               cogs	FLOAT,
               total_sale FLOAT
             );


```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.

```sql

SELECT COUNT(*) FROM retail_sales

-- DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL


SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
      transactions_id IS NULL
	  or
	  sale_time IS NULL
	  or
	  sale_date IS NULL
	  or 
	  gender IS NULL
	  or
	  category IS NULL
	  or 
	  quantiy IS NULL
	  or
	  total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
      transactions_id IS NULL
	  or
	  sale_time IS NULL
	  or
	  sale_date IS NULL
	  or 
	  gender IS NULL
	  or
	  category IS NULL
	  or 
	  quantiy IS NULL
	  or
	  total_sale IS NULL;

-- DATA EXPLORATION

-- how many sales we have?
SELECT COUNT(*) AS total_sales 
FROM retail_sales

-- how many unique customers we have?
SELECT COUNT( DISTINCT customer_id) AS total_sales 
FROM retail_sales

-- how many unique categories?
SELECT COUNT( DISTINCT category)  
FROM retail_sales
```

### 3. Data Analysis & busniness key problems and answers


1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT 
  *
FROM retail_sales
WHERE total_sale > 1000

```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY
category,
gender
ORDER BY category

```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT * FROM 
( 
  SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1
--ORDER BY 1, 3 DESC
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
      category,
	  COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category

```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
( 
SELECT *,
     CASE
	 WHEN EXTRACT(HOUR FROM sale_time ) > 12 THEN 'Morning'
	 WHEN EXTRACT(HOUR FROM sale_time ) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening'
	 END as shift    
FROM retail_sales
)
SELECT 
      shift, 
	  COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift 

-- END OF PROJECT
```

## Reports

- **Sales Summary**: A detailed report summarizing total sales and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
