-- How many candidates are in the candidate table
-- for the 2000 election

select * from candidate 
where year=2000;



-- How many candidates are in the candidate table
-- for each election from 184 to 2016


select `year`, count(*)
from candidate c 
where year between 1984 and 2016 
group by `year`;




-- For each election from 1984 to 2106, give the party that won
-- the popular vote 


with cte_1 as(
select  `Year`,sum(Democrat) as total_democrat,
sum(Republican) as total_republican,
sum(Other) as total_other
from election
where `Year` between 1984 and 2016
group by `Year`)
select `Year`,total_democrat,total_republican,total_other,
case when total_democrat >total_republican and total_democrat > total_other then 'democrat'
when total_republican>total_democrat and total_republican>total_other then 'republican' 
else 'other' 
end as winner
from cte_1;

-- Extension of previous question: for each election from 1984
-- to 2016,give the party that won the popular vote and the 
-- margin, assuming 'Other' is irrelevant

with cte_1 as(
select  `Year`,sum(Democrat) as total_democrat,
sum(Republican) as total_republican
from election
where `Year` between 1984 and 2016
group by `Year`)
select `Year`,
case when total_democrat>total_republican 
then total_democrat-total_republican 
else total_republican-total_democrat
end as margin,
case when total_democrat>total_republican 
then 'democrat'
else 'republican'
end as winner
from cte_1;


-- Which states have had fewer than 3 democratic victories
-- since 1952

with cte_1 as (
select state,'democrat' as winner, 
case when Democrat>Republican and Democrat>Other then 1
else 0 
end as democratic_victories
from election 
)
select state,winner,sum(democratic_victories) as num_democratic_victories
from cte_1
group by state
having sum(democratic_victories) < 3
order by 1 ;



-- Which states have had fewer than 3 republican victories since 1952?
-- Note: Since 1952 is the min(`year`) query does not require to check for the `year`

with cte_1 as (
select state,'republican' as winner, 
case when Republican>Democrat and Republican>Other then 1
else 0 
end as republican_victories
from election 
)
select state,winner,sum(republican_victories) as num_republican_victories
from cte_1
group by state
having sum(republican_victories) < 3 ;




-- Find the states where all of the elections since 1988 (including 1988) have been 
-- won by the same party.
with cte_1 as(
select state, 
case when Democrat>Republican then 1
else 0
end as winners_dem,
case when Republican>Democrat then 1 
else 0 
end as winners_rep
from election 
where `year`>=1988)
select state, 
case when sum(winners_dem)=0 then 'republican'
when sum(winners_rep)=0 then 'democrat'
end as winner
from cte_1
group by state
having winner is not null 
order by 2 