-- ============================================================================
-- Week 2: Multi-National Retail Data Warehouse Schema (Star Schema)
-- Track: Business Intelligence Data Engineer
-- ============================================================================

-- 1. Date Dimension (Pre-populated Calendar Grain)
CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY,               -- Format: YYYYMMDD
    full_date DATE NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    calendar_month VARCHAR(15) NOT NULL,
    calendar_quarter INT NOT NULL,
    calendar_year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_holiday BOOLEAN DEFAULT FALSE
);

-- 2. Store & Geography Dimension (Multi-National Operational Footprint)
CREATE TABLE Dim_Store (
    store_key SERIAL PRIMARY KEY,
    store_id VARCHAR(50) NOT NULL,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    country_code CHAR(2) NOT NULL,
    currency_code CHAR(3) NOT NULL,
    store_type VARCHAR(30) DEFAULT 'Physical'
);

-- 3. Product Dimension (Categorical Taxonomy)
CREATE TABLE Dim_Product (
    product_key SERIAL PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    sub_category VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    standard_cost_usd NUMERIC(12, 2) NOT NULL,
    list_price_usd NUMERIC(12, 2) NOT NULL
);

-- 4. Customer Dimension (SCD Type 2 Architecture for History Tracking)
CREATE TABLE Dim_Customer (
    customer_key SERIAL PRIMARY KEY,        -- Surrogate Key
    customer_id VARCHAR(50) NOT NULL,       -- Natural / Business Key
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email_hashed CHAR(64) NOT NULL,         -- SHA-256 for GDPR/Data Privacy
    residence_country VARCHAR(50) NOT NULL,
    tier VARCHAR(20) DEFAULT 'Standard',
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_dim_customer_lookup ON Dim_Customer(customer_id, is_current);

-- 5. Central Fact Table (Atomic Transaction Grain)
CREATE TABLE Fact_Retail_Sales (
    sales_fact_id BIGSERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES Dim_Date(date_key),
    store_key INT NOT NULL REFERENCES Dim_Store(store_key),
    product_key INT NOT NULL REFERENCES Dim_Product(product_key),
    customer_key INT NOT NULL REFERENCES Dim_Customer(customer_key),
    transaction_id VARCHAR(100) NOT NULL,
    
    -- Transactional Metrics (Additive / Semi-Additive)
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
    local_currency_code CHAR(3) NOT NULL,
    unit_price_local NUMERIC(12, 2) NOT NULL,
    gross_revenue_local NUMERIC(12, 2) NOT NULL,
    exchange_rate_to_usd NUMERIC(10, 4) NOT NULL,
    gross_revenue_usd NUMERIC(12, 2) NOT NULL,
    discount_amount_usd NUMERIC(12, 2) DEFAULT 0.00,
    tax_amount_usd NUMERIC(12, 2) NOT NULL,
    net_revenue_usd NUMERIC(12, 2) NOT NULL,
    fulfillment_latency_hours NUMERIC(6, 2)
);

-- Optimization & FK Indexes on Fact Table
CREATE INDEX idx_fact_sales_date ON Fact_Retail_Sales(date_key);
CREATE INDEX idx_fact_sales_store ON Fact_Retail_Sales(store_key);
CREATE INDEX idx_fact_sales_product ON Fact_Retail_Sales(product_key);
CREATE INDEX idx_fact_sales_customer ON Fact_Retail_Sales(customer_key);
