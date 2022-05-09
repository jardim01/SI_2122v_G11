-- e)
create or replace function contarAlarmes(ano integer, matricula varchar(8)) returns integer
    language plpgsql
as
$$
declare
    count integer;
begin
    if (matricula is null) then
        select count(*)
        into count
        from alarmes
        where extract(year from marca_temporal) = ano;
    else
        select count(*)
        into count
        from alarmes
        where alarmes.matricula = $2
          and extract(year from marca_temporal) = ano;
    end if;
    return count;
end;
$$;

create or replace function obterCliente(idFrota integer) returns record
    language plpgsql
as
$$
declare
    r record;
begin
    select *
    into r
    from clientes
    where nif = (select nif_cliente from frotas_veiculos where id = idFrota);

    return r;
end;
$$;

create or replace function obterFrotaCliente(nif integer) returns record
    language plpgsql
as
$$
declare
    r record;
begin
    select *
    into r
    from frotas_veiculos
    where nif_cliente = nif;

    return r;
end;
$$;

-- Retorna o número de veículos de um cliente
create or replace function contarVeiculos(nif integer) returns integer
    language plpgsql
as
$$
declare
    idFrotaCliente integer;
begin
    idFrotaCliente = (select id from frotas_veiculos where nif_cliente = nif);
    if (idFrotaCliente is null) then
        return 0;
    end if;

    return (select count(*) from veiculos where id_frota = idFrotaCliente);
end;
$$;

create or replace function obterMatricula(id_equip integer) returns varchar(8)
    language plpgsql
as
$$
declare
    m varchar(8);
begin
    select matricula
    into m
    from veiculos
    where veiculos.id_equip = $1;
    return m;
end;
$$;

create or replace function obterNomeCondutorAtual(matr varchar(8)) returns varchar(60)
    language plpgsql
as
$$
declare
    nome varchar(60);
begin
    select nome_cond_atual
    into nome
    from veiculos
    where veiculos.matricula = matr;
    return nome;
end;
$$;

-- verifica se um veículo se encontra dentro de uma zona verde
create or replace function zonaVerdeValida(zLat decimal(7, 5), zLon decimal(8, 5), zRaio integer, lat decimal(7, 5),
                                           lon decimal(8, 5)) returns boolean
    language plpgsql
as
$$
begin
    return mod(cast(lat as integer), 2) = 0;
end;
$$;

-- verifica se um veículo se encontra dentro de alguma zona verde
-- se não existirem zonas verdes retorna true
create or replace function dentroZonaVerde(lat decimal(7, 5), lon decimal(8, 5), _matricula varchar(8)) returns boolean
    language plpgsql
as
$$
declare
    z record;
    existemZonas boolean;
begin
    for z in select * from zonas_verdes where matricula = _matricula
        loop
            existemZonas = true;
            if (zonaVerdeValida(z.latitude, z.longitude, z.raio, lat, lon)) then
                return true;
            end if;
        end loop;
    return not existemZonas;
end;
$$;

create or replace function registoValido(reg record) returns boolean
    language plpgsql
as
$$
begin
    if (reg.marca_temporal is null or reg.latitude is null or reg.longitude is null) then
        return false;
    end if;
    return exists(select 1 from veiculos where id_equip = reg.id_equip);
end;
$$;