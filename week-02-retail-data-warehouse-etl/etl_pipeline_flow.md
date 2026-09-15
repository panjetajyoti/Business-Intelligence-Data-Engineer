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
