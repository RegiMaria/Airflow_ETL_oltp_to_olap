from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
from airflow.providers.postgres.operators.postgres import PostgresOperator

dag =  DAG('airflow_test_connection', description="testa conexão airflow-postgres",
        schedule_interval=None,
        start_date=datetime(2023,3,5),
        catchup=False)

def print_result(ti):
    task_instance = ti.xcom_pull(task_ids='query_data')
    print("Resultado da consulta:")
    for row in task_instance:
        print(row)

create_table = PostgresOperator(task_id='create_table',
                                postgres_conn_id='olap_dw',
                                sql='create table if not exists teste_olap(id int);',
                                dag=dag)

insert_data = PostgresOperator(task_id='insert_data',
                                postgres_conn_id='olap_dw',
                                sql='insert into teste_olap values(60);',
                                dag=dag)

query_data = PostgresOperator(task_id='query_data',
                                postgres_conn_id='olap_dw',
                                sql='select * from teste_olap;',
                                dag=dag)

print_result_task = PythonOperator(
                              task_id='print_result_task',
                              python_callable=print_result,
                              provide_context=True,
                              dag=dag   
                                )
create_table >> insert_data >> query_data >> print_result_task