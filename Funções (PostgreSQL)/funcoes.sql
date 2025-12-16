CREATE SCHEMA funcoesbd2;
SET SEARCH_PATH TO funcoesbd2;

CREATE TABLE Pessoa(
   id int,
   nome varchar(80)
);

INSERT INTO Pessoa (id,nome)
VALUES (1,'GABRIEL PONTEL DE MORI'),
       (2,'JOSE BERNARDO'),
       (3,'JOAQUIM FRANCISCO'),
       (4,'SOFIA DA SILVA COSTA');

-- abntextendido – Recebendo um nome retorna ele no formato ABNT Nome inteiro
-- Exemplo: select abntextendido("JOAO CARLOS DE OLIVEIRA SANTOS");
-- SANTOS, JOAO CARLOS DE OLIVEIRA
create function abntextendido(nome varchar) returns varchar
as
$$
begin
   return concat(
               right(nome,strpos(reverse(nome), ' ')),
               ', ',
               left(nome, length(nome)-strpos(reverse(nome), ' '))
          );
end;
$$ language plpgsql;
SELECT nome, abntextendido(nome) FROM Pessoa;

-- 2 – abnt  – Recebendo um nome retorna ele no formato ABNT nome abreviado
-- Exemplo:  select abntextendido("JOAO CARLOS DE OLIVEIRA SANTOS");
-- RESPOSTA: SANTOS, J. C. DE O.
CREATE OR REPLACE FUNCTION abnt(nome TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
declare
    partes TEXT[];
    sobrenome TEXT;
    resultado TEXT := '';
    i INT;
begin
    nome := trim(upper(nome));
    partes := string_to_array(nome, ' ');
    sobrenome := partes[array_length(partes, 1)];
    resultado := sobrenome || ', ';
    for i in 1..array_length(partes, 1) - 1 LOOP
        IF partes[i] in ('DE', 'DA', 'DO', 'DAS', 'DOS') THEN
            resultado := resultado || partes[i] || ' ';
        ELSE
            resultado := resultado || left(partes[i], 1) || '. ';
        end IF;
    END loop;
    RETURN trim(resultado);
end;
$$;
SELECT nome, abnt(nome)FROM pessoa;

-- 3 – abrevia  – Recebendo um nome retorna o nome abreviado Exemplo: select abntextendido("JOAO CARLOS DE OLIVEIRA SANTOS");
-- RESPOSTA: JOAO C. DE. O. SANTOS
create function abrevia(nome varchar) returns varchar
as
$$
DECLARE
   inicio varchar;
   fim varchar;
   aux varchar;
   comparativa varchar;
begin
   inicio := left(nome, strpos(nome, ' ')-1);
   fim := right(nome, strpos(reverse(nome), ' ')-1);
   nome := right(nome,length(nome)-strpos(nome, ' '));
   aux := ' ';
   while nome != fim LOOP
       comparativa := left(nome,3);
       IF comparativa = 'DE ' OR comparativa = 'DA ' THEN
           comparativa := replace(comparativa, ' ', '.');
           aux := concat(aux,comparativa,' ');
       ELSE
           aux :=  concat(aux,left(nome,1), '.', ' ');
       END IF;
       nome := right(nome,length(nome)-strpos(nome, ' '));
   end loop;
   aux := concat(inicio,aux,fim);
   return aux;
end;
$$ language plpgsql;
SELECT nome, abrevia(nome) FROM pessoa;

-- 4 – retornanome – Recebendo uma posição e um nome, retorne a palavra correspondente a posição informada.
-- Exemplo: select retornanome(1,"CESAR OLIVEIRA DE ANDRADE"); RESPOSTA: CESAR
-- select retornanome(3,"CESAR OLIVEIRA DE ANDRADE");  RESPOSTA: DE
create function retornanome(num integer,nome varchar) returns
varchar
as
$$
DECLARE
   aux varchar;
   quant integer;
   i integer;
begin
   aux := replace(nome,' ', '');
   quant := length(nome) +1 - length(aux);
   aux := null;
   nome:=concat(nome,' ');
   if num < quant+1 THEN
       num := num-1;
       for i IN 1..num LOOP
           nome := right(nome, length(nome) - strpos(nome,' '));
       end loop;
       aux := left(nome, strpos(nome,' '));
   end if;
   return aux;
end;
$$language plpgsql;
SELECT nome, retornanome(2,nome)FROM pessoa;

-- 5 – contvogais – Recebendo um texto retorne a quantidade de vogais no texto.
-- Exemplo: select contavogais(VILSON MAZIERO");
-- RESPOSTA: 6

create function contvogais(nome varchar) returns integer
as
$$
DECLARE
   aux varchar;
begin
   aux:=replace(nome, 'A', '');
   aux:=replace(aux, 'E', '');
   aux:=replace(aux, 'I', '');
   aux:=replace(aux, 'O', '');
   aux:=replace(aux, 'U', '');
   return length(nome) - length(aux);
end;
$$ language plpgsql;
select nome, contvogais(nome) FROM pessoa;