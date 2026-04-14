{{ config(tags=['hourly']) }}

SELECT * FROM read_csv_auto('/opt/airflow/project/data/olist_customers_dataset.csv', header=True)