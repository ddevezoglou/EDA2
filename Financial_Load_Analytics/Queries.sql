
-- Clean The Data/ Fix Dates 

-- 1. Issue_date Column
update loans 
set issue_date=concat(right(issue_date,4),"-",substring(issue_date,4,2),"-",left(issue_date,2));

-- 2. Last_Credit_Pull_date

update loans 
set last_credit_pull_date=concat(right(last_credit_pull_date,4),"-",substring(last_credit_pull_date,4,2),"-",left(last_credit_pull_date,2));

-- 3.Last_Payment_date

update loans 
set last_payment_date=concat(right(last_payment_date,4),"-",substring(last_payment_date,4,2),"-",left(last_payment_date,2));



-- 4.Next_payment_date
update loans 
set next_payment_date=concat(right(next_payment_date,4),"-",substring(next_payment_date,4,2),"-",left(next_payment_date,2));

-- Check /Make them DATE




-- ------------------------
-- Now we find the KPIs   |
-- ------------------------




-- 1. Total Number of Applications 
select count(distinct id) as Total_Loan_Applications
from loans;


-- 2. Total Number Applications December {MTD} --> Max(Issue_Date)=12/12/2021, so we find in December

select count(distinct id) as Total_Applications_MTD
from loans
where month(issue_Date)=12;


-- 3. {PMTD} Total Number Applications

select count(distinct id) as Total_Applications_PMTD
from loans
where month(issue_Date)=11;

-- 4. Total Funded Amount

select sum(loan_amount) as Total_Funded_Amount
from loans ;


-- 5. {MTD} Total Funded Amount

select sum(loan_amount) as Total_Funded_Amount_MTD
from loans 
where month(issue_Date)=12;

-- 6.{PMTD} Total Funded Amount
select sum(loan_amount) as Total_Funded_Amount_PMTD
from loans 
where month(issue_Date)=11;


-- 7. Total Amount Received 
select sum(total_payment) as Total_Amount_Collected 
from loans ;

-- 8.{MTD}Total Amount Received 
select sum(total_payment) as Total_Amount_Collected_MTD
from loans 
where month(issue_date)=12;


-- 9.{PTMD}Total Amount Received 

select sum(total_payment) as Total_Amount_Collected_PTMD
from loans 
where month(issue_date)=11;

-- 10. Average Interest Rate

select avg(int_rate)*100 as Avg_Int_Rate
from loans;


-- 11. {MTD}Average Interest Rate
select avg(int_rate)*100 as Avg_Int_Rate_MTD
from loans
where month(issue_Date)=12;



-- 12. {PTMD}Average Interest Rate
select avg(int_rate)*100 as Avg_Int_Rate_MTD
from loans
where month(issue_Date)=11;


-- 13.Average DTI

select avg(dti)*100 as Avg_DTI
from loans;


-- 14. {MTD} Average DTI

select avg(dti)*100 as Avg_DTI_MTD
from loans
where month(issue_date)=12;


-- 15. {PTMD}Average DTI

select avg(dti)*100 as Avg_DTI_PMTD
from loans
where month(issue_date)=11;



-- 16.GOOD LOAN PCT (define the loans that are fully paid/current and divide by total_loans)
select (count(
case when loan_status="Fully Paid" or loan_status="Current" then id end)*100
)/count(id) as Good_Loan_Pct
from loans;

-- 17.Good Loan Applications
select count(id) as Good_Loan_applications
from loans
where loan_status="Fully Paid" or loan_status="Current";


-- 18. Good Loan Amount Funded
select sum(loan_amount) as Good_Loan_Amount_Funded
from loans
where loan_status="Fully Paid" or loan_status="Current";



-- 19. Good Loan Amount Received 
select sum(total_payment) as Good_Loan_Amount_Received
from loans
where loan_status="Fully Paid" or loan_status="Current";



-- 20. Bad Loan Pct 
select (count(case when loan_status="Charged Off" then id end))*100/count(id) as Bad_Loan_Pct
from loans;


-- 21.Bad Loan Applications 
select count(id) as Bad_Loan_Applications
from loans 
where loan_status="Charged Off";

-- 22.Bad Loan Funded Amount
select sum(loan_amount) as Bad_Loan_Funded_Amount
from loans 
where loan_status="Charged Off";

-- 23. Bad Loan Amount Received
select sum(total_payment) as Bad_Loan_Amount_Received
from loans 
where loan_status="Charged Off";



-- 24. Loan Status 
select Loan_Status,
count(id) as Loan_Count,
sum(total_payment) as Total_Amount_Received,
sum(loan_amount) as Total_Funded_Amount,
avg(dti)*100 as DTI
from loans 
group by Loan_Status;


-- 25. Loan Status {MTD}

select Loan_Status,
sum(total_payment) as Total_Amount_Received_MTD,
sum(loan_amount) as Total_Funded_Amount_MTd
from loans 
where month(issue_date)=12
group by Loan_Status;



-- 26. Monthly Report 

select month(issue_date) as Month_Number,
date_format(issue_date,"%M") as Month_Name,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from loans 
group by month(issue_date),date_format(issue_date,"%M")
order by month(issue_date);


-- 26. State


select address_state as State,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from loans
group by address_state
order by address_state;




-- 27. Term 
select term as Term, 
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from loans
group by Term 
order by Term;


-- 28. Employee Length

select emp_length as Employee_Length,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from loans
group by emp_length
order by emp_length;

-- 29.Purpose
select purpose as Purpose,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from loans
group by purpose
order by purpose;


-- 30 Home Ownership 
select Home_Ownership,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from loans 
group by home_ownership
order by home_ownership;