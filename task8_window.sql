CREATE TABLE sales (
    order_id VARCHAR(50),
    order_date DATE,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    category VARCHAR(50),
    product_name VARCHAR(150),
    sales DECIMAL(10,2)
);
CREATE DATABASE sales;
use sales;
show databases;
show tables;
INSERT INTO sales
(order_id, order_date, customer_name, region, category, product_name, sales)
VALUES
('O-101', '2023-01-05', 'Amit Kumar', 'East', 'Technology', 'Laptop', 45000);
INSERT INTO sales 
(order_id, order_date, customer_name, region, category, product_name, sales)
VALUES
('O-102', '2023-01-10', 'Amit Kumar', 'East', 'Technology', 'Mouse', 1200),
('O-103', '2023-01-15', 'Neha Sharma', 'East', 'Furniture', 'Chair', 8500),

('O-104', '2023-02-02', 'Rahul Verma', 'West', 'Technology', 'Laptop', 48000),
('O-105', '2023-02-05', 'Rahul Verma', 'West', 'Technology', 'Keyboard', 2500),
('O-106', '2023-02-12', 'Pooja Singh', 'West', 'Office Supplies', 'Paper', 1200),

('O-107', '2023-03-01', 'Suresh Rao', 'South', 'Furniture', 'Table', 15000),
('O-108', '2023-03-05', 'Suresh Rao', 'South', 'Furniture', 'Chair', 7000),
('O-109', '2023-03-12', 'Anjali Mehta', 'South', 'Technology', 'Tablet', 22000),

('O-110', '2023-04-03', 'Ravi Patel', 'North', 'Office Supplies', 'Pen', 500),
('O-111', '2023-04-07', 'Ravi Patel', 'North', 'Office Supplies', 'Notebook', 1800),
('O-112', '2023-04-15', 'Kiran Joshi', 'North', 'Technology', 'Printer', 16000);
select * from sales;
SELECT
    customer_name,
    region,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER (
        PARTITION BY region
        ORDER BY SUM(sales) DESC
    ) AS row_num
FROM sales
GROUP BY customer_name, region;
SELECT
    customer_name,
    region,
    SUM(sales) AS total_sales
FROM sales
GROUP BY customer_name, region;

SELECT
    customer_name,
    region,
    SUM(sales) AS total_sales,
    RANK() OVER (
        PARTITION BY region
        ORDER BY SUM(sales) DESC
    ) AS rank_val,
    DENSE_RANK() OVER (
        PARTITION BY region
        ORDER BY SUM(sales) DESC
    ) AS dense_rank_val
FROM sales
GROUP BY customer_name, region;

SELECT
    order_date,
    sales,
    SUM(sales) OVER (
        ORDER BY order_date
    ) AS running_total
FROM sales;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m-01') AS month,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY month
)
SELECT
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY month) AS mom_growth
FROM monthly_sales;

WITH product_sales AS (
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS rank_val
    FROM sales
    GROUP BY category, product_name
)
SELECT *
FROM product_sales
WHERE rank_val <= 3;




