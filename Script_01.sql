Use Master
go
-- Este código verifica se há no disco C:\ uma pasta chamada Bancos e se não 
-- houver ela será criada
DECLARE @result int
EXEC @result = xp_cmdshell 'dir C:\Bancos'
IF (@result <> 0)
   Exec master.dbo.xp_cmdshell 'MD C:\Bancos'


EXEC @result = xp_cmdshell 'dir C:\Bancos\Escola'
IF (@result <> 0)
   Exec master.dbo.xp_cmdshell 'MD C:\Bancos\Escola'
go

-- Laboratório 2

--1 --> 4
CREATE DATABASE Escola
ON
(
  name= 'Escola_Dados',
  filename='C:\Bancos\escola\Escola_Dados.mdf',
  size= 10MB,
  maxsize=100MB,
  filegrowth= 10MB
)
LOG ON
(
  name= 'Escola_Log',
  filename='C:\Bancos\escola\Escola_Log.ldf',
  size= 10MB,
  maxsize=10MB,
  filegrowth= 10MB
)
go
Use Escola
go
--5
Exec SP_HelpFile
go

--6
Exec SP_HelpFileGroup
go

--7
Exec SP_HelpSort
go
--8
SELECT * FROM ::Fn_HelpCollations()
WHERE Description = 'Latin1-General, case-insensitive, accent-sensitive, kanatype-insensitive, width-insensitive for Unicode Data, SQL Server Sort Order 52 on Code Page 1252 for non-Unicode Data'
go
