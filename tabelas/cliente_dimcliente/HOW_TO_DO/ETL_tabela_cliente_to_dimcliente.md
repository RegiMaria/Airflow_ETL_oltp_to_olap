<h3>How to do: </h3>

<table style="border: 1px solid black; border-collapse: collapse;">
  <tr>
    <th style="border: 1px solid black; padding: 5px;">Processo</th>
    <th style="border: 1px solid black; padding: 5px;">Tabela origem</th>
    <th style="border: 1px solid black; padding: 5px;">Sistema origem</th>
    <th style="border: 1px solid black; padding: 5px;">Tabela destino</th>
    <th style="border: 1px solid black; padding: 5px;">Sistema destino</th>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">ETL</td>
    <td style="border: 1px solid black; padding: 5px;">cliente</td>
    <td style="border: 1px solid black; padding: 5px;">OLTP</td>
    <td style="border: 1px solid black; padding: 5px;">dimcliente</td>
    <td style="border: 1px solid black; padding: 5px;">OLAP</td>
  </tr>
</table>



:heavy_check_mark:**Objetivo:**

Que todos os dias sejam extraídos os dados das tabelas relacionais da financeira, transformados e adicionados no Data Warehouse para futura análise.

Antes de escrevermos as DAG para o ETL de cliente para dimcliente, revisamos as tabelas. Revisamos o `datatype` ,  os nomes dos campos e quantidade de colunas de cada uma. 

| Colunas tabela cliente (OLTP) | Colunas tabela dimcliente (OLAP) |
| ----------------------------- | -------------------------------- |
| idcliente                     | sk_cliente                       |
| nome                          | idcliente                        |
| cpf                           | nome                             |
| idade                         | cpf                              |
| data_nascimento               | idade                            |
| sexo                          | data_nascimento                  |
| email                         | sexo                             |
| telefone                      | email                            |
| profissao                     | telefone                         |
| endereco_id                   | profissao                        |
| fonte_renda_id                | sk_endereco                      |
| faixa_renda_id                | sk_fonte_renda                   |
|                               | sk_faixa_renda                   |
| **Total de colunas: 12**      | **Total de colunas: 13**         |

Escrevemos a DAG e tentamos fazer o ETL.

No log da tarefa no airflow:

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdHQbsjDEZ-UXG0ZswEfaV3AeeSmgkO4fti73_u-l9sFPUS7wmGNF5vND10-7mtQ4skvDtBw8xVLCwbotuczYLOveW43Ry-U2c7uOhI3gYl7TnlB7KsEmTWD2DU7rKewxtEQZYrUruzUamYg7CMuqzY35dr?key=mcTeGO_pylJdcN1ITL-rTQ)

O erro **UndefinedColunm** indica que a consulta tentou acessar uma coluna que não existe na tabela referenciada. Isso vai acontecer pra todas as colunas que  existem em cliente e não existem em dimcliente.

Precisamos decidir como lidar isso,com chaves naturais, estrangeiras e chaves substitutas (surrogate keys) durante a transformação. 

Diante disso podemos:

:small_orange_diamond:Manter as chaves naturais nas tabelas dimensionais junto com as chaves substitutas. Permitindo que as chaves substitutas sejam usadas para operações internas do DW e as chaves naturais para integrações e análises no Power BI.

:small_orange_diamond:Remover as chaves naturais e substituir elas por chaves substitutas nas tabelas dimensionais. No entanto, a ausência das chaves naturais podem dificultar a integração com fontes que precisam usar os identificadores únicos das tabelas relacionais.

<h3> Dicionário de dimensões </h3>

-----------------------------------------------------------------------------

Escolhemos a segunda opção, remover as chaves naturais e substituir elas por chaves substitutas (sk_*). Vamos associar o identificador único da tabela do sistema OLTP com uma chave substituta correspondente na tabela dimensional do Data Warehouse (DW). Na prática, a chave fonte_renda_id vai apontar para sk_fonte_renda e assim por diante.

Para documentar o mapeamento entre as chaves criamos um dicionário de dimensões (as que vêm do sistema OLTP) e chaves substitutas (as geradas e usadas no Data Warehouse OLAP). Esse dicionário vai servir como uma referência para ajudar os analistas e desenvolvedores a entender a estrutura do Data Warehouse e a realizar consultas ou integrações caso seja necessário.

O dicionário pode ser construído:

:pushpin:[Numa planilha](DAG/data/dicionario_dimensoes.csv)

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdJBWh6uod3fkRwGw-67y9qyfnsw0OXh6T8InQsyVZPDo8YcaRgaWhF6aDYSNpi3IO6ibCb5zzMm12rVLYZos1Vj_TJnGNNRqG6SPUxAdapw11olO-oS8V_-CjA2BKCC6fi9FfKs9-Y0Mwfrwfongw0PrrE?key=mcTeGO_pylJdcN1ITL-rTQ)

:pushpin:[No banco de dados](DAG/sql/dicionario_dimensoes.sql)

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfg0zttkULNk4AQZtr-v77T3el9LZ0k5wxCbV0xQfz3-jH2p6d8BKDPnKrRDBG84T3Rg6vl5AxmJ6gvD5QKHWObjUfhGpAlmPFuGhU51PU-Veg1KJzj0HOzv7biHEpIJzB7WOeJJBGBPYkJihPj4CvsYQHY?key=mcTeGO_pylJdcN1ITL-rTQ)



Reescrevemos o ETL de cliente para dimcliente.

:pushpin:O script da DAG para dimcliente aqui

Pipeline:

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfElBUXqCBzse7J4Y4dBxStHclY-F0ZcBeGqNJos5EbTXg0yFSQ31Ke2MBVtO6VKD2ZJJd-64nas8K4RhjIza-yLmDxWloFg5uyqmwT8-4oIckQv2INyRZDkhlDUmXh2vTxWIrEMBc7E8KFI6lbYYVg0xV_?key=mcTeGO_pylJdcN1ITL-rTQ)

Resposta no LOG da DAG:

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdL38Z2Va8yrlEWJx61aKGKPmp_ajY2cs9HBve1BDhISqKMkyyWRe0HpAjzKISBSJCQGgUw1mGJy3zP7bNjik4CJVT-EW-Qc4RSPbiQvhyc-kx0yYxfWZ8Gq-PyhJxsffKM2E2dxk1gbl9v1ntievdgj7Wm?key=mcTeGO_pylJdcN1ITL-rTQ)

Embora as tarefas da DAG tenham ocorrido com sucesso e os dados tenho sido extraídos de cliente e transferidos corretamente para dimcliente em outro banco de dados, as chaves sk_ ficaram **null**. Isso aconteceu porque não carregamos os dados das dimensões auxiliares de dimcliente (sk_fonte_renda, sk_faixa_renda).

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdcMFUBldhtik7nbwrT9GUpsWzYQJkyhrsFLrgKKIcaaCI6Ggg3WwBrKRq2IUUeXFSE3nbE902-gXNwhep35DpH_d9p5M-J7j1pA9mspDNb4U4IdbeirC7TARIAx0WGDyrY2dP5ITKDy-b97fOUrjfUDQia?key=mcTeGO_pylJdcN1ITL-rTQ)

Agora vamos colocar **verificações pra existência de dados como ValueErro**.

Vamos criar o fluxo de trabalho para transferir os dados das tabelas fonte_renda e faixa_renda no sistema OLTP para o sistema OLAP. 

:pushpin:[Aqui podemos ver o How to do ETL_dimfonterenda_dimfaixarenda](DAG/How_to_do/ETL_dimfonterenda_dimfaixarenda.md)



Com os dados dessas tabelas dimensionais inserido poderemos refazer a transferência de dados entre as tabelas cliente e dimcliente. Após realizamos o ETL das tabelas fonte_renda e faixa_renda tentamos novamente fazer o ETL da tabela cliente para dimcliente. Agora os dados que estavam **null**  estão apontando para as sk_* das respectivas tabelas dimensionais.

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcPqrYV7mAIqUwIGCcYfVSZVi_t1gJK7PvTohtxf6013UeSzoKTpGTqWeHLUMns7yII_iVumaD2rDa9JNEVikzEN9aAaOcf3dTGIZyuQ6_hnEuJQSHHipuhW5Brgm5QxUyj2o70IgJoKf_XsJMrdmypR41U?key=mcTeGO_pylJdcN1ITL-rTQ)

**Extração:**

Fizemos a conexão com o banco de dados, usamos e SQL pra selecionar a tabela de origem dos dados (cliente no database oltp_db) e, com o método `get_pandas_df`, salvamos na variável `df`. Em seguida enviamos para o `xcom` com a chave `data` e como valor todos dados de `df`.

```def `extract(kwargs):```

``` oltp_hook = PostgresHook(postgres_conn_id='oltp_db') ``` 

```sql = 'SELECT * FROM cliente'   ```

```df = oltp_hook.get_pandas_df(sql)```

```   kwargs['ti'].xcom_push(key='data', value=df)```





**Transformação:**

Na parte de transformação realizamos o mapeamento. O mapeamento garante que as chaves naturais apontem para as sk.

Com `xcom_pull` capturamos todos os dados de `data`.

Adicionamos um `ValueErro` pra não correr o que aconteceu antes, subir campos vazios sem q a gente perceba.

``` if df is None:``` 

``` raise ValueError("Nenhum dado foi extraído na etapa anterior.")```



Como vamos precisar consultar as tabelas dimensionais pra fazer o mapeamento das chaves, escrevemos a conexão do `engineSQLAlchemy` nessa etapa. Normalmente usamos ela na etapa de carga para escrever os dados na tabela de destino.

```olap_hook = PostgresHook(postgres_conn_id='olap_dw')```

```engine = olap_hook.get_sqlalchemy_engine() ```





Agora vamos escrever o **mapeamento**. Para isso é preciso revisar e conhecer os campos da tabela de destino e de origem.

No dicionário `oltp_dim_mapping` a gente escreve o nome da tabela no sistema OLTP e como valor o nome da tabela no sistema OLTP.

```oltp_to_dim_mapping = {``

``'endereco': 'dimendereco',``

``’fonte_renda': 'dimfonterenda',``

``'faixa_renda': 'dimfaixarenda'``

``}``





Para cada tabela da minha lista de tabelas OLTP, vamos consultar uma tabela no sistema OLAP correspondente e agora vamos obter as SK das tabelas dimensionais e substituir pelos ids das tabelas relacionais. Vamos usar `merge` do pandas e vamos usar um loop pra percorrer as tabelas.

``` 
       for oltp_table, dim_table in oltp_to_dim_mapping.items():
       dim_df = pd.read_sql(f'SELECT id{oltp_table} as id_{oltp_table}, sk_{oltp_table} FROM {dim_table}', engine)
        
        df = df.merge(dim_df, left_on=f'{oltp_table}_id', right_on=f'id_{oltp_table}', how='left')
        
        df = df.drop(columns=[f'{oltp_table}_id'])``
```



Na sintaxe da função `pd.read-sql (sql_query, con)` , indicamos a consulta e a conexão com o banco de dados, que no caso é `engine` definida anteriormente. 

Enviamos para o `xcom_push`com a chave `transfomed_data` e com o valor dos dados em `df`.



**Carregamento:**

No carregamento, capturamos tudo de `transfomed_data` com `xcom_pull`, inserimos novamente a verificação ValueErro e definimos a engineSQLAlchemy para escrever os dados na tabela de destino. 

A função `df_.to_sql` do pandas escreve um DataFrame diretamente na tabela no banco de dados. Definindo o nome da tabela, a conexão, a condição e se o DataFrame vai ter uma coluna pra index. 

```
df.to_sql(nome,con,index)
```

```
 df.to_sql('dimcliente', engine, if_exists='append', index=False)
```



**Tarefas:**

```
extract_task = PythonOperator( task_id='extract',
 python_callable=extract,
 dag=dag)
```



```
transform_task = PythonOperator( 
 task_id='transform',
 python_callable=transform,
 dag=dag
)
```

 

```load_task = PythonOperator( task_id = 'load', 
load_task = PythonOperator( 
task_id = 'load',
python_callable=load,
provide_context=True,
dag=dag
)
```



**Ordem das tarefas:**

``extract_task >> transform_task >> load_task `` 



:pushpin:A DAG da tarefa está aqui
