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


