
USE db_Ecommerce
GO

-- ***** CURSOR ***** 
/*
O exemplo b�sico de cursor consiste em uma repeti��o (loop) onde um mesmo conjunto
de comandos � executado para todas as linhas do retorno de uma consulta.
*/

/*
 � READ ONLY: Somente leitura. Previne atualiza��es feitas por este cursor
 � FORWARD_ONLY: O cursor pode ser rolado apenas da primeira at� a �ltima linha;
 � STATIC: Cursor que recebe uma c�pia tempor�ria dos dados e que n�o reflete as altera��es da tabela;
 � KEYSET: Consegue avaliar se os registros s�o modificados nas tabelas e retorna um valor -2 para a vari�vel @@FETCH_STATUS;
 � DYNAMIC: O cursor reflete as altera��es das linhas dos dados originais.
*/

-- Exemplo 1
/*
	Ser� utilizado um cursor para buscar o nome do supervisor 
e a quantidade de subordinados de cada um:
*/


--Declara as vari�veis de apoio
DECLARE @COD_SUP INT, @SUPERVISOR VARCHAR(35), @QTD INT

--Declara o cursor selecionando os supervisores
DECLARE CURSOR_SUPERVISOR CURSOR FORWARD_ONLY FOR
	SELECT DISTINCT COD_SUPERVISOR 
	FROM TB_EMPREGADO 
	WHERE COD_SUPERVISOR IS NOT NULL

-- Abre o Cursor
OPEN CURSOR_SUPERVISOR

-- Movimenta o Cursor para a 1� linha
FETCH NEXT FROM CURSOR_SUPERVISOR INTO @COD_SUP;

-- Enquanto o cursor possuir linhas, a vari�vel @@FETCH_STATUS estar� com valor 0
WHILE @@FETCH_STATUS = 0
BEGIN
	
	-- Busca o nome do Supervisor
	SELECT @SUPERVISOR = NOME	
	FROM TB_EMPREGADO
	WHERE ID_EMPREGADO = @COD_SUP
	
	-- Busca a quantidade de subordinados do supervisor
	SELECT	@QTD = COUNT(*)		
	FROM TB_EMPREGADO
	WHERE 1=1
	AND COD_SUPERVISOR = @COD_SUP 
	AND ID_EMPREGADO <> @COD_SUP
	
	-- Apresenta a informa��o
	PRINT @SUPERVISOR + ' - ' + CAST(@QTD AS VARCHAR(3)) + ' Subordinados'

	-- Move o cursor para a pr�xima linha
	FETCH NEXT FROM CURSOR_SUPERVISOR INTO @COD_SUP;

END

--Fecha o cursor
CLOSE CURSOR_SUPERVISOR

-- Remove da mem�ria
DEALLOCATE	CURSOR_SUPERVISOR

-----------------------------------------------------------------------------------

-- Exemplo 2
/*
	A procedure exibida a seguir gera um texto a partir da tabela TB_CLIENTE
que cont�m os nomes dos clientes de Minas Gerais, exibindo tr�s nomes por linha:
*/

GO

CREATE PROCEDURE STP_MALA_DIRETA
AS BEGIN

-- Declarar vari�vel do tipo CURSOR para "percorrer" um SELECT
DECLARE CR_MALA CURSOR KEYSET FOR 
	SELECT NOME 
	FROM TB_CLIENTE AS C
	JOIN TB_ENDERECO AS E
	ON C.ID_CLIENTE = E.id_cliente
	WHERE ESTADO = 'MG';

-- Declarar uma vari�vel para cada campo do cursor e Contador de colunas
DECLARE @NOME VARCHAR(50);
DECLARE @CONT INT;

-- Acumulador de nomes. Ser� usada para armazenar os 3 nomes que ser�o gerados para cada linha do texto
DECLARE @NOMES VARCHAR(150)

-- Abrir o cursor
OPEN CR_MALA;

-- Ler a primeira linha do cursor
FETCH FIRST FROM CR_MALA INTO @NOME;

-- Enquanto n�o chegar no final dos dados
WHILE @@FETCH_STATUS = 0
BEGIN
   -- "Limpar" a vari�vel @NOMES
   SET @NOMES = '';

   -- Atribuir 1 � vari�vel @CONT
   SET @CONT = 1;

   -- Enquanto o contador for menor ou igual a 3 e
   -- n�o chegar no final dos dados do SELECT
   WHILE @CONT <= 3 AND @@FETCH_STATUS = 0
   BEGIN

      -- Alterar o nome lido acrescentando espa�os de modo que fique com tamanho total 50
      SET @NOME = @NOME + SPACE( 50 - LEN( @NOME) ); 
   
      -- Concatenar o nome na vari�vel @NOMES
      SET @NOMES = @NOMES + @NOME;
   
      -- Ler o pr�ximo registro
      FETCH NEXT FROM CR_MALA INTO @NOME;
   
      -- Incrementar o contador de colunas
      SET @CONT = @CONT + 1;

   END
   
   -- Imprimir a vari�vel @NOME na �rea de mensagens   
   PRINT @NOMES;

END

-- Fechar o cursor
CLOSE CR_MALA;

-- Liberar mem�ria do cursor
DEALLOCATE CR_MALA;

END
GO

---- Testando
EXEC STP_MALA_DIRETA

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- ***** Query din�micas ***** 

-- Exemplo 1
--Execu��o de um comando diretamente pelo comando EXEC:
EXEC('SELECT * FROM TB_PEDIDO' )

-------------------------

-- Exemplo 2
--Utilizando uma vari�vel:
DECLARE @SQL VARCHAR(300)

SET @SQL = 'SELECT * FROM TB_PEDIDO'
EXEC( @SQL )

-------------------------

-- Exemplo 3
--Compondo um comando com vari�veis:

DECLARE @SQL VARCHAR(300) , @CODCLI INT

SET @CODCLI = 5

SET @SQL = 'SELECT * FROM TB_PEDIDO WHERE ID_CLIENTE=' + CAST(@CODCLI AS VARCHAR(5)) 
EXEC( @SQL )
