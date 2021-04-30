USE db_Ecommerce
GO

-- ******* Trigger de logon *******
/*
Um tipo especial de trigger são aqueles relacionados ao logon. 
Este tipo permite tanto auditar o acesso quanto bloquear acessos indevidos.
*/

-- Exemplo 1
-- Criar login

CREATE LOGIN Adm_Impacta WITH PASSWORD = 'teste123'

GO

-- Criar a Trigger a nivel de servidor 
CREATE TRIGGER TRG_Bloqueio_SSMS
ON ALL SERVER
	FOR LOGON
AS
BEGIN

	IF (ORIGINAL_LOGIN() LIKE 'Adm_%') AND APP_NAME() LIKE 'Microsoft SQL Server Management Studio%'
		ROLLBACK
END

-- Agora, tente executar o acesso ao management studio através do usuário Adm_Impacta

GO

-------------------------------------------------------------------------------------------

-- Exemplo 2

CREATE TABLE master.dbo.DBA_AuditLogin
(
	idPK				int		IDENTITY,
	Data				datetime,
	ProcID				int,
	LoginID				varchar(128),
	NomeHost			varchar(128),
	App					varchar(128),
	SchemaAutenticacao	varchar(128),
	Protocolo			varchar(128),
	IPcliente			varchar(30),
	IPservidor			varchar(30),
	xmlConectInfo		xml
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


--Criação de um trigger de logon

CREATE TRIGGER DBA_AuditLogin 
ON ALL SERVER
	FOR LOGON
AS
BEGIN

	INSERT INTO master.dbo.DBA_AuditLogin
	select 
		getdate(),
		@@spid,
		s.login_name,
		s.[host_name],
		s.program_name,
		c.auth_scheme,
		c.net_transport,
		c.client_net_address,
		c.local_net_address,
		eventdata()
	from sys.dm_exec_sessions s 
	join sys.dm_exec_connections c
	on s.session_id = c.session_id
	where s.session_id = @@spid

END
GO

-- Verificando os usuários logados
select * from master.dbo.DBA_AuditLogin
