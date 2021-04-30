
-- ****** FUNÇÕES DEFINIDAS PELO USUÁRIO ****** 

/*
	Uma função de usuário não pode ser usada para alterar dados, nem pode 
	definir ou criar novos objetos no banco de dados. Ou seja, em uma função 
	definida pelo usuário, não se pode utilizar os comandos UPDATE, INSERT, DELETE, CREATE, ALTER e DROP.
*/

-- Exemplo 1
--Função para receber dois números INT e retornar o maior dos dois:

CREATE FUNCTION FN_MAIOR( @N1 INT, @N2 INT )
	RETURNS INT
AS 
BEGIN
	DECLARE @RET INT;
	
	IF @N1 > @N2
	   SET @RET = @N1
	ELSE
	   SET @RET = @N2;

	RETURN (@RET)
END

GO
-- Testando
SELECT DBO.FN_MAIOR( 5,3 )
SELECT DBO.FN_MAIOR( 7,11 )

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Exemplo 2
/*
	Função para receber uma data e retornar o nome do dia da semana sempre em português, 
		independentemente das configurações do servidor:
*/

CREATE FUNCTION FN_NOME_DIA_SEMANA( @DT DATETIME )
	RETURNS VARCHAR(15)
AS 
BEGIN
	DECLARE @NUM_DS INT, @NOME_DS VARCHAR(15);
	
	SET @NUM_DS = DATEPART( WEEKDAY, @DT );
	
	SET @NOME_DS = CASE @NUM_DS
					 WHEN 1 THEN 'DOMINGO'
					 WHEN 2 THEN 'SEGUNDA-FEIRA'
					 WHEN 3 THEN 'TERÇA-FEIRA'
					 WHEN 4 THEN 'QUARTA-FEIRA'
					 WHEN 5 THEN 'QUINTA-FEIRA'
					 WHEN 6 THEN 'SEXTA-FEIRA'
					 WHEN 7 THEN 'SÁBADO'
				   END -- CASE

	RETURN (@NOME_DS)
END
GO

-- TESTANDO
SELECT 
		NOME, 
		DATA_ADMISSAO, 
		DATENAME(WEEKDAY,DATA_ADMISSAO),
		DBO.FN_NOME_DIA_SEMANA( DATA_ADMISSAO )
FROM TB_EMPREGADO

--
SELECT DBO.FN_NOME_DIA_SEMANA('2013.11.12' )


SELECT DBO.FN_NOME_DIA_SEMANA(GETDATE() )

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Exemplo 3
/*
	Função para gerar um número aleatório em um determinado intervalo. Passaremos para 
		a função o valor mínimo e o valor máximo para o sorteio:
*/

-- Exemplo 
-- OBS.: @MIN + (@MAX - @MIN) * RAND()
SELECT 10 + (20-10) * RAND()
SELECT 5 + (10-5) * RAND()
SELECT 1 + (10-1) * RAND()


-- Versão 1 (Erro)
-- Esse erro acontecerá porque não pode ser chamada uma função não deterministica dentro da function de usuário
GO

CREATE FUNCTION FN_SORTEIO( @MIN INT, @MAX INT )
	RETURNS INT
AS 
BEGIN
	RETURN @MIN + (@MAX - @MIN) * RAND();
END

GO

-- Versão 2 (Sucesso)

CREATE VIEW VIE_RAND
AS 
SELECT RAND() AS NUM_RAND

	SELECT NUM_RAND  FROM VIE_RAND



GO

CREATE FUNCTION FN_SORTEIO( @MIN INT, @MAX INT )
	RETURNS INT
AS 
BEGIN
	DECLARE @RAND FLOAT;
	SELECT @RAND = NUM_RAND FROM VIE_RAND

	RETURN @MIN + (@MAX - @MIN) * @RAND;
END


-- Testando
GO
SELECT DBO.FN_SORTEIO( 5,60 )

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Exemplo 5
-- Função para calcular a diferença entre duas datas

-- O SQL Server possui uma função chamada DATEDIFF, que serve para calcular a diferença entre duas datas.

SELECT DATEDIFF(DAY, '2009.1.1', '2009.1.15')


/*
	Porém, na maioria das vezes, ela não funciona de forma adequada. 
		No exemplo a seguir, note que a diferença entre as datas ainda não é de um (1) mês, 
		somente seria se o dia da segunda data fosse maior ou igual a 20. Contudo, a função retorna 1.
*/
SELECT DATEDIFF(MONTH, '2008.12.20', '2009.1.15')

GO

CREATE FUNCTION FN_DIF_DATAS( @TIPO CHAR(1), @DT1 DATETIME, @DT2 DATETIME )
	RETURNS INT
AS 
BEGIN
	DECLARE @DIA1 INT, @MES1 INT, @ANO1 INT;
	DECLARE @DIA2 INT, @MES2 INT, @ANO2 INT;
	DECLARE @RET INT;

	SET @DIA1 = DAY(@DT1);
	SET @MES1 = MONTH(@DT1);
	SET @ANO1 = YEAR(@DT1);

	SET @DIA2 = DAY(@DT2);
	SET @MES2 = MONTH(@DT2);
	SET @ANO2 = YEAR(@DT2);

IF @TIPO = 'D'
BEGIN 
	SET @RET = CAST(@DT2 - @DT1 AS INT);
END

ELSE IF @TIPO = 'M'
BEGIN
	IF @MES1 <= @MES2
	BEGIN
		SET @RET = 12 * (@ANO2 - @ANO1) + (@MES2 - @MES1)
		
		IF @DIA1 > @DIA2
		BEGIN
			SET @RET = @RET - 1; 
		END
	END
	ELSE
	BEGIN
		SET @RET = 12 * (@ANO2 - (@ANO1 + 1)) + (12 - (@MES1 - @MES2));
		
		IF @DIA1 > @DIA2 
		BEGIN
			SET @RET = @RET - 1; 
		END
	END
END

ELSE
BEGIN 
	SET @RET = @ANO2 - @ANO1;
	
	IF @MES1 > @MES2 
	BEGIN
		SET @RET = @RET - 1;
	END
	
	IF @MES1 = @MES2 AND @DIA1 > @DIA2
	BEGIN
		SET @RET = @RET - 1;
	END
END

RETURN @RET; 

END

GO

-- TESTANDO
SELECT DBO.FN_DIF_DATAS('D', '2009.1.1', '2009.1.15')

SELECT DBO.FN_DIF_DATAS('M', '2008.1.2', '2009.2.15')
SELECT DBO.FN_DIF_DATAS('M', '2008.1.20', '2009.2.15')

SELECT DBO.FN_DIF_DATAS('M', '2008.8.2', '2009.2.15')
SELECT DBO.FN_DIF_DATAS('M', '2007.8.20', '2009.2.15')

SELECT DBO.FN_DIF_DATAS('A', '2006.10.2', '2009.10.15')
SELECT DBO.FN_DIF_DATAS('A', '2006.11.2', '2009.10.15')
SELECT DBO.FN_DIF_DATAS('A', '2006.10.20', '2009.10.20')

GO

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Exemplo 6
-- Função para retornar a primeira palavra de um nome completo:

CREATE FUNCTION FN_PRIM_NOME ( @S VARCHAR(200) )
	RETURNS VARCHAR(200)
AS 
BEGIN
	DECLARE @RET VARCHAR(200);
	DECLARE @CONT INT;
	
	SET @S = LTRIM( @S );
	SET @RET = '';
	SET @CONT = 1;
	
	WHILE @CONT <= LEN(@S)
	BEGIN
		IF SUBSTRING(@S, @CONT, 1) = ' ' 
			BREAK;
			
		SET @RET = @RET + SUBSTRING(@S, @CONT, 1);
		SET @CONT = @CONT + 1;
	END
	RETURN @RET;
END
GO


-- TESTANDO
SELECT DBO.FN_PRIM_NOME( 'CARLOS MAGNO' )
SELECT DBO.FN_PRIM_NOME( '  CARLOS MAGNO' )

GO

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Exemplo 7
--  Função para formatar nomes próprios, com a primeira letra de cada nome em caixa alta e as restantes em caixa baixa:

CREATE FUNCTION FN_PROPER( @S VARCHAR(200) )
	RETURNS VARCHAR(200)
AS 
BEGIN

	DECLARE @RET VARCHAR(200);
	DECLARE	@CONT INT;
	
	SET @RET = UPPER(LEFT(@S,1));
	SET @CONT = 2;
	
	WHILE @CONT <= LEN(@S)
	BEGIN
	
		IF SUBSTRING(@S, @CONT - 1, 1) = ' '
		BEGIN
			SET @RET = @RET + UPPER( SUBSTRING(@S, @CONT, 1) )
		END
		ELSE
		BEGIN
			SET @RET = @RET + LOWER( SUBSTRING(@S, @CONT, 1) )
		END
		
	SET @CONT = @CONT + 1
	
	END
	   
	RETURN @RET;

END

GO

-- Testando

SELECT NOME, DBO.FN_PROPER( NOME ) FROM TB_EMPREGADO

GO





