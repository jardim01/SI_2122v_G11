create or replace function obterMatricula(id_equip text) returns varchar(8)
    language plpgsql
as
$$
declare
    m text;
begin
    select matricula
    into m
    from veiculos
    where veiculos.equip_id = id_equip;
    return m;
end;
$$;

create or replace function obterNomeCondutorAtual(matr varchar(8)) returns text
    language plpgsql
as
$$
declare
    nome text;
begin
    select nome_cond_atual
    into nome
    from veiculos
    where veiculos.matricula = matr;
    return nome;
end;
$$;

-- verifica se um veículo se encontra dentro de uma zona verde
create or replace function zonaVerdeValida(lat decimal(7, 5), lon decimal(8, 5), id_zona integer) returns boolean
    language plpgsql
as
$$
begin
    return mod(cast(lat as integer), 2) = 0;
end;
$$;

-- verifica se um veículo se encontra dentro de alguma zona verde
create or replace function dentroZonaVerde(lat decimal(7, 5), lon decimal(8, 5), matricula varchar(8)) returns boolean
    language plpgsql
as
$$
declare
    r record;
begin
    for r in select zona_id from zonas_verdes where matricula_fk = matricula
        loop
            if (zonaVerdeValida(lat, lon, r.zona_id)) then
                return true;
            end if;
        end loop;
    return false;
end;
$$;
