from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2026, 4, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'ecommerce_hourly_pipeline',
    default_args=default_args,
    schedule_interval='@hourly',
    catchup=False,
) as dag:

    dbt_run_hourly = BashOperator(
        task_id='dbt_run_hourly',
        bash_command='cd /opt/airflow/project/dbt_project && dbt build --select tag:hourly --profiles-dir .'
    )
