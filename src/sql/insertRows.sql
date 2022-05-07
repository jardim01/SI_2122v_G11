insert into clientes (nif, nome, morada, telefone, ref_cliente)
values (000000000, 'Paulo', 'Rua do rei', 295000000, null);
insert into clientes (nif, nome, morada, telefone, ref_cliente)
values (111111111, 'Joana', 'Rua da rainha', 295111111, 000000000);
insert into clientes (nif, nome, morada, telefone, ref_cliente)
values (222222222, 'Luis', 'Rua do principe', 295222222, 111111111);
insert into clientes (nif, nome, morada, telefone, ref_cliente)
values (333333333, 'Leonor', 'Rua da princesa', 295333333, 222222222);
insert into clientes (nif, nome, morada, telefone, ref_cliente)
values (444444444, 'Daniel', 'Rua do escravo', 295444444, 111111111);

insert into clientes_institucionais (nif_cliente, nome_contacto)
values (000000000, 'Francisco');
insert into clientes_institucionais (nif_cliente, nome_contacto)
values (111111111, 'Joao');
insert into clientes_institucionais (nif_cliente, nome_contacto)
values (222222222, 'Leonardo');

insert into clientes_particulares (nif_cliente, cc)
values (222222222, 01234567);
insert into clientes_particulares (nif_cliente, cc)
values (333333333, 12345678);
insert into clientes_particulares (nif_cliente, cc)
values (444444444, 23456789);

insert into frotas_veiculos (nif_cliente)
values (000000000);
insert into frotas_veiculos (nif_cliente)
values (111111111);

insert into estados_equipamentos (estado)
values ('Activo');
insert into estados_equipamentos (estado)
values ('PausaDeAlarmes');
insert into estados_equipamentos (estado)
values ('Inactivo');

insert into veiculos (matricula, nome_cond_atual, telef_cond_actual, id_equip, estado_equip, id_frota)
values ('00-AA-00', 'David', 295666666, '1ZZZ', 'Activo', 2);
insert into veiculos (matricula, nome_cond_atual, telef_cond_actual, id_equip, estado_equip, id_frota)
values ('11-BB-11', 'Bruno', 295777777, '2XXX', 'Activo', 1);
insert into veiculos (matricula, nome_cond_atual, telef_cond_actual, id_equip, estado_equip, id_frota)
values ('22-CC-22', 'Renato', 295888888, '3YYY', 'Inactivo', 1);

insert into zonas_verdes (latitude, longitude, raio, matricula)
values (-22.22222, 100.22222, 500, '00-AA-00');
insert into zonas_verdes (latitude, longitude, raio, matricula)
values (33.33333, -100.33333, 1000, '11-BB-11');

insert into registos_processados (marca_temporal_proc, id_equip, latitude, longitude)
values (CURRENT_TIMESTAMP(0), '1ZZZ', -22.22222, 100.22222);
insert into registos_processados (marca_temporal_proc, id_equip, latitude, longitude)
values (CURRENT_TIMESTAMP(0), '2XXX', 33.33333, -100.33333);

insert into registos_invalidos (equip_id, marca_temporal_inval, latitude, longitude)
values ('1ZZZ', CURRENT_TIMESTAMP, -22.22222, 100.22222);
insert into registos_invalidos (equip_id, marca_temporal_inval, latitude, longitude)
values ('2XXX', CURRENT_TIMESTAMP - INTERVAL '15' day, -22.22222, 100.22222);
