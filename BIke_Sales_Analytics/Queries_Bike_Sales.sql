-- Total Revenue by Years 2016-2017-2018

-- Year 2016
-- This query is our base without any calculations

select oi.order_id,oi.list_price,oi.quantity,oi.discount,o.order_Date,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2016;

-- Now we calculate Price*Quantity as Revenue before Discount, Amount_Discount
select oi.order_id,(oi.list_price*oi.quantity)as Revenue_BD,(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,o.order_Date,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2016;

-- Next step is to find the total Revenue for each item before discount and the total discount grouped by order_id
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2016
group by order_id;


-- Substract to find net revenue This is the one we want to see for every order
With Year16_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2016
group by order_id)
select Revenue_BD,Amount_Discount,(Revenue_BD-Amount_Discount) as Net_Revenue,Full_Name
from year16_cte;


-- ---------------------------------------------------------
--                    NET REVENUE(YEARS/TOTAL)              |
-- ---------------------------------------------------------



--  Total_Net_Revenue for 2016 


With Year16_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2016
group by order_id)
select sum(Revenue_BD-Amount_Discount) as Total_Net_Revenue_2016
from year16_cte;

-- Do this for 2017 and 2018 respectively 
--  Total_Net_Revenue for 2017 
With Year17_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2017
group by order_id)
select sum(Revenue_BD-Amount_Discount) as Total_Net_Revenue_2017
from year17_cte;


--  Total_Net_Revenue for 2018 
With Year18_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2018
group by order_id)
select sum(Revenue_BD-Amount_Discount) as Total_Net_Revenue_2018
from year18_cte;


-- Total_NET_Revenue for all years:
With Total_NET_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
group by order_id)
select sum(Revenue_BD-Amount_Discount) as Total_Net_Revenue
from Total_NET_CTE;




-- ---------------------------------------------------------
--                    NOT NET REVENUE(YEARS/TOTAL)          |
-- ---------------------------------------------------------


-- To find the Total_Revenue (not NET)for all years we do something very similar


--  Total_Revenue  
With Total_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
group by order_id)
select sum(Revenue_BD) as Total_Revenue
from total_cte;



-- 2016 Total_Revenue

With Year16_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2016
group by order_id)
select sum(Revenue_BD) as Total_Revenue_2016
from year16_cte;


-- 2017 Total_Revenue


With Year17_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2017
group by order_id)
select sum(Revenue_BD) as Total_Revenue_2017
from year17_cte;


-- 2018 Total_Revenue



With Year18_CTE as (
select oi.order_id ,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2018
group by order_id)
select sum(Revenue_BD) as Total_Revenue_2018
from year18_cte;




-- -----------------------------------------------
--            TOTAL UNITS SOLD(YEAR/TOTAL)        |
-- -----------------------------------------------


-- 2016

select sum(oi.quantity) as Units_Sold_2016
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_Date)=2016;



-- 2017
select sum(oi.quantity) as Units_Sold_2017
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_Date)=2017;


-- 2018 
select sum(oi.quantity) as Units_Sold_2018
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_Date)=2018;



-- Total 
select sum(oi.quantity) as Units_Sold
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id;




-- -----------------------------------------------
--            TOTAL ORDERS(YEAR/TOTAL)           |
-- -----------------------------------------------




-- 2016
select count(*) as Orders_2016
from orders
where year(order_date)=2016;

-- 2017
select count(*) as Orders_2017
from orders
where year(order_date)=2017;


-- 2018
select count(*) as Orders_2018
from orders
where year(order_date)=2018;

-- Total
select count(*)
from orders;



-- -----------------------------------------------
--            TOTAL CUSTOMERS(YEAR/TOTAL)         |
-- -----------------------------------------------


-- Total Unique Customers
select count(*) as Total_Customers
from customers ;

-- 2016 
select count(distinct o.customer_id) as Customers_2016
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2016;


-- 2017
select count( distinct o.customer_id) as Customers_2017
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2017;




-- 2018
select count(distinct o.customer_id) as Customers_2018
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(o.order_date)=2018;










-- -------------------------------------------------
-- 			NET REVENUE BY MONTH OF YEAR			|
-- -------------------------------------------------

-- 2016 
With Total_CTE as(
select oi.order_id , substring_index(substring(date_format(order_date,"%Y,%M,%d"),6),",",1)as Month_2016,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2016
group by order_id,Month_2016)
select Month_2016,sum(Revenue_BD)-sum(Amount_Discount) as Net_Revenue_2016
from Total_CTE
group by Month_2016;




-- 2017
With Total_CTE as(
select oi.order_id , substring_index(substring(date_format(order_date,"%Y,%M,%d"),6),",",1)as Month_2017,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2017
group by order_id,Month_2017)
select Month_2017,sum(Revenue_BD)-sum(Amount_Discount) as Net_Revenue_2017
from Total_CTE
group by Month_2017;






-- 2018
With Total_CTE as(
select oi.order_id , substring_index(substring(date_format(order_date,"%Y,%M,%d"),6),",",1)as Month_2018,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2018
group by order_id,Month_2018)
select Month_2018,sum(Revenue_BD)-sum(Amount_Discount) as Net_Revenue_2018
from Total_CTE
group by Month_2018;





-- -------------------------------------------------
-- 			  REVENUE BY MONTH OF YEAR			   |
-- -------------------------------------------------


-- 2016 
With Total_CTE as(
select oi.order_id , substring_index(substring(date_format(order_date,"%Y,%M,%d"),6),",",1)as Month_2016,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2016
group by order_id,Month_2016)
select Month_2016,sum(Revenue_BD) as Revenue_2016
from Total_CTE
group by Month_2016;


-- 2017 
With Total_CTE as(
select oi.order_id , substring_index(substring(date_format(order_date,"%Y,%M,%d"),6),",",1)as Month_2017,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2017
group by order_id,Month_2017)
select Month_2017,sum(Revenue_BD) as Revenue_2017
from Total_CTE
group by Month_2017;




-- 2018 
With Total_CTE as(
select oi.order_id , substring_index(substring(date_format(order_date,"%Y,%M,%d"),6),",",1)as Month_2018,sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2018
group by order_id,Month_2018)
select Month_2018,sum(Revenue_BD) as Revenue_2018
from Total_CTE
group by Month_2018;






-- -----------------------------------------------------------------
-- 	           TOP CUSTOMERS (YEAR/ALL TIME) BY REVENUE		       |
-- -----------------------------------------------------------------

-- All Time
select sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
group by Full_name
order by revenue_bd desc
limit 10;


-- 2016
select sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2016
group by Full_name
order by revenue_bd desc
limit 10;



-- 2017
select sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2017
group by Full_name
order by revenue_bd desc
limit 10;



-- 2018
select sum(oi.list_price*oi.quantity)as Revenue_BD,sum(oi.quantity*oi.discount*oi.list_price) as Amount_Discount,concat(c.first_name," ",c.last_name) as Full_Name
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2018
group by Full_name
order by revenue_bd desc
limit 10;



-- -----------------------------------------------------------------
-- 	           TOP SALES REP (YEAR/ALL TIME) BY REVENUE		       |
-- -----------------------------------------------------------------
-- All time
select sum(oi.list_price*oi.quantity)as Revenue,concat(s.first_name," ",s.last_name) as Sales_Rep
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
left join staffs s
on s.staff_id=o.staff_id
group by Sales_Rep
order by Revenue desc;


-- 2016
select sum(oi.list_price*oi.quantity)as Revenue,concat(s.first_name," ",s.last_name) as Sales_Rep
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
left join staffs s
on s.staff_id=o.staff_id
where year(o.order_date)=2016
group by Sales_Rep
order by Revenue desc;




-- 2017
select sum(oi.list_price*oi.quantity)as Revenue,concat(s.first_name," ",s.last_name) as Sales_Rep
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
left join staffs s
on s.staff_id=o.staff_id
where year(o.order_date)=2017
group by Sales_Rep
order by Revenue desc;



-- 2018
select sum(oi.list_price*oi.quantity)as Revenue,concat(s.first_name," ",s.last_name) as Sales_Rep
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
left join staffs s
on s.staff_id=o.staff_id
where year(o.order_date)=2018
group by Sales_Rep
order by Revenue desc;

-- -----------------------------------------------------------------
-- 	           CUSTOMERS BY STATE                     		       |
-- -----------------------------------------------------------------



select State, count(*) as Customers_Count
from customers
group by state;
-- -----------------------------------------------------------------
-- 	                   REVENUE BY STORE                     	   |
-- -----------------------------------------------------------------



select Store_Name,sum(quantity*list_price) as Revenue
from orders o left join stores s
on o.store_id=s.store_id
left join order_items od 
on o.order_id=od.order_id
group by s.store_name;


-- 2016

select Store_Name,sum(quantity*list_price) as Revenue_2016
from orders o left join stores s
on o.store_id=s.store_id
left join order_items od 
on o.order_id=od.order_id
where year(order_date)=2016
group by s.store_name;

-- 2017 

select Store_Name,sum(quantity*list_price) as Revenue_2017
from orders o left join stores s
on o.store_id=s.store_id
left join order_items od 
on o.order_id=od.order_id
where year(order_date)=2017
group by s.store_name;

-- Revenue Store 2018
select Store_Name,sum(quantity*list_price) as Revenue_2018
from orders o left join stores s
on o.store_id=s.store_id
left join order_items od 
on o.order_id=od.order_id
where year(order_date)=2018
group by s.store_name;




-- We do some queries from production database

-- In stocks we have store_id,product_id, quantity (how many are in a cetrain stock)
-- In products we have product_id,list_price,category_id,brand_id

-- -----------------------------------------------------------------
-- 	                 TOTAL VALUE OF CATEGORIES IN STOCK             |
-- -----------------------------------------------------------------
With Production_CTE as (
select p.product_id,p.product_name,b.brand_name,c.category_name,p.list_price,s.quantity
from products p left join brands b
on p.brand_id=b.brand_id
left join categories c
on c.category_id=p.category_id
join stocks s 
on s.product_id=p.product_id)
select Category_name,sum(quantity)as Quantity_In_Stock,sum(quantity*list_price)as Total_Value
from Production_CTE
group by Category_Name
order by Total_Value desc;


-- -----------------------------------------------------------------
-- 	                 TOTAL ITEMS PER BRAND NAME                    |
-- -----------------------------------------------------------------

with p_cte as(
select p.product_id,p.product_name,b.brand_name,c.category_name,p.list_price
from products p left join brands b
on p.brand_id=b.brand_id
left join categories c
on c.category_id=p.category_id
)
select count(*) as Frequency,Brand_Name
from p_cte
group by Brand_Name;





select year(order_Date) as Year,sum(oi.list_price*oi.quantity)as Revenue_BD
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2016
group by year(order_date)
union
select year(order_Date) as Year,sum(oi.list_price*oi.quantity)as Revenue_BD
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2017
group by year(order_date)
union 
select year(order_Date) as Year,sum(oi.list_price*oi.quantity)as Revenue_BD
from order_items oi left join orders o
on oi.order_id=o.order_id
left join customers c 
on o.customer_id=c.customer_id
where year(order_date)=2018
group by year(order_date)