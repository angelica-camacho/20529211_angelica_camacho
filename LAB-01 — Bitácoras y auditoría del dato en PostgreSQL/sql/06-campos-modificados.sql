-- # LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
-- Gestión de seguridad y desempeño de bases de datos_
-- Camacho Castañeda Angélica María 4-1
-- Comparar cambios campo por campo
SELECT a.id_evento, a.momento, a.usuario_sesion, a.ip_cliente,
       d.key                     AS campo,
       a.valores_antes ->> d.key AS antes,
       d.value #>> '{}'          AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL jsonb_each(a.valores_despues) d
WHERE a.operacion = 'UPDATE'
  AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY a.id_evento;