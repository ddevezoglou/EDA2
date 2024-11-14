-- The Warehouse
-- lINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_warehouse
-- 3.1 Select all warehouses.
select * 
from warehouses w 

-- 3.2 Select all boxes with a value larger than $150.
select * 
from boxes 
where value>150

-- 3.3 Select all distinct contents in all the boxes.  
select distinct contents 
from boxes
-- 3.4 Select the average value of all the boxes.  

select round(avg(value),3)as Avg_Value
from boxes
-- 3.5 Select the warehouse code and the average value of the boxes in each warehouse.

select w.Code,round(avg(value),3) as Avg_Value
from warehouses w join boxes b 
on w.Code =b.Warehouse 
group by w.Code;
-- 3.6 Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.

select w.Code,round(avg(value),3) as Avg_Value
from warehouses w join boxes b 
on w.Code =b.Warehouse 
group by w.Code
having round(avg(value),3)>150;

-- 3.7 Select the code of each box, along with the name of the city the box is located in.
select b.Code,w.Location
from boxes b join warehouses w 
on b.Warehouse =w.Code ;


-- 3.8 Select the warehouse codes, along with the number of boxes in each warehouse. 
    -- Optionally, take into account that some warehouses are empty (i.e., the box count should show up as zero, instead of omitting the warehouse from the result).
select w.Code as Warehouse_Code ,count(*) as Boxes
from boxes b join warehouses w 
on b.Warehouse =w.Code 
group by w.code;

-- 3.9 Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse's capacity).
with cte_1 as (select w.Code as Warehouse_Code,w.Capacity,count(*) as Boxes
from boxes b join warehouses w 
on b.Warehouse =w.Code 
group by w.code,W.Capacity)
select Warehouse_Code
from cte_1 
where Boxes>Capacity;

-- 3.10 Select the codes of all the boxes located in Chicago.
select b.code as Box_Code
from boxes b join warehouses w 
on b.Warehouse =w.Code 
where w.Location ='Chicago';


-- 3.11 Create a new warehouse in New York with a capacity for 3 boxes.
insert into warehouses(Code,Location,Capacity)
values (6,'New York',3)

-- 3.12 Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
insert into boxes (Code,Contents,Value,Warehouse)
values ('H5RT','Papers',200,2)

-- 3.13 Reduce the value of all boxes by 15%.
update boxes 
set Value =Value *0.85

-- 3.14 Remove all boxes with a value lower than $100.
delete 
from boxes 
where Value<100 



 