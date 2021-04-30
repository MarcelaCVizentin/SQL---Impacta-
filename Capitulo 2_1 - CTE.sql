/*
Podemos usar uma CTE para:

* Criar uma consulta recursiva;
* Substituir uma view quando o uso geral de uma viewo n�o � necess�ria, isto �, voc� n�o tem que armazenar a defini��o em metadados;
* Permitir o agrupamento de uma coluna que � derivada de uma subsele��o escalar ou uma fun��o que � ou n�o determinista ou tem acesso externo;
* Referenciar a tabela resultante v�rias vezes na mesma declara��o;
*/

/*
Uma CTE � composta de:

* um nome de express�o representando a CTE,
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
-- Membro �ncora
SELECT MONTH( DATA_EMISSAO ) AS MES,
       YEAR( DATA_EMISSAO ) AS ANO,
       MAX( VLR_TOTAL ) AS MAIOR_TB_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2019
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)	
)
-- Utiliza��o da CTE fazendo JOIN com a tabela TB_PEDIDO
SELECT CTE.MES, CTE.ANO, CTE.MAIOR_TB_PEDIDO, P.ID_PEDIDO
FROM CTE JOIN TB_PEDIDO P 
	ON CTE.MES = MONTH(P.DATA_EMISSAO) 
    AND CTE.ANO = YEAR(P.DATA_EMISSAO)
    AND CTE.MAIOR_TB_PEDIDO = P.VLR_TOTAL;


-- Contador
WITH CONTADOR ( N )
AS
(
	-- Membro �ncora
    SELECT 1
    UNION ALL
    -- Membro recursivo
    SELECT N+1 FROM CONTADOR WHERE N < 100
)
-- Execu��o da CTE
SELECT * FROM CONTADOR;

-- Pot�ncias de 5

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
(	-- Membro �ncora
	SELECT ID_EMPREGADO, NOME, ID_DEPARTAMENTO, COD_SUPERVISOR, NOME
	FROM TB_Empregado WHERE COD_SUPERVISOR = 0
	UNION ALL
	-- Membro recursivo
	SELECT E.ID_CARGO, E.NOME, E.ID_DEPARTAMENTO, E.COD_SUPERVISOR, CTE.NOME
	FROM TB_Empregado E JOIN CTE ON E.COD_SUPERVISOR = CTE.CODFUN
)	-- Execu��o da CTE
SELECT CTE.CODFUN AS [C�digo], CTE.NOME AS [Funcion�rio], 
       D.DEPARTAMENTO AS [Departamento], CTE.NOME_SUP AS [Nome Supervisor]
FROM CTE JOIN TB_EMPREGADO E ON CTE.CODFUN = E.ID_CARGO
         JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
ORDER BY CTE.ID_DEPARTAMENTO;
