-- # LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
-- Gestión de seguridad y desempeño de bases de datos_
-- Camacho Castañeda Angélica María 4-1

--Actividad 3 — El incidente sin bitácora
SELECT linea FROM dba.bitacora
WHERE linea ILIKE '%update%' OR linea LIKE '%app_ventas%';
-- 10. Actividad 4 — Configurar la bitácora
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix = '%m [%p] user=%u db=%d app=%a client=%h ';
ALTER SYSTEM SET log_statement = 'ddl';
SELECT pg_reload_conf();
-- Verificar el origen de los valores con una consulta nueva
SELECT name, setting, source, sourcefile
FROM pg_settings
WHERE name IN ('log_connections', 'log_line_prefix', 'log_statement');
-- Revisar la líneas de la bitácora
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 6;