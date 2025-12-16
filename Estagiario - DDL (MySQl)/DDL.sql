USE registros;

#Alterar a chave da tabela
set sql_safe_updates=0;

-- Desabilita update sem where 
ALTER TABLE dados ADD COLUMN id_cliente int;
UPDATE dados SET id_cliente = left(linha,2);
alter table dados add primary key(id_cliente);
UPDATE dados SET linha = substr(linha,4,length(linha));

#Alterar o nome
ALTER TABLE dados ADD COLUMN nome VARCHAR(120);
UPDATE dados SET nome = replace(left(linha,LOCATE(" ", linha)), "_", " ");
UPDATE dados SET linha = substr(linha, locate(" ",linha) + 1, length(linha));

#Alterar o email
ALTER TABLE dados ADD COLUMN email VARCHAR(120);
UPDATE dados SET email = left(linha, LOCATE(" ", linha));
UPDATE dados SET linha = substr(linha, locate(" ", linha)+1, length(linha));

#Alterar data nascimento
ALTER TABLE dados ADD COLUMN nascimento DATE;
UPDATE dados SET nascimento = left(linha, 10);
UPDATE dados SET linha = substr(linha,12,length(linha));

#Alterar a cidade
ALTER TABLE dados ADD COLUMN cidade VARCHAR(100); 
UPDATE dados SET cidade = replace(left(linha,locate(" ",linha)), "_", " ");
UPDATE dados SET linha = substr(linha, locate(" ", linha)+1, length(linha));

#Alterar a UF
ALTER TABLE dados ADD COLUMN uf CHAR(2);
UPDATE dados SET uf = left(linha,2); 
UPDATE dados SET linha = substr(linha, 4, length(linha));

#Alterar a renda
ALTER TABLE dados ADD COLUMN renda DECIMAL(10,2);
UPDATE dados SET renda = left(linha, locate(" ", linha));
UPDATE dados SET linha = substr(linha, locate(" ", linha)+1, length(linha));

#Alterar o status
ALTER TABLE dados ADD COLUMN status ENUM('ATIVO','INATIVO');
UPDATE dados SET status = linha;  
ALTER TABLE dados DROP COLUMN linha;

#Alterar clientes
ALTER TABLE cliente RENAME clientes;

SELECT * FROM clientes;