
-- ***** FUNÇÕES DE CONVERSÃO *****


--Converte uma data em número
SELECT CAST(GETDATE() AS INT) AS DATA_NUMERO


--Convertendo um texto em data
SELECT CAST('2014.1.13' AS DATETIME) AS DATA


--Convertendo um número em Data
SELECT CAST(42525 AS DATETIME) AS DATA


--Convertendo uma data para texto com CAST
SELECT CAST (GETDATE() AS VARCHAR(20)) 


--Utilizando o CONVERT para retornar somente a data no formato DD/MM/YYYY.
SELECT CONVERT(VARCHAR(10), GETDATE() , 103) 


--Retornando a data no formato AAAA/MM/DD.
SELECT CONVERT(VARCHAR(10), GETDATE() , 111) 


--Retornando a Hora
SELECT CONVERT(VARCHAR(20), GETDATE() , 114) 

----------------------------------------------------------------------
----------------------------------------------------------------------

-- Exemplo 1

--Convertendo um texto em valor numérico. Verifique que o ponto é o separador de decimal e o resultado estará correto.
SELECT PARSE( '159.00'  AS DECIMAL(10,2) ) AS RESULTADO

--Porém, se alterar de ponto para vírgula, a conversão ficará incorreta.
SELECT PARSE( '159,00'  AS DECIMAL(10,2) ) AS RESULTADO

--Para resolver este problema, utilize o formato cultural para atender o texto passado.
SELECT PARSE( '159,00'  AS DECIMAL(10,2) USING 'pt-BR' ) AS RESULTADO



----------------------------------------------------------------------
----------------------------------------------------------------------

--No exemplo abaixo é passado um caractere indevido, utilizando o PARSE é apresentado um erro.
SELECT PARSE( '159,A0'  AS DECIMAL(10,2) USING 'PT-br' ) AS RESULTADO


--Utilizando o TRY_PARSE, não é retornado um erro e sim NULL.
SELECT TRY_PARSE( '159,A0'  AS DECIMAL(10,2) USING 'PT-br' ) AS RESULTADO


--Utilizando CONVERT numa conversão indevida:
SELECT CONVERT(DATETIME, '2016.06.a' , 103)


--Com o TRY_CONVERT o retorno é NULO:
SELECT TRY_CONVERT(DATETIME, '2016.06.a' , 103) AS RESULTADO


/*
Dica:

A diferença entre TRY_CONVERT e TRY_PARSE é simples. 
TRY_PARSE pode converter apenas tipos dados numéricos ou de data, 
enquanto TRY_CONVERT pode ser usado para qualquer conversão de tipo geral.

*/