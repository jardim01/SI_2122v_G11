-- f)
create or replace procedure processarRegistos()
    language plpgsql
as
$$
declare
    reg record;
begin
    for reg in select * from registos_nao_processados order by marca_temporal
        loop
            if (registoValido(reg)) then
                call processarRegistoValido(reg);
            else
                call processarRegistoInvalido(reg);
            end if;
        end loop;
end;
$$;

create or replace procedure processarRegistoValido(reg record)
    language plpgsql
as
$$
begin
    -- inserir registo processado (trigger gera alarme)
    insert into registos_processados (marca_temporal_proc, id_equip, latitude, longitude)
    values (CURRENT_TIMESTAMP, reg.id_equip, reg.latitude, reg.longitude);

    -- apagar registo não processado
    delete
    from registos_nao_processados
    where id_reg = reg.id_reg;
end;
$$;

create or replace procedure processarRegistoInvalido(reg record)
    language plpgsql
as
$$
begin
    -- adicionar registo inválido
    insert into registos_invalidos (equip_id, marca_temporal_inval, latitude, longitude)
    values (reg.id_equip, CURRENT_TIMESTAMP, reg.latitude, reg.longitude);

    -- apagar registo não processado
    delete
    from registos_nao_processados
    where id_reg = reg.id_reg;
end;
$$;

create or replace procedure gerarAlarme(id_reg integer, matricula varchar(8))
    language plpgsql
as
$$
begin
    insert into alarmes (id_reg, matricula, marca_temporal)
    values ($1, $2, CURRENT_TIMESTAMP);
end;
$$;

call processarRegistos();

-- d)
create or replace procedure inserirCliente(_nif integer,
                                           _nome varchar(60),
                                           _morada varchar(50),
                                           _telefone integer,
                                           _ref_cliente integer,
                                           tipo char,
                                           _nome_contacto varchar(60),
                                           _cc integer)
    language plpgsql
as
$$
begin
    insert into clientes (nif, nome, morada, telefone, ref_cliente, tipo)
    values (_nif, _nome, _morada, _telefone, _ref_cliente, tipo);

    insert into frotas_veiculos (nif_cliente)
    values (_nif);

    if (tipo = 'P') then
        insert into clientes_particulares (nif_cliente, cc)
        values (_nif, _cc);
    else
        insert into clientes_institucionais (nif_cliente, nome_contacto)
        values (_nif, _nome_contacto);
    end if;
end;
$$;

create or replace procedure removerCliente(_nif integer)
    language plpgsql
as
$$
begin
    update clientes
    set removido = '1'
    where nif = _nif;
end;
$$;

create or replace procedure atualizarCliente(_nif integer,
                                             novo_nif integer,
                                             novo_cc integer,
                                             novo_nome varchar(60),
                                             nova_morada varchar(50),
                                             nova_ref_cliente integer)
    language plpgsql
as
$$
begin
    if (not exists(select 1 from vista_clientes where nif = _nif)) then
        raise exception 'Não existe nenhum cliente com o nif %', _nif;
    end if;

    update clientes
    set nif         = novo_nif,
        nome        = novo_nome,
        morada      = nova_morada,
        ref_cliente = nova_ref_cliente
    where nif = _nif;

    -- ignore if client is removed
    update clientes_particulares
    set cc = novo_cc
    where nif_cliente = _nif;
end;
$$;

-- h)
create or replace procedure criarVeiculo(matr varchar(8),
                                         nomeCondutor varchar(60),
                                         telefoneCondutor integer,
                                         nifCliente integer,
                                         lat numeric(7, 5) default null,
                                         lon numeric(8, 5) default null,
                                         r integer default null)
    language plpgsql
as
$$
declare
    frota record;
    idEquip integer;
begin
    frota = obterFrotaCliente(nifCliente);

    insert into equipamentos (estado)
    values ('Activo') returning id into idEquip;

    insert into veiculos (matricula, nome_cond_atual, telef_cond_actual, id_equip, id_frota)
    values (matr, nomeCondutor, telefoneCondutor, idEquip, frota.id);

    if (lat is not null and lon is not null and r is not null) then
        insert into zonas_verdes (latitude, longitude, raio, matricula)
        values (lat, lon, r, matr);
    end if;
end;
$$;

-- k)
create or replace procedure removerRegistosInvalidos()
    language plpgsql
as
$$
begin
    delete
    from registos_invalidos
    where marca_temporal_inval + INTERVAL '15' day <= CURRENT_TIMESTAMP;
end;
$$;
