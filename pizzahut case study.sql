use pizzahut;
-- Retrieve the total number of orders placed.

select count(order_id) as totalorder
from orders;

-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(price * quantity)) AS revenue
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id;

-- Identify the highest-priced pizza.

select p.price ,piz.name
from pizzas p
join pizzatype piz
on p.pizza_type_id = piz.pizza_type_id
order by p.price desc
limit 1;


-- Identify the most common pizza size ordered.

select count(order_details_id),p.size
from order_details o
join pizzas p
on p.pizza_id = o.pizza_id
group by p.size
order by count(order_details_id) desc
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select piz.name,sum(o.quantity) as total
from pizzas p 
join pizzatype piz
on p.pizza_type_id = piz.pizza_type_id
join order_details o
on p.pizza_id = o.pizza_id
group by piz.name
order by total  desc
limit 5;



-- Join the necessary tables to find the total quantity of each pizza category ordered.


select piz.category,sum(o.quantity) 
from pizzas p
join pizzatype piz
on p.pizza_type_id = piz.pizza_type_id
join order_details o
on p.pizza_id = o.pizza_id
group by piz.category;


-- Determine the distribution of orders by hour of the day.

select hour(order_time),count(order_id)
from orders
group by  hour(order_time);


-- Group the orders by date and calculate the average number of pizzas ordered per day.


SELECT 
    ROUND(AVG(quantity))
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.

select piz.name,sum(od.quantity * p.price) as revenue
from pizzas p 
join pizzatype piz
on p.pizza_type_id =piz.pizza_type_id
join order_details od
on p.pizza_id = od.pizza_id
group by piz.name
order by revenue desc
limit 3;



-- Join relevant tables to find the category-wise distribution of pizzas.

select piz.category,sum(quantity),count(order_id)
from pizzas p 
join pizzatype piz
on p.pizza_type_id =piz.pizza_type_id
join order_details od
on p.pizza_id = od.pizza_id
group by piz.category;




