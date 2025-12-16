use registros;

create table dados(
       linha varchar(255)
);

insert into dados (linha) values("01 JOAO_SILVA joao.silva4@gmail.com 1980-04-05 GOIANIA SP 12287.94 ATIVO");

insert into dados (linha) values("02 MARIA_OLIVEIRA maria.oliveira@softdeloteria.com.br 1966-02-07 RIO_DE_JANEIRO CE 11063.03 ATIVO");

insert into dados (linha) values("03 PEDRO_SOUZA pedro.souza@softdeloteria.com.br 1993-10-09 VITORIA SC 1306.97 ATIVO");

insert into dados (linha) values("04 ANA_PEREIRA ana.pereira44@outlook.com 1974-04-25 CURITIBA SP 2719.48 ATIVO");

insert into dados (linha) values("05 CARLOS_ALMEIDA carlos.almeida45@yahoo.com 1967-12-15 SALVADOR SP 7401.10 INATIVO");

insert into dados (linha) values("06 JULIA_COSTA julia.costa@softdeloteria.com.br 1969-01-22 RIO_DE_JANEIRO RN 5941.10 ATIVO");

insert into dados (linha) values("07 LUCAS_ROCHA lucas.rocha49@gmail.com 1994-11-27 CURITIBA RJ 7265.45 ATIVO");

insert into dados (linha) values("08 BEATRIZ_GOMES beatriz.gomes@yahoo.com 2003-11-06 SALVADOR ES 5210.20 INATIVO");

insert into dados (linha) values("09 RAFAEL_FERREIRA rafael.ferreira@outlook.com 1985-01-08 NATAL MS 14389.40 INATIVO");

insert into dados (linha) values("10 CAMILA_MARTINS camila.martins@yahoo.com 2001-12-11 RIO_DE_JANEIRO GO 9379.50 INATIVO");

insert into dados (linha) values("11 GABRIEL_RIBEIRO gabriel.ribeiro@hotmail.com 1980-12-18 SALVADOR PR 13439.74 INATIVO");

insert into dados (linha) values("12 LARISSA_BARROS larissa.barros52@softdeloteria.com.br 1979-03-17 RECIFE SP 13582.06 ATIVO");

insert into dados (linha) values("13 BRUNO_SANTOS bruno.santos@hotmail.com 1992-10-03 PORTO_ALEGRE PE 10963.59 INATIVO");

insert into dados (linha) values("14 ISABELA_MELO isabela.melo@softdeloteria.com.br 1999-05-25 MANAUS RS 3027.37 INATIVO");

insert into dados (linha) values("15 RENAN_CARVALHO renan.carvalho@hotmail.com 1981-09-25 SAO_PAULO CE 2943.80 INATIVO");

insert into dados (linha) values("16 PATRICIA_TEIXEIRA patricia.teixeira@softdeloteria.com.br 1974-06-25 SAO_PAULO CE 13957.67 ATIVO");

insert into dados (linha) values("17 DIEGO_PINTO diego.pinto42@softdeloteria.com.br 1966-02-12 FLORIANOPOLIS SC 14418.39 ATIVO");

insert into dados (linha) values("18 FERNANDA_ARAUJO fernanda.araujo@gmail.com 1970-12-16 NATAL SP 13661.68 ATIVO");

insert into dados (linha) values("19 TIAGO_DIAS tiago.dias85@hotmail.com 1970-12-16 SALVADOR SC 11138.54 ATIVO");

insert into dados (linha) values("20 AMANDA_FREITAS amanda.freitas@softdeloteria.com.br 1984-07-22 MANAUS RS 8377.66 INATIVO");

insert into dados (linha) values("21 VICTOR_MOURA victor.moura@gmail.com 1969-06-01 FORTALEZA CE 4970.75 ATIVO");

insert into dados (linha) values("22 NATASHA_CARDOSO natasha.cardoso@gmail.com 1979-02-02 NATAL RS 2360.65 ATIVO");

insert into dados (linha) values("23 RODRIGO_CAMPOS rodrigo.campos86@yahoo.com 1978-09-05 GOIANIA AM 10640.60 ATIVO");

insert into dados (linha) values("24 CAROLINA_NOGUEIRA carolina.nogueira@outlook.com 1971-02-22 PORTO_ALEGRE RS 8139.52 INATIVO");

insert into dados (linha) values("25 IGOR_BATISTA igor.batista@gmail.com 1968-07-24 CURITIBA RN 2990.31 ATIVO");

insert into dados (linha) values("26 MONIQUE_SALES monique.sales69@hotmail.com 1973-07-06 BELO_HORIZONTE BA 5292.09 INATIVO");

insert into dados (linha) values("27 ANDRE_LIMA andre.lima@softdeloteria.com.br 1999-01-03 FLORIANOPOLIS RN 5072.21 INATIVO");

insert into dados (linha) values("28 PRISCILA_DUARTE priscila.duarte@outlook.com 1990-01-06 PORTO_ALEGRE MS 7596.33 INATIVO");

insert into dados (linha) values("29 FELIPE_CESAR felipe.cesar55@yahoo.com 1974-04-10 RIO_DE_JANEIRO MS 10689.94 ATIVO");

insert into dados (linha) values("30 VIVIANE_REIS viviane.reis@yahoo.com 2002-08-17 FLORIANOPOLIS SC 9901.20 ATIVO");

CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY,
  nome VARCHAR(120) NULL,
  email VARCHAR(120) NULL,
  nascimento DATE NULL,
  cidade VARCHAR(100) NULL,
  uf CHAR(2) NULL,
  renda DECIMAL(10,2) NULL,
  status ENUM('ATIVO','INATIVO') NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;