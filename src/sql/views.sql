create or replace view view_clientes as
select nif, nome, morada, telefone, ref_cliente
from clientes
where removed_cliente = '0';

-- i)
create or replace view view_alarmes as
select reg_id, matricula, nome_cond_atual as nome_condutor, latitude, longitude, marca_temporal
from (alarmes join registos_processados on (reg_fk = reg_id))
         join veiculos on (equip_fk = equip_id);
