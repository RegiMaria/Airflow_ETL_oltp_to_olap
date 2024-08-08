--DimEndereco
CREATE TABLE dimendereco (
    sk_endereco SERIAL PRIMARY KEY,
    idendereco INTEGER NOT NULL,
	cep VARCHAR(20),
	rua VARCHAR(255),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado VARCHAR(2)
    
);

CREATE TABLE dimfonterenda (
    sk_fonte_renda SERIAL PRIMARY KEY,
    idfonte_renda INTEGER NOT NULL,
    descricao VARCHAR(100)
);

CREATE TABLE dimfaixarenda (
    sk_faixa_renda SERIAL PRIMARY KEY,
    idfaixa_renda INTEGER NOT NULL,
    descricao VARCHAR(100)
);

-- DimCliente
CREATE TABLE dimcliente (
    sk_cliente SERIAL PRIMARY KEY,
    idcliente INTEGER NOT NULL,
    nome VARCHAR(100),
    cpf VARCHAR(15) NOT NULL,
    idade INTEGER NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(1),
    email VARCHAR(100),
    telefone VARCHAR(20),
	profissao VARCHAR (50),
    sk_endereco INTEGER,
    sk_fonte_renda INTEGER,
    sk_faixa_renda INTEGER,
    CONSTRAINT fk_endereco_cliente FOREIGN KEY (sk_endereco) REFERENCES DimEndereco(sk_endereco),
    CONSTRAINT fk_fonte_renda_cliente FOREIGN KEY (sk_fonte_renda) REFERENCES DimFonteRenda(sk_fonte_renda),
    CONSTRAINT fk_faixa_renda_cliente FOREIGN KEY (sk_faixa_renda) REFERENCES DimFaixaRenda(sk_faixa_renda)
);

/**-- Criação da tabela DimPerfilDemografico
CREATE TABLE DimPerfilDemografico (
    sk_PerfilDemografico SERIAL PRIMARY KEY,
    idade_media INTEGER NOT NULL,
    distribuicao_idade VARCHAR(255) NOT NULL,
    distribuicao_sexo VARCHAR(255) NOT NULL,
    sk_endereco INTEGER,
    CONSTRAINT fk_endereco_perfil_demografico FOREIGN KEY (sk_endereco) REFERENCES DimEndereco(sk_endereco)
);*/

--DimTempo
CREATE TABLE DimTempo (
    sk_tempo SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    ano INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    dia INTEGER NOT NULL,
    dia_semana INTEGER NOT NULL,
    nome_mes VARCHAR(50) NOT NULL,
    CONSTRAINT uq_data UNIQUE (data)
);


-- DimProduto:
CREATE TABLE DimProduto (
    sk_produto SERIAL PRIMARY KEY,
    idproduto INTEGER NOT NULL,
    nome_produto VARCHAR(255) NOT NULL,
    tipo_produto VARCHAR(100) NOT NULL,
    valor_minimo DECIMAL(10, 2) NOT NULL,
    valor_maximo DECIMAL (10, 2) NOT NULL,
    numero_parcelas_maximo INTEGER NOT NULL,
    condicoes_especiais TEXT
);

--  DimPagamento
CREATE TABLE DimPagamento (
    sk_pagamento SERIAL PRIMARY KEY,
    numero_parcela INTEGER NOT NULL,
    valor_parcela DECIMAL (10, 2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    status_pagamento VARCHAR(20) NOT NULL,
    dias_atraso INTEGER, -- Número de dias de atraso
    juros_mora DECIMAL (10, 2), -- Juros de mora aplicados
    multa_atraso DECIMAL(10, 2), -- Multa por atraso
    valor_final DECIMAL(10, 2), -- Valor total da parcela com juros e multa
    sk_contrato INTEGER NOT NULL,
    CONSTRAINT fk_contrato_pagamento FOREIGN KEY (sk_contrato) REFERENCES DimContrato(sk_contrato)
);

-- DimContrato
CREATE TABLE DimContrato (
    sk_contrato SERIAL PRIMARY KEY,
    idcontrato INTEGER NOT NULL,
    codigo_contrato VARCHAR(200) UNIQUE NOT NULL,
    valor_emprestimo DECIMAL (10, 2) NOT NULL,
    numero_parcelas INTEGER NOT NULL,
    taxa_juros DECIMAL (5, 2) NOT NULL,
    data_contratacao DATE NOT NULL,
    status_contrato VARCHAR(20) NOT NULL,
    sk_cliente INTEGER NOT NULL,
    sk_produto INTEGER NOT NULL,
    CONSTRAINT fk_cliente_contrato FOREIGN KEY (sk_cliente) REFERENCES DimCliente(sk_cliente),
    CONSTRAINT fk_produto_contrato FOREIGN KEY (sk_produto) REFERENCES DimProduto(sk_produto)
);


CREATE TABLE FatoResumoPagamentosAtrasados (
    sk_pagamento_atrasado SERIAL PRIMARY KEY,
    ano INTEGER,
    mes INTEGER,
    total_pagamentos_atrasados INTEGER,
    valor_total_atrasado DECIMAL (10, 2),
    tempo_id INTEGER,
    cliente_id INTEGER, 
    contrato_id INTEGER, 
    produto_id INTEGER, 
    CONSTRAINT fk_fato_tempo FOREIGN KEY (tempo_id) REFERENCES DimTempo (sk_tempo),
    CONSTRAINT fk_fato_cliente FOREIGN KEY (cliente_id) REFERENCES DimCliente (sk_cliente),
    CONSTRAINT fk_fato_contrato FOREIGN KEY (contrato_id) REFERENCES DimContrato (sk_contrato),
    CONSTRAINT fk_fato_produto FOREIGN KEY (produto_id) REFERENCES DimProduto (sk_produto)
);
