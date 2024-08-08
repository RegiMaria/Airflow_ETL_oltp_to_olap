<h3>ETL de transferência de dados das tabelas faixa_renda e fonte_renda do sistema relacional para dimfaixarenda e dimfonterenda no sistema analítico </h3>

-----------------------------------------------

Bom, fizemos a transferência de cliente para dimcliente e os campos com as chaves para as dimensões dimfaixarenda e dimfonterenda ficaram null. Logo, vamos realizar a transferência desses dados pra reexecutar a DAG cliente-dimcliente.

A primeira DAG que escrevemos para esse ETL já consideramos o mapeamento das chaves naturais para as chaves substitutas, mas como os dados vem de uma única fonte e estamos apenas replicando os dados do sistema transacional para o Data Warehouse, vamos pela abordagem mais prática.

Antes de iniciar a DAG vamos revisar a estrutura das tabelas e realizar as correções necessárias. Como essas no datatype.![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcTUqcJIc_7ybhbcBLz2aEqaKKeyhcnoa2Dr1qjZVu-Yi7m1ninZXixLfl1hDPxNXIjTV50qTQjL1M20hjgbF0u98Q_Ghgheol1pUF1laa7MDi2Hbdogi0ojkAFad6dNx-xtS_4CmIVM-go7G28xL9_t5ZS?key=mcTeGO_pylJdcN1ITL-rTQ)



![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdmo_sahNlgaK84VIDnHAlRXkNTeF_6r85cXXY2z03-dvsg65AB1DfE3HwfpeAmyq7Bo---ILeObagxuLxaA11bP5do4eBBrDz7LPSr7Fy-d9DoCsvyc_0UleDhfFSye5_q5tcu2S04zJyVbxWQHVXJPYaW?key=mcTeGO_pylJdcN1ITL-rTQ)



Consultamos as tabelas e os dados estavam inseridos.

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd2BP9h97c60JclUp5jlcxcCsT-thiuMTCUV4af6u3XPQmxKHm26g_XeOKfZvvt1Rld9jp-m_ypOzp-CMMBW_NWN7T5MTxA2GmADJh8CwuaE4QkuvcQ4c3hv5-HMu1Dyq87UW1w5NOvbIDhobMgOhSGtcNB?key=mcTeGO_pylJdcN1ITL-rTQ)

<h3>Para construir esse pipeline ... </h3>

---------------------------

Para construir o pipeline, revisamos as tabelas e analisando os dados que elas continham percebemos que poderíamos usar um fluxo de trabalho simples na mesma DAG. Inclusive essa migração poderia ser feita no próprio banco de dados, já que são dados que dificilmente serão modificados. Mas vamos escrever a DAG por motivos de estudo.

<h4>Função para extração das tabelas fonte_renda e faixa_renda do database oltp_db</h4>

:heavy_check_mark:**Extração:**

Selecionamos as tabelas que vão ser extraídas do banco de dados oltp_db:

`tables = [fonte_renda, faixa_renda]`

Depois criamos um dicionário de DataFrames vazio chamado `data`.

`data = {}`

Realizamos uma iteração onde pra cada tabela em `tables` (definida anteriormente):

`for table in tables:`

Vamos executar uma consulta `SQL (SELECT * FROM {table};)` para buscar todos os dados dessa tabela.

`sql = f'SELECT * FROM {table};'`

Com o método `get_pandas_df` executamos a consulta e carregamos os dados no DataFrame do pandas.

`data[table] = oltp_hook.get_pandas_df(sql)`

Enviamos tudo que está armazenado em **data** para o `xcom`:

`ti.xcom_push(key='data', value=data)`



![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfNIMqVSqKK-kJgshvr2nGs6N1sCWVENj7UUn35Bz2bVBwiJyrAWWz6DfLIUQjSZLEHuUXuWC6a1SJb1MZSqSNQC051TjHOkvAjaDSu8knFuWzyRDCdX9Li7JpY5btoIzmX6TA6YLxA61o2m_bREiJj0WM?key=mcTeGO_pylJdcN1ITL-rTQ)



:heavy_check_mark:**Transformação:**

Função de transformação **separada** para cada tabela:

Tanto os dados de faixa_renda como fonte_renda não passaram por transformações uma vez que são conhecidos, imutáveis, poucos e para estudo.

Recuperamos os dados do xcom:

`data = ti.xcom_pull(key='data', task_ids='extract_data')`

Colocamos uma **verificação**(ValueErro) pra vê se os dados existem. Para não acontecer como na outro fluxo de transferir campos null. 

A variável **data** contém os dados definidos na etapa de extração, se retornar `None` signifca que **nenhum** dado foi extraído.

`if not data: raise ValueError("Nenhum dado foi extraído na etapa anterior.")`

Acessamos **data** e selecionamos os dados que vamos usar (fonte_renda) e armazenamos em uma variável chamada **df_fonte_renda**.

`df_fonte_renda = data['fonte_renda']`

Fazemos o mesmo com os dados de faixa_renda.

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeH8Myp_8nLDvo7sdrjj4DefwUo4JRkEdjewbYX4mF9Xe5lsyqHdOsGo2gQ8nFavPTZ9YUWqdRCngAibEeRYub5xPzg1-XHXrmH7AZVyJhMy9g3Mas8vxrAJEkK6giczHrjW1HD7cs8j-L_3K756_75oK6d?key=mcTeGO_pylJdcN1ITL-rTQ)

:heavy_check_mark:**Carregamento**:

Função para carregar os dados nas respectivas tabelas:

Nessa etapa, também construímos task separadas, mas ao invés de usar  `PostgresHook`, para interagir com o banco de dados (no caso foi usado pra leitura) usamos a `engine SQLAlchemy` para escrever os dados nas tabelas do database olap_dw.

**Tabela fonte_renda:**

Usamos o **PostgreHook** pra conexão com o banco de dados:

`olap_hook = PostgresHook(postgres_conn_id='olap_dw')`

Dele pegamos um  **engine SLQAlchemy** pra escrever os dados:

`engine = olap_hook.get_sqlalchemy_engine()`

Pegamos os dados que estavam no **xcom**:

`df_fonte_renda = ti.xcom_pull(key='transformed_data_fonte_renda', task_ids='transform_fonte_renda')`

Armazenamos na variável **df_fonte_renda**.

Agora passamos a mesma verificação:

```if df_fonte_renda is None or df_fonte_renda.empty: ```

```raise ValueError("Nenhum dado transformado foi encontrado para dimfonterenda.")```

Com o método `to_sql` vamos carregar os dados em dimfonterenda, onde, se a tabela já existir os dados devem ser **adicionados**(append) e não substituídos (replace).

`df_fonte_renda.to_sql('dimfonterenda', engine, if_exists='append', index=False)`

Fazemos as mesmas etapas para a tabela faixa_renda.

:heavy_check_mark: Definimos as tarefas:

```extract_task = PythonOperator( ```

```task_id='extract_data',```

``` python_callable=extract_data,``` 

``` dag=dag)```



``` transform_fonte_renda_task = PythonOperator(``` 

```task_id='transform_fonte_renda',```

``` python_callable=transform_fonte_renda,```

``` dag=dag) ```



```transform_faixa_renda_task = PythonOperator( ```

```task_id='transform_faixa_renda',```

``` python_callable=transform_faixa_renda,``` 

```  dag=dag)```



```load_fonte_renda_task = PythonOperator(```

``` task_id='load_fonte_renda',```

```python_callable=load_fonte_renda,```

```dag=dag)```



```load_faixa_renda_task = PythonOperator(```

```task_id='load_faixa_renda',```

```python_callable=load_faixa_renda,```

```dag=dag)```



:heavy_check_mark: Definimos a precedência das tarefas:

`extract_task >> transform_fonte_renda_task >> load_fonte_renda_task`

`extract_task >> transform_faixa_renda_task >> load_faixa_renda_task `



:pushpin:[Escrevemos o script dessa DAG aqui](DAG/DAG/ETL_dimfonterenda_faixarenda.py)

:pushpin: Pipeline dimcliente pode ser encontrado aqui
