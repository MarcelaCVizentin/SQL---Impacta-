/*
Dados espaciais tem a finalidade de armazenar as informações em
geoprocessamento, onde podemos usar as informações estruturadas das tabelas 
e visualizar em mapas e formas geométricas.

O SQL possui dois tipos de Dados espaciais:

• GEOMETRY (Geometria): Coordenadas euclidianas (dados planos). O SQL utiliza o recurso de OGC (Open Geospatial Consortium);

• GEOGRAPHY (Geografia): Coordenadas esféricas.

*/

---------------------------------------
---------------------------------------

-- Tipos de dados geográficos

/*
**** Point ****

Representa um local único de uma longitude
*/

select  geometry::STGeomFromText('POINT (3 4)', 0)

SELECT geometry::STGeomFromText('POINT (33 45)', 0);  


/* 
No próximo exemplo, será armazenado um valor em uma variável e depois extraídas
as posições X, Y, Z e M:
*/

declare @g geometry
SET @g = geometry::Parse('POINT(4 7 3 1)');

SELECT @g.STX;  
SELECT @g.STY;  
SELECT @g.Z;  
SELECT @g.M;

---------------------------------------
---------------------------------------

/*
**** LineString ****

Apresenta uma figura linear. Pode ser:
	• Simples não fechada;
	• Não simples não fechada;
	• Fechada simples;
	• Fechada não simples.
	
*/
Select geometry::STGeomFromText('LINESTRING(1 1, 2 4, 3 9)', 0);  

---------------------------------------
---------------------------------------

/*
**** CircularString ****

Representa uma figura circular.
	
*/

select geometry:: STGeomFromText('CIRCULARSTRING(2 0, 1 1, 0 0)', 0);  

---------------------------------------
---------------------------------------

/*
**** Polígono ****

Representa uma figura de um polígono
	
*/
SELECT geometry::STPolyFromText('POLYGON((0 0, 0 3, 3 3, 3 0, 0 0), (1 1, 1 2, 2 1, 1 1))', 10);

---------------------------------------
---------------------------------------

/*
**** MultiPoint ****

É um conjunto de vários pontos.
	
*/
select geometry::STMPointFromText('MULTIPOINT((2 3), (7 8 9.5))', 23);

---------------------------------------
---------------------------------------

/*
**** MultiLineString ****

Representa várias linhas de uma figura.
	
*/
select geometry::Parse('MULTILINESTRING((0 2, 1 1), (1 0, 1 1))');

---------------------------------------
---------------------------------------

/*
**** GeometryCollection ****

É uma coleção de figuras geométricas ou geográficas
	
*/
select geometry::STGeomCollFromText('GEOMETRYCOLLECTION(POINT(3 3 1), POLYGON((0 0 2, 1 10 3, 1 0 4, 0 0 2)))', 1);


