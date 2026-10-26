# insurance-portfolio-analytics
A portfolio project analyzing property and casualty insurance risk, loss ratios, and portfolio health using PostgreSQL and Metabase.

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
1. **`clients`**: Stores customer demographic data, join dates, and credit scores.
2. **`policies`**: Houses insurance lines (`Motor`, `Home`, `Life`, `Commercial`), sum insured amounts, monthly premiums, and policy statuses (`Active`, `Expired`, `Cancelled`).
3. **`claims`**: Tracks reported claims, claim amounts, financial payout amounts, and operational workflow statuses (`Approved`, `Rejected`, `Under Review`, `Submitted`).

---

## 💻 SQL Scripts & Analytical Highlights
All SQL code is organized within the `sql/` directory:
* **`01_schema_and_generator.sql`**: Contains the DDL table creation scripts and procedural data generation logic seeding 10,000 clients, 10,000 policies, and 4,000 balanced claims.
* **`02_analytics_queries.sql`**: Features portfolio-grade analytical queries, including:
  * **Loss Ratio Calculation**: Evaluating underwriting health across product lines using division safety (`NULLIF`) and missing data handling (`COALESCE`).
  * **Credit Risk Segmentation**: Correlating client credit tiers with claim frequency and average payout severity using custom `CASE WHEN` bucketing.
  * **Window Functions**: Calculating cumulative running totals of premium revenue partitioned by policy type (`SUM() OVER (PARTITION BY...)`).

---

## 📈 Metabase Dashboard Visualizations
The project features an executive BI dashboard connected to PostgreSQL (`dashboard/` directory screenshots included):
* **Loss Ratio by Policy Type (Bar Chart)**: Highlights underwriting risk exposure across commercial and personal lines.
* **Claim Status Pipeline (Pie/Bar Chart)**: Visualizes operational volume across approved, rejected, and under-review claims.
* **Total Premium vs. Payout Metrics**: Summary cards displaying portfolio financial exposure.

---

## 🚀 How to Run Locally
1. Clone this repository to your local machine using GitHub Desktop or Git.
2. Open pgAdmin 4 and create a database named `insurance_analytics`.
3. Execute the script located in `sql/01_schema_and_generator.sql` to build the schema and populate the mock data.
4. Run the queries in `sql/02_analytics_queries.sql` to explore portfolio metrics.
5. Connect your local Metabase instance to the `insurance_analytics` database to explore the visual dashboard.

---
*Created by Adriane Takunda Chevure*