/*
Podemos usar uma CTE para:

* Criar uma consulta recursiva;
* Substituir uma view quando o uso geral de uma viewo não é necessária, isto é, você não tem que armazenar a definição em metadados;
* Permitir o agrupamento de uma coluna que é derivada de uma subseleção escalar ou uma função que é ou não determinista ou tem acesso externo;
* Referenciar a tabela resultante várias vezes na mesma declaração;
*/

/*
Uma CTE é composta de:

* um nome de expressão representando a CTE,
* uma lista de colunas opcionais,
* e uma consulta definindo a CTE.
*/

USE db_Ecommerce
go

SELECT MONTH( DATA_EMISSAO ) AS MES,
       YEAR( DATA_EMISSAO ) AS ANO,
       MAX( VLR_TOTAL ) AS MAIOR_TB_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2019
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)	
ORDER BY MES;


WITH CTE( MES, ANO, MAIOR_TB_PEDIDO )
AS
(
-- Membro âncora
SELECT MONTH( DATA_EMISSAO ) AS MES,
       YEAR( DATA_EMISSAO ) AS ANO,
       MAX( VLR_TOTAL ) AS MAIOR_TB_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2019
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)	
)
-- Utilização da CTE fazendo JOIN com a tabela TB_PEDIDO
SELECT CTE.MES, CTE.ANO, CTE.MAIOR_TB_PEDIDO, P.ID_PEDIDO
FROM CTE JOIN TB_PEDIDO P 
	ON CTE.MES = MONTH(P.DATA_EMISSAO) 
    AND CTE.ANO = YEAR(P.DATA_EMISSAO)
    AND CTE.MAIOR_TB_PEDIDO = P.VLR_TOTAL;


-- Contador
WITH CONTADOR ( N )
AS
(
	-- Membro âncora
    SELECT 1
    UNION ALL
    -- Membro recursivo
    SELECT N+1 FROM CONTADOR WHERE N < 100
)
-- Execução da CTE
SELECT * FROM CONTADOR;

-- Potências de 5

WITH POTENCIAS_DE_5 ( EXPOENTE, POTENCIA )
AS
(
    SELECT 1,5
    UNION ALL
    SELECT EXPOENTE+1, POTENCIA * 5 
    FROM POTENCIAS_DE_5 
    WHERE EXPOENTE < 10
)
SELECT * FROM POTENCIAS_DE_5;


-- Recursividade 
WITH CTE( CODFUN, NOME, ID_DEPARTAMENTO, CODSUP, NOME_SUP )
AS
(	-- Membro âncora
	SELECT ID_EMPREGADO, NOME, ID_DEPARTAMENTO, COD_SUPERVISOR, NOME
	FROM TB_Empregado WHERE COD_SUPERVISOR = 0
	UNION ALL
	-- Membro recursivo
	SELECT E.ID_CARGO, E.NOME, E.ID_DEPARTAMENTO, E.COD_SUPERVISOR, CTE.NOME
	FROM TB_Empregado E JOIN CTE ON E.COD_SUPERVISOR = CTE.CODFUN
)	-- Execução da CTE
SELECT CTE.CODFUN AS [Código], CTE.NOME AS [Funcionário], 
       D.DEPARTAMENTO AS [Departamento], CTE.NOME_SUP AS [Nome Supervisor]
FROM CTE JOIN TB_EMPREGADO E ON CTE.CODFUN = E.ID_CARGO
         JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
ORDER BY CTE.ID_DEPARTAMENTO;
