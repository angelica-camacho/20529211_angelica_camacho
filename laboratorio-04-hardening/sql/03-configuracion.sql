-- Camacho Castañeda Angélica María 4-1
-- 21/10/2026

-- Actividad 10 — Revisar extensiones
SELECT
    extname,
    extversion
FROM pg_extension
ORDER BY extname;
-- Actividad 11 — Revisar configuración relacionada con conexiones
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;
-- Actividad 12 - Verificar permisos del sistema operativo
SHOW data_directory;
SHOW config_file;
SHOW hba_file;