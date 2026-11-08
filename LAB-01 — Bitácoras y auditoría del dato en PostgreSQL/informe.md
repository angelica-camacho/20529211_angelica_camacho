# LAB-01 — Bitácoras y auditoría del dato en postgre
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 
## INFORME

# Informe LAB-01: Bitácoras y auditoría del dato en PostgreSQL

## 1. Despliegue y situación inicial

Desplegué el servidor postgreSQL de forma local en mi computadora, con la base comercial, los roles app_ventas y soporte_ana de la unidad II y las herramientas pgAdmin y psql para administrarlo. Como el recolector de bitácora (logging_collector) ya estaba en on, postgreSQL escribía los archivos él mismo en la carpeta log del directorio de datos. Para consultarlos con SQL creé la vista dba.bitacora, que lee el archivo actual. 
Por defecto, la configuración registraba casi nada ya que log_connections estaba apagado, log_disconnections en off, log_statement en none y log_line_prefix solo tenía la marca de tiempo (%t). Con eso no podía responder a Dirección quién cambió el RFC de un cliente ni qué valor tenía antes. El UPDATE que ejecuté con app_ventas respondió UPDATE 1, pero no dejó ninguna línea en la bitácora. Lo único que apareció de app_ventas fueron errores de autenticación fallida, sin IP, y mi propia consulta fallida. Tampoco había forma de distinguir a app_ventas de soporte_ana o de cualquier otro usuario.

## 2. Configuración aplicada

Apliqué los parámetros con ALTER SYSTEM y los activé con SELECT pg_reload_conf();, sin reiniciar el servidor, porque todos se pueden cambiar con recarga. Activé log_connections y log_disconnections para saber quién se conecta, desde dónde y cuánto dura la sesión. Cambié log_line_prefix a '%m [%p] user=%u db=%d app=%a client=%h ', para que cada línea incluya la hora con milisegundos, el PID, el usuario, la base de datos, la aplicación y el cliente. Con el prefijo anterior no se podía atribuir ninguna acción.

Para log_statement empecé con 'ddl', que registra los cambios de estructura y de privilegios (CREATE, ALTER, DROP, GRANT y REVOKE), y después lo subí a 'mod' para registrar también los INSERT, UPDATE y DELETE. Elegí 'mod' y no 'all' porque registrar todas las consultas aumenta el volumen de la bitácora y copia más datos sensibles. Ese parámetro solo necesita recarga, porque cada sesión lo consulta para decidir si registra una sentencia. En cambio, logging_collector sí requiere reinicio, porque arranca un proceso en segundo plano que se conecta a la salida del servidor al iniciar. En mi caso ya estaba activo, por lo que no tuve que reiniciar.

## 3. Eventos observados

Una autenticación fallida aparece como FATAL con user=app_ventas db=comercial client=127.0.0.1 y la contraseña incorrecta. Muestra que alguien se presentó como app_ventas desde mi computadora y no logró entrar, pero no prueba que fuera la aplicación de ventas, porque el nombre de usuario lo escribe el cliente. Lleva app=[desconocido] porque la conexión terminó antes de que se aplicara el nombre de la aplicación.

Una conexión exitosa genera varias líneas con el mismo PID: conexión recibida, conexión autenticada (con el método scram-sha-256) y conexión autorizada. La desconexión registra la duración de la sesión y ya trae app=app-ventas-web, porque el nombre se aplicó al terminar la autenticación.

Un cambio de configuración lo registra el proceso principal del servidor con parameter ... changed to ..., sin usuario ni base de datos, porque no pertenece a ninguna sesión. Un cambio de privilegios o estructura aparece como sentencia con user=postgres, por ejemplo REVOKE UPDATE ON clientes FROM soporte_ana, GRANT UPDATE ON clientes TO app_ventas o ALTER TABLE clientes ADD COLUMN segmento. Esas líneas muestran qué se cambió, quién lo hizo y desde dónde.

Un error de autorización se ve cuando app_ventas intentó borrar la tabla de auditoría y desactivar el disparador: salió permission denied for schema auditoria y must be owner of table clientes. La sesión ya había entrado, pero no tenía permiso para esa acción. Por último, una modificación de datos aparece con log_statement = 'mod' como statement: UPDATE clientes SET ..., con usuario, aplicación y cliente.

4. Auditoría del dato

Como la bitácora no guarda el valor anterior, diseñé la tabla auditoria.cambios_clientes con el momento (TIMESTAMPTZ, para conservar la zona horaria), el usuario de sesión, el usuario efectivo, la aplicación, la IP, la operación, el id del cliente y los valores antes y después. Guardé la fila completa en JSONB para poder revertir el cambio y para que la tabla no dependa de la estructura de clientes.

Un disparador llama a la función auditoria. La función registrar_cambio_cliente(), que es SECURITY DEFINER: se ejecuta con los privilegios de su dueño, así que app_ventas no necesita permiso sobre la tabla de auditoría y no puede falsificarla. El usuario real queda en usuario_sesion (session_user), que no cambia, y usuario_efectivo (current_user) muestra el rol con el que corrió la función.

En el incidente auditado, la tabla registró (id_evento = 1) que app_ventas, desde 127.0.0.1 y con app-ventas-web, cambió el RFC del cliente 3 de GAMA780912XYZ a GAMA780912ZZZ, y con valores_antes pude escribir el UPDATE que lo restaura.

## 5. Limitaciones

Las lecturas no quedan registradas son cuando soporte_ana consultó el RFC del cliente 3 no apareció nada, porque no hay disparador para SELECT y 'mod' no registra consultas. Para registrarlas haría falta 'all', una función que registre el acceso o pgaudit, y todas tienen un costo. 
El volumen también es un problema por que un UPDATE sin WHERE en un millón de filas genera una línea en la bitácora, pero un millón de filas en la auditoría, cada una con dos copias en JSONB.
Por último, un administrador con control total puede evitar la auditoría. Desde postgres desactivé el disparador, cambié el RFC a GAMA780912GHI y lo reactivé, la auditoría quedó en tres eventos y solo la bitácora lo registró, aunque la controla el mismo administrador. Hace falta enviarla a un sistema externo a cargo de otra área.

## 6. Riesgos de la bitácora

El principal riesgo son los secretos expuestos son el CREATE ROLE ... PASSWORD quedó en la bitácora con la contraseña en texto plano. Por eso asigné las contraseñas con \password y exporté la bitácora con la contraseña sustituida por <REDACTED>. La bitácora original sigue teniendo el secreto y debe protegerse.
Otro riesgo es, el acceso de terceros, ya que leer la bitácora desde SQL exige privilegios altos, y tanto ella como la auditoría contienen RFC, por lo que deben clasificarse igual que clientes y leerlas solo un rol de auditoría con SELECT.

## 7. Cronología y conclusión

La cronología del 6 de noviembre de 2026 muestra los cambios de privilegios y estructura de postgres (22:03 a 22:04), el intento fallido de borrar a soporte_ana (22:26), el cambio de RFC de app_ventas registrado por el disparador (22:59) y el cambio de postgres con el disparador desactivado, que solo quedó en la bitácora.

Con la configuración inicial no podía demostrar quién cambió un dato sensible ni su valor anterior. Con la final sí puedo hacerlo para los cambios de roles sin control del servidor, como app_ventas: la auditoría guarda usuario, IP, aplicación y los valores antes y después. Eso identifica un rol y una dirección, no una persona, y la aplicación es lo más fácil de falsificar.