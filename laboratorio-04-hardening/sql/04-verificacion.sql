-- Camacho Castañeda Angélica María 4-1
-- 21/10/2026

-- Actividad 15 — Revisar TLS
SHOW ssl;
SHOW ssl_min_protocol_version;
SELECT pid, ssl, version, cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();