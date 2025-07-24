-- SQL Retail Sales Analysis: Project 1
CREATE DATABASE sql_project_1;

-- Create Table
CREATE TABLE retail_sales
			(
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

SELECT *
FROM retail_sales
LIMIT 10;


SELECT COUNT(*)
FROM retail_sales;


-- Data Cleaning
SELECT *
FROM retail_sales
WHERE transactionS_id IS NULL;

SELECT *
FROM retail_sales
WHERE sale_date IS NULL;

SELECT *
FROM retail_sales
WHERE sale_time IS NULL;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	category IS NULL
	OR
	gender IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	category IS NULL
	OR
	gender IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration:

-- How many sales do we have?
SELECT COUNT(*) AS total_sale
FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM retail_sales;


-- Data Analysis and KPI Problem & Answers:

-- 1. All columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. All 'Clothing' sales where quantity >= 4 in Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4;

-- 3. What are the total sales in each category?
SELECT category, SUM(total_sale) AS net_sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- 4. What's the average age of customers who purchased items in 'Beauty' category?
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Transactions where the total sale is greater than $1,000?
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. How many transactions were made by each gender, in each category?
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender

-- 7. What is the average sale for each month? What's the best selling month in each year?
SELECT year, month, avg_sale
FROM
(
SELECT EXTRACT(YEAR FROM sale_date) AS year, EXTRACT(MONTH FROM sale_date) AS month, AVG(total_sale) AS avg_sale, RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE rank = 1;

-- 8. What are the top 5 customers based on total sales?
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY total_sale DESC
LIMIT 5;

-- 9. What's the number of unique customers who purchased items from category?
SELECT COUNT(DISTINCT(customer_id)), category
FROM retail_sales
GROUP BY category;

-- 10. Create table with each shift and number of orders.
WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- End of project.





	
	
	