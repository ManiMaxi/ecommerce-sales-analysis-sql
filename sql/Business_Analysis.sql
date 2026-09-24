-- Business_Analysis

-- How many customers, orders, and products are in the dataset?
SELECT
	(SELECT COUNT(*) from customer_cleaning) AS total_customers,
    (SELECT COUNT(*) from order_cleaning) AS total_orders ,
    (SELECT COUNT(*) from product_cleaning) AS total_products ;
    
-- How many orders are delivered, cancelled, returned, and pending?
SELECT order_status,COUNT(order_status) as order_count FROM order_cleaning group by order_status; 

-- What percentage of orders are cancelled?
SELECT COUNT(CASE WHEN order_status='Cancelled' THEN 1 END) * 100/ COUNT(*) AS percentage_of_cancelled from order_cleaning;

-- What percentage of orders are pending?
SELECT COUNT(CASE WHEN order_status='Pending' THEN 1 END) * 100 / COUNT(*) AS percentage_of_pending from order_cleaning;

-- what percentage of orders are delivered?
SELECT COUNT(CASE WHEN order_status='Delivered' THEN 1 END) *100/COUNT(*) AS percentage_of_delivered from order_cleaning;

-- what percentage of orders are returned?
SELECT COUNT(CASE WHEN order_status='Returned' THEN 1 END)*100/count(*) AS percentage_of_returned from order_cleaning;

-- What is total revenue of orders
SELECT SUM(unit_price*quantity) as total_revenue_orders from order_items_cleaning;

-- What is the total revenue from completed/delivered orders?
SELECT SUM(i.unit_price*i.quantity) as total_revenue_of_delivered from order_items_cleaning i join order_cleaning e 
on i.order_id=e.order_id where e.order_status='Delivered';

-- What is the average order value?
with avg_order_valuee as(
SELECT e.order_id,SUM(i.unit_price*i.quantity) as total_revenue from order_items_cleaning i join order_cleaning e 
on i.order_id=e.order_id group by e.order_id)
select avg(total_revenue) as avg_order_value from avg_order_valuee;

-- Which payment methods are used most frequently?
select payment_method,count(payment_method) as most_freq_used from payment_cleaning 
group by payment_method order by most_freq_used desc;

-- Which cities generate the most orders and revenue?
select c.city,count(distinct o.order_id) as total_order,sum(ot.unit_price*ot.quantity) as total_revenue from customers c 
join order_cleaning o on c.customer_id=o.customer_id
join order_items_cleaning ot on o.order_id=ot.order_id group by c.city order by total_order desc;

-- Which product categories generate the most revenue?
select p.category,sum(o.unit_price*o.quantity) as total_revenue 
from product_cleaning p join order_items_cleaning o on p.product_id=o.product_id group by p.category order by total_revenue desc;

-- Which categories generate the most profit?
with dupcte as(
select p.category,sum(o.unit_price*o.quantity) as total_revenue,sum(p.cost_price*o.quantity) as total_costprice from product_cleaning p 
join order_items_cleaning o on p.product_id=o.product_id group by category)
select category,total_revenue-total_costprice as profit from dupcte group by category order by profit desc;

-- What are the top 10 products by revenue?
select p.product_name,sum(o.unit_price*o.quantity) as total_revenue from product_cleaning p 
join order_items_cleaning o on p.product_id=o.product_id group by p.product_name order by total_revenue desc limit 10;

-- Which products sold the most units?
select p.product_name,sum(o.quantity) as sold_units from product_cleaning p join order_items_cleaning o 
on p.product_id=o.product_id group by product_name order by sold_units desc;

-- Which products generate the highest profit?
with dupcte as(
select p.product_name,sum(o.unit_price*o.quantity) as total_revenue,sum(p.cost_price*o.quantity) as total_costprice 
from product_cleaning p join order_items_cleaning o on p.product_id=o.product_id group by product_name
)
select product_name,total_revenue-total_costprice as profits from dupcte group by product_name order by profits desc;

-- Which products have high sales but relatively low profit?
with dupcte as(
select p.product_name,sum(o.quantity) as sales,sum(o.unit_price*o.quantity) as total_revenue,
sum(p.cost_price*o.quantity) as total_costprice 
from product_cleaning p join order_items_cleaning o on p.product_id=o.product_id group by p.product_name
)
select product_name,sales,total_revenue,total_costprice,total_revenue-total_costprice as profits,
round((total_revenue-total_costprice)/total_revenue*100,2) as profit_margin
from dupcte group by product_name order by profit_margin;

-- Which products have high sales but relatively low profit?
with dupcte as(
select p.product_name,sum(o.quantity) as sales,sum(o.unit_price*o.quantity) as total_revenue,sum(p.cost_price*o.quantity) as total_cost
from product_cl]eaning p join order_items_cleaning o on p.product_id=o.product_id group by product_name)
select product_name,sales,total_revenue,total_cost,total_revenue-total_cost as profit, round(
(total_revenue-total_cost)/total_revenue*100,2) as profit_margin from dupcte order by profit_margin desc;

-- Who are the top 10 customers by total spending?
select * from customer_cleaning;
select c.customer_id,c.customer_name,sum(oi.unit_price*oi.quantity) as total_spending from customer_cleaning c 
join order_cleaning o on c.customer_id=o.customer_id join order_items_cleaning oi on o.order_id=oi.order_id 
where c.customer_id is not null and c.customer_name is not null and oi.unit_price is not null and oi.quantity is not null
group by c.customer_id,c.customer_name order by total_spending desc limit 10;

-- Which customers placed the most orders?
select c.customer_id,c.customer_name,count(order_id) as order_count from customer_cleaning c 
join order_cleaning o on c.customer_id=o.customer_id group by c.customer_id,c.customer_name order by order_count desc;

-- Which customers have made repeat purchases?
select c.customer_id,c.customer_name,count(o.order_id) as repeated_purchase from customer_cleaning c join order_cleaning o
on c.customer_id=o.customer_id group by c.customer_id,c.customer_name having count(o.order_id)>1;

-- Which customers have made only one purchase?
select c.customer_id,c.customer_name,count(o.order_id) as repeated_purchase from customer_cleaning c join order_cleaning o
on c.customer_id=o.customer_id group by c.customer_id,c.customer_name having count(o.order_id)=1;

-- Which customers registered but never placed an order?
select distinct c.customer_id,c.customer_name from customer_cleaning c join order_cleaning o on c.customer_id=o.customer_id 
where o.order_id is not Null;

-- What percentage of customers are repeat customers?
with dupcte as(
select c.customer_id,count(o.order_id) as order_count from customer_cleaning c 
left join order_cleaning o on c.customer_id=o.customer_id group by c.customer_id)
select 
	count(case when order_count>1 then 1 end) as repeated_customers,
    count(*) as total_customers,
    round(
    count(case when order_count>1 then 1 end) * 100.0/count(*),2) as per_rep_cus
    from dupcte;
    
-- How does revenue change month by month?
select year(o.order_date),month(o.order_date),sum(oi.unit_price*oi.quantity) as total_revenue from order_cleaning o join order_items_cleaning oi on 
o.order_id = oi.order_id group by year(o.order_date),month(o.order_date) order by year(o.order_date),month(o.order_date);

-- How does revenue change year by year
select year(o.order_date) as yearr,sum(oi.unit_price*oi.quantity) as yearly_revenue from order_cleaning o join
order_items_cleaning oi on o.order_id=oi.order_id group by year(o.order_date) order by yearr;

-- Which month generated the highest revenue?
with dupcte as(
select year(o.order_date) as yearr,month(o.order_date) as monthh,sum(oi.unit_price*oi.quantity) as total_revenue 
from order_cleaning o join order_items_cleaning oi on 
o.order_id = oi.order_id group by year(o.order_date),month(o.order_date) order by year(o.order_date),month(o.order_date)
)
select yearr,monthh,total_revenue as high_revenue from dupcte order by total_revenue desc limit 1;

-- Calculate month-over-month revenue growth
with monthly_revenue as(
select year(o.order_date)as yearr,month(o.order_date) as monthh,sum(oi.unit_price*oi.quantity) as current_revenue
from order_cleaning o join order_items_cleaning oi on o.order_id=oi.order_id group by year(o.order_date),month(o.order_date)
),
revenue_with_previous as(
select yearr,monthh,current_revenue,lag(current_revenue) over(order by yearr,monthh) as previous_revenue from monthly_revenue)
select yearr,monthh,current_revenue,previous_revenue,
round(((current_revenue-previous_revenue)/previous_revenue)*100,2) as month_over_month_revenue from revenue_with_previous;

-- Calculate year-over-year revenue growth

with yearly_revenue as
(select year(o.order_date) as yearr,sum(oi.unit_price*oi.quantity) as current_revenue from order_cleaning o join order_items_cleaning oi
on o.order_id=oi.order_id group by year(o.order_date)),
previous_revenue as(
select yearr,current_revenue,lag(current_revenue) over(order by yearr) as previous_year_revenue from yearly_revenue
)
select yearr,current_revenue,previous_year_revenue,round(((current_revenue-previous_year_revenue)/previous_year_revenue)*100,2)
as year_over_year_revenue from previous_revenue;

-- Calculate cumulative revenue over time
with monthly_revenue as(
select year(o.order_date) yearr,month(o.order_date) monthh,sum(oi.unit_price*oi.quantity) as current_revenue from order_cleaning o 
join order_items_cleaning oi on o.order_id=oi.order_id group by year(o.order_date),month(o.order_date)
)
select yearr,monthh,current_revenue,sum(current_revenue) 
over(order by yearr,monthh) as cumulative_revenue from monthly_revenue;

-- Rank products by revenue within each category
with dupcte as(
select p.product_name as product,p.category as category,sum(o.unit_price*o.quantity) as total_revenue from product_cleaning p 
join order_items_cleaning o on p.product_id=o.product_id group by p.category,p.product_name
)
select product,category,total_revenue,rank() over(partition by category order by total_revenue desc) as revenue_rank from dupcte;

-- Rank products by low revenue within each category
with dupcte as(
select p.product_name as product,p.category as category,sum(o.unit_price*o.quantity) as total_revenue from product_cleaning p 
join order_items_cleaning o on p.product_id=o.product_id group by p.category,p.product_name
)
select product,category,total_revenue,rank() over(partition by category order by total_revenue desc) as revenue_rank from dupcte;

-- Find the top 3 products in each category by revenue
with dupcte as(
select p.product_name as product,p.category as category,sum(o.unit_price*o.quantity) as total_revenue from product_cleaning p
join order_items_cleaning o on p.product_id=o.product_id group by p.category,p.product_name
),
rankk as(
select product,category,total_revenue,rank() over(partition by category order by total_revenue desc) as revenue_rank from dupcte
)
select product,category,total_revenue,revenue_rank from rankk where revenue_rank<=3;

-- Find the top 3 products in each category by revenue
with dupcte as(
select p.product_name as product,p.category as category,sum(o.unit_price*o.quantity) as total_revenue from product_cleaning p
join order_items_cleaning o on p.product_id=o.product_id group by p.category,p.product_name
),
rankk as(
select product,category,total_revenue,rank() over(partition by category order by total_revenue) as revenue_rank from dupcte
)
select product,category,total_revenue,revenue_rank from rankk where revenue_rank<=3;

-- Calculate each customer's total revenue
with dupcte as(
select c.customer_id,c.customer_name,sum(oi.unit_price*oi.quantity) as customer_revenue from customer_cleaning c 
join order_cleaning o on c.customer_id=o.customer_id join order_items_cleaning oi on o.order_id=oi.order_id
group by c.customer_id
)
select customer_id,customer_name,customer_revenue from dupcte order by customer_revenue desc;

-- Calculate each customer's percentage contribution to total revenue
with dupcte as(
select c.customer_id,c.customer_name,sum(oi.unit_price*oi.quantity) as customer_revenue from customer_cleaning c 
join order_cleaning o on c.customer_id=o.customer_id join order_items_cleaning oi on o.order_id=oi.order_id
group by c.customer_id
),
total_revenuee as(
select customer_id,customer_name,customer_revenue,sum(customer_revenue) over() as total_revenue from dupcte
)
select customer_id,customer_name,customer_revenue,total_revenue,round(customer_revenue/total_revenue*100,2) as revenue_contribution
from total_revenuee;

