-- LINK : https://en.wikibooks.org/wiki/SQL_Exercises/Employee_management


-- 2.1 Select the last name of all employees.
select LastName 
from employees

-- 2.2 Select the last name of all employees, without duplicates.
select distinct LastName
from employees 

-- 2.3 Select all the data of employees whose last name is "Smith".
select * 
from employees 
where LastName ='Smith'



-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
select * 
from employees 
where LastName in ('Smith','Doe')

-- 2.5 Select all the data of employees that work in department 14.
select * 
from employees 
where Department=14

-- 2.6 Select all the data of employees that work in department 37 or department 77.
select * 
from employees  
where Department =37 or Department=77

-- 2.7 Select all the data of employees whose last name begins with an "S".
select * 
from employees 
where LastName regexp '^S'

-- 2.8 Select the sum of all the departments' budgets.
select sum(Budget) as Total_Budget
from departments  

-- 2.9 Select the number of employees in each department (you only need to show the department code and the number of employees).
select Department ,count(SSN)
from employees e 
group by Department 

-- 2.10 Select all the data of employees, including each employee's department's data.
select * 
from employees e join departments d 
on e.Department =d.Code 


-- 2.11 Select the name and last name of each employee, along with the name and budget of the employee's department.
select e.Name,e.LastName,d.Name as Department,d.budget
from employees e join departments d 
on e.Department =d.Code 

-- 2.12 Select the name and last name of employees working for departments with a budget greater than $60,000.
select e.Name,e.LastName
from employees e join departments d 
on e.Department =d.Code 
and Budget >60000

-- 2.13 Select the departments with a budget larger than the average budget of all the departments.
select Name,Budget 
from departments d 
where Budget >(select avg(Budget) from departments )

-- 2.14 Select the names of departments with more than two employees.
select d.Name,count(*) as Num_Employees
from employees e join departments d 
on e.Department =d.Code 
group by d.Name 
having count(*)>2



-- 2.15 Very Important - Select the name and last name of employees working for departments with second lowest budget.
with cte_1 as (
select Code,rank() over(order by Budget ) as Ranking,Budget
from departments d )
select Name,LastName 
from employees e join cte_1
on e.Department =cte_1.Code
where Ranking=2;


select * 
from departments d ;
-- 2.16  Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11.
insert into departments (Code,Name,Budget)
values (11,'Quality Assurance',40000)

-- And Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.


insert into employees (SSN,Name,LastName,Department)
values(847219811,'Mary','Moore',11)

-- 2.17 Reduce the budget of all departments by 10%.
update departments 
set Budget =Budget *0.9


-- 2.18 Reassign all employees from the Research department (code 77) to the IT department (code 14).

update employees 
set Department =14
where Department=77



-- 2.19 Delete from the table all employees in the IT department (code 14).

delete from employees 
where Department=14

-- 2.20 Delete from the table all employees who work in departments with a budget greater than or equal to $60,000.


DELETE e
FROM employees e
JOIN departments d ON e.Department = d.Code
WHERE d.Budget > 60000;



