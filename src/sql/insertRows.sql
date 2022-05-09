call inserirCliente(000000000,
                    'Empresa 1',
                    'Chelas',
                    295000000,
                    null,
                    'I',
                    'Rui',
                    null);
call inserirCliente(111111111,
                    'Empresa 2',
                    'Amadora',
                    295111111,
                    null,
                    'I',
                    'Alberto',
                    null);
call inserirCliente(222222222,
                    'João',
                    'Alameda',
                    295222222,
                    null,
                    'P',
                    null,
                    55555555);
call inserirCliente(333333333,
                    'Joana',
                    'Saldanha',
                    295333333,
                    null,
                    'P',
                    null,
                    66666666);

insert into estados_equipamentos (estado)
values ('Activo');
insert into estados_equipamentos (estado)
values ('PausaDeAlarmes');
insert into estados_equipamentos (estado)
values ('Inactivo');

call criarVeiculo(
        '00-AA-00',
        'Miguel',
        236000000,
        000000000,
        -22.22222,
        100.11111,
        2000
    );
call criarVeiculo(
        '11-BB-11',
        'Lucília',
        236111111,
        111111111,
        -33.33333,
        120.33333,
        3000
    );
call criarVeiculo(
        '22-CC-22',
        'Rui',
        236222222,
        222222222
    );
