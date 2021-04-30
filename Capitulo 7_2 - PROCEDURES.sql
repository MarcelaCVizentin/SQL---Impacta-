USE db_ecommerce

GO
-- Exemplo 1.
-- Procedures aninhadas e exibindo o nivel de aninhamento com @@NESTLEVEL

CREATE PROCEDURE PROC_A
AS BEGIN
	PRINT 'PROC_A  -  ' + CAST( @@NESTLEVEL AS VARCHAR(2) );
	EXEC PROC_B;
	PRINT 'VOLTEI PARA PROC_A'
END

GO

CREATE PROCEDURE PROC_B
AS BEGIN
	PRINT 'PROC_B  -  ' + CAST( @@NESTLEVEL AS VARCHAR(2) );
	EXEC PROC_C;
	PRINT 'VOLTEI PARA PROC_B'
END

GO

CREATE PROCEDURE PROC_C
AS BEGIN
	PRINT 'PROC_C  -  ' + CAST( @@NESTLEVEL AS VARCHAR(2) );
END

GO

-- Executando a procedure
EXEC PROC_A

-----------------------------------------------------------------------------------------


-- Exemplo 2.

GO
CREATE PROCEDURE STP_TOT_VENDIDO @ANO INT
AS 
BEGIN
	SELECT 
			MONTH( DATA_EMISSAO ) AS MES,
			YEAR( DATA_EMISSAO ) AS ANO,
			SUM( VLR_TOTAL ) AS TOT_VENDIDO
	FROM TB_PEDIDO
	WHERE YEAR(DATA_EMISSAO) = @ANO
	GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)
	ORDER BY MES
END

GO

--- Testando
EXEC STP_TOT_VENDIDO 2018
EXEC STP_TOT_VENDIDO 2019

GO

-----------------------------------------------------------------------------------------

-- Exemplo 3.
-- Passando valores para os parametros de forma posicional e nominal

CREATE PROCEDURE STP_ITENS_PEDIDO	@DT1 DATETIME, 
									@DT2 DATETIME, 
									@DESCRICAO VARCHAR(40) = '%',
									@VENDEDOR VARCHAR(40) = '%'
AS BEGIN
	SELECT 
			I.ID_PEDIDO, 
			I.ITEM, 
			I.ID_PRODUTO, 
			I.QUANTIDADE, 
			I.PR_UNITARIO, 
			I.DESCONTO, 
			I.DATA_ENTREGA,
			PE.DATA_EMISSAO, 
			PR.DESCRICAO, 
			C.NOME AS CLIENTE,
			V.NOME AS VENDEDOR
	FROM TB_PEDIDO PE
	JOIN TB_CLIENTE C ON PE.ID_CLIENTE = C.ID_CLIENTE
	JOIN TB_EMPREGADO V ON PE.ID_EMPREGADO = V.ID_EMPREGADO
	JOIN TB_ITENSPEDIDO I ON PE.ID_PEDIDO = I.ID_PEDIDO
	JOIN TB_PRODUTO PR ON I.ID_PRODUTO = PR.ID_PRODUTO
	WHERE 1=1 
	AND	PE.DATA_EMISSAO BETWEEN @DT1 AND @DT2
	AND	PR.DESCRICAO LIKE @DESCRICAO
	AND V.NOME LIKE @VENDEDOR 
	ORDER BY I.ID_PEDIDO
END
GO

-- Passando todos os parâmetros
EXEC STP_ITENS_PEDIDO '2019.1.1', '2019.1.31', '%CANETA%', 'MARCELO'


-- Omitindo o nome do vendedor
EXEC STP_ITENS_PEDIDO '2019.1.1', '2019.1.31', '%CANETA%'


-- Omitindo o nome do vendedor e do cliente
EXEC STP_ITENS_PEDIDO '2019.1.1', '2019.1.31'


--Se tentarmos, contudo, omitir apenas o nome do cliente, a passagem posicional não será adequada, como podemos observar a seguir
EXEC STP_ITENS_PEDIDO '2018.1.1', '2019.1.31', '%MARCELO%' 
--                    @DT1,      @DT2,       @CLIENTE

  
--Os parâmetros também podem ser passados nominalmente, conforme vemos a seguir:
EXEC STP_ITENS_PEDIDO @DT1 = '2019.1.1', @DT2 = '2019.1.31', @VENDEDOR = 'MARCELO%'

-----------------------------------------------------------------------------------------

-- Exemplo 4.
/*
Por meio do comando RETURN, é possível fazer com que a procedure 
	retorne um valor, que deve ser um número inteiro, no seu próprio nome.
O retorno de valor com RETURN é utilizado normalmente para sinalizar algum 
	tipo de erro na execução ou para indicar que a procedure não conseguiu executar 
	o que foi solicitado
*/
GO

CREATE PROCEDURE STP_ULT_DATA_COMPRA @ID_CLIENTE INT
AS BEGIN

IF NOT EXISTS( SELECT * FROM TB_PEDIDO WHERE ID_CLIENTE = @ID_CLIENTE )
   RETURN -1;
               
	SELECT MAX(DATA_EMISSAO) AS ULT_DATA_COMPRA 
	FROM TB_PEDIDO 
	WHERE ID_CLIENTE = @ID_CLIENTE;

END 
GO
                   
-- Teste 1
DECLARE @RET INT;
EXEC @RET = STP_ULT_DATA_COMPRA 3
IF @RET < 0 
PRINT 'NÃO EXISTE PEDIDO DESTE CLIENTE'

-- Teste 2
DECLARE @RET INT;
EXEC @RET = STP_ULT_DATA_COMPRA 1
IF @RET < 0 
PRINT 'NÃO EXISTE PEDIDO DESTE CLIENTE'

-----------------------------------------------------------------------------------------

-- Exemplo 5.
-- Usando o scope_identity para obter o ID utilizado
GO

ALTER PROCEDURE STP_COPIA_PRODUTO @ID_PRODUTO INT
AS BEGIN

	DECLARE @ID_PRODUTO_NOVO INT;

	-- Copia o registro existente para um novo registro
	INSERT INTO TB_PRODUTO
		(DESCRICAO, ID_UNIDADE, ID_TIPO, PRECO_CUSTO, PRECO_VENDA, 
		 QTD_REAL, QTD_MINIMA, CLAS_FISC, IPI, PESO_LIQ )
	SELECT 
		 DESCRICAO, ID_UNIDADE, ID_TIPO, PRECO_CUSTO, PRECO_VENDA, 
		QTD_REAL, QTD_MINIMA, CLAS_FISC, IPI, PESO_LIQ
	FROM TB_PRODUTO
	WHERE ID_PRODUTO = @ID_PRODUTO;

	-- Descobre qual foi o ID_PRODUTO gerado
	SET @ID_PRODUTO_NOVO = SCOPE_IDENTITY();

	-- Retorna para a aplicação cliente o novo ID_PRODUTO gerado
	SELECT @ID_PRODUTO_NOVO AS ID_PRODUTO_NOVO;
--	PRINT @ID_PRODUTO_NOVO;  


END
GO

-- Testando
EXEC STP_COPIA_PRODUTO 10

-----------------------------------------------------------------------------------------

-- Exemplo 6.
GO

ALTER PROCEDURE STP_COPIA_PRODUTO @ID_PRODUTO INT,
                                  @ID_PRODUTO_NOVO INT OUTPUT
AS BEGIN

	-- Copia o registro existente para um novo registro
	-- Copia o registro existente para um novo registro
	INSERT INTO TB_PRODUTO
		(DESCRICAO, ID_UNIDADE, ID_TIPO, PRECO_CUSTO, PRECO_VENDA, 
		 QTD_REAL, QTD_MINIMA, CLAS_FISC, IPI, PESO_LIQ )
	SELECT 
		 DESCRICAO, ID_UNIDADE, ID_TIPO, PRECO_CUSTO, PRECO_VENDA, 
		QTD_REAL, QTD_MINIMA, CLAS_FISC, IPI, PESO_LIQ
	FROM TB_PRODUTO
	WHERE ID_PRODUTO = @ID_PRODUTO;

	-- Descobre qual foi o ID_PRODUTO gerado
	SET @ID_PRODUTO_NOVO = SCOPE_IDENTITY();

END
GO

-- Testando
DECLARE @IDPROD INT;
EXEC STP_COPIA_PRODUTO 10, @IDPROD OUTPUT;
PRINT 'NOVO PRODUTO = ' + CAST(@IDPROD AS VARCHAR(5));