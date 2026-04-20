# E-commerce Multi-Source ELT Pipeline

## Objective
This project implements a production-grade Data Engineering infrastructure using Apache Airflow, dbt, Docker, and DuckDB. The pipeline orchestrates an ELT process that extracts data from multiple heterogeneous sources, loads it into a centralized analytical storage, and transforms it into business-ready data marts.

## Project Architecture & Data Sources
The pipeline integrates three distinct data source types, meeting all assignment requirements:

* **OLTP Database (MySQL):** Extracts relational data (Customers, Products, Orders, Sellers).
* **Object Storage (MinIO):** Replaces dbt seeds for large datasets. Extracts large CSV files (Order Items).
* **Semi-Structured Data (JSON):** Extracts local JSON files (Order Reviews).
* **dbt Seeds:** Exclusively used for small reference datasets (Item Translations).

## dbt Modeling & Transformations
The data transformation layer is built with dbt and contains over 20 models following best practices and official style guides. 

### Layered Architecture
* **Raw Layer:** Source-aligned tables loaded directly into DuckDB with minimal transformations.
* **Staging Layer (stg):** Cleaned data with standardized naming conventions and explicit type casting.
* **Mart Layer:** Business-level models providing aggregated datasets and analytical metrics.

### Analytical Features & Quality
* **Window Functions:** Implemented for advanced analytics (ranking, cumulative metrics, rolling aggregates).
* **Data Quality Tests:** Comprehensive testing suite including `unique`, `not_null`, and `accepted_values` across critical models.
* **Analytical Outputs:** The mart layer generates actionable KPIs, trend analysis, and business insights.

## Orchestration & Scheduling
Apache Airflow acts as the central orchestrator for the entire workflow.

### ETL Flow
1. Airflow extracts data from MySQL, MinIO, and JSON sources using Python.
2. Data is loaded into a centralized DuckDB instance (`final_project.db`).
3. Airflow triggers dbt execution to build the transformation layers.

### Tag-Based Scheduling
Models are grouped and scheduled based on refresh frequency using dbt tags, optimizing resource utilization:

* **Hourly Execution:** Models tagged with `hourly` are triggered by Airflow every hour.
* **Daily Execution:** Models tagged with `daily` are triggered by Airflow on scheduled dates.

## Setup & Installation

git clone https://github.com/ozinchuk/final_DE_project.git
cd final_DE_project

docker-compose up -d

python3 load_to_mysql.py

## Execution Commands

dbt build

dbt build --select tag:hourly

dbt build --select tag:daily
