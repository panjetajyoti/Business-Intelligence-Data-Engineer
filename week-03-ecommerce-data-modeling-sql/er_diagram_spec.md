# Week 3: Conceptual & Logical Data Model Specification (E-Commerce)

## 1. Relational Architecture (3NF)
This data model handles high-concurrency OLTP transactional workflows while supporting analytical aggregation without data duplication.

### Entity & Cardinality Relationships
```text
 [CUSTOMERS] (1) <------- (N) [ORDERS] (1) <------- (N) [PAYMENTS]
                                 | (1)
                                 |
                                 v (N)
                           [ORDER_ITEMS] (N) -------> (1) [PRODUCTS]
```
### Customers ➔ Orders (1:N): A customer can initiate zero, one, or multiple orders. Each order belongs strictly to one registered customer.

### Orders ➔ Order_Items (1:N): An order consists of one or multiple product line items.

### Products ➔ Order_Items (1:N): A single product can appear in multiple customer order line items.

### Orders ➔ Payments (1:N): Each order maps to one or multiple payment records (enabling payment retries and split tender)
## 2. Entity Attribute Catalog
Entity        Primary Key           Foreign Keys                                 Key Attributes	                                 Data Type
Customers     customer_id            None                                 first_name, last_name, email, city, state, created_at   Relational Core
Products      product_id             None                                 product_name, category, unit_price, stock_quantity      Master Catalog
Orders        order_id               customer_id                          order_date, order_status, total_amount                 Range-Partitioned
Order_Items   order_item_id          order_id, order_date, product_id     quantity, unit_price_at_purchase, line_total",Line Items (M:N resolver)
Payments      payment_id             order_id, order_date                 payment_method, payment_status, amount, payment_timestamp",Financial Ledger
## 3. Query Execution Plan Optimization Strategy
### A. Covering Indexes & Index-Only Scans
Regular indexes require random heap page lookups to read missing projected columns.

Using CREATE INDEX ... INCLUDE (total_amount) allows queries grouping by status and order date to return data straight from memory index blocks, avoiding disk I/O.

### B. Declarative Range Partitioning
The Orders and Order_Items tables are partitioned quarterly by order_date.

Queries executing with date boundary conditions automatically perform Partition Pruning, skipping unneeded partition segments.

### C. Materialized View Caching
For repeating business intelligence workloads, mv_daily_sales_summary caches pre-computed daily figures, scheduled for a non-blocking concurrent refresh nightly.
