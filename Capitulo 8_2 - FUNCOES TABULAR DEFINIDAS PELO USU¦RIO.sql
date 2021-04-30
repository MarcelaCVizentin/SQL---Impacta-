USE db_Ecommerce
GO

-- Exemplo 1
-- Função para retornar o valor do maior pedido vendido em cada um dos meses de determinado período:

CREATE FUNCTION FN_MAIOR_PEDIDO( @DT1 DATETIME, @DT2 DATETIME )
	RETURNS TABLE
AS
RETURN 
( 
	SELECT 
			MONTH(DATA_EMISSAO)	AS MES, 
			YEAR(DATA_EMISSAO)	AS ANO, 
			MAX(VLR_TOTAL )		AS MAIOR_VALOR
	FROM TB_PEDIDO
	WHERE DATA_EMISSAO BETWEEN @DT1 AND @DT2
	GROUP BY 
			MONTH( DATA_EMISSAO ), 
			YEAR( DATA_EMISSAO ) 
)
GO

-- Testando

SELECT * FROM DBO.FN_MAIOR_PEDIDO( '2019.1.1', '2019.12.31')
ORDER BY ANO, MES

GO

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- Exemplo 2
-- Função para listar os funcionários de cada departamento

alter FUNCTION FN_TOT_DEPTOS( @Departamento VARCHAR(500))
	RETURNS @TotDeptos TABLE 
			(	
				ID_DEPARTAMENTO INT, 
				NOME VARCHAR(40),          
				VALOR NUMERIC(12,2),
				DEPARTAMENTO VARCHAR(40)
			)
AS 
BEGIN

	INSERT INTO @TotDeptos
	SELECT 
			TE.ID_DEPARTAMENTO, 
			TE.NOME, 
			TE.SALARIO,
			TD.DEPARTAMENTO
	FROM TB_EMPREGADO TE 
	JOIN TB_DEPARTAMENTO TD ON TE.ID_DEPARTAMENTO = TD.ID_DEPARTAMENTO
	WHERE TD.DEPARTAMENTO = @Departamento
	
RETURN
	
END -- FUNCTION

GO
--
SELECT * FROM FN_TOT_DEPTOS('COMPRAS')


GO
