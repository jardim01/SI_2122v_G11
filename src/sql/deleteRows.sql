delete from clientes_institucionais;
delete from clientes_particulares;
delete from registos_invalidos;
delete from alarmes;
delete from registos_processados;
delete from registos_nao_processados;
delete from zonas_verdes;
delete from veiculos;
delete from equipamentos;
delete from estados_equipamentos;
delete from frotas_veiculos;
delete from clientes;

alter sequence if exists equipamentos_id_seq restart with 1;
alter sequence if exists frotas_veiculos_id_seq restart with 1;
alter sequence if exists registos_nao_processados_id_reg_seq restart with 1;
alter sequence if exists registos_processados_id_reg_seq restart with 1;
alter sequence if exists zonas_verdes_id_zona_seq restart with 1;