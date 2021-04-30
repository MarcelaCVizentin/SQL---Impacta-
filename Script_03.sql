-- Este código verifica se há no disco C:\ uma pasta chamada Bancos e se não 
-- houver ela será criada
DECLARE @result int
EXEC @result = xp_cmdshell 'dir C:\Bancos'
IF (@result <> 0)
   Exec master.dbo.xp_cmdshell 'MD C:\Bancos'

EXEC @result = xp_cmdshell 'dir C:\Bancos\Impacta'
IF (@result <> 0)
   Exec master.dbo.xp_cmdshell 'MD C:\Bancos\Impacta'

go
------------------------------------------------------------------

-- 1 --> 4
CREATE DATABASE Impacta
ON PRIMARY
(
  name= 'Impacta_Dados1',
  filename='C:\Bancos\Impacta\Impacta_primary1.mdf',
  size= 10MB,
  maxsize=Unlimited,
  filegrowth= 10MB
),
FILEGROUP Tabelas
(
  name= 'Impacta_Dados2',
  filename='C:\Bancos\Impacta\Impacta_Dados1.ndf',
  size= 10MB,
  maxsize=Unlimited,
  filegrowth= 10MB
),
FILEGROUP INDICES
(
  name= 'Impacta_Indices1',
  filename='C:\Bancos\Impacta\Impacta_Indices1.ndf',
  size= 10MB,
  maxsize=Unlimited,
  filegrowth= 10MB
)
LOG ON
(
  name= 'Impacta_Log1',
  filename='C:\Bancos\Impacta\Impacta_Log1.ldf',
  size= 10MB,
  maxsize=10MB,
  filegrowth= 10MB
),
(
  name= 'Impacta_Log2',
  filename='C:\Bancos\Impacta\Impacta_Log2.ldf',
  size= 10MB,
  maxsize=10MB,
  filegrowth= 10MB
)
go
USE Impacta
go

--5

CREATE TABLE Aluno
(
Cod_Aluno	Int,	
Nome_Aluno	Varchar(100)
)ON TABELAS
go

CREATE TABLE Treinamento
(
Cod_Trein	Int	,
Nome_Trein	Varchar(100)	
)ON TABELAS
go

-- 6 
INSERT Aluno VALUES(1,'Cristina')
INSERT Aluno VALUES(2,'Rosana')
INSERT Aluno VALUES(3,'Roberto')
INSERT Aluno VALUES(4,'Marcos')
INSERT Aluno VALUES(5,'Ana')
go

-- 7
INSERT Treinamento VALUES(1,'SQL Server')
INSERT Treinamento VALUES(2,'Oracle')
INSERT Treinamento VALUES(3,'DB2')
INSERT Treinamento VALUES(4,'Sybase')
INSERT Treinamento VALUES(5,'Postgresql')
go

--8
Exec SP_HelpFile
go
--9
Exec SP_HelpFileGroup
go
--10
Exec SP_HelpSort
go
--11
SELECT * FROM ::Fn_HelpCollations()
WHERE name = 'Latin1_General_CI_AI_KS'
go

--12
Exec SP_Help 'Aluno'
go
--13
Exec SP_Help 'Treinamento'
go

--14
SELECT syscolumns.Name,
       syscolumns.Collation 
FROM sysobjects,syscolumns
WHERE sysobjects.id = syscolumns.id
and sysobjects.Name = 'Aluno'
go

--15
SELECT syscolumns.Name,
       syscolumns.Collation 
FROM sysobjects,syscolumns
WHERE sysobjects.id = syscolumns.id
and sysobjects.Name = 'Treinamento'
go

--16
CREATE NONCLUSTERED INDEX I_Func_1
ON Aluno(Nome_Aluno)
ON INDICES
go
CREATE NONCLUSTERED INDEX I_Trein_1
ON Treinamento(Nome_Trein)
ON INDICES
go
