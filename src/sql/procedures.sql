-- k)
create or replace procedure remover_registos_invalidos()
    language plpgsql
as
$$
begin
    delete
    from registos_invalidos
    where marca_temporal_inval + INTERVAL '15' day >= CURRENT_TIMESTAMP;
end;
$$;
