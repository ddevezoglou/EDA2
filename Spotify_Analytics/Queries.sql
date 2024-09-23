-- We need to make some columns into boolean 

update spotify 
set Licensed =TRUE
where Licensed ="True";

update spotify 
set Licensed =FALSE
where Licensed ="False";


update spotify 
set official_video =TRUE
where official_video ="True";




update spotify 
set official_video =FALSE
where official_video ="False";


--              ---------------
--              |     Easy     |
--              ---------------

-- Retreive names of all tracks that have more than 1 billion streams. 
select track as Tracks 
from spotify 
where Stream>1000000000
order by Stream DESC

-- List all albums along with their respective artists 

select distinct Album, Artist 
from spotify 


-- Get the total number of comments for tracks where licensed=TRUE

select sum(Comments) as Total_Comments 
from spotify
where Licensed =TRUE



-- Find all the tracks that belong to the album type single
 select Track
 from spotify
 where Album_type="single"
 
 
 
 -- Count the total number of tracksby each artist 
 select count(Track) as Tracks,Artist
 from spotify 
 group by Artist 
 order by Tracks desc;
 


--              ---------------
--              |    Medium    |
--              ---------------
-- Clculate the average danceability of tracks in each album 


select round(avg(Danceability),2) as Avg_Dance,Album
from spotify 
group by Album 
order by Avg_Dance desc;



-- Find top 5 tracks with the highest energy values 
select Track 
from spotify
order by Energy desc
limit 5;



-- List all tracks along with their views and likes where they have official video
select distinct Track, Views, Likes
from spotify 
where official_video =true 
order by Likes desc;


-- For each album, calculate the total views of all associated tracks
select sum(Views) as Total_Album_Views,Album 
from spotify 
group by Album 
order by Total_Album_Views desc;




-- Retreive the track names that have been streamed on spotify more than youtube
select Track 
from spotify 
where most_playedon="Spotify";



--              ---------------
--              |    Hard     |
--              ---------------


-- Find the top 3 most viewd tracks for each artist
with ranked as (
select Artist,Track,Views, row_number() over (partition by Artist order by Views desc) as Track_rank
from spotify
)
select Artist,Track,Views,Track_rank
from ranked
where track_rank<=3
;


-- Find tracks where the liveness score is above the average
select Track,Liveness 
from spotify 
where Liveness >
(select avg(Liveness) 
from spotify)
order by Liveness desc; 





-- Difference between the highest and lowest energy values for tracks in eack album 
-- No constrains if an album contains only one song 
with max_cte as(select max(Energy) as Max_Energy,Album 
from spotify
where Album_type ="album"
group by Album),
min_cte as(select min(Energy) as Min_Energy,Album 
from spotify
where Album_type ="album"
group by Album)
select max_cte.Album,Max_Energy,Min_Energy,round((Max_Energy-Min_Energy),3)as Energy_Diff
from max_cte join min_cte 
on max_cte.Album=min_cte.Album;

-- With that constraint
with max_cte as(select max(Energy) as Max_Energy,Album 
from spotify
where Album_type ="album"
group by Album),
min_cte as(select min(Energy) as Min_Energy,Album 
from spotify
where Album_type ="album"
group by Album)
select max_cte.Album,Max_Energy,Min_Energy,round((Max_Energy-Min_Energy),3)as Energy_Diff
from max_cte join min_cte 
on max_cte.Album=min_cte.Album
where round((Max_Energy-Min_Energy),3)>0
order by Energy_Diff desc;


-- Find tracks where energy to liveness ratio >1.2
select Track,EnergyLiveness 
from spotify s 
where EnergyLiveness>1.2
order by EnergyLiveness desc;



-- Calculate the cumulative sum of likes for tracks ordered by the number of views
select row_number () over( order by Views desc),Likes,Track,sum(Likes) over ( order by Views desc) as Cumulative_Likes
from spotify; 

-- To see the final number of Cumulative_Likes
select row_number () over( order by Views desc),Likes,Track,sum(Likes) over ( order by Views desc) as Cumulative_Likes
from spotify 
limit 4 offset 20590


