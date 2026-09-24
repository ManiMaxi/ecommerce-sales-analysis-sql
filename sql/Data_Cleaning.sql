USE ecommerce_analysis;

-- Data Cleaning

select * from customers;
select * from products;
select * from orders;
select * from order_items;
select * from payments;

create table customer_cleaning like customers;
insert into customer_cleaning select * from customers;
select * from customer_cleaning;

-- Remove duplicates
with duplicate_cte as(
select customer_id,row_number() over(partition by customer_name,city,state,signup_date) as row_num from customer_cleaning)
select customer_id from duplicate_cte where row_num>1;
delete from customer_cleaning where customer_id in(select customer_id from
(select customer_id,row_number() over(partition by customer_name,city,state,signup_date) as row_num from customer_cleaning) 
as duplicates where row_num>1);

create table product_cleaning like products;
insert into product_cleaning select * from products;
select * from product_cleaning;

with duplicate_cte as(
select product_id,row_number() over(partition by product_name,category,cost_price,selling_price) as row_num from product_cleaning)
select product_id from duplicate_cte where row_num>1;
delete from product_cleaning where product_id in(select product_id from
(select product_id,row_number() over(partition by product_name,category,cost_price,selling_price) as row_num 
from product_cleaning) as duplicates where row_num>1);

create table order_cleaning like orders;
insert into order_cleaning select * from orders;
select * from order_cleaning;
create table order_items_cleaning like order_items;
insert into order_items_cleaning select * from order_items;
select * from order_items_cleaning;
create table payment_cleaning like payments;
insert into payment_cleaning select * from payments;

-- Standarize the data

select * from customer_cleaning;
select distinct city from customer_cleaning;
select distinct state from customer_cleaning;
select distinct signup_date from customer_cleaning;
update customer_cleaning set
	customer_name=concat(
		upper(left(substring_index(trim(customer_name), ' ',1),1)),
		lower(substring(substring_index(trim(customer_name), ' ',1),2)),
		' ',
		upper(left(substring_index(trim(customer_name),' ',-1),1)),
		lower(substring(substring_index(trim(customer_name),' ',-1),2))
		),
	city=case
		when lower(trim(city))='chennai' then 'Chennai'
	    when lower(trim(city))='madurai' then 'Madurai'
        when lower(trim(city))='salem' then 'Salem'
        when lower(trim(city))='mumbai' then 'Mumbai'
        when lower(trim(city))='kochi' then 'Kochi'
        when lower(trim(city))='coimbatore' then 'Coimbatore'
        when lower(trim(city))='tiruchirappalli' then 'Trichy'
        when lower(trim(city))='pune' then 'Pune'
        when lower(trim(city))='bengaluru' then 'Bengaluru'
        when lower(trim(city))='hyderbad' then 'Hyderbad'
        when lower(trim(city))='delhi' then 'Delhi'
        else city
        end,
	state=case
		when lower(trim(state)) in ('tamil nadu','tn') then 'Tamil Nadu'
        when lower(trim(state)) in ('maharashtra','mh') then 'Maharashtra'
        when lower(trim(state)) in ('kerala','kl') then 'Kerala'
        when lower(trim(state)) in ('delhi','dl') then 'Tamil Nadu'
        when lower(trim(state)) in ('karnataka','ka') then 'Karnataka'
        when lower(trim(state)) in ('telangana','ts') then 'Telangana'
        else state
        end,
	signup_date=case
		when signup_date like '____-__-__' then str_to_date(signup_date,'%Y-%m-%d')
        when signup_date like '____/__/__' then str_to_date(signup_date,'%Y/%m/%d')
        when signup_date like '__-__-____' then str_to_date(signup_date,'%d-%m-%Y')
        when signup_date like '__/__/____' then str_to_date(signup_date,'%d/%m/%Y')
        else signup_date
        end;
select * from customer_cleaning;
select distinct city from customer_cleaning;
select distinct state from customer_cleaning;
select distinct signup_date from customer_cleaning;


select * from product_cleaning;

select distinct product_name from product_cleaning;
UPDATE product_cleaning
SET product_name = CASE
    WHEN LOWER(TRIM(product_name)) = 'wireless mouse' THEN 'Wireless Mouse'
    WHEN LOWER(TRIM(product_name)) = 'bluetooth speaker' THEN 'Bluetooth Speaker'
    WHEN LOWER(TRIM(product_name)) = 'usb-c hub' THEN 'USB-C Hub'
    WHEN LOWER(TRIM(product_name)) = 'power bank' THEN 'Power Bank'
    WHEN LOWER(TRIM(product_name)) = 'wireless earbuds' THEN 'Wireless Earbuds'
    WHEN LOWER(TRIM(product_name)) = 'mechanical keyboard' THEN 'Mechanical Keyboard'
    WHEN LOWER(TRIM(product_name)) = 'laptop stand' THEN 'Laptop Stand'
    WHEN LOWER(TRIM(product_name)) = 'smart watch' THEN 'Smart Watch'
    WHEN LOWER(TRIM(product_name)) = 'portable ssd' THEN 'Portable SSD'
    WHEN LOWER(TRIM(product_name)) = 'phone charger' THEN 'Phone Charger'
    WHEN LOWER(TRIM(product_name)) = 'gaming mouse' THEN 'Gaming Mouse'
    WHEN LOWER(TRIM(product_name)) = 'wifi router' THEN 'WiFi Router'
    WHEN LOWER(TRIM(product_name)) = 'led monitor' THEN 'LED Monitor'
    WHEN LOWER(TRIM(product_name)) = 'electrical kettle' THEN 'Electrical Kettle'
    WHEN LOWER(TRIM(product_name)) = 'mixer grinder' THEN 'Mixer Grinder'
    WHEN LOWER(TRIM(product_name)) = 'water bottle' THEN 'Water Bottle'
    WHEN LOWER(TRIM(product_name)) = 'lunch box' THEN 'Lunch Box'
    WHEN LOWER(TRIM(product_name)) = 'frying pan' THEN 'Frying Pan'
    WHEN LOWER(TRIM(product_name)) = 'coffee maker' THEN 'Coffee Maker'
    WHEN LOWER(TRIM(product_name)) = 'bedsheet set' THEN 'Bedsheet Set'
    WHEN LOWER(TRIM(product_name)) = 'vaccum flask' THEN 'Vacuum Flask'
    WHEN LOWER(TRIM(product_name)) = 'nonstick tawa' THEN 'Nonstick Tawa'
    WHEN LOWER(TRIM(product_name)) = 'desk organizer' THEN 'Desk Organizer'
    WHEN LOWER(TRIM(product_name)) = 'men casual shirt' THEN 'Men Casual Shirt'
    WHEN LOWER(TRIM(product_name)) = 'women kurta' THEN 'Women Kurta'
    WHEN LOWER(TRIM(product_name)) = 'running shoes' THEN 'Running Shoes'
    WHEN LOWER(TRIM(product_name)) = 'backpack' THEN 'Backpack'
    WHEN LOWER(TRIM(product_name)) = 'wallet' THEN 'Wallet'
    WHEN LOWER(TRIM(product_name)) = 'sunglasses' THEN 'Sunglasses'
    WHEN LOWER(TRIM(product_name)) = 'sports t-shirt' THEN 'Sports T-Shirt'
    WHEN LOWER(TRIM(product_name)) = 'handbag' THEN 'Handbag'
    WHEN LOWER(TRIM(product_name)) = 'denim jeans' THEN 'Denim Jeans'
    WHEN LOWER(TRIM(product_name)) = 'sneakers' THEN 'Sneakers'
    WHEN LOWER(TRIM(product_name)) = 'formal belt' THEN 'Formal Belt'
    WHEN LOWER(TRIM(product_name)) = 'cotton saree' THEN 'Cotton Saree'
    WHEN LOWER(TRIM(product_name)) = 'hoodie' THEN 'Hoodie'
    WHEN LOWER(TRIM(product_name)) = 'travel duffel bag' THEN 'Travel Duffel Bag'
    WHEN LOWER(TRIM(product_name)) = 'face wash' THEN 'Face Wash'
    WHEN LOWER(TRIM(product_name)) = 'moisturizer' THEN 'Moisturizer'
    WHEN LOWER(TRIM(product_name)) = 'shampoo' THEN 'Shampoo'
    WHEN LOWER(TRIM(product_name)) = 'hair serum' THEN 'Hair Serum'
    WHEN LOWER(TRIM(product_name)) = 'sunscreen' THEN 'Sunscreen'
    WHEN LOWER(TRIM(product_name)) = 'body lotion' THEN 'Body Lotion'
    WHEN LOWER(TRIM(product_name)) = 'perfume' THEN 'Perfume'
    WHEN LOWER(TRIM(product_name)) = 'trimmer' THEN 'Trimmer'
    WHEN LOWER(TRIM(product_name)) = 'hair dryer' THEN 'Hair Dryer'
    WHEN LOWER(TRIM(product_name)) = 'lip balm' THEN 'Lip Balm'
    WHEN LOWER(TRIM(product_name)) = 'face serum' THEN 'Face Serum'
    WHEN LOWER(TRIM(product_name)) = 'conditioner' THEN 'Conditioner'
    WHEN LOWER(TRIM(product_name)) = 'body wash' THEN 'Body Wash'
    WHEN LOWER(TRIM(product_name)) = 'makeup kit' THEN 'Makeup Kit'
    WHEN LOWER(TRIM(product_name)) = 'electric toothbrush' THEN 'Electric Toothbrush'
    WHEN LOWER(TRIM(product_name)) = 'data analytics handbook' THEN 'Data Analytics Handbook'
    WHEN LOWER(TRIM(product_name)) = 'notebook set' THEN 'Notebook Set'
    WHEN LOWER(TRIM(product_name)) = 'gel pen pack' THEN 'Gel Pen Pack'
    WHEN LOWER(TRIM(product_name)) = 'desk planner' THEN 'Desk Planner'
    WHEN LOWER(TRIM(product_name)) = 'sticky notes set' THEN 'Sticky Notes Set'
    WHEN LOWER(TRIM(product_name)) = 'calculator' THEN 'Calculator'
    WHEN LOWER(TRIM(product_name)) = 'highlighter pack' THEN 'Highlighter Pack'
    WHEN LOWER(TRIM(product_name)) = 'sketch book' THEN 'Sketch Book'
    WHEN LOWER(TRIM(product_name)) = 'office file set' THEN 'Office File Set'
    WHEN LOWER(TRIM(product_name)) = 'business analytics book' THEN 'Business Analytics Book'
    WHEN LOWER(TRIM(product_name)) = 'excel guide book' THEN 'Excel Guide Book'
    WHEN LOWER(TRIM(product_name)) = 'power bi guide' THEN 'Power BI Guide'
    WHEN LOWER(TRIM(product_name)) = 'whiteboard marker set' THEN 'Whiteboard Marker Set'
    WHEN LOWER(TRIM(product_name)) = 'journal' THEN 'Journal'
    WHEN LOWER(TRIM(product_name)) = 'cap'THEN 'Cap'
    ELSE product_name
END,
	category=CASE
    WHEN LOWER(TRIM(category))='electronics' then 'Electronics'
    WHEN LOWER(TRIM(category))='home & kitchen' then 'Home & Kitchen'
    WHEN LOWER(TRIM(category))='fashion' then 'Fashion'
    WHEN LOWER(TRIM(category))='beauty & personal care' then 'Beauty & Personal Care'
    WHEN LOWER(TRIM(category))='books & stationery' then 'Books & Stationery'
    ELSE category
END;
select * from product_cleaning;

select * from order_cleaning;
select distinct order_status from order_cleaning;
select distinct payment_method from order_cleaning;
UPDATE order_cleaning 
SET order_date=case
	WHEN order_date LIKE '____-__-__'  then str_to_date(order_date,'%Y-%m-%d')
    WHEN order_date LIKE '__-__-____'  then str_to_date(order_date,'%d-%m-%Y')
    WHEN order_date LIKE '____/__/__'  then str_to_date(order_date,'%Y/%m/%d')
    WHEN order_date LIKE '__/__/____'  then str_to_date(order_date,'%d/%m/%Y')
    ELSE order_date
END,
	order_status=CASE
    WHEN LOWER(TRIM(order_status))='pending' then 'Pending'
    WHEN LOWER(TRIM(order_status))='delivered' then 'Delivered'
    WHEN LOWER(TRIM(order_status))='cancelled' then 'Cancelled'
    WHEN LOWER(TRIM(order_status))='returned' then 'Returned'
    ELSE order_status
END,
	payment_method=CASE
    WHEN LOWER(TRIM(payment_method))='net banking' then 'Net Banking'
    WHEN LOWER(TRIM(payment_method))='cod' then 'COD'
    WHEN LOWER(TRIM(payment_method))='credit card' then 'Credit Card'
    WHEN LOWER(TRIM(payment_method))='upi' then 'UPI'
    WHEN LOWER(TRIM(payment_method))='debit card' then 'Debit Card'
    else payment_method
end;
select * from order_cleaning;


select * from order_items_cleaning;

select * from payment_cleaning;
Update payment_cleaning 
SET payment_date=case
	WHEN payment_date LIKE '____-__-__'  then str_to_date(payment_date,'%Y-%m-%d')
    WHEN payment_date LIKE '__-__-____'  then str_to_date(payment_date,'%d-%m-%Y')
    WHEN payment_date LIKE '____/__/__'  then str_to_date(payment_date,'%Y/%m/%d')
    WHEN payment_date LIKE '__/__/____'  then str_to_date(payment_date,'%d/%m/%Y')
    ELSE payment_date
END,
	payment_method=CASE
    WHEN LOWER(TRIM(payment_method))='net banking' then 'Net Banking'
    WHEN LOWER(TRIM(payment_method))='cod' then 'COD'
    WHEN LOWER(TRIM(payment_method))='credit card' then 'Credit Card'
    WHEN LOWER(TRIM(payment_method))='upi' then 'UPI'
    WHEN LOWER(TRIM(payment_method))='debit card' then 'Debit Card'
    else payment_method
end,
	payment_status=CASE
    WHEN LOWER(TRIM(payment_status))='pending' then 'Pending'
    WHEN LOWER(TRIM(payment_status))='paid' then 'Paid'
    WHEN LOWER(TRIM(payment_status))='refunded' then 'Refunded'
    WHEN LOWER(TRIM(payment_status))='failed' then 'Failed'
    ELSE payment_status
end;

select * from payment_cleaning;

-- Handling null values
select * from customer_cleaning;
select * from customer_cleaning where customer_name=''or city='' or state='' or signup_date='';
update customer_cleaning set city= 'Unknown' where city='';
select * from customer_cleaning where state='';
select distinct city from customer_cleaning;
update customer_cleaning 
set state=case
	when city in ('Chennai','Madurai','Salem','Coimbatore','Trichy') then 'Tamil Nadu'
    when city ='Kochi' then 'Kerala'
    when city in ('Mumbai','Pune') then 'Maharashtra'
    when city='Delhi' then 'Delhi'
    when city='Hyderabad' then 'Telangana'
    when city='Bengaluru' then 'Karnataka'
    else state
end;
update customer_cleaning set city=Null where trim(city)='';
update customer_cleaning set customer_name=Null where trim(customer_name)='';
update customer_cleaning set signup_date=Null where trim(signup_date)='';
SELECT
    COUNT(*) AS total_rows,
    SUM(customer_name IS NULL) AS missing_name,
    SUM(city='Unknown') AS missing_city,
    SUM(state IS NULL) AS missing_state,
    SUM(signup_date IS NULL) AS missing_signup_date
FROM customer_cleaning;

select * from product_cleaning;
select * from product_cleaning where product_name is Null;
select distinct category from product_cleaning;
update product_cleaning set category='Books & Stationery' where product_name in ('Data Analytics Handbook','Whiteboard marker set');
update product_cleaning set product_name=Null where trim(product_name)='';
update product_cleaning p join products b on p.product_id=b.product_id set p.product_name=b.product_name;

select * from order_cleaning;
select * from order_cleaning where order_status is null or payment_method is null;
update order_cleaning set order_status=Null where order_status='';
update order_cleaning set payment_method=Null where trim(payment_method)='';

select count(*) as total_rows,
	   sum(order_status is Null) as missing_order_status,
       sum(payment_method is Null) as missing_payment_method from order_cleaning;

select * from order_items_cleaning;
select * from order_items_cleaning where trim(quantity)='' or trim(unit_price)='' or trim(discount)='';

select * from payment_cleaning;
select * from payment_cleaning where trim(payment_date)='' or trim(payment_method)='' or trim(payment_status)='';
update payment_cleaning set payment_date=Null where trim(payment_date)='';
update payment_cleaning set payment_method=Null where trim(payment_method)='';
update payment_cleaning set payment_status=Null where trim(payment_status)='';

select count(*) as total_rows,
	   sum(payment_date is null) as missing_payment_date,
       sum(payment_method is null) as missing_payment_method,
       sum(payment_status is null) as missing_payment_status 
from payment_cleaning;

-- fix data types and formats
describe customer_cleaning;
alter table customer_cleaning modify column signup_date DATE;
describe product_cleaning;
describe order_cleaning;
alter table order_cleaning modify column order_date DATE;
describe order_items_cleaning;
describe payments;
alter table payment_cleaning modify column payment_date DATE;
