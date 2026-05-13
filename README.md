# SQL-Data-Analysis-Project 1
Personal portfolio showcasing my projects, skills, and learning journey in data analytics.

# Project Title: Retail Sales Analysis
# Level: Beginner
This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.


# Objectives : 
1.Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
2.Data Cleaning: Identify and remove any records with missing or null values.
3.Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
4. Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.


# Database Creation: The project starts by creating a dataset named retail_sales in bigquery.
# Table Creation: A table named _sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.




# 2. Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset. 2000 records
Customer Count: Find out how many unique customers are in the dataset. 155 unique customers
Category Count: Identify all unique product categories in the dataset. 3 categories ("clothing, beauty and electronic)
Null Value Check: Check for any null values in the dataset and delete records with missing data. 3 rows deleted with null values


```
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

Data analysis
following queries were written to analyse the business problem


# 1 write a query to retrieve all the columns for sales made on "2022-11-05"

```
select *
from `retail_sales.sales`
where sale_date = "2022-11-05"

```


 # 2 write a quety to retrieve all the transaction where the category is clothing and at leat 3 quantity sold for the month 2022-11
```
select *
from `retail_sales.sales`
where (lower(category) = "clothing") and (quantiy >= 3) and sale_date between "2022-11-01" and "2022-11-30"

```


# 3 find the Total sales  and total orders for each category 
```
select
category,
sum(total_sale) as total_sale,
count(transactions_id) as total_orders
from `retail_sales.sales`
group by category
```
--- insight we got more order for clothing 
--- electronics category did more sales.



# 4 find the average age of the customer who bought beauty products
```
select 
round(avg(age),0) as average_age
from `retail_sales.sales`
where lower(category) = "beauty"
```



# 5 find the customers who purchase more requently top 5
```
select customer_id,
count(transactions_id) as total_orders
from `retail_sales.sales`
group by customer_id
order by total_orders desc
limit 5
```


# 6 find the customers who purchase less requently bottom 5

```
select customer_id,
count(transactions_id) as total_orders
from `retail_sales.sales`
group by customer_id
order by total_orders 
limit 5

```




# 7 find out the purchase each customer did top 5
```
select customer_id,
count(transactions_id) as total_orders,
sum(total_sale) as total_purchase
from `retail_sales.sales`
group by customer_id
order by total_purchase desc
limit 5
```

# 8 find the transactions where the total sales is more than 1000
```
select *
from `retail_sales.sales`
where total_sale > 1000

```


# 9 find out the total sale and number of orders made by each gender 
```
select gender,
count(transactions_id) as total_order,
 sum(total_sale) total_purchase
from `retail_sales.sales`
group by gender
```
--insight: female are purchasing more than male



# 10 find transactions by each gender in each category
```
select category,
  gender,
  count(transactions_id) as total_transaction,
  sum(total_sale) as total_purchase
  from `retail_sales.sales`
  group by category,gender

```


# 11 find the sales for each month each year and find the highest selling month for each year

```
select 
extract(year from sale_date) as year,
extract (month from sale_date) as month,
sum(total_sale) as Total
from `retail_sales.sales`
group by extract(year from sale_date),extract (month from sale_date)
order by year,month


select*,
first_value(month) over(partition by year order by Total desc)
from (select 
extract(year from sale_date) as year,
extract (month from sale_date) as month,
sum(total_sale) as Total
from `retail_sales.sales`
group by extract(year from sale_date),extract (month from sale_date)

)
```
--- insight : for both year the sale was high in december 


# # find the AVG sales for each month each year and find the highest selling month for each year

```

select*,
first_value(month) over(partition by year order by Total desc)
from (select 
extract(year from sale_date) as year,
extract (month from sale_date) as month,
AVG(total_sale) as Total
from `retail_sales.sales`
group by extract(year from sale_date),extract (month from sale_date)
)
```

-- FOR YEAR 2022 AVG SALE WAS HIGH IN jULY(07TH MONTH)
-- FRO YEAR 2022 AVG SALE WAS HIGH IN FEB (2ND MONTH)





#  analyse the number of orders in different shifts like morning , afternoon and evening 
# say 06:00:00 to 12:00:00 morning
# 12:00:00 to 18:00:00 afternoon and 18:00:00 to 23:00:00 evening

select max(sale_time),
min(sale_time)
from `retail_sales.sales`



```
with shift_table 
as
(select *,
case 
when sale_time >= "06:00:00" and sale_time < "12:00:00" then "morning"
when sale_time >= "12:00:00" and sale_time < "18:00:00" then "afternoon"
when sale_time >= "18:00:00" and sale_time < "23:59:00" then "evening"
end as shift
from `retail_sales.sales`
)


select shift,
count(transactions_id) as total_orders
from shift_table
group by shift

```

-- insight we can say that more orders come in the evening 1062 , less orders in afternoon 377




# Findings
-- This data contains customers with different age group min 18 and max 64. Sales is distributed across different categories.
female are purchasing more beauty products than male
sales trend : monthly analysis shows variation in sales, helping identify peak seasons (december) 
Customer Insights: The analysis identifies the top-spending customers and the most popular product categories.

# Reports

Sales Summary: A detailed report summarizing total sales, customer demographics, and category performance.
Trend Analysis: Insights into sales trends across different months and shifts.
Customer Insights: Reports on top customers and unique customer counts per category.


# conclusion 
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.



