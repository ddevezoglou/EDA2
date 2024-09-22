select c.CategoryName,count(*) as TotalProducts
from categories c join products p
on c.CategoryID=p.categoryID
group by c.CategoryID
order by 2 desc;


select country,city,count(*) totalcustomer
from customers
group by country,city
order by 3 desc,1;




select ProductID,ProductName,UnitsInStock,ReorderLevel
from products
where UnitsInStock<ReorderLevel
order by ProductID;

select ProductID,ProductName,UnitsInStock,ReorderLevel,UnitsOnOrder,Discontinued
from products
where (UnitsInStock+UnitsOnOrder)<=ReorderLevel and
Discontinued=0;

select CustomerID,CompanyName,Region
from customers
order by case when region is null then 1 else 0 end,region,customerid;


select ShipCountry,avg(Freight) as AverageFreight
from orders o right join customers c
on o.customerid=c.CustomerID
where o.orderdate between date_sub((select max(orderdate) from orders) ,interval 12 month) and (select max(orderdate) from orders)
group by ShipCountry
order by 2 desc
limit 3;

select o.EmployeeID, e.LastName,o.orderid,p.ProductName,od.Quantity
from orders o left join orderdetails od 
on o.OrderID=od.orderid
left join products p 
on od.productid=p.productid
left join employees e
on o.employeeid=e.employeeid
;

select c.customerid,o.OrderID
from customers c left join orders o 
on c.customerid=o.CustomerID
where o.OrderID is null ;

select c.customerid,o.CustomerID
from customers c left join orders o
on c.CustomerID=o.CustomerID
and o.EmployeeID=4
where o.CustomerID is null;