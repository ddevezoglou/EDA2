-- Total IDs
select count(*) as total_content 
from netflix; 


-- Different types of movies 

select distinct type 
from netflix ; 

-- Count the Number of movies vs Tv Shows 

-- Total number of Movies and Tv Shows 
select type,count(*) as Total_Entries
from netflix 
where type="Movie"
union 
select type,count(*) as Total_Entries
from netflix 
where type="TV Show";



-- Most Common rating for movies and TV Shows 

with Movie_Cte as (
select rating,count(*) as Counts_Movies 
from netflix 
where type="Movie"
group by rating 
order by Counts_Movies desc),
Tv_cte as (
select rating,count(*) as Counts_Tv
from netflix
where type="Tv Show"
group by rating
order by Counts_Tv desc )
select Movie_Cte.rating,Counts_Movies,Counts_Tv
from movie_cte join tv_cte 
on Movie_Cte.rating=Tv_Cte.rating
;




-- List all movies released in a specific year (2020)



select title 
from netflix
where release_year=2020 and type="Movie"; 



-- Identify the longest movie or Tv Show duration 

select rtrim(left(duration,3))
from netflix 
where type="Movie";




-- We need to do some cleanup 

-- Always perform changes at a copy table

create table netflix_copy as 
select title,type,duration from netflix;


alter table netflix_copy 
add column duration_int INT default null;

-- Find the duration of all movies 
update netflix_copy 
set duration_int=rtrim(left(duration,3))
where type="Movie" and left(duration,2)>10;

-- Select Title with Max duration 
select title,duration
from netflix_copy  
where type="Movie" and 
duration_int=(select max(duration_int) from netflix_copy); 


-- Find the content added in the last 5 years ( database is from 2021)

select title,type 
from netflix 
where release_year>=2016;

-- Directed by .....  

select *
from netflix 
where director regexp "Rajiv Chilaka";



-- List all Tv shows with more than 5 seasons
-- Set new column for tv shows 
alter table netflix_copy 
add column duration_seasons INT default null;


-- Set columns
update netflix_copy 
set duration_seasons=rtrim(left(duration,2))
where type="Tv Show";

 -- Final Product 
select title,duration
from netflix_copy  
where type="Tv Show" and 
duration_seasons>5
order by duration_seasons desc;


-- Count by Gender
select listed_in,count(*) as Count_By_Gender
from netflix
group by listed_in
order by Count_By_Gender desc;



-- Find each year and the average numbers of content release in India

select avg(title) as Avg_Number_Releases,release_year 
from netflix 
where country="India" and release_year>2007
group by release_year
order by Avg_Number_Releases desc
limit 5;




-- List all movies that are documentaries 

select title,listed_in
from netflix
where type="Movie" and listed_in regexp "Documentaries";




-- List all content without a director 


select title
from netflix
where director="";


-- Find how many movies Salman Khan appeared in last 10 years 
-- Db is from 2021 so we think 2011

select title
from netflix
where cast regexp "Salman Khan" and release_year>=2011;



-- Top 10 Actors who have appeared in the highest number of movies produced in India



select  LENGTH(cast) - LENGTH(REPLACE(cast, ',', '')) AS comma_count
from netflix
where country="India" and cast<>"";


-- Create two labels, Good and Bad based on the Description. Then count how much content falls in those categories
with all_cte as(
select title, 
case when description regexp "kill|violence" then "Bad"
else "Good"
end as Categorize
from netflix
)
select count(*) as Counts,Categorize
from all_cte 
group by categorize;


-- Find top 5 Countries with most content on Netflix


select count(*),
    SUBSTRING_INDEX(country, ',',n) as country_value_split
FROM
    netflix
CROSS JOIN (
    SELECT @rownum := @rownum + 1 AS n
    FROM (SELECT @rownum := 0) r
) AS numbers
where country<>""
group by SUBSTRING_INDEX(country, ',',n)
order by count(*) desc
limit 5;




