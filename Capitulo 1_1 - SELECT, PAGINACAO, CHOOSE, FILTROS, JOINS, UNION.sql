
USE DB_ECOMMERCE;

 --Exemplo 1
 --código adiante consulta os funcionários do departamento de código 2 que ganham acima de 5000 reais:

SELECT * FROM TB_EMPREGADO 
WHERE ID_DEPARTAMENTO = 2 AND SALARIO > 5000

--Exemplo 2
--o código adiante consulta os funcionários do departamento de código 2 ou (OR) aqueles que ganham acima de 5000 reais:


SELECT * FROM TB_EMPREGADO
WHERE ID_DEPARTAMENTO = 2 OR SALARIO > 5000


--Exemplo 3
--O código adiante consulta os funcionários com salário entre 3000 e 5000 reais:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO >= 3000 AND SALARIO <= 5000
ORDER BY SALARIO


--O código a seguir pratica a mesma consulta feita pelo código anterior. A diferença é que aqui utilizamos a palavra BETWEEN em vez de >= e <=:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO BETWEEN 3000 AND 5000
ORDER BY SALARIO


--Exemplo 4
--A instrução SELECT a seguir consulta os funcionários com salário abaixo de 3000 ou acima de 5000 reais:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO < 3000 OR SALARIO > 5000
ORDER BY SALARIO


--O mesmo resultado do código anterior pode ser obtido com a instrução SELECT a seguir:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO NOT BETWEEN 3000 AND 5000
ORDER BY SALARIO


--Exemplo 5
--O exemplo a seguir consulta os funcionários admitidos no ano 2000:

SELECT * FROM TB_Empregado
WHERE DATA_ADMISSAO BETWEEN '2019.1.1' AND '2019.12.31'
ORDER BY DATA_ADMISSAO


--O mesmo resultado do código anterior pode ser obtido com a instrução SELECT a seguir:

SELECT * FROM TB_Empregado
WHERE YEAR(DATA_ADMISSAO) = 2019
ORDER BY DATA_ADMISSAO


--Exemplo 6
--A instrução SELECT adiante consulta os funcionários cujo nome seja iniciado por MARIA:
SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE 'MARIA%'

--Exemplo 7
--A instrução SELECT adiante consulta os funcionários cujo nome contenha SOUZA:

SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE '%MARIA%'


--Exemplo 8
--A instrução SELECT a seguir consulta os funcionários cujo nome contenha SOUZA ou SOUSA:

SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE '%SOU[SZ]A%'


--Exemplo 9
--A instrução SELECT a seguir consulta os clientes dos estados do Amazonas, Paraná, Rio de Janeiro e São Paulo:

SELECT  ESTADO FROM TB_ENDERECO
WHERE ESTADO IN ('AM', 'PR', 'RJ', 'SP')


--Exemplo 10
--Para sabermos a quantidade de dias desde que cada funcionário foi admitido, utilizamos a instrução SELECT com a função de data GETDATE():

SELECT ID_EMPREGADO, NOME, 
       CAST(GETDATE() - DATA_ADMISSAO AS INT) AS DIAS_NA_EMPRESA
FROM TB_EMPREGADO


--Exemplo 11
--Vejamos como utilizar o SELECT com outras funções de data. No código a seguir, filtramos os funcionários admitidos em uma sexta-feira:

SELECT 
  ID_EMPREGADO, NOME, DATA_ADMISSAO, 
  DATENAME(WEEKDAY,DATA_ADMISSAO) AS DIA_SEMANA,
  DATENAME(MONTH,DATA_ADMISSAO) AS MES
FROM TB_EMPREGADO
WHERE DATEPART(WEEKDAY, DATA_ADMISSAO) = 6


--Exemplo 12
--O código adiante consulta duas tabelas na mesma instrução SELECT:

SELECT  
  TB_EMPREGADO.ID_EMPREGADO, TB_EMPREGADO.NOME, 
  TB_EMPREGADO.ID_DEPARTAMENTO, TB_EMPREGADO.ID_CARGO, 
  TB_DEPARTAMENTO.DEPARTAMENTO
FROM TB_EMPREGADO
  JOIN TB_DEPARTAMENTO ON TB_EMPREGADO.ID_DEPARTAMENTO = TB_DEPARTAMENTO.ID_DEPARTAMENTO


--A escrita do código anterior pode ser simplificada se utilizarmos alias para os nomes das tabelas:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO
FROM TB_EMPREGADO E
  JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO


--Exemplo 13
--O código a seguir consulta três tabelas na mesma instrução SELECT:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO, C.CARGO
FROM TB_EMPREGADO E
  JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
  JOIN TB_CARGO C ON E.ID_CARGO = C.ID_CARGO;


--A mesma consulta do código anterior pode ser feita da maneira mostrada a seguir:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO, C.CARGO
FROM TB_DEPARTAMENTO D
  JOIN TB_EMPREGADO E ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
  JOIN TB_CARGO C ON E.ID_CARGO = C.ID_CARGO;


--Também podemos utilizar uma terceira maneira para realizar a mesma consulta anterior:
SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO, C.CARGO
FROM TB_CARGO C
  JOIN TB_EMPREGADO E ON E.ID_CARGO = C.ID_CARGO
  JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO;


--Exemplo 14
--A instrução SELECT a seguir consulta os funcionários que não constam em departamento algum:
SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO
FROM TB_EMPREGADO E 
     LEFT JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO  
WHERE D.ID_DEPARTAMENTO IS NULL


--Exemplo 15
--A instrução SELECT a seguir consulta os departamentos sem funcionários:

SELECT  
  E.ID_EMPREGADO, E.NOME, E.ID_DEPARTAMENTO, E.ID_CARGO, D.DEPARTAMENTO
FROM TB_EMPREGADO E 
     RIGHT JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO  
WHERE E.ID_DEPARTAMENTO IS NULL


--O mesmo resultado do código anterior pode ser obtido com a instrução a seguir:

SELECT * FROM TB_DEPARTAMENTO
WHERE ID_DEPARTAMENTO NOT IN (SELECT DISTINCT ID_DEPARTAMENTO FROM TB_EMPREGADO WHERE ID_DEPARTAMENTO IS NOT NULL)


--Exemplo 16
--A instrução a seguir consulta os clientes que compraram em janeiro de 2015:

SELECT * FROM TB_CLIENTE
WHERE ID_CLIENTE IN (SELECT ID_CLIENTE FROM TB_PEDIDO
                 WHERE ID_CLIENTE = TB_CLIENTE.ID_CLIENTE AND
                       DATA_EMISSAO BETWEEN '2019.1.1' AND 
                                            '2019.1.31')  


--Exemplo 17
--O código a seguir soma os salários de cada departamento:
SELECT E.ID_DEPARTAMENTO, D.DEPARTAMENTO, SUM( SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
GROUP BY E.ID_DEPARTAMENTO, D.DEPARTAMENTO
ORDER BY TOT_SAL


--Exemplo 18
--A instrução a seguir consulta os departamentos que gastam mais de 15000 reais em salários:
SELECT E.ID_DEPARTAMENTO, D.DEPARTAMENTO, SUM( SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E JOIN TB_DEPARTAMENTO D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
GROUP BY E.ID_DEPARTAMENTO, D.DEPARTAMENTO
   HAVING SUM(E.SALARIO) > 15000
ORDER BY TOT_SAL


--Exemplo 19
--A instrução SELECT a seguir consulta os cinco departamentos que mais gastam com salários:
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
-- Substitui o S por SIM e o N por NÃO
       IIF(SINDICALIZADO = 'S', 'SIM', 'NÃO') AS SINDICALIZADO,
	-- Pega o número do dia da semana e devolve o nome que 
     -- está na posição correspondente
	   CHOOSE(DATEPART(WEEKDAY, DATA_ADMISSAO), 'DOMINGO', 'SEGUNDA','TERÇA','QUARTA','QUINTA','SEXTA','SÁBADO') AS DIA_SEMANA
FROM TB_EMPREGADO


--2.3.	LAG e LEAD

-- LAG atrasa, LEAD avança
-- primeiro parametro será o valor retornado com base no deslocamento
-- segundo parametro será o avanço de linhas ou atraso de linhas com base na atual
-- terceiro parametro é o valor default caso não tenha o que avançar ou retroceder.

SELECT ID_EMPREGADO, NOME, SALARIO, 
LAG(SALARIO,1, 0) OVER (ORDER BY ID_EMPREGADO) AS SALARIO_ANTERIOR,
LEAD(SALARIO,1, 0) OVER (ORDER BY ID_EMPREGADO) AS PROXIMO_SALARIO
FROM TB_EMPREGADO
ORDER BY ID_EMPREGADO


--2.4. Paginação (FETCH e OFFSET)

/*
-- A cláusula OFFSET especifica o número de linhas a serem ignoradas antes de começar a retornar linhas da consulta
-- A cláusula FETCH especifica o número de linhas a serem retornadas após o OFFSET ter sido processada.
*/

SELECT * FROM TB_CLIENTE
ORDER BY ID_CLIENTE
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;

-- seleciona os próximos 20 clientes
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
