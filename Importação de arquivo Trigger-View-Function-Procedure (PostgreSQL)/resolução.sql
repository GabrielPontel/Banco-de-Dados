CREATE SCHEMA prova2;
SET SEARCH_PATH TO prova2;

-- 1- 0,75) Crie o schema prova2, faça a importação do arquivo CSV criando a
-- tabela DADOSAPOS. Gere uma chave primaria serial IDAPOSENTADO
-- primary key, e crie atributo IDORGAO int para a tabela importada e o
-- atributo ESTADO varchar(100).

-- Para importar inicialmente deve-se selecionar o schema e ir em
-- importar/exportar renomeia a importação para a geração da tabela
-- e deixe como text o que esta dando problema
SELECT *
FROM dadosapo;

-- Comando para gerar a chave serial
-- ALTER TABLE nomeTabela ADD COLUMN nomeColuna SERIAL;
ALTER TABLE dadosapo
    ADD COLUMN idaposentado SERIAL PRIMARY KEY;

--Comando para criar uma nova coluna de qualque tipo
-- ALTER TABLE nomeTabela ADD COLUMN nomeColuna TIPO;
ALTER TABLE dadosapo
    ADD COLUMN idorgao int;
ALTER TABLE dadosapo
    ADD COLUMN estado VARCHAR(100);

-- Crie a tabela ORGAO com os atributos IDORGAO, UORG, ORGAO e
-- CLASSE relacione as tabelas e exclua os atributos de DADOSAPOS.
-- Altere os atributos da tabela DADOSAPOS conforme segue: CPF
-- varchar(14), SITUACAO varchar(20), FUNDAMENTACAO varchar(12)
-- DATAOCORRENCIA E DATADOU para date.

--Criação da tabela orgao
-- CREATE TABLE nomeTabela AS (Consulta);
CREATE TABLE orgao AS (SELECT DISTINCT dadosapo.idorgao, dadosapo.uorg, dadosapo.orgao, dadosapo.classe
                       FROM dadosapo);
SELECT *
FROM orgao;
--CRIAR A CHAVE PRIMARIA EM orgao, no entanto de acordo com Vilso
-- como esta nula é mais faciol apagar e criar serial novamento
ALTER TABLE orgao
    DROP COLUMN idorgao;
ALTER TABLE orgao
    ADD COLUMN idorgao SERIAL PRIMARY KEY;

--RELACIONAR AS TABELAS, PARA GARANTIR A INTEGRIDADE
update dadosapo ds
SET idorgao = (SELECT o.idorgao FROM orgao o WHERE o.classe = ds.classe AND o.orgao = ds.orgao AND o.uorg = ds.uorg)
WHERE idaposentado > 0;
SELECT *
FROM dadosapo
WHERE idorgao IS NULL;

ALTER TABLE dadosapo
    ADD CONSTRAINT fk_dadosapo_orgao
        FOREIGN KEY (idorgao)
            REFERENCES orgao (idorgao);

-- DROPAR AS COLUNAS EM DADOS
ALTER TABLE dadosapo
    DROP COLUMN classe;
ALTER TABLE dadosapo
    DROP COLUMN uorg;
ALTER TABLE dadosapo
    DROP COLUMN orgao;

ALTER TABLE dadosapo
    ALTER COLUMN cpf TYPE VARCHAR(14);
ALTER TABLE dadosapo
    ALTER COLUMN situacao TYPE VARCHAR(20);
ALTER TABLE dadosapo
    ALTER COLUMN fundamentacao TYPE VARCHAR(12);
-- O USING serve para ensinar ao PostgreSQL como converter os valores existentes da coluna antiga para o novo tipo.
ALTER TABLE dadosapo
    ALTER COLUMN dataocorrencia TYPE DATE USING dataocorrencia::DATE;
ALTER TABLE dadosapo
    ALTER COLUMN datadou TYPE DATE USING datadou::DATE;

-- 2 (1,0) Dada a tabela acima, Figura 1 que indica o estado em que o CPF foi
-- emitido, de acordo com o nono “9” digito do CPF. Crie uma função com
-- nome de retorna_estado que ao receber o CPF e 0 ou 1 como parâmetro,
-- retorne o nome do estado. Execute a função e substitua o valor do atributo
-- ESTADO utilizando o retorno de retorna_estado(cpf,0) para todos os
-- registro de DADOSAPOS.
-- Antes altere todos os CPF´s da tabela DADOSAPOS conforme abaixo
-- Altere o cpf para ‘***.161.491-** para 161.161.491-91
-- Estado = retornaNomeEstado(cpf,condicao)
-- Condicao = 1 retorna sempre o

UPDATE dadosapo ds1
SET cpf = (SELECT substr(cpf, 5, 3) || substr(cpf, 4, 9) || substr(cpf, 10, 2)
           FROM dadosapo ds2
           WHERE ds2.idaposentado = ds1.idaposentado)
WHERE ds1.idaposentado > 0;

create function retornar_estado(cpf varchar, condicao int) returns varchar
as
$$
DECLARE
    posicao         integer;
    numero          varchar(1);
    estado_desejado varchar(100);
begin
    numero := (substr(cpf, 9, 1));
    if (numero = '0') then
        estado_desejado := 'Rio Grande do Sul';
    end if;
    if (numero = '1') then
        estado_desejado := 'Distrito Federal, Goiás, Mato Grosso, Mato Grosso do Sul e Tocantins';
    end if;
    if (numero = '2') then
        estado_desejado := 'Amazonas, Pará, Roraima, Amapá, Acre e Rondônia';
    end if;
    if (numero = '3') then
        estado_desejado := 'Ceará, Maranhão e Piauí';
    end if;
    if (numero = '4') then
        estado_desejado := 'Paraíba, Pernambuco, Alagoas e Rio Grande do Norte';
    end if;
    if (numero = '5') then
        estado_desejado := 'Bahia e Sergipe';
    end if;
    if (numero = '6') then
        estado_desejado := 'Minas Gerais';
    end if;
    if (numero = '7') then
        estado_desejado := 'Rio de Janeiro e Espírito Santo';
    end if;
    if (numero = '8') then
        estado_desejado := 'São Paulo';
    end if;
    if (numero = '9') then
        estado_desejado := 'Paraná e Santa Catarina';
    end if;
    if (condicao = 1) then
        posicao = strpos(estado_desejado, ',') - 1;
        if (posicao > 0) then
            estado_desejado := left(estado_desejado, posicao);
        end if;
        posicao = strpos(estado_desejado, ' e ') - 1;
        if (posicao > 0) then
            estado_desejado := left(estado_desejado, posicao);
        end if;
    else
        if (condicao <> 0) then
            estado_desejado := null;
        end if;
    end if;
    return estado_desejado;
end;
$$ language plpgsql;

-- 3 (0,25) Crie um VIEW que mostre os campos ESTADO, MES e TOTAL de
-- aposentadorias no mês,  o mês deve ser extraído do atributo DATADOU e
-- por ordem de estado e mês.
CREATE VIEW view_prova AS
(
SELECT DISTINCT estado,
                (EXTRACT(MONTH FROM ds.datadou))                                                  AS mes,
                (SELECT COUNt(*)
                 FROM dadosapo
                 WHERE (EXTRACT(MONTH FROM dadosapo.datadou)) = (EXTRACT(MONTH FROM ds.datadou))) AS total
FROm dadosapo ds
ORDER BY estado, mes);

-- 4 (0,50) Crie uma procedure que atualize a matricula conforme o exemplo
-- abaixo, para cada pessoa da seguinte forma:
-- 001xxxxx = 001-1001
-- 001xxxxx = 001-1002
-- 002xxxxx = 002-1001
-- 002xxxxx = 002-1002
-- 002xxxxx = 002-1003
-- Altere todas as matrículas utilizando o procedimento.

create procedure atualiza_matriculas()
as
$$
DECLARE
    mat                record;
    matricula_desejada varchar(20);
    numero             int;
begin
    for matricula_desejada in (SELECT matricula FROm dadosapo GROUP BY matricula)
        loop
            numero := 1000;
            for mat in (SELECT * FROM dadosapo where matricula = matricula_desejada)
                loop
                    update dadosapo ds
                    SET matricula = left(matricula, 3) || '-' || cast(numero as varchar)
                    where ds.idaposentado = mat.idaposentado;
                    numero := numero + 1;
                end loop;
        end loop;
end;
$$ language plpgsql;

call atualiza_matriculas();

-- 5 (0,50) Crie o usuário com seu RA e de os direitos necessários para que ele
-- possa acessar o schema e inserir, alterar e excluir na tabela DADOSAPOS
-- porém na tabela ORGAO apenas visualizar os dados.

CREATE ROLE pe3029042 with password 'senha';
ALTER ROLE pe3029042 LOGIN;
GRANT USAGE ON SCHEMA prova2 TO pe3029042;
grant select, insert, UPDATE, DELETE on table dadosapo to pe3029042;
grant select on table orgao to pe3029042;