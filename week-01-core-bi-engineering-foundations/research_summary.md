# Week 1: Core Business Intelligence & Data Engineering Foundations — Technical Summary

## 1. Executive Overview
This research artifact provides an in-depth comparative study of the core pillars supporting enterprise data systems: Data Warehouses, Data Lakes, Modern Data Lakehouses, and distributed ETL/ELT pipelines.

---

## 2. Key Architectural Paradigms

### A. Data Warehouse vs. Data Lake vs. Data Lakehouse
| Dimension | Enterprise Data Warehouse (EDW) | Enterprise Data Lake | Modern Data Lakehouse |
| :--- | :--- | :--- | :--- |
| **Primary Data Type** | Highly Structured (Relational) | Structured, Semi-structured, Unstructured | Multi-modal (Parquet, Delta, Iceberg) |
| **Schema Paradigm** | Schema-on-Write | Schema-on-Read | Dual: Schema-on-Write enforcement with ACID |
| **Storage & Compute** | Coupled or Tightly Integrated | Completely Decoupled Object Storage (S3/GCS) | Decoupled Storage + Vectorized Engines |
| **Target Workload** | High-concurrency SQL Reporting / BI | Exploratory Data Science & Big Data Storage | Unified: Direct BI Reporting + Machine Learning |

### B. ETL vs. ELT Processing Models
* **Extract, Transform, Load (ETL):**
  * Transformations occur in transit / intermediate staging servers prior to loading into target storage.
  * Used for strict data hygiene, regulatory compliance (PII masking before persistence), and legacy DW constraints.
* **Extract, Load, Transform (ELT):**
  * Raw data is loaded directly into modern cloud columnar stores (BigQuery, Snowflake).
  * Leverages scalable MPP (Massively Parallel Processing) compute engines to transform in-place using SQL/dbt.

---

## 3. Data Modeling & Governance Foundations

### Dimensional Modeling Concepts
* **Fact Tables:** Contain numerical additive/semi-additive measures representing business event occurrences at defined atomic grains.
* **Dimension Tables:** Contain business attributes, context, and hierarchies (e.g., date hierarchies, customer demographics).
* **Slowly Changing Dimensions (SCD):**
  * **Type 1:** Overwrite existing value (no history maintained).
  * **Type 2:** Add a new record with surrogate key, effective timestamp range (`valid_from`, `valid_to`), and active flag (`is_current = TRUE`).
  * **Type 3:** Add an additional column to preserve previous state (`previous_value`).

---

## 4. Key Metrics & Evaluation Criteria
* **Query Latency:** SLA thresholds for sub-second executive dashboards.
* **Data Freshness / Lag:** Tracking batch delta latency versus real-time CDC (Change Data Capture) feeds.
* **Storage Cost Efficiency:** Columnar compression (Snappy, Zstandard) reducing I/O footprint by up to 60-70%.
