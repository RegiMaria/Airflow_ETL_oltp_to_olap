<h3>Airflow: testando a conexão</h3>

--------------------------------------------------

<h3> Conexão Airflow com banco de dados OLTP local</h3>

Vamos criar uma tabela chamada ‘teste’ na camada relacional com alguns dados para teste. Em seguida vamos escrever a extração, transformação e carregamento para um tabela chamada ‘teste_olap’ no Data Warehouse.

O objetivo dessa tarefa será de testar as conexões do airflow com as tabelas no banco de dados.

:small_orange_diamond:Conexões no airflow:

localhost:8080//admin/connection:

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXczkm1kuJdHAvV2WPISAKVScapIucMMZMQrlJCCiHgWyYkEa2Oilt62FUmIOEdqzY9DaviQFf2uGd5J-vhKLIMY_CoCo7XBj8Fb35pCZAdTQqg3t-Q5ayu9vXYZDeP61Nj7hDJtksabFNq_zVVjNVNz44m0?key=mcTeGO_pylJdcN1ITL-rTQ)

<h3>Teste no banco de dados oltp_db</h3>

-----------------------------------------

Realizamos o teste no banco de dados oltp_db.

Escrevemos a DAG, onde criamos a tabela ‘teste’, inserimos um dado ‘50’ e realizamos uma query pra verificação.

:pushpin:A DAG de teste está em airflow_test_connection​

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdQDyg8LeFnEQp04H_vvhCcExZDfK3uNksdvRW0N2hsyHNtsOcPmU4shMfMRwrA5P4lEXCSIn-hgENTHKKXqQELRgl6Qjp6uheKLF2rvHxExzjy4job9Db4Z0vEKxEMEOaJbn5srgPGpNw5reuI3H8UIrcw?key=mcTeGO_pylJdcN1ITL-rTQ)



LOG com resultado da query:

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdHegg4z4lZ3AsDOkgbsgAcGcwvFjICDLwS-zZ05ddZxe_N5fG09okaep0S-7-8S-ON0KQx_aysa9-K8TDgYlqR4n0sz08xfiAlIYlyFXZtRX6ivaYDIZpcriMlrvu2d0SWvNLx4pCSHB4nbW0neXxFadxy?key=mcTeGO_pylJdcN1ITL-rTQ)

Ao olharmos diretamente no banco de dados oltp_db é possível verificar a criação da tabela ‘teste’ com o dado inserido '50'.

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdyqpAjqZPVo4AusiNUftx_wODZ5D_jK9ViuaJP44bh6vg1PtVUupGvylUU_Ao2sSws-C85EOPpRktXcVsMeLRHkMktmXZdyijK8Sz4oCGW-ApWkZ5LFkEkzCalpWbBGXe7m4bHXnufTK6178M3Zy_2OTgm?key=mcTeGO_pylJdcN1ITL-rTQ)

<h3>Teste de conexão no banco de dados olap_dw</h3>

-------------------

Agora testamos a conexão do airflow com a tabela olap_dw. 

Vamos criar uma DAG pra criar uma tabela ‘teste_olap’ no banco de dados olap_dw com o valor 60.

:pushpin: ​A DAG com o teste dessa conexão está em airflow_test_connection

O pipeline foi bem sucedido e podemos ver o valor retornado, que é o valor que inserimos na DAG '60'.

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfCf0WrbAwHznhFA3jw6iMoLTUlNJGVF6btO9XyAaVslPBqQeB8Q5jXRRyRV_s8HTXAwi2SJiBHyIkxxHyeN6J-rjGtDyza-eAohJuZ1MGeC5jP08rr7kOW5K5NTW6K1Zz5KKvHPpK-z-NmslNZHpUrtW3j?key=mcTeGO_pylJdcN1ITL-rTQ)

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeMEitit57oZN-tMppvYT0O3kWoVPJBCExJZArHOzMplA_wPp78bKEEqMdxJnXMrIZRzttBZYlwOeB7MaVifG7ZmjWDEj5D1hoEfd800fmwA3IgOegYAmmEhnV001rv4O9nW3goFfjQDyjQkYp94kqlOtI?key=mcTeGO_pylJdcN1ITL-rTQ)

Agora verificamos o banco de dados no postegreSQL para garantir que a tabela 'teste_olap' foi criada e recebeu o dado ‘60’.

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXe6n28QpBDI-IefFcwXAaKZvHXno_cIdSFkJqf2k3pg4egjLx5ksITaqbTws1W-tPOBZzIuzontQvjrvnSdMJXtSeZRtC8RFMXdxfCLDnLPJMdTJBniYKVAqj1H201mYFyvUIrLhxWisFuS1sWstgvHbCI?key=mcTeGO_pylJdcN1ITL-rTQ)

:pushpin: [​Agora vamos criar a ETL_from_oltp_to_olap](HOW_TO/3_ETL_test_from_oltp_to_olap.md)
