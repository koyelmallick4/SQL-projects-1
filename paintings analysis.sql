use paintings;



-- 1) Fetch all the paintings which are not displayed on any museums?

select work_id ,name from work 
where museum_id is null;


-- 2) How many paintings have an asking price of more than their regular price? 

select count(*)
 from product_size
 where sale_price > regular_price;



-- 3) Identify the paintings whose asking price is less than 50% of its regular price


select p.work_id ,w.name
from product_size p
join work w 
on p.work_id = w.work_id
where regular_price/2 >sale_price;

-- 4) Which canva size costs the most?

select size_id ,regular_price
from product_size
order by regular_price desc
limit 1;


-- 5)Delete duplicate records from work, product_size, subject and image_link tables


SET SQL_SAFE_UPDATES = 0;

delete from work
where work_id in
(select work_id from (select work_id ,count(*) as duplicate 
from work
group by work_id
having duplicate >1) as temp);

SET SQL_SAFE_UPDATES = 1;




-- 6) Identify the museums with invalid city information in the given dataset

select name ,city
 from museum
 where city is null;


-- 7) Museum_Hours table has 1 invalid entry. Identify it and remove it.

select open,close from museum_hours 
where open =' 'and close =  ' ';



-- 8) Identify the museums which are open on both Sunday and Monday. Display museum name, city.

select mu.name,mu.city
from museum_hours mh1
join museum mu
on mh1.museum_id =mu.museum_id
where day ='sunday'
and exists (select * from museum_hours mh2 
           where mh2.museum_id = mh1.museum_id
           and mh2.day ='monday');
           
           
           
-- 9)How many museums are open every single day?

SELECT COUNT(*) AS museums_open_every_day
FROM (
    SELECT museum_id
    FROM museum_hours
    GROUP BY museum_id
    HAVING COUNT(DISTINCT day) = 7
) AS museums_open_7_days;




-- 10) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)

select count(work_id),w.museum_id,m.name
from work w
join museum m
on w.museum_id = m.museum_id
group by w.museum_id,m.name
order by count(work_id) desc
limit 5;



-- 11) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)

select count(work_id),a.full_name
 from work w
 join artist a
 on w.artist_id = a.artist_id
 group by a.full_name
order by count(work_id) desc
limit 5;



-- 12) Display the 3 least popular canva sizes

select count(work_id) as total_uses_of_size ,size_id
from product_size
group by size_id
order by count(work_id) desc
limit 3;


 

-- 13) Identify the artists whose paintings are displayed in multiple countries


select count(distinct m.country),a.full_name
from artist a
join work w
on a.artist_id = w.artist_id
join museum m
on w.museum_id = m.museum_id
group by a.full_name
having count(distinct m.country) > 1;




-- 14) Identify the artist and the museum where the most expensive and least expensive painting is placed.
--  Display the artist name, sale_price, painting name, museum name, museum city and canvas label


-- for most expensive painting
select p.sale_price as most_expensive,w.name as painting_name,m.name as museum_name,m.city,a.full_name as artist_name,c.label
from product_size p
join work w
on p.work_id = w.work_id
join museum m
on w.museum_id = m.museum_id
join artist a
on a.artist_id = w.artist_id
join canvas_size c
on c.size_id = p.size_id 
order by sale_price desc
limit 1;


-- least expensive painting

select p.sale_price as least_expensive,w.name as painting_name,m.name as museum_name,m.city,a.full_name as artist_name,c.label
from product_size p
join work w
on p.work_id = w.work_id
join museum m
on w.museum_id = m.museum_id
join artist a
on a.artist_id = w.artist_id
join canvas_size c
on c.size_id = p.size_id 
order by sale_price asc
limit 1;

-- 15) Which country has the 5th highest no of paintings?

select country ,no_of_paintings from 
(select count(w.work_id) as no_of_paintings,m.country
from work w
join museum m
on m.museum_id = w.museum_id
group by m.country
order by no_of_paintings desc
limit 5) as ranked_countries
order by no_of_paintings asc
limit 1;












