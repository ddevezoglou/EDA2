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




