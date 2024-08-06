<h3>Criando e populando as tabelas relacionais </h3>

Primeiro, criamos as tabelas relacionais cliente, endereco, produto, fonte de renda, faixa de renda, pagamento e contrato. Você pode encontrar as regras de negócio que fizemos diretamente no banco de dados aqui e mais informações sobre o carregamento de dados usando sql aqui.

:pushpin:[Consulte o DDL completo das tabelas relacionais aqui](OLTP_DB).

Criação da tabela relacional cliente:

![tabela_cliente](C:\Users\User\Documents\PROGRAMAÇÃO\1_Github_projetos\1_Posgraduacao_wyden\NOVO_AIFLOW_ETL\imag\cliente_oltp.png)



Agora vamos criar as tabelas dimensionais  e de fato no Data Warehouse.

:pushpin:[Consulte o DDL das tabelas dimensionais aqui](OLAP_DW).

![olap_dimcliente](C:\Users\User\Documents\PROGRAMAÇÃO\1_Github_projetos\1_Posgraduacao_wyden\NOVO_AIFLOW_ETL\imag\olap_dimcliente.png)

É possível automatizar a criação das tabelas dimensionais a partir das tabelas relacionais durante a fase de transformação, mas não foi esse o caso. Então, revisamos todas as tabelas antes de fazer o fluxo de dados.

<h3>Populando as tabelas relacionais</h3>

----------------------------------------------------------------------------

:pushpin: ​[O DML completo pode ser encontrado aqui](OLTP_DB/DML_OLTP.sql).

:pushpin: ​Os dados fictícios estão aqui.![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcIYE-BPH4PFypx5HFwfAYS_6TG3jpl2Wy7nTuxn7Uurp5V1W4sm8FkFMSqRrua36jLFhUmPgPpqYaHdf_l6vCHpKu5WoGhHXk8xAjgMsA_o3IjF60dULBZ64Yg4WO1foWW7o-MXGIhHQbkmLC5zU2svAs?key=mcTeGO_pylJdcN1ITL-rTQ)

:pushpin:[Agora vamos ao PIPELINE_DE_DADOS!](HOW_TO/2_airflow_test_connection.md)
