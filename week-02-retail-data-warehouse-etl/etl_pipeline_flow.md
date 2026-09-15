# Week 2: Enterprise Retail Data Warehouse & ETL Pipeline Architecture

## 1. Architectural Overview
This document details the end-to-end Extract, Transform, Load (ETL) pipeline feeding the Multi-National Retail Data Warehouse. The architecture ingests operational data across distributed international retail branches, standardizes currency and timestamps, tracks customer historical state via SCD Type 2, and enforces field-level PII hashing for GDPR compliance.

---

## 2. High-Level Data Flow

```text
[Point of Sale (POS) Systems]   [Regional ERP Databases]   [Online E-Commerce Feeds]
             \                             |                             /
              \                            |                            /
               v                           v                           v
              +---------------------------------------------------------+
              |           1. INGESTION & STAGING LAYER (RAW)            |
              |     - S3 Bucket / Blob Landing Zone (JSON / CSV)        |
              |     - Immutable Append-only Audit Logs                  |
              +---------------------------------------------------------+
                                           |
                                           v
              +---------------------------------------------------------+
              |          2. TRANSFORMATION ENGINE (CLEAN & ENRICH)      |
              |     - Schema Validation & Data Contracts                |
              |     - Currency Normalization to Base USD               |
              |     - Timezone Standardization to UTC                   |
              |     - SHA-256 Hashing of Customer PII (GDPR)            |
              |     - SCD Type 2 Logic on Customer Address Changes      |
              +---------------------------------------------------------+
                                           |
                                           v
              +---------------------------------------------------------+
              |          3. ANALYTICAL SERVING LAYER (STAR SCHEMA)      |
              |     - Columnar Storage Target (Data Warehouse)          |
              |     - Pre-aggregated Materialized Views for Power BI   |
              +---------------------------------------------------------+
```
## 3. Step-by-Step ETL Execution Stages
**Stage 1: Extraction (E)
Ingestion Strategy: Automated delta extraction utilizing Change Data Capture (CDC) via database transaction logs, supplemented by daily midnight batch extract snapshots.

Sources Handled: Relational transaction databases across regions (APAC, EMEA, Americas) and edge inventory point-of-sale systems.

**Stage 2: Transformation (T)
Data Hygiene & Cleansing:

Automated removal of duplicate transaction IDs.

Group-median imputation for missing non-critical metrics (e.g., fulfillment latency).

Currency & Standardization:

Dynamic join against daily foreign exchange tables (Dim_Exchange_Rate) to convert local tender (EUR, GBP, INR, JPY) into consolidated gross_revenue_usd.

Slowly Changing Dimensions (SCD Type 2):

Customer updates compare incoming residence or tier attributes against Dim_Customer.

On mutation: previous record expires (valid_to = CURRENT_TIMESTAMP, is_current = FALSE), and a new surrogate record is appended (is_current = TRUE).

Data Privacy & Governance:

Full cryptographic one-way hashing (SHA-256) applied on customer emails and phone numbers to satisfy cross-border GDPR compliance.

**Stage 3: Loading (L)
Target Load Pattern: Micro-batch staging table upserts into the production Star Schema.

Integrity Checks: Foreign key constraints validated against active surrogate dimension records prior to final commit into Fact_Retail_Sales.

## 4. Operational Monitoring & SLA Metrics
Pipeline Latency SLA: Maximum 2-hour processing window from daily snapshot capture to warehouse availability.

Data Quality Threshold: Pipeline triggers automated alerts if schema null-rate exceeds 0.5% on transactional financial metrics.
