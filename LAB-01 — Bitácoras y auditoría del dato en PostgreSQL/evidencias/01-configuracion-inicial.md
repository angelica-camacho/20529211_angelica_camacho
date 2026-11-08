# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

## Actividad 1 — Revisar la configuración de registro por defecto
**¿Con esta configuración se registra quién se conecta?**
No. log_connections está vacío (apagado por defecto) y log_disconnections está en off, así que no queda registro de quién se conecta ni cuándo se desconecta.

**¿Se registran las sentencias UPDATE?**
No. log_statement está en none, por lo que ninguna sentencia se registra solo por ejecutarse. La única excepción es que un UPDATE falle: como log_min_error_statement está en error, en ese caso se registraría el error junto con la sentencia que lo causó. Los UPDATE exitosos no dejan rastro.

**¿La línea de bitácora incluye el usuario o la dirección IP del cliente?**
No. log_line_prefix es %t, que solo agrega la marca de tiempo. Para registrar usuario, IP y base de datos habría que agregar %u, %h y %d al prefijo, por ejemplo '%t [%p] %u@%d %h '.

**¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?**
Se registran en America/Chihuahua (log_timezone). Importa porque al reconstruir una cronología hay que cruzar la bitácora de PostgreSQL con otras fuentes (logs del sistema operativo, de la aplicación o de otros servidores). Si esas fuentes usan otra zona horaria, como UTC, los eventos quedan desfasados y puedo concluir mal qué ocurrió primero o atribuir una acción a la persona equivocada. Por eso conviene documentar la zona horaria de cada fuente o usar la misma en todas.

**Con logging_collector = off, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?**
Con el colector apagado, lo decide el mecanismo con que se desplegó el servidor. PostgreSQL solo escribe sus mensajes a stderr y no administra archivos, directorio ni rotación. El destino final depende de quien lanzó el proceso: systemd lo envía a journald, Docker a docker logs, y un script con pg_ctl -l a un archivo específico.
