-- Customers table only contains info about the customers 
select * from customers limit 10; 
-- Orders tablre containts order_id,customer_id, order and delivered date
select * from orders limit 10;
-- Products table contains product id,name and price 
select * from products  limit 10;
-- Order details table contains order_id,product_id,quantity
select * from order_details  limit 10;




-- List the 10 most expensive products for sale and their prices 

select * from products p 
order by price desc
limit 10;


-- Which states have more than 5 customers? 
-- Use the state column on the customer table. 
-- Count each customer on the table regardless of whether they have ever bought anything.

select state,count(*) as `count`
from customers 
group by state
having count(*)>5
order by 2 desc


-- Get the 27 customers that have made the largest number of orders. 
-- Include the name, address, state, and number of orders ,made
 


select name,address,state,count(*) as num_orders
from customers c left join orders o on 
c.user_id=o.customer_id 
group by name,address,state
order by 4 desc 
limit 17;




-- Get all orders by customer 1026.
-- Include the amount spent in each order, the order id
-- and the total number of distinct products purchased.


select distinct o.order_id,sum(p.price*od.quantity) as spent, count(product_name)  as num_distinct_products
from orders o left join order_details od 
on o.order_id =od.order_id 
left join products p 
on od.product_id = p.product_id
where customer_id=1026
group by o.order_id 




-- Get the 10 customers that have spent the most. Give the customer_id and amount spent

select  o.customer_id ,sum(p.price*od.quantity) as total_spent
from orders o left join order_details od 
on o.order_id=od.order_id 
left join products p 
on od.product_id =p.product_id 
group by o.customer_id 
order by 2 desc
limit 10 ;


-- Repeat the previous question,but include the customer's name, address
-- and state in addition to the customer id and total amount spent


with cte_1 as (
select  o.customer_id ,sum(p.price*od.quantity) as total_spent
from orders o left join order_details od 
on o.order_id=od.order_id 
left join products p 
on od.product_id =p.product_id 
group by o.customer_id 
order by 2 desc
limit 10)
select cte_1.customer_id,c.name,c.address,c.state,cte_1.total_spent 
from cte_1 left join customers c 
on cte_1.customer_id=c.user_id;


-- Find the 10 customers that spent the most in 2017. 
-- Give the name and amount spent. Take the date to be the order date 
-- (not the delivery date)

select o.customer_id ,c.name, sum(od.quantity*p.price) as amt_spent
from orders o left join order_details od
on o.order_id =od.order_id 
left join products p 
on od.product_id=p.product_id 
left join customers c 
on o.customer_id =c.user_id 
where year(order_date)=2017 
group by o.customer_id,c.name
order by 3 desc 
limit 10;


-- Which 3 products have we sold the most?
select od.product_id,sum(od.quantity) as num_sold
from order_details od left join products p 
on od.product_id =p.product_id 
group by od.product_id 
order by 2 desc 
limit 3;



-- Previous querie but with product name 
select od.product_id,p.product_name ,sum(od.quantity) as num_sold
from order_details od left join products p 
on od.product_id =p.product_id 
group by od.product_id ,p.product_name 
order by 3 desc 
limit 3;




-- What is the average number of days between order and delivery
select avg(datediff(deliver_date,order_date)) as Avg_days_between_order_delivery
from orders


-- Previous query but now with hours,minutes,seconds

select 
concat(concat(floor(avg(datediff(deliver_date,order_date)))," days")," ",
time_format(sec_to_time(floor((avg(datediff(deliver_date,order_date)) - floor(avg(datediff(deliver_date,order_date)))) * 24 * 3600)), '%H: %i: %s'))
as avg_delivery_time
from orders 



-- What is thre average number of days between order and delivery date	
-- for each year
-- Take the year from the order date 

select year(order_date) as order_year,
concat(concat(floor(avg(datediff(deliver_date,order_date)))," days")," ",
time_format(sec_to_time(floor((avg(datediff(deliver_date,order_date)) - floor(avg(datediff(deliver_date,order_date)))) * 24 * 3600)), '%H: %i: %s'))
as avg_delivery_time
from orders 
group by 1 





