from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pandas as pd
import duckdb
from sqlalchemy import create_engine
import boto3
import io

def run_elt_pipeline():
    db_path = '/opt/airflow/project/final_project.db'
    con = duckdb.connect(db_path)

    print("Extracting MySQL...")
    engine = create_engine('mysql+pymysql://root:root@mysql:3306/DE_final')
    tables = ['customers', 'products', 'orders', 'sellers']
    for table in tables:
        df = pd.read_sql(f"SELECT * FROM {table}", engine)
        con.execute(f"CREATE OR REPLACE TABLE raw_{table} AS SELECT * FROM df")

    print("Extracting JSON...")
    json_path = '/opt/airflow/project/data/olist_order_reviews_dataset.json'
    df_reviews = pd.read_json(json_path, lines=True)
    con.execute("CREATE OR REPLACE TABLE raw_reviews AS SELECT * FROM df_reviews")

    print("Extracting from MinIO...")
    s3 = boto3.client(
        's3',
        endpoint_url='http://minio:9000',
        aws_access_key_id='minioadmin',
        aws_secret_access_key='minioadmin'
    )
    obj = s3.get_object(Bucket='raw-data', Key='olist_order_items_dataset.csv')
    df_items = pd.read_csv(io.BytesIO(obj['Body'].read()))
    con.execute("CREATE OR REPLACE TABLE raw_order_items AS SELECT * FROM df_items")

    con.close()
    print("ETL Pipeline completed")

with DAG(
    'ecommerce_elt_pipeline',
    start_date=datetime(2024, 1, 1),
    schedule_interval='@hourly',
    catchup=False,
    tags=['hourly']
) as dag:
    
    run_etl = PythonOperator(
        task_id='extract_and_load_to_duckdb',
        python_callable=run_elt_pipeline
    )
