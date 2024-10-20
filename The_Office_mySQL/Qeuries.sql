-- List all the employees in order of decreasing salary

select * 
from employee_data 
order by salary desc;



-- List all the department names and the number of employees in that department
-- Order by number of employees in department (greatest to least)


select deptname,
count(emp_id) as num_in_dept
from employee_data e right join department d
on e.dept_id =d.deptid 
group by deptname
order by 2 desc; 


-- List all the employees that dont have a manager 
select * 
from employee_data ed 
where mananger_id is null;



-- List all employees by name, and the name of their manager. If the employee doesn't have 
-- a manager, leave the column as NULL


with cte_1 as 
(select emp_name,mananger_id from employee_data), 
cte_2 as 
(select emp_id,emp_name from employee_data ed)
select cte_1.emp_name as employee,
case when 
cte_2.emp_name is not null then cte_2.emp_name
else Null
end as manager
from cte_1 left join cte_2 
on cte_1.mananger_id=cte_2.emp_id 
order by 2 desc;



-- For each manager, list the number of employees he or she is managing. For these purposes,
-- a manager is anyone who is not managed by someone else, even if that person has no direct 
-- reports


with cte_1 as 
(select emp_name,emp_id 
from employee_data 
where mananger_id is null 
), 
cte_2 as(
select mananger_id, count(*) as num_managed
from employee_data ed 
group by mananger_id
)
select cte_1.emp_name as name,
case when 
cte_2.num_managed >0 then cte_2.num_managed 
else 0 
end as num_managed
from cte_1 left join cte_2 
on cte_1.emp_id=cte_2.mananger_id
order by 2 desc;



-- Find the two highest paid people per department 
with cte_1 as (select emp_name as name,
dept_id,
salary,
rank() over(partition by dept_id order by salary desc) as `rank`
from employee_data ed 
order by 2 )
select name,dept_id, salary, `rank`
from cte_1 
where `rank` <=2;






select * 
from employee_data ed 