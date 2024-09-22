-- CleanUp should be a work to do on a copyTable,not the original one tho.

-- 1. CleanUp BirthDates
-- Select Some things to find the proper functions 
select birthdate,substring_index(birthdate,"-",1) as Month,substring(birthdate,3,2) as Day_1,substring(birthdate,4,2) as Day_2,right(birthdate,2) as Year
from hr_data ;

select * 
from hr_data;
-- Make the "-" dates at the form MM/dd/YYYY where year<2000
update hr_data
set birthdate=concat(substring_index(birthdate,"-",1),"/",substring(birthdate,4,2),"/",19,right(birthdate,2))
where length(substring_index(birthdate,"-",1))<=2 and right(birthdate,2)>10;

-- Make the same for dates where year>2000
update hr_data
set birthdate=concat(substring_index(birthdate,"-",1),"/",substring(birthdate,4,2),"/",20,right(birthdate,2))
where length(substring_index(birthdate,"-",1))<=2 and right(birthdate,2)<10;

-- Select Some things 
select birthdate,substring_index(birthdate,"/",1) as Month,substring(birthdate,3,2) as Day_1,substring(birthdate,4,2) as Day_2,right(birthdate,4) as Year
from hr_data;


-- Now make the days in the default mysql datetimeform YYYY-MM-DD

-- There are two cases 

-- Case 1 based on day 
update hr_data 
set birthdate=concat(right(birthdate,4),"-",substring_index(birthdate,"/",1),"-",substring(birthdate,3,2))
where not substring(birthdate,3,2) regexp "/";


-- Case 2 based on day 
update hr_data
set birthdate=concat(right(birthdate,4),"-",substring_index(birthdate,"/",1),"-",substring(birthdate,4,2))
where substring(birthdate,3,2) regexp "/";

-- Now they are in the form of changing the current type from text to date
--    ------------------------------------------------------------------------------- -- 
-- Clean Up Hire Date


-- First we select some things to figure out which function is best in our case
select hire_date,substring_index(hire_date,"-",1) as Month,substring(hire_date,4,2) as Day_2,right(hire_date,2) as Year
from hr_data ;

-- Make the "-" dates in the correct form of mysql 

update hr_data
set hire_date=concat(20,right(hire_date,2),"-",substring_index(hire_date,"-",1),"-",substring(hire_date,4,2))
where length(substring_index(hire_date,"-",1))<=2;

-- Select some things

select hire_date,substring_index(hire_date,"/",1) as Month,substring(hire_date,3,2) as Day_2,right(hire_date,4) as Year
from hr_data 
;
-- At this Point after a lot of mistakes:
Create Table hr_data1 as 
select * from hr_data;



-- So lets make the final step for clean up hire_date at the copy table to ensure everything is correct
select hire_date,substring_index(hire_date,"/",1) as Month,substring(hire_date,3,2) as Day_2,right(hire_date,4) as Year
from hr_data1 
;


-- Case 1 for days
update hr_data1 
set hire_date=concat(right(hire_date,4),"-",substring_index(hire_date,"/",1),"-",substring(hire_date,3,2))
where length(substring_index(hire_date,"/",1))<=2 and not substring(hire_date,3,2) regexp "/";

-- Case 2 for days
update hr_data1
set hire_date=concat(right(hire_date,4),"-",substring_index(hire_date,"/",1),"-",substring(hire_date,4,2))
where length(substring_index(hire_date,"/",1))<=2 and substring(hire_date,3,2) regexp "/";


-- Check 
select hire_date
from hr_data1 ;

-- Make this for the original Table

update hr_data
set hire_date=concat(right(hire_date,4),"-",substring_index(hire_date,"/",1),"-",substring(hire_date,3,2))
where length(substring_index(hire_date,"/",1))<=2 and not substring(hire_date,3,2) regexp "/";

update hr_data
set hire_date=concat(right(hire_date,4),"-",substring_index(hire_date,"/",1),"-",substring(hire_date,4,2))
where length(substring_index(hire_date,"/",1))<=2 and substring(hire_date,3,2) regexp "/";



-- ----------------------------------------------------------------------------------------
-- 							 Birth/Hire DATES ARE CLEANED								  |
-- ----------------------------------------------------------------------------------------


-- Clean up TermDates(we dont need hour) First on copyTable

update hr_Data1
set termdate=left(termdate,10)
where length(termdate)>1;


-- Check 
select termdate 
from hr_data1;

-- Now on the orginal table

update hr_Data
set termdate=left(termdate,10)
where length(termdate)>1;


-- Update to null the values that are blank 

update hr_data1
set termdate =null 
where termdate="";
-- Check
select termdate 
from hr_data1
order by termdate desc;

-- Now on the original Table

update hr_data
set termdate =null 
where termdate="";


-- ----------------------------------------------------------------------------------------
-- 							 CLEAN UP COMPLETE/ Right Type Data 						  |
-- ----------------------------------------------------------------------------------------

-- Now we add the Age of the Employees. First Find the proper functions
select year(current_date())-year(birthdate)
from hr_data;

-- Second, we apply the changes on the copyTable;
alter table hr_data1
add column age INT NOT NULL;


update hr_data1
set age=year(current_date())-year(birthdate);


-- As soon as it works fine we do the same for the original Table,and change the possition of the column


alter table hr_data
add column age INT NOT NULL;


update hr_data
set age=year(current_date())-year(birthdate);

-- ------------------------------------------------------
-- Now there are some questions to answer from the date  |
-- ------------------------------------------------------
-- 1. Age distribution in the company(NO CLASSES)


select Age,count(*) as Age_Frequency
from hr_data
group by age
order by age;

-- 2.Age group by gender (NO GROUPED)
With Cte_Male as(
select Age,count(*) as Men_Frequency
from hr_data 
where gender="Male" and termdate is Null
group by age),
Cte_Female as (select Age,count(*) as Female_Frequency
from hr_data 
where gender="female" and termdate is Null 
group by age),
Cte_NF as (select Age,count(*) as NF_Frequency
from hr_data 
where gender="Non-Conforming" and termdate is Null 
group by age)
select cte_male.Age,Men_Frequency,Female_frequency,NF_frequency,Men_Frequency+Female_frequency+NF_frequency as Age_Frequency
from Cte_male join Cte_female 
on Cte_Male.Age=Cte_Female.Age
join Cte_NF 
on Cte_Male.age=Cte_NF.age
order by age;

-- ------------------------------------------------------------------------------
-- 3. Age Min/Max

select min(age) as Youngest,max(Age) as Oldest
from hr_data;


-- 4. Age distribution by GroupAge (CLASSES)

With Group_Age as 
(select case when age between 20 and 30 then "[20,30)"
when age between 30 and 40 then "[30,40)"
when age between 40 and 50 then "[40,50)"
else "[50,60)"
end as Age_Group
from hr_data
where termdate is null)
select Age_Group,count(*) as Grouped_Age_Frequency
from Group_age
group by age_group
order by age_group;




-- 5. Age distribution by Group Age,Gender(CLASSES)


With Group_Age as 
(select case when age between 20 and 30 then "[20,30)"
when age between 30 and 40 then "[30,40)"
when age between 40 and 50 then "[40,50)"
else "[50,60)"
end as Age_Group,Gender
from hr_data
where termdate is null
)
select Age_Group,Gender,count(*) as Grouped_Age_Gender_Frequency
from Group_age
group by age_group,Gender
order by age_group;


-- 6. Gender Breakdown


Select Gender,Count(*) as Gender_Frequency 
from hr_data
where termdate is Null
group by gender;



-- 7. How does gender vary across departments

select Gender,Department,
count(*) as Department_Gender_Frequency
from hr_data 
where termdate is Null 
group by Department,Gender
order by DepartMent;


-- 8. How does gender vary across Job Titles and DepartMents
select Gender,JobTitle,Department,
count(*) as Department_Job_Gender_Frequency
from hr_data 
where termdate is Null 
group by JobTitle,Gender,Department
order by DepartMent,JobTitle,Gender;


-- 9.Race Distribution 

select Race,count(*) as Race_Frequency 
from hr_data
where termdate is Null 
group by Race
order by race_frequency desc;

-- 10. Average Years in Company when termdate <= 4/9/2024


select avg(datediff(termdate,hire_date)/365) as Avg_Years_in_Company
from hr_data
where termdate is not Null and termdate<=current_date();


-- 11. Turnover Ratio : Total count by department,Then terminated Count, then division
select Department,Department_frequency,Terminated_Frequency, 
round(Terminated_Frequency/Department_frequency,2)*100 as `Turnover_Ratio%`
from(
	select Department,Count(*) as Department_Frequency,
	Sum(case when termdate is not null and termdate<=current_date() then 1 else 0
	end)as Terminated_Frequency
	from hr_Data
	group by Department)as t1
    order by `Turnover_Ratio%` desc;

-- 12 Tenure Distribution for each Department

Select Department, round(avg(datediff(termdate,hire_date)/365),0) as Tenure
from hr_data
where termdate is not Null and termdate<=current_date()
group by DepartMent
order By Tenure Desc;


-- 13. How many employees work remotely for each department

select Department,count(*) as Remote_Departments_Frequency
from hr_data
where location="Remote" and termdate is Null
group by Department;


-- 14. How many work remotely
select Location,count(*) as Location_Frequency
from hr_data 
where termdate is Null
group by Location;



-- 15. Distribution of employees across different states


select Location_State,count(*) as Location_Frequency
from hr_data
where termdate is null
group by Location_State
order by Location_frequency desc;


-- 16. Distribution of JobTitle
select JobTitle, count(*) as JobTitle_Frequency
from hr_data
where termdate is null 
group by JobTitle
order by count(*) desc;


-- 17. % Hire Change

With cte_1 as(
select year(hire_Date) as Hire_Year,
count(*) as Hires,
sum(case when termdate is not Null and termdate <= current_date then 1 else 0 end)
as Terminations
from hr_data
group by year(hire_date)
)
select Hire_Year,Hires,Terminations,
Hires-Terminations as Net_Change ,
round((Hires-Terminations)/Hires,2)*100 as `Hire_Change%`
from cte_1
order by `Hire_change%`