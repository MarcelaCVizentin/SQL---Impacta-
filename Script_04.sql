DECLARE @result int
EXEC @result = xp_cmdshell 'dir C:\Bancos'
IF (@result <> 0)
	Exec master.dbo.xp_cmdshell 'Md C:\Bancos'

EXEC @result = xp_cmdshell 'dir C:\Bancos\faculdade'
IF (@result <> 0)
	Exec master.dbo.xp_cmdshell 'Md C:\Bancos\faculdade'


go
 
-- 1 --> 4
CREATE DATABASE faculdade
ON PRIMARY
(
  name= 'Fac_Dados1',
  filename='C:\Bancos\faculdade\fac_dados1.mdf',
  size= 10MB,
  maxsize=Unlimited,
  filegrowth= 10MB
),
FILEGROUP INDICES
(
  name= 'fac_indices1',
  filename='C:\Bancos\faculdade\fac_indices1.ndf',
  size= 10MB,
  maxsize=Unlimited,
  filegrowth= 10MB
)

LOG ON
(
  name= 'fac_Log',
  filename='C:\Bancos\faculdade\fac_Log.ldf',
  size= 10MB,
  maxsize=10MB,
  filegrowth= 10MB
)
go