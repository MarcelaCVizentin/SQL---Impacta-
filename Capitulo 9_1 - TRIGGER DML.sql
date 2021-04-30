
select * from sys.triggers

USE db_Ecommerce
GO

/*
O SQL Server inclui três tipos genéricos de triggers:

 • Triggers DML (Data Manipulation Language);
 • Triggers DDL (Data Definition Language);
 • Triggers de logon.

*/

-- Exemplo 1

CREATE TABLE EMPREGADOS_HIST_SALARIO
( 
	NUM_MOVTO INT IDENTITY,
	ID_EMPREGADO INT,
	DATA_ALTERACAO DATETIME,
	SALARIO_ANTIGO NUMERIC(12,2),	
	SALARIO_NOVO NUMERIC(12,2),
	CONSTRAINT PK_EMPREGADOS_HIST_SALARIO PRIMARY KEY (NUM_MOVTO) 
)
GO

--Vejamos o procedimento de criação do trigger: 
CREATE TRIGGER TRG_EMPREGADOS_HIST_SALARIO 
ON TB_EMPREGADO 
	FOR UPDATE
AS BEGIN

	DECLARE @ID_EMPREGADO INT, @SALARIO_ANTIGO FLOAT, @SALARIO_NOVO FLOAT;

	-- Ler os dados antigos
	SELECT @SALARIO_ANTIGO = SALARIO FROM DELETED;

	-- Ler os dados novos
	SELECT @ID_EMPREGADO = ID_EMPREGADO, @SALARIO_NOVO = SALARIO FROM INSERTED;

	-- Se houver alteração de salário
	IF @SALARIO_ANTIGO <> @SALARIO_NOVO

	-- Inserir dados na tabela de histórico
	INSERT INTO [EMPREGADOS_HIST_SALARIO] (ID_EMPREGADO, DATA_ALTERACAO, SALARIO_ANTIGO, SALARIO_NOVO)
	VALUES (@ID_EMPREGADO, GETDATE(), @SALARIO_ANTIGO, @SALARIO_NOVO) 	

END

GO

-- Testar
UPDATE TB_EMPREGADO SET SALARIO = SALARIO * 1.2
WHERE ID_EMPREGADO = 3

-- Observar que foi inserido na tabela o registro referente à alteração efetuada
SELECT * FROM [EMPREGADOS_HIST_SALARIO] 

---------------------------------------------

-- Exemplo 2
-- Alterar o salário "em lote"

UPDATE TB_EMPREGADO SET SALARIO = SALARIO * 1.2
WHERE ID_EMPREGADO IN (4,5,7)

-- Conferir se foram gerados os históricos para os 3 funcionários
SELECT * FROM EMPREGADOS_HIST_SALARIO 


GO

ALTER TRIGGER TRG_EMPREGADOS_HIST_SALARIO 
ON TB_EMPREGADO
	FOR UPDATE
AS BEGIN

	INSERT INTO EMPREGADOS_HIST_SALARIO
	(ID_EMPREGADO, DATA_ALTERACAO, SALARIO_ANTIGO, SALARIO_NOVO)
	SELECT 
			I.ID_EMPREGADO, 
			GETDATE(), 
			D.SALARIO, 
			I.SALARIO
	FROM INSERTED I 
	JOIN DELETED D 
	ON I.ID_EMPREGADO = D.ID_EMPREGADO
	WHERE I.SALARIO <> D.SALARIO

END
GO

-- Testar
DELETE FROM EMPREGADOS_HIST_SALARIO 

UPDATE TB_EMPREGADO SET SALARIO = SALARIO * 1.2
WHERE ID_EMPREGADO IN (4,5,7)
--
SELECT * FROM EMPREGADOS_HIST_SALARIO 
GO

---------------------------------------------

-- Exemplo 3

CREATE TRIGGER TRG_CORRIGE_VLR_TOTAL 
ON TB_ITENSPEDIDO
   FOR DELETE, INSERT, UPDATE
AS BEGIN

	-- Se o trigger foi executado por DELETE
	IF NOT EXISTS( SELECT * FROM INSERTED )
	BEGIN
		UPDATE P
		SET VLR_TOTAL = (SELECT SUM( PR_UNITARIO * QUANTIDADE * ( 1 - DESCONTO/100 ) )
						 FROM TB_ITENSPEDIDO
						 WHERE ID_PEDIDO = P.ID_PEDIDO
						 )
		FROM TB_PEDIDO P 
		JOIN DELETED D
		ON P.ID_PEDIDO = D.ID_PEDIDO
	END

	-- Se o trigger foi executado por INSERT ou UPDATE
	ELSE
	BEGIN
		UPDATE TB_PEDIDO
		SET VLR_TOTAL = (SELECT SUM( PR_UNITARIO * QUANTIDADE * ( 1 - DESCONTO/100 ) )
						FROM TB_ITENSPEDIDO
						WHERE ID_PEDIDO = P.ID_PEDIDO
						)
		FROM TB_PEDIDO P 
		JOIN INSERTED I
		ON P.ID_PEDIDO = I.ID_PEDIDO
	END

END

GO

-- Testar
SELECT * FROM TB_PEDIDO WHERE ID_PEDIDO = 1000

-- Pedido 1000 -> VLR_TOTAL = 380
SELECT * FROM TB_ITENSPEDIDO WHERE ID_PEDIDO = 1000


-- Possui um único item com PR_UNITARIO = 1
UPDATE TB_ITENSPEDIDO SET PR_UNITARIO = 2
WHERE ID_PEDIDO = 1000

--
SELECT * FROM TB_PEDIDO WHERE ID_PEDIDO = 1000


-- Deletando o Item do pedido 1000
DELETE FROM TB_ITENSPEDIDO WHERE ID_PEDIDO = 1000


-- Campo VLR_TOTAL está nulo
SELECT * FROM TB_PEDIDO WHERE ID_PEDIDO = 1000

------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Exemplo 4
-- USANDO TRIGGER INSTEAD OF

ALTER TABLE TB_CLIENTE
ADD SN_ATIVO CHAR(1) NOT NULL DEFAULT 'S'


GO
CREATE TRIGGER TRG_CLIENTES_DESATIVA 
ON TB_CLIENTE
	INSTEAD OF DELETE
AS BEGIN

	UPDATE TB_CLIENTE SET SN_ATIVO = 'N'
	FROM TB_CLIENTE C 
	JOIN DELETED D ON C.ID_CLIENTE = D.ID_CLIENTE

END
GO

-- TESTAR
SELECT ID_CLIENTE, NOME, SN_ATIVO FROM TB_CLIENTE
--
DELETE FROM TB_CLIENTE WHERE ID_CLIENTE IN (4,7,11)
--
SELECT ID_CLIENTE, NOME, SN_ATIVO FROM TB_CLIENTE WHERE ID_CLIENTE IN (4,7,11)

------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Exemplo 5
-- Desativar a trigger da tabela
DISABLE TRIGGER TRG_CLIENTES_DESATIVA ON TB_CLIENTE;  


-- Exemplo 6
-- Desativar a trigger da tabela
ENABLE TRIGGER TRG_CLIENTES_DESATIVA ON TB_CLIENTE;  


-- Exemplo 7
-- Excluir a trigger da tabela
DROP TRIGGER TRG_CLIENTES_DESATIVA
