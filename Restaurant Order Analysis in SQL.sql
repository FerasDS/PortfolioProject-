USE restaurant_db;

-- View the menu_items table
Select * from menu_items;

-- Find the number of items on the menu
Select count(*) from menu_items;

-- what are the least and most expensive items on the menu
-- Least
Select price
from menu_items
order by price;

-- Most
Select price
from menu_items
order by price desc;

-- How many italian dishes are on the menu
Select count(*) from menu_items
where category = "italian";

-- what are the least and most expensive italian dishes on the menu
Select * from menu_items
where category = "italian"
order by price;

Select * from menu_items
where category = "italian"
order by price desc;
-- How many dishes are in each catagory

select category, count(menu_item_id) as num_dishes 
from menu_items
group by category;

-- What is the average dish price within each catagory
select category, avg(price) As avg_price
from menu_items
group by category;

-- View the order_details table
Select * from order_details;

-- What is the date range of the table
Select min(order_date), max(order_date) from order_details;

-- How many items were ordered within this date range
select count(distinct order_id) from order_details;

-- Which orders had most number of items
select count(distinct order_id) from order_details;

-- Which orders had the most number of items
select order_id, count(item_id) as num_items from order_details
group by order_id
order by num_items desc;

-- How many orders had more than 12 items
select Count(*) from
(select order_id, count(item_id) as num_items
from order_details
group by order_id
having num_items > 12) as num_orders;

-- combine the menu_items and order_details tables into a single table
select * 
from order_details od left join menu_items mi
on od.item_id = mi.menu_item_id;
 
-- What were the least and most ordered items? What categories were they in?
select
item_name, category, count(order_details_id) as num_items from order_details as od left join menu_items as mi
on od.item_id = mi.menu_item_id
group by item_name, category
order by num_items desc;

-- what were the top 5 orders that spent the most money
select order_id, sum(price) As total_spend
from order_details od left join menu_items mi
	on od.item_id = mi.menu_item_id
Group by order_id
Order by total_spend desc
limit 5;


-- View the detailes of the top 5 highestet spend items. What insights can you gather from the results
select order_id, category, count(item_id) as num_items
from order_details od left join menu_items mi
	on od.item_id = mi.menu_item_id
where order_id in(440, 2075, 1957, 330, 2675)
group by order_id, category;


