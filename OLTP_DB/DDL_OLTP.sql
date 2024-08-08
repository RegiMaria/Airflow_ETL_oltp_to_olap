CREATE TABLE endereco (
    idendereco SERIAL PRIMARY KEY NOT NULL,
    cep VARCHAR(20),
    rua VARCHAR(100) NOT NULL,
    numero NUMBER NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL
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
    idcliente SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(100),
    cpf VARCHAR(15) UNIQUE NOT NULL,
    idade INT NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(1),
    email VARCHAR(100),
    telefone VARCHAR(20),
    profissao VARCHAR(50),
    fonte_renda_id INT,
    faixa_renda_id INT,
    endereco_id INT,
    CONSTRAINT fk_endereco FOREIGN KEY (endereco_id) REFERENCES endereco (idendereco),
    CONSTRAINT fk_fonte_renda FOREIGN KEY (fonte_renda_id) REFERENCES fonte_renda (idfonte_renda),
    CONSTRAINT fk_faixa_renda FOREIGN KEY (faixa_renda_id) REFERENCES faixa_renda (idfaixa_renda)
);

CREATE TABLE produto (
    idproduto SERIAL PRIMARY KEY NOT NULL,
    nome_produto VARCHAR(255) NOT NULL,
    descricao VARCHAR(100),
    tipo_produto VARCHAR(100) NOT NULL,
    valor_minimo DECIMAL(10, 2) NOT NULL,
    valor_maximo DECIMAL(10, 2) NOT NULL,
    numero_parcelas_maximo INTEGER NOT NULL,
    condicoes_especiais TEXT
);


CREATE TABLE contrato (
    idcontrato SERIAL PRIMARY KEY NOT NULL,
    codigo_contrato VARCHAR(200) UNIQUE NOT NULL, -- Trigger baseada no tipo_produto da tabela produto
    valor_emprestimo DECIMAL(10, 2) NOT NULL,
    numero_parcelas INTEGER NOT NULL,
    taxa_juros DECIMAL(5, 2) NOT NULL,
    data_contratacao DATE NOT NULL,
    status_contrato VARCHAR(20) NOT NULL,
    cliente_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(idcliente),
    CONSTRAINT fk_produto FOREIGN KEY (produto_id) REFERENCES produto(idproduto)
);

CREATE TABLE pagamento (
    idpagamento SERIAL PRIMARY KEY NOT NULL,
    numero_parcela INTEGER NOT NULL,
    valor_parcela DECIMAL(10, 2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE NULL,
    status_pagamento VARCHAR(20) NOT NULL,
    dias_atraso INTEGER, -- Número de dias de atraso
    juros_mora DECIMAL(10, 2), -- Juros de mora aplicados
    multa_atraso DECIMAL(10, 2), -- Multa por atraso
    valor_final DECIMAL(10, 2), -- Valor total da parcela com juros e multa
    contrato_id INTEGER NOT NULL,
    FOREIGN KEY (contrato_id) REFERENCES contrato(idcontrato)
);
