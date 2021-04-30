
USE DB_ECOMMERCE;

 --Exemplo 1
 --c�digo adiante consulta os funcion�rios do departamento de c�digo 2 que ganham acima de 5000 reais:

SELECT * FROM TB_EMPREGADO 
WHERE ID_DEPARTAMENTO = 2 AND SALARIO > 5000

--Exemplo 2
--o c�digo adiante consulta os funcion�rios do departamento de c�digo 2 ou (OR) aqueles que ganham acima de 5000 reais:


SELECT * FROM TB_EMPREGADO
WHERE ID_DEPARTAMENTO = 2 OR SALARIO > 5000


--Exemplo 3
--O c�digo adiante consulta os funcion�rios com sal�rio entre 3000 e 5000 reais:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO >= 3000 AND SALARIO <= 5000
ORDER BY SALARIO


--O c�digo a seguir pratica a mesma consulta feita pelo c�digo anterior. A diferen�a � que aqui utilizamos a palavra BETWEEN em vez de >= e <=:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO BETWEEN 3000 AND 5000
ORDER BY SALARIO


--Exemplo 4
--A instru��o SELECT a seguir consulta os funcion�rios com sal�rio abaixo de 3000 ou acima de 5000 reais:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO < 3000 OR SALARIO > 5000
ORDER BY SALARIO


--O mesmo resultado do c�digo anterior pode ser obtido com a instru��o SELECT a seguir:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO NOT BETWEEN 3000 AND 5000
ORDER BY SALARIO


--Exemplo 5
--O exemplo a seguir consulta os funcion�rios admitidos no ano 2000:

SELECT * FROM TB_Empregado
WHERE DATA_ADMISSAO BETWEEN '2019.1.1' AND '2019.12.31'
ORDER BY DATA_ADMISSAO


--O mesmo resultado do c�digo anterior pode ser obtido com a instru��o SELECT a seguir:

SELECT * FROM TB_Empregado
WHERE YEAR(DATA_ADMISSAO) = 2019
ORDER BY DATA_ADMISSAO


--Exemplo 6
--A instru��o SELECT adiante consulta os funcion�rios cujo nome seja iniciado por MARIA:
SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE 'MARIA%'

--Exemplo 7
--A instru��o SELECT adiante consulta os funcion�rios cujo nome contenha SOUZA:

SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE '%MARIA%'


--Exemplo 8
--A instru��o SELECT a seguir consulta os funcion�rios cujo nome contenha SOUZA ou SOUSA:

SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE '%SOU[SZ]A%'


--Exemplo 9
--A instru��o SELECT a seguir consulta os clientes dos estados do Amazonas, Paran�, Rio de Janeiro e S�o Paulo:

SELECT  ESTADO FROM TB_ENDERECO
WHERE ESTADO IN ('AM', 'PR', 'RJ', 'SP')


--Exemplo 10
--Para sabermos a quantidade de dias desde que cada funcion�rio foi admitido, utilizamos a instru��o SELECT com a fun��o de data GETDATE():

SELECT ID_EMPREGADO, NOME, 
       CAST(GETDATE() - DATA_ADMISSAO AS INT) AS DIAS_NA_EMPRESA
FROM TB_EMPREGADO


--Exemplo 11
--Vejamos como utilizar o SELECT com outras fun��es de data. No c�digo a seguir, filtramos os funcion�rios admitidos em uma sexta-feira:

SELECT 
  ID_EMPREGADO, NOME, DATA_ADMISSAO, 
  DATENAME(WEEKDAY,DATA_ADMISSAO) AS DIA_SEMANA,
  DATENAME(MONTH,DATA_ADMISSAO) AS MES
FROM TB_EMPREGADO
WHERE DATEPART(WEEKDAY, DATA_ADMISSAO) = 6


--Exemplo 12
--O c�digo adiante consulta duas tabelas na mesma instru��o SELECT:

SELECT  
  TB_EMPREGADO.ID_EMPREGADO, TB_EMPREGADO.NOME, 
  TB_EMPREGADO.ID_DEPARTAMENTO, TB_EMPREGADO.ID_CARGO, 
  TB_DEPARTAMENTO.DEPARTAMENTO
FROM TB_EMPREGADO
  JOIN TB_DEPARTAMENTO ON TB_EMPREGADO.ID_DEPARTAMENTO = TB_DEPARTAMENTO.ID_DEPARTAMENTO


--A escrita do c�digo anterior pode ser simplificada se utilizarmos alias para os nomes das tabelas:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO
FROM TB_EMPREGADO E
  JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO


--Exemplo 13
--O c�digo a seguir consulta tr�s tabelas na mesma instru��o SELECT:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO, C.CARGO
FROM TB_EMPREGADO E
  JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
  JOIN TB_CARGO C ON E.ID_CARGO = C.ID_CARGO;


--A mesma consulta do c�digo anterior pode ser feita da maneira mostrada a seguir:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO, C.CARGO
FROM TB_DEPARTAMENTO D
  JOIN TB_EMPREGADO E ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
  JOIN TB_CARGO C ON E.ID_CARGO = C.ID_CARGO;


--Tamb�m podemos utilizar uma terceira maneira para realizar a mesma consulta anterior:
SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO, C.CARGO
FROM TB_CARGO C
  JOIN TB_EMPREGADO E ON E.ID_CARGO = C.ID_CARGO
  JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO;


--Exemplo 14
--A instru��o SELECT a seguir consulta os funcion�rios que n�o constam em departamento algum:
SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO
FROM TB_EMPREGADO E 
     LEFT JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO  
WHERE D.ID_DEPARTAMENTO IS NULL


--Exemplo 15
--A instru��o SELECT a seguir consulta os departamentos sem funcion�rios:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO
FROM TB_EMPREGADO E 
     RIGHT JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO  
WHERE E.ID_DEPARTAMENTO IS NULL


--O mesmo resultado do c�digo anterior pode ser obtido com a instru��o a seguir:

SELECT * FROM TB_DEPARTAMENTO
WHERE ID_DEPARTAMENTO NOT IN (SELECT DISTINCT ID_DEPARTAMENTO FROM TB_EMPREGADO WHERE ID_DEPARTAMENTO IS NOT NULL)


--Exemplo 16
--A instru��o a seguir consulta os clientes que compraram em janeiro de 2015:

SELECT * FROM TB_CLIENTE
WHERE ID_CLIENTE IN (SELECT ID_CLIENTE FROM TB_PEDIDO
                 WHERE ID_CLIENTE = TB_CLIENTE.ID_CLIENTE AND
                       DATA_EMISSAO BETWEEN '2019.1.1' AND 
                                            '2019.1.31')  


--Exemplo 17
--O c�digo a seguir soma os sal�rios de cada departamento:
SELECT E.ID_DEPARTAMENTO, D.DEPARTAMENTO, SUM( SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
GROUP BY E.ID_DEPARTAMENTO, D.DEPARTAMENTO
ORDER BY TOT_SAL


--Exemplo 18
--A instru��o a seguir consulta os departamentos que gastam mais de 15000 reais em sal�rios:
SELECT E.ID_DEPARTAMENTO, D.DEPARTAMENTO, SUM( SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
GROUP BY E.ID_DEPARTAMENTO, D.DEPARTAMENTO
   HAVING SUM(E.SALARIO) > 15000
ORDER BY TOT_SAL


--Exemplo 19
--A instru��o SELECT a seguir consulta os cinco departamentos que mais gastam com sal�rios:
SELECT TOP 5 E.ID_DEPARTAMENTO, D.DEPARTAMENTO, SUM( E.SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E
     JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
GROUP BY E.ID_DEPARTAMENTO, D.DEPARTAMENTO
ORDER BY TOT_SAL DESC


--2.2.	IIF/CHOOSE

DECLARE @a INT = 15, @b INT = 10;
SELECT IIF( @a>@b, 'VERDADEIRO', 'FALSO') AS Resultado


DECLARE @indice INT = 4;
SELECT CHOOSE (@indice/2, 'ola', 'oi', 'tchau') AS Resultado



SELECT ID_EMPREGADO, NOME, DATA_ADMISSAO,
-- Substitui o S por SIM e o N por N�O
       IIF(SINDICALIZADO = 'S', 'SIM', 'N�O') AS SINDICALIZADO,
	-- Pega o n�mero do dia da semana e devolve o nome que 
     -- est� na posi��o correspondente
	   CHOOSE(DATEPART(WEEKDAY, DATA_ADMISSAO), 'DOMINGO', 'SEGUNDA','TER�A','QUARTA','QUINTA','SEXTA','S�BADO') AS DIA_SEMANA
FROM TB_EMPREGADO


--2.3.	LAG e LEAD

-- LAG atrasa, LEAD avan�a
-- primeiro parametro ser� o valor retornado com base no deslocamento
-- segundo parametro ser� o avan�o de linhas ou atraso de linhas com base na atual
-- terceiro parametro � o valor default caso n�o tenha o que avan�ar ou retroceder.

SELECT ID_EMPREGADO, NOME, SALARIO, 
LAG(SALARIO,1, 0) OVER (ORDER BY ID_EMPREGADO) AS SALARIO_ANTERIOR,
LEAD(SALARIO,1, 0) OVER (ORDER BY ID_EMPREGADO) AS PROXIMO_SALARIO
FROM TB_EMPREGADO
ORDER BY ID_EMPREGADO


--2.4. Pagina��o (FETCH e OFFSET)

/*
-- A cl�usula OFFSET especifica o n�mero de linhas a serem ignoradas antes de come�ar a retornar linhas da consulta
-- A cl�usula FETCH especifica o n�mero de linhas a serem retornadas ap�s o OFFSET ter sido processada.
*/

SELECT * FROM TB_CLIENTE
ORDER BY ID_CLIENTE
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;

-- seleciona os pr�ximos 20 clientes
SELECT * FROM TB_CLIENTE
ORDER BY ID_CLIENTE
OFFSET 20 ROWS FETCH NEXT 20 ROWS ONLY;


DECLARE @OFFSET INT = 0, @FETCH INT = 20;

SELECT * FROM TB_CLIENTE
ORDER BY ID_CLIENTE
OFFSET @OFFSET ROWS FETCH NEXT @FETCH ROWS ONLY;

--2.5. Union 


SELECT NOME, FONE1 FROM TB_CLIENTE
UNION 
SELECT NOME, FONE1 FROM TB_CLIENTE ORDER BY NOME;

--2.6. Union all


SELECT NOME, FONE1 FROM TB_CLIENTE
UNION ALL
SELECT NOME, FONE1 FROM TB_CLIENTE ORDER BY NOME;
