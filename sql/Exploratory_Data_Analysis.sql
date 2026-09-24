-- Exploratory_Data_Analysis

-- 1.Dataset overview

-- Total customers
select count(distinct customer_id) as total_customers from customer_cleaning;

-- Total orders
select count(distinct order_id) from order_cleaning;

-- Total order items
select count(distinct order_item_id) from order_items_cleaning;

-- Total products
select count(distinct product_id) from product_cleaning;

-- Total payments
select count(distinct payment_id) from payment_cleaning;

-- 2. Customer exploration

-- Number of customers by state
select state,count(distinct customer_id) from customer_cleaning group by state;

-- Number of customers by city
select city,count(distinct customer_id) from customer_cleaning group by city;

-- Customer signup date range
select min(signup_date) as earliest_signup,max(signup_date) as latest_signup from customer_cleaning;

-- 3. Order exploration

-- Number of orders by order_status
select order_status, count(distinct order_id) as total from order_cleaning group by order_status order by total desc;

-- Number of orders by payment_method
select payment_method,count(distinct payment_id) as total from payment_cleaning group by payment_method order by total desc;

-- Order date range
select min(order_date) as earliest_order,max(order_date) as latest_order from customer_cleaning;

-- Number of orders by year
select year(order_date) as yearr,count(*) as total from order_cleaning group by year(order_date);

-- Number of orders by month
select year(order_date) as yearr,month(order_date) as monthh,count(*) as total from order_cleaning 
group by year(order_date),month(order_date) order by yearr,monthh;

-- 4. Product exploration

-- Number of products by category
select count(product_name) as product,category from product_cleaning group by category order by product desc;

-- Minimum, maximum, and average selling_price
select min(selling_price) as min_selling_price,max(selling_price) as max_selling_price,avg(selling_price) as avg_selling_price
from product_cleaning;

-- Minimum, maximum, and average cost_price
select min(cost_price) as min_cost_price,max(cost_price) as max_cost_price,avg(cost_price) as avg_cost_price
from product_cleaning;

-- Minimum, maximum, and average discount
select min(discount) as min_discount,max(discount) as max_discount,avg(discount) as avg_discount
from order_items_cleaning;

-- Minimum, maximum, and average quantity
select min(quantity) as min_quantity,max(quantity) as max_quantity,avg(quantity) as avg_quantity
from order_items_cleaning;

-- 5. Payment exploration

-- Number of payments by payment_status
select payment_status,count(distinct payment_id) as total_payments from payment_cleaning group by payment_status 
order by total_payments desc;

-- Number of payments by payment_method
select payment_method,count(distinct payment_id) as total_payments from payment_cleaning group by payment_method 
order by total_payments desc;

-- 6. Data relationship checks

-- Orders without a matching customer
select o.customer_id,o.order_id from order_cleaning o left join customer_cleaning c on o.customer_id=c.customer_id 
where c.customer_id is null;

-- Order items without a matching order
select oi.order_id,oi.order_item_id from order_items_cleaning oi left join order_cleaning o on oi.order_id=o.order_id 
where o.order_id is null;

-- Order items without a matching product
select o.order_item_id,o.product_id from order_items_cleaning o left join product_cleaning p on o.product_id=p.product_id
where p.product_id is null;

-- Payments without a matching order
select p.payment_id,p.order_id from payment_cleaning p left join order_cleaning o on p.order_id=o.order_id
where o.order_id is null;

-- 7. Data-quality checks

-- Duplicate primary-key values
   -- for customer table
select customer_id,count(*) as dup_count from customer_cleaning group by customer_id having count(*)>1;

   -- for product table
select product_id,count(*) as dup_count from product_cleaning group by product_id having count(*)>1;
    
   -- for order table
select order_id,count(*) as dup_count from order_cleaning group by order_id having count(*)>1;

   -- for order_item table
select order_item_id,count(*) as dup_count from order_items_cleaning group by order_item_id having count(*)>1;

   -- for payment table
select payment_id,count(*) as dup_count from payment_cleaning group by payment_id having count(*)>1;

-- NULL values

   -- for customer table
select * from customer_cleaning where customer_id is null or customer_name is null or 
city is null or state is null or signup_date is null;

   -- for product table
select * from product_cleaning where product_id is null or product_name is null or category is null or
cost_price is null or selling_price is null;

   -- for order table
select * from order_cleaning where order_id is null or customer_id is null or order_date is null or
order_status is null or payment_method is null;

   -- for order_item table
select * from order_items_cleaning where order_item_id is null or order_id is null or product_id is null or quantity is null or
unit_price is null or discount is null;

   -- for payment table
select * from payment_cleaning where payment_id is null or order_id is null or payment_date is null or payment_method is null or
payment_status is null;

-- Blank values

   -- for customer table
select * from customer_cleaning where trim(customer_name)='' or trim(city)='' or trim(state)='';

   -- for product table
select * from product_cleaning where trim(product_name) = '' or trim(category) = '';

   -- for order table
select * from order_cleaning where trim(order_status) = '' or trim(order_date) = '';

   -- for order_item table
select * from order_items_cleaning where trim(quantity) = '' or trim(selling_price) = '' or trim(discount) = '';

   -- for payment table
select * from payment_cleaning where trim(payment_method) = '' or trim(payment_status) = '';

-- N/A values

   -- for customer table
select * from customer_cleaning where customer_name = 'N/A' or city = 'N/A' or state = 'N/A';
   
   -- for product table
select * from product_cleaning where product_name = 'N/A' or category = 'N/A';
   
   -- for order table
select * from order_cleaning where order_status = 'N/A';
   
   -- for order_item table
select * from order_items_cleaning where 'N/A' in (quantity, selling_price, discount);

   -- for payment table
select * from payment_cleaning where payment_method = 'N/A' or payment_status = 'N/A';

-- Negative quantity
select * from order_items_cleaning where quantity < 0;

-- Negative price
select * from product_cleaning where selling_price < 0 or cost_price < 0;

-- Negative discount
select * from order_items_cleaning where discount < 0;

-- Selling price lower than cost price
select * from product_cleaning where selling_price < cost_price;