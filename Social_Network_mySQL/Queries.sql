-- How many users are there in each house?

select house,count(*) as count
from users 
group by house


-- List all the follwing links that were xreated before seprember 1st 1993 
select * 
from follows 
where `date`<'1993-09-01'


-- List all rows from the follos table, raplacing both user_id's with 
-- first name 


select u1.first_name as user_first,u2.first_name,f.`date` as date_created
from follows f join users u2 
on u2.user_id=f.follows 
join users u1 
on f.user_id=u1.user_id


-- List all the following links established before September 1st 1993,
-- but this time use the users first names. 


select u1.first_name as user_first,u2.first_name,f.`date` as date_created
from follows f join users u2 
on u2.user_id=f.follows 
join users u1 
on f.user_id=u1.user_id
where `date`<'1993-09-01'



-- Give a count of how many people followed each user as of 199-12-31. 
-- Give the results in terms of user full name, number of followers 

with cte_1 as (
select u.user_id,concat(u.first_name," ",u.last_name) as user_followed_name
from users u),
cte_2 as (select follows,count(user_id) as num_followers
from follows 
where `date`<='1999-12-31'
group by follows )
select cte_1.user_followed_name,
case when cte_2.num_followers>0 then cte_2.num_followers
else 0
end as num_followers
from cte_1 left join cte_2 on 
cte_1.user_id=cte_2.follows



-- List the number of each user follows 

with cte_1 as (
select u.user_id,concat(u.first_name," ",u.last_name) as user_name
from users u),
cte_2 as (select user_id,count(follows) as num_followed
from follows 
group by user_id)
select cte_1.user_name,
case when cte_2.num_followed>0 then num_followed
else 0
end as num_followed
from cte_1 left join cte_2
on cte_1.user_id=cte_2.user_id;


-- List all rows from follows where someone from one house follows someone from 
-- a different house 
with cte_1 as (
select u1.user_id,concat(u1.first_name," " ,u1.last_name) as username,
u1.house as user_house,
f.follows,
concat(u2.first_name," " ,u2.last_name) as follows_name,
u2.house as follows_house
from follows f join users u1 
on f.user_id=u1.user_id 
join users u2 
on f.follows=u2.user_id )
select username,user_house,follows_name,follows_house
from cte_1
where user_house != follows_house;




-- We define a friendship as a relationship between two users where both follow each other.
-- The friendship is established when the later of the two links is established.

select least(f1.user_id, f2.user_id) AS user_id,
greatest(f1.user_id, f2.user_id) AS follows,
max(greatest(f1.date, f2.date)) AS friendship_established
from follows f1 join follows f2 
on f1.follows= f2.user_id and f2.follows = f1.user_id
where f1.user_id < f2.user_id
group by least(f1.user_id, f2.user_id),greatest(f1.user_id, f2.user_id);




-- List all unrequited followings (i.e. where A follows B but B does not follow A)

select f1.user_id as follower, f1.follows as following
from follows f1
left join follows f2 
on f1.follows = f2.user_id  and f2.follows = f1.user_id
where f2.user_id is null