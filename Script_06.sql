--1.
CREATE DATABASE SNAP_UNIVERSIDADE ON
( NAME = Univers_primary, FILENAME = 'C:\Bancos\Univers_primary.ss' ) ,
( NAME = Univers_Dados1, FILENAME = 'C:\Bancos\Univers_Dados1.ss'),
( NAME = Univers_Dados3, FILENAME = 'C:\Bancos\Univers_Dados3.ss')
AS SNAPSHOT OF UNIVERSIDADE;  

--2.
USE SNAP_UNIVERSIDADE

--3.
SELECT * FROM ALUNO

--4.
USE Universidade

--5.
INSERT INTO ALUNO VALUES (6 , 'MARCELO')

--6.
SELECT * FROM ALUNO

--7.
USE MASTER

--8.
RESTORE DATABASE Universidade FROM DATABASE_SNAPSHOT = 'SNAP_UNIVERSIDADE'

--9.
USE Universidade

--10.
SELECT * FROM ALUNO

