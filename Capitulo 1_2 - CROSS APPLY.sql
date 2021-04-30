
USE db_Ecommerce

--CROSS APPLY

--Consulta apresentando o c�digo e nome do cliente, Valor total e data da -- emiss�o. 
SELECT C.ID_CLIENTE, C.NOME,P.ID_PEDIDO,P.VLR_TOTAL, P.DATA_EMISSAO
FROM TB_CLIENTE AS C
JOIN TB_PEDIDO AS P 
ON P.ID_CLIENTE = C.ID_CLIENTE 
ORDER BY C.ID_CLIENTE,P.ID_PEDIDO


--Adicionando as colunas quantidade de pedidos, maior e menor valor de compra e a �ltima data de pedido.

SELECT  
		C.ID_CLIENTE, 
		C.NOME,
		P.ID_PEDIDO,
		P.VLR_TOTAL, 
		P.DATA_EMISSAO,
		(SELECT COUNT(*) FROM TB_PEDIDO WHERE ID_CLIENTE = C.ID_CLIENTE) AS QTD_PED,
		(SELECT MAX(VLR_TOTAL) FROM TB_PEDIDO WHERE ID_CLIENTE = C.ID_CLIENTE) AS MAIOR_VALOR,
		(SELECT MIN(VLR_TOTAL) FROM TB_PEDIDO WHERE ID_CLIENTE = C.ID_CLIENTE) AS MENOR_VALOR,
		(SELECT MAX(DATA_EMISSAO) FROM TB_PEDIDO WHERE ID_CLIENTE = C.ID_CLIENTE) AS ULTIMA_COMPRA
FROM TB_CLIENTE AS C
JOIN TB_PEDIDO AS P 
	ON P.ID_CLIENTE = C.ID_CLIENTE 
ORDER BY C.ID_CLIENTE,P.ID_PEDIDO


---Utilizando o CROSS APPLY

SELECT	C.ID_CLIENTE,
		C.NOME,
		P.ID_PEDIDO,
		P.VLR_TOTAL, 
		P.DATA_EMISSAO,
		CR.QTD_PED, 
		CR.MAIOR_VALOR, 
		CR.MENOR_VALOR,   
        CR.DATAMAXIMA 	
FROM TB_CLIENTE AS C
JOIN TB_PEDIDO AS P 
	ON P.ID_CLIENTE = C.ID_CLIENTE 
CROSS APPLY
( 
	SELECT	
		COUNT(*) AS QTD_PED, 
		MAX(VLR_TOTAL) AS MAIOR_VALOR,
		MIN(VLR_TOTAL) AS MENOR_VALOR,
		MAX(DATA_EMISSAO) AS DATAMAXIMA 
	FROM TB_PEDIDO  AS P
	WHERE C.ID_CLIENTE = P.ID_CLIENTE 
) AS CR
ORDER BY C.ID_CLIENTE,P.ID_PEDIDO


-- EXEMPLO 2 
--Consulta com filtro dos pedidos de 2019.

SELECT  C.ID_CLIENTE, 
		C.NOME,
		P.ID_PEDIDO,
		P.VLR_TOTAL, 
		P.DATA_EMISSAO,
		(SELECT COUNT(*) FROM TB_PEDIDO WHERE YEAR(DATA_EMISSAO) = 2019 AND ID_CLIENTE = C.ID_CLIENTE) AS QTD_PED,
		(SELECT MAX(VLR_TOTAL) FROM TB_PEDIDO WHERE YEAR(DATA_EMISSAO) = 2019 AND ID_CLIENTE = C.ID_CLIENTE) AS MAIOR_VALOR,
		(SELECT MIN(VLR_TOTAL) FROM TB_PEDIDO WHERE YEAR(DATA_EMISSAO) = 2019 AND ID_CLIENTE = C.ID_CLIENTE) AS MENOR_VALOR,
		(SELECT MAX(DATA_EMISSAO) FROM TB_PEDIDO WHERE YEAR(DATA_EMISSAO) = 2019 AND ID_CLIENTE = C.ID_CLIENTE) AS ULTIMA_COMPRA
FROM TB_CLIENTE AS C
JOIN TB_PEDIDO AS P 
	ON P.ID_CLIENTE = C.ID_CLIENTE 
WHERE YEAR(DATA_EMISSAO) = 2019


--UTILIZANDO O CROSS APPLY

SELECT	C.ID_CLIENTE, 
		C.NOME,
		P.ID_PEDIDO,
		P.VLR_TOTAL, 
		P.DATA_EMISSAO,
		CR.QTD_PED, 
		CR.MAIOR_VALOR , 
		CR.MENOR_VALOR , 
		CR.DATAMAXIMA 
FROM TB_CLIENTE AS C
JOIN TB_PEDIDO AS P 
ON P.ID_CLIENTE = C.ID_CLIENTE 
CROSS APPLY
( 
	SELECT	
			COUNT(*) AS QTD_PED, 
			MAX(VLR_TOTAL) AS MAIOR_VALOR,
			MIN(VLR_TOTAL) AS MENOR_VALOR,
			MAX(DATA_EMISSAO) AS DATAMAXIMA 
	FROM TB_PEDIDO  AS PC
	WHERE C.ID_CLIENTE = PC.ID_CLIENTE AND YEAR(PC.DATA_EMISSAO) = 2019 
) AS CR
WHERE  YEAR(P.DATA_EMISSAO) = 2019
ORDER BY C.ID_CLIENTE,P.ID_PEDIDO



-- OUTER APPLY
-- J� o OUTER APPLY possui uma caracter�stica parecida com a do LEFT JOIN

SELECT 
		D.DEPARTAMENTO , 
		E.NOME 
FROM TB_DEPARTAMENTO AS D
LEFT JOIN TB_EMPREGADO AS E 
	ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO 
ORDER BY 2


SELECT 
		D.DEPARTAMENTO , 
		CA.NOME 
FROM TB_DEPARTAMENTO AS D
OUTER  APPLY 
(SELECT E.NOME FROM TB_EMPREGADO  AS E WHERE E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO ) AS CA
ORDER BY 2

