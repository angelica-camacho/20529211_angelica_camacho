-- Camacho Castañeda Angélica María 4-1
-- 21/10/2026
-- 14. Actividad 8 — Revisar usuarios y privilegios
-- MOSTRAR ROLES Y PRIVILEGIOS
SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;