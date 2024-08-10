<h3> Data Warehouse : Convenção de Nomenclatura Metodologia Kimball </h3>

:heavy_check_mark:**Objetivo:** Estudar a nomenclatura de DW baseado na Metodologia Kimball

:heavy_exclamation_mark:**O que você vai encontrar?** Nessa tarefa criamos uma tabela `produto` no sistema OLTP e transferimos os seus dados para a tabela `dimproduto` no sistema OLAP. Nossa intenção é automatizar esse ETL através de uma DAG no **Airflow**. Padronizamos os nomes das colunas de acordo com as recomendações do *Kimballl Group* e realizamos o mapeamento para que cada campo aponte para o respectivo item.

:pushpin:Encontre o script dessa tarefa aqui.

:pushpin: Encontre o how to do aqui.

:pushpin: Encontre o DDL da tabela relacional e a dimensional aqui

A Metodologia de Ralph Kimball se concentra na Modelagem Dimensional e enfatiza a importância de um designe intuitivo, bem estruturado e orientado ao Negócio. Significando dizer que deve ser de fácil uso para análise. Embora o Kimball Group não estabeleça uma lista rígida de convenções de nomenclatura, ele defende princípios gerais que estão alinhados com as seguintes diretrizes:



- **Clareza e Descritividade:** Kimball enfatiza a importância de nomes claros e descritivos para facilitar a compreensão por parte dos usuários e desenvolvedores.

- **Consistência:** A consistência na nomenclatura é um princípio fundamental para garantir que o Data Warehouse seja fácil de manter e compreender.

- **Uso de Prefixos:** O uso de prefixos como **dim** para tabelas dimensionais e **fato** para tabelas de fatos reflete as práticas recomendadas de Kimball para ajudar a distinguir rapidamente o tipo de tabela e seu propósito no esquema.

Esses princípios são cruciais para manter a consistência, clareza e organização, facilitando a compreensão e manutenção dos dados por todos que vão interagir com eles.



:one: **PADRONIZAÇÃO DE NOMES E ESTRUTURA -TABELAS E COLUNAS:**

<table style="border: 1px solid black; border-collapse: collapse;">
  <tr>
    <th style="border: 1px solid black; padding: 5px;">Tabela de Origem (OLTP)</th>
    <th style="border: 1px solid black; padding: 5px;">Tabela de Destino (Dimensão)</th>
  </tr>
     <tr>
    <td style="border: 1px solid black; padding: 5px;">produto</td>
    <td style="border: 1px solid black; padding: 5px;">dimproduto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">idproduto</td>
    <td style="border: 1px solid black; padding: 5px;">codigo_produto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">nome_produto</td>
    <td style="border: 1px solid black; padding: 5px;">nome_produto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">descricao</td>
    <td style="border: 1px solid black; padding: 5px;">descricao_produto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">tipo_produto</td>
    <td style="border: 1px solid black; padding: 5px;">categoria_produto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">valor_minimo</td>
    <td style="border: 1px solid black; padding: 5px;">valor_minimo_produto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">valor_maximo</td>
    <td style="border: 1px solid black; padding: 5px;">valor_maximo_produto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">numero_parcelas_maximo</td>
    <td style="border: 1px solid black; padding: 5px;">max_parcelas_produto</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 5px;">condicoes_especiais</td>
    <td style="border: 1px solid black; padding: 5px;">condicoes_especiais_produto</td>
  </tr>
</table>

<h4> TABELAS </h4>

---------------------------------------------------------------------------------------

- Uso de prefixos para identificar a tabela:

**fato**: A tabela fato deve vir acompanhada do prefixo `fato`.

**dim**: A tabela dimensão deve vir acompanhada do prefixo `dim`.

​		Exemplo: `dimproduto` (ou `dim_produto`), `fato_vendas` (ou `fatovendas`)



- Uso de plural e singular:

**Tabela dimensional:** no singular como em  `dimcontrato` , `dimproduto`

**Tabela fato:** A tabela fato no plural como em `fatovendas`



- Descrição: os nomes devem ser descritivos, autoexplicativos sobre o conteúdo da tabela e sem abreviações.

  

<H4> COLUNAS </h4>

----------------------------------------------------------------------

- Prefixos de chaves:

**sk:**para chaves substitutas (surrogate keys), como em `sk_cliente`.

**pk:** para chaves naturais ou primárias como em `pk_venda`.

**fk**: para chaves estrageiras, como em `fk_produto`



- Clareza: Colunas devem refletir claramente seu conteúdo ou função, como `nome_cliente`, `data_venda`, `valor_total`.

  

- Sem abreviações ambíguas ou obscura: deve ser clara, objetiva e com significado amplamente reconhecido pela equipe. Como em `valor_total`ou `data_venda`.

<h4>
     NOMES  de ÍNDICES E RESTRIÇÕES:
</h4>

----------------------------------------

- Índice: Use prefixos como `idx_` seguido pelo nome da tabela e coluna. Como em `ìdx_dimcliente_nome`.

  

- Chaves primárias:  prefixo ``pk_` seguido pelo nome da tabela. Como em `pk_dimcliente`

  

- Chave estrangeira: prefixo `fk_` seguido pelo nome da tabela de origem e destino. Como em `fk_fato_vendas_cliente`



<h4> NOME DE SCRIPTS E PROCEDURES</h4>

---------------------------------------------------

- **Ação e Contexto:** Nomeie os scripts e as procedures com uma ação seguida do contexto, como em`sp_insere_cliente`, `fn_calcula_venda`, `fn_atualiza_pagamento`.



<h4> PADRONIZAÇÃO DE VALORES E CONVERSÃO DE TIPOS:</h4>

-----------------------------------------------------------------------

:x: Nos meus estudos os principais e recorrentes erros estavam ligados ao **formato inadequado** dos dados, ao uso de maiúscula e minúscula e a falta e ineficiência de mapeamento de campos. Por isso considero este um tópico importante a ser discutido.



- **Padronização de Valores:** os valores devem ser padronizados,por exemplo valores numéricos devem estar no mesmo formato, e a mesma convenção de maiúsculas/minúsculas.
- **Conversão de Tipos de Dados:** converter tipos de dados, como transformar um `TEXT` em `VARCHAR` ou garantir que datas estejam no formato adequado.



<h4> USO DE UNDERLINES</h4>

-----------------------------------------------

Pode ser usado para **separar palavras** em nomes de tabelas, colunas e outras entidades para **melhorar a legibilidade**. 

**Documente** sua convenção de nomenclatura para garantir que todos os envolvidos no projeto a sigam e compreendam ou siga a convenção da organização da qual você faz parte. O importante é definir ou seguir uma convenção clara, organizada e consistente.







<h4> REFERÊNCIAS </h4>

-------------------------------------------

:pushpin:KimballGroup - [Dimensional Modeling Techniques](https://www.kimballgroup.com/wp-content/uploads/2013/08/2013.09-Kimball-Dimensional-Modeling-Techniques11.pdf)

:pushpin: Kimball Group - [Data Warehouse -Business Inteligence](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/)

