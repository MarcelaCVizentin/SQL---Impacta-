
-- ***** Trigger DDL ***** 

USE db_Ecommerce
GO

/*
Os triggers DDL são executados em resposta a eventos DDL, 
que correspondem às instruções Transact-SQL, que começam com as seguintes 
palavraschave: CREATE, ALTER e DROP.
*/

select * from sys.server_triggers



-- Exemplo 1
-- Trigger a nivel de banco de dados

CREATE TRIGGER TRG_LOG_BANCO 
ON  DATABASE
	FOR DDL_DATABASE_LEVEL_EVENTS
AS BEGIN

DECLARE @DATA XML, @MSG VARCHAR(5000);

	-- Recupera todas as informações sobre o motivo da execução do trigger
	SET @DATA = EVENTDATA();

	-- Extrai uma informação específica da variável XML
	SET @MSG = @DATA.value('(/EVENT_INSTANCE/EventType)[1]', 'Varchar(100)');
	PRINT @MSG;

	SET @MSG = @DATA.value('(/EVENT_INSTANCE/ObjectType)[1]', 'Varchar(100)');
	PRINT @MSG;

	SET @MSG = @DATA.value('(/EVENT_INSTANCE/ObjectName)[1]', 'Varchar(100)');
	PRINT @MSG;

	SET @MSG = @DATA.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'Varchar(4000)');
	PRINT @MSG;

END
GO

---- TESTAR
CREATE TABLE TESTE ( COD INT, NOME VARCHAR(30) )
GO
ALTER TABLE TESTE ADD E_MAIL VARCHAR(100)
GO
DROP TABLE TESTE
GO

---------------------------------------------------------------------

-- Exemplo 2
-- Desativar a Trigger no banco de dados
DISABLE TRIGGER TRG_LOG_BANCO ON DATABASE;  


-- Exemplo 3
-- Desativar a Trigger no banco de dados
ENABLE TRIGGER TRG_LOG_BANCO ON DATABASE;  


-- Exemplo 4
-- Excluindo a Trigger a nivel de banco de dados 
DROP TRIGGER TRG_LOG_BANCO  
ON DATABASE;  


---------------------------------------------------------------------

-- Exemplo 5

CREATE TRIGGER TRG_LOG_SERVER 
ON ALL SERVER
   FOR CREATE_DATABASE, DROP_DATABASE, ALTER_DATABASE, DDL_DATABASE_LEVEL_EVENTS
AS BEGIN

	DECLARE @DATA XML, @MSG VARCHAR(5000);

	-- Recupera todas as informações sobre o motivo da
	-- execução do trigger
	SET @DATA = EVENTDATA();

	-- Extrai uma informação específica da variável XML
	SET @MSG = @DATA.value('(/EVENT_INSTANCE/EventType)[1]', 'Varchar(100)');
	PRINT @MSG;

	SET @MSG = @DATA.value('(/EVENT_INSTANCE/ObjectType)[1]', 'Varchar(100)');
	PRINT @MSG;

	SET @MSG = @DATA.value('(/EVENT_INSTANCE/ObjectName)[1]', 'Varchar(100)');
	PRINT @MSG;

	SET @MSG = @DATA.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'Varchar(4000)');
	PRINT @MSG;

END
GO

-- TESTAR
CREATE DATABASE TESTE_TRIGGER
GO
USE TESTE_TRIGGER
GO
CREATE TABLE TESTE (C1 INT, C2 VARCHAR(30))
GO
DROP DATABASE TESTE_TRIGGER
GO

---------------------------------------------------------------------

-- Exemplo 6
-- Desabilitar trigger a nivel de servidor
DISABLE Trigger ALL ON ALL SERVER;  


-- Exemplo 7
-- Ativar trigger a nivel de servidor
Enable Trigger ALL ON ALL SERVER;  


-- Exemplo 8
DROP TRIGGER TRG_LOG_SERVER  
ON ALL SERVER; 