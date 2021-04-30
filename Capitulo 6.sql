
USE db_Ecommerce
GO

-- ****** Declaração de variáveis ******

-- Exemplo 1. 

DECLARE @A INT = 10;
DECLARE @B INT = 20;
PRINT @A + @B

-- OU ENTÃO

DECLARE @A INT = 10, @B INT = 20;
PRINT @A + @B

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** Atribuição com SET ******

-- Exemplo 2. 

DECLARE @A INT = 10, 
		@B INT = 20, 
		@C INT;
		
SET @C = @A + @B;

PRINT @C;

-- OU ENTÃO

DECLARE @A INT, @B INT, @C INT;

SET @A = 10;
SET @B = 20;
SET @C = @A + @B;

PRINT @C;


-- Exemplo 3. Também é possível realizar a operação a partir da instrução SELECT

DECLARE @A INT

SELECT @A = 3

SELECT @A AS Valor

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** Instrução IF ******

-- Exemplo 4 

-- Neste caso, como @A NÃO É MAIOR que @B, as instruções contidas no IF 
-- não serão executadas e somente o último PRINT funcionará   

DECLARE @A INT = 10, 
		@B INT = 15;

IF @A > @B
   BEGIN
	   PRINT @A;
	   PRINT 'É MAIOR QUE';
	   PRINT @B;
   END
PRINT 'CONTINUAÇÃO DO CÓDIGO'


-- Exemplo 5
-- Neste caso, como @A É MAIOR que @B, as instruções contidas no IF 
-- serão executadas e também o último PRINT funcionará porque está fora do IF  


DECLARE @A INT = 15, 
		@B INT = 10;

IF @A > @B
   BEGIN
	   PRINT @A;
	   PRINT 'É MAIOR QUE';
	   PRINT @B;
   END
PRINT 'CONTINUAÇÃO DO CÓDIGO'

-- Exemplo 6
-- Neste caso, temos um bloco tanto para o caso verdadeiro quanto para o caso falso  

DECLARE @A INT = 15, @B INT = 10;

IF @A > @B
   BEGIN
	   PRINT @A;
	   PRINT 'É MAIOR QUE';
	   PRINT @B;
   END
ELSE
   BEGIN
	   PRINT @A;
	   PRINT 'NÃO É MAIOR QUE';
	   PRINT @B;
   END   
PRINT 'CONTINUAÇÃO DO CÓDIGO'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** LOOPS WHILE ******

-- Exemplo 7. 
-- Exemplo 7.1. Números inteiros de 0 até 100

DECLARE @CONT INT = 0;

WHILE @CONT <= 100
   BEGIN
	   PRINT @CONT;
	   SET @CONT += 1; -- OU SET @CONT = @CONT + 1
   END
PRINT 'FIM'


-- Exemplo 7.2. Números inteiros de 100 até 0

DECLARE @CONT INT = 100;

WHILE @CONT >= 0
   BEGIN
	   PRINT @CONT;
	   SET @CONT -= 1; -- OU SET @CONT = @CONT - 1
   END
PRINT 'FIM'


-- Exemplo 7.3. Tabuadas do 1 ao 10 (Loops encadeados)

DECLARE @T INT = 1, 
		@N INT;
		
WHILE @T <= 10
   BEGIN
	   PRINT 'TABUADA DO ' + CAST(@T AS VARCHAR(2));
	   PRINT '';
	   SET @N = 1;   
   WHILE @N <= 10
      BEGIN
		  PRINT CAST(@T AS VARCHAR(2)) + ' x ' + CAST(@N AS VARCHAR(2)) + ' = ' + CAST(@T*@N AS VARCHAR(3));
		  SET @N += 1;       
      END -- WHILE @N 
	   SET @T += 1;
	   PRINT '';   
END -- WHILE @T


-- Exemplo 7.4. Palpites para a mega-sena

DECLARE @DEZENA INT, 
		@CONT INT = 1;
		
WHILE @CONT <= 6
   BEGIN
	   SET @DEZENA = 1 + 60 * RAND();
	   PRINT @DEZENA;
	   SET @CONT += 1;
   END
PRINT 'BOA SORTE';


-- Exemplo 7.5. Palpites para a mega-sena (versão 2 para não repetir a mesma dezena)

DECLARE @DEZENA INT, 
		@CONT INT = 1;
		
IF OBJECT_ID('TBL_MEGASENA') IS NOT NULL
   DROP TABLE TBL_MEGASENA;
   
CREATE TABLE TBL_MEGASENA
( 
	NUM_DEZENA INT 
);
   
WHILE @CONT <= 6
	BEGIN
		SET @DEZENA = 1 + 60 * RAND();
		IF EXISTS( SELECT * FROM TBL_MEGASENA WHERE NUM_DEZENA = @DEZENA )
			CONTINUE;
		INSERT INTO TBL_MEGASENA VALUES (@DEZENA);
		SET @CONT += 1;
	END

SELECT * FROM TBL_MEGASENA 
ORDER BY NUM_DEZENA;   

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** GOTO ******

-- Exemplo 8. 
A:
PRINT 'AGORA ESTOU NO PONTO "A"'
GOTO C

B:
PRINT 'AGORA ESTOU NO PONTO "B"'
GOTO D

C:
PRINT 'AGORA ESTOU NO PONTO "C"'
GOTO B

D:
PRINT 'AGORA ESTOU NO PONTO "D"'
PRINT 'FIM. QUE BAGUNÇA!'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** RETURN ******

-- Exemplo 9.

PRINT 'AGORA ESTOU NO PONTO "A"'
PRINT 'AGORA ESTOU NO PONTO "B"'
RETURN
PRINT 'AGORA ESTOU NO PONTO "C"'
PRINT 'AGORA ESTOU NO PONTO "D"'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** WAITFOR ******

-- Exemplo 9.

WAITFOR DELAY '00:00:05'
PRINT 'ESPEREI 5 SEGUNDOS'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** EXISTS ******

-- Exemplo 10.

IF EXISTS (SELECT * FROM DBO.TB_CLIENTE WHERE ID_CLIENTE=43)
	BEGIN
		PRINT 'Código existe'
	END
ELSE
	BEGIN
		PRINT 'Código não existe'
	END

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


-- ****** Atribuição de valor de uma consulta ******
-- Exemplo 11.	

DECLARE @SOMA DECIMAL(10,2)

SET @SOMA = (SELECT SUM(VLR_TOTAL) FROM DBO.tb_PEDIDO WHERE VLR_TOTAL IS NOT NULL)

PRINT @SOMA

   

