

--        ----------------------------------
--        |         Feature Engineering     | 
--        -----------------------------------

-- Add a new_column time_of_the_day.
-- We always do that in a copy table 

create table sales_copy as 
select * from sales;


alter table sales_copy
add column time_of_the_day varchar(50) default null;


update sales_copy 
set time_of_the_day=(case 
when `Time`between "00:00:00" and "12:00:00" then "Morning"
when `Time`between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end);


-- Add day name 
alter table sales_copy 
add column day_name varchar(50) default null; 

update sales_copy 
set day_name=dayname(`Date`)  


-- Add month_name


alter table sales_copy 
add column month_name varchar(50) default null; 


update sales_copy 
set month_name=monthname(`Date`); 







-- 
select * 
from sales_copy 


--        ----------------------------------
--        |              E.D.A              | 
--        -----------------------------------



-- --------------------------
--        Product            |
-- --------------------------

-- How many unique cities does the data have 

select distinct City
from sales_copy;


-- In which city is each branch 

select distinct City, Branch 
from sales_copy ;


-- How many unique product lines does the data have? 
select count(distinct Product_line) 
from sales_copy ;


-- Most common payment method 
select count(*) as Counts ,Payment 
from sales_copy
group by Payment
order by Counts desc
limit 1;



-- What is the most selling product line?
select count(*) as Counts, Product_line 
from sales_copy 
group by Product_line 
order by Counts desc 
limit 1; 


-- What is the total revenue by Month 
select sum(total) as Total_Revenue,month_name as Month
from sales_copy 
group by month_name 
order by Total_Revenue desc;


-- What month had the largest cogs 
select sum(cogs) as Total_COGS,month_name as Month
from sales_copy 
group by month_name 
order by Total_COGS desc
limit 1;


-- What product line had the largest revenue
select sum(total) as Total_Revenue, Product_line
from sales_copy 
group by Product_line 
order by Total_Revenue desc
limit 1;



-- What is the city with the largest revenue
select sum(total) as Total_Revenue, City 
from sales_copy sc 
group by City 
order by Total_Revenue desc
limit 1; 




-- What product line had the largest VAT(Value Added Tax) 
select Product_line,avg(`Tax_5%`) as Average_Tax
from sales_copy
group by Product_line 
order by Average_Tax desc
limit 1;




-- Which branch sold more products than average product sold
select Branch,sum(Quantity) as Sum_Quantity 
from sales_copy 
group by Branch
having sum(Quantity)>(select avg(Quantity) from sales_copy)
order by Sum_Quantity desc 
limit 1 ;

-- Most common product line by gender 
select Gender, Product_Line,count(Gender) as Counter
from sales_copy
group by Product_line,Gender
order by gender,Counter desc


-- Average rating of each product line 
select Product_line, round(avg(Rating),2)as Average_Rating 
from sales_copy sc 
group by Product_line 
order by Average_Rating desc;

-- Fetch each product line and add a column to those 
-- product line showing "Good", "Bad". Good if its greater than average sales


with cte_1 as (
select Product_line,round(avg(quantity),2) as Average_Sales
from sales_copy 
group by Product_line)
select Product_line,Average_Sales,
case when Average_Sales>(select avg(quantity) from sales_copy) 
then "Good"
else "Bad"
end as Good_Bad
from cte_1












-- --------------------------
--         Sales            |
-- --------------------------

-- Number of Sales in each time of the day in Monday

select count(*) as Total_Sales,time_of_the_day
from sales_copy 
where day_name="Monday"
group by time_of_the_day
order by Total_Sales desc;


-- Which of the customer types brings the most revenue


select sum(Total) as Total_Revenue, Customer_type 
from sales_copy 
group by Customer_type 
order by Total_Revenue desc
limit 1;




-- Which city has the largest tax percent/VAT?
-- COGS=Unit Price * Quantity
-- VAT= Tax_5%*COGS


select round(avg(`Tax_5%`),2) as Avg_VAT,City
from sales_copy 
group by City 
order by Avg_VAT desc
limit 1;



-- Which customer type pays the most in VAT
select round(avg(`Tax_5%`),2) as Avg_VAT,Customer_type 
from sales_copy 
group by Customer_type 
order by Avg_VAT desc;



-- --------------------------
--         Customer          |
-- --------------------------





-- How many unique customer types does the data have
select distinct Customer_Type
from sales_copy ;



-- How many unique payment methods does the data have
select distinct Payment 
from sales_copy ;


-- What is the most common customer type 
select count(*) as Frequency,Customer_Type
from sales_copy 
group by Customer_Type 
order by Frequency desc
limit 1;


-- Which customer type buys the most

select sum(quantity) as Total_Sales, Customer_Type
from sales_copy 
group by Customer_type 
order by Total_Sales desc 
limit 1;




-- What is the gender with the most customers
select count(*) as Cnt,Gender
from sales_copy 
group by Gender 
order by Cnt desc 
limit 1; 




-- What is the gender distribution per branch 
select count(*) as Cnt, Branch,Gender
from sales_copy 
group by Branch,Gender
order by Branch;




-- Which time of the day do customer give the most rating?
select round(avg(Rating),2) as Avg_Rating,Time_Of_The_Day
from sales_copy 
group by time_of_the_day 
order by Avg_Rating desc 
limit 1; 



-- Which time of the day do customers give most ratings per branch?
select round(avg(Rating),2) as Avg_Rating,Branch,Time_Of_The_Day
from sales_copy 
group by Branch ,time_of_the_day
order by Branch,Avg_rating desc;




-- Which day of the week has the best avg rating?
select day_name as `Day`,round(avg(Rating),2) as Avg_Rating
from sales_copy 
group by day_name 
order by Avg_Rating desc 
limit 1;

-- Which day of the week has the best average ratings per branch 

select round(avg(Rating),2) as Avg_Rating,Branch,day_name as `Day`
from sales_copy 
group by Branch ,day_name 
order by Branch,Avg_rating desc;





select * 
from sales_copy sc 