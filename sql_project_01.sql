-- create table
CREATE TABLE retail_sales
				(
					transactions_id	INT,
					sale_date DATE,
					sale_time TIME,
					customer_id	INT,
					gender VARCHAR(15),
					age INT,
					category VARCHAR(15),
					quantiy	INT,
					price_per_unit FLOAT,	
					cogs FLOAT,
					total_sale FLOAT

				);
-- i have imported data using pgadmin import/export option
     --------- Dats Cleaning---------
-- checking imported data
SELECT * FROM retail_Sales
limit 10

-- to check number of rows in dataset.
SELECT COUNT(*) FROM retail_sales

--- checking for null values--

SELECT * FROM retail_Sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
-- after getting null values i am deleting the entire rows 
-- of null values.

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
-- checking again for deletion of null values and rows count
SELECT COUNT(*) FROM retail_sales

SELECT * FROM retail_sales
WHERE
transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

	-- Data Exploration__
-- how many sales we have??
SELECT COUNT(*) as total_sale FROM retail_sales

--how many unique customer we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer
from retail_sales

--how many categories we have?
SELECT DISTINCT category 
FROM retail_sales

-- Data Analysis & Bussiness key problems and answer

-- write a query to find out total Revenue
SELECT SUM(total_Sale) AS total_revenue
FROM retail_sales

-- write a query to find out average order value
SELECT AVG(total_Sale) AS avg_order_val
FROM retail_sales

-- write a query to find out total quantity sold per category.
SELECT category, SUM(quantiy) AS total_quantities
FROM retail_sales
GROUP BY category

-- write a query to find out revenue per category .
SELECT category, SUM(total_sale) AS revenue
FROM retail_sales
group by category

-- write a query to find out which category has highest revenue.
SELECT category, SUM(total_sale) AS revenue
FROM retail_sales
GROUP BY category
ORDER by revenue DESC
LIMIT 1;

-- write a query to find out AVERAGE spending per categpry
SELECT category, AVG(total_sale) AS avg_spending
FROM retail_sales
GROUP BY category

-- write a query to retrieve all the columns for sales in decreasing order made on'2022-11-05'

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'
ORDER BY total_sale desc

-- write a query who has made highest purchase on date '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'
ORDER BY total_sale desc
limit 1;

--write a query to retrieve all transaction where the category is 'clothing' and the quantity sold is equal or more than 4 in the month of nov 2022.

SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	sale_date BETWEEN '2022-11-01' AND '2022-11-30'
	AND 
	quantiy >= 4
-- we can do this same using TO-CHAR
SELECT * FROM retail_sales
WHERE
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
	AND
	quantiy >= 4

-- write a query to calculate the total sales (total_sale) and total orders for each category,

SELECT 
	category,
	SUM(total_Sale) AS total_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category

-- write a query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Write a query to find all transations where the total_sale is greater than 1000.

SELECT * FROM retail_Sales
WHERE 
	total_sale > 1000

--write sql query to find total number of transactions(transactions_id) made by each gender in the each category
--select * from retail_Sales
SELECT
	 category,
	 gender,
	 COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY 1

--write a sql query to find the average sale for each month. find the best selling month in each year.

SELECT 
	year,
	month,
	avg_sale
FROM
	(
	
	SELECT
		EXTRACT(year FROM sale_date) AS year,
		EXTRACT(month FROM sale_Date) AS month,
		AVG(total_Sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(year FROM sale_date) ORDER BY AVG(total_Sale) DESC) AS rank
	FROM retail_sales
	GROUP BY 1,2
	ORDER BY 1,3
	) AS t1
WHERE rank = 1

-- Write a query to find the top 5 customers based on the highest total sale
SELECT 
	customer_id, SUM(total_Sale) AS highest_total_sale
from retail_sales
GROUP BY(customer_id)
ORDER BY highest_total_sale desc
LIMIT 5;

-- Write a sql query to find the number of unique customers who purchased items from each category.

SELECT
	category,
	COUNT(DISTINCT(customer_id)) AS unique_id 
	
FROM retail_Sales
GROUP BY category

-- write a sql query to find customer who purchased from multiple category.
SELECT
	customer_id,
	STRING_AGG(DISTINCT category, ',') AS categories
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) > 1

-- write a sql query to find the number of unique customers who purchased from all category.
SELECT 
	customer_id,
	STRING_AGG(DISTINCT category, ',') AS categories
FROM retail_sales
WHERE category IN('Clothing', 'Electronics', 'Beauty')
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 3;


-- write a sql query to create each shift and number of orders(ex-morning<=12, afternoon between 12 &17 , Evening >17)

WITH hourly_sales
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
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift

select * from retail_Sales

-- End of analysis--








