USE banco_04_08;
-- 01 TOTAL DE CIDADES DO ESTADO DE SANTA CATARINA, A MENOR POPULAÇÃO
-- DO ESTADO E A MAIOR
SELECT COUNT(codigo) AS total_cidades, MIN(Populacao) AS menor_populacao, MAX(Populacao) AS maior_populacao
  FROM Cidades
 WHERE Estado = 'SC';
 
-- 02 TOTAL DE POPULAÇÃO DO ESTADO DE SANTA CATARINA, MOSTRAR NOME DA
-- CIDADE COM MENOR POPULAÇÃO E COM A MAIOR
SELECT SUM(Populacao) AS total_populacao,
	 (SELECT Municipio
	    FROM Cidades
	   WHERE Estado = 'SC' AND Populacao = (
		    SELECT MIN(Populacao) 
              FROM Cidades 
			 WHERE Estado = 'SC') LIMIT 1 
	 ) AS Cidade_menor_populacao,
	 (SELECT Municipio
        FROM Cidades
	   WHERE Estado = 'SC' AND Populacao = (
			SELECT MAX(Populacao)
              FROM Cidades 
			 WHERE Estado = 'SC') LIMIT 1
	 ) AS Cidade_maior_populacao
  FROM Cidades
 WHERE Estado = 'SC';
 
-- 03 TOTAL DE CIDADES POR ESTADO EM ORDEM ESTADO (TODOS ESTADOS)
SELECT Estado ,COUNT(*) AS Total_Cidades 
  FROM Cidades
 GROUP BY Estado
 ORDER BY Estado;

-- 04 AS 5 CIDADES MAIS POPULOSAS
SELECT Municipio, Estado, Populacao 
  FROM Cidades
 ORDER BY Populacao DESC LIMIT 5;
 
-- 05 OS 5 ESTADOS COM MAIS CIDADES ORDEM DESCRECENTE QUANTIDADE CIDADES
SELECT Estado, COUNT(*) AS Quantidade_Cidades
  FROM Cidades
 GROUP BY Estado
 ORDER BY Quantidade_Cidades DESC LIMIT 5;
 
-- 06 OS 5 ESTADOS COM MAIS CIDADES ORDEM DESCRECENTE QUANTIDADE
-- CIDADES E A SOMATORIA DA POPULAÇÃO DE CADA UM EM ORDEM CRESCENTE
-- POPULAÇÃO
SELECT Estado, COUNT(*) AS Quantidade_Cidades, SUM(Populacao) AS Total_Populacao
  FROM Cidades
 GROUP BY Estado
 ORDER BY Quantidade_Cidades DESC,Total_Populacao LIMIT 5;
 
-- 07 MEDIA DA POPULAÇÃO DE HOMEM E MULHERES POR ESTADO EM ORDEM DE
-- ESTADO
SELECT Estado,
	   ROUND(AVG(pctHomem ), 2) AS Media_Homens,
       ROUND(AVG(pctMulher), 2) AS Media_Mulheres
  FROM Cidades
 GROUP BY Estado ORDER BY Estado;
 
-- 08 SOMA DA POPULACAO, SOMA DE HOMENS E MULHERES POR ESTADO PARA
-- OS 5 PRIMEIROS REGISTROS
SELECT Estado,
	   SUM(Populacao) AS Populacao_Total,
	   ROUND(SUM(Populacao*pctHomem/100), 0) AS Populacao_Masculina,
       ROUND(SUM(Populacao*pctMulher/100), 0) AS Populacao_Feminina
  FROM Cidades
 GROUP BY Estado
 LIMIT 5;
 
-- 09 TODOS OS ESTADOS EM QUE A MEDIA DA POPULACAO DE MULHERES E
-- ACIMA DE 50%
SELECT Estado,
	   SUM(Populacao) AS populacao_total,
	   AVG(pctMulher) AS media_mulher
  FROM Cidades
 GROUP BY Estado
HAVING AVG(pctMulher)>50;
       
-- 10 OS ESTADOS EM QUE A POPULAÇÃO DE MULHERES É MAIOR QUE A DE HOMEM 
SELECT Estado,
	   SUM(Populacao) AS Populacao,
       ROUND(SUM(Populacao*pctHomem),0) AS pop_homem,
       ROUND(SUM(Populacao*pctMulher),0) AS pop_mulher
  FROM Cidades
 GROUP BY Estado
HAVING SUM(Populacao*pctMulher) > SUM(Populacao*pctHomem);
       
-- 11 A CIDADE COM MENOR PERCENTUAL DE MULHERES E A DIFERENÇA DE 
-- PERCENTUAL EM RELAÇÃO AOS HOMENS 
SELECT Municipio,
	   Estado,
	   pctHomem,
	   pctMulher,
	   (pctHomem-pctMulher) AS diferenca
  FROM Cidades
 WHERE pctMulher = (
      SELECT MIN(pctMulher)
        FROM Cidades)
 LIMIT 1;
 
 -- 12 A CIDADE COM A MENOR POPULAÇÃO POR ESTADO
SELECT c.Estado, c.Municipio, c.Populacao
  FROM Cidades c
 INNER JOIN (
      SELECT Estado, MIN(Populacao) AS menor
        FROM Cidades
	   GROUP BY Estado
) AS sub
    ON c.Estado = sub.Estado AND c.Populacao = sub.menor;

-- 13 AS CINCO MAIORES CIDADES SENDO UMA DE CADA ESTADO COM A MAIOR 
-- POUPULACAO 
SELECT c.Municipio, c.Estado, c.Populacao
  FROM Cidades c
 INNER JOIN (
      SELECT Estado, MAX(Populacao) AS maior
	    FROM Cidades
	   GROUP BY Estado) AS sub
    ON c.Estado = sub.Estado AND c.Populacao = sub.maior
 ORDER BY c.Populacao DESC
 LIMIT 5;
 
-- 14 A QUANTIDADE DE HOMENS E MULHERES POR ESTADO ORDEM ASCENDENTE 
-- DE ESTADO 
SELECT Estado,
	   ROUND(SUM(Populacao*pctHomem/100),0) AS pophomem,
       ROUND(SUM(Populacao*pctMulher/100),0) AS popmulher
  FROM Cidades
 GROUP BY Estado
 ORDER BY Estado ASC;

-- 15 A SOMATORIA DA POPULAÇÃO PELA INICIAL DA CIDADE A,B,C,D POR ORDEM 
-- DE LETRA
SELECT
  LEFT(Municipio, 1) AS Letra,
  SUM(Populacao) AS Total
FROM Cidades
WHERE LEFT(Municipio, 1) IN ('A', 'B', 'C', 'D', 'E')
GROUP BY Letra
ORDER BY Letra;

-- 16 A SOMATORIA DA POPULACAO POR ESTADO, SOMENTE PARA AS CIDADES 
-- ONDE PERCENTUAL DE HOMENS É MAIOR QUE O PERCENTUAL DE MULHERES
SELECT Estado, SUM(Populacao)
 
		FROM Cidades
	   WHERE pctHomem > pctMulher
     
 GROUP BY Estado;

-- 17 A CIDADE E ESTADO DA MAIOR DIFERENÇA DA POPULACAO DE HOMEM E 
-- MULHER 
SELECT Estado, 
	   Municipio,
       ROUND((pctHomem*Populacao/100),0)AS pophomem,
       ROUND((pctMulher*Populacao/100),0)AS popmulher,
       ROUND(((pctMulher-pctHomem)*Populacao),0) AS diferenca
  FROM Cidades
 ORDER BY diferenca DESC
 LIMIT 1;
 
-- 18 IDENTIFIQUE OS TRÊS ESTADOS COM A MAIOR MÉDIA DE POPULAÇÃO POR 
-- MUNICÍPIO, CONSIDERANDO APENAS OS  MUNICÍPIOS CUJA POPULAÇÃO SEJA 
-- SUPERIOR A 50.000 HABITANTES.
SELECT Estado, (SUM(Populacao)/COUNT(Municipio)) AS media_populacao

		FROM Cidades
	   WHERE Populacao>50000
	
 GROUP BY Estado
 ORDER BY media_populacao DESC 
 LIMIT 3;
 
-- 19 LISTE OS CINCO MUNICÍPIOS COM A MENOR POPULAÇÃO MASCULINA EM 
-- TERMOS, MAS ONDE A POPULAÇÃO URBANA SEJA SUPERIOR A 80%.
SELECT Municipio, 
	   (pctHomem*Populacao/100) AS populacao_masculina,
       pctUrbana AS percentual

        FROM Cidades
	   WHERE pctUrbana>80
      
 ORDER BY populacao_masculina ASC 
 LIMIT 5;
 
-- 20  PARA CADA ESTADO, IDENTIFIQUE O MUNICÍPIO QUE MAIS SE APROXIMA DA 
-- MÉDIA POPULACIONAL DAQUELE ESTADO.
SELECT c2.Estado, c2.Municipio, c2.Populacao, ROUND(sub3.menor,0) AS menor_diff
  FROM 
     (SELECT sub2.Estado,MIN(sub2.diff) AS menor
        FROM
           (SELECT c.Codigo, c.Estado, c.Municipio, c.Populacao, ABS(C.Populacao-sub1.media) AS diff
			  FROM Cidades c INNER JOIN 
				 (SELECT (SUM(Populacao)/COUNT(Municipio)) AS media, Estado
					FROM Cidades
			       GROUP BY Estado
				 )
				AS sub1 ON c.Estado = sub1.Estado
		   ) 
		  AS sub2
       GROUP BY sub2.Estado
	 ) 
	AS sub3 
 INNER JOIN 
	 (SELECT c.Codigo, c.Estado, c.Municipio, c.Populacao, ABS(C.Populacao-sub1.media) AS diff
		FROM Cidades c 
	   INNER JOIN 
           (SELECT (SUM(Populacao)/COUNT(Municipio)) AS media, Estado
			  FROM Cidades
			 GROUP BY Estado
			)
		   AS sub1 ON c.Estado = sub1.Estado
	 ) 
	AS c2 ON sub3.Estado = c2.Estado AND sub3.menor = c2.diff
 ORDER BY sub3.menor ASC;
