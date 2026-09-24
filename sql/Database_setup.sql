CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;
show tables;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    signup_date VARCHAR(20)
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(100),
    cost_price DECIMAL(10,2),
    selling_price DECIMAL(10,2)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date VARCHAR(20),
    order_status VARCHAR(50),
    payment_method VARCHAR(50),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(5,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date VARCHAR(20),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

select * from customers;
select * from products;
select * from orders;
select * from order_items;
select * from payments;