

--================================================
-- Cap. 6 - VIEWS
-- Uma view serve para armazenar uma instrução SELECT.
-- Para que utilizar uma VIEW?
--    .Centralizar a instrução SELECT para que não seja necessário digitá-la repetidas vezes.
--    .Proteger informações (colunas e/ou linhas)
--    .Simplificação de código no caso de SELECTs muito complexos.
--------------------------------------------------- 

-- SYSCOMMENTS

SELECT TEXT FROM SYSCOMMENTS


USE db_Ecommerce
GO

--****** Criando, Alterando e Excluindo uma VIEW ******

-- Exemplo 1.
-- Criando a VIEW

CREATE VIEW VIE_EMP1 
AS
SELECT 
		ID_EMPREGADO, 
		NOME, 
		DATA_ADMISSAO, 
		ID_DEPARTAMENTO, 
		ID_CARGO, 
		SALARIO
FROM TB_EMPREGADO


-- Testando a VIEW

SELECT * FROM VIE_EMP1
-- OU
SELECT 	
		ID_EMPREGADO, 
		NOME 
FROM VIE_EMP1


-- Exemplo 2
-- Alterando a VIEW 

ALTER VIEW VIE_EMP1 
AS
SELECT 
		ID_EMPREGADO, 
		NOME, 
		ID_CARGO, -- Adicionando um novo campo
		SALARIO
FROM TB_EMPREGADO


-- Testando a VIEW

SELECT * FROM VIE_EMP1


-- Exemplo 3
-- Excluindo a VIEW

DROP VIEW VIE_EMP1

------------------------------------------------------------
------------------------------------------------------------

/*
****** WITH ENCRYPTION: ****** 

	Protege o código fonte da view, impedindo que ele 
	seja aberto a partir do Object Explorer;
*/

-- Exemplo 2. 

CREATE VIEW VIE_EMP2
WITH ENCRYPTION
AS
SELECT TOP 100 
		ID_EMPREGADO, 
		NOME, 
		DATA_ADMISSAO, 
		ID_DEPARTAMENTO, 
		ID_CARGO, 
		SALARIO
FROM TB_EMPREGADO
ORDER BY NOME
GO

------------------------------------------------------------
------------------------------------------------------------

/*
****** SCHEMABINDING ******

	Quando especificamos SCHEMABINDING, a view fica ligada ao esquema (estrutura) da(s) tabela(s) 
	à(s) qual(is) faz referência, então, não podemos fazer modificações na(s) tabela(s) se isto implicar 
	em alterações na definição da view
*/


CREATE VIEW VIE_EMP3 
WITH ENCRYPTION, SCHEMABINDING
AS
SELECT 
		ID_EMPREGADO, 
		NOME, 
		DATA_ADMISSAO, 
		ID_DEPARTAMENTO, 
		ID_CARGO, 
		SALARIO, 
		NUM_DEPEND
FROM DBO.TB_EMPREGADO -- é obrigatorio informar o schema
GO

-- Testando a VIEW

SELECT * FROM VIE_EMP3


-- Não é possível apagar a coluna da tabela

ALTER TABLE TB_EMPREGADO DROP COLUMN NUM_DEPEND

------------------------------------------------------------
------------------------------------------------------------

/*
****** VIEW INDEXADA ******

	As views podem receber indexes desde que elas tenham sido criadas como SCHEMABINDING.
*/

-- Indice clusterizado e não clusterizado

CREATE UNIQUE CLUSTERED INDEX IX_VIE_EMP3_ID_EMPREGADO ON VIE_EMP3(ID_EMPREGADO)
GO

CREATE NONCLUSTERED INDEX IX_VIE_EMP3_NOME ON VIE_EMP3(NOME)

GO
------------------------------------------------------------
------------------------------------------------------------

/*
****** WITH CHECK OPTION ******

	Esta cláusula faz com que os critérios definidos na cláusula 
	WHERE sejam seguidos no momento em que são executados os comandos que 
	realizam a alteração de dados com relação às view
*/

-- Exemplo 1
-- View criada com WHERE

CREATE VIEW VIE_EMP4 
WITH ENCRYPTION
AS
SELECT 
		ID_EMPREGADO, 
		NOME, 
		DATA_ADMISSAO, 
		ID_DEPARTAMENTO, 
		ID_CARGO, 
		SALARIO
FROM TB_EMPREGADO
WHERE ID_DEPARTAMENTO = 2
GO


-- Exemplo 2 
-- Executando a consulta
SELECT * FROM VIE_EMP4


-- Exemplo 3
-- Realizando um INSERT através da VIEW.

INSERT INTO VIE_EMP4 ( NOME, DATA_ADMISSAO, ID_DEPARTAMENTO, ID_CARGO, SALARIO)
VALUES ('TESTE INCLUSÃO', GETDATE(), 1, 1, 1000)


-- Exemplo 4
-- Insert realizado com sucesso na tabela 

SELECT TOP 1 * FROM TB_EMPREGADO
ORDER BY 1 DESC

-- Exemplo 5
-- Porém não aparece na VIEW por causa do filtro

SELECT * FROM VIE_EMP4

GO


-- Exemplo 6
-- Alterando a VIEW e utilizando o WITH CHECK OPTION

ALTER VIEW VIE_EMP4 
WITH ENCRYPTION
AS
SELECT ID_EMPREGADO, NOME, DATA_ADMISSAO, 
       ID_DEPARTAMENTO, ID_CARGO, SALARIO
FROM TB_EMPREGADO
WHERE ID_DEPARTAMENTO = 2
WITH CHECK OPTION


-- Exemplo 7
-- Tentando realizar um novo INSERT através da VIEW

INSERT INTO VIE_EMP4 ( NOME, DATA_ADMISSAO, ID_DEPARTAMENTO, ID_CARGO, SALARIO)
VALUES ('TESTE INCLUSÃO', GETDATE(), 1, 1, 1000)
