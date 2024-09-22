use northwind;
select * 
from shippers;

select CategoryName,Description
from categories;

select FirstName,LastName,HireDate
from employees
where title="Sales Representative";


select FirstName,LastName,HireDate
from employees
where title="Sales Representative" and country="USA";



select * 
from orders
where employeeid=5;

select SupplierId,ContactName,ContactTitle
from suppliers
where not contactTitle="Marketing Manager";

select productId,ProductName
from products
where productname regexp "queso";

select orderid,customerid,shipcountry
from orders
where shipcountry in ("Brazil","Mexico","Argentina","Venezuela");


select Firstname,Lastname,title,date(birthdate) as BirthDate
from employees
order by birthdate;

select Firstname,Lastname,concat(Firstname," ",Lastname) as FullName
from employees;

select orderid,productid,unitprice,quantity,unitprice*quantity as TotalPrice
from orderdetails
order by orderid,productid;


select count(customerid)
from customers;


select min(orderdate) as firstorder
from orders;


select distinct country
from customers;


select distinct ContactTitle,count(*) as TotalContactTile
from customers
group by contacttitle;

select p.ProductId,p.ProductName,s.CompanyName
from products p join suppliers s 
on p.supplierid=s.supplierid
order by 1;

select  o.orderid as OrderID,date(o.orderdate) as OrderDate,s.companyname as Shipper
from orders o join shippers s 
on o.shipvia=s.shipperid
where o.orderid<10300
order by o.orderid;



