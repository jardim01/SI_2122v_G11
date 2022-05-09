create or replace procedure testeInserirClienteComSucesso()
    language plpgsql
as
$$
declare
    testName text;
begin
    testName = 'Inserir cliente com dados bem passados';
    call inserirCliente(999999999,
                        'John Doe',
                        'Planeta Terra',
                        987654321,
                        null,
                        null,
                        true,
                        12345678);
    raise notice '% -> Resultado OK', testName;
exception
    when others then
        raise notice '% -> Resultado NOK', testName;
end;
$$;

create or replace procedure testesInserirClienteComErro()
    language plpgsql
as
$$
declare
    testName text;
begin
    testName = 'Inserir cliente com dados mal passados';
    call inserirCliente(-1,
                        'John Doe',
                        'Planeta Terra',
                        987654321,
                        null,
                        null,
                        true,
                        12345678);
    raise exception '% -> Resultado OK', testName;
exception
    when others then
        raise notice '% -> Resultado NOK', testName;
end;
$$;

create or replace procedure testeAtualizarClienteComSucesso()
    language plpgsql
as
$$
declare
    testName text;
begin
    testName = 'Atualizar cliente com dados bem passados';
    call atualizarCliente(000000000,
                          888888888,
                          12345678,
                          'John Doe',
                          'Planeta Terra',
                          null);
    raise notice '% -> Resultado OK', testName;
exception
    when others then
        raise exception '% -> Resultado NOK (%)', testName, SQLERRM;
end;
$$;

create or replace procedure testeAtualizarClienteComErro()
    language plpgsql
as
$$
declare
    testName text;
begin
    testName = 'Atualizar cliente com dados mal passados';
    call atualizarCliente(888888888,
                          999999999,
                          12345678,
                          null,
                          'Planeta Terra',
                          null);
    raise exception '% -> Resultado OK', testName;
exception
    when others then
        raise notice '% -> Resultado NOK', testName;
end;
$$;

create or replace procedure testeRemoverClienteComSucesso()
    language plpgsql
as
$$
declare
    testName text;
begin
    testName = 'Remover cliente com dados bem passados';
    call removerCliente(888888888);
    raise notice '% -> Resultado OK', testName;
exception
    when others then
        raise exception '% -> Resultado NOK', testName;
end;
$$;

create or replace procedure testeRemoverClienteComErro()
    language plpgsql
as
$$
declare
    testName text;
begin
    testName = 'Remover cliente com dados mal passados';
    call removerCliente(-1);
    raise exception '% -> Resultado OK', testName;
exception
    when others then
        raise notice '% -> Resultado NOK', testName;
end;
$$;

create or replace procedure testeContarAlarmes()
    language plpgsql
as
$$
declare
    testName text;
    year     integer;
    n0       integer;
    n1       integer;
begin
    testName = 'Contar alarmes';

    year = extract(year from CURRENT_TIMESTAMP);
    n0 = contarAlarmes(year, '00-AA-00');

    insert into registos_processados (marca_temporal_proc, id_equip, latitude, longitude)
    values (CURRENT_TIMESTAMP, 1, 11.2, 0);
    -- alarme gerado pelo trigger

    n1 = contarAlarmes(year, '00-AA-00');
    if (n1 != n0 + 1) then
        raise exception '% -> Resultado NOK', testName;
    end if;

    raise notice '% -> Resultado OK', testName;
end;
$$;

create or replace procedure testeTratamentoRegistos()
    language plpgsql
as
$$
declare
    testName  text;
    remaining integer = -1;
begin
    testName = 'Tratamento de registos não processados';
    insert into registos_nao_processados (id_equip, marca_temporal, latitude, longitude)
    values (-1, null, null, null);
    insert into registos_nao_processados (id_equip, marca_temporal, latitude, longitude)
    values (-2, null, null, null);
    call processarRegistos();

    select count(*) from registos_nao_processados into remaining;

    if (remaining != 0) then
        raise exception '% -> Result NOK', testName;
    end if;
    raise notice '% -> Result OK', testName;
end;
$$;

create or replace procedure testeVistaAlarmes()
    language plpgsql
as
$$
declare
    testName text;
    count    integer;
begin
    testName = 'Vista de alarmes';

    insert into registos_processados (marca_temporal_proc, id_equip, latitude, longitude)
    values (CURRENT_TIMESTAMP, 1, 11.2, 0);
    -- alarme gerado pelo trigger

    select count(*) from vista_alarmes into count;

    if (count = 0) then
        raise exception '% -> Result NOK', testName;
    end if;
    raise notice '% -> Result OK', testName;
end;
$$;

create or replace procedure testeInserirVistaAlarmes()
    language plpgsql
as
$$
declare
    testName text;
    id       integer;
begin
    testName = 'Inserir sobre vista de alarmes';

    insert into registos_nao_processados (id_equip, marca_temporal, latitude, longitude)
    values (1, CURRENT_TIMESTAMP, 1, 0)
    returning id_reg into id;

    insert into vista_alarmes (id_reg)
    values (id);
end;
$$;

create or replace procedure testeRemoverRegistosInvalidos()
    language plpgsql
as
$$
declare
    testName text;
    bef      integer;
    aft      integer;
begin
    testName = 'Remover registos inválidos';

    call removerRegistosInvalidos();

    insert into registos_invalidos (equip_id, marca_temporal_inval, latitude, longitude)
    values (null, CURRENT_TIMESTAMP, null, null);
    insert into registos_invalidos (equip_id, marca_temporal_inval, latitude, longitude)
    values (null, CURRENT_TIMESTAMP - interval '16' day, null, null);
    insert into registos_invalidos (equip_id, marca_temporal_inval, latitude, longitude)
    values (null, CURRENT_TIMESTAMP - interval '2' month, null, null);

    select count(*) from registos_invalidos into bef;

    -- deve remover 2 registos
    call removerRegistosInvalidos();

    select count(*) from registos_invalidos into aft;

    if (bef - aft != 2) then
        raise exception '% -> Result NOK', testName;
    end if;
    raise notice '% -> Result OK', testName;
end;
$$;

create or replace procedure testeRemoverClienteVista()
    language plpgsql
as
$$
declare
    testName  text;
    remaining integer;
begin
    testName = 'Remover cliente através da vista';
    delete from vista_clientes;
    select count(*) from vista_clientes into remaining;

    if (remaining != 0) then
        raise exception '% -> Result NOK', testName;
    end if;
    raise notice '% -> Result OK', testName;
end;
$$;

-- d)
start transaction isolation level repeatable read;
call testeInserirClienteComSucesso();
rollback;

start transaction isolation level repeatable read;
call testesInserirClienteComErro();
rollback;

start transaction isolation level repeatable read;
call testeAtualizarClienteComSucesso();
rollback;

start transaction isolation level repeatable read;
call testeAtualizarClienteComErro();
rollback;

start transaction isolation level read committed;
call testeRemoverClienteComSucesso();
rollback;

start transaction isolation level read committed;
call testeRemoverClienteComErro();
rollback;

-- e) g)
start transaction isolation level serializable;
call testeContarAlarmes();
rollback;

-- f)
start transaction isolation level serializable;
call testeTratamentoRegistos();
rollback;

-- i)
start transaction isolation level serializable;
call testeVistaAlarmes();
rollback;

-- j)
start transaction isolation level repeatable read;
call testeInserirVistaAlarmes();
rollback;

-- k)
start transaction isolation level serializable;
call testeRemoverRegistosInvalidos();
rollback;

-- l)
start transaction isolation level repeatable read;
call testeRemoverClienteVista();
rollback;
