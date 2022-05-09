-- g)
create or replace function analisarRegistoProcessado() returns trigger
    language plpgsql
as
$$
declare
    matr    varchar(8);
    _estado varchar(20);
begin
    matr = obterMatricula(new.id_equip);
    -- verificar se está dentro das zonas verdes
    if (not dentroZonaVerde(new.latitude, new.longitude, matr)) then
        -- verificar se está em pausa de alarmes
        select estado
        into _estado
        from veiculos
                 join equipamentos on (id_equip = id)
        where matricula = matr;

        if (_estado != 'PausaDeAlarmes') then
            -- gerar alarme
            call gerarAlarme(new.id_reg, matr);
        end if;
    end if;
    return null;
end;
$$;

drop trigger if exists analisar_registo_processado on registos_processados;
create trigger analisar_registo_processado
    after insert
    on registos_processados
    for each row
execute function analisarRegistoProcessado();

-- Limitação do número de veículos
create or replace function verificarLimiteVeiculos() returns trigger
    language plpgsql
as
$$
declare
    cliente record;
begin
    cliente = obterCliente(new.id_frota);
    if (cliente.tipo = 'P') then
        if (contarVeiculos(cliente.nif) > 3) then
            raise exception 'Número máximo de veículos alcançado';
        end if;
    end if;

    return null;
end;
$$;

drop trigger if exists verificar_limite_veiculos on veiculos;
create trigger verificar_limite_veiculos
    after insert
    on veiculos
    for each row
execute function verificarLimiteVeiculos();

-- j)
create or replace function inserirAlarme() returns trigger
    language plpgsql
as
$$
declare
    r    record;
    m    varchar(8);
    nome varchar(60);
begin
    if new.marca_temporal is not null then
        raise exception 'A marca temporal é gerada automaticamente';
    end if;

    select * into r from registos_nao_processados where id_reg = new.id_reg;
    if r is null then
        raise exception 'reg_id inválido';
    end if;

    if (not registoValido(r)) then
        raise exception 'O registo é inválido';
    end if;

    m = obterMatricula(r.id_equip);
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

    if dentrozonaverde(r.latitude, r.longitude, m) then
        raise exception 'O veículo está dentro das zonas verdes';
    end if;

    call processarRegistoValido(r);

    return null;
end;
$$;

drop trigger if exists inserirAlarme on vista_alarmes;
create trigger inserirAlarme
    instead of insert
    on vista_alarmes
    for each row
execute function inserirAlarme();

-- l)
create or replace function apagarCliente() returns trigger
    language plpgsql
as
$$
begin
    call removerCliente(old.nif);
    return null;
end;
$$;

drop trigger if exists desativar_cliente on vista_clientes;
create trigger desativar_cliente
    instead of delete
    on vista_clientes
    for each row
execute function apagarCliente();

-- m)
create or replace function incrementarNumeroAlarmes() returns trigger
    language plpgsql
as
$$
begin
    update veiculos
    set n_alarmes = n_alarmes + 1
    where matricula = new.matricula;

    return null;
end;
$$;

drop trigger if exists incrementar_n_alarmes on alarmes;
create trigger incrementar_n_alarmes
    after insert
    on alarmes
    for each row
execute function incrementarNumeroAlarmes();