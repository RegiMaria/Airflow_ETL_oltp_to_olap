CREATE TABLE endereco (
    idendereco SERIAL PRIMARY KEY NOT NULL,
    cep VARCHAR2(20),
    rua VARCHAR2(100) NOT NULL,
    numero NUMBER NOT NULL,
    bairro VARCHAR2(100) NOT NULL,
    cidade VARCHAR2(100) NOT NULL,
    estado VARCHAR2(2) NOT NULL
);


CREATE TABLE fonte_renda (
    idfonte_renda SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE faixa_renda (
    idfaixa_renda SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);



CREATE TABLE cliente (
    idcliente NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(100),
    cpf VARCHAR2(11) UNIQUE NOT NULL,
    idade NUMBER NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo VARCHAR2(1),
    email VARCHAR2(100),
    telefone VARCHAR2(20),
    profissao VARCHAR2(50),
    fonte_renda_id NUMBER,
    faixa_renda_id NUMBER,
    endereco_id NUMBER,
    CONSTRAINT fk_endereco FOREIGN KEY (endereco_id) REFERENCES endereco (idendereco),
    CONSTRAINT fk_fonte_renda FOREIGN KEY (fonte_renda_id) REFERENCES fonte_renda (idfonte_renda),
    CONSTRAINT fk_faixa_renda FOREIGN KEY (faixa_renda_id) REFERENCES faixa_renda (idfaixa_renda)
);

CREATE TABLE produto (
    idproduto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    nome_produto VARCHAR2(255) NOT NULL,
    descricao CLOB,
    tipo_produto VARCHAR2(100) NOT NULL,
    valor_minimo NUMBER(10, 2) NOT NULL,
    valor_maximo NUMBER(10, 2) NOT NULL,
    numero_parcelas_maximo NUMBER NOT NULL,
    condicoes_especiais CLOB
);

CREATE TABLE contrato (
    idcontrato NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    codigo_contrato VARCHAR2(200) UNIQUE NOT NULL, --Trigger baseado no tipo_produto da tabela produto
    valor_emprestimo NUMBER(10, 2) NOT NULL,
    numero_parcelas INT NOT NULL,
    taxa_juros NUMBER(5, 2) NOT NULL,
    data_contratacao DATE NOT NULL,
    status_contrato VARCHAR2(20) NOT NULL,
    cliente_id NUMBER NOT NULL,
    produto_id NUMBER NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(idcliente),
    CONSTRAINT fk_produto FOREIGN KEY (produto_id) REFERENCES produto(idproduto)
);


CREATE TABLE pagamento (
    idpagamento NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    numero_parcela INT NOT NULL,
    valor_parcela NUMBER(10, 2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE NULL,
    status_pagamento VARCHAR2(20) NOT NULL,
    dias_atraso NUMBER, -- Número de dias de atraso
    juros_mora NUMBER(10, 2), -- Juros de mora aplicados
    multa_atraso NUMBER(10, 2), -- Multa por atraso
    valor_final NUMBER(10, 2), -- Valor total da parcela com juros e multa
    contrato_id NUMBER NOT NULL,
    FOREIGN KEY (contrato_id) REFERENCES contrato(idcontrato)
);
