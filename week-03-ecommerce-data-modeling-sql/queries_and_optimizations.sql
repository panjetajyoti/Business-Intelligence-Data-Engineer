-- ============================================================================
-- Week 3: E-Commerce Relational Data Modeling & Query Optimization
-- Track: Business Intelligence Data Engineer
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. BASE DDL: 3NF RELATIONAL SCHEMA
-- ----------------------------------------------------------------------------

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0
);

-- Partitioned Orders Table (By Month on order_date)
CREATE TABLE Orders (
    order_id BIGSERIAL NOT NULL,
    customer_id INT NOT NULL REFERENCES Customers(customer_id),
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (order_id, order_date)
) PARTITION BY RANGE (order_date);

-- Sample Monthly Partitions
CREATE TABLE orders_2026_q3 PARTITION OF Orders
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE orders_2026_q4 PARTITION OF Orders
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');

CREATE TABLE Order_Items (
    order_item_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    product_id INT NOT NULL REFERENCES Products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_at_purchase NUMERIC(10, 2) NOT NULL,
    line_total NUMERIC(10, 2) GENERATED ALWAYS AS (quantity * unit_price_at_purchase) STORED,
    FOREIGN KEY (order_id, order_date) REFERENCES Orders(order_id, order_date) ON DELETE CASCADE
);

CREATE TABLE Payments (
    payment_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id, order_date) REFERENCES Orders(order_id, order_date)
);

-- ----------------------------------------------------------------------------
-- 2. QUERY OPTIMIZATION INDEXES
-- ----------------------------------------------------------------------------

-- Covering Index for Monthly Sales Aggregations (Enables Index-Only Scan)
CREATE INDEX idx_orders_status_date_covering 
ON Orders(order_status, order_date) 
INCLUDE (total_amount);

-- B-Tree Indexes on Joining Foreign Keys to eliminate Full Table Scans
CREATE INDEX idx_order_items_product ON Order_Items(product_id);
CREATE INDEX idx_order_items_composite_order ON Order_Items(order_id, order_date);
CREATE INDEX idx_customers_email ON Customers(email);

-- ----------------------------------------------------------------------------
-- 3. CORE ANALYTICAL & TRANSACTIONAL SQL QUERIES
-- ----------------------------------------------------------------------------

-- Query A: Customer Purchase History & Summary
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id = 10042
ORDER BY o.order_date DESC;

-- Query B: Monthly Gross Revenue & Average Order Value (AOV)
SELECT 
    DATE_TRUNC('month', o.order_date) AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS gross_revenue,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM Orders o
WHERE o.order_status = 'Completed'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month DESC;

-- Query C: Top 5 Product Categories by Revenue (Analytical Window Function)
SELECT 
    p.category,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.line_total) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS revenue_rank
FROM Products p
INNER JOIN Order_Items oi ON p.product_id = oi.product_id
INNER JOIN Orders o ON oi.order_id = o.order_id AND oi.order_date = o.order_date
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY revenue_rank ASC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- 4. MATERIALIZED VIEW FOR EXECUTIVE DASHBOARDING
-- ----------------------------------------------------------------------------
CREATE MATERIALIZED VIEW mv_daily_sales_summary AS
SELECT 
    CAST(o.order_date AS DATE) AS sales_date,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_ticket_size
FROM Orders o
WHERE o.order_status = 'Completed'
GROUP BY CAST(o.order_date AS DATE);

CREATE UNIQUE INDEX idx_mv_daily_sales_date ON mv_daily_sales_summary(sales_date);
