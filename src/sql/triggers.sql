-- j) TODO: Verificar se o registo é válido
create or replace function inserirAlarme() returns trigger
    language plpgsql
as
$$
declare
    r    record;
    m    varchar(8);
    nome text;
    t    timestamp(0);
begin
    select * into r from registos_nao_processados where reg_id = new.reg_id;
    if r is null then
        raise exception 'reg_id inválido';
    end if;

    m = obterMatricula(r.equip_fk);
    if new.matricula is not null and new.matricula != m then
        raise exception 'A matrícula do registo não corresponde com a fornecida';
    end if;

    nome = obterNomeCondutorAtual(m);
    if new.nome_condutor is not null and new.nome_condutor != nome then
        raise exception 'A nome do condutor atual não corresponde com o fornecido';
    end if;

    if new.latitude is not null and new.latitude != r.latitude then
        raise exception 'A latitude não corresponde com a fornecida';
    end if;

    if new.longitude is not null and new.longitude != r.longitude then
        raise exception 'A longitude não corresponde com a fornecida';
    end if;

    t = CURRENT_TIMESTAMP;
    if new.marca_temporal is not null then
        t = new.marca_temporal;
    end if;

    if dentrozonaverde(r.latitude, r.longitude, m) then
        raise exception 'O veículo está dentro das zonas verdes';
    end if;

    insert into registos_processados (marca_temporal_proc, equip_fk, latitude, longitude)
    values (CURRENT_TIMESTAMP, r.equip_fk, r.latitude, r.longitude);

    insert into alarmes (reg_fk, marca_temporal)
    values (r.reg_id, t);

    delete
    from registos_nao_processados
    where reg_id = r.reg_id;

    return null;
end;
$$;

drop trigger if exists inserirAlarme on view_alarmes;
create trigger inserirAlarme
    instead of insert
    on view_alarmes
    for each row
execute function inserirAlarme();

-- l)
create or replace function apagarCliente() returns trigger
    language plpgsql
as
$$
begin
    update clientes
    set removed_cliente = '1'
    where nif = old.nif;

    return null;
end;
$$;

drop trigger if exists desativar_cliente on view_clientes;
create trigger desativar_cliente
    instead of delete
    on view_clientes
    for each row
execute function apagarCliente();
