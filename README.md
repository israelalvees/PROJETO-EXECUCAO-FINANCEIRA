<p align="center">
<img src="https://img.shields.io/badge/STATUS-CONCLUÍDO-blue"/>
</p>

<div align="center">
	
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![SQL](https://img.shields.io/badge/SQL-%2300758F.svg?style=for-the-badge&logo=sql&logoColor=white) ![Power Bi](https://img.shields.io/badge/power_bi-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

</div>


## OBJETIVO:

- Análisar as informações contidas no banco de dados (execução_financeira) proposto.
- Tratar os dados; elimando nulls, ajustando valores e datas para melhor análise.
- Construção de um Data Warehouse a partir do banco supracitado.
- Utilizar o DW para construção de um Dashboard utilizando uma ferramenta de BI, apresentando insights relevantes.


 MODELAGEM LÓGICA, CONCEITUAL E DIMENSIONAL:

- LÓGICA:

![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/9a535eb5-5051-4b1e-98be-435465c4f995)  

- CONCEITUAL:

![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/19999dab-43ae-4fa8-b234-4b74c0b11545)  

- DIMENSIONAL:

![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/30d2dcb5-14e2-4681-93c9-7ed19e473658)

	- Modelo Dimensional feito exemplificando a View utilizada para construção do Dashboard.


## MODELAGEM DOS SCRIPTS PARA CRIAÇÃO DAS TABELAS DIMENSÃO E FATO:

- TODAS AS TABELAS USAM A MESMA METODOLOGIA, PRIMEIRO CRIAMOS O SELECT PARA TRAZER OS CAMPOS NECESSÁRIOS PARA CRIAÇÃO DA TABELA.
- APÓS EXECUTADO O SELECT E VERIFICADO OS RESULTADOS, INCLUE A PRIMEIRA LINHA CREATE TABLE AS 'NOME_TABELA'.
- A CRIAÇÃO SEMPRE DEVE SER FEITA EM 'DATA_WAREHOUSE', LOCAL ONDE ESTÁ O DW.

## * TABELA DIM_ORGAO:


- Na análise incial, foi indentificado orgãos com o mesmo código de orgão porém descrições diferentes.
- Utilizamos esse SELECT para indentificar quais eram:

	![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/16428eb4-1852-4f69-8c56-cc0ae4a765d2)



- A subconsulta dentro do HAVING seleciona os códigos de órgãos que possuem mais de uma descrição de órgão associado. Em seguida, a consulta principal exibe apenas os registros que possuem um código de órgão presente na subconsulta, filtrando apenas os casos em que o código do órgão é igual, mas o nome do órgão é diferente. Resultando nesses orgãos:

	![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/ec07f923-5c02-4ec4-9ced-387796657cd8)


- A partir dai partimos para a correção na criação da DIM_ORGAO, utilizando a cláusula MIN para mostrar somente a menor descrição
associada a código do orgão.
	
	![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/b4e74836-ad52-4093-abd6-fac3315c6525)


- e.codigo_orgao AS codigo_orgao: Esta parte da consulta seleciona o campo codigo_orgao da tabela execucao_financeira_despesa e o renomeia como codigo_orgao. 
O campo codigo_orgao é uma coluna que representa o código de identificação do órgão.

- COALESCE(MIN(e.dsc_orgao), e.codigo_orgao) AS nome_orgao: Nesta parte da consulta, usa-se a função COALESCE em conjunto com a função MIN. 
A função MIN é usada para obter o valor mínimo da coluna dsc_orgao da tabela execucao_financeira_despesa. Evitando duplicidade de Orgaos.
A função COALESCE é usada para retornar o primeiro valor não nulo entre o valor mínimo da coluna dsc_orgao e o valor de e.codigo_orgao. 
O resultado dessa operação é renomeado como nome_orgao, que representa o nome do órgão de execução financeira de despesas.

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela execucao_financeira_despesa 
e a renomeia como e, que é um alias para facilitar a referência aos campos da tabela.

- GROUP BY e.codigo_orgao: Aqui, a cláusula GROUP BY é usada para agrupar os resultados com base no campo codigo_orgao. 
Isso significa que os resultados serão agrupados por órgão de execução financeira.

- ORDER BY e.codigo_orgao ASC: A cláusula ORDER BY é usada para ordenar os resultados em 
ordem ascendente com base no campo codigo_orgao. Isso significa que os resultados serão exibidos em ordem crescente de código de órgão.	


## * TABELA DIM_CREDOR:

![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/d06918cc-03dd-41dd-b2b3-97e7f68ba024)


- e.cod_credor AS codigo_credor: Esta parte da consulta seleciona o campo cod_credor da tabela execucao_financeira_despesa
 e o renomeia como codigo_credor. O campo cod_credor é uma coluna que representa o código de identificação do credor.

- MIN(e.dsc_nome_credor) AS nome_credor: Nesta parte da consulta, usa-se a função MIN para obter o valor mínimo da 
coluna dsc_nome_credor da tabela execucao_financeira_despesa. E evitando duplicidade de Credor.
Essa função é aplicada para encontrar o nome do credor que vem primeiro em ordem alfabética. 
O resultado dessa operação é renomeado como nome_credor, que representa o nome do credor de execução financeira de despesas.

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela execucao_financeira_despesa 
e a renomeia como e, que é um alias para facilitar a referência aos campos da tabela.

- GROUP BY e.cod_credor: Aqui, a cláusula GROUP BY é usada para agrupar os resultados com base 
no campo cod_credor. Isso significa que os resultados serão agrupados por código de credor.

- ORDER BY e.cod_credor ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem 
ascendente com base no campo cod_credor. Isso significa que os resultados serão exibidos em ordem crescente de código de credor.	


## * TABELA DIM_FONTE:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/7dcbf2d9-c25f-416f-9d2d-0f39d320f05e)


 - e.cod_fonte AS codigo_fonte: Esta parte da consulta seleciona o campo cod_fonte da tabela execucao_financeira_despesa 
e o renomeia como codigo_fonte. O campo cod_fonte é uma coluna que representa o código de identificação da fonte.

- MIN(e.dsc_fonte) AS nome_fonte: Nesta parte da consulta, usa-se a função MIN para obter o valor mínimo da coluna dsc_fonte 
da tabela execucao_financeira_despesa. E evitando duplicidade de Fonte.
Essa função é aplicada para encontrar o nome da fonte que vem primeiro em ordem alfabética. 
O resultado dessa operação é renomeado como nome_fonte, que representa o nome da fonte de execução financeira de despesas.

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela execucao_financeira_despesa 
e a renomeia como e, que é um alias para facilitar a referência aos campos da tabela.

- WHERE e.cod_item IS NOT NULL: A cláusula WHERE é usada para filtrar os registros da tabela 
execucao_financeira_despesa, selecionando apenas aqueles em que o campo cod_item não seja nulo. 
Isso significa que somente serão considerados os registros que possuam um código de item.

- GROUP BY e.cod_fonte: Aqui, a cláusula GROUP BY é usada para agrupar os resultados com base no campo cod_fonte. 
Isso significa que os resultados serão agrupados por código de fonte.

- ORDER BY e.cod_fonte ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo cod_fonte. 
Isso significa que os resultados serão exibidos em ordem crescente de código de fonte.

## * TABELA DIM_FUNCAO:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/4e2a2e3c-3e28-42c9-bfc4-dcd983d1ad02)


- e.cod_funcao AS codigo_funcao: Este campo representa o código da função financeira. Ele é renomeado como "codigo_funcao".

- MIN(e.dsc_funcao) AS nome_funcao: Este campo representa o nome da função financeira. A função de agregação "MIN" é usada para retornar 
o valor mínimo da coluna "dsc_funcao". E evitando duplicidade de Função. Ele é renomeado como "nome_funcao".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- GROUP BY e.cod_funcao: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_funcao". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_funcao".

- ORDER BY e.cod_funcao ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_funcao". 
Isso significa que os resultados serão exibidos em ordem crescente de código de função.

## * TABELA DIM_SUBFUNCAO:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/e1a5f652-959e-4b89-8cdf-775dfa62d4a0)


- e.cod_subfuncao AS codigo_subfuncao: Este campo representa o código da subfunção financeira. Ele é renomeado como "codigo_subfuncao".

- MIN(e.dsc_subfuncao) AS nome_subfuncao: Este campo representa o nome da subfunção financeira. A função de agregação "MIN" é usada para retornar 
o valor mínimo da coluna "dsc_subfuncao". E evitando duplicidade de Subfunção. Ele é renomeado como "nome_subfuncao".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- GROUP BY e.cod_subfuncao: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_subfuncao". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_subfuncao".

- ORDER BY e.cod_subfuncao ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_subfuncao". 
Isso significa que os resultados serão exibidos em ordem crescente de código de subfunção.	


## * TABELA DIM_ITEM:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/04df0f3f-8c4a-4f99-b7c9-9944f3777899)


- e.cod_item AS codigo_item: Este campo representa o código do item financeiro. Ele é renomeado como "codigo_item".

- MIN(e.dsc_item) AS nome_item: Este campo representa o nome do item financeiro. A função de agregação "MIN" é usada para retornar o valor mínimo 
da coluna "dsc_item". E evitando duplicidade de Item. Ele é renomeado como "nome_item".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- WHERE e.cod_item IS NOT NULL: Esta cláusula WHERE é adicionada para filtrar os registros onde o código do item não é nulo. 
Isso remove as linhas com valores nulos na coluna "cod_item".

- GROUP BY e.cod_item: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_item". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_item".

- ORDER BY e.cod_item ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_item". 
Isso significa que os resultados serão exibidos em ordem crescente de código de item.	

	
## * TABELA DIM_ITEM_ELEMENTO:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/fab27733-d772-4350-8f29-548d41bba0f8)


- e.cod_item_elemento AS codigo_item_elemento: Este campo representa o código do elemento do item financeiro. Ele é renomeado como "codigo_item_elemento".

- MIN(e.dsc_item_elemento) AS nome_item_elemento: Este campo representa o nome do elemento do item financeiro. 
A função de agregação "MIN" é usada para retornar o valor mínimo da coluna "dsc_item_elemento". E evitando duplicidade de Item Elemento.
Ele é renomeado como "nome_item_elemento".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- WHERE e.cod_item_elemento IS NOT NULL: Esta cláusula WHERE é adicionada para filtrar os registros onde o código do elemento do item não é nulo. 
Isso remove as linhas com valores nulos na coluna "cod_item_elemento".

- GROUP BY e.cod_item_elemento: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_item_elemento". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_item_elemento".

- ORDER BY e.cod_item_elemento ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_item_elemento". 
Isso significa que os resultados serão exibidos em ordem crescente de código do elemento do item.
	

## * TABELA DIM_ITEM_CATEGORIA:

![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/0a6a4677-8496-467f-83cc-d7bc82c1fb42)


- e.cod_item_categoria AS codigo_item_categoria: Este campo representa o código da categoria do item financeiro. Ele é renomeado como "codigo_item_categoria".

- MIN(e.dsc_item_categoria) AS nome_item_categoria: Este campo representa o nome da categoria do item financeiro. 
A função de agregação "MIN" é usada para retornar o valor mínimo da coluna "dsc_item_categoria". E evitando duplicidade de Item Categoria.
Ele é renomeado como "nome_item_categoria".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- GROUP BY e.cod_item_categoria: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_item_categoria". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_item_categoria".

- ORDER BY e.cod_item_categoria ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_item_categoria". 
Isso significa que os resultados serão exibidos em ordem crescente de código da categoria do item.

## * TABELA DIM_ITEM_GRUPO:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/3bc65361-fb16-41b3-82e8-903802f37274)


- e.cod_item_grupo AS codigo_item_grupo: Este campo representa o código do grupo do item financeiro. Ele é renomeado como "codigo_item_grupo".

- MIN(e.dsc_item_grupo) AS nome_item_grupo: Este campo representa o nome do grupo do item financeiro. 
A função de agregação "MIN" é usada para retornar o valor mínimo da coluna "dsc_item_grupo". E evitando duplicidade de Item Grupo. 
Ele é renomeado como "nome_item_grupo".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- WHERE e.cod_item_grupo IS NOT NULL: Esta cláusula WHERE é adicionada para filtrar os registros onde o código do grupo do item não é nulo. 
Isso remove as linhas com valores nulos na coluna "cod_item_grupo".

- GROUP BY e.cod_item_grupo: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_item_grupo". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_item_grupo".

- ORDER BY e.cod_item_grupo ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_item_grupo". 
Isso significa que os resultados serão exibidos em ordem crescente de código do grupo do item.

## * TABELA DIM_ITEM_MODALIDADE:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/541d3075-f5e9-45cf-ba55-7ec62dc91e02)


- e.cod_item_modalidade AS codigo_item_modalidade: Este campo representa o código da modalidade do item financeiro. Ele é renomeado como "codigo_item_modalidade".

- MIN(e.dsc_item_modalidade) AS nome_item_modalidade: Este campo representa o nome da modalidade do item financeiro. 
A função de agregação "MIN" é usada para retornar o valor mínimo da coluna "dsc_item_modalidade". E evitando duplicidade de Item Modalidade.
Ele é renomeado como "nome_item_modalidade".

- MIN(e.dsc_modalidade_licitacao) AS nome_item_modalidade: Este campo representa o nome da modalidade de licitação do item financeiro. 
A função de agregação "MIN" é usada para retornar o valor mínimo da coluna "dsc_modalidade_licitacao". Ele também é renomeado como "nome_item_modalidade".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- GROUP BY e.cod_item_modalidade: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_item_modalidade". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_item_modalidade".

- ORDER BY e.cod_item_modalidade ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_item_modalidade". 
Isso significa que os resultados serão exibidos em ordem crescente de código da modalidade do item.

## * TABELA DIM_PROGRAMA:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/f70994e7-93b2-4f99-9780-56e5c42add8d)


- e.cod_programa AS codigo_programa: Este campo representa o código do programa financeiro. Ele é renomeado como "codigo_programa".

- MIN(e.dsc_programa) AS nome_programa: Este campo representa o nome do programa financeiro. 
A função de agregação "MIN" é usada para retornar o valor mínimo da coluna "dsc_programa". E evitando duplicidade de Programa.
Ele é renomeado como "nome_programa".

- FROM execucao_financeira_despesa e: Esta parte da consulta especifica a tabela "execucao_financeira_despesa" de onde os dados serão selecionados. 
É atribuído o alias "e" à tabela para facilitar a referência posterior.

- GROUP BY e.cod_programa: A cláusula GROUP BY é usada para agrupar os resultados com base no campo "cod_programa". 
Isso significa que os registros serão agrupados de acordo com os valores únicos do campo "cod_programa".

- ORDER BY e.cod_programa ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo "cod_programa". 
Isso significa que os resultados serão exibidos em ordem crescente de código do programa.

## * TABELA FATO_VALOR:
	
![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/54fc5b4b-8ace-4f7a-b18e-d7d691dc3157)


- CONCAT(num_ano, cod_ne, codigo_orgao) AS codigo_empenho: Esta parte da consulta utiliza a função CONCAT para concatenar 
os valores dos campos num_ano, cod_ne e codigo_orgao. O resultado é renomeado como codigo_empenho e representa o código do empenho, 
formado pela combinação desses três campos.

- codigo_orgao: Este campo representa o código do órgão.

- cod_credor AS codigo_credor: Este campo representa o código do credor.

- cod_fonte AS codigo_fonte: Este campo representa o código da fonte.

- cod_funcao AS codigo_funcao: Este campo representa o código da função.

- cod_subfuncao AS codigo_subfuncao: Este campo representa o código da subfunção.

- cod_item AS codigo_item: Este campo representa o código do item.

- cod_item_elemento AS codigo_item_elemento: Este campo representa o código do elemento do item.

- cod_item_categoria: Este campo representa a categoria do item.

- cod_item_grupo: Este campo representa o grupo do item.

- cod_item_modalidade: Este campo representa a modalidade do item.

- cod_programa: Este campo representa o código do programa.

- num_sic: Este campo representa o número do SIC.

- cod_np: Este campo representa o código número do pagamento.

- COALESCE(vlr_empenho, 0.00) AS valor_empenho: Nesta parte da consulta, utiliza-se a função COALESCE para retornar o valor do campo vlr_empenho, 
mas se for nulo, será retornado o valor padrão de 0.00. O resultado é renomeado como valor_empenho e representa o valor do empenho.

- COALESCE(vlr_liquidado, 0.00) AS valor_liquidado: Nesta parte da consulta, utiliza-se a função COALESCE para retornar o valor do campo vlr_liquidado, 
mas se for nulo, será retornado o valor padrão de 0.00. O resultado é renomeado como valor_liquidado e representa o valor liquidado.

- COALESCE(valor_pago, 0.00) AS valor_pago: Nesta parte da consulta, utiliza-se a função COALESCE para retornar o valor do campo valor_pago, 
mas se for nulo, será retornado o valor padrão de 0.00. O resultado é renomeado como valor_pago e representa o valor pago.

- CASE WHEN vlr_resto_pagar IS NULL THEN '0.00' WHEN vlr_resto_pagar = 0.00 THEN (vlr_empenho - valor_pago) END AS valor_a_pagar: 
Esta parte da consulta utiliza a cláusula CASE para verificar duas condições. Se o campo vlr_resto_pagar for nulo, será retornado '0.00'. 
Se o campo vlr_resto_pagar for igual a 0.00, será calculada a diferença entre vlr_empenho e valor_pago, representando o valor a pagar. 
O resultado é renomeado como valor_a_pagar.

- dth_empenho AS data_empenho: Este campo representa a data do empenho.

- dth_pagamento AS data_pagamento: Este campo representa a data do pagamento.

- dth_liquidacao AS data_liquidacao: Este campo representa a data da liquidação.

- dth_processamento AS data_processamento: Este campo representa a data do processamento.

- num_ano_np: Este campo representa o ano do número do pagamento.

- FROM execucao_financeira_despesa: Esta parte da consulta especifica a tabela execucao_financeira_despesa de onde os dados serão selecionados.

- ORDER BY codigo_empenho ASC: A cláusula ORDER BY é usada para ordenar os resultados em ordem ascendente com base no campo codigo_empenho. 
Isso significa que os resultados serão exibidos em ordem crescente de código de empenho.	
	
## * VW PARA CRIAÇÃO DO DASHBOARD: 

- Optou-se pela criação de uma view criada a partir das tabelas constantes no DW e fazer o tratamento dos valores, somente no script da view.
A ideia seria otimizar o tempo, considerando um cenário real onde foi passada a demanda de criação de um dashboard onde os dados estavam desorganizados.
Sendo assim possível entregar a demenda completa e de maneira correta, no menor tempo possível.

![image](https://github.com/israelalvees/PROJETO-EXECUCAO-FINANCEIRA/assets/128307729/154b74db-c8d9-4d1c-8180-c5b562758a5a)


- v.codigo_empenho: Este campo representa o código do empenho.

- v.codigo_orgao: Este campo representa o código do órgão.

- o.nome_orgao: Este campo representa o nome do órgão.

- v.codigo_credor: Este campo representa o código do credor.

- cc.nome_credor: Este campo representa o nome do credor.

- v.codigo_fonte: Este campo representa o código da fonte.

- cf.nome_fonte: Este campo representa o nome da fonte.

- v.valor_empenho AS total_empenho: Este campo representa o valor total do empenho.

- COALESCE(SUM(v.valor_pago), 0.00) AS total_pago: Nesta parte da consulta, utiliza-se a função SUM para calcular a soma do campo valor_pago, 
agrupado por empenho. A função COALESCE é usada para tratar os valores nulos, retornando 0.00 como valor padrão. 
O resultado é renomeado como total_pago e representa o valor total pago.

- COALESCE(SUM(v.valor_pago), 0.00) AS valor_liquidado: Nesta parte da consulta, utiliza-se novamente a função SUM para calcular a soma do campo valor_pago,
agrupado por empenho. A função COALESCE é usada para tratar os valores nulos, retornando 0.00 como valor padrão. 
O resultado é renomeado como valor_liquidado e representa o valor total liquidado.

- CASE WHEN COALESCE(SUM(v.valor_pago), 0.00) = valor_empenho THEN 0.00 ELSE v.valor_empenho - COALESCE(SUM(v.valor_pago), 0.00) END AS valor_a_pagar: 
Esta parte da consulta utiliza a cláusula CASE para verificar se o valor total pago é igual ao valor do empenho. 
Se for igual, é retornado 0.00 como valor a pagar. Caso contrário, é calculada a diferença entre o valor do empenho e o valor total pago. 
O resultado é renomeado como valor_a_pagar e representa o valor a pagar.

- t.data AS data_empenho: Este campo representa a data do empenho.

- date_part('year', t.data) AS Ano: Este campo utiliza a função date_part para extrair o ano da data do empenho.

- date_part('quarter', t.data) AS Trimestre: Este campo utiliza a função date_part para extrair o trimestre da data do empenho.

- date_part('month', t.data) AS Mes: Este campo utiliza a função date_part para extrair o mês da data do empenho.

- mes_nome_pt(t.data) AS Mes_Nome: Este campo utiliza uma função chamada mes_nome_pt para obter o nome do mês em português com base na data do empenho.

- CASE WHEN COALESCE(SUM(v.valor_pago), 0.00) = v.valor_empenho THEN MAX(v.data_pagamento) ELSE NULL END AS data_liquidacao: 
Esta parte da consulta utiliza a cláusula CASE para verificar se o valor total pago é igual ao valor do empenho. 
Se for igual, é retornado a data máxima de pagamento. Caso contrário, é retornado NULL. O resultado é renomeado como data_liquidacao e representa a data de liquidação.

- FROM data_warehouse.fato_valor v: Esta parte da consulta especifica a tabela fato_valor do data warehouse de onde os dados serão selecionados.

- INNER JOIN data_warehouse.dim_orgao o ON o.codigo_orgao = v.codigo_orgao: Essa cláusula realiza um INNER JOIN entre a tabela dim_orgao e a tabela fato_valor 
com base nos campos codigo_orgao, relacionando as informações do órgão.

- INNER JOIN data_warehouse.dim_credor cc ON cc.codigo_credor = v.codigo_credor: Essa cláusula realiza um INNER JOIN entre a tabela dim_credor e a tabela fato_valor 
com base nos campos codigo_credor, relacionando as informações do credor.

- INNER JOIN data_warehouse.dim_fonte cf ON cf.codigo_fonte = v.codigo_fonte: Essa cláusula realiza um INNER JOIN entre a tabela dim_fonte e a tabela fato_valor 
com base nos campos codigo_fonte, relacionando as informações da fonte.

- INNER JOIN data_warehouse.dim_tempo t ON t.data = v.data_empenho: Essa cláusula realiza um INNER JOIN entre a tabela dim_tempo e a tabela fato_valor 
com base no campo data_empenho, relacionando as informações do tempo.

- GROUP BY v.codigo_empenho, v.codigo_orgao, o.nome_orgao, v.codigo_credor, cc.nome_credor, v.codigo_fonte, cf.nome_fonte, v.valor_empenho, t.data: 
Essa cláusula agrupa os resultados pelo código do empenho, código do órgão, nome do órgão, código do credor, nome do credor, código da fonte, nome da fonte, 
valor do empenho e data do empenho.

## - DASHBOARD:

  https://app.powerbi.com/view?r=eyJrIjoiN2YxMWNiYmEtYzFlYy00NDBhLTgxNTctMTc2YzI4YTVlYzJiIiwidCI6IjY5YjJmMGUzLTRkNjctNGFkMi04OGZmLWU5MzMzZDMwOGIzMiJ9&pageName=ReportSection

- Foi utilizado como ferramenta de BI para criação do dashboard o Power BI.

- CONSIDERAÇÕES SOBRE O DASHBOARD:

  	- O intuido de um Dashboard é apresentar um conjunto de dados, outrora desorganizados e que já passaram pelo processo de ETL, de uma maneira de fácil visualização
  	para qualquer usuário. Seguindo essa metodologia, é apresentado um dashboard intuitívo. Podendo ser filtrado desde uma forma geral, até uma combinação distinta entre os 	filtros (orgão, credor, fonte), tão bem quanto a data (ano, trimestre e mês). Ademais, é apresentado nas demais telas alguns insights relevantes ao contexto.
   	

