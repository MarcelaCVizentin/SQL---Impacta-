
USE db_Ecommerce
GO

-- ***** CURSOR ***** 
/*
O exemplo básico de cursor consiste em uma repetição (loop) onde um mesmo conjunto
de comandos é executado para todas as linhas do retorno de uma consulta.
*/

/*
 • READ ONLY: Somente leitura. Previne atualizações feitas por este cursor
 • FORWARD_ONLY: O cursor pode ser rolado apenas da primeira até a última linha;
 • STATIC: Cursor que recebe uma cópia temporária dos dados e que não reflete as alterações da tabela;
 • KEYSET: Consegue avaliar se os registros são modificados nas tabelas e retorna um valor -2 para a variável @@FETCH_STATUS;
 • DYNAMIC: O cursor reflete as alterações das linhas dos dados originais.
*/

-- Exemplo 1
/*
	Será utilizado um cursor para buscar o nome do supervisor 
e a quantidade de subordinados de cada um:
*/


--Declara as variáveis de apoio
DECLARE @COD_SUP INT, @SUPERVISOR VARCHAR(35), @QTD INT

--Declara o cursor selecionando os supervisores
DECLARE CURSOR_SUPERVISOR CURSOR FORWARD_ONLY FOR
	SELECT DISTINCT COD_SUPERVISOR 
	FROM TB_EMPREGADO 
	WHERE COD_SUPERVISOR IS NOT NULL

-- Abre o Cursor
OPEN CURSOR_SUPERVISOR

-- Movimenta o Cursor para a 1ª linha
FETCH NEXT FROM CURSOR_SUPERVISOR INTO @COD_SUP;

-- Enquanto o cursor possuir linhas, a variável @@FETCH_STATUS estará com valor 0
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
	
	-- Apresenta a informação
	PRINT @SUPERVISOR + ' - ' + CAST(@QTD AS VARCHAR(3)) + ' Subordinados'

	-- Move o cursor para a próxima linha
	FETCH NEXT FROM CURSOR_SUPERVISOR INTO @COD_SUP;

END

--Fecha o cursor
CLOSE CURSOR_SUPERVISOR

-- Remove da memória
DEALLOCATE	CURSOR_SUPERVISOR

-----------------------------------------------------------------------------------

-- Exemplo 2
/*
	A procedure exibida a seguir gera um texto a partir da tabela TB_CLIENTE
que contém os nomes dos clientes de Minas Gerais, exibindo três nomes por linha:
*/

GO

CREATE PROCEDURE STP_MALA_DIRETA
AS BEGIN

-- Declarar variável do tipo CURSOR para "percorrer" um SELECT
DECLARE CR_MALA CURSOR KEYSET FOR 
	SELECT NOME 
	FROM TB_CLIENTE AS C
	JOIN TB_ENDERECO AS E
	ON C.ID_CLIENTE = E.id_cliente
	WHERE ESTADO = 'MG';

-- Declarar uma variável para cada campo do cursor e Contador de colunas
DECLARE @NOME VARCHAR(50);
DECLARE @CONT INT;

-- Acumulador de nomes. Será usada para armazenar os 3 nomes que serão gerados para cada linha do texto
DECLARE @NOMES VARCHAR(150)

-- Abrir o cursor
OPEN CR_MALA;

-- Ler a primeira linha do cursor
FETCH FIRST FROM CR_MALA INTO @NOME;

-- Enquanto não chegar no final dos dados
WHILE @@FETCH_STATUS = 0
BEGIN
   -- "Limpar" a variável @NOMES
   SET @NOMES = '';

   -- Atribuir 1 à variável @CONT
   SET @CONT = 1;

   -- Enquanto o contador for menor ou igual a 3 e
   -- não chegar no final dos dados do SELECT
   WHILE @CONT <= 3 AND @@FETCH_STATUS = 0
   BEGIN

      -- Alterar o nome lido acrescentando espaços de modo que fique com tamanho total 50
      SET @NOME = @NOME + SPACE( 50 - LEN( @NOME) ); 
   
      -- Concatenar o nome na variável @NOMES
      SET @NOMES = @NOMES + @NOME;
   
      -- Ler o próximo registro
      FETCH NEXT FROM CR_MALA INTO @NOME;
   
      -- Incrementar o contador de colunas
      SET @CONT = @CONT + 1;

   END
   
   -- Imprimir a variável @NOME na área de mensagens   
   PRINT @NOMES;

END

-- Fechar o cursor
CLOSE CR_MALA;

-- Liberar memória do cursor
DEALLOCATE CR_MALA;

END
GO

---- Testando
EXEC STP_MALA_DIRETA

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- ***** Query dinâmicas ***** 

-- Exemplo 1
--Execução de um comando diretamente pelo comando EXEC:
EXEC('SELECT * FROM TB_PEDIDO' )

-------------------------

-- Exemplo 2
--Utilizando uma variável:
DECLARE @SQL VARCHAR(300)

SET @SQL = 'SELECT * FROM TB_PEDIDO'
EXEC( @SQL )

-------------------------

-- Exemplo 3
--Compondo um comando com variáveis:

DECLARE @SQL VARCHAR(300) , @CODCLI INT

SET @CODCLI = 5

SET @SQL = 'SELECT * FROM TB_PEDIDO WHERE ID_CLIENTE=' + CAST(@CODCLI AS VARCHAR(5)) 
EXEC( @SQL )
