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

SELECT * FROM retail_sales
LIMIT 10

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

-- Data analysis & busniness key problems and answers:

-- Q.1 write an SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 write an SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of november 2022
SELECT 
  *
FROM retail_sales
WHERE category = 'Clothing'
     AND 
	 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	 AND
	 quantiy >= 4

-- Q.3 write an SQL query to calculate the total sales for each category:
SELECT 
  category,
  SUM(total_sale) as net_sale,
  COUNT(*) as total_orders
FROM retail_sales
GROUP BY category

-- Q.4 write an SQL query to find the average age of customers who purchaced items from 'Beauty' category.
SELECT 
   ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5 write an SQL query to find all transactions where total_sale is greater than 1000.
SELECT 
  *
FROM retail_sales
WHERE total_sale > 1000

--Q.6 write an SQL query to find the total number of transactions made by each gender in each category.
SELECT 
  category,
  gender,
  COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
category,
gender
ORDER BY category

-- Q.7 write an SQL query to calculate the average sale for each month , find out the best selling month in each year.
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

--Q.8 write an SQL query to find the top 5 customers based on the highest total sales.
SELECT 
      customer_id,
	  SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9 write an SQL query to find the number of unique customers who purchased items from each category.
SELECT 
      category,
	  COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category

--Q.10 write an SQL query to create each shift and number of orders, (ex morning <12, afternoon between 12&17, evening >17).
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