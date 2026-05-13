select * 
from `retail_sales.sales`

# exporatory analysis 

# check how many rows are there 
select count(*) as total_rows
from `retail_sales.sales`




# check the period of the data 

select min(sale_date) as start_date,
max(sale_date) as end_date
from `retail_sales.sales`

-- This data is for year 2022 and 2023

# check how many customers do we have

select count(distinct customer_id) as Total_customers
from `retail_sales.sales`

-- This data contains 155 customers



# check for different categories 

select distinct category
from `retail_sales.sales`

-- we have 3 categories Beauty clothing and electronics


# check for gender 
select distinct gender
from `retail_sales.sales` -- Male and Female



select * from `retail_sales.sales`


# data cleaning



# lest check for null values 

select *
from `retail_sales.sales`
where transactions_id is null or
sale_date is null or 
sale_time is null or 
customer_id is null or 
gender is null or
category is null or 
quantiy is null or 
price_per_unit is null or 
cogs is null or
total_sale is null





delete 
from `retail_sales.sales`
where 
transactions_id is null or
sale_date is null or 
sale_time is null or 
customer_id is null or 
gender is null or
category is null or 
quantiy is null or 
price_per_unit is null or 
cogs is null or
total_sale is null


# == 3 records deleted 

select count(*)
from `retail_sales.sales`


# business key problems

# write a query to retrieve all the columns for sales made on "2022-11-05"


select *
from `retail_sales.sales`
where sale_date = "2022-11-05"



# wriete a quety to retrieve all the transaction where the category is clothing and at leat 3 quantity sold for the month 2022-11

select *
from `retail_sales.sales`
where (lower(category) = "clothing") and (quantiy >= 3) and sale_date between "2022-11-01" and "2022-11-30"




# 3 find the Total sales for each category 

select
category,
sum(total_sale) as total_sale,
count(transactions_id) as total_orders
from `retail_sales.sales`
group by category

--- insight we got more order for clothing 
--- electronics category did more sales.



#4 find the average age of the customer who bought beauty products

select 
round(avg(age),0) as average_age
from `retail_sales.sales`
where lower(category) = "beauty"



# find the customers who purchase more requently top 5
select customer_id,
count(transactions_id) as total_orders
from `retail_sales.sales`
group by customer_id
order by total_orders desc
limit 5




# find the customers who purchase less requently bottom 5


select customer_id,
count(transactions_id) as total_orders
from `retail_sales.sales`
group by customer_id
order by total_orders 
limit 5


# find out the purchase each customer did bottom 5

select customer_id,

count(transactions_id) as total_orders,
sum(total_sale) as total_purchase
from `retail_sales.sales`
group by customer_id
order by total_purchase
limit 5



# find out the purchase each customer did top 5

select customer_id,
count(transactions_id) as total_orders,
sum(total_sale) as total_purchase
from `retail_sales.sales`
group by customer_id
order by total_purchase desc
limit 5




# find the transactions where the total sales is more than 1000

select *
from `retail_sales.sales`
where total_sale > 1000


# find out the total sale and number of orders made by each gender 
select gender,
count(transactions_id) as total_order,
 sum(total_sale) total_purchase
from `retail_sales.sales`
group by gender

--insight: female are purchasing more than male





# find transactions by each gender in each category

select category,
  gender,
  count(transactions_id) as total_transaction,
  sum(total_sale) as total_purchase
  from `retail_sales.sales`
  group by category,gender



# find the sales for each month each year and find the highest selling month for each year


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

--- for both year the sale was high in december 




# # find the AVG sales for each month each year and find the highest selling month for each year



select*,
first_value(month) over(partition by year order by Total desc)
from (select 
extract(year from sale_date) as year,
extract (month from sale_date) as month,
AVG(total_sale) as Total
from `retail_sales.sales`
group by extract(year from sale_date),extract (month from sale_date)
)

-- FOR YEAR 2022 AVG SALE WAS HIGH IN jULY(07TH MONTH)
-- FRO YEAR 2022 AVG SALE WAS HIGH IN FEB (2ND MONTH)

select
extract (year from sale_date) as year,
extract (month from sale_date) as month,
round(avg(total_sale),2) as average_sale,
from `retail_sales.sales`
group by extract (year from sale_date),extract (month from sale_date)




select*,
rank() over (partition by year order by average_sale desc) as rank_
from(select
extract (year from sale_date) as year,
extract (month from sale_date) as month,
round(avg(total_sale),2) as average_sale,
from `retail_sales.sales`
group by extract (year from sale_date),extract (month from sale_date))



select *
from(
select*,
rank() over (partition by year order by average_sale desc) as rank_
from (select
extract (year from sale_date) as year,
extract (month from sale_date) as month,
round(avg(total_sale),2) as average_sale,
from `retail_sales.sales`
group by extract (year from sale_date),extract (month from sale_date)))
where rank_ = 1



#  analyse the number of orders in different shifts like morning , afternoon and evening 
# say 06:00:00 to 12:00:00 morning
#12:00:00 to 18:00:00 afternoon and 18:00:00 to 23:00:00 evening

select max(sale_time),
min(sale_time)
from `retail_sales.sales`



-- 
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



-- insight we can say that more orders come in the evening 1062 , less orders in afternoon 377



----- End of Project



