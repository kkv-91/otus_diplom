"""
Даг качает датасет Kaggle, перемещается скачанные csv файлы в рабочий каталог data
"""

# 1. section imports
import kagglehub
import shutil
import os
import logging as _log
from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.models import Variable

#2. section global vars
KAGGLE_DATASET = 'kaggle_dataset'

# 3. section def
def upload_data(**context):
    '''
    Функция качает датасет Kaggle, перемещает сsv файлы в рабочий каталог data
    '''

    kaggle_ds = Variable.get(KAGGLE_DATASET)

    path = kagglehub.dataset_download(kaggle_ds, force_download=True)

    for files in os.listdir(path):
        if files.endswith('.csv'):
            full_file_name = path + '/' +files           
            shutil.move(full_file_name, "data/"+files)

# 4. section dag. task descr
args = {
       'owner': 'airflow',
        'catchup': 'False',
    }

with DAG(
    dag_id="upload_from_kaggle_api",
    default_args=args,
    description='upload dataset Kaggle',
    start_date=datetime(2023,12,14),
    schedule=None,
    tags=['PG', 'API'],
    catchup=False,
    max_active_tasks=1,
    max_active_runs=1,
) as dag:
    upload_data_task = PythonOperator(
        task_id='upload_data_task',
        python_callable=upload_data,
        provide_context=True,
        dag=dag
    )

    upload_data_task
