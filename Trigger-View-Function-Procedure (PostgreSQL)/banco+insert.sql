CREATE SCHEMA provabd2;
SET
    SEARCH_PATH TO provabd2;

CREATE TABLE IF NOT EXISTS cliente
(
    idcliente
                  SERIAL,
    nome
                  VARCHAR(60)      NULL,
    telefone      VARCHAR(20)      NULL,
    totalcomprado DOUBLE PRECISION NULL,
    totalpago     DOUBLE PRECISION NULL,
    totalpendente DOUBLE PRECISION NULL,
    PRIMARY KEY
        (
         idcliente
            )
);


-- -----------------------------------------------------
-- Table produto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS produto
(
    idproduto
                    SERIAL
                                     NOT
                                         NULL,
    nomeproduto
                    VARCHAR(60)      NULL,
    estoque         INT              NULL,
    preco           DOUBLE PRECISION NULL,
    controlaestoque VARCHAR(1)       NULL,
    PRIMARY KEY
        (
         idproduto
            )
);


-- -----------------------------------------------------
-- Table itemvendido
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS itemvendido
(
    iditemvendido
        INT
        NOT
            NULL,
    idcliente
        INT
        NOT
            NULL,
    idproduto
        INT
        NOT
            NULL,
    qtde
        INT
        NULL,
    preco
        DOUBLE
            PRECISION
        NULL,
    datapagamento
        DATE
        NULL,
    datavenda
        DATE
        NULL,
    PRIMARY
        KEY
        (
         iditemvendido,
         idcliente
            ),
    FOREIGN KEY
        (
         idcliente
            )
        REFERENCES cliente
            (
             idcliente
                ),
    FOREIGN KEY
        (
         idproduto
            )
        REFERENCES produto
            (
             idproduto
                )
);


-- -----------------------------------------------------
-- Table resumodiario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS resumodiario
(
    idresumodiario
        DATE
        NOT
            NULL,
    entrada
        DOUBLE
            PRECISION
        NULL,
    saida
        DOUBLE
            PRECISION
        NULL,
    saldo
        DOUBLE
            PRECISION
        NULL,
    PRIMARY
        KEY
        (
         idresumodiario
            )
);


-- -----------------------------------------------------
-- Table compra
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS compra
(
    idcompra
        SERIAL
        NOT
            NULL,
    data
        DATE
        NULL,
    valortotal
        DOUBLE
            PRECISION
        NULL,
    PRIMARY
        KEY
        (
         idcompra
            )
);


-- -----------------------------------------------------
-- Table itemcomprado
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS itemcomprado
(
    idcompra
        INT
        NOT
            NULL,
    idproduto
        INT
        NOT
            NULL,
    qtde
        INT
        NULL,
    preco
        DOUBLE
            PRECISION
        NULL,
    PRIMARY
        KEY
        (
         idcompra,
         idproduto
            ),
    FOREIGN KEY
        (
         idproduto
            )
        REFERENCES produto
            (
             idproduto
                ),
    FOREIGN KEY
        (
         idcompra
            )
        REFERENCES compra
            (
             idcompra
                )
);


-- -----------------------------------------------------
-- Table pagamento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS pagamento
(
    idpagamento
        INT
        NOT
            NULL,
    idcompra
        INT
        NOT
            NULL,
    vencimento
        DATE
        NULL,
    valor
        DOUBLE
            PRECISION
        NULL,
    datapagamento
        DATE
        NULL,
    PRIMARY
        KEY
        (
         idcompra,
         idpagamento
            ),
    FOREIGN KEY
        (
         idcompra
            )
        REFERENCES compra
            (
             idcompra
                )
);



INSERT INTO cliente (nome, telefone)
VALUES ('João Silva', '(11) 98765-4321');
INSERT INTO cliente (nome, telefone)
VALUES ('Maria Santos', '(11) 91234-5678');
INSERT INTO cliente (nome, telefone)
VALUES ('Pedro Oliveira', '(11) 97777-8888');
INSERT INTO cliente (nome, telefone)
VALUES ('Ana Costa', '(11) 96666-5555');
INSERT INTO cliente (nome)
VALUES ('Carlos Ferreira');
INSERT INTO cliente (nome, telefone)
VALUES ('Lucia Pereira', '(11) 92222-3333');
INSERT INTO cliente (nome, telefone)
VALUES ('Roberto Almeida', '(11) 94444-5555');
INSERT INTO cliente (nome, telefone)
VALUES ('Patricia Lima', '(11) 98888-9999');
INSERT INTO cliente (nome)
VALUES ('Fernando Souza');
INSERT INTO cliente (nome, telefone)
VALUES ('Beatriz Martins', '(11) 95555-4444');

INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Chocolate Quente', 0, 6.50, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Milk Shake', 0, 12.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Chá Gelado', 0, 5.00, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Cappuccino', 0, 7.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Açaí na Tigela', 0, 14.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Vitamina de Frutas', 0, 9.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Água Mineral 500ml', 0, 3.50, 'S');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Kibe', 25, 6.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Hamburguer', 40, 16.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Refrigerante Lata', 0, 5.50, 'S');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Coca Cola lata 350', 0, 4.00, 'S');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Coxinha', 40, 6.50, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Batata Frita P', 30, 8.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('X-Burger', 50, 18.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Misto Quente', 25, 12.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Esfiha de Frango', 30, 5.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Fanta lata 350 ', 0, 7.50, 'S');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Mini Pizza', 20, 15.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Pão de Queijo', 45, 3.90, 'N');
INSERT INTO produto (nomeproduto, estoque, preco, controlaestoque)
VALUES ('Pastel de Carne', 35, 9.90, 'N');

INSERT INTO compra (idcompra, data, valortotal)
values (1, CURRENT_DATE, 0);
INSERT INTO compra (idcompra, data, valortotal)
values (2, CURRENT_DATE, 0);
INSERT INTO compra (idcompra, data, valortotal)
values (3, CURRENT_DATE, 0);

INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (1, 2, 5, 4.90);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (1, 4, 15, 3.20);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (1, 6, 20, 3.50);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (1, 8, 9, 6.90);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (2, 2, 8, 4.90);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (2, 4, 10, 3.20);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (2, 6, 11, 3.50);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (2, 8, 7, 6.90);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (3, 2, 13, 4.90);
INSERT INTO itemcomprado (idcompra, idproduto, qtde, preco)
VALUES (3, 4, 12, 3.20);

INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (1, CURRENT_DATE + INTERVAL '30 days', 0.00, 1);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (1, CURRENT_DATE + INTERVAL '60 days', 0.00, 2);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (1, CURRENT_DATE + INTERVAL '90 days', 0.00, 3);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (1, CURRENT_DATE + INTERVAL '120 days', 0.00, 4);

INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (2, CURRENT_DATE + INTERVAL '15 days', 0.00, 1);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (2, CURRENT_DATE + INTERVAL '45 days', 0.00, 2);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (2, CURRENT_DATE + INTERVAL '75 days', 0.00, 3);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (2, CURRENT_DATE + INTERVAL '105 days', 0.00, 4);

INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (3, CURRENT_DATE + INTERVAL '10 days', 0.00, 1);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (3, CURRENT_DATE + INTERVAL '40 days', 0.00, 2);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (3, CURRENT_DATE + INTERVAL '70 days', 0.00, 3);
INSERT INTO pagamento (idcompra, vencimento, valor, idpagamento)
VALUES (3, CURRENT_DATE + INTERVAL '100 days', 0.00, 4);

INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (1, 8, 4, 5, 3.50, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (2, 8, 4, 1, 3.50, null, '2025-09-22');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (3, 8, 14, 2, 5.00, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (4, 8, 19, 5, 6.90, null, '2025-09-05');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (5, 8, 15, 2, 15.90, null, '2025-09-12');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (6, 8, 20, 2, 9.90, null, '2025-09-19');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (7, 8, 10, 3, 6.50, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (8, 8, 5, 3, 6.50, null, '2025-08-30');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (9, 8, 5, 1, 6.50, null, '2025-09-15');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (10, 8, 5, 5, 6.50, null, '2025-09-10');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (11, 8, 11, 5, 3.90, null, '2025-09-02');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (12, 8, 14, 5, 5.00, null, '2025-09-09');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (13, 8, 7, 2, 12.90, null, '2025-09-19');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (14, 8, 4, 5, 3.50, null, '2025-09-18');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (15, 9, 6, 3, 4.00, null, '2025-09-20');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (16, 9, 16, 2, 7.90, null, '2025-08-30');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (17, 9, 10, 5, 6.50, null, '2025-09-04');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (18, 9, 19, 2, 6.90, null, '2025-09-15');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (19, 9, 12, 1, 12.90, null, '2025-09-17');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (20, 9, 17, 2, 16.90, null, '2025-09-08');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (21, 9, 5, 1, 6.50, null, '2025-09-14');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (22, 7, 8, 3, 7.50, null, '2025-09-02');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (23, 7, 7, 5, 12.90, null, '2025-09-09');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (24, 7, 16, 1, 7.90, null, '2025-09-16');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (25, 7, 6, 2, 4.00, null, '2025-09-19');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (26, 7, 7, 1, 12.90, null, '2025-09-21');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (27, 7, 7, 4, 12.90, null, '2025-08-27');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (28, 7, 16, 5, 7.90, null, '2025-08-31');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (29, 5, 6, 1, 4.00, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (30, 2, 6, 1, 4.00, null, '2025-08-31');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (31, 3, 6, 2, 4.00, null, '2025-09-16');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (32, 1, 4, 1, 3.50, null, '2025-09-19');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (33, 2, 4, 5, 3.50, null, '2025-09-16');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (34, 4, 4, 1, 3.50, null, '2025-09-16');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (35, 8, 14, 2, 5.00, '2025-09-14', '2025-09-23');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (36, 5, 4, 1, 3.50, '2025-09-14', '2025-09-18');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (37, 8, 17, 1, 16.90, '2025-09-19', '2025-09-18');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (38, 9, 5, 1, 6.50, '2025-09-19', '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (39, 7, 2, 1, 5.50, '2025-09-19', '2025-09-04');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (40, 8, 15, 2, 15.90, '2025-09-12', '2025-09-02');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (41, 9, 11, 1, 3.90, '2025-09-12', '2025-09-13');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (42, 7, 11, 2, 3.90, '2025-09-12', '2025-09-25');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (43, 3, 6, 2, 4.00, '2025-09-12', '2025-09-22');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (44, 5, 4, 5, 3.50, '2025-09-12', '2025-08-30');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (45, 2, 4, 4, 3.50, '2025-09-12', '2025-09-15');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (46, 7, 6, 2, 4.00, '2025-09-14', '2025-09-14');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (47, 6, 6, 3, 4.00, '2025-09-14', '2025-09-04');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (48, 1, 6, 1, 4.00, '2025-09-14', '2025-09-14');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (49, 10, 16, 2, 7.90, '2025-09-19', '2025-09-07');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (50, 1, 3, 2, 8.90, '2025-09-19', '2025-09-20');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (51, 2, 7, 1, 12.90, '2025-09-19', '2025-09-02');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (52, 4, 19, 1, 6.90, '2025-09-19', '2025-09-20');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (53, 6, 3, 3, 8.90, '2025-09-19', '2025-09-09');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (54, 3, 11, 1, 3.90, '2025-09-19', '2025-09-09');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (55, 5, 5, 4, 6.50, '2025-09-19', '2025-09-15');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (56, 1, 7, 2, 12.90, '2025-09-12', '2025-09-08');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (57, 4, 12, 4, 12.90, '2025-09-12', '2025-08-28');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (58, 6, 16, 3, 7.90, '2025-09-12', '2025-09-21');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (59, 10, 5, 5, 6.50, '2025-09-12', '2025-08-31');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (60, 10, 8, 1, 7.50, null, '2025-09-25');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (61, 10, 7, 2, 12.90, null, '2025-09-02');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (62, 10, 17, 3, 16.90, null, '2025-09-13');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (63, 10, 9, 2, 9.90, null, '2025-09-17');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (64, 10, 19, 1, 6.90, null, '2025-08-29');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (65, 1, 15, 3, 15.90, null, '2025-09-04');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (66, 1, 15, 5, 15.90, null, '2025-09-09');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (67, 1, 8, 2, 7.50, null, '2025-09-05');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (68, 1, 3, 4, 8.90, null, '2025-08-27');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (69, 1, 3, 3, 8.90, null, '2025-08-31');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (70, 1, 5, 1, 6.50, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (71, 1, 6, 1, 4.00, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (72, 1, 17, 1, 16.90, null, '2025-09-05');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (73, 5, 15, 4, 15.90, null, '2025-09-14');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (74, 5, 2, 4, 5.50, null, '2025-09-25');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (75, 5, 19, 1, 6.90, null, '2025-09-16');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (76, 5, 19, 3, 6.90, null, '2025-09-14');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (77, 5, 4, 1, 3.50, null, '2025-09-12');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (78, 5, 2, 4, 5.50, null, '2025-08-28');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (79, 5, 16, 3, 7.90, null, '2025-09-03');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (80, 5, 5, 5, 6.50, null, '2025-09-19');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (81, 5, 9, 4, 9.90, null, '2025-09-05');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (82, 2, 15, 5, 15.90, null, '2025-09-03');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (83, 2, 10, 3, 6.50, null, '2025-08-30');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (84, 2, 20, 2, 9.90, null, '2025-09-23');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (85, 2, 14, 3, 5.00, null, '2025-09-12');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (86, 4, 12, 1, 12.90, null, '2025-09-11');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (87, 4, 15, 1, 15.90, null, '2025-09-10');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (88, 4, 10, 5, 6.50, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (89, 6, 9, 3, 9.90, null, '2025-09-21');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (90, 6, 2, 2, 5.50, null, '2025-09-17');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (91, 6, 11, 1, 3.90, null, '2025-09-17');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (92, 6, 16, 1, 7.90, null, '2025-08-29');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (93, 6, 7, 4, 12.90, null, '2025-09-07');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (94, 6, 8, 4, 7.50, null, '2025-09-13');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (95, 6, 12, 3, 12.90, null, '2025-09-18');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (96, 10, 3, 3, 6.50, null, '2025-09-11');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (97, 1, 1, 2, 16.90, null, '2025-09-10');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (98, 5, 4, 1, 6.50, null, '2025-09-06');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (99, 5, 2, 1, 6.50, null, '2025-09-01');
INSERT INTO itemvendido (iditemvendido, idcliente, idproduto, qtde, preco, datapagamento, datavenda)
VALUES (100, 5, 1, 2, 6.50, null, '2025-09-12');
