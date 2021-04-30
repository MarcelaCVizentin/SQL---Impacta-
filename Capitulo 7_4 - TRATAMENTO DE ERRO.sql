
USE PEDIDOS
GO
-- ***** Adicionado mensagem de erro ***** 

/* Verificar a pagina 309 para informações sobre mensagens de erro */

--Para consultar as mensagens, utilize a tabela de sistemas SYS.MESSAGES:
SELECT * FROM SYS.messages ORDER BY 1 DESC


--Adicionando uma mensagem de erro devido à quantidade nula, severidade 16 e código 50001:
EXEC SP_ADDMESSAGE 50001,16,'Proibido inserir quantidade nula.';


--Para consultar a mensagem criada
SELECT * FROM SYS.messages where message_id = 50001


-- Idioma configurado na mensagem customizada
select * from syslanguages where lcid IN(1033,2070)


-- Adicionando a mesma mensagem no idioma Portugues 
EXEC SP_ADDMESSAGE 50001,16,'Proibido inserir quantidade nula.', 'Portuguese';


--Excluindo a mensagem: 
EXEC SP_DROPMESSAGE 50001, 'Portuguese';


-- Tentando excluir mensagem nativa, receberá um erro
EXEC SP_DROPMESSAGE 49925, 'Portuguese';

----------------------------------------------------------------------
----------------------------------------------------------------------

-- ****** RAISERROR E THROW ******

--Neste exemplo será retornada a mensagem de código 50001 criada com o SP_ADDMESAGE:
RAISERROR (50001,-1,-1, 'Erro!!');


-- Neste exemplo, é exibido um erro com qualquer codigo
THROW 60000, 'PRODUTO NÃO EXISTE',1

----------------------------------------------------------------------
----------------------------------------------------------------------

GO

-- ****** TRY CATCH ******

-- Exemplo 1 
-- Faz o PRECO_VENDA de TB_PRODUTO ficar menor que o PRECO_CUSTO
UPDATE TB_PRODUTO SET PRECO_VENDA = PRECO_CUSTO * 0.9
WHERE ID_PRODUTO = 1

 
-- Cria CONSTRAINT que impede que o PRECO_VENDA seja menor que PRECO_CUSTO
-- a cláusula WITH NOCHECK é necessária, pois já existe uma linha violando esta CONSTRAINT

ALTER TABLE TB_PRODUTO WITH NOCHECK 
ADD CONSTRAINT CK_PRECO_VENDA1 CHECK(PRECO_VENDA >= PRECO_CUSTO)
GO

-- procedure para criar uma cópia de um produto
CREATE PROCEDURE STP_COPIA_PRODUTO @ID_PRODUTO_FONTE INT
AS BEGIN

-- declara variável para o ID do novo produto gerado
DECLARE @ID_PRODUTO_NOVO INT;

	BEGIN TRY
		-- se o ID_PRODUTO passado como parâmetro não existir	
	IF NOT EXISTS(SELECT * FROM TB_PRODUTO WHERE ID_PRODUTO = @ID_PRODUTO_FONTE) 
	BEGIN
		-- gera um erro, o que provoca a execução do bloco CATCH
		THROW 60000, 'PRODUTO NÃO EXISTE',1
	END
	
	-- executa INSERT de SELECT na tabela TB_PRODUTO para efetuar a cópia
	INSERT INTO TB_PRODUTO ( COD_PRODUTO, DESCRICAO, COD_UNIDADE, COD_TIPO, PRECO_CUSTO, PRECO_VENDA, 
							 QTD_ESTIMADA, QTD_REAL, QTD_MINIMA, CLAS_FISC, IPI, PESO_LIQ)
	SELECT 
			COD_PRODUTO, DESCRICAO, COD_UNIDADE, COD_TIPO, PRECO_CUSTO, PRECO_VENDA, 
			QTD_ESTIMADA, QTD_REAL, QTD_MINIMA, CLAS_FISC, IPI, PESO_LIQ
	FROM TB_PRODUTO WHERE ID_PRODUTO = @ID_PRODUTO_FONTE
	
	-- descobre o novo ID_PRODUTO gerado
	SET @ID_PRODUTO_NOVO = SCOPE_IDENTITY()

	-- se os dados de TB_PRODUTO estivessem contidos em mais de uma tabela, aqui viriam 
	-- os outros INSERTs retorna o novo ID_PRODUTO para a aplicação que executou a procedure
	SELECT @ID_PRODUTO_NOVO AS ID_PRODUTO_NOVO, 'SUCESSO' AS MSG
	
END TRY
BEGIN CATCH

    -- recupera informações sobre o erro ocorrido
	-- que pode ser o erro de constraint, que já preparamos,
	-- ou pode ser o erro gerado dentro do bloco TRY
	DECLARE @ERRO VARCHAR(1000) = ERROR_MESSAGE();
	DECLARE @NUM INT = ERROR_NUMBER();
	DECLARE @STATUS INT = ERROR_STATE();

	THROW @NUM, @ERRO, @STATUS
END CATCH
END
GO

-- Verificando ID que tem problema de constraint
SELECT ID_PRODUTO, PRECO_VENDA, PRECO_CUSTO 
FROM TB_PRODUTO
WHERE PRECO_VENDA < PRECO_CUSTO
GO

-- Verifique que, ao executar a procedure, ocorrerá um ERRO por causa da constraint
EXEC STP_COPIA_PRODUTO 1


-- ERRO gerado no bloco TRY
EXEC STP_COPIA_PRODUTO 999


-- Execução com sucesso
EXEC STP_COPIA_PRODUTO 10

----------------------------------------------------------------------
----------------------------------------------------------------------

-- Exemplo 2

-- uma CONSTRAINT que impedirá o cadastramento de um item de pedido (TB_ITENSPEDIDO) 
-- com QUANTIDADE igual a zero (0):
ALTER TABLE TB_ITENSPEDIDO WITH NOCHECK
ADD CONSTRAINT UQ_ITENSPEDIDO_QUANTIDADE
CHECK( QUANTIDADE > 0 )


-- Versão 2000 não existia o TRY CATCH
CREATE PROCEDURE STP_COPIA_PEDIDO @NUM_PEDIDO_ANTIGO INT
AS BEGIN
DECLARE @NUM_PEDIDO_NOVO INT

-- Abrir processo de transação
BEGIN TRAN

-- Abrir bloco protegido de erro
BEGIN TRY

	-- Inserir em TB_PEDIDO
	INSERT INTO TB_PEDIDO (CODCLI,CODVEN,DATA_EMISSAO,VLR_TOTAL, SITUACAO,OBSERVACOES)
	SELECT CODCLI,CODVEN,DATA_EMISSAO,VLR_TOTAL, SITUACAO,OBSERVACOES 
	FROM TB_PEDIDO 
	WHERE NUM_PEDIDO = @NUM_PEDIDO_ANTIGO

	-- Descobrir o num. pedido gerado
	SET @NUM_PEDIDO_NOVO = SCOPE_IDENTITY()

	-- Inserir em TB_ITENSPEDIDO
	INSERT INTO TB_ITENSPEDIDO( NUM_PEDIDO,NUM_ITEM,ID_PRODUTO,	COD_PRODUTO,CODCOR, QUANTIDADE,
								PR_UNITARIO, DATA_ENTREGA,SITUACAO,DESCONTO )
	SELECT @NUM_PEDIDO_NOVO, NUM_ITEM, ID_PRODUTO, COD_PRODUTO,CODCOR, QUANTIDADE,
			PR_UNITARIO, DATA_ENTREGA,SITUACAO,DESCONTO
	FROM TB_ITENSPEDIDO 
	WHERE NUM_PEDIDO = @NUM_PEDIDO_ANTIGO

	-- Retornar com o num. pedido gerado
	SELECT @NUM_PEDIDO_NOVO AS NUM_PEDIDO_NOVO,
           'SUCESSO' AS MSG_ERRO

	-- Finalizar transação gravando
	COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    SELECT -1 AS NUM_PEDIDO_NOVO, ERROR_MESSAGE() AS MSG_ERRO

END CATCH
END

GO

GO

-- Codigo com erro
EXEC STP_COPIA_PEDIDO 999

-- Codigo com sucesso
EXEC STP_COPIA_PEDIDO 1

