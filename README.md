# 🛡️ P&C Insurance Portfolio Analytics Engine

An end-to-end data analytics and business intelligence portfolio project simulating Property & Casualty (P&C) insurance risk management, underwriting profitability, and claims pipeline efficiency.

---

## 📌 Project Overview
Insurance carriers must continually evaluate underwriting performance and solvency by monitoring key risk indicators—most notably the **Loss Ratio** (total claims paid out vs. premium revenue collected). This project builds a production-grade relational insurance database from scratch, seeds 10,000+ synthetic records programmatically via PostgreSQL, executes complex analytical queries, and visualizes executive insights through Metabase dashboards.

---

## 🛠️ Technical Stack & Tools
* **Database & DDL**: PostgreSQL, pgAdmin 4
* **Data Modeling & Seeding**: Relational 3NF Schema, Procedural SQL (`generate_series()`, conditional `CASE` logic)
* **Data Analysis**: Advanced SQL (Multi-table joins, Window Functions, `COALESCE`, `NULLIF`, Risk Segmentation)
* **Data Visualization**: Metabase (BI Dashboard)
* **Version Control**: Git, GitHub Desktop, Markdown (`README.md`)

---

## 🗄️ Database Architecture & Schema
The database (`insurance_analytics`) consists of a normalized 3NF relational model linking three core tables via foreign keys:

---

### Data Dictionary & Schema Specification

| Table Name | Column Name | Data Type | Constraints / Keys | Description |
| :--- | :--- | :--- | :--- | :--- |
| **clients** | `client_id` | SERIAL | PRIMARY KEY | Unique identifier for each customer. |
| | `first_name` | VARCHAR(50) | NOT NULL | Customer first name. |
| | `last_name` | VARCHAR(50) | NOT NULL | Customer last name. |
| | `email` | VARCHAR(100) | UNIQUE, NOT NULL | Customer contact email. |
| | `date_of_birth` | DATE | NOT NULL | Customer birth date. |
| | `join_date` | DATE | NOT NULL | Date customer onboarded with carrier. |
| | `credit_score` | INT | NULL | Underwriting risk metric (range 550–850). |
| **policies** | `policy_id` | SERIAL | PRIMARY KEY | Unique identifier for each insurance policy. |
| | `client_id` | INT | FOREIGN KEY (`clients`) | Owner of the policy. |
| | `policy_type` | VARCHAR(50) | NOT NULL | Insurance line (`Motor`, `Home`, `Life`, `Commercial`). |
| | `sum_insured` | DECIMAL(12,2)| NOT NULL | Maximum liability coverage limit. |
| | `monthly_premium` | DECIMAL(10,2)| NOT NULL | Monthly recurring revenue (MRR) collected. |
| | `status` | VARCHAR(20) | NOT NULL | Policy lifecycle status (`Active`, `Expired`, `Cancelled`). |
| | `start_date` | DATE | NOT NULL | Policy inception date. |
| | `end_date` | DATE | NOT NULL | Policy expiration date. |
| **claims** | `claim_id` | SERIAL | PRIMARY KEY | Unique identifier for each filed claim. |
| | `policy_id` | INT | FOREIGN KEY (`policies`) | Associated policy under claim. |
| | `claim_date` | TIMESTAMP | DEFAULT NOW() | Timestamp when the claim was logged. |
| | `claim_amount` | DECIMAL(10,2)| NOT NULL | Total financial amount claimed by insured. |
| | `payout_amount` | DECIMAL(10,2)| DEFAULT 0.00 | Actual approved financial payout disbursed. |
| | `claim_status` | VARCHAR(30) | NOT NULL | Operational stage (`Approved`, `Rejected`, `Under Review`, `Submitted`). |

---

## ⚙️ Data Generation Mechanics & Business Rules
Rather than importing static CSV files, this project uses PostgreSQL procedural SQL to generate balanced, reproducible datasets:
* **`generate_series(1, 10000)`**: Procedurally scales row generation for clients and policies.
* **Modulo Arithmetic (`%`)**: Used to distribute product types evenly across Motor, Home, Life, and Commercial lines, and to simulate realistic credit score tiers (550–850).
* **Relational Integrity**: Foreign keys ensure zero orphan records; claims are deterministically mapped back to active policy IDs with conditional payout logic (e.g., rejected claims return `0.00` payout).

---

## 💻 SQL Scripts & Analytical Highlights
All SQL code is organized within the `sql/` directory:
1. **`01_schema_and_generator.sql`**: Full DDL schema creation and 14,000+ record data seeding script.
2. **`02_analytics_queries.sql`**: Portfolio-grade analytical queries covering:
   * **Loss Ratio Analysis**: $\text{Loss Ratio} = (\sum \text{Claims Paid} / \sum \text{Premiums Collected}) \times 100$ utilizing division safety (`NULLIF`) and missing data handling (`COALESCE`).
   * **Credit Risk Segmentation**: Bucketing clients into risk tiers (`Low Risk`, `Medium Risk`, `High Risk`) via `CASE WHEN` logic.
   * **Cumulative Window Functions**: Running premium totals partitioned by product line (`SUM() OVER (PARTITION BY...)`).

---

## 📈 Metabase Dashboard Visualizations
The executive BI dashboard (`dashboard/` directory screenshots included) tracks:
* **Summary Cards**: Total Premium Collected vs. Total Claims Paid.
* **Loss Ratio by Policy Type**: Bar chart highlighting underwriting risk exposure.
* **Claim Status Pipeline**: Breakdown of operational volume across claim stages.

---

## 🚀 How to Run Locally
1. Clone this repository to your local machine using GitHub Desktop.
2. Open pgAdmin 4 and create a database named `insurance_analytics`.
3. Execute `sql/01_schema_and_generator.sql` to build tables and seed data.
4. Run `sql/02_analytics_queries.sql` to verify analytical metrics.
5. Connect Metabase to explore the live dashboard.

---
*Created by Adriane Takunda Chevure*
