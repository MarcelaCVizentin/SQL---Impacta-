
DECLARE @result int
EXEC @result = xp_cmdshell 'dir C:\Bancos'
IF (@result <> 0)
	Exec master.dbo.xp_cmdshell 'Md C:\Bancos'

EXEC @result = xp_cmdshell 'dir C:\Bancos\universidade'
IF (@result <> 0)
	Exec master.dbo.xp_cmdshell 'Md C:\Bancos\universidade'

go
--1
CREATE DATABASE Universidade
ON PRIMARY
(
  name= 'Univers_primary',
  filename='C:\Bancos\universidade\Univers_primary.mdf',
  size= 10MB,
  maxsize=Unlimited,
  filegrowth= 10MB
),
FILEGROUP DADOS
(
  name= 'Univers_Dados1',
  filename='C:\Bancos\Universidade\Univers_Dados1.ndf',
  size= 10MB,
  maxsize=100MB,
  filegrowth= 10MB
)

LOG ON
(
  name= 'Univers_Log',
  filename='C:\Bancos\Universidade\Univers_Log.ldf',
  size= 10MB,
  maxsize=10MB,
  filegrowth= 10MB
)
go

--2
USE Universidade
go

--3
CREATE TABLE Aluno
(
Cod_Aluno	Int,	
Nome_Aluno	Varchar(100)
)ON Dados
go

--4
INSERT Aluno VALUES(1,'Cristina')
INSERT Aluno VALUES(2,'Rosana')
INSERT Aluno VALUES(3,'Roberto')
INSERT Aluno VALUES(4,'Marcos')
INSERT Aluno VALUES(5,'Ana')
go
CREATE TABLE Funcionario
(
Cod_Func	Int,	
Nome_Func	Varchar(100)
)ON Dados
go
INSERT Funcionario VALUES(1,'Jorge')
INSERT Funcionario VALUES(2,'Ronaldo')
INSERT Funcionario VALUES(3,'Cláudia')
INSERT Funcionario VALUES(4,'Francisco')
INSERT Funcionario VALUES(5,'Agnaldo')
go

--5
ALTER DATABASE Universidade SET READ_ONLY
go

--6
Use Universidade
go

INSERT Aluno VALUES(6,'Laureana')
go
Use Master
go
--7
ALTER DATABASE Universidade	SET OFFLINE
go

--8
Use Universidade
go

--9
ALTER DATABASE Universidade	SET ONLINE
go
--10
ALTER DATABASE Universidade	SET READ_WRITE
go
--11
Use Universidade
go

--12
ALTER DATABASE Universidade	MODIFY FILEGROUP  DADOS READONLY
go

--13
INSERT Funcionario VALUES(5,'Ronaldo')
go

--14
ALTER DATABASE Universidade	MODIFY FILEGROUP DADOS READWRITE
go

--15
INSERT Funcionario VALUES(5,'Ronaldo')
go

--16
ALTER DATABASE Universidade	MODIFY FILEGROUP DADOS DEFAULT
go

--17
CREATE TABLE Materia
(
Cod_Mat	Int,
Nome_Mat	Varchar(50)
)
go
--18
Exec SP_Help Materia
go

--19
ALTER DATABASE Universidade	MODIFY FILEGROUP [PRIMARY] DEFAULT
go
--20
ALTER DATABASE Universidade	ADD FILEGROUP DADOS_BASICO

go

--21
ALTER DATABASE Universidade
ADD FILE
(
  name= 'Univers_Dados3',
  filename='C:\Bancos\universidade\Univers_Dados3.ndf',
  size= 10MB,
  maxsize=UNLIMITED,
  filegrowth= 10MB
)TO FILEGROUP DADOS_BASICO
go

--22
ALTER DATABASE Universidade	ADD FILEGROUP DADOS_COMPLEMENTO
go

--23
ALTER DATABASE Universidade
ADD FILE
(
  name= 'Univers_Dados4',
  filename='C:\Bancos\universidade\univers_Dados_complemento1.ndf',
  size= 10MB,
  maxsize=UNLIMITED,
  filegrowth= 10MB
),
(
  name= 'Univers_Dados5',
  filename='C:\Bancos\universidade\Univers_Dados_complemento2.ndf',
  size= 10MB,
  maxsize=UNLIMITED,
  filegrowth= 10MB
)TO FILEGROUP DADOS_COMPLEMENTO
go

--24
CREATE TABLE Professor
(
Cod_Prof	Int,
Nome_Prof	Varchar(50)
)ON DADOS_BASICO
go

--25
Exec SP_HelpFile
go

--26
ALTER DATABASE Universidade	MODIFY FILE
(
	Name = 'Univers_Dados5', 
	NewName = 'Univers_Dados6',
	Size = 20MB,
	MaxSize = UNLIMITED,
	Filegrowth = 20MB
)
go
Exec SP_Helpfile
go

--27
DBCC SHRINKFILE ('Univers_Dados6',5)
go

--28
ALTER DATABASE Universidade	REMOVE FILE Univers_Dados6
go

--29
ALTER DATABASE Universidade	REMOVE FILE Univers_Dados4
go
--30
ALTER DATABASE Universidade	REMOVE FILEGROUP DADOS_COMPLEMENTO
go
--31
Exec SP_HelpFile 
go

