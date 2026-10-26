-- Camacho Castañeda Angélica María 4-1
-- 21/10/2026

-- Actividad 1 — Identificar la superficie de ataque
-- VERIFICAR VERSIÓN DE POSTGRESQL
SELECT version();
-- MOSTRAR MÁS CONFIGURACIONES
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;
-- OBTENER INFORMACION SOBRE CONEXIONES
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;
--Actividad 2 — Identificar los archivos de configuración 
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
-- MOSTRAR MÁS CONFIGURACIONES
SHOW data_directory;
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;
-- Actividad 3 — Revisar listen_addresses
SHOW listen_addresses;
-- Actividad 4 — Revisar pg_hba.conf
SELECT
    type,
    database,
    user_name,
    address,
    auth_method
FROM pg_hba_file_rules;
-- 13. Actividad 7 — Revisar autenticación
SHOW password_encryption;
