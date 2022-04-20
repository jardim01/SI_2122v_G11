INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente)
VALUES (000000000, 'Paulo', 'Rua do rei', 295000000, null);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente)
VALUES (111111111, 'Joana', 'Rua da rainha', 295111111, 000000000);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente)
VALUES (222222222, 'Luis', 'Rua do principe', 295222222, 111111111);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente)
VALUES (333333333, 'Leonor', 'Rua da princesa', 295333333, 222222222);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente)
VALUES (444444444, 'Daniel', 'Rua do escravo', 295444444, 111111111);

INSERT INTO clientes_institucionais (nif_cliente, nome_contacto)
VALUES (000000000, 'Francisco');
INSERT INTO clientes_institucionais (nif_cliente, nome_contacto)
VALUES (111111111, 'Joao');
INSERT INTO clientes_institucionais (nif_cliente, nome_contacto)
VALUES (222222222, 'Leonardo');

INSERT INTO clientes_particulares (nif_cliente, cc)
VALUES (222222222, 01234567);
INSERT INTO clientes_particulares (nif_cliente, cc)
VALUES (333333333, 12345678);
INSERT INTO clientes_particulares (nif_cliente, cc)
VALUES (444444444, 23456789);

INSERT INTO frotas_veiculos (nome, cliente_fk)
VALUES ('Porto transport', 000000000);
INSERT INTO frotas_veiculos (nome, cliente_fk)
VALUES ('Lisboa transport', 111111111);

INSERT INTO estados_equipamentos (estado)
VALUES ('Activo');
INSERT INTO estados_equipamentos (estado)
VALUES ('PausaDeAlarmes');
INSERT INTO estados_equipamentos (estado)
VALUES ('Inactivo');

INSERT INTO veiculos (matricula, nome_cond_atual, telef_cond_actual, equip_id, equip_estado, frota_veic_fk)
VALUES ('00-AA-00', 'David', 295666666, '1ZZZ', 'Activo', 2);
INSERT INTO veiculos (matricula, nome_cond_atual, telef_cond_actual, equip_id, equip_estado, frota_veic_fk)
VALUES ('11-BB-11', 'Bruno', 295777777, '2XXX', 'Activo', 1);
INSERT INTO veiculos (matricula, nome_cond_atual, telef_cond_actual, equip_id, equip_estado, frota_veic_fk)
VALUES ('22-CC-22', 'Renato', 295888888, '3YYY', 'Inactivo', 1);

INSERT INTO zonas_verdes (latitude, longitude, raio, matricula_fk)
VALUES (-22.22222, 100.22222, 500, '00-AA-00');
INSERT INTO zonas_verdes (latitude, longitude, raio, matricula_fk)
VALUES (33.33333, -100.33333, 1000, '11-BB-11');
