
-- Sum of sales grouped by ProductLine

select Productline,sum(sales) as Total_Sales
from sales 
group by productline


-- Sum of sales grouped by Year

select Year_id,sum(sales) as Total_Sales
from sales 
group by YEAR_ID

-- -- Sum of sales grouped by DealSize

select DEALSIZE,sum(sales) as Total_Sales
from sales
group by DEALSIZE 



-- What was the best month for sales in a specifi year?Profit

select rank() over (order by sum(sales) desc) as Ranking,Month_id,sum(sales) as Revenue,count(ordernumber) as Frequency
from sales 
where YEAR_ID=2004
group by MONTH_ID 
order by 3 desc



-- What is the product most selled in November(rank 1 month)?
select Month_id,ProductLine,sum(sales) as Revenue,count(ordernumber) as Frequency
from sales 
where YEAR_ID=2004 and MONTH_ID=11
group by MONTH_ID,PRODUCTLINE 
order by 3 desc


-- who is the best customer 
select sum(sales)as Total_Sales,Customername
from sales
group by CUSTOMERNAME 
order by 1 desc
limit 1


-- What is the best product in USA?
select sum(sales) as Total_Sales,Productline
from sales 
where COUNTRY='USA'
group by PRODUCTLINE 
order by 1 desc 
limit 1


-- What city has the highest number of sales in a every country

with cte_1 as (
select distinct city as City,country 
from sales
order by 2 ),
cte_2 as (
select distinct city as City, sum(sales) as Revenue 
from sales 
group by city
)
select cte_1.City,cte_1.country,cte_2.Revenue,rank() over(partition by cte_1.country order by Revenue desc) as Ranking 
from cte_1 join cte_2 
on cte_1.City=cte_2.City



-- Top  customers with the highest total sales in every country 


with cte_1 as (
select distinct customername,sum(sales) as Total_Sales
from sales
group by customername),
cte_2 as (
select distinct customername,country
from sales
)
select cte_1.customername as Customer_Name,cte_1.Total_Sales,cte_2.country as Country,rank() over(partition by cte_2.country order by Total_Sales desc) as Ranking 
from cte_1 join cte_2 
on cte_1.customername=cte_2.customername
order by 3



-- Top  products with the highest total sales in every country


with cte_1 as (
select distinct productline,sum(sales) as Total_Sales
from sales
group by productline),
cte_2 as (
select distinct productline,country
from sales
)
select cte_1.productline as Product,cte_1.Total_Sales,cte_2.country as Country,rank() over(partition by cte_2.country order by Total_Sales desc) as Ranking 
from cte_1 join cte_2 
on cte_1.productline=cte_2.productline
order by 3;




