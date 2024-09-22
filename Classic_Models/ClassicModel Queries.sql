-- All queries answered from:
-- https://www.richardtwatson.com/open/Reader/ClassicModels.html#


select * 
from offices
order by country,state,city;
select count(*) as Total_Employees
from employees;
select sum(amount) as Total_Payments_Received
from payments;
select * 
from productlines
where productline regexp "Cars";

select sum(amount) as Total_Payments_October28_2004
from payments
where paymentdate="2004-10-28";

select *
from payments 
where amount>100000;


select distinct productName as Product,productLine
from products
order by productline;


select count(*) as Products_In_ProductLine,productline as ProductLine
from products 
group by productline
order by productline;


select min(amount) as Min_Payment
from payments;


select * 
from payments 
where amount>2*(select avg(amount) from payments);

select avg(msrp) as Average_MSRP
from products;


select count(distinct productname) as Distinct_Products
from products;


select customerName as Name ,city as City 
from customers
where salesRepEmployeeNumber is Null ;

select concat(firstname," ",lastname) as Executive_Names
from employees
where jobtitle regexp "VP" or jobtitle regexp "Manager";

select sum(priceeach*quantityordered) as Total_Value,orderNumber
from orderdetails
group by orderNumber
Having Total_Value>5000;

select concat(contactfirstname," ",contactlastname) as Account_Representative
from customers;


select sum(amount) as Total_Payments_Ag
from payments p left join customers c
on p.customernumber=c.customernumber
group by c.customername
having customername="Atelier graphique";



select sum(amount) as Total_Payments_Ag,p.PaymentDate
from payments p left join customers c
on p.customernumber=c.customernumber
group by p.paymentDate
order by 2;



select * 
from products 
where products.productcode not in (select productcode from orderdetails);

select c.CustomerNumber,c.customerName,sum(p.amount) as Total_Amount
from customers c  join payments p
on c.customerNumber=p.customerNumber
group by c.customerNumber
order by 3 desc;


select count(*) as Total_Orders
from orders o join customers c 
on o.customernumber=c.customernumber
where c.customername="Herkku Gifts"
group by c.customernumber;


select concat(firstname," ",lastname) as Employees_In_Boston
from employees e join offices o
on e.officecode=o.officecode
where o.city="Boston";


select sum(p.amount) as Total_Amount_Over_100000,c.customername as Customers
from payments p join customers c
on p.customernumber=c.customernumber
group by Customers
having Total_Amount_Over_100000>100000
order by 1 desc;

select sum(od.priceeach*od.quantityOrdered) as Total_Value,o.Status, o.OrderNumber 
from orders o left join orderdetails od
on o.ordernumber=od.ordernumber
where status="On Hold"
group by o.ordernumber;

select count(*) as Total_Orders,c.CustomerNumber,o.Status 
from orders o left join customers c
on o.customernumber=c.customerNumber
where o.status="On Hold"
group by c.customernumber;



select p.productName,o.orderDate
from orders o left join orderdetails od
on o.orderNumber=od.orderNumber
left join products p 
on p.productCode=od.productCode;




select p.productName,o.orderDate
from orders o left join orderdetails od
on o.orderNumber=od.orderNumber
left join products p 
on p.productCode=od.productCode
where p.productName="1940 Ford Pickup Truck"
order by orderDate desc;



select sum(quantityordered*priceEach) as TotalOfOrder,o.ordernumber,c.Customername
from customers c join orders o 
on c.customerNumber=o.customerNumber
 join orderdetails od
on od.orderNumber=o.orderNumber
group by ordernumber
having TotalOfORder>25000;



select p.productCode
from products p  left join orderdetails od
on p.productCode=od.productCode
group by p.productCode
having count(*)=(select count(distinct ordernumber) from orders);




select p.productName,o.ordernumber,priceEach,p.MSRP, (priceeach/MSRP)*100 as prct_MSRP
from orderdetails o left join products p
on o.productCode=p.productCode
group by p.productname,o.ordernumber,priceeach,msrp
having prct_msrp<=80
order by prct_msrp;


select p.productName,o.ordernumber,priceEach,buyprice
from orderdetails o left join products p
on o.productCode=p.productCode
where priceEach>=2*buyprice;



select p.productName
from orders o left join orderdetails od
on o.orderNumber=od.orderNumber
left join products p 
on p.productCode=od.productCode
where dayname(o.orderDate)="Monday"
order by orderDate desc;

select sum(od.quantityOrdered)
from orders o left join orderdetails od
on o.ordernumber=od.ordernumber 
where o.status="On Hold";

select productCode,productName
from products
where productname regexp "Ford";

select productCode,productName
from products
where productname regexp "ship$";

select customerNumber,customerName,country
from customers
where country in ("Denmark","Norway","Sweden");


select productCode,productName
from products
where right(productcode,4) between 1000 and 1499 and productcode regexp "^s700";


select customerNumber,customerName 
from customers
where customername regexp "[0-9]";


select firstName,lastName
from employees
where firstname regexp "Diane|Dianne" ;

select productCode,productName
from products 
where productname regexp "ship|boat";

select productCode,productName
from products 
where productcode regexp "^s700";


select firstname,lastname
from employees 
where firstname regexp "Larry|Barry";


select firstname,lastname 
from employees 
where not firstname regexp "^[[:alpha:]]+$" or not lastname regexp "^[[:alpha:]]+$";


select productVendor
from products
where productVendor regexp "Diecast$";



-- General Queries


-- 1. 
select employeeNumber,FirstName,LastName
from employees
where reportsTo is Null;

-- 2.
select employeeNumber,lastName,firstName 
from employees
where reportsTo=(select employeeNumber from employees where firstname="William" and lastname="Patterson");


-- 3.
select distinct p.productName
from customers c join orders o 
on c.customerNumber=o.customerNumber
join orderdetails od 
on od.orderNumber=o.orderNumber
join products p 
on p.productCode=od.productCode
where customerName="Herkku Gifts";


-- 4. 
with Comm_cte as(
-- Find the Commision of Each Sale
select orderNumber,(sum(quantityOrdered*priceEach))*0.05 as Commision_Per_Order
from orderdetails od
group by orderNumber),
-- Every SalesMan is responsible for some orders
EmpCust_cte as (
select customerNumber,customerName,employeeNumber,concat(e.lastName," ",e.firstname) as employeeName
from customers c left join employees e 
on c.salesRepEmployeeNumber=e.employeeNumber)
-- Now we join 
select com.orderNumber,emp.CustomerNumber,emp.CustomerName,emp.employeeNumber,emp.employeeName,com.Commision_Per_Order
from orders o  left join EmpCust_Cte emp
on o.customerNumber=emp.customerNumber
join comm_cte com 
on com.orderNumber=o.orderNumber
order by 5;

-- 5.
select datediff(max(OrderDate),min(OrderDate))
from orders;

-- 6.
With Full_Cte as(
select orderNumber,datediff(shippedDate,orderDate) as Diff, customerName
from orders o join customers c
on o.customerNumber=c.customerNumber)
select avg(Diff) as Average_Diff,customerName
from Full_Cte 
group by customerName
order by Average_Diff desc;


-- 7. 
with Full_Cte as(
select shippeddate,quantityOrdered as qO,priceEach as pE
from orders o left join orderdetails od
on o.orderNumber=od.orderNumber
where year(shippedDate)=2004 
and month(shippedDate)=08)
select sum(qO*pE) as Total_Sum_August
from Full_Cte;


-- 8.

-- Step 1 Create Order_VW
Create View Orders_VW as 
select c.CustomerName as Cs,sum(quantityOrdered*priceEach) as Total_Orders
from orders o left join orderdetails od
on o.orderNumber=od.orderNumber
left join customers c
on o.customerNumber=c.customerNumber
where year(shippedDate)=2004 
group by Cs;


-- Step 2 Create Payments_VW
Create View Payments_VW as
select sum(Amount) as Total_Payments,c.customerName as Cs
from payments p left join customers c 
on p.customerNumber=c.customerNumber
where year(paymentDate)=2004
group by Cs;

-- Step 3 Join them and find the difference: orders-payments
select p.Cs,Total_Orders,Total_Payments,(Total_orders-Total_payments) as Diff_Orders_Payments
from Payments_VW p left join Orders_VW o
on p.Cs=o.Cs
order by Diff_Orders_Payments desc;


-- 9. 
with t1_cte as
(select concat(e1.firstName," ",e1.lastname) as Wanted_Employees,
concat(e2.firstName," ",e2.lastName) as Wanted_Employees_Reports_To,
e2.reportsTo as Reports_To
from employees e1 left join employees e2 
on e1.reportsTo=e2.employeeNumber)
select Wanted_Employees
from t1_cte left join employees e3 
on t1_cte.Reports_To=e3.employeeNumber
where concat(e3.firstname," ",e3.lastname)="Diane Murphy";

-- 13.
select sum(amount)
from payments
where year(paymentDate)=2004 and month(paymentDate)=7;


-- 14. 
With Payments_CTE as(
select month(paymentDate) as Month_of_2004,sum(amount) as Total_Amount,count(paymentDate) as Orders_Made
from payments
where year(paymentDate)=2004
group by month(paymentDate)
order by Month_of_2004)
select Month_of_2004,Total_Amount,Orders_Made,Total_amount/Orders_Made as Ratio_Of_Value
from Payments_Cte;



-- 15.
With CTE04 as 
(select month(paymentDate) as Month_of_2004,sum(amount) as Total_Amount_2004
from payments
where year(paymentDate)=2004
group by month(paymentDate)
order by Month_of_2004),
CTE03 as 
(select month(paymentDate) as Month_of_2003,sum(amount) as Total_Amount_2003
from payments
where year(paymentDate)=2003
group by month(paymentDate)
order by Month_of_2003)
select cte04.month_of_2004 as Months,Total_Amount_2004,Total_Amount_2003,(Total_Amount_2004-Total_Amount_2003) as Difference
from cte04 join cte03 
on cte04.month_of_2004=cte03.month_of_2003;


-- 16.
select OrderDate,c.CustomerName,sum(od.quantityOrdered) as Amount_Ordered
from orders o left join customers c
on o.customernumber=c.customerNumber
right join orderdetails od 
on od.orderNumber=o.orderNumber
where year(orderDate)=2004 and month(orderDate)=03 and c.customerName regexp "A"
group by  orderdate,c.customerNumber
order by Amount_Ordered desc;



-- 17. Credit limit is not specified so i choose to  reduce it by 21%
select country,Customername,creditlimit as Old_CreditLimit,creditlimit*0.79 as New_CreditLimit
from customers
where country="france";


-- 18. 
WITH
p1 AS (SELECT Products.productCode, productName AS `Product 1`, orderNumber
FROM Products JOIN OrderDetails
ON Products.productCode = OrderDetails.productCode),
p2 AS (SELECT Products.productCode, productName AS `Product 2`, orderNumber
FROM Products JOIN OrderDetails
ON Products.productCode = OrderDetails.productCode)
SELECT `Product 1`, `Product 2`, count(*) as Frequency FROM p1 JOIN p2
ON p1.orderNumber = p2.OrderNumber
WHERE p1.productCode > p2.productCode
GROUP BY `Product 1`, `Product 2` HAVING Frequency > 10
ORDER BY Frequency DESC, `Product 1`, `Product 2`;

-- 19. 
With revenue_cte as (select c.CustomerName, sum(od.quantityOrdered*priceEach) as Revenue
from orderdetails od left join orders o  
on od.orderNumber=o.orderNumber
left join customers c 
on c.customerNumber=o.customerNumber
group by c.customerName)
Select CustomerName, Revenue, round((Revenue/sum(Revenue)over())*100,2) as Pct_Revenue
from revenue_cte
group by CustomerName
order by CustomerName;


-- 20.
With profit_cte as (select c.CustomerName, sum(od.quantityOrdered*(priceEach-buyPrice)) as Profit
from orderdetails od left join orders o  
on od.orderNumber=o.orderNumber
left join customers c 
on c.customerNumber=o.customerNumber
left join products p 
on p.productCode=od.productCode
group by c.customerName)
Select CustomerName, Profit, round((Profit/sum(Profit)over())*100,2) as Pct_Profit
from profit_cte
group by CustomerName
order by Pct_Profit desc;


-- 21.
select concat(e.firstname," ",e.lastName) as Employee_Name, sum(od.quantityOrdered*od.priceEach) as Revenue
from orderdetails od left join orders o
on od.orderNumber=o.orderNumber left join customers c 
on c.customerNumber=o.customerNumber
left join employees e
on c.salesRepEmployeeNumber=e.employeeNumber
group by Employee_Name
order by Revenue desc;



-- 22.
select concat(e.firstname," ",e.lastName) as Employee_Name, sum(od.quantityOrdered*(priceEach-buyPrice)) as Profit
from orderdetails od left join orders o  
on od.orderNumber=o.orderNumber
left join customers c 
on c.customerNumber=o.customerNumber
left join products p 
on p.productCode=od.productCode
left join employees e
on c.salesRepEmployeeNumber=e.employeeNumber
group by Employee_Name
order by Profit desc;

-- 23.
select p.productName,sum(quantityOrdered*priceEach) as Total_Value
from orderdetails od left join products p 
on od.productCode=p.productCode
group by p.productName
order by p.productName;

-- 24. 
select (sum(quantityOrdered*priceEach)-sum(quantityOrdered*buyPrice)) as Profit,p.productLine
from orderdetails od left join products p 
on od.productCode=p.productCode
group by productLine
order by profit desc;


-- Sales Made Ratio. 
With CTE_2003 as(
select p.productName,count(orderDate) as Total_Sales_2003
from orderdetails od left join orders o 
on od.orderNumber=o.orderNumber
left join products p 
on p.productCode=od.productCode
where year(orderDate)=2003
group by p.productName),
Cte_2004 as (
select p.productName,count(orderDate) as Total_Sales_2004
from orderdetails od left join orders o 
on od.orderNumber=o.orderNumber
left join products p 
on p.productCode=od.productCode
where year(orderDate)=2004
group by p.productName)
select cte_2004.productName,Total_Sales_2003,Total_Sales_2004,(Total_Sales_2004/Total_Sales_2003) as Ratio 
from cte_2004 join cte_2003
on cte_2004.productName=cte_2003.productName
order by Ratio desc;





-- 25. 
With cte_2003 as(
select productName,sum(quantityOrdered*priceEach) as Total_Sales_2003
from orderdetails od left join orders o 
on od.orderNumber=o.orderNumber
left join products p 
on p.productCode=od.productCode
where year(orderDate)=2003
group by productName),
cte_2004 as 
(select productName,sum(quantityOrdered*priceEach) as Total_Sales_2004
from orderdetails od left join orders o 
on od.orderNumber=o.orderNumber
left join products p 
on p.productCode=od.productCode
where year(orderDate)=2004
group by productName)
select cte_2004.productName, Total_Sales_2003,Total_Sales_2004, round((Total_Sales_2004/Total_Sales_2003),2) as Ratio
from cte_2003 join cte_2004 
on cte_2003.productName=cte_2004.productName
order by Ratio desc;

-- 26.
with cte_2003 as (
select customerName,sum(amount) as Payments_2003
from customers c left join payments p 
on c.customerNumber=p.customerNumber
where year(p.paymentDate)=2003
group by customerName), 
cte_2004 as (
select customerName,sum(amount) as Payments_2004
from customers c left join payments p 
on c.customerNumber=p.customerNumber
where year(p.paymentDate)=2004
group by customerName) 
select cte_2003.customerName, Payments_2003,Payments_2004,round((Payments_2004/Payments_2003),2) as Ratio
from cte_2003 join cte_2004 
on cte_2003.customerName=cte_2004.customerName
order by Ratio desc;



-- 27. 
select productName 
from products p join orderdetails od
on p.productCode=od.productCode
join orders o 
on o.orderNumber=od.orderNumber
where Year(orderDate)=2003 
and p.productCode not in (
select p.productCode
from products p join orderdetails od
on p.productCode=od.productCode
join orders o 
on o.orderNumber=od.orderNumber
where year(orderDate)=2004
);

-- 28.

select distinct c.customerName 
from payments p  join customers c
on p.customerNumber=c.customerNumber 
where c.customerName not in (
select customerName 
from customers c join payments p  
on p.customerNumber=c.customerNumber 
where year(paymentDate)=2003
);


-- Correlated Subqueries 


-- 1. 
select e1.EmployeeNumber,concat(e1.firstName," ",e1.lastName) as Employee, e1.reportsTo, concat(e2.firstName," ",e2.lastName) as Reports_FullName
from employees e1 join employees e2
on e1.reportsTo=e2.employeeNumber
where concat(e2.firstName," ",e2.lastName)="Mary Patterson";








