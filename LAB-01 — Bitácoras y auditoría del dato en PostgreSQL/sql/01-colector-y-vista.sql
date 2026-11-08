-- # LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
-- Gestión de seguridad y desempeño de bases de datos_
-- Camacho Castañeda Angélica María 4-1

-- Actividad 1 — Revisar la configuración de registro por defecto
SELECT name, setting, source
FROM pg_settings
WHERE name IN ('log_destination', 'logging_collector', 'log_directory', 'log_filename',
               'log_connections', 'log_disconnections', 'log_line_prefix',
               'log_statement', 'log_min_error_statement', 'log_timezone')
ORDER BY name;
-- 8. Actividad 2 — Que el servidor administre su propia bitácora
-- Activar el colector
ALTER SYSTEM SET logging_collector = on;
SELECT name, setting, pending_restart FROM pg_settings WHERE name = 'logging_collector';
SELECT name, setting, source FROM pg_settings WHERE name = 'logging_collector';
SELECT pg_current_logfile();
SELECT linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n') AS linea;
-- Crear vista 
CREATE SCHEMA dba;
REVOKE ALL ON SCHEMA dba FROM PUBLIC;
CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
     WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';