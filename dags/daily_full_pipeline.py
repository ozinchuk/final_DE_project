from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
import pandas as pd, duckdb, boto3, os
from sqlalchemy import create_engine


def run_full_etl():
    con = duckdb.connect('/opt/airflow/project/final_project.db')
    eng = create_engine('mysql+pymysql://root:root@mysql:3306/DE_final')

    for t in ['customers', 'products', 'orders', 'sellers']:
        df = pd.read_sql(f"SELECT * FROM {t}", eng)
        con.execute(f"CREATE OR REPLACE TABLE raw_{t} AS SELECT * FROM df")

    path = '/opt/airflow/project/data/order_reviews.json'
    if os.path.exists(path):
        df_rev = pd.read_json(path, lines=True)
        con.execute("CREATE OR REPLACE TABLE raw_reviews AS SELECT * FROM df_rev")

    s3 = boto3.client('s3', endpoint_url='http://minio:9000', aws_access_key_id='minioadmin',
                      aws_secret_access_key='minioadmin')
    obj = s3.get_object(Bucket='raw-data', Key='olist_order_items_dataset.csv')
    df_s3 = pd.read_csv(obj['Body'])
    con.execute("CREATE OR REPLACE TABLE raw_order_items AS SELECT * FROM df_s3")

    con.close()


with DAG('ecommerce_daily_pipeline', start_date=datetime(2026, 4, 1), schedule_interval='@daily', catchup=False) as dag:
    t1 = PythonOperator(task_id='etl', python_callable=run_full_etl)
    t2 = BashOperator(task_id='dbt',
                      bash_command='cd /opt/airflow/project/dbt_project && dbt seed --profiles-dir . && dbt build --select tag:daily --profiles-dir .')
    t1 >> t2