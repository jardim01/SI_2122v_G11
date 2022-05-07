call inserirCliente(000000000,
                    'Empresa 1',
                    'Chelas',
                    295000000,
                    null,
                    'Rui');
call inserirCliente(111111111,
                    'Empresa 2',
                    'Amadora',
                    295111111,
                    null,
                    'Alberto');
call inserirCliente(222222222,
                    'João',
                    'Alameda',
                    295222222,
                    null,
                    null,
                    true,
                    55555555);
call inserirCliente(333333333,
                    'Joana',
                    'Saldanha',
                    295333333,
                    null,
                    null,
                    true,
                    66666666);

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
