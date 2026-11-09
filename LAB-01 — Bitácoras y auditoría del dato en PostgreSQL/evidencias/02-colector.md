# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 
## Actividad 2 — Que el servidor administre su propia bitácora

**¿Por qué logging_collector requiere reinicio y log_statement solo recarga?**
logging_collector inicia un proceso en segundo plano (el logger) y redirige hacia él la salida stderr del servidor. Esa conexión se establece una sola vez, cuando inicia el proceso principal (postmaster) y antes de crear los procesos hijos, que la heredan. Por eso no puede cambiarse con el servidor en marcha y requiere reinicio. En cambio, log_statement es un valor que cada sesión consulta para decidir si registra una sentencia. No altera la estructura del servidor, así que basta con ejecutar SELECT pg_reload_conf(); para que los procesos lean el nuevo valor.

**¿Qué ventaja tiene que la bitácora se lea con SQL y no con una herramienta del sistema operativo o del contenedor? ¿Qué riesgo introduce?**
La ventaja es que puedo consultar la bitácora desde la misma conexión a la base de datos, sin necesidad de acceso por SSH, escritorio remoto o docker logs al servidor. Con SQL puedo filtrar, agrupar y ordenar los eventos, cruzarlos con otras tablas y cargarlos en una tabla como dba.bitacora, donde controlo quién los ve con GRANT y REVOKE. Además, funciona igual si el servidor está en un equipo, una máquina virtual o un contenedor.

El riesgo es que leer archivos del servidor desde SQL exige privilegios muy altos (superusuario o el rol pg_read_server_files), y con ellos se puede leer cualquier archivo accesible al usuario del servidor, no solo la bitácora. También la bitácora puede contener datos sensibles (usuarios, IP, texto de sentencias con valores), y al copiarla a una tabla quedan expuestos a quien tenga permisos sobre ella. Si alguien puede modificar o borrar filas de esa tabla, la evidencia deja de ser confiable. Por último, si la base de datos se cae o se compromete, la bitácora se ve afectada con ella.

**¿Quién debería poder consultar dba.bitacora?**
Solo un rol dedicado de auditoría o administración, con permiso únicamente de SELECT. No daría acceso a roles de aplicación ni de usuarios finales como app_ventas o soporte_ana, porque la bitácora contiene información sensible y podrían usarla para ver la actividad de otros. Tampoco daría permisos de INSERT, UPDATE o DELETE a nadie, salvo al proceso o rol que carga los datos, para proteger la integridad de la evidencia.
