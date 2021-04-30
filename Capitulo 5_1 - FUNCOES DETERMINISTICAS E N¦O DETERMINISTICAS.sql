USE db_Ecommerce
GO

/*
******* EXPLICAÇÃO ******* 

Existem dois tipos de funções (Tanto nativa quanto de usuário):

* FUNÇÕES ESCALARES - As funções escalares retornam um valor único, cujo tipo é definido por uma cláusula RETURNS.
						
* FUNÇÕES TABULARES - Funções tabulares são aquelas que, utilizando uma cláusula SELECT, retornam um conjunto de resultados em forma de tabela. 

----------------------------------------

Tanto para funções nativas e tanto para funções de usuários, existem duas categorias:

* FUNÇÕES DETERMINISTICAS - Sempre retornam o mesmo resultado para um mesmo conjunto de valores de entrada e em um mesmo estado do banco de dados.

* FUNÇÕES NÃO DETERMINISTICAS - São aquelas que podem retornar resultados distintos para um mesmo conjunto de valores de entrada a cada vez que são chamadas

*/

-------------------
-------------------

-- ***** ALGUMAS FUNÇÕES DETERMINÍSTICAS *****


-- Retorna a quantidade de caracteres do texto
SELECT LEN('CARLOS MAGNO')


-- Valor de PI
SELECT PI()


-- Raiz quadrada de 144
SELECT SQRT(144)


-- Valor Exponencial de 12
SELECT SQUARE( 12 )

--------------------
--------------------

-- ***** ALGUMAS FUNÇÕES NÃO DETERMINÍSTICAS *****


-- Valor randômico entre 0 e 1
SELECT RAND()


-- Data e hora do servidor
SELECT GETDATE()


-- Gera um valor exclusivo 
SELECT NEWID()


