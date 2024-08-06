<h3>TRANSFERINDO DADOS DE OLTP_DB PARA OLAP_DW</h3>

----------------------------------

Agora vamos transferir dados entre banco de dados. Extraímos os dados de oltp_dw (50) e carregamos em olap_dw (quem tem '60').

:pushpin:[A DAG com ETL está em ETL_test_from_oltp_to_olap](teste/2_ETL_test_from_oltp_to_OLAP.py)

Com o ETL bem sucedido, verificamos diretamente o banco de dados e o novo valor foi inserido com sucesso.

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeOjhY79Pn8avI45ZsaX7v3qogWVsGLAEF_UnSS4L2VKKbd_SYaVKv7qMOguU1isAmI1JTexoko4cWSK3ixn7JyO54Q5Cww18PaFRvZnn0ivU5wYZ3efzvkGJEr1qlo_pdrHevB77xr26Hw5e6prt-0TrY?key=mcTeGO_pylJdcN1ITL-rTQ)

:pushpin: ​Agora vamos começar com o ETL das tabelas reais!
