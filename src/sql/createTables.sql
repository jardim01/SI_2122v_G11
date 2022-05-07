create table clientes
(
    nif         int primary key check (nif between 0 and 999999999),
    nome        text    not null,
    morada      text    not null,
    telefone    integer not null check (telefone between 0 and 999999999),
    ref_cliente int,
    removido    bit     not null default '0'
);

create table clientes_institucionais
(
    nif_cliente   int primary key,
    nome_contacto text not null,
    foreign key (nif_cliente) references clientes (nif) on update cascade
);

create table clientes_particulares
(
    nif_cliente int primary key,
    cc          int not null check (cc between 0 and 99999999),
    foreign key (nif_cliente) references clientes (nif) on update cascade
);

alter table clientes
    add constraint ref_cliente_fk foreign key (ref_cliente)
        references clientes_particulares (nif_cliente) on update cascade;


create table frotas_veiculos
(
    id          serial primary key,
    nif_cliente int not null,
    foreign key (nif_cliente) references clientes (nif) on update cascade
);

create table estados_equipamentos
(
    estado text not null primary key
);

create or replace function validar_matricula(matricula varchar(8)) returns boolean
    language plpgsql
as
$$
begin
    -- 00-00-AA
    if regexp_match(matricula, '\d{2}-\d{2}-[A-Z]{2}') is not null then
        return true;
    end if;
    -- 00-AA-00
    if regexp_match(matricula, '\d{2}-[A-Z]{2}-\d{2}') is not null then
        return true;
    end if;
    -- AA-00-00
    if regexp_match(matricula, '[A-Z]{2}-\d{2}-\d{2}') is not null then
        return true;
    end if;
    -- AA-00-AA
    if regexp_match(matricula, '[A-Z]{2}-\d{2}-[A-Z]{2}') is not null then
        return true;
    end if;
    return false;
end;
$$;

create table veiculos
(
    matricula         varchar(8) primary key check (validar_matricula(matricula)),
    nome_cond_atual   text        not null,
    telef_cond_actual int         not null,
    id_equip          text unique not null,
    estado_equip      text        not null,
    id_frota          int         not null,
    n_alarmes         int         not null default 0,
    foreign key (id_frota) references frotas_veiculos (id),
    foreign key (estado_equip) references estados_equipamentos (estado)
);

create table zonas_verdes
(
    id_zona   serial primary key,
    latitude  decimal(7, 5) not null check ( latitude between -90 and 90),
    longitude decimal(8, 5) not null check ( longitude between -180 and 180),
    raio      int           not null,
    matricula varchar(8)    not null,
    foreign key (matricula) references veiculos (matricula)
);

create table registos_nao_processados
(
    id_reg         serial primary key,
    id_equip       text,
    marca_temporal timestamp(0),
    latitude       decimal(7, 5),
    longitude      decimal(8, 5)
);

create table registos_processados
(
    id_reg              serial primary key,
    marca_temporal_proc timestamp(0)  not null,
    id_equip            text          not null,
    latitude            decimal(7, 5) not null,
    longitude           decimal(8, 5) not null,
    foreign key (id_equip) references veiculos (id_equip)
);

create table registos_invalidos
(
    equip_id             text,
    marca_temporal_inval timestamp(0),
    latitude             decimal(7, 5),
    longitude            decimal(8, 5)
);

create table alarmes
(
    id_reg         int          not null unique,
    matricula      text         not null,
    marca_temporal timestamp(0) not null,
    foreign key (id_reg) references registos_processados (id_reg),
    foreign key (matricula) references veiculos (matricula)
);
