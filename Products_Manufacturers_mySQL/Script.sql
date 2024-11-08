-- LINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_computer_store
-- 1.1 Select the names of all the products in the store.

select name from products; 

-- 1.2 Select the names and the prices of all the products in the store.
select Name,Price
from products p ;

-- 1.3 Select the name of the products with a price less than or equal to $200.
select Name, Price 
from products p 
where Price <=200;

-- 1.4 Select all the products with a price between $60 and $120.
select Code,Name,Price
from products p 
where Price between 60 and 120;

-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
select Name,concat( Price*100," Cents") as Price_Cents 
from products p ;

-- 1.6 Compute the average price of all the products.
select avg(Price) as Average_Price
from products p;


-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
select avg(Price) as Average_Price
from products p 
where Manufacturer=2;

-- 1.8 Compute the number of products with a price larger than or equal to $180.
select count(*) as num_products 
from products p 
where price>=180;

-- 1.9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
select name,price 
from products p 
where price>=180 
order by price desc,name asc;

-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
select * 
from products p join manufacturers m
on p.Manufacturer =m.Code; 

-- 1.11 Select the product name, price, and manufacturer name of all the products.
select Name,Price,Manufacturer 
from products p ;
-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
select Manufacturer,avg(price) as Avg_Price
from products p 
group by Manufacturer;
-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
with cte_1 as (select Manufacturer,avg(price) as Avg_Price
from products p 
group by Manufacturer)
select m.Name,cte_1.Avg_Price
from  cte_1 join manufacturers m 
on cte_1.Manufacturer=m.code;


-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
with cte_1 as (select Manufacturer,avg(price) as Avg_Price
from products p 
group by Manufacturer)
select m.Name,cte_1.Avg_Price
from  cte_1 join manufacturers m 
on cte_1.Manufacturer=m.code
where cte_1.Avg_Price>=180

-- 1.15 Select the name and price of the cheapest product.

select Name,Price 
from products 
where Price=(select min(Price) from products p )


-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
with cte_1 as (
select row_number() over(partition by m.Name order by p.Price desc) as rn ,p.Name as Product_Name,p.Price,m.Name as Manufacturer_Name 
from products p left join manufacturers m 
on p.Manufacturer=m.Code)
select Manufacturer_Name,Product_Name,Price
from cte_1 
where rn=1;


-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
insert into products (Code,Name,Price,Manufacturer)
values (11,Loudspakers,70,2)

-- 1.18 Update the name of product 8 to "Laser Printer".

update products 
set Name='Laser Printer'
where code=8



-- 1.19 Apply a 10% discount to all products.

update products 
set Price=Price*0.9;
 

-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
update products 
set Price =Price*0.9 
where Price>=120

