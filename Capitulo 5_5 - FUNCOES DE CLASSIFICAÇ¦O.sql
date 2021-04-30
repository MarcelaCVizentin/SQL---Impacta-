
-- ***** FUNÇÕES DE CLASSIFICAÇÃO *****
 

-- ******* ROW_NUMBER *******

USE db_Ecommerce
GO

-- Exemplo 1
-- Numero as linhas
SELECT 
		NOME, 
		TOTAL, 
		ROW_NUMBER() OVER (ORDER BY TOTAL DESC) AS LINHA
FROM 
(
	SELECT  
			C.NOME, 
			SUM(P.VLR_TOTAL) AS TOTAL
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	GROUP BY C.NOME
) AS A


--Exemplo 2
-- Numerando os dados com base no Estado
SELECT 
		NOME, 
		QTD_PEDIDOS, 
		ESTADO, 
		ROW_NUMBER() OVER (PARTITION BY ESTADO ORDER BY QTD_PEDIDOS DESC) AS LINHA
FROM 
(
	SELECT  
			C.NOME, 
			E.ESTADO, 
			COUNT(*) AS QTD_PEDIDOS
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	JOIN TB_ENDERECO AS E ON E.ID_CLIENTE = C.ID_CLIENTE
	WHERE E.ESTADO IS NOT NULL
	GROUP BY C.NOME, E.ESTADO
) AS A

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- ******* RANK *******

--Exemplo 1
-- Fazendo rank de dados (dica: note que as classificações pulam caso o dado se repita)
SELECT 
		NOME, 
		QTD_PEDIDOS, 
		RANK() OVER (ORDER BY QTD_PEDIDOS DESC) AS [CLASSIFICAÇÃO]
FROM 
(
	SELECT  
			C.NOME, 
			E.ESTADO, 
			COUNT(*) AS QTD_PEDIDOS
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	JOIN TB_ENDERECO AS E ON E.ID_CLIENTE = C.ID_CLIENTE
	WHERE E.ESTADO IS NOT NULL
	GROUP BY C.NOME, E.ESTADO
) AS A


--Exemplo 2
-- Fazendo rank dos dados particionando pelo estado
SELECT 
		NOME, 
		ESTADO, 
		QTD_PEDIDOS, 
		RANK() OVER (PARTITION BY ESTADO ORDER BY QTD_PEDIDOS DESC) AS [CLASSIFICAÇÃO]
FROM 
(
	SELECT  
			C.NOME, 
			E.ESTADO, 
			COUNT(*) AS QTD_PEDIDOS
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	JOIN TB_ENDERECO AS E ON E.ID_CLIENTE = C.ID_CLIENTE
	WHERE E.ESTADO IS NOT NULL
	GROUP BY C.NOME, E.ESTADO
) AS A
Order by Estado

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- ******* DENSE_RANK ******* 

--Exemplo 1
-- Tem o mesmo efeito da função RANK, a diferença é que a numeração vai se repetir e depois continuar
SELECT 	
		NOME, 
		QTD_PEDIDOS, 
		DENSE_RANK() OVER (ORDER BY QTD_PEDIDOS DESC) AS [CLASSIFICAÇÃO]
FROM 
(
	SELECT  
		C.NOME, 
		COUNT(*) AS QTD_PEDIDOS
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	GROUP BY C.NOME
) AS A


--Exemplo 2
-- Tem o mesmo efeito da função RANK, a diferença é que a numeração vai se repetir e depois continuar
SELECT 
		NOME, 
		ESTADO,  
		QTD_PEDIDOS, 
		DENSE_RANK() OVER (PARTITION BY ESTADO ORDER BY QTD_PEDIDOS DESC) AS [CLASSIFICAÇÃO]
FROM 
(
	SELECT  
			C.NOME, 
			E.ESTADO, 
			COUNT(*) AS QTD_PEDIDOS
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	JOIN TB_ENDERECO AS E ON E.ID_CLIENTE = C.ID_CLIENTE
	WHERE E.ESTADO IS NOT NULL
	GROUP BY C.NOME, E.ESTADO
) AS A
Order by Estado

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- ******* NTILE *******

--Exemplo 1
-- Com o valor passado para a função ela quebrará todas as linhas respeitando a quantidade solicitada
SELECT 
		NOME, 
		TOTAL, 
		ESTADO, 
		NTILE (10) OVER (ORDER BY TOTAL DESC) AS GRUPO
FROM 
(
		SELECT  
			C.NOME, 
			E.ESTADO, 
			SUM(P.VLR_TOTAL) AS TOTAL
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	JOIN TB_ENDERECO AS E ON E.ID_CLIENTE = C.ID_CLIENTE
	WHERE E.ESTADO IS NOT NULL
	GROUP BY C.NOME, E.ESTADO
) AS A


-- Exemplo 2
-- ROW_NUMBER, RANK, DENSE_RANK e NTILE

SELECT 
		NOME, 
		ESTADO, 
		QTD_PEDIDOS, 
		ROW_NUMBER() OVER (PARTITION BY ESTADO ORDER BY QTD_PEDIDOS DESC) AS ROW_NUMBER,
		RANK()		 OVER (PARTITION BY ESTADO ORDER BY QTD_PEDIDOS DESC) AS RANK,
		DENSE_RANK() OVER (PARTITION BY ESTADO ORDER BY QTD_PEDIDOS DESC) AS DENSE_RANK,
		NTILE (10)	 OVER (PARTITION BY ESTADO ORDER BY QTD_PEDIDOS DESC) AS NTILE
FROM 
(
	SELECT  
			C.NOME, 
			E.ESTADO, 
			COUNT(*) AS QTD_PEDIDOS
	FROM TB_PEDIDO AS P
	JOIN TB_CLIENTE AS C ON C.ID_CLIENTE = P.ID_CLIENTE
	JOIN TB_ENDERECO AS E ON E.ID_CLIENTE = C.ID_CLIENTE
	WHERE E.ESTADO IS NOT NULL
	GROUP BY C.NOME, E.ESTADO
) AS A
