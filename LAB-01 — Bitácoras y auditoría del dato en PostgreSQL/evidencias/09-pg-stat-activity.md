# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 

### Actividad 9 — Sesiones activas con pg_stat_activity

**¿Qué columna permite relacionar una sesión con sus líneas de bitácora?**
La columna pid. En pg_stat_activity es el número del proceso que atiende la sesión, y en la bitácora aparece entre corchetes (por ejemplo [14612]) porque log_line_prefix incluye %p. Con ese número busco en dba.bitacora todas las líneas de esa sesión: la conexión, la autenticación y la desconexión.

**Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?**
La bitácora. pg_stat_activity solo muestra las sesiones que están activas en ese momento, así que en cuanto termina el reporte la fila desaparece. En cambio, la bitácora conserva las líneas de conexión autorizada y de desconexión, con el usuario (soporte_ana), la aplicación (reporte-mensual), el cliente y la duración de la sesión. El SELECT pg_sleep(90) no queda registrado porque log_statement = 'mod' no incluye los SELECT, pero la sesión sí deja rastro.

**¿Por qué client_addr aparece vacío en la sesión del administrador?**
Porque el administrador se conectó de forma local, por un socket del sistema y no por la red. Esas conexiones no tienen dirección IP, así que client_addr queda vacío (NULL) y en la bitácora se ve como client=[local].
En mi computadora con Windows aparece ::1, porque pgAdmin se conecta por TCP a localhost (la dirección de mi propio computadora).