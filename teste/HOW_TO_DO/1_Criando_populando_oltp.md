<h3>Criando e populando as tabelas relacionais </h3>

Primeiro, criamos as tabelas relacionais cliente, endereco, produto, fonte de renda, faixa de renda, pagamento e contrato. Você pode encontrar as regras de negócio que fizemos diretamente no banco de dados aqui e mais informações sobre o carregamento de dados usando sql aqui.

:pushpin:[Consulte o DDL completo das tabelas relacionais aqui](OLTP_DB).

Criação da tabela relacional cliente:

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeoBgEv4nNPh_OmWVtTb71eJms0ieidxYgkVt6MT_OSm_5t4K-lncZTFt-PwYRkN4hcqFueZpraCHyX_SBwPmLGfhFv-wuljEF1ZFeWTJgQqnkqXQYUuxMZQl6qNne4qaeTa2jUlR0wWr23iB6Kd8Jei7Q?key=mcTeGO_pylJdcN1ITL-rTQ)



Agora vamos criar as tabelas dimensionais  e de fato no Data Warehouse.

:pushpin:[Consulte o DDL das tabelas dimensionais aqui](OLAP_DW).

![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcPPh4rsMBx8oPMpiICA-uiP-trnCfqC1nbRlEc17NASwAtmzbrKPTbe2JhL3-cho9Z41q8zjPUNA9dI0_leobMpjOhd89oT263k_R-r_i3BiqFzxKlvdw9islpwd5PtIgzwmF0mLomrVTFF5SjHHHpjPdL?key=mcTeGO_pylJdcN1ITL-rTQ)

É possível automatizar a criação das tabelas dimensionais a partir das tabelas relacionais durante a fase de transformação, mas não foi esse o caso. Então, revisamos todas as tabelas antes de fazer o fluxo de dados.

<h3>Populando as tabelas relacionais</h3>

----------------------------------------------------------------------------

:pushpin: ​[O DML completo pode ser encontrado aqui](OLTP_DB/DML_OLTP.sql).

:pushpin: ​Os dados fictícios estão aqui.![img](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcIYE-BPH4PFypx5HFwfAYS_6TG3jpl2Wy7nTuxn7Uurp5V1W4sm8FkFMSqRrua36jLFhUmPgPpqYaHdf_l6vCHpKu5WoGhHXk8xAjgMsA_o3IjF60dULBZ64Yg4WO1foWW7o-MXGIhHQbkmLC5zU2svAs?key=mcTeGO_pylJdcN1ITL-rTQ)

:pushpin:[Agora vamos ao PIPELINE_DE_DADOS!](HOW_TO/2_airflow_test_connection.md)
