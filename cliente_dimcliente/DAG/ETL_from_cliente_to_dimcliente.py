from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime
import pandas as pd

dag = DAG(
    'ETL_cliente_to_dimcliente',
    description='ETL Pipeline for dimcliente with mapping keys',
    schedule_interval=None,
    start_date=datetime(2023, 8, 2),
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

    if df is None:
        raise ValueError("Nenhum dado foi extraído na etapa anterior.")

   
    olap_hook = PostgresHook(postgres_conn_id='olap_dw')
    engine = olap_hook.get_sqlalchemy_engine()

    
    oltp_to_dim_mapping = {
        'endereco': 'dimendereco',
        'fonte_renda': 'dimfonterenda',
        'faixa_renda': 'dimfaixarenda'
    }

    
    for oltp_table, dim_table in oltp_to_dim_mapping.items():
        dim_df = pd.read_sql(f'SELECT id{oltp_table} as id_{oltp_table}, sk_{oltp_table} FROM {dim_table}', engine)
        df = df.merge(dim_df, left_on=f'{oltp_table}_id', right_on=f'id_{oltp_table}', how='left')
        df = df.drop(columns=[f'{oltp_table}_id'])
    
    columns = ['idcliente', 'nome', 'cpf', 'idade', 'data_nascimento', 'sexo', 'email', 'telefone', 'profissao', 'sk_endereco', 'sk_fonte_renda', 'sk_faixa_renda']
    df = df[columns]
    
    ti.xcom_push(key='transformed_data', value=df)



def load(**kwargs):
    olap_hook = PostgresHook(postgres_conn_id='olap_dw')
    ti = kwargs['ti']
    df = ti.xcom_pull(key='transformed_data')

    if df is None:
        raise ValueError("Nenhum dado transformado foi encontrado.")

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
