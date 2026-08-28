DROP TABLE IF EXISTS pizzas

CREATE TABLE pizzas
(
pizza_id	varchar(50),
pizza_type_id	varchar(50),
size	varchar(50),
price	float
);

DROP TABLE IF EXISTS pizza_types
create table pizza_types
(
pizza_type_id	varchar(50),
name	varchar(150),
category	varchar(100),
ingredients	varchar(250)
);

create table orders
(
order_id int	primary key,
date	date,	
time	time	
);

create table order_details
(
order_details	int,
order_id	int,
pizza_id	varchar(100),
quantity	int
);

select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;

--BASIC:

--RETRIEVE THE TOTAL NUMBER OF ORDERS PLACED.

   select count(order_id) total_orders from orders;
   
--CALCULATE THE TOTAL REVENUE GENERATED FROM PIZZA SALES.

   select sum(price*quantity) total_revenue 
   from pizzas p join order_details od on p.pizza_id = od.pizza_id

--IDENTIFY THE HIGHEST-PRICED PIZZA.

  select max(price) highest_price from pizzas;
  
--IDENTIFY THE MOST COMMON PIZZA SIZE ORDERED.

   select  p.pizza_id , quantity,size 
   from pizzas p join order_details od on p.pizza_id = od.pizza_id
   group by p.pizza_id , quantity,size
   order by quantity desc
   limit 1;
   
--LIST THE TOP 5 MOST ORDERED PIZZA TYPES ALONG WITH THEIR QUANTITIES.

   select  p.pizza_id , quantity,name 
   from pizzas p join order_details od on p.pizza_id = od.pizza_id
   join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
   group by p.pizza_id , quantity,name
   order by quantity desc
   limit 5;
   
--INTERMEDIATE:

select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;

--JOIN THE NECESSARY TABLES TO FIND THE TOTAL QUANTITY OF EACH PIZZA CATEGORY ORDERED.

   select category, sum(quantity)
   from pizzas p join order_details od on p.pizza_id = od.pizza_id
   join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
   group by category;

--DETERMINE THE DISTRIBUTION OF ORDERS BY HOUR OF THE DAY.

   select extract(hour from time) hour_of_day,count(order_id) total_orders
   from orders
   group by hour_of_day;

--JOIN RELEVANT TABLES TO FIND THE CATEGORY-WISE DISTRIBUTION OF PIZZAS.

   select category, count(name) total_pizzas
   from pizza_types
   group by category;
   
--GROUP THE ORDERS BY DATE AND CALCULATE THE AVERAGE NUMBER OF PIZZAS ORDERED PER DAY.

  select avg(total_pizza_order) avg_pizza_ordered
  from (select date,sum(quantity) total_pizza_order
   from orders o join order_details od on o.order_id=od.order_id
   group by date) as d ;
   
--DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE.

    select name,sum(quantity*price) revenue
	from pizzas p join pizza_types pt on pt.pizza_type_id=p.pizza_type_id
	join order_details od on od.pizza_id=p.pizza_id
	group by name
	order by revenue desc
	limit 3;
	
--ADVANCED:

select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;

-- CALCULATE THE PERCENTAGE CONTRIBUTION OF EACH PIZZA TYPE TO TOTAL REVENUE.

     select name,(sum(quantity*price)) /(select sum(price*quantity) total_revenue 
   from pizzas p join order_details od on p.pizza_id = od.pizza_id
     )*100 revenue
	from pizzas p join pizza_types pt on pt.pizza_type_id=p.pizza_type_id
	join order_details od on od.pizza_id=p.pizza_id
	group by name
	order by revenue desc;
	
-- ANALYZE THE CUMULATIVE REVENUE GENERATED OVER TIME.

    select date, sum(revenue) over(order by date) cum_rev
	from(select date , sum(quantity*price) revenue
	from order_details od  join pizzas p on p.pizza_id=od.pizza_id
	join orders o on o.order_id=od.order_id
	group by date) sales;
	
-- DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE FOR EACH PIZZA CATEGORY.

    select name,revenue, rank, category
	from(select name,category , revenue , rank() over(partition by category order by revenue) rank
	 from (select name,category ,sum(quantity*price) revenue
	from pizzas p join pizza_types pt on pt.pizza_type_id=p.pizza_type_id
	join order_details od on od.pizza_id=p.pizza_id
	group by category,name
	order by revenue desc) a)
	where rank <=3;


	
