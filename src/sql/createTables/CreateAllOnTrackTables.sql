create table CLIENTES
(
    nif int primary key check (nif between 0 and 999999999),/*TODO : Tem que ser um e apenas um cliente institucional ou particular*/
    nome text not null,
    morada text not null,
    telefone integer not null check ( telefone between 0 and 999999999),
    ref_cliente int ,
    removed_cliente bit not null DEFAULT '0'
);
ALTER TABLE CLIENTES add constraint ref_cliente_fk foreign key(ref_cliente) references clientes(nif);

INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente) VALUES (000000000, 'Paulo', 'Rua do rei', 295000000, null);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente) VALUES (111111111, 'Joana', 'Rua da rainha', 295111111,000000000);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente) VALUES (222222222, 'Luis', 'Rua do principe', 295222222,111111111);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente) VALUES (333333333, 'Leonor', 'Rua da princesa', 295333333, 222222222);
INSERT INTO clientes (nif, nome, morada, telefone, ref_cliente) VALUES (444444444, 'Daniel', 'Rua do escravo', 295444444,111111111);

create table CLIENTES_INSTITUCIONAIS
(
    nif_cliente int not null
        constraint CLIENTES_INSTITUCIONAIS_PK primary key,
    nome_contacto text not null,
    foreign key (nif_cliente) references clientes (nif)
);

INSERT INTO clientes_institucionais (nif_cliente, nome_contacto)VALUES (000000000, 'Francisco');
INSERT INTO clientes_institucionais (nif_cliente, nome_contacto)VALUES (111111111, 'Joao');
INSERT INTO clientes_institucionais (nif_cliente, nome_contacto)VALUES (222222222, 'Leonardo');
create table CLIENTES_PARTICULARES
(
    nif_cliente int not null
        constraint CLIENTES_PARTICULARES_PK primary key,
    cc int not null check (cc between 0 and 99999999),
    foreign key (nif_cliente) references clientes (nif)
);

INSERT INTO clientes_particulares (nif_cliente, cc)VALUES (222222222, 01234567);
INSERT INTO clientes_particulares (nif_cliente, cc)VALUES (333333333, 12345678);
INSERT INTO clientes_particulares (nif_cliente, cc)VALUES (444444444, 23456789);

create table FROTA_VEICULOS
(
    id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome text NOT NULL,
    cliente_fk int not null,
    foreign key (cliente_fk) references clientes (nif)
);

INSERT INTO frota_veiculos (nome, cliente_fk)VALUES ('Porto transport', 000000000);
INSERT INTO frota_veiculos (nome, cliente_fk)VALUES ('Lisboa transport', 111111111);

create table ESTADOS_EQUIPAMENTOS(
    estado text not null primary key
);

INSERT INTO ESTADOS_EQUIPAMENTOS (estado) VALUES ('Activo');
INSERT INTO ESTADOS_EQUIPAMENTOS (estado) VALUES ('PausaDeAlarmes');
INSERT INTO ESTADOS_EQUIPAMENTOS (estado) VALUES ('Inactivo');

create table VEICULOS
(
    matricula text not null constraint VEICULOS_PK primary key,/*TODO : CHECK dos tracos*/
    nome_cond_atual text not null,
    telef_cond_actual int not null,
    equip_id text unique not null,
    equip_estado text not null,
    frota_veic_fk int not null,
    foreign key (frota_veic_fk) references FROTA_VEICULOS (id),
    foreign key (equip_estado) references ESTADOS_EQUIPAMENTOS (estado)
);

INSERT INTO veiculos (matricula, nome_cond_atual, telef_cond_actual, equip_id, equip_estado, frota_veic_fk)VALUES ('00-AA-00', 'David', 295666666, '1ZZZ', 'Activo', 2);
INSERT INTO veiculos (matricula, nome_cond_atual, telef_cond_actual, equip_id, equip_estado, frota_veic_fk)VALUES ('11-BB-11', 'Bruno', 295777777, '2XXX', 'Activo', 1);
INSERT INTO veiculos (matricula, nome_cond_atual, telef_cond_actual, equip_id, equip_estado, frota_veic_fk)VALUES ('22-CC-22', 'Renato', 295888888, '3YYY', 'Inactivo', 1);



create table ZONA_VERDE
(
    zona_id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY ,
    latitude decimal(7,5) not null check ( latitude between -90 and 90),
    longitude decimal(8,5)  not null check ( longitude between -180 and 180),
    raio int not null,
    matricula_fk text not null,
    foreign key (matricula_fk) references VEICULOS(matricula)
);

INSERT INTO zona_verde (latitude,longitude, raio, matricula_fk) VALUES (-22.22222, 100.22222, 500, '00-AA-00');
INSERT INTO zona_verde (latitude,longitude, raio, matricula_fk) VALUES (33.33333, -100.33333, 1000, '11-BB-11');


create table REGISTOS_NAO_PROCESSADOS
(
    equip_fk text primary key,
    marca_temporal timestamp not null,
    latitude decimal(5) not null,
    longitude decimal(5) not null,
    foreign key (equip_fk) references VEICULOS(equip_id)
);


create table REGISTOS_PROCESSADOS
(
    reg_id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    marca_temporal_proc date not null,
    equip_fk text not null,
    foreign key (equip_fk) references VEICULOS(equip_id)
);

create table REGISTOS_INVALIDOS
(
    equip_id text not null,
    marca_temporal_inval timestamp not null,
    latitude decimal(5) not null,
    longitude decimal(5) not null
);

create table ALARME
(
    reg_fk int not null,
    foreign key (reg_fk) references REGISTOS_PROCESSADOS(reg_id)
);