-- k)
create
    or replace procedure remover_registos_invalidos()
    language plpgsql
as
$$
begin
    delete
    from registos_invalidos
    where marca_temporal_inval + INTERVAL '15' day >= CURRENT_TIMESTAMP;
end;
$$;

-- l)

create
    or replace function apagar_cliente() returns trigger
    language plpgsql
as
$$
begin
    if not exists (select 1 from clientes where nif = old.nif) then
        raise exception '';
    end if;
    update clientes
    set removed_cliente = '1'
    where nif = old.nif;
end;
$$;

create trigger desativar_cliente
    instead of
        delete
    on view_clientes
    for each row
execute function apagar_cliente();