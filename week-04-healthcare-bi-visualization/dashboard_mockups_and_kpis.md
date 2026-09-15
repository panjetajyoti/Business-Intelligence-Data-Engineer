# Week 4: Healthcare Executive BI Dashboards & Visual Wireframes

---

## 📊 Dashboard 1: Patient Satisfaction & Experience Overview

### Key Performance Indicators (KPIs)
* **Overall Net Promoter Score (NPS):** 81.4 (Benchmark: >75)
* **Avg Emergency Department (ED) Triage Wait Time:** 34 Minutes (Target: <45 mins)
* **Doctor & Nurse Communication Index:** 4.6 / 5.0

### Visual Wireframe Mockup
```text
+-------------------------------------------------------------------------+
| PATIENT SATISFACTION & EXPERIENCE MONITOR                               |
+-------------------------------------------------------------------------+
| [ Overall NPS: 81.4 ]    [ Avg Wait Time: 34m ]   [ Doctor Rating: 4.6 ]|
+------------------------------------+------------------------------------+
| VISUALIZATION 1: Gauge Meter       | VISUALIZATION 2: Scatter Plot      |
| Overall Facility Rating            | Correlation: Wait Time vs Rating   |
|                                    | Rating ^                           |
|       [==== 88% ====>   ]          |      5 |  *   *                    |
|    Target Threshold: 85%           |      3 |      *   *   *            |
|                                    |      1 |              *   *        |
|                                    |        +------------------------>  |
|                                    |        0   20  40  60  80 mins     |
+------------------------------------+------------------------------------+
| VISUALIZATION 3: Horizontal Stacked Bar Chart                           |
| Departmental Sentiment: [ Positive Feedback ][ Neutral ][ Negative ]   |
| Nursing Care   : [========================== 85% =================][10%][5%]|
| Cleanliness    : [===================== 78% ======================][14%][8%]|
| Billing Clarity: [============= 54% =============][==== 26% =====][20%]|
+-------------------------------------------------------------------------+
```
## 📊 Dashboard 2: Treatment Effectiveness & Clinical Outcomes
Key Performance Indicators (KPIs)
30-Day Unplanned Readmission Rate: 6.4% (National Benchmark: <8.0%)

Average Length of Stay (ALOS): 3.8 Days (Target: 4.1 Days)

Post-Surgical Complication Rate: 0.8% (Target: <1.2%)

Visual Wireframe Mockup
```Plaintext
+-------------------------------------------------------------------------+
| TREATMENT EFFECTIVENESS & CLINICAL OUTCOMES                             |
+-------------------------------------------------------------------------+
| [ Readmission Rate: 6.4% ]  [ Hospital ALOS: 3.8d ]  [ Complications: 0.8% ]|
+-------------------------------------------------------------------------+
| VISUALIZATION 1: Dual-Axis Line & Column Chart                          |
| Readmission Rates (Line) vs Average Length of Stay (Columns) by Ward    |
|                                                                         |
|  ALOS (Days) ^             [Column: ALOS]            ^ Readmission %    |
|            8 |   [||]           [||]           [||]  | 10%              |
|            4 |   [||]    /\     [||]    /\     [||]  | 5%               |
|            0 |___[||]___/  \____[||]___/  \____[||]__| 0%               |
|               Cardiology     Orthopedics     Oncology                   |
+-------------------------------------------------------------------------+
| VISUALIZATION 2: Departmental Heatmap Matrix                            |
| Complication Frequency Across Patient Age Tiers                         |
|                 0-18 Years   19-45 Years   46-65 Years   65+ Years      |
| Inpatient Surgery: [ Low   ]   [ Low   ]   [ Medium ]   [ High   ]      |
| Intensive Care   : [ Low   ]   [ Medium ]  [ Medium ]   [ High   ]      |
| General Medicine : [ Low   ]   [ Low   ]   [ Low    ]   [ Medium ]      |
+-------------------------------------------------------------------------+
```
## 📊 Dashboard 3: Hospital Resource & Capacity Saturation
Key Performance Indicators (KPIs)
Total Inpatient Bed Occupancy: 83.2% (Target Optimal Range: 80% - 85%)

ICU Capacity Saturation: 89.1% (Critical Alert Threshold: >90.0%)

Operating Room (OR) Productivity: 78.5% (Target: 80.0%)

Visual Wireframe Mockup
```Plaintext
+-------------------------------------------------------------------------+
| RESOURCE UTILIZATION & CAPACITY SATURATION                              |
+-------------------------------------------------------------------------+
| [ Bed Occupancy: 83.2% ]   [ ICU Saturation: 89.1% ]  [ OR Output: 78.5% ]|
+-------------------------------------------------------------------------+
| VISUALIZATION 1: 100% Stacked Area Chart (30-Day Bed Utilization)       |
| 100% +----------------------------------------------------------------+ |
|      | ////////////////// Available Clean Reserve Beds ////////////// | |
|      | -------------------------------------------------------------- | |
|      | \\\\\\\\\\\\\\\\ Standard Occupied Beds \\\\\\\\\\\\\\\\\\\\\\ | |
|      | ============================================================== | |
|   0% | **************** ICU Critical Care Beds ********************** | |
|      +----------------------------------------------------------------+ |
|        Day 1                       Day 15                      Day 30   |
+-------------------------------------------------------------------------+
| VISUALIZATION 2: Bullet Graph Matrix (Operating Room Productivity)      |
| OR Suite A (Cardiac) : [====================|======>     ] 86% (Goal: 80%)|
| OR Suite B (Neuro)   : [===============|===>             ] 74% (Goal: 80%)|
| OR Suite C (Trauma)  : [==================|===>          ] 81% (Goal: 80%)|
+-------------------------------------------------------------------------+
