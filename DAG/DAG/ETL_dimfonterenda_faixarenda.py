from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from sqlalchemy import create_engine
from datetime import datetime
import pandas as pd

dag = DAG(
    'ETL_fonterenda_faixarenda',
    description='ETL Pipeline for dimension tables dimfonterenda and dimfaixarenda',
    schedule_interval=None,
    start_date=datetime(2024, 8, 7),
    catchup=False
)

def extract_data(ti):
    oltp_hook = PostgresHook(postgres_conn_id='oltp_db')
    tables = ['faixa_renda', 'fonte_renda']
    
    data = {}
    for table in tables:
        sql = f'SELECT * FROM {table};'
        data[table] = oltp_hook.get_pandas_df(sql)

    ti.xcom_push(key='data', value=data)


def transform_fonte_renda(ti):
    data = ti.xcom_pull(key='data', task_ids='extract_data')
    
    if not data:
        raise ValueError("Nenhum dado foi extraído na etapa anterior.")
    
    df_fonte_renda = data['fonte_renda']
    ti.xcom_push(key='transformed_data_fonte_renda', value=df_fonte_renda)



def transform_faixa_renda(ti):
    data = ti.xcom_pull(key='data', task_ids='extract_data')

    if not data:
        raise ValueError("Nenhum dado foi extraído na etapa anterior.")
    
    df_faixa_renda = data['faixa_renda']
    ti.xcom_push(key='transformed_data_faixa_renda', value=df_faixa_renda)



def load_fonte_renda(ti):
    olap_hook = PostgresHook(postgres_conn_id='olap_dw')
    engine = olap_hook.get_sqlalchemy_engine()

    df_fonte_renda = ti.xcom_pull(key='transformed_data_fonte_renda', task_ids='transform_fonte_renda')
    
    if df_fonte_renda is None or df_fonte_renda.empty:
        raise ValueError("Nenhum dado transformado foi encontrado para dimfonterenda.")
    df_fonte_renda.to_sql('dimfonterenda', engine, if_exists='append', index=False)



def load_faixa_renda(ti):
    olap_hook = PostgresHook(postgres_conn_id='olap_dw')
    engine = olap_hook.get_sqlalchemy_engine()
    
    df_faixa_renda = ti.xcom_pull(key='transformed_data_faixa_renda', task_ids='transform_faixa_renda')
    if df_faixa_renda is None or df_faixa_renda.empty:
        raise ValueError("Nenhum dado transformado foi encontrado para dimfaixarenda.")
    df_faixa_renda.to_sql('dimfaixarenda', engine, if_exists='append', index=False)


extract_task = PythonOperator(
    task_id='extract_data',
    python_callable=extract_data,
    dag=dag
)

transform_fonte_renda_task = PythonOperator(
    task_id='transform_fonte_renda',
    python_callable=transform_fonte_renda,
    dag=dag
)

transform_faixa_renda_task = PythonOperator(
    task_id='transform_faixa_renda',
    python_callable=transform_faixa_renda,
    dag=dag
)

load_fonte_renda_task = PythonOperator(
    task_id='load_fonte_renda',
    python_callable=load_fonte_renda,
    dag=dag
)

load_faixa_renda_task = PythonOperator(
    task_id='load_faixa_renda',
    python_callable=load_faixa_renda,
    dag=dag
)

extract_task >> transform_fonte_renda_task >> load_fonte_renda_task
extract_task >> transform_faixa_renda_task >> load_faixa_renda_task
