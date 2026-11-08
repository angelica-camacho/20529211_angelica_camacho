# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 
**¿Por qué se ejecuta REVOKE ALL ON FUNCTION ... FROM PUBLIC si el disparador seguirá funcionando para app_ventas?**
Porque por defecto PostgreSQL le da EXECUTE a PUBLIC sobre cualquier función nueva, y eso significa que cualquier rol podría invocarla. Al ser SECURITY DEFINER, la función corre con los privilegios de su dueño, así que dejarla abierta es un riesgo. Con el REVOKE aplico el mínimo privilegio. El disparador sigue funcionando para app_ventas porque PostgreSQL solo exige el permiso EXECUTE sobre la función de disparador a quien crea el disparador, no a quien ejecuta el INSERT, UPDATE o DELETE que lo activa.

**¿Qué pasaría si la función no fuera SECURITY DEFINER? Hipótesis para la Actividad 12.**
Mi hipótesis es que la función correría con los privilegios de quien hace el cambio (por ejemplo app_ventas), y como ese rol no tiene permiso de INSERT sobre auditoria.cambios_clientes ni acceso al esquema auditoria, el INSERT de la auditoría fallaría con permission denied. Como el disparador es AFTER y corre dentro de la misma transacción, el error cancelaría también el UPDATE original, y la aplicación ya no podría modificar clientes.
La salida fácil sería darle a app_ventas permiso de escritura sobre la tabla de auditoría, pero eso permitiría que alterara o falsificara la evidencia. Con SECURITY DEFINER, solo el dueño de la función escribe en esa tabla. El usuario real queda registrado igual en usuario_sesion (session_user), porque no cambia aunque la función se ejecute como su dueño.

**Consulta dba.bitacora. ¿Quedó registrada la creación del esquema, la tabla, la función y el disparador? ¿Por qué?**
Sí, deberían aparecer, siempre que log_statement estuviera en 'ddl' o 'mod' cuando los ejecuté. Los cuatro son sentencias DDL (CREATE SCHEMA, CREATE TABLE, CREATE FUNCTION y CREATE TRIGGER), y ese nivel registra toda sentencia que modifica la estructura.