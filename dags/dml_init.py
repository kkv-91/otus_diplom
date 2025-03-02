"""
Даг коннектится к БД Postgres, создает схемы stg,ds,dm
Создает таблицы
"""

# 1. section imports
from datetime import datetime
from airflow import DAG
from airflow.operators.postgres_operator import PostgresOperator

#2. section global vars
PG_CONN_ID = 'postgres_analytics_otus'

# 3. section def

# 4. section dag. task descr
args = {
        'owner': 'airflow',
        'catchup': 'False',
    }

with DAG(
    dag_id="dml_init",
    default_args=args,
    description='init database_schemes',
    start_date=datetime(2023,12,14),
    schedule=None,
    tags=['PG', 'API'],
    catchup=False,
    max_active_tasks=1,
    max_active_runs=1,
) as dag:
    dml_init = PostgresOperator(
        task_id='dml_init',
        postgres_conn_id=PG_CONN_ID,
        database='postgres',
        sql='dml_init.sql'
    )

    dml_init
