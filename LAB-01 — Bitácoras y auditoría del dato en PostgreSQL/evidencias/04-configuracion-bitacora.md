# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 

### Actividad 4 — Configurar la bitácora

**¿Por qué el proceso que registra el cambio es el principal y no la sesión?**
ALTER SYSTEM solo escribe el valor en postgresql.auto.conf, pero no cambia nada en el servidor en ese momento. El cambio se aplica cuando el proceso principal (postmaster) recibe la orden de recarga con pg_reload_conf(). Ese proceso es el que lee los archivos de configuración, aplica los valores nuevos y los propaga a los procesos hijos. Por eso es él quien escribe la línea parameter ... changed to ..., y por eso esa línea sale sin usuario ni base de datos: no pertenece a ninguna sesión.

**¿Qué pasaría si alguien ejecutara ALTER SYSTEM SET log_statement = 'none'? ¿Quedaría rastro?**
Sí quedaría rastro, pero depende de cómo estuviera configurada la bitácora en ese momento, por que con log_statement en ddl o all, la sentencia ALTER SYSTEM quedaría registrada con usuario, base de datos y cliente, porque todavía rige el valor anterior al ejecutarse. Después de la recarga, el proceso principal registraría parameter "log_statement" changed to "none", pero sin decir quién lo hizo. Si log_statement ya estuviera en none, solo quedaría esa línea del proceso principal, sin autor.

**¿Por qué no se recomienda editar postgresql.auto.conf a mano?**
Es un archivo que PostgreSQL administra por sí mismo, y ALTER SYSTEM lo reescribe completo, así que los cambios manuales se pueden perder. También, un error de sintaxis o un valor inválido puede hacer que PostgreSQL ignore la configuración o no arranque. ALTER SYSTEM valida el nombre y el valor del parámetro, y la edición manual no. Editar el archivo no deja ninguna sentencia en la bitácora ni identifica a quien lo hizo, porque se hace desde el sistema operativo. Solo quedaría el mensaje del proceso principal al recargar.