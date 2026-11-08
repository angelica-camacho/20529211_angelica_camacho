# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**
## Preguntas de reflexión

## 1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?
Porque la bitácora y el disparador solo registran lo que ocurre después de activarlos, no hacia atrás. En la práctica, el primer cambio de RFC se ejecutó cuando log_statement estaba en none y todavía no existía el disparador, así que no quedó ni la sentencia, ni el usuario, ni el valor anterior. Configurar la auditoría después no recupera ese evento, y por eso tiene que estar lista antes del incidente.

## 2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?
Porque con el recolector activado (logging_collector), postgreSQL decide el directorio, el nombre de los archivos y la rotación, y se comporta igual sin importar cómo se instaló el servidor. Yo puedo leerlos con SQL y controlar quién los ve. Si la bitácora depende del mecanismo de despliegue (systemd, Docker o un script con pg_ctl), el destino y la retención dependen de quien lanzó el proceso, y pueden perderse, por ejemplo, al borrar un contenedor.

## 3. ¿Por qué el prefijo de línea es tan importante como el nivel de log_statement?
Porque el nivel decide qué se registra, pero el prefijo decide si esa línea sirve para atribuirla. Con el prefijo original (solo la hora), un UPDATE registrado diría qué pasó y cuándo, pero no quién lo hizo, desde dónde ni con qué aplicación. Con el prefijo ampliado (usuario, base, aplicación, cliente y PID) puedo atribuir la acción y unir todas las líneas de una misma sesión.

## 4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?
Registrar la sentencia guarda el texto del UPDATE con el valor nuevo, pero no dice qué había antes, cuántas filas se modificaron ni si la transacción se confirmó, y un UPDATE sin WHERE es una sola línea. Registrar el cambio en el dato, con el disparador, guarda la fila completa antes y después por cada fila afectada, junto con el usuario y la IP. Eso me permite revertir con certeza, aunque cuesta más espacio y escritura.

## 5. ¿Qué evidencia ofrece pg_stat_activity que no ofrece la bitácora, y viceversa?
pg_stat_activity muestra lo que está pasando ahora: las sesiones abiertas, su estado, la consulta en ejecución y desde cuándo, como cuando vi la sesión de reporte-mensual con pg_sleep(90). Pero no guarda historial: cuando la sesión termina, la fila desaparece. La bitácora conserva el historial de conexiones, desconexiones con su duración, errores y sentencias según el nivel configurado, pero no me deja ver el estado actual de una sesión y solo registra lo que se configuró.

## 6. Si el administrador puede cambiar log_statement a none y desactivar el disparador, ¿quién audita al administrador?
Dentro del propio servidor, nadie. En la Actividad 14 desactivé el disparador desde postgres, cambié el RFC y lo reactivé, y solo la bitácora lo registró, que controla el mismo administrador. Hace falta un control externo: enviar la bitácora a un sistema administrado por otra área, separar funciones para que quien opera la base no custodie la evidencia, exigir aprobación para cambiar la auditoría y revisar periódicamente que la bitácora y la tabla de auditoría coincidan.