# E-Commerce Customer Intelligence \& Revenue Analytics — SQL



Advanced MySQL analysis of customer value, purchasing behavior, revenue contribution, product preferences, and RFM segmentation.



## Project Overview



This project analyzes an e-commerce transaction dataset using MySQL to understand customer purchasing behavior, revenue contribution, product preferences, customer recency, and customer value segments.



The analysis follows a structured data-analysis workflow:



\- Audited the raw data for quality and integrity issues

\- Created a cleaned analytical layer without modifying the raw data

\- Analyzed customer revenue and revenue contribution

\- Examined purchasing frequency, repeat behavior, and recency

\- Identified each customer's highest-quantity product

\- Applied RFM (Recency, Frequency, Monetary) segmentation

\- Combined the analytical outputs into a customer-level master view



## Business Problem



An e-commerce business generates large volumes of customer transaction data, but raw transaction records alone do not provide a clear view of customer value, purchasing behavior, product preferences, or customer engagement.



This project uses SQL to transform raw transaction data into customer-level insights that can support customer segmentation, revenue analysis, and retention analysis.



## Objectives



The analysis aims to:



1\. Assess the quality and integrity of the raw transaction data.

2\. Create a reliable analytical dataset while preserving the raw data.

3\. Measure customer revenue, order volume, average order value, and revenue contribution.

4\. Identify repeat and one-time customers.

5\. Analyze purchase recency and time gaps between customer orders.

6\. Identify each customer's highest-quantity purchased product.

7\. Segment customers using RFM analysis.

8\. Build a consolidated customer-level master view combining revenue, behavior, product preference, and RFM metrics.



## Dataset



The project uses four primary source tables:



| Table | Rows |

|---|---:|

| `customers` | 9,820 |

| `orders` | 49,819 |

| `products` | 20 |

| `payments` | 50,000 |



The `orders` table is the primary transaction source used for customer and revenue analysis.



### Data Quality Findings



Before analysis, the raw data was audited for duplicates, invalid values, missing dates, and referential integrity issues.



Key findings:



\- **119 duplicate order ID groups** were identified.

\- **25 order rows** contained invalid quantities (`quantity <= 0`).

\- **180 distinct customer IDs** in the orders data did not exist in the customer master table.

\- **35 order records** contained blank order dates.

\- `productid` references were valid.

\- Discount values were within the expected range.

\- Product unit prices were positive.



### Data Cleaning Approach



The raw tables were not modified.



A `cleaned\_orders` analytical view was created to:



\- Remove exact duplicate transaction records.

\- Convert text-based order dates into proper `DATE` values.

\- Convert blank order dates to `NULL`.

\- Flag invalid quantities.

\- Flag invalid customer references.

\- Preserve problematic records for auditability rather than silently deleting them.



For business analysis, the analytical population was restricted to records with:



\- Positive quantities

\- Valid customer references

\- Non-null order dates



Additional `Completed` status filtering was applied to the Product Behavior analysis.



## SQL Analysis & Techniques



The project was developed using MySQL and applies intermediate-to-advanced SQL techniques to transform transaction data into customer-level insights.



### SQL Techniques Used



\- `CTE` (Common Table Expressions) for modular query development

\- `JOIN` and `LEFT JOIN` for combining customer, order, and product data

\- `GROUP BY` and aggregate functions for customer and product metrics

\- `CASE` expressions for business classifications

\- `ROW\_NUMBER()` for identifying each customer's top product

\- `DENSE\_RANK()` for customer revenue ranking

\- `LEAD()` for analyzing customer purchase sequences

\- `DATEDIFF()` for purchase-gap and recency analysis

\- Window functions for cumulative revenue calculations

\- `NTILE(5)` for RFM scoring

\- Subqueries for revenue-share calculations

\- Data validation and referential-integrity checks

\- SQL Views for creating reusable analytical layers



### Analytical Modules



| Module | Purpose |

|---|---|

| [Data Quality Audit](sql/01_data_quality_audit.sql) | Identify data-quality and integrity issues |

| [Cleaned Orders](sql/02_cleaned_orders.sql) | Create a reliable analytical transaction layer |

| [Revenue Analysis](sql/03_revenue_analysis.sql) | Measure customer revenue and revenue contribution |

| [Purchase Behavior](sql/04_purchase_behavior.sql) | Analyze frequency, repeat behavior, purchase gaps, and recency |

| [Product Behavior](sql/05_product_behavior.sql) | Identify each customer's highest-quantity product |

| [RFM Analysis](sql/06_rfm_analysis.sql) | Segment customers based on Recency, Frequency, and Monetary value |

| [Customer Master](sql/07_customer_master.sql) | Combine the analytical outputs into one customer-level view |

## Key Findings



The analysis produced several notable findings across customer behavior, revenue contribution, RFM segmentation, and product preference.



### Customer Activity



\- **4,493 customers (46.0%)** are classified as Inactive.

\- **2,310 customers (23.7%)** are classified as At Risk.

\- Together, Inactive and At Risk customers represent approximately **69.7%** of the analyzed customer base.

\- **1,867 customers (19.1%)** are classified as Active.

\- **1,089 customers (11.2%)** are classified as Recently Active.



### Customer Purchase Behavior



\- **9,436 customers (96.7%)** are Repeat Customers.

\- **323 customers (3.3%)** are One-Time Customers.



This shows that the analyzed customer base is predominantly made up of repeat purchasers, while a substantial proportion of those customers have relatively high recency values.



### RFM Segmentation



\- **Mixed Value** is the largest RFM segment with **2,379 customers (24.4%)**.

\- **Champions** account for **1,365 customers (14.0%)**.

\- Champions contribute approximately **25.7% of analyzed revenue**, despite representing 14.0% of customers.

\- **At Risk** customers represent **1,161 customers (11.9%)**.



### Product Preference



\- **USB-C Cable** is the most frequently identified top product, appearing as the highest-quantity product for **1,220 customers**.

\- It is followed by **Phone Case (1,091 customers)** and **Notebook (1,052 customers)**.



### Revenue Concentration



\- The **top 10 customers** contribute approximately **0.59% of total analyzed revenue**.

\- This indicates that the analyzed revenue is not concentrated among only a very small number of individual customers.



## Project Screenshots



The analysis outputs are documented through selected MySQL Workbench screenshots covering the major stages of the project.



### Data Quality Audit



![Data Quality Audit](screenshots/01_data_quality_audit.png)



### Revenue Analysis



![Revenue Analysis](screenshots/02_revenue_analysis.png)



### Purchase Behavior



![Purchase Behavior](screenshots/03_Purchase_Behavior.png)



### Product Behavior



![Product Behavior](screenshots/04_Product_Behavior.png)



### RFM Segmentation



![RFM Segmentation](screenshots/05_RFM_Segments.png)



### Customer Master



![Customer Master](screenshots/06_Customer_Master.png)



## Project Structure



```text

Ecommerce-Customer-Intelligence-SQL

|

|--- README.md

|

|--- sql/

|   |--- 01_data_quality_audit.sql

|   |--- 02_cleaned_orders.sql

|   |--- 03_revenue_analysis.sql

|   |--- 04_purchase_behavior.sql

|   |--- 05_product_behavior.sql

|   |--- 06_rfm_analysis.sql

|   |--- 07_customer_master.sql

|

|--- screenshots/

|   |--- 01_data_quality_audit.png

|   |--- 02_revenue_analysis.png

|   |--- 03_purchase_behavior.png

|   |--- 04_product_behavior.png

|   |--- 05_rfm_segments.png

|   |--- 06_customer_master.png





## Tools & Technologies



\- **Database:** MySQL

\- **SQL Environment:** MySQL Workbench

\- **Version Control:** Git \& GitHub

\- **Analysis:** SQL-based customer, revenue, product, and RFM analysis





## Skills Demonstrated



\- Data Quality Auditing

\- Data Cleaning \& Validation

\- Relational Data Modeling

\- Customer Revenue Analysis

\- Customer Purchase Behavior Analysis

\- Product Preference Analysis

\- RFM Customer Segmentation

\- Window Functions

\- CTEs and Subqueries

\- Analytical SQL Views

\- Business Insight Generation



## Future Improvements



Potential extensions to this project include:



\- Building an interactive Power BI dashboard from the customer master view.

\- Adding cohort and customer retention analysis.

\- Analyzing monthly revenue and customer trends.

\- Developing product-level sales and profitability analysis.

\- Exploring customer behavior across payment methods.

\- Automating the SQL analysis pipeline for refreshed datasets.



## Project Outcome



This project demonstrates how raw e-commerce transaction data can be transformed into a structured customer intelligence layer using SQL.



The final `Customer\_Master` view combines revenue, purchasing behavior, product preference, recency, and RFM segmentation into a single customer-level analytical dataset.



## Author



**Rik Pramanik**



Data Analytics Portfolio Project



Skills: SQL • MySQL • Data Analysis • Customer Analytics • RFM Segmentation



