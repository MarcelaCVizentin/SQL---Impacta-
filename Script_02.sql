-- Este código verifica se há no disco C:\ uma pasta chamada Bancos e se não 
-- houver ela será criada
DECLARE @result int
EXEC @result = xp_cmdshell 'dir C:\Bancos'
IF (@result <> 0)
   Exec master.dbo.xp_cmdshell 'MD C:\Bancos'

EXEC @result = xp_cmdshell 'dir C:\Bancos\Empresa'
IF (@result <> 0)
   Exec master.dbo.xp_cmdshell 'MD C:\Bancos\Empresa'

go
--1 --> 4
-- Criando o database Empresa

CREATE DATABASE Empresa
ON
(
  name= 'Empresa_Dados1',
  filename='C:\Bancos\Empresa\Empresa_Dados1.mdf',
  size= 10MB,
  maxsize=100MB,
  filegrowth= 10MB
),
(
  name= 'Empresa_Dados2',
  filename='C:\Bancos\Empresa\Empresa_Dados2.ndf',
  size= 10MB,
  maxsize=100MB,
  filegrowth= 10MB
)
LOG ON
(
  name= 'Empresa_Log',
  filename='C:\Bancos\Empresa\Empresa_Log.ldf',
  size= 10MB,
  maxsize=10MB,
  filegrowth= 10MB
) 
go
Use Empresa
go

--5 
CREATE TABLE Funcionario
(
Cod_Func	Int	,
Nome_Func	Varchar(100)
)
go
--6
INSERT Funcionario VALUES(1,'Jorge')
INSERT Funcionario VALUES(2,'Ronaldo')
INSERT Funcionario VALUES(3,'Cláudia')
INSERT Funcionario VALUES(4,'Francisco')
INSERT Funcionario VALUES(5,'Agnaldo')
go
Use Empresa
go

--7
Exec SP_HelpFile
go
--8
Exec SP_HelpFileGroup
go

--9
Exec SP_HelpSort
go
--10
SELECT * FROM ::Fn_HelpCollations()
WHERE Description = 'Latin1-General, case-insensitive, accent-sensitive, kanatype-insensitive, width-insensitive for Unicode Data, SQL Server Sort Order 52 on Code Page 1252 for non-Unicode Data'
go

--11
Exec SP_Help 'Funcionario'
go
