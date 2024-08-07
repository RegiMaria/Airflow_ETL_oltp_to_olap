CREATE TABLE dicionario_dimensoes (
    id SERIAL PRIMARY KEY,
    tabela_oltp VARCHAR(50),
    coluna_oltp VARCHAR(50),
    tabela_olap VARCHAR(50),
    coluna_olap VARCHAR(50),
    descricao TEXT
);

INSERT INTO dicionario_dimensoes (tabela_oltp, coluna_oltp, tabela_olap, coluna_olap, descricao)
VALUES
('cliente', 'idcliente', 'dimcliente', 'idcliente', 'Chave natural da tabela OLTP.'),
('cliente', 'idcliente', 'dimcliente', 'sk_cliente', 'Chave substituta da tabela OLAP.'),
('cliente', 'endereco_id', 'dimcliente', 'sk_endereco', 'Mapeamento de endereco_id para sk_endereco na dimensão dimendereco.'),
('cliente', 'fonte_renda_id', 'dimcliente', 'sk_fonte_renda', 'Mapeamento de fonte_renda_id para sk_fonte_renda na dimensão dimfonterenda.'),
('cliente', 'faixa_renda_id', 'dimcliente', 'sk_faixa_renda', 'Mapeamento de faixa_renda_id para sk_faixa_renda na dimensão dimfaixarenda.');


SELECT * FROM dicionario_dimensoes;