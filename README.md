# E-commerce Multi-Source ELT Pipeline

This project implements a Data Engineering infrastructure using **Airflow**, **Docker**, and **DuckDB**. The goal is to orchestrate an ELT (Extract, Load, Transform) pipeline that consolidates data from multiple heterogeneous sources into a single analytical storage.

## Project Overview

The pipeline automates the extraction of e-commerce data from three different source types and loads them into a centralized **DuckDB** database for further transformation with dbt.

### Key Features:
* **Infrastructure as Code**: The entire environment (Airflow, MySQL, MinIO) is containerized using Docker Compose.
* **Multi-Source Extraction**:
    * **MySQL**: Relational data extraction (Customers, Products, Orders, Sellers).
    * **MinIO (S3-Compatible)**: Object storage extraction (Order Items CSV).
    * **Local JSON**: Semi-structured data processing (Order Reviews).
* **Orchestration**: Fully automated workflow management using Apache Airflow.
* **Analytical Storage**: Data is consolidated into a high-performance DuckDB file (`final_project.db`)


## Project Structure

* `dags/etl_pipeline.py`: The main Airflow DAG defining the ETL logic.
* `data/`: Directory containing local JSON and source datasets.
* `load_to_mysql.py`: Pre-deployment script to populate the source MySQL database.
* `docker-compose.yml`: Docker configuration for the entire data platform.
* `dbt_project/`: (In Progress) Transformation layer for data modeling.

## Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/ozinchuk/final_DE_project.git](https://github.com/ozinchuk/final_DE_project.git)
    cd final_DE_project
    ```

2.  **Spin up the infrastructure:**
    ```bash
    docker-compose up -d
    ```

3.  **Prepare source data:**
    * Run `python3 load_to_mysql.py` to populate MySQL.
    * Access MinIO at `localhost:9001`, create a bucket named `raw-data`, and upload `olist_order_items_dataset.csv`.

4.  **Run the Pipeline:**
    * Access the Airflow UI at `localhost:8080`.
    * Enable and trigger the `ecommerce_elt_pipeline` DAG.
