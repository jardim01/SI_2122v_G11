/* TODO: Tem que ser um e apenas um cliente institucional ou particular */
create table clientes
(
    nif             int primary key check (nif between 0 and 999999999),
    nome            text    not null,
    morada          text    not null,
    telefone        integer not null check ( telefone between 0 and 999999999),
    ref_cliente     int,
    removed_cliente bit     not null default '0'
);

alter table clientes
    add constraint ref_cliente_fk foreign key (ref_cliente) references clientes (nif);

create table clientes_institucionais
(
    nif_cliente   int primary key,
    nome_contacto text not null,
    foreign key (nif_cliente) references clientes (nif)
);

create table clientes_particulares
(
    nif_cliente int primary key,
    cc          int not null check (cc between 0 and 99999999),
    foreign key (nif_cliente) references clientes (nif)
);

create table frotas_veiculos
(
    id         int primary key generated always as identity,
    nome       text NOT NULL,
    cliente_fk int  not null,
    foreign key (cliente_fk) references clientes (nif)
);

create table estados_equipamentos
(
    estado text not null primary key
);

create table veiculos
(
    matricula         varchar(8)  not null
        constraint VEICULOS_PK primary key check (matricula like '__-__-__'),
    nome_cond_atual   text        not null,
    telef_cond_actual int         not null,
    equip_id          text unique not null,
    equip_estado      text        not null,
    frota_veic_fk     int         not null,
    foreign key (frota_veic_fk) references frotas_veiculos (id),
    foreign key (equip_estado) references estados_equipamentos (estado)
);

create table zonas_verdes
(
    zona_id      int primary key generated always as identity,
    latitude     decimal(7, 5) not null check ( latitude between -90 and 90),
    longitude    decimal(8, 5) not null check ( longitude between -180 and 180),
    raio         int           not null,
    matricula_fk text          not null,
    foreign key (matricula_fk) references veiculos (matricula)
);

create table registos_nao_processados
(
    equip_fk       text primary key,
    marca_temporal timestamp  not null,
    latitude       decimal(5) not null,
    longitude      decimal(5) not null,
    foreign key (equip_fk) references veiculos (equip_id)
);

create table registos_processados
(
    reg_id              int primary key generated always as identity,
    marca_temporal_proc timestamp not null,
    equip_fk            text      not null,
    foreign key (equip_fk) references veiculos (equip_id)
);

create table registos_invalidos
(
    equip_id             text       not null,
    marca_temporal_inval timestamp  not null,
    latitude             decimal(5) not null,
    longitude            decimal(5) not null
);

create table alarme
(
    reg_fk int not null,
    foreign key (reg_fk) references registos_processados (reg_id)
);
