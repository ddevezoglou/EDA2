select c.customerid,c.companyname,o.OrderID,sum(od.quantity*od.unitprice) as total_amount
from customers c join orders o 
on c.customerid=o.CustomerID
join orderdetails od 
on od.orderid=o.orderid
where year(o.orderdate)=1996
group by c.customerid,c.CompanyName,o.orderid
having total_amount>10000
order by total_amount desc;



select c.customerid,c.companyname,sum(od.quantity*od.unitprice) as order_amount
from customers c join orders o 
on c.customerid=o.CustomerID
join orderdetails od 
on od.orderid=o.orderid
where year(o.orderdate)=1996
group by c.customerid,c.CompanyName
having order_amount>15000
order by order_amount desc;

select c.customerid,c.companyname,sum(od.quantity*od.unitprice) as amount_without_discount,sum(od.quantity*od.unitprice*(1-od.discount)) as amount_after_discount
from customers c join orders o 
on c.customerid=o.CustomerID
join orderdetails od 
on od.orderid=o.orderid
where year(o.orderdate)=1996
group by c.customerid,c.CompanyName
having amount_after_discount>10000
order by amount_after_discount desc;


select orderdate,orderid,employeeid
from orders 
where orderdate=last_day(orderdate)
order by 3,2;


select o.orderid, rand() as values_rand
from orders o join orderdetails d
on o. orderid=d.orderid;


select  orderid
from orderdetails od  
where quantity>=60
group by orderid,quantity
having count(*)>1;



select  orderid,productid,unitprice,quantity,discount
from orderdetails od  
where orderid in (
select  orderid
from orderdetails od  
where quantity>=60
group by orderid,quantity
having count(*)>1
)
order by orderid,quantity;

select orderid,orderdate,requireddate,shippeddate
from orders 
where RequiredDate<=ShippedDate
order by orderid;


select concat(FirstName," ",Lastname) as Name_Salesperson,e.employeeid as ID,count(*) as Late_Orders
from orders o join employees e
on o.EmployeeID=e.employeeid
where o.RequiredDate<=o.ShippedDate
group by e.EmployeeID
order by 3 desc;


select concat(FirstName," ",Lastname) as Name_Salesperson,e.employeeid as ID,count(*) as Total_Sales,sum(case when o.RequiredDate<=o.ShippedDate then 1 else 0 end) as Late_Orders
from orders o join employees e 
on o.EmployeeID=e.employeeid
group by e.employeeid;



select concat(FirstName," ",Lastname) as Name_Salesperson,e.employeeid as ID,count(*) as Total_Sales,sum(case when o.RequiredDate<=o.ShippedDate then 1 else 0 end) as Late_Orders,
concat(round(
        (sum(CASE WHEN o.RequiredDate <= o.ShippedDate THEN 1 ELSE 0 END) / COUNT(*))*100, 
        2
    )," ","%") AS Late_Order_Percentage
from orders o join employees e 
on o.EmployeeID=e.employeeid
group by e.employeeid;



select concat(FirstName," ",Lastname) as Name_Salesperson,e.employeeid as ID,count(*) as Total_Sales,sum(case when o.RequiredDate<=o.ShippedDate then 1 else 0 end) as Late_Orders,
round(
        (sum(CASE WHEN o.RequiredDate <= o.ShippedDate THEN 1 ELSE 0 END) / COUNT(*)), 
        2
    ) AS Late_Order_Percentage
from orders o join employees e 
on o.EmployeeID=e.employeeid
group by e.employeeid;

select c.CustomerID as ID,c.companyname as Company_Name, sum(d.unitprice*d.quantity) as Total_Order_Amount,
case when sum(d.unitprice*d.quantity) between 0 and 1000 then "Low"
when sum(d.unitprice*d.quantity) between 1001 and 5000 then "Medium"
when sum(d.unitprice*d.quantity) between 5001 and 10000 then "High"
when sum(d.unitprice*d.quantity)>10000 then "Very High"
else "Bottom" 
end
as CustomerGroup
from customers c  left join orders o 
on c.CustomerID=o.CustomerID
left join orderdetails d
on d.orderid=o.OrderID
where year(o.orderdate)=1996
group by c.CustomerID
order by c.CustomerID;



SELECT 
    CustomerGroup, 
    COUNT(*) AS CustomerCount,
    (COUNT(*) / SUM(COUNT(*))over())  AS CustomerPercentage
FROM (
    SELECT 
        CASE 
            WHEN SUM(d.unitprice * d.quantity) BETWEEN 0 AND 1000 THEN 'Low'
            WHEN SUM(d.unitprice * d.quantity) BETWEEN 1001 AND 5000 THEN 'Medium'
            WHEN SUM(d.unitprice * d.quantity) BETWEEN 5001 AND 10000 THEN 'High'
            WHEN SUM(d.unitprice * d.quantity) > 10000 THEN 'Very High'
            ELSE 'Bottom'
        END AS CustomerGroup
    FROM 
        customers c
    LEFT JOIN 
        orders o ON c.CustomerID = o.CustomerID
    LEFT JOIN 
        orderdetails d ON d.orderid = o.OrderID
    WHERE 
        YEAR(o.orderdate) = 1996
    GROUP BY 
        c.customerid
) AS grouped_customers
GROUP BY 
    CustomerGroup;



select country 
from suppliers
union
select country
from customers;

Select SupplierCountries.Country as SuppliersCountries, CustomerCountries.Country as CustomerCountries
from (select country from suppliers) as SupplierCountries
left join (select country from customers) as CustomerCountries
on CustomerCountries.Country = SupplierCountries.Country
union
Select SupplierCountries.Country as SuppliersCountries, CustomerCountries.Country as CustomerCountries
from (select country from suppliers) as SupplierCountries
right join (select country from customers) as CustomerCountries
on CustomerCountries.Country = SupplierCountries.Country
order by CustomerCountries;


SELECT
  o.shipcountry,
  o.customerid,
  o.orderid,
  o.orderdate
FROM orders o
INNER JOIN (
  SELECT shipcountry, MIN(orderdate) AS first_order_date
  FROM orders
  GROUP BY shipcountry
) AS first_orders ON o.shipcountry = first_orders.shipcountry AND o.orderdate = first_orders.first_order_date
ORDER BY o.orderid;



select o1.customerid as CustomerID,o1.OrderID as InitialOrderID,o1.orderdate as InitialOrderDate,o2.OrderID as NextOrderId, o2.OrderDate as NextOrderDate,datediff(o2.orderdate,o1.orderdate) as DaysBetween
from orders o1 left join orders o2
on o1.customerid=o2.customerid  and o1.orderid<o2.OrderID
where datediff(o2.orderdate,o1.orderdate) between 0 and 5 
order by o1.CustomerID;


