
CREATE SCHEMA avl;
SET SEARCH_PATH TO avl;
-- -----------------------------------------------------
-- Table avl.aluno
-- -----------------------------------------------------
CREATE TABLE aluno
(
    idaluno  SERIAL,
    nome     VARCHAR(45) NULL,
    cpf      VARCHAR(14) NULL,
    endereco VARCHAR(60) NULL,
    uf       VARCHAR(2)  NULL,
    cep      VARCHAR(9)  NULL,
    PRIMARY KEY (idaluno)
)
;


-- -----------------------------------------------------
-- Table avl.curso
-- -----------------------------------------------------
CREATE TABLE curso
(
    idcurso      SERIAL,
    nome         VARCHAR(45) NULL,
    cargahoraria INT         NULL,
    preco        numeric     NULL,
    qtdeparcelas INT         NULL,
    PRIMARY KEY (idcurso)
)
;


-- -----------------------------------------------------
-- Table avl.matricula
-- -----------------------------------------------------
CREATE TABLE matricula
(
    idano       INT  NOT NULL,
    idmatricula INT  NOT NULL,
    data        DATE NULL,
    idaluno     INT  NOT NULL,
    idcurso     INT  NOT NULL,
    PRIMARY KEY (idano, idmatricula),
    FOREIGN KEY (idaluno)
        REFERENCES aluno (idaluno),
    FOREIGN KEY (idcurso)
        REFERENCES curso (idcurso)
);


-- -----------------------------------------------------
-- Table avl.caixa
-- -----------------------------------------------------
CREATE TABLE caixa
(
    idcaixa         SERIAL,
    data            DATE    NULL,
    entradas        numeric NULL,
    saidas          numeric NULL,
    saldo           numeric NULL,
    hora_abertura   TIME    NULL,
    hora_fechamento TIME    NULL,
    PRIMARY KEY (idcaixa)
)
;


-- -----------------------------------------------------
-- Table avl.pagamento
-- -----------------------------------------------------
CREATE TABLE pagamento
(
    idano       INT     NOT NULL,
    idmatricula INT     NOT NULL,
    vencimento  DATE    NOT NULL,
    valor       numeric NULL,
    idcaixa     INT     NULL,
    PRIMARY KEY (idano, idmatricula, vencimento),
    FOREIGN KEY (idano, idmatricula)
        REFERENCES matricula (idano, idmatricula),
    FOREIGN KEY (idcaixa)
        REFERENCES caixa (idcaixa)
)
;

-- -----------------------------------------------------
-- Table avl.disciplinas
-- -----------------------------------------------------
CREATE TABLE disciplinas
(
    idcurso       INT         NOT NULL,
    iddisciplinas INT         NOT NULL,
    descricao     VARCHAR(45) NULL,
    PRIMARY KEY (idcurso, iddisciplinas),
    FOREIGN KEY (idcurso)
        REFERENCES curso (idcurso)
)
;


-- -----------------------------------------------------
-- Table avl.notas
-- -----------------------------------------------------
CREATE TABLE notas
(
    idano         INT     NOT NULL,
    idmatricula   INT     NOT NULL,
    idnota        INT     NULL,
    idcurso       INT     NOT NULL,
    iddisciplinas INT     NOT NULL,
    nota1         numeric NULL,
    nota2         numeric NULL,
    nota3         numeric NULL,
    nota4         numeric NULL,
    media         numeric NULL,
    PRIMARY KEY (idano, idmatricula, idnota),
    FOREIGN KEY (idano, idmatricula)
        REFERENCES matricula (idano, idmatricula),
    FOREIGN KEY (idcurso, iddisciplinas)
        REFERENCES disciplinas (idcurso, iddisciplinas)
);

-- (0,25) Crie uma view DADOSALUNO para tabela aluno que mostre nome, cpf, endereco, uf, cep porem
-- CPF tem que aparecer nnn-***.**n-** onde n é o numero do CPF.
CREATE VIEW dadosaluno AS
SELECT nome,
       cpf,
       endereco,
       uf,
       cep,
       substring(cpf,1,3) || '-***.**' || substring(cpf,12,1) || '-**' AS cpf_criptografado
FROM aluno;


-- (0,50) Ao inserir a disciplinas o atributo iddisciplinas tem que ser gerado automaticamente para cada curso
-- ele começa no 1. insert into disciplinas values(1,null,’MATEMATICA’)
CREATE OR REPLACE FUNCTION atualiza_curso() RETURNS TRIGGER
AS
$$
DECLARE
    i   integer := 1;
    aux record;
BEGIN
    IF (tg_op = 'INSERT') THEN
        new.iddisciplinas := -1;
        while new.iddisciplinas = -1
            LOOP
                SELECT iddisciplinas INTO aux FROM disciplinas d WHERE d.idcurso = new.idcurso AND d.iddisciplinas = i;
                if (aux IS NULL) THEN
                    new.iddisciplinas := i;
                end if;
                i := i + 1;
            end loop;
        return new;
    end if;
    IF (tg_op = 'DELETE') THEN
        update disciplinas
        SET iddisciplinas = iddisciplinas - 1
        WHERE idcurso = old.idcurso
          AND iddisciplinas > old.iddisciplinas;
        return old;
    end if;
    return null;
end;
$$ language plpgsql;
CREATE TRIGGER trg_atualiza_curso
    BEFORE INSERT OR DELETE
    ON disciplinas
    FOR EACH ROW
EXECUTE PROCEDURE atualiza_curso();


-- (1,00) Ao inserir uma MATRICULA INSERT INTO MATRICULA(2024,?,?,IDALUNO,IDCURSO) os
-- atributos com ? devem ser atribuídos automaticamente, as parcelas de PAGAMENTO devem ser geradas
-- e as  disciplinas do curso devem ser lançadas em NOTAS um registro para cada disciplina.
CREATE OR REPLACE FUNCTION atualiza_matricula() RETURNS TRIGGER
AS
$$
DECLARE
    i              integer := 1;
    aux            record;
BEGIN
    IF (tg_op = 'INSERT') THEN
        new.data := now();
        new.idmatricula := -1;
        while new.idmatricula = -1
            loop
                SELECT * INTO aux FROM matricula WHERE idano = new.idano AND idmatricula = i;
                IF (aux IS NULL) THEN
                    new.idmatricula = i;
                end if;
                i := i+1;
            end loop;
    end if;
    return new;
end;
$$ language plpgsql;

CREATE TRIGGER trg_atualiza_matricula
    BEFORE INSERT
    ON matricula
    FOR EACH ROW
EXECUTE PROCEDURE atualiza_matricula();


CREATE OR REPLACE FUNCTION gera_dependentes() RETURNS TRIGGER
AS
$$
DECLARE
    id_disciplina  integer;
    i              integer;
    valor_parcela  numeric;
    dia_vencimento DATE;
BEGIN
    valor_parcela := (SELECT preco FROM curso WHERE idcurso = new.idcurso) /
                     (SELECT qtdeparcelas FROM curso WHERE idcurso = new.idcurso);
    dia_vencimento := now();
    FOR i in 1 .. (SELECT qtdeparcelas FROM curso WHERE idcurso = new.idcurso)
        LOOP
            dia_vencimento := dia_vencimento + interval '1 month';
            INSERT INTO pagamento (idano, idmatricula, vencimento, valor)
            VALUES (new.idano, new.idmatricula, dia_vencimento, valor_parcela);
        end loop;
    i := 1;
    FOR id_disciplina in (SELECT iddisciplinas FROM disciplinas WHERE idcurso = new.idcurso)
        LOOP
            INSERT INTO notas (idano, idmatricula, idnota, idcurso, iddisciplinas, nota1, nota2, nota3, nota4, media)
            VALUES (new.idano, new.idmatricula, i, new.idcurso, id_disciplina, 0, 0, 0, 0, 0);
            i := i + 1;
        end loop;
    return new;
end;
$$ language plpgsql;
CREATE TRIGGER trg_gera_dependentes
    AFTER INSERT
    ON matricula
    FOR EACH ROW
EXECUTE PROCEDURE gera_dependentes();

-- (0,25)  Ao informar as notas (nota1,nota2,nota3 e nota4) a média é calculada automaticamente.
CREATE OR REPLACE FUNCTION atualiza_notas() RETURNS TRIGGER
AS
$$
DECLARE
BEGIN
    IF (tg_op = 'UPDATE' AND (old.nota1 <> new.nota1 OR old.nota2 <> new.nota2 OR old.nota3 <> new.nota3 OR old.nota4 <> new.nota4)) THEN
        new.media := (new.nota1+new.nota2+new.nota3+new.nota4)/4;
    end if;
    return new;
end;
$$ language plpgsql;
CREATE TRIGGER trg_atualiza_notas
    BEFORE UPDATE
    ON notas
    FOR EACH ROW
EXECUTE PROCEDURE atualiza_notas();


-- (0,25) Ao efetuar um pagamento o valor deve ser adicionado no atributo entrada do caixa caso o caixa
-- exista caso contrário a parcela continua pendente.

CREATE OR REPLACE FUNCTION verifica_caixa() RETURNS TRIGGER
AS
$$
BEGIN
    if(tg_op = 'UPDATE' AND old.idcaixa IS NULL AND new.idcaixa IS NOT NULL) THEN
        if((SELECT idcaixa FROM caixa WHERE idcaixa = new.idcaixa) IS NULL) THEN
            new.idcaixa := null;
        end if;
    end if;
    return new;
end;
$$ language plpgsql;
CREATE TRIGGER trg_verifica_caixa
    BEFORE UPDATE
    ON pagamento
    FOR EACH ROW
EXECUTE PROCEDURE verifica_caixa();

CREATE OR REPLACE FUNCTION atualiza_caixa() RETURNS TRIGGER
AS
$$
BEGIN

    if(tg_op = 'UPDATE' AND old.idcaixa IS NULL AND new.idcaixa IS NOT NULL) THEN
        update caixa SET entradas = entradas + new.valor, saldo = saldo + new.valor WHERE idcaixa = new.idcaixa;
    end if;
    return new;
end;
$$ language plpgsql;
CREATE TRIGGER trg_atualiza_caixa
    AFTER UPDATE
    ON pagamento
    FOR EACH ROW
EXECUTE PROCEDURE atualiza_caixa();

-- (0,75) Para um aluno ser aprovado ele tem que ter média acima de 6 em todas as disciplinas do curso crie
-- uma view que mostre  uma relação onde apareça nome do aluno, curso, situacao (APROVADO OU
-- REPROVADO)
CREATE VIEW situacao_aluno AS
SELECT a.nome AS nome_aluno,
       c.nome AS nome_curso,
       CASE
           WHEN (SELECT COUNT(*) FROM notas WHERE media >= 6 AND idmatricula = m.idmatricula AND idano = m.idano) = (SELECT COUNT(*) FROM notas WHERE idmatricula = m.idmatricula AND idano = m.idano) then
            'APROVADO'
            else
            'REPROVADO'
       END AS situacao
    FROM matricula m
JOIN aluno a ON m.idaluno = a.idaluno
JOIn curso c on m.idcurso = c.idcurso;

