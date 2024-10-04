-- ------------------------------
-- |    Tables explorations     | 
-- ------------------------------

-- Bike table has 10 entries

select count(*)
from bike;

select * 
from bike 
limit 5;


-- Customer table has 10 entries
select count(*)
from customer;

select * 
from customer  
limit 5;


-- Membership table has 12 entries

select count(*)
from membership;


select *
from membership 
limit 5;

-- Membershiptype table has 3 entries

select count(*)
from membership_type ;

select * 
from membership_type;



-- Rental table has 32 entries

select count(*)
from rental 

select * 
from rental 
limit 5






-- ------------------------------
-- |    EDA Questions           | 
-- ------------------------------



-- Question 1
-- How many bikes the shop owns by category,show categories where number>2 


select Category,count(*) as Number_Of_Bikes 
from bike
group by category
having Number_Of_Bikes>2;


-- Question 2
-- Customer names with the total number memberships purchased by each 
-- Show all names of customers, 0 to those who didnt purchace
select Name,
case when count(m.customer_id)>0 then count(m.customer_id)
else 0
end as Membership_Count
from membership m right join customer c 
on m.customer_id=c.id
group by name 
order by 2 desc ;



-- Question 3
-- New rental prices:
-- Electric bikes should have a 10% discount for hourly rentals and a 20%
-- discount for daily rentals. Mountain bikes should have a 20% discount for
-- hourly rentals and a 50% discount for daily rentals. All other bikes should
-- have a 50% discount for all types of rentals

select r.bike_id,b.category ,price_per_hour as Old_Price_Per_Hour,
case when category='electric' then price_per_hour*0.9
when category='mountain bike' then price_per_hour*0.8
else price_per_hour*0.5 end as New_Price_Per_Hour,
price_per_day  as Old_Price_Per_Day,
case when category='electric' then price_per_day*0.8
when category='mountain bike' then price_per_day*0.5
else price_per_day*0.5 end as New_Price_Per_Day
from rental r join bike b 
on r.bike_id =b.id
group by r.bike_id,b.category ; 




-- Question 4
-- counts of the rented bikes and of the available bikes in each category.
with cte as (select distinct category from bike),
cte_1 as (
select count(*) as Available_Bikes_Count, Category 
from bike
where status='available'
group by category 
),
cte_2 as (
select count(*) as Rented_Bikes_Count,Category 
from bike
where status='rented' 
group by category 
)
select cte.Category,
case 
when Available_Bikes_Count is null then 0
else Available_Bikes_Count end as Available_Bikes_Count,
case when Rented_Bikes_Count is null  then 0
else Rented_Bikes_Count end as Rented_Bikes_Count
from cte left join cte_1
on cte.category=cte_1.category
left join cte_2 
on cte.category=cte_2.category
order by cte.category;



-- Question 5
-- Total Revenue from rentals by month,year,all time

select year(start_timestamp)as year,
month(start_timestamp) as month,sum(total_paid) as revenue 
from rental
where year(start_timestamp)=2022
group by year(start_timestamp) ,month(start_timestamp)
union all 
select year(start_timestamp) as year,
null as month, sum(total_paid) as revenue
from rental 
where year(start_timestamp)=2022
group by year(start_timestamp)
union all 
select year(start_timestamp) as year, month(start_timestamp) as month,
sum(total_paid) as revenue 
from rental 
where year(start_timestamp)=2023
group by year(start_timestamp),month(start_timestamp)
union all 
select year(start_timestamp) as year, null as month,
sum(total_paid) as revenue 
from rental 
where year(start_timestamp)=2023
group by year(start_timestamp)
union all 
select null as year,null as month, sum(total_paid) as revenue
from rental ;



-- Question 6
-- Display year,month, name of membership type,total revenue
select year(start_date) as `Year`,month(start_date) as `Month`,
name as Membership_Type_Name,sum(total_paid) as Total_Revenue 
from membership m join membership_type mt 
on m.membership_type_id =mt.id 
group by name,month(start_date),year(start_date)
order by `Month`;


 



-- Question 7 
-- Now with totals and subtotals
select year(start_date) as `Year`,month(start_date) as `Month`,
name as Membership_Type_Name,sum(total_paid) as Total_Revenue 
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=8
group by name,month(start_date),year(start_date)
union all
select year(start_date) as `Year`,null as `Month`,
null as Memebership_Type_Name,
sum(total_paid) as Total_Revenue
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=8
group by year(start_date)
union all 
select year(start_date) as `Year`,month(start_date) as `Month`,
name as Membership_Type_Name,sum(total_paid) as Total_Revenue 
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=9
group by name,month(start_date),year(start_date)
union all
select year(start_date) as `Year`,null as `Month`,
null as Memebership_Type_Name,
sum(total_paid) as Total_Revenue
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=9
group by year(start_date)
union all
select year(start_date) as `Year`,month(start_date) as `Month`,
name as Membership_Type_Name,sum(total_paid) as Total_Revenue 
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=10
group by name,month(start_date),year(start_date)
union all
select year(start_date) as `Year`,null as `Month`,
null as Memebership_Type_Name,
sum(total_paid) as Total_Revenue
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=10
group by year(start_date)
union all 
select year(start_date) as `Year`,month(start_date) as `Month`,
name as Membership_Type_Name,sum(total_paid) as Total_Revenue 
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=11
group by name,month(start_date),year(start_date)
union all
select year(start_date) as `Year`,null as `Month`,
null as Memebership_Type_Name,
sum(total_paid) as Total_Revenue
from membership m join membership_type mt 
on m.membership_type_id =mt.id
where month(start_date)=11
group by year(start_date)
union all 
select 'Total' as `Year`,null as `Month`,null as Memebership_Type_Name,
sum(total_paid) as Total_Revenue
from membership m join membership_type mt 
on m.membership_type_id =mt.id;




-- Question 8
-- Segment customers based on the number of rentals and see the count 
-- of customers in each segment 
with cte as (
select 
case 
when count(*)>10 then 'More than 10'
when count(*) between 5 and 10 then 'Between 5 and 10'
else 'Fewer than 5'
end as Rental_Count_Category
from rental
group by customer_id)
select Rental_Count_Category,count(*) as Customer_Count
from cte
group by Rental_Count_Category
order by Customer_Count;


