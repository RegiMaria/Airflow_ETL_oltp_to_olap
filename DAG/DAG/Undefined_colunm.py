from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime
import pandas as pd

dag = DAG(
    'etl_cliente_dimcliente',
    description='ETL Pipeline_from_cliente_todimcliente',
    schedule_interval=None,
    start_date=datetime(2023, 3, 5),
    catchup=False
)

def extract(**kwargs):
    oltp_hook = PostgresHook(postgres_conn_id='oltp_db')
    sql = 'SELECT * FROM cliente'
    df = oltp_hook.get_pandas_df(sql)
    kwargs['ti'].xcom_push(key='data', value=df)

def transform(**kwargs):
    ti = kwargs['ti']
    df = ti.xcom_pull(key='data')
    ti.xcom_push(key='transformed_data', value=df)

def load(**kwargs):
    olap_hook = PostgresHook(postgres_conn_id='olap_dw')
    ti = kwargs['ti']
    df = ti.xcom_pull(key='transformed_data')

    engine = olap_hook.get_sqlalchemy_engine()
    df.to_sql('dimcliente', engine, if_exists='append', index=False)


extract_task = PythonOperator(
    task_id='extract',
    python_callable=extract,
    provide_context=True,
    dag=dag
)

transform_task = PythonOperator(
    task_id='transform',
    python_callable=transform,
    provide_context=True,
    dag=dag
)

load_task = PythonOperator(
    task_id='load',
    python_callable=load,
    provide_context=True,
    dag=dag
)

extract_task >> transform_task >> load_task
