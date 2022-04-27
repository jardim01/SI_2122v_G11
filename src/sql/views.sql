-- i)
create view view_alarmes as
select matricula, nome_cond_atual as nome_condutor, latitude, longitude, marca_temporal
from (alarmes join registos_processados on (reg_fk = reg_id))
         join veiculos on (equip_fk = equip_id);
