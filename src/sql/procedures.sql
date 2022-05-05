-- h)
create or replace procedure criarVeiculo(matr varchar(8),
                                         nomeCondutor text,
                                         telefoneCondutor integer,
                                         idEquip text,
                                         estadoEquip text,
                                         nifCliente integer,
                                         lat numeric(7, 5),
                                         lon numeric(8, 5),
                                         r integer)
    language plpgsql
as
$$
declare
    frota record;
begin
    frota = obterFrotaCliente(nifCliente);
    if (frota is null) then
        raise exception 'O cliente não tem uma frota de veículos';
    end if;

    insert into veiculos (matricula, nome_cond_atual, telef_cond_actual, equip_id, equip_estado, frota_veic_fk)
    values (matr, nomeCondutor, telefoneCondutor, idEquip, estadoEquip, frota.id);

    if (lat is not null and lon is not null and r is not null) then
        insert into zonas_verdes (latitude, longitude, raio, matricula_fk)
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
    where marca_temporal_inval + INTERVAL '15' day >= CURRENT_TIMESTAMP;
end;
$$;
