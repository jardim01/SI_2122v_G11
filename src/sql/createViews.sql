create or replace view vista_clientes as
select nif, nome, morada, telefone, ref_cliente, tipo
from clientes
where removido = '0';

-- i)
create or replace view vista_alarmes as
select alarmes.id_reg, alarmes.matricula, nome_cond_atual as nome_condutor, latitude, longitude, marca_temporal
from (alarmes join registos_processados on (alarmes.id_reg = registos_processados.id_reg))
         join veiculos on (veiculos.id_equip = registos_processados.id_equip);
