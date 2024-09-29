-- Data CleanUP and fix Columns 


ALTER TABLE olympic_games.events MODIFY COLUMN 'Year' INT NULL;

select * 
from events 
where age ='NA';


update events 
set age=null 
where age="NA";

ALTER TABLE olympic_games.events MODIFY COLUMN age INT NULL;

-- We do the same for weight, height column 



update events 
set weight=null 
where weight ="NA";

update events 
set height=null 
where height="NA";



ALTER TABLE olympic_games.events MODIFY COLUMN weight INT NULL;
ALTER TABLE olympic_games.events MODIFY COLUMN height INT NULL;



update events 
set medal=null 
where medal="NA";


-- Dataset is ready to use, cleaned


-- In the events table there is a noc column 
-- In the regions table there is also a noc column 




-- 1. How many olympic games have been held?

select count(distinct games) as Total_Games
from events ;



-- 2. List down all olympic games held so far 
with cte_1 as (
select distinct games as Olympics,year
from events
order by games desc),
cte_2 as (select distinct year,season, city from events )
select distinct cte_1.year,season,city
from cte_1  join cte_2 
on cte_1.year=cte_2.year
order by year ;



-- 3. mention the total number of nations who participated in each olympic game

select games as Olympics,count(distinct r.region) as Nations
from events e left join regions r 
on e.noc=r.noc
group by games;




-- 4. Which year saw the highest and the lowest number of countries participating in olympics
with cte_1 as (select games as Olympics, count(distinct r.region) as Nations
from events e left join regions r 
on e.noc=r.noc
group by games),
cte_2 as(
select concat(Olympics,' - ',Nations) as highest_countries
from cte_1
where Nations=(select max(Nations) from cte_1) ),
cte_3 as (select concat(Olympics,' - ',Nations) as lowest_countries
from cte_1
where Nations=(select min(Nations) from cte_1) )
select cte_3.lowest_countries,cte_2.highest_countries
from cte_3 join cte_2


-- 5. Which nation has participated in all of the olympic games

select Team,count(distinct games) as Total_Participated_Games
from events e join regions r 
on e.noc=r.noc
group by team 
having count(distinct games)=(select count(distinct games) from events);


-- 6. Identify the sport which was played in all summer olympics 
select sport,count(distinct games) as Number_Of_Games,max(count(distinct games)) over() as Total_Games
from events 
where season='Summer' 
group by sport
having 
count(distinct games)=(select max(count(distinct games)) over() from events where season='Summer')
order by Number_Of_Games desc;





-- 7.Which Sports were just played only once in the olympics
-- Comment on this one:
-- Maybe it can be done with full group by mode,that gives as error here
with cte_1 as (
select distinct sport as Sport, count(distinct games) as Number_Of_Games
from events 
group by sport
having Number_Of_Games=1),
cte_2 as 
(select distinct sport, count(distinct games),games
from events 
group by sport,games
having count(distinct games)=1
)
select cte_1.Sport,Number_Of_Games,games
from cte_1  left join cte_2
on cte_1.Sport=cte_2.sport;


-- 8.Fetch the total no of sports played in each olympic games.
select distinct games,count(distinct sport) as Total_Sports
from events
group by games
order by Total_Sports desc;


-- 9.Fetch oldest athletes to win a gold medal
select Name,Sex,Age,Team,Games,City,Sport,Event,Medal
from events 
where age=(select max(age) from events where medal='Gold') and medal='Gold';




-- 10.Find the ratio of male and female atheles participated in all olympic games
with male_cte as(
select count(sex) as Males
from events
where sex='M'
),
female_cte as (select count(sex) as Females 
from events 
where sex='F'
)
select concat(round(Females/Females,0),' : ',round(Males/Females,2)) as ratio
from male_cte join female_cte;




-- 11.Fetch the top 15 athletes who have won the most gold medals.
with cte_1 as (
select name,count(medal) as Total_Gold_Medals
from events 
where medal='Gold'
group by name
order by Total_Gold_Medals desc),
cte_2 as (
select name,team
from events 
)
select distinct cte_1.Name,cte_2.team,cte_1.Total_Gold_Medals
from cte_1 left join cte_2
on cte_1.name=cte_2.name
order by Total_Gold_Medals desc 
limit 15;



-- 12.Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)

with cte_1 as (
select name,count(medal) as Total_Medals
from events 
group by name
order by Total_Medals desc),
cte_2 as (
select name,team
from events 
)
select distinct cte_1.Name,cte_2.team,cte_1.Total_Medals
from cte_1 left join cte_2
on cte_1.name=cte_2.name
order by Total_Medals desc 
limit 15;




-- 13.Fetch the top 5 most succesful(medals won) countries in olympics.

select Region,count(medal) as Total_Medals,row_number() over(order by count(medal) desc) as Ranking
from events e right join regions r 
on e.noc=r.noc
group by Region
order by Total_Medals desc
limit 5;


-- 14. List down total gold, silver and bronze medals won by each country.
with cte_1 as (
select region as Country 
from events e right join regions r 
on e.noc=r.noc 
),
cte_2 as (
select region as Country,count(medal) as Gold_Medals
from events e right join regions r 
on e.noc=r.noc 
where medal='Gold'
group by region),
cte_3 as (select region as Country,count(medal) as Silver_Medals
from events e right join regions r 
on e.noc=r.noc 
where medal='Silver'
group by region),
cte_4 as (select region as Country,count(medal) as Bronze_Medals
from events e right join regions r 
on e.noc=r.noc 
where medal='Bronze'
group by region)
select distinct cte_1.Country,cte_2.Gold_Medals,cte_3.Silver_Medals,cte_4.Bronze_Medals
from cte_1 left join cte_2 
on cte_1.Country=cte_2.Country
left join cte_3 
on cte_3.Country=cte_1.Country
left join cte_4
on cte_4.Country=cte_1.Country
order by Gold_Medals desc,Silver_Medals desc,Bronze_Medals desc






-- 15.List down total gold,silver,bronze medals won by each country 
-- correspondig to each game

select games, region as Country ,
sum(case when medal='Gold' then 1 else 0 end) as Gold,
sum(case when medal='Silver' then 1 else 0 end) as Silver, 
sum(case when medal='Bronze' then 1 else 0 end) as Bronze
from events e join regions r 
on e.noc=r.noc
group by games,region 
order by games ;



-- 16. Identify which country won the most medals in each olympic games

with cte_1 as (select games, region as Country ,
sum(case when medal='Gold' then 1 else 0 end) as Gold,
sum(case when medal='Silver' then 1 else 0 end) as Silver, 
sum(case when medal='Bronze' then 1 else 0 end) as Bronze
from events e join regions r 
on e.noc=r.noc
group by games,region 
order by games )
select 
distinct Games,
concat(first_value(Country) over(partition by Games order by Gold desc),' - ',
first_value(Gold) over (partition by Games order by Gold desc)) as Max_Gold,
concat(first_value(Country) over(partition by Games order by Silver desc),' - ',
first_value(Silver) over (partition by Games order by Silver desc)) as Max_Silver,
concat(first_value(Country) over(partition by Games order by Bronze desc),' - ',
first_value(Bronze) over (partition by Games order by Bronze desc)) as Max_Bronze
from cte_1
order by Games;


-- 17.Show also max medals 
with cte_1 as (select games, region as Country ,
sum(case when medal='Gold' then 1 else 0 end) as Gold,
sum(case when medal='Silver' then 1 else 0 end) as Silver, 
sum(case when medal='Bronze' then 1 else 0 end) as Bronze,
sum(case when medal<>'NA' then 1 else 0 end) as Medals
from events e join regions r 
on e.noc=r.noc
group by games,region 
order by games )
select 
distinct cte_1.Games,
concat(first_value(cte_1.Country) over(partition by cte_1.Games order by Gold desc),' - ',
first_value(Gold) over (partition by cte_1.Games order by Gold desc)) as Max_Gold,
concat(first_value(cte_1.Country) over(partition by cte_1.Games order by Silver desc),' - ',
first_value(Silver) over (partition by cte_1.Games order by Silver desc)) as Max_Silver,
concat(first_value(cte_1.Country) over(partition by cte_1.Games order by Bronze desc),' - ',
first_value(Bronze) over (partition by cte_1.Games order by Bronze desc)) as Max_Bronze,
concat(first_value(cte_1.Country) over(partition by cte_1.Games order by Medals desc),' - ',
first_value(Medals) over (partition by cte_1.Games order by Medals desc)) as Max_Medals
from cte_1
order by games







-- 18. Which Countries have never won gold medal but have won silver/bronze medals 
with cte_1 as (select region as Country ,
sum(case when medal='Gold' then 1 else 0 end) as Gold,
sum(case when medal='Silver' then 1 else 0 end) as Silver, 
sum(case when medal='Bronze' then 1 else 0 end) as Bronze
from events e join regions r 
on e.noc=r.noc
group by region 
)
select 
distinct Country,
Gold,
Silver,
Bronze
from cte_1
where Gold=0 and (Bronze>0 or Silver>0)
group by Country
order by Bronze desc,Silver 

-- 19.In which Sport/event, India has won the highest Medals
with cte_1 as (
select sport,count(medal) as Total_Medals
from events
where team='India'
group by sport)
select sport,Total_Medals
from cte_1
where Total_Medals=(select max(Total_Medals) from cte_1)
group by sport;





-- 20.Break down all games where India won medal for hockey, how many medals in each game
select Team,Sport,Games,count(medal)as Total_Medals
from events 
where team='India' and sport='Hockey'
group by games
order by Total_Medals desc;

 