

--================================================
-- Cap. 6 - VIEWS
-- Uma view serve para armazenar uma instru��o SELECT.
-- Para que utilizar uma VIEW?
--    .Centralizar a instru��o SELECT para que n�o seja necess�rio digit�-la repetidas vezes.
--    .Proteger informa��es (colunas e/ou linhas)
--    .Simplifica��o de c�digo no caso de SELECTs muito complexos.
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

	Protege o c�digo fonte da view, impedindo que ele 
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
	�(s) qual(is) faz refer�ncia, ent�o, n�o podemos fazer modifica��es na(s) tabela(s) se isto implicar 
	em altera��es na defini��o da view
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
FROM DBO.TB_EMPREGADO -- � obrigatorio informar o schema
GO

-- Testando a VIEW

SELECT * FROM VIE_EMP3


-- N�o � poss�vel apagar a coluna da tabela

ALTER TABLE TB_EMPREGADO DROP COLUMN NUM_DEPEND

------------------------------------------------------------
------------------------------------------------------------

/*
****** VIEW INDEXADA ******

	As views podem receber indexes desde que elas tenham sido criadas como SCHEMABINDING.
*/

-- Indice clusterizado e n�o clusterizado

CREATE UNIQUE CLUSTERED INDEX IX_VIE_EMP3_ID_EMPREGADO ON VIE_EMP3(ID_EMPREGADO)
GO

CREATE NONCLUSTERED INDEX IX_VIE_EMP3_NOME ON VIE_EMP3(NOME)

GO
------------------------------------------------------------
------------------------------------------------------------

/*
****** WITH CHECK OPTION ******

	Esta cl�usula faz com que os crit�rios definidos na cl�usula 
	WHERE sejam seguidos no momento em que s�o executados os comandos que 
	realizam a altera��o de dados com rela��o �s view
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
-- Realizando um INSERT atrav�s da VIEW.

INSERT INTO VIE_EMP4 ( NOME, DATA_ADMISSAO, ID_DEPARTAMENTO, ID_CARGO, SALARIO)
VALUES ('TESTE INCLUS�O', GETDATE(), 1, 1, 1000)


-- Exemplo 4
-- Insert realizado com sucesso na tabela 

SELECT TOP 1 * FROM TB_EMPREGADO
ORDER BY 1 DESC

-- Exemplo 5
-- Por�m n�o aparece na VIEW por causa do filtro

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
-- Tentando realizar um novo INSERT atrav�s da VIEW

INSERT INTO VIE_EMP4 ( NOME, DATA_ADMISSAO, ID_DEPARTAMENTO, ID_CARGO, SALARIO)
VALUES ('TESTE INCLUS�O', GETDATE(), 1, 1, 1000)
