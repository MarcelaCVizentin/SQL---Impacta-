/*

****** DIFERENÇA ENTRE FUNÇÃO E PROCEDURE ******

•	A Função deve retornar um valor, mas a Procedure é opcional. 

•	As funções podem ter apenas parâmetros de entrada, enquanto as Procedures podem 
	ter parâmetros de entrada ou saída.

•	As funções podem ser chamadas de dentro de uma Procedure, enquanto as Procedures 
	não podem ser chamados a partir de uma Função.

•	A procedure permite SELECT e instruções DML (INSERT / UPDATE / DELETE), 
	enquanto a Function permite apenas a instrução SELECT.

•	As procedures não podem ser utilizados em uma instrução SELECT, enquanto a Função 
	pode ser incorporada em uma instrução SELECT.

•	As procedures não podem ser usados ​​nas instruções SQL em qualquer lugar da 
	seção WHERE / HAVING / SELECT, enquanto a Função pode ser.

•	As funções que retornam tabelas podem ser tratadas como outro conjunto de linhas. Isso 
	pode ser usado em JOINs com outras tabelas.

•	Uma exceção pode ser manipulada pelo bloco try-catch em uma Procedure, enquanto o bloco 
	try-catch não pode ser usado em uma Função.

•	Podemos usar Transações no Procedimento, enquanto não podemos usar Transações na Função.

*/