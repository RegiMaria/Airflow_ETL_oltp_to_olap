<h3>How to: DAG para ETL -cliente ---> dimcliente</h3>

**Objetivo:**

Que todos os dias sejam extraídos os dados das tabelas relacionais da financeira, transformados e adicionados no Data Warehouse.

Antes de escrevermos as DAG para o ETL de cliente para dimcliente, revisamos as tabelas. Percebemos que a tabela cliente no sistema OLTP possui 12 colunas, enquanto a tabela dimcliente no sistema OLAP possui 13 colunas. 

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

Escrevemos a DAG e tentamos fazer o ETL mesmo assim e recebemos o erro:

No log da tarefa no airflow:

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdHQbsjDEZ-UXG0ZswEfaV3AeeSmgkO4fti73_u-l9sFPUS7wmGNF5vND10-7mtQ4skvDtBw8xVLCwbotuczYLOveW43Ry-U2c7uOhI3gYl7TnlB7KsEmTWD2DU7rKewxtEQZYrUruzUamYg7CMuqzY35dr?key=mcTeGO_pylJdcN1ITL-rTQ)

O erro **UndefinedColunm** indica que a consulta tentou acessar uma coluna que não existe na tabela referenciada. Isso vai acontecer pra todas as colunas que  existem em cliente e não existem em dimcliente.

Precisamos decidir como lidar isso,com chaves naturais, estrangeiras e chaves substitutas (surrogate keys) durante a transformação. 

Veja a dag que gerou  o erro aqui.

Diante disso podemos:

Manter as chaves naturais nas tabelas dimensionais junto com as chaves substitutas. Permitindo que as chaves substitutas sejam usadas para operações internas do DW e as chaves naturais para integrações e análises no Power BI.

Remover as chaves naturais e substituir elas por chaves substitutas nas tabelas dimensionais. No entanto, a ausência das chaves naturais podem dificultar a integração com fontes que precisam usar os identificadores únicos das tabelas relacionais.

<h3> Dicionário de dimensões </h3>

-----------------------------------------------------------------------------

Escolhemos a segunda opção, remover as chaves naturais e substituir elas por chaves substitutas (sk_*). Vamos associar o identificador único da tabela do sistema OLTP com uma chave substituta correspondente na tabela dimensional do Data Warehouse (DW). Na prática, a chave fonte_renda_id vai apontar para sk_fonte_renda e assim por diante.

Para documentar o mapeamento entre as chaves criamos um dicionário de dimensões (as que vêm do sistema OLTP) e chaves substitutas (as geradas e usadas no Data Warehouse OLAP). Esse dicionário vai servir como uma referência para ajudar os analistas e desenvolvedores a entender a estrutura do Data Warehouse e a realizar consultas ou integrações caso seja necessário.

O dicionário pode ser construído:

:pushpin:[Numa planilha](DAG/data/dicionario_dimensoes.csv)

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdJBWh6uod3fkRwGw-67y9qyfnsw0OXh6T8InQsyVZPDo8YcaRgaWhF6aDYSNpi3IO6ibCb5zzMm12rVLYZos1Vj_TJnGNNRqG6SPUxAdapw11olO-oS8V_-CjA2BKCC6fi9FfKs9-Y0Mwfrwfongw0PrrE?key=mcTeGO_pylJdcN1ITL-rTQ)

:pushpin:[No banco de dados](DAG/sql/dicionario_dimensoes.sql)

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfg0zttkULNk4AQZtr-v77T3el9LZ0k5wxCbV0xQfz3-jH2p6d8BKDPnKrRDBG84T3Rg6vl5AxmJ6gvD5QKHWObjUfhGpAlmPFuGhU51PU-Veg1KJzj0HOzv7biHEpIJzB7WOeJJBGBPYkJihPj4CvsYQHY?key=mcTeGO_pylJdcN1ITL-rTQ)

Resolvido isso, voltamos para nosso ETL.

Aqui nós reescrevemos o script da DAG com as transformações
