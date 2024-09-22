select * 
from pizzas;
-- Pizzas have pizza_id and pizza_type_id. Then they have the size and the price 
select *
from pizza_types;


-- Pizza types have  pizza_type_id, and category 

-- Comment I) We can join them on pizza_type_id 


select * 
from orders;

-- Orders have order_id,date (and time ) 


select * 
from order_details;


-- Order_Details have a unique order_details_id (not usefull ) have order_id, pizza_id, 
-- and the quantity of pizzas ordered.
-- Comment II) So we can join the four tables 

-- We want to find the total revenue. So we need to have all orders 


-- 1.Total Revenue 
select round(sum(quantity*price),0) as Total_Revenue
from order_details od left join pizzas p
on od.pizza_id=p.pizza_id;



-- 2. Average Order Value 

With Order_Cte as(
select order_id,sum(quantity*price) as Order_Value
from order_details od left join pizzas p
on od.pizza_id=p.pizza_id
group by od.order_id)
select round(avg(Order_Value),2) as Avg_Order_Value
from order_cte;


-- 3. Total Pizzas Sold 

select sum(quantity) as Total_Pizzas_Sold 
from order_details od left join pizzas p
on od.pizza_id=p.pizza_id; 


-- 4.Total Orders


select count(distinct order_id ) as Total_Orders
from order_details ;



-- 5. Average Pizzas Per Order
With Order_CTE as (
select sum(quantity) as Quantity_Order,order_id
from order_details od left join pizzas p
on od.pizza_id=p.pizza_id
group by order_id)
select round(avg(Quantity_Order),0) as Average_Pizzas_Per_Order
from Order_CTE;


-- 6. Sales by Category 

select sum(quantity) as Total_Sales,pt.category as Pizza_Category
from order_details od left join pizzas p 
on od.pizza_id=p.pizza_id
left join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id
GROUP BY PT.CATEGORY;


-- 7. Sales per Pizza Size 
select sum(quantity) as Total_Sales ,Size
from order_details od left join pizzas p 
on od.pizza_id=p.pizza_id
left join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id
group by size;

-- 8 Find the Percentages for Sales by Category 
With Pct_CTE as(
select sum(quantity) as Total_Sales,pt.category as Pizza_Category
from order_details od left join pizzas p 
on od.pizza_id=p.pizza_id
left join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id
GROUP BY PT.CATEGORY)
select Total_Sales/sum(Total_Sales)  over() as Pct_Sales,Pizza_Category
from Pct_CTE;


-- 9 Find the Percentages for Sales by Pizza Size

With Prt_CTE as (
select sum(quantity) as Total_Sales ,Size
from order_details od left join pizzas p 
on od.pizza_id=p.pizza_id
left join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id
group by size)
select Total_Sales/sum(Total_Sales) over() as Pct_Sales, Size
from Prt_Cte;


-- 10 Daily Order Trends by Day 


select count( distinct o.order_id) as Orders ,date_format(date,"%a") as Day
from order_details od  join orders  o
on od.order_id=o.order_id
group by date_format(date,"%a");



-- 11 Hourly Order Trends


select count( distinct o.order_id) as Orders ,time_format(time,"%H") as Hour
from order_details od  join orders  o
on od.order_id=o.order_id
group by time_format(time,"%H");


-- 12. Best  Sellers For Pizza Names

select sum(quantity) as Pizzas_Sold,pt.Name
from pizza_types pt left join pizzas p 
on pt.pizza_type_id=p.pizza_type_id
left join order_details od 
on p.pizza_id=od.pizza_id
group by pt.Name
order by Pizzas_Sold desc
limit 5;

-- 13.Worst Sellers For Pizza Names


select sum(quantity) as Pizzas_Sold,pt.Name
from pizza_types pt left join pizzas p 
on pt.pizza_type_id=p.pizza_type_id
left join order_details od 
on p.pizza_id=od.pizza_id
group by pt.Name
order by Pizzas_Sold 
limit 5;


-- ------------------------------------------------------------
--                         UPDATE PERCENTAGES                  |
-- ------------------------------------------------------------

-- Percentage of Total Revenue by Category

With Pct_CTE as(
select sum(quantity*price) as Total_Sales,pt.category as Pizza_Category
from order_details od left join pizzas p 
on od.pizza_id=p.pizza_id
left join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id
GROUP BY PT.CATEGORY)
select round(Total_Sales/sum(Total_Sales) over(),2) as Pct_Sales,Pizza_Category
from Pct_CTE;



-- Percentage Of Total Revenue by Size

With Prt_CTE as (
select sum(quantity*price) as Total_Sales ,Size
from order_details od left join pizzas p 
on od.pizza_id=p.pizza_id
left join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id
group by size)
select round(Total_Sales/sum(Total_Sales) over(),2) as Pct_Sales, Size
from Prt_Cte;
