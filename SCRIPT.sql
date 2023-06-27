--TABELA DIM_ORGAO:	
	
CREATE TABLE data_warehouse.dim_orgao AS
SELECT
    e.codigo_orgao AS codigo_orgao,
    COALESCE(MIN(e.dsc_orgao), e.codigo_orgao) AS nome_orgao
FROM execucao_financeira_despesa e
GROUP BY e.codigo_orgao
ORDER BY e.codigo_orgao ASC

--TABELA DIM_CREDOR:
	
CREATE TABLE data_warehouse.dim_credor AS
SELECT
    e.cod_credor AS codigo_credor,
    MIN(e.dsc_nome_credor) AS nome_credor
FROM execucao_financeira_despesa e
GROUP BY e.cod_credor
ORDER BY e.cod_credor ASC

--TABELA DIM_FONTE:
	
CREATE TABLE data_warehouse.dim_fonte AS
SELECT
    e.cod_fonte AS codigo_fonte,
    MIN(e.dsc_fonte) AS nome_fonte
FROM execucao_financeira_despesa e
WHERE e.cod_item IS NOT NULL
GROUP BY e.cod_fonte
ORDER BY e.cod_fonte ASC

--TABELA FATO_VALOR:
	
CREATE TABLE data_warehouse.fato_valor AS 
SELECT 
	CONCAT(num_ano, cod_ne, codigo_orgao) AS codigo_empenho,
	codigo_orgao,
	cod_credor AS codigo_credor,
	cod_fonte AS codigo_fonte,
	cod_funcao AS codigo_funcao,
	cod_subfuncao AS codigo_subfuncao,
	cod_item AS codigo_item,
	cod_item_elemento AS codigo_item_elemento,
	cod_item_categoria,
	cod_item_grupo,
	cod_item_modalidade,
	cod_programa, 
	num_sic,
	cod_np,
	COALESCE(vlr_empenho, 0.00) AS valor_empenho,
	COALESCE(vlr_liquidado, 0.00) AS valor_liquidado,
	COALESCE(valor_pago, 0.00) AS valor_pago,
		CASE
			WHEN vlr_resto_pagar IS NULL THEN '0.00'
			WHEN vlr_resto_pagar = 0.00 THEN (vlr_empenho - valor_pago) 
			END AS valor_a_pagar,
	dth_empenho AS data_empenho,
	dth_pagamento AS data_pagamento,
	dth_liquidacao AS data_liquidacao,
	dth_processamento AS data_processamento,
	num_ano_np
FROM execucao_financeira_despesa
ORDER BY codigo_empenho ASC

--VW PARA CRIAÇÃO DO DASHBOARD: 

CREATE VIEW data_warehouse.analise_teste1 AS 
SELECT
    v.codigo_empenho,
	v.codigo_orgao,
	o.nome_orgao,
	v.codigo_credor,
	cc.nome_credor,
	v.codigo_fonte,
	cf.nome_fonte,
    v.valor_empenho AS total_empenho,
    COALESCE(SUM(v.valor_pago), 0.00) AS total_pago,
    COALESCE(SUM(v.valor_pago), 0.00) AS valor_liquidado,
    CASE
        WHEN COALESCE(SUM(v.valor_pago), 0.00) = valor_empenho THEN 0.00
        ELSE v.valor_empenho - COALESCE(SUM(v.valor_pago), 0.00)
    END AS valor_a_pagar,
	t.data AS data_empenho,
    date_part('year', t.data) AS Ano,
	date_part('quarter', t.data) AS Trimestre,
    date_part('month', t.data) AS Mes,
    mes_nome_pt(t.data) AS Mes_Nome,
		CASE 
			WHEN COALESCE(SUM(v.valor_pago), 0.00) = v.valor_empenho THEN MAX(v.data_pagamento)
        ELSE NULL
    END AS data_liquidacao
FROM
    data_warehouse.fato_valor v
INNER JOIN data_warehouse.dim_orgao o ON o.codigo_orgao = v.codigo_orgao
INNER JOIN data_warehouse.dim_credor cc ON cc.codigo_credor = v.codigo_credor
INNER JOIN data_warehouse.dim_fonte cf ON cf.codigo_fonte = v.codigo_fonte
INNER JOIN data_warehouse.dim_tempo t ON t.data = v.data_empenho
GROUP BY
    v.codigo_empenho, v.codigo_orgao, o.nome_orgao,
	v.codigo_credor, cc.nome_credor, v.codigo_fonte, cf.nome_fonte, v.valor_empenho, t.data

--TABELA DIM_FUNCAO:
	
CREATE TABLE data_warehouse.dim_funcao AS
SELECT
    e.cod_funcao AS codigo_funcao,
    MIN(e.dsc_funcao) AS nome_funcao
FROM execucao_financeira_despesa e
GROUP BY e.cod_funcao
ORDER BY e.cod_funcao ASC


--TABELA DIM_SUBFUNCAO:
	
CREATE TABLE data_warehouse.dim_subfuncao AS
SELECT
    e.cod_subfuncao AS codigo_subfuncao,
    MIN(e.dsc_subfuncao) AS nome_subfuncao
FROM execucao_financeira_despesa e
GROUP BY e.cod_subfuncao
ORDER BY e.cod_subfuncao ASC


--TABELA DIM_ITEM:
	
CREATE TABLE data_warehouse.dim_item AS
SELECT
    e.cod_item AS codigo_item,
    MIN(e.dsc_item) AS nome_item
FROM execucao_financeira_despesa e
WHERE e.cod_item IS NOT NULL --incluído para remover uma linha null
GROUP BY e.cod_item
ORDER BY e.cod_item ASC


--TABELA DIM_ITEM_ELEMENTO:
	
CREATE TABLE data_warehouse.dim_item_elemento AS
SELECT
    e.cod_item_elemento AS codigo_item_elemento,
    MIN(e.dsc_item_elemento) AS nome_item_elemento
FROM execucao_financeira_despesa e
WHERE e.cod_item_elemento IS NOT NULL
GROUP BY e.cod_item_elemento 
ORDER BY e.cod_item_elemento  ASC


--TABELA DIM_ITEM_CATEGORIA:

CREATE TABLE data_warehouse.dim_item_categoria AS	
SELECT
    e.cod_item_categoria AS codigo_item_categoria,
    MIN(e.dsc_item_categoria) AS nome_item_categoria
FROM execucao_financeira_despesa e
GROUP BY e.cod_item_categoria 
ORDER BY e.cod_item_categoria  ASC


--TABELA DIM_ITEM_CATEGORIA:
	
CREATE TABLE data_warehouse.dim_item_grupo AS
SELECT
    e.cod_item_grupo AS codigo_item_grupo,
    MIN(e.dsc_item_grupo) AS nome_item_grupo
FROM execucao_financeira_despesa e 
WHERE e.cod_item_grupo IS NOT NULL
GROUP BY e.cod_item_grupo 
ORDER BY e.cod_item_grupo  ASC


--TABELA DIM_ITEM_MODALIDADE:
	
CREATE TABLE data_warehouse.dim_item_modalidade AS
SELECT
    e.cod_item_modalidade AS codigo_item_modalidade,
    MIN(e.dsc_item_modalidade) AS nome_item_modalidade,
	MIN(e.dsc_modalidade_licitacao) AS nome_item_modalidade
FROM execucao_financeira_despesa e 
GROUP BY e.cod_item_modalidade 
ORDER BY e.cod_item_modalidade  ASC


--TABELA DIM_PROGRAMA:
	
CREATE TABLE data_warehouse.dim_programa AS
SELECT
    e.cod_programa AS codigo_programa,
    MIN(e.dsc_programa) AS nome_programa
FROM execucao_financeira_despesa e 
GROUP BY e.cod_programa 
ORDER BY e.cod_programa  ASC











