use swiggycasestudy;

SELECT * FROM swiggycasestudy.delivery_partner;
SELECT * FROM swiggycasestudy.food;
SELECT * FROM swiggycasestudy.order_details;
SELECT * FROM swiggycasestudy.orders;
SELECT * FROM swiggycasestudy.restaurants;
SELECT * FROM swiggycasestudy.`zomato-schema - users`;
SELECT * FROM swiggycasestudy.`zomato-schema - menu`;

-- 1)Find customers who have never ordered

select name
from `zomato-schema - users`
where user_id not in (select user_id from orders);


-- 2) Avarage price per dish

select avg(price) ,f_name
from `zomato-schema - menu` m
join food f
on m.f_id = f.f_id
group by f_name;


-- 3)Find top restaurent in terms of no of orders for a given month

select r.r_name,count(*)
from orders o
join restaurants r
on o.r_id = r.r_id
where monthname(date) like 'may'
group by o.r_id,r.r_name
order by count(*) desc
limit 1;


-- 4) restaurants with monthly sales > 500 or x 

select sum(amount) as 'revenue',r.r_name
from orders o
join restaurants r
on o.r_id = r.r_id
where monthname(date) like 'june' 
group by r.r_name,r.r_id
having revenue > 500;

-- 5) show all orders with order details for a particular customer in a particular date range

select o.order_id,r_name,f_name,f.f_id
from orders o
join restaurants r
on o.r_id = r.r_id
join order_details od
on o.order_id = od.order_id
join food f
on f.f_id = od.f_id
where user_id =(select user_id from `zomato-schema - users`where name like 'Nitish')
and (date > '2022-06-10' and date < '2022-07-10');


-- 6) Find restaurants with max repeated customer

select r.r_name,count(*) as 'loyalcustomer'
from
(Select r_id,user_id, count(*) as 'visits'
from orders
group by r_id,user_id
having visits > 1
order by r_id) t
join restaurants r
on t.r_id = r.r_id
group by t.r_id,r.r_name
order by loyalcustomer desc
limit 1;

-- 7)month over month revenue growth of swiggy 

select month,revenue,((revenue -prev)/prev)*100 as 'growth' from(
with sales as
(select monthname(date) as 'month',sum(amount) as 'revenue'
from orders
group by month)
select month, revenue,lag(revenue,1) over (order by revenue) as 'prev'from sales
)t;

-- 8) Customer's Favorate food
with temp as
(select o.user_id,od.f_id,count(*) as 'frequency'
from orders o
join order_details od
on o.order_id = od.order_id
group by o.user_id,od.f_id)

select u.name,f.f_name,t1.frequency
from temp t1 
join `zomato-schema - users` as u
on t1.user_id = u.user_id
join food f
on t1.f_id = f.f_id
where t1.frequency =(
select max(frequency)
 from temp t2
 where t1.user_id = t2.user_id)














