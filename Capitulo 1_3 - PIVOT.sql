USE db_Ecommerce

--PIVOT

/* 
2.7. Consultas cruzadas
A criação de uma consulta cruzada consiste em rotacionar os resultados de uma consulta 
de maneira que as linhas sejam exibidas verticalmente e as colunas, horizontalmente.
*/

GO


/*
Imaginemos uma situação em que precisássemos totalizar as vendas de cada vendedor em 
cada um dos meses do ano. Bastaria utilizar um GROUP BY, como mostra o exemplo a seguir:
*/

SELECT 
	ID_EMPREGADO, 
	MONTH(DATA_EMISSAO) AS MES, 
	YEAR(DATA_EMISSAO) AS ANO,
	SUM(VLR_TOTAL) AS TOT_VENDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2019
GROUP BY 
   ID_EMPREGADO , MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO) 
ORDER BY 1,2,3

-- Consulta de vendas por vendedor

SELECT ID_EMPREGADO, [1] AS MES1, [2] AS MES2, [3] AS MES3, 
               [4] AS MES4, [5] AS MES5, [6] AS MES6, 
               [7] AS MES7, [8] AS MES8, [9] AS MES9, 
               [10] AS MES10, [11] AS MES11, [12] AS MES12
FROM 
(
	SELECT 
		ID_EMPREGADO, 
		VLR_TOTAL, 
		MONTH(DATA_EMISSAO) AS MES
	FROM TB_PEDIDO
	WHERE YEAR(DATA_EMISSAO) = 2019
) P
PIVOT( SUM(VLR_TOTAL) FOR MES IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]) ) AS PVT
ORDER BY 1  

--Consulta vendas por vendedor (com nome)
SELECT	
		ID_EMPREGADO, 
		NOME, 
		[1] AS MES1, [2] AS MES2, [3] AS MES3, [4] AS MES4, [5] AS MES5, 
		[6] AS MES6, [7] AS MES7, [8] AS MES8, [9] AS MES9, [10] AS MES10,
		[11] AS MES11, [12] AS MES12
FROM 
(
	SELECT 
		P.ID_EMPREGADO, 
		V.NOME, 
		P.VLR_TOTAL, 
		MONTH(P.DATA_EMISSAO) AS MES
	FROM TB_PEDIDO P 
	JOIN TB_EMPREGADO V 
	ON P.ID_EMPREGADO = V.ID_EMPREGADO
	WHERE YEAR(P.DATA_EMISSAO) = 2019
) P
PIVOT( SUM(VLR_TOTAL) FOR MES IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PVT
ORDER BY 1

--Consulta vendas por cliente
SELECT ID_CLIENTE, [1] AS MES1, [2] AS MES2, [3] AS MES3, [4] AS MES4, 
               [5] AS MES5, [6] AS MES6, [7] AS MES7, [8] AS MES8, 
               [9] AS MES9, [10] AS MES10,[11] AS MES11, 
               [12] AS MES12
FROM 
(
	SELECT	
		ID_CLIENTE, 
		VLR_TOTAL, 
		MONTH(DATA_EMISSAO) AS MES
	FROM TB_PEDIDO
	WHERE YEAR(DATA_EMISSAO) = 2019
) P
PIVOT( SUM(VLR_TOTAL) FOR MES IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PVT
ORDER BY 1 


-- NÃO FUNCIONA
SELECT ID_DEPARTAMENTO, ['A'], ['B'], ['C'], ['D'], ['E']
FROM 
(
	SELECT 
		ID_EMPREGADO,
		ID_DEPARTAMENTO, 
		LEFT(NOME,1) AS LETRA 
	FROM TB_EMPREGADO
) AS P
PIVOT (COUNT(ID_EMPREGADO) FOR LETRA IN (['A'], ['B'], ['C'], ['D'], ['E'])) AS PVT



-- FUNCIONA
SELECT ID_DEPARTAMENTO, [65], [66], [67], [68], [69]
FROM 
(
	SELECT 
		ID_EMPREGADO,
		ID_DEPARTAMENTO, 
		ASCII( UPPER(LEFT(NOME,1))) AS LETRA 
	FROM TB_EMPREGADO
) AS P
PIVOT (COUNT(ID_EMPREGADO) FOR LETRA IN ([65], [66], [67], [68], [69])) AS PVT


--UNPIVOT
-- Gira uma tabela transformando colunas em linhas.
GO
CREATE TABLE FREQ_CINEMA
( DIA_SEMANA TINYINT, 
  SEC_14HS   INT, 
  SEC_16HS   INT, 
  SEC_18HS   INT, 
  SEC_20HS   INT, 
  SEC_22HS   INT )
  
INSERT FREQ_CINEMA VALUES ( 1, 80, 100, 130, 90, 70 )  
INSERT FREQ_CINEMA VALUES ( 2, 20, 34, 75, 50, 30 )
INSERT FREQ_CINEMA VALUES ( 3, 25, 40, 80, 70, 25 )
INSERT FREQ_CINEMA VALUES ( 4, 30, 45, 70, 50, 30 )
INSERT FREQ_CINEMA VALUES ( 5, 35, 40, 60, 60, 40 )
INSERT FREQ_CINEMA VALUES ( 6, 25, 34, 70, 90, 110 )
INSERT FREQ_CINEMA VALUES ( 7, 30, 80, 130, 150, 180 )


SELECT * FROM FREQ_CINEMA

-- Consulta frequência cinema por dia
-- Perceba que é necessário adicionar duas coluna. Uma coluna que conterá os valores das colunas que você está girando, no cenário abaixo é HORARIO.
-- E a segunda coluna chamda QTD_PESSOAS que conterá os valores que atualmente existem nas colunas que estão sendo girados.

SELECT DIA_SEMANA, HORARIO, QTD_PESSOAS             
FROM
(               
	SELECT 
		DIA_SEMANA, 
		SEC_14HS, 
		SEC_16HS, 
		SEC_18HS, 
		SEC_20HS, 
		SEC_22HS
	FROM FREQ_CINEMA
) P
UNPIVOT ( QTD_PESSOAS FOR HORARIO IN (SEC_14HS, SEC_16HS, SEC_18HS, SEC_20HS, SEC_22HS)) AS UP







