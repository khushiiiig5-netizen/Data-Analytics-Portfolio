create table zepto
(
id serial primary key,
category varchar(50),
name	varchar(250),
mrp	int,
discountpercent	int,
availablequantity	int,
discountsellingprice	int,
weightingms	int,
outofstock	boolean,
quantity	int
);

select * from zepto
ORDER BY id
limit 10;

--DIFFERENT PRODUCT CATEGORIES.
select distinct category
from zepto
order by category;
 
--PRODUCTS IN STOCK VS OUT OF STOCK.
SELECT outofstock, count(id)
from zepto
group by outofstock;

--PRODUCT NAMES PRESENT MULTIPLE TIMES.
SELECT name, count(id)  "no_of_id"
from zepto
group by name
having count(id) > 1
order by count(id) desc;

--DATA CLEANING

--DELETE DATA WHERE MRP IS 0.
delete from zepto
where mrp =0;

--CONVERT PAISA INTO RUPEES.
UPDATE zepto
set mrp=mrp/100,discountsellingprice =discountsellingprice/100;

--DATA ANALYSIS

-- Q1. FIND THE TOP 10 BEST-VALUE PRODUCTS BASED ON THE DISCOUNT PERCENTAGE.

 select * from zepto;

 select distinct name, mrp,discountpercent
 from zepto
 order by discountpercent desc
 limit 10;

--Q2.WHAT ARE THE PRODUCTS WITH HIGH MRP BUT OUT OF STOCK.

select distinct name , mrp
from zepto
where outofstock=true and mrp>300
order by mrp desc;

--Q3.CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY

select category,sum(discountsellingprice*availablequantity) revenue
from zepto
group by category
order by revenue;

-- Q4. FIND ALL PRODUCTS WHERE MRP IS GREATER THAN ₹500 AND DISCOUNT IS LESS THAN 10%.

select distinct name , mrp, discountpercent
from zepto
where mrp>500 and discountpercent<10
order by mrp,discountpercent desc;

-- Q5. IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE.

select category ,round(avg( discountpercent),2) avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

-- Q6. FIND THE PRICE PER GRAM FOR PRODUCTS ABOVE 100G AND SORT BY BEST VALUE.

select distinct name,discountsellingprice,weightingms,round(discountsellingprice/weightingms,2) price_per_gms
from zepto
where weightingms>100
order by price_per_gms desc;

--Q7.GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW, MEDIUM, BULK.

select distinct name, 
case when weightingms<1000 then 'low'
     when weightingms<5000 then 'medium'
     else 'bulk'
end as weight_category 	 
from zepto;

--Q8.WHAT IS THE TOTAL INVENTORY WEIGHT PER CATEGORY.

select category , sum(weightingms*availablequantity) total_inventory_weight
from zepto
group by category
order by total_inventory_weight desc;











