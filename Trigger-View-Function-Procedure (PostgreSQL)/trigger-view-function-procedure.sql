SET
    SEARCH_PATH TO provabd2;

-- 1. (0,5) Atualize todos as informações que estão incompletas na sua base de dados
-- para que a mesma fique consistente.
--    • Atributos TOTALCOMPRADO, TOTALPAGO e TOTALPENDENTE da tabela CLIENTE
--    • Atributo VALOR tabela PAGAMENTO
--    • Atributo ESTOQUE na tabela PRODUTO
--    • Atributo VALORTOTAL na tabela COMPRA

DO
$$
    DECLARE
        i integer;
        j
          integer;
        valor_parcela
          numeric;
        quant_vendida
          integer;
        quant_comprada
          integer;
    BEGIN
        FOR i in (SELECT idcliente FROM itemvendido GROUP BY idcliente)
            LOOP
                UPDATE cliente
                SET totalcomprado = (SELECT SUM(qtde * preco) FROM itemvendido WHERE idcliente = i),
                    totalpago     = (SELECT SUM(qtde * preco)
                                     FROM itemvendido
                                     WHERE datapagamento IS NOT NULL
                                       AND idcliente = i),
                    totalpendente = (SELECT SUM(qtde * preco)
                                     FROM itemvendido
                                     WHERE datapagamento IS NULL
                                       AND idcliente = i)
                WHERE idcliente = i;
            end loop;
        FOR i in (SELECT idcompra FROM itemcomprado GROUP BY idcompra)
            LOOP
                UPDATE compra
                SET valortotal = (SELECT SUM(qtde * preco) FROM itemcomprado where idcompra = i)
                WHERE idcompra = i;
            end loop;
        FOR i in (SELECT idcompra FROM pagamento GROUP BY idcompra)
            LOOP
                valor_parcela = (SELECT valortotal FROM compra WHERE idcompra = i) /
                                (SELECT COUNT(*) FROM pagamento WHERE idcompra = i);
                FOR j IN (SELECT idpagamento FROM pagamento GROUP BY idpagamento)
                    LOOP
                        UPDATE pagamento
                        SET valor = valor_parcela
                        WHERE idcompra = i
                          AND idpagamento = j;
                    end loop;
            end loop;
        FOR i in (SELECT produto.idproduto FROM produto GROUP BY idproduto)
            LOOP
                IF ((SELECT controlaestoque FROM produto WHERE idproduto = i) = 'S') THEN
                    quant_comprada = (SELECT coalesce(SUM(qtde), 0) FROM itemcomprado WHERE idproduto = i);
                    quant_vendida
                        = (SELECT coalesce(SUM(qtde), 0) FROM itemvendido WHERE idproduto = i);
                    UPDATE produto
                    SET estoque = (quant_comprada - quant_vendida)
                    WHERE idproduto = i;
                ELSE
                    UPDATE produto
                    SET estoque = 0
                    WHERE idproduto = i;
                end if;

            end loop;
    end;
$$;

-- 2. (0,75) Corrija a tabela ITEMVENDIDO de acordo com o diagrama acerte os valores
-- do atributo IDITEMVENDIDO. Para efetuar a correção crie um BLOCO ANONIMO que
-- resolva o problema.
-- DO
-- $$
-- DECLARE
--      ...
--      ...
-- BEGIN
-- END;
-- .....
-- Após rodar cada cliente deve ter o ITEMVENDIDO
-- Cliente 1 Pagamentos de 1 ... N
-- Cliente 2 Pagamentos de 1 ... N
DO
$$
    DECLARE
        id_itemvendido integer;
        i
                       integer;
        id_cliente
                       integer;
    BEGIN
        FOR id_cliente IN (SELECT idcliente FROM itemvendido GROUP BY idcliente)
            LOOP
                i := 1;
                FOR id_itemvendido IN (SELECT iditemvendido FROM itemvendido WHERE idcliente = id_cliente)
                    LOOP
                        UPDATE itemvendido
                        SET iditemvendido = i
                        WHERE idcliente = id_cliente
                          AND iditemvendido = id_itemvendido;
                        i
                            := i + 1;
                    end loop;
            end loop;
    end;
$$;

-- 3. (0,5) Toda vez que um item for vendido alterado ou excluído em ITEMVENDIDO,
-- tem que atualizar o atributo ESTOQUE da tabela PRODUTO caso o atributo
-- CONTROLAESTOQUE = 'S' o mesmo deve ser feito quanto for comprado.
CREATE
    OR REPLACE FUNCTION atualiza_estoque_venda() RETURNS TRIGGER
AS
$$

BEGIN
    IF
        (tg_op = 'INSERT' AND (SELECT produto.controlaestoque FROM produto WHERE idproduto = new.idproduto) = 'S') THEN
        UPDATE produto
        SET estoque = estoque - new.qtde
        WHERE idproduto = new.idproduto;
        return new;
    end if;
    IF
        (tg_op = 'UPDATE' AND (SELECT produto.controlaestoque FROM produto WHERE idproduto = new.idproduto) = 'S') THEN
        UPDATE produto
        SET estoque = estoque - new.qtde + old.qtde
        WHERE idproduto = new.idproduto;
        return new;
    end if;
    IF
        (tg_op = 'DELETE' AND (SELECT produto.controlaestoque FROM produto WHERE idproduto = old.idproduto) = 'S') THEN
        UPDATE produto
        SET estoque = estoque + old.qtde
        WHERE idproduto = old.idproduto;
        return old;
    end if;

end;
$$
    language plpgsql;
CREATE TRIGGER trg_atualiza_estoque_venda
    AFTER INSERT OR
        UPDATE OR
        DELETE
    ON itemvendido
    FOR EACH ROW
EXECUTE PROCEDURE atualiza_estoque_venda();

CREATE
    OR REPLACE FUNCTION atualiza_estoque_compra() RETURNS TRIGGER
AS
$$

BEGIN
    IF
        (tg_op = 'INSERT' AND (SELECT produto.controlaestoque FROM produto WHERE idproduto = new.idproduto) = 'S') THEN
        UPDATE produto
        SET estoque = estoque + new.qtde
        WHERE idproduto = new.idproduto;
        return new;
    end if;
    IF
        (tg_op = 'UPDATE' AND (SELECT produto.controlaestoque FROM produto WHERE idproduto = new.idproduto) = 'S') THEN
        UPDATE produto
        SET estoque = estoque + new.qtde - old.qtde
        WHERE idproduto = new.idproduto;
        return new;
    end if;
    IF
        (tg_op = 'DELETE' AND (SELECT produto.controlaestoque FROM produto WHERE idproduto = old.idproduto) = 'S') THEN
        UPDATE produto
        SET estoque = estoque - old.qtde
        WHERE idproduto = old.idproduto;
        return old;
    end if;
    return NULL;
end;
$$
    language plpgsql;
CREATE TRIGGER trg_atualiza_estoque_compra
    AFTER INSERT OR
        UPDATE OR
        DELETE
    ON itemcomprado
    FOR EACH ROW
EXECUTE PROCEDURE atualiza_estoque_compra();

-- 4. (0,5) Crie uma procedure de nome EFETUAR_PAGAMENTO(CLIENTE,QTVENDAS)
-- que ao receber o IDCLIENTE e QTVENDAS,  de baixa nas próximas N vendas
-- pendentes do cliente, atualize os atributos da tabela CLIENTE, TOTALCOMPRA,
-- TOTALPENDENTE, TOTALPAGO. Mostre no output com raise notice, as parcelas
-- pagas e o total geral conforme abaixo:
-- Pagamento efetuado: 19.50  // raise notice 'Pagamento efetuado: %',x;
-- Pagamento efetuado: 31.80
-- Pagamento efetuado: 19.50
-- Pagamento efetuado: 34.50
-- Pagamento efetuado: 19.50
-- Total baixado: 124.80
-- // raise notice 'Total baixado: %',valor;
create procedure efetuar_pagamento(cliente int, qtdvendas int) as
$$
DECLARE
    cont integer := 0;
    total
         integer;
    i
         integer := 1;
    soma
         numeric := 0;
    x
         numeric;
begin
    total
        := (SELECT COUNT(*) FROM itemvendido WHERE idcliente = cliente);
    while
        i <= total AND cont < qtdvendas
        LOOP
            if ((SELECT datapagamento FROM itemvendido WHERE idcliente = cliente AND iditemvendido = i) IS NULL) THEN
                UPDATE itemvendido
                SET datapagamento = now()
                WHERE iditemvendido = i
                  AND idcliente = cliente;
                SELECT (qtde * preco)
                INTO x
                FROM itemvendido
                WHERE idcliente = cliente
                  AND iditemvendido = i;
                raise
                    notice 'Pagamento efetuado: %', x;
                soma
                    := soma + x;
                cont
                    := cont + 1;
            end if;
            i
                := i + 1;
        end loop;
    raise
        notice 'Total baixado: %', soma;
    UPDATE cliente
    SET totalpago     = COALESCE(totalpago, 0) + soma,
        totalpendente = COALESCE(totalpendente, 0) - soma
    WHERE idcliente = cliente;
end;
$$
    language plpgsql;

-- 5. (0,5) Diariamente o ESTAGIARIO tem que criar o RESUMODIARIO, para isso crie uma
-- procedure CRIAR_RESUMO(DATA) que ao ser executada diariamente ele pega a
-- data que é passada e no ITEMVENDIDO o que foi pago nesta data e atualiza o
-- atributo ENTRADA do RESUMO fazendo a mesma coisa em PAGAMENTO
-- verificando o que foi pago e atualizando o atributo SAIDA e SALDO.
create procedure criar_resumo(dia DATE) as
$$
DECLARE
    valor_entrada numeric;
    valor_saida
                  numeric;
begin
    IF NOT EXISTS (SELECT 1
                   FROM resumodiario
                   WHERE idresumodiario = dia) THEN
        valor_entrada := (SELECT coalesce(SUM(qtde * preco), 0) FROM itemvendido WHERE datapagamento = dia);
        valor_saida
            := (SELECT coalesce(SUM(valor), 0) FROM pagamento WHERE datapagamento = dia);
        insert into resumodiario (idresumodiario, entrada, saida, saldo)
        VALUES (dia, valor_entrada, valor_saida, valor_entrada - valor_saida);
    end if;
end;
$$
    language plpgsql;

-- 6. (0,25) Crie uma VIEW de nome POSICAO_ESTOQUE que mostre os produtos em
-- estoque controlado CONTROLARESTOQUE=’S’, esta VIEW deve ter os campos:
-- IDPRODUTO, NOMEPRODUTO, QTDECOMPRADO, QTDEVENDIDO, QTDE,
-- VALOR_TOTAL_ESTOQUE que é a QTDE * PRECO
create view posicao_estoque as
SELECT idproduto,
       nomeproduto,
       (SELECT coalesce(SUM(qtde), 0) FROM itemcomprado WHERE idproduto = p.idproduto) AS qtdecomprado,
       (SELECT coalesce(SUM(qtde), 0) FROM itemvendido WHERE idproduto = p.idproduto)  AS qtdevendido,
       estoque                                                                         AS qtde,
       (estoque * preco)                                                               AS valor_total_estoque
FROM produto p
WHERE controlaestoque = 'S'
GROUP BY idproduto;