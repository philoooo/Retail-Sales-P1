# SQL PROJECT: Retail Sales Analysis

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `sql_project_1`

his project showcases the core SQL skills that data analysts use to work with real-world datasets. I created and managed a retail sales database, cleaned the data, and ran SQL queries to explore trends and answer key business questions. It’s a hands-on way to build a strong foundation in SQL and better understand how data drives decision-making in a retail setting.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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

```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Sales Count**: Identify the total amount of sales in the dataset.

```sql
SELECT COUNT(*)
FROM retail_sales;
```

```sql
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
```

```sql
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
 ```

```sql
-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM retail_sales;
 ```

```sql
-- How many sales do we have?
SELECT COUNT(*) AS total_sale
FROM retail_sales;
 ```


### 3. Data Analysis & KPI Findings:

The following SQL queries were developed to answer specific business questions:

1. **All columns for sales made on '2022-11-05'**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **All 'Clothing' sales where quantity greater than or equal to 4 in Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4;
```

3. **What are the total sales in each category?**:
```sql
SELECT category, SUM(total_sale) AS net_sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

4. **What's the average age of customers who purchased items in 'Beauty' category?**:
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

5. **Transactions where the total sale is greater than $1,000?**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **How many transactions were made by each gender, in each category?**:
```sql
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
```

7. **What is the average sale for each month? What's the best selling month in each year?**:
```sql
SELECT year, month, avg_sale
FROM
(
SELECT EXTRACT(YEAR FROM sale_date) AS year, EXTRACT(MONTH FROM sale_date) AS month, AVG(total_sale) AS avg_sale, RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

8. **What are the top 5 customers based on total sales?**:
```sql
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY total_sale DESC
LIMIT 5;
```

9. **What's the number of unique customers who purchased items from each category?**:
```sql
SELECT COUNT(DISTINCT(customer_id)), category
FROM retail_sales
GROUP BY category;
```

10. **Display time of day and number of orders.(Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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

```

## Findings

- **Customer Demographics**: Customers span a wide age range, and purchases are spread across product types like Clothing, Electronics and Beauty.
- **Big Spenders**: Some transactions were over $1,000, which likely reflect high-end or bulk purchases.
- **Sales Patterns**: Monthly sales data shows fluctuations, helping pinpoint peak shopping seasons.
- **Customer Behavior**: The data highlights top-spending customers and shows which product categories are most popular.

## Reports

- **Sales Overview**: A summary of total sales, customer profiles, and how each product category performs.
- **Trend Analysis**: Monthly breakdowns that reveal sales trends and the busiest times of day.
- **Customer Insights**: Lists of top buyers and category-level customer counts to better understand customer engagement.

## Conclusion

This project was a great introduction to SQL for data analysis. I built and cleaned a retail sales database, explored the data with SQL, and answered business-related questions. The insights gained customer preferences, high-value purchases, and sales seasonality, which could help inform smarter business decisions in the real world.

