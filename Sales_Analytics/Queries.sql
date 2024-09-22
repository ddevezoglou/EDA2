use salesproject;

-- 1. 
select * 
from customers;

-- 2. 
select count(*) 
from customers;

-- 3. Transactions for Chennai Market 
select * 
from transactions 
where market_code="Mark001";

-- 4. Distinct product codes that were sold in Chennai

select distinct product_code
from transactions 
where market_code="Mark001";


-- 5. Transactions where currency is US dollar 
select * 
from transactions 
where currency="USD";


-- 6. transaction in 2020 join by date table 
-- -----------------------------------------------------
-- date: date, cy_date,year,month_name,date_yy_mmm   |
-- transactions: order_date (to join date)
-- -----------------------------------------------------


select * 
from transactions t  left join date d 
on t.order_date=d.date
where year(d.date)=2020;



-- 7. 

select sum(t.sales_amount)  as Total_Sales_Amount
from transactions t left join date d 
on t.order_date=d.date
where d.year=2020 and t.currency regexp "INR|USD";



-- 8. 

select sum(t.sales_amount)  as Total_Sales_Amount
from transactions t left join date d 
on t.order_date=d.date
where d.year=2020 and d.month_name="January" and t.currency regexp "INR|USD";



-- 9.

select sum(t.sales_amount)  as Total_Sales_Amount
from transactions t left join date d 
on t.order_date=d.date
where d.year=2020 and market_code="Mark001" and t.currency regexp "INR|USD";