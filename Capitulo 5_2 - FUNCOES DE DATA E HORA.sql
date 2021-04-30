
-- ***** FUNÇÕES DE DATA E HORA *****

-- Data e hora do servidor
SELECT  GETDATE() AS Data


-- Último dia do mês corrente
SELECT EOMONTH(GETDATE(), 0 )


-- Apresenta a data de 28/10/2014
SELECT DATEFROMPARTS(2014,10,28)


-- Adiciona dias
SELECT DATEADD(DAY, 45, GETDATE())


-- Adiciona MESES
SELECT DATEADD(DAY, 45, GETDATE())


-- Adiciona HORAS
SELECT DATEADD(HOUR, 45, GETDATE())


-- Adiciona ANOS
SELECT DATEADD(YEAR, 45, GETDATE())