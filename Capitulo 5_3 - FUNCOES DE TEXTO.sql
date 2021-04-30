
-- ***** FUNÇÕES NATIVAS (BUILT-IN) *****

-- ***** FUNÇÕES DE TEXTO *****


--- Código de um dado caractere
SELECT ASCII( 'A' )
SELECT ASCII( 'B' )
SELECT ASCII( '0' )


--- Caractere que tem um determinado código
SELECT CHAR(65)
--
DECLARE @COD INT;
SET @COD = 1;

WHILE @COD <= 255
   BEGIN
	   PRINT CAST(@COD AS VARCHAR(3)) + ' - ' + CHAR(@COD);
	   SET @COD = @COD + 1; 
   END


--- Posição de uma string dentro de outra
SELECT CHARINDEX( 'PA', 'IMPACTA' ) -- Retorna 3
SELECT CHARINDEX( 'MAGNO', 'CARLOS MAGNO' ) -- Retorna 8


--- Tamanho de uma string
SELECT LEN( 'IMPACTA' ) 
SELECT LEN( 'IMPACTA TECNOLOGIA' )


--- Pegar uma parte de uma string
SELECT LEFT( 'IMPACTA TECNOLOGIA', 5 ) -- Retorna IMPAC

SELECT RIGHT( 'IMPACTA TECNOLOGIA', 5 ) -- Retorna LOGIA


-- Retornar 6 caracteres a partir da quinta (5) posição
SELECT SUBSTRING( 'IMPACTA TECNOLOGIA', 5, 6 ) -- Retorna CTA TE


--- Eliminar espaços em branco à direita
SELECT 'IMPACTA     ' + 'TECNOLOGIA'
SELECT RTRIM('IMPACTA     ') + 'TECNOLOGIA'


--- Reverso de uma string
SELECT REVERSE('IMPACTA')
SELECT REVERSE('MAGNO')
SELECT REVERSE('TECNOLOGIA')


--- Replicar string várias vezes
PRINT REPLICATE('IMPACTA ', 10)


--- Maiúsculo
PRINT UPPER('impacta  123 @@ !!')


--- Minúsculo
PRINT LOWER( 'tECnOlOGIa 123 @@ !!' )


-- Substituição de texto
PRINT REPLACE( 'JOSÉ,CARLOS,ROBERTO,FERNANDO,MARCO', ',' ,' - ')


