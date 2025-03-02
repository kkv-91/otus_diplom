"""
Даг парсит csv файлы в каталоге data, записывает в бд postgre, перемещает обработанный фалй в каталог data_worked
"""

# 1. section imports
import pandas as pd
import logging as _log
import os
import shutil
from datetime import datetime

from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator
from airflow.hooks.postgres_hook import PostgresHook
from airflow.models import Variable

from sqlalchemy import create_engine

#2. section global vars
PG_CONN_ID = 'postgres_analytics_otus'
PG_TABLE = 'taxi_trips_upload'

# 3. section def
def insert_data(**context):
    '''
    Функция считывает данные с csv и добавляет данные в postgre
    '''

    PG_hook = PostgresHook(postgres_conn_id=PG_CONN_ID)
    PG_hook.run("truncate stg."+PG_TABLE+";")
    lst = os.listdir('./data')
    lst.sort()

    for file in lst:
        if file.endswith('.csv'):
            full_file_name = 'data/' + file
            _log.info('Upload: ' + full_file_name)
            df = pd.read_csv(full_file_name)
            _log.info('Total_records:' + str(len(df)))
            engine = PG_hook.get_sqlalchemy_engine()
            df.to_sql(PG_TABLE, engine,if_exists='replace',schema='stg')
            shutil.move(full_file_name, "data_worked/"+file)
            break
        else:
            continue

# 4. section dag. task descr
args = {
        'owner': 'airflow',
        'catchup': 'False',
    }

with DAG(
    dag_id="csv_upload",
    default_args=args,
    description='parsing data from csv',
    start_date=datetime(2023,12,14),
    schedule='* * * * *',
    tags=['PG', 'API'],
    catchup=False,
    max_active_tasks=1,
    max_active_runs=1,
) as dag:
    insert_data_task = PythonOperator(
        task_id='insert_data_task',
        python_callable=insert_data,
        provide_context=True,
        dag=dag
    )
    upload_stg_task = PostgresOperator(
        task_id='upload_stg_task',
        postgres_conn_id=PG_CONN_ID,
        database='postgres',
        sql='to_stg.sql'
    )
    upload_dwh_task = PostgresOperator(
        task_id='upload_dwh_task',
        postgres_conn_id=PG_CONN_ID,
        database='postgres',
        sql='to_dwh.sql'
    )
    upload_dm_task = PostgresOperator(
        task_id='upload_dm_task',
        postgres_conn_id=PG_CONN_ID,
        database='postgres',
        sql='to_dm.sql'
    )

    insert_data_task >> upload_stg_task >> upload_dwh_task >> upload_dm_task
